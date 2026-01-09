function fish_prompt
  set_color cyan
  set -l curr_dir (string replace -- "$HOME" "~" "$PWD")
  echo -n $curr_dir
  set_color normal
  printf '%s ' (__fish_git_prompt)
  set_color red
   echo -n '| '
  set_color normal
end

function fish_right_prompt
  if set -q CMD_DURATION
    set --local total_seconds (math --scale=0 "$CMD_DURATION / 1000")
    set --local hours (math --scale=0 "$total_seconds / 3600")
    set --local minutes (math --scale=0 "($total_seconds % 3600) / 60")
    set --local seconds (math --scale=0 "$total_seconds % 60")
    set --local duration_str ""
    if test "$hours" -gt 0
      set duration_str "$duration_str""$hours""h "
    end
    if test "$minutes" -gt 0
      set duration_str "$duration_str""$minutes""m "
    end
    if test -n "$duration_str" -o "$total_seconds" -gt 0
      set duration_str "$duration_str""$seconds""s"
    end
    if test "$total_seconds" -gt 5
      echo -n -s (set_color brblack) "$duration_str" (set_color normal)
    end
  end
end
