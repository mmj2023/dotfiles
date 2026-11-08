import { View, div } from "gpui-kit";
import { v_flex } from "gpui-base";
import { closeOverlay, focused, nextCommand, notify, panes, props, run, spaces, theme } from "herdr";

const ACTIONS = {
  "new-tab": ["tab.new", {}],
  "split-right": ["pane.split", { direction: "right" }],
  "split-down": ["pane.split", { direction: "down" }],
  "detach": ["window.close", {}],
  "next-tab": ["tab.next", {}],
  "prev-tab": ["tab.prev", {}],
  "close-pane": ["pane.close", {}],
  "zoom": ["pane.zoom", {}],
  "left": ["pane.go", { direction: "left" }],
  "right": ["pane.go", { direction: "right" }],
  "up": ["pane.go", { direction: "up" }],
  "down": ["pane.go", { direction: "down" }],
  "close-tab": ["tab.close", {}],
  "rename-tab": ["tab.rename", {}],
  "rename-space": ["space.rename", {}],
  "scroll-top": ["terminal.scroll", { to: "top" }],
  "scroll-bottom": ["terminal.scroll", { to: "bottom" }],
  "copy": ["terminal.copy", {}],
  "tab-1": ["tab.select", { index: 1 }],
  "tab-2": ["tab.select", { index: 2 }],
  "tab-3": ["tab.select", { index: 3 }],
  "tab-4": ["tab.select", { index: 4 }],
  "tab-5": ["tab.select", { index: 5 }],
  "tab-6": ["tab.select", { index: 6 }],
  "tab-7": ["tab.select", { index: 7 }],
  "tab-8": ["tab.select", { index: 8 }],
  "tab-9": ["tab.select", { index: 9 }],
  "help": ["app.help", {}],
  "search": ["terminal.search", {}],
  "session-picker": ["app.palette", {}]
};

export default class TmuxPrefix extends View {
  init(_props, cx) {
    this.mode = "prefix";
    cx.spawn(async (cx) => {
      for (;;) {
        const command = await nextCommand();
        const overlay = props().overlay;

        if (command === "cancel") {
          if (overlay) closeOverlay(overlay);
          this.mode = "prefix";
          continue;
        }
        if (command === "session-picker") {
          this.mode = "spaces";
          cx.notify();
          continue;
        }
        if (/^tab-[1-9]$/.test(command)) {
          if (this.mode === "spaces") {
            const space = spaces()[Number(command.slice(4)) - 1];
            if (overlay) closeOverlay(overlay);
            this.mode = "prefix";
            if (space) run("space.select", { id: space.id });
            else notify({ title: "Herdr", body: "No space at that number.", level: "warning" });
          } else {
            if (overlay) closeOverlay(overlay);
            run("tab.select", { index: Number(command.slice(4)) });
          }
          continue;
        }
        if (command === "next-pane" || command === "prev-pane") {
          if (overlay) closeOverlay(overlay);
          const current = focused();
          const list = panes().filter((pane) => pane.tab === current?.tab);
          if (list.length) {
            const index = list.findIndex((pane) => pane.pane === current?.pane);
            const nextIndex = index < 0
              ? (command === "next-pane" ? 0 : list.length - 1)
              : (index + (command === "next-pane" ? 1 : list.length - 1)) % list.length;
            run("pane.focus", { pane: list[nextIndex].pane });
          }
          continue;
        }
        if (command === "reload") {
          if (overlay) closeOverlay(overlay);
          notify({ title: "Herdr", body: "Layouts and keybindings reload automatically." });
          continue;
        }
        if (command.startsWith("resize-")) {
          if (overlay) closeOverlay(overlay);
          notify({ title: "Herdr", body: "Resize panes by dragging their divider; keyboard pane resizing is not available in the app." });
          continue;
        }

        if (overlay) closeOverlay(overlay);
        const action = ACTIONS[command];
        if (action) run(action[0], action[1]);
        else notify({ title: "Tmux prefix", body: `Unsupported action: ${command}`, level: "warning" });
        cx.notify();
      }
    });
  }

  render() {
    const t = theme();
    if (this.mode === "spaces") {
      return v_flex().id("tmux-prefix-spaces").p(16).gap(8).bg(t.popover)
        .text_color(t.foreground).text_size(13)
        .child(div().font_semibold().child("Choose a space · Ctrl+S, T"))
        .children(spaces().slice(0, 9).map((space, index) =>
          div().text_color(t.muted).child(`${index + 1}  ${space.name}`)));
    }
    return v_flex().id("tmux-prefix").p(16).gap(8).bg(t.popover)
      .text_color(t.foreground).text_size(13)
      .child(div().font_semibold().child("Tmux prefix · Ctrl+S"))
      .child(div().text_color(t.muted).child("c tab · % / \" split · arrows focus · x close · z zoom · n / p tabs · [ scrollback · y copy"))
      .child(div().text_color(t.dim).child("Resize panes by dragging the divider."));
  }
}
