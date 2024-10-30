# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
ZSH_THEME="parrot"
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '%n/.zshrc'
autoload -U promptinit && promptinit
autoload -Uz compinit
compinit
# End of lines added by compinstall

PROMPT='%F{red}┌─[%F{green}%n%F{cyan}@%F{white}%m%F{red}]─[%F{green}%c%F{red}]
└──╼ %F{%(#.red.yellow)}$ %F{reset}'