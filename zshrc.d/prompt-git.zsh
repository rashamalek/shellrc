autoload -Uz colors && colors

function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function parse_git_state() {
  local git_state=""

  local git_dir="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $git_dir ] && test -r $git_dir/MERGE_HEAD; then
    git_state="${git_state}%{$fg[red]%}⚡︎%{$reset_color%}"
  fi

  local num_untracked=$(git ls-files --other --exclude-standard 2> /dev/null |wc -l |tr -d ' ')
  if [ "$num_untracked" -gt 0 ]; then
    git_state="${git_state}%{$fg[red]%}…%{$reset_color%}"
  fi

  local num_staged=$(git diff --cached --name-only 2> /dev/null |wc -l |tr -d ' ')
  if [ "$num_staged" -gt 0 ]; then
    git_state=${git_state}%{$fg[yellow]%}✗
  elif ! git diff --quiet 2> /dev/null; then
    git_state="${git_state}%{$fg[red]%}✗%{$reset_color%}"
  fi

  # clean
  if [ -z $git_state ]; then
    git_state="%{$fg[green]%}✔%{$reset_color%}"
  fi

  echo -n $git_state
}

# if inside a git repository, print its branch and state
function git_prompt_info() {
  local git_where=$(parse_git_branch)

  if [ -n "$git_where" ]; then
    echo -n "(%{$fg[green]%}${git_where#refs/heads/}%{$reset_color%}|$(parse_git_state)%{$reset_color%}) "
  fi
}
