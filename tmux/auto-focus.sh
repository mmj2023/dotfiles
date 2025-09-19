#!/user/bin/env bash

# Get the current pane's process
# pane_pid=$(tmux display-message -p "#{pane_pid}")
# program=$(ps -p $pane_pid -o comm=)
# Check if the program is a shell (bash, zsh, etc.)
# if [[ "$program" == "bash" || "$program" == "zsh" || "$program" == "fish" ]]; then
#     # Execute your desired command
#     # tmux display-message "Shell detected in pane. Running your command..."
#     # Example: Run a custom script or command
#     # ./your-command.sh
#     tmux set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d "
#     tmux set-option status-style bg=default
# fi
# is_shell_program="ps -o state= -o comm= -t '#{pane_tty}' \
#     | grep -vqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
# if eval "$is_vim"; then
#     # echo "This pane is running a shell program (e.g., bash, zsh, etc.)."
    # tmux if-shell "! $is_vim" "display-message  'This pane is running a shell program (e.g., bash, zsh, etc.).'"
    # tmux if-shell "! $is_vim" 'set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default] 󰃮 %Y-%m-%d "'
    # tmux if-shell "! $is_vim" 'set status-right "#{#[bg=#{default_fg},bold]░}#[fg=${default_fg},bg=default]  "'
    tmux if-shell "! $is_vim" 'set status-right "#{#[bg=#{default_fg},bold]}#[fg=${default_fg},bg=default]  "'
    tmux if-shell "! $is_vim" 'set-option status-style bg=default'
#     # Run your custom command here
# else
#     tmux display-message "Shell is running"
# fi
