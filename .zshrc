# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# sdkman
export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

setopt HIST_IGNORE_DUPS         # Do not add a command to the history list if it is the same as the previous one.
setopt HIST_EXPIRE_DUPS_FIRST   # When history size limits are reached, expire duplicate entries first.
setopt HIST_SAVE_NO_DUPS        # Do not write a duplicate event to the history file.
setopt HIST_FIND_NO_DUPS        # When searching history, do not display duplicates of a line previously found.
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate.

alias py="python3"
alias nv="nvim"
