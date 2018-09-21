# Setup fzf
# ---------
if [[ ! "$PATH" == */home/PREHCN/wang_j11/.fzf/bin* ]]; then
  export PATH="$PATH:/home/PREHCN/wang_j11/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/PREHCN/wang_j11/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/PREHCN/wang_j11/.fzf/shell/key-bindings.zsh"

