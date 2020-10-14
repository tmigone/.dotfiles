local username='%{$fg[cyan]%}%n%{$reset_color%}'
local hostname='%{$fg[green]%}%m%{$reset_color%}'
local pwd='%{$fg_bold[yellow]%}%~%{$reset_color%}'
local git='$(git_prompt_info)'
PROMPT="${username}@${hostname}:${pwd} ${git}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
