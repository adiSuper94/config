abbr top htop
abbr vim nvim
abbr man batman
abbr cat bat
abbr diff batdiff
abbr g git
abbr lg lazygit
abbr j z
abbr ls eza

fish_add_path $HOME/nutter-tools/bin
fish_add_path /usr/local/go/bin
fish_add_path $HOME/.local/share/fnm
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin

if test -d /opt/homebrew
  /opt/homebrew/bin/brew shellenv | source
end

if status is-interactive
  bash ~/.config/tmux/tat.sh
  setenv EDITOR nvim
  setenv SUDO_EDITOR $HOME/nutter-tools/bin/nvim
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

  fzf --fish | source
  zoxide init fish | source
  fnm env --use-on-cd --shell fish | source
end
