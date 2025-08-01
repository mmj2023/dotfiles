# Define the PREFIX variable
PREFIX ?= /usr
SRC=src

# Default target
all: clean install

prepare:
	mkdir -p $(PREFIX)/share/hypr/
	mkdir -p /etc/sddm.conf.d/

install: clean prepare
	@install -D $(SRC)/hypr-sddm.conf $(PREFIX)/share/hypr/hypr-sddm.conf && echo "[Installed] $(PREFIX)/share/hypr/hypr-sddm.conf"
	@install -D $(SRC)/wayland.conf /etc/sddm.conf.d/wayland.conf && echo "[Installed] /etc/sddm.conf.d/wayland.conf"

clean:
	@rm -rf $(PREFIX)/share/hypr/hypr-sddm.conf && echo "[cleaned] $(PREFIX)/share/hypr/hypr-sddm.conf"
	@rm -rf /etc/sddm.conf.d/wayland.conf && echo "[cleaned] /etc/sddm.conf.d/sddm-hyprland.conf"
	# @rm -rf $(PREFIX)/share/hyde/hypr-sddm.conf && echo "[cleaned] $(PREFIX)/share/hyde/sddm"

.PHONY: all install prepare
