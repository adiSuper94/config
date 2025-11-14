function fish_greeting
  set -l TODO_DIR "$HOME/work/todo/"
  set -l todos (rg "^- \[ \]" --no-line-number --color=never --max-depth 1 --no-filename "$TODO_DIR" | sort -R)
  set -l done (rg "^- \[x\]" --no-line-number --color=never --max-depth 1 --no-filename "$TODO_DIR" | sort -R)
  set_color yellow
  echo "$(count $todos) tasks pending & $(count $done) completed. Here are some to work on:"
  set colors green blue cyan magenta white
  for todo in $todos[1..3]
    set_color $colors[(math (random) % (count $colors) + 1)]
    echo $todo
  end
  set_color normal
end
