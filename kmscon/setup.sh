#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
user_name="$(id -un)"
user_home="$(getent passwd "$user_name" | cut -d: -f6)"
template_source="$repo_root/kmscon/dms/matugen/kmscon-palette.conf"
template_target="$user_home/.config/DankMaterialShell/matugen/templates/kmscon-palette.conf"
dms_config="$user_home/.config/DankMaterialShell/matugen/config.toml"
palette_output="$user_home/.cache/kmscon/matugen-palette.conf"
helper_source="$repo_root/kmscon/system/usr/local/libexec/kmscon-matugen-apply"
rule_template="$repo_root/kmscon/system/etc/polkit-1/rules.d/50-kmscon-matugen.rules.in"
config_template="$repo_root/kmscon/dms/matugen/config.toml.in"

if (( EUID == 0 )); then
  echo "Run this script as your regular user; it uses sudo only for system files." >&2
  exit 1
fi

if [[ -z "$user_home" || "$user_home" != "$HOME" ]]; then
  echo "Could not safely determine the current user's home directory." >&2
  exit 1
fi

if [[ ! "$user_name" =~ ^[a-z_][a-z0-9_-]*\$?$ ]]; then
  echo "Unsupported username for a Polkit rule: $user_name" >&2
  exit 1
fi

for executable in dms kmscon pkexec python3; do
  if ! command -v "$executable" >/dev/null 2>&1; then
    echo "Missing required command: $executable" >&2
    exit 1
  fi
done

run_user_templates="$(dms ipc call settings get runUserMatugenTemplates 2>/dev/null || true)"
if [[ "$run_user_templates" == false ]]; then
  echo "Enable 'Run user Matugen templates' in DMS Settings > Theme & Colors first." >&2
  exit 1
elif [[ "$run_user_templates" != true ]]; then
  echo "DMS is not available to verify its user Matugen template setting; continuing." >&2
fi

backup_path() {
  local path="$1"
  local stamp backup
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="${path}.backup.${stamp}"
  while [[ -e "$backup" ]]; do
    stamp="${stamp}x"
    backup="${path}.backup.${stamp}"
  done
  cp -a -- "$path" "$backup"
  printf 'Backed up %s to %s\n' "$path" "$backup"
}

link_managed_file() {
  local source="$1"
  local target="$2"
  mkdir -p -- "$(dirname -- "$target")"
  if [[ -L "$target" && "$(readlink -- "$target")" == "$source" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    backup_path "$target"
  fi
  ln -sfn -- "$source" "$target"
}

link_managed_file "$template_source" "$template_target"
mkdir -p -- "$user_home/.cache/kmscon"
chmod 700 -- "$user_home/.cache/kmscon"

python3 - "$dms_config" "$config_template" "$template_source" "$palette_output" <<'PY'
import json
import os
import re
import shutil
import sys
import tempfile
import tomllib

config_path, template_path, source_path, output_path = sys.argv[1:]
with open(template_path, encoding="utf-8") as template_file:
    section = template_file.read()
section = section.replace("@TEMPLATE_PATH@", source_path)
section = section.replace("@PALETTE_PATH@", output_path)
tomllib.loads(section)

try:
    with open(config_path, encoding="utf-8") as config_file:
        original = config_file.read()
except FileNotFoundError:
    original = ""
if os.path.islink(config_path):
    raise SystemExit(f"Refusing to overwrite symlinked DMS Matugen config: {config_path}")

if original.strip():
    parsed = tomllib.loads(original)
else:
    parsed = {}

lines = original.splitlines(keepends=True)
header = re.compile(r"^\s*\[templates\.kmscon\]\s*(?:#.*)?(?:\r?\n)?$")
table = re.compile(r"^\s*\[")
matches = [index for index, line in enumerate(lines) if header.match(line)]
if len(matches) > 1:
    raise SystemExit("DMS Matugen config has duplicate [templates.kmscon] sections")

if matches:
    start = matches[0]
    finish = start + 1
    while finish < len(lines) and not table.match(lines[finish]):
        finish += 1
    lines[start:finish] = [section + "\n"]
    merged = "".join(lines)
else:
    merged = original.rstrip()
    if not merged:
        merged = "[config]"
    merged += "\n\n" + section + "\n"

tomllib.loads(merged)
if original == merged:
    print("DMS Matugen config already includes the kmscon template.")
    raise SystemExit(0)

if os.path.exists(config_path):
    stamp = __import__("datetime").datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = f"{config_path}.backup.{stamp}"
    suffix = 0
    while os.path.exists(backup):
        suffix += 1
        backup = f"{config_path}.backup.{stamp}.{suffix}"
    shutil.copy2(config_path, backup)
    print(f"Backed up {config_path} to {backup}")

directory = os.path.dirname(config_path)
os.makedirs(directory, exist_ok=True)
fd, temporary_path = tempfile.mkstemp(prefix=".kmscon-matugen.", dir=directory)
try:
    with os.fdopen(fd, "w", encoding="utf-8") as output:
        output.write(merged)
        output.flush()
        os.fsync(output.fileno())
    os.chmod(temporary_path, 0o644)
    os.replace(temporary_path, config_path)
except Exception:
    try:
        os.unlink(temporary_path)
    except FileNotFoundError:
        pass
    raise
print(f"Configured DMS Matugen integration in {config_path}.")
PY

pkexec install -D -o root -g root -m 0755 \
  "$helper_source" /usr/local/libexec/kmscon-matugen-apply

rule_stage="$(mktemp)"
trap 'rm -f -- "$rule_stage"' EXIT
sed "s/@USER@/$user_name/g" "$rule_template" >"$rule_stage"
pkexec install -D -o root -g root -m 0644 \
  "$rule_stage" /etc/polkit-1/rules.d/50-kmscon-matugen.rules

if [[ -f "$palette_output" ]]; then
  pkexec /usr/local/libexec/kmscon-matugen-apply
else
  echo "DMS will generate the initial kmscon palette on its next Matugen theme refresh."
fi

echo "Kmscon Matugen integration is installed."
