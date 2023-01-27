#!/bin/sh
not_in_tmux() {
  [ -z "$TMUX" ]
}

# switch to existing session
switch_or_create_session(){
  selected_session=$( (tmux list-sessions | sed "s/:.*//"; echo "--new-session--") | fzf)
  if [ "$selected_session" = "--new-session--" ]; then
    #echo "enter name of new session: "
    read selected_session
    if [ -z session_exists session_name ]; then
      tmux new-session -d -s "$selected_session"
      #echo "created detached tmux session : $selected_session"
    else
      echo "session name already exits"
    fi
  fi
  if not_in_tmux; then
    #echo "attach n  -d -t "
    tmux new-session -As "$selected_session"
  else
    #echo "switch"
    tmux switch-client -t "$selected_session"
  fi
}

# switches or attaches to an existing/new session
switch_session() {
  # for first session use defaut name "noname"
  if [ -z "$(tmux list-sessions)" ]; then
    selected_session="noname"
    tmux new-session -s "$selected_session"
  else
    switch_or_create_session
  fi
}


switch_session
