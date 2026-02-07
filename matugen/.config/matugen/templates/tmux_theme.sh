bg="{{dank16.color0.default.hex}}"
active_prefix_bg="{{dank16.color1.default.hex}}"
default_fg="{{dank16.color7.default.hex}}"
session_fg="{{dank16.color6.default.hex}}"
selection_bg="{{dank16.color4.default.hex}}"
selection_fg="{{dank16.color8.default.hex}}"
active_pane_border="{{dank16.color5.default.hex}}"
active_window_fg="{{dank16.color10.default.hex}}"
message_fg="{{dank16.color14.default.hex}}"
status_active_fg="{{dank16.color2.default.hex}}"
status_fg="{{dank16.color6.default.hex}}"

# set -g status-position bottom
set-option -g status-position top

set -g @my_prefix_status '#[fg={{dank16.color2.default.hex}},bold]   '
set -g status-left "#{?client_prefix,#{@my_prefix_status},#[fg={{dank16.color2.default.hex}},bold]  }#[fg={{dank16.color6.default.hex}},bold] #S"

set -g status-right "#{#[bg=#{default_fg},bold]}#[fg=${default_fg},bg=default] "

set -g status-justify centre
set -g status-left-length 200   # default: 10
set -g status-right-length 200  # default: 10
# set-option -g status-style bg=${bg}
set-option -g status-style bg=default
set -g window-status-current-format "#[fg=${active_window_fg},bg=default]  #I:#W"
set -g window-status-format "#[fg=${default_fg},bg=default] #I:#W"
set -g window-status-last-style "fg=${default_fg},bg=default"
set -g message-command-style bg=default,fg=${default_fg}
set -g message-style bg=${message_fg},fg=${default_fg}
set -g mode-style bg=${selection_bg},fg=${selection_fg}
set -g pane-active-border-style "fg=${active_pane_border},bg=default"
set -g pane-border-style 'fg=brightblack,bg=default'
set -g window-status-bell-style "fg=red,nobold"
