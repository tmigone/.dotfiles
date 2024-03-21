local username='%{$fg[cyan]%}%n%{$reset_color%}'
local hostname='%{$fg[green]%}%m%{$reset_color%}'
local pwd='%{$fg_bold[yellow]%}$(prompt_pwd)%{$reset_color%}'
local git='$(git_prompt_info)'
PROMPT="${username}@${hostname}:${pwd}$ "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

function prompt_pwd () {
 local full_pwd=$(pwd)
 if [[ ${#full_pwd} -gt 30 ]]; then
  shrink_path -l
 else
  echo "$full_pwd"
 fi
}
