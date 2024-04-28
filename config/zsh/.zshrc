if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

source $ZDOTDIR/config.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

mkdir -p $ZSH_CACHE
autoload -U compinit && compinit -C -d $ZSH_CACHE/zcompdump

source $ZDOTDIR/plugins.zsh

source $ZDOTDIR/p10k.zsh

source $ZDOTDIR/zstyle.zsh
source $ZDOTDIR/keybinds.zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi
