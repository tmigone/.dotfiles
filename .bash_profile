# macOS Terminal app color styling
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export EDITOR=/usr/bin/nano # default text editor
export BLOCKSIZE=1M # for ls, df, etc

# Aliases
alias ls='ls -GFh'
alias ll='ls -al'
alias h='history'
alias mkdir='mkdir -p'

alias home='cd ~'
alias dev='cd ~/Documents/git/tomasmigone'
alias bal='cd ~/Documents/git/balena'

myip () {
  EN0=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')
  EN1=$(ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}')
  if [ $EN0 ]; then LOCAL_IP=$EN0; else LOCAL_IP=$EN1; fi
  echo 'Private IP: ' $LOCAL_IP
  
  PRIVATE_IP=$(curl -s ifconfig.co)
  echo 'Public IP: ' $PRIVATE_IP
}
