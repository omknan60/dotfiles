# Created by newuser for 5.8
. "$HOME/.cargo/env"

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$PATH:/usr/local/go/bin:/usr/local/zig"
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/config/p10k-robbyrussell.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
