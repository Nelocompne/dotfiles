tmux new -s mango -d
tmux rename-window -t "windows:0" service
tmux split-window -t "windows:service"
tmux split-window -h -t "windows:service.0"
tmux send -t "windows:service.0" "cd ~;./bin" Enter

tmux send -t "windows:service" C-c
tmux kill-session -t windows