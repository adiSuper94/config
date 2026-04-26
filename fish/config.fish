set -l os (uname)

fish_add_path $HOME/nutter-tools/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin

if test -d /opt/homebrew
  /opt/homebrew/bin/brew shellenv | source
end

function tat --description "tmux all the time"
  if test ! -z "$TERM_PROGRAM"; and test "$TERM_PROGRAM" = "WezTerm"
    return
  end
  if test ! -z "$TMUX"
    return
  end
  if test -z (tmux list-sessions 2>/dev/null)
    tmux new-session -As "noname"
  else
  set selected_session (begin
    tmux list-sessions | sed "s/:.*//"
    echo "--new-session--"
    echo "no tmux ;("
  end | fzf)
    if test "$selected_session" = "--new-session--"
      echo "enter name of new session: "
      read -r selected_session
    else if test "$selected_session" = "no tmux ;("
      return
    end
    tmux new-session -As "$selected_session"
  end
end

if status is-interactive
  abbr top btop
  abbr vim nvim
  abbr man batman
  abbr cat bat
  abbr diff batdiff
  abbr g git
  abbr lg lazygit
  abbr j z
  abbr ls eza
  abbr pn pnpm

  setenv XDG_CONFIG_HOME $HOME/.config
  setenv EDITOR nvim
  setenv SUDO_EDITOR nvim
  setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
  setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
  setenv FZF_DEFAULT_OPTS '--height 20% --ansi'

  # Fish git prompt config
  set __fish_git_prompt_showuntrackedfiles 'yes'
  set __fish_git_prompt_showdirtystate 'yes'
  set __fish_git_prompt_showstashstate 'yes'
  set __fish_git_prompt_showcolorhints 'yes'
  set __fish_git_prompt_show_informative_status 'yes' # shows numbers, upstream info, and non-ascii chars
  # forcing ascii chars
  set __fish_git_prompt_char_dirtystate '!'
  set __fish_git_prompt_char_stagedstate '+'
  set __fish_git_prompt_char_untrackedfiles '?'
  set __fish_git_prompt_char_upstream_equal ''
  set __fish_git_prompt_char_stashstate '*'
  set __fish_git_prompt_char_cleanstate ''
  $HOME/.local/bin/mise activate fish | source
  fzf --fish | source
  zoxide init fish | source
  tat
end
