local username='%{$fg[cyan]%}%n%{$reset_color%}'
local hostname='%{$fg[green]%}%m%{$reset_color%}'
local pwd='%{$fg_bold[yellow]%}$(prompt_pwd)%{$reset_color%}'
local git='$(parse_git_dirty)'
PROMPT="${username}@${hostname}:${pwd}${git} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$"

function prompt_pwd () {
 local full_pwd=$(pwd)
 if [[ ${#full_pwd} -gt 30 ]]; then
  shrink_path -l
 else
  echo "$full_pwd"
 fi
}
