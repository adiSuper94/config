#!/bin/bash
not_in_tmux() {
  [ -z "$TMUX" ]
}
session_exists(){
  tmux has-session -t "$1"
}

# switch to existing session
switch_or_create_session(){
  selected_session=$( (tmux list-sessions | sed "s/:.*//"; echo "--new-session--"; echo "no tmux ;(") | fzf)
  if [ "$selected_session" = "--new-session--" ]; then
    echo "enter name of new session: "
    read -r selected_session
  elif [ "$selected_session" = "no tmux ;(" ]; then
    return
  fi
  if not_in_tmux; then
    # echo "attach n  -d -t "
    exec tmux new-session -As "$selected_session"
  else
    tmux switch-client -t "$selected_session"
  fi
}

# switches or attaches to an existing/new session
switch_session() {
  # for first session use defaut name "noname"
  if [ -z "$(tmux list-sessions 2>/dev/null)" ]; then
    selected_session="noname"
    exec tmux -v new-session -As "$selected_session"
  else
    switch_or_create_session
  fi
}

tat() {
  if not_in_tmux; then
      switch_session
  fi
}
. <(fzf --zsh) && tat
