local username='%{$fg[cyan]%}%n%{$reset_color%}'
local hostname='%{$fg[green]%}%m%{$reset_color%}'
local pwd='%{$fg_bold[yellow]%}%1~%{$reset_color%}'
local git='$(parse_git_dirty)'
PROMPT="${username}@${hostname}:${pwd}${git} "

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$"
