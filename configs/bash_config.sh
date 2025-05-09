# prompt
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_k8s_ctx() {
      K8SCTX="$(cat ~/.kube/config 2>/dev/null | grep --color=never "current-context:" | grep -Eo --color=never "dqs|prod")"
      #echo "${K8SCTX}/$(cat ~/.kube/config 2>/dev/null | grep --color=never "current-context:" | awk -F'/' '{print $2}')"
      echo "${K8SCTX}"
}

function timer_start {
    COMMAND_START=${COMMAND_START:-$(date +%s)}
}

trap 'timer_start' DEBUG

if [ -t 0 ] ; then  # input is a terminal
    DARK_GRAY="\[\033[90m\]"
    RED="\[\033[31m\]"
    WHITE="\[\033[0m\]"
    CYAN="\[\033[36m\]"
    BLUE="\[\033[01;34m\]"
    PINK="\[\033[01;35m\]"
    PROMPT_COMMAND='

        LAST_CODE=$?

        # python env handler
        VENV=""
        if [[ ${VIRTUAL_ENV} ]]; then
            VENV="${DARK_GRAY}[$(basename ${VIRTUAL_ENV})] "
        fi

        # git branch handler
        GITBR="$(parse_git_branch)"
        GITBRANCH=""
        if [[ ${GITBR} ]]; then
            GITBRANCH="${DARK_GRAY}[${GITBR}]"
        fi

        # k8s context
        K8SCTX="$(parse_k8s_ctx)"
        K8S=""
        if [[ ${K8SCTX} ]]; then
            K8S="${DARK_GRAY}[k8s:${K8SCTX}]"
        fi

        HOSTNAME="\h"
        if [ "${HOSTNAME_MANUAL}" ]; then
            HOSTNAME="${HOSTNAME_MANUAL}"
        fi

        if [ ${LAST_CODE} = 0 ]; then
            PROMPT_COLOR="${CYAN}"
        else
            PROMPT_COLOR="${RED}"
        fi

        COMMAND_DURATION="$(expr $(date +%s) - ${COMMAND_START:-$(date +%s)} 2>/dev/null)"
        PS1="[${COMMAND_DURATION} sec] ${VENV}${K8S}${GITBRANCH}\n${WHITE}\D{%T} ${PROMPT_COLOR}\u@${HOSTNAME}${WHITE}:${BLUE}\w${WHITE}\$ "

        # must be the last command
        unset COMMAND_START

    '
    export GREP_OPTIONS='--color=always'
    export GREP_COLOR='1;35;40'
fi
export BASH_SILENCE_DEPRECATION_WARNING=1

# brew install bash-completion
if [ -f "/opt/homebrew/etc/profile.d/bash_completion.sh" ]; then source "/opt/homebrew/etc/profile.d/bash_completion.sh"; fi
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f '~/.git-completion.bash' ]; then source '~/.git-completion.bash'; fi


# common aliases
alias gitbr="git branch"
alias gitcmt="git commit -a"
alias gitammend="git commit -a --amend --date=now"
alias gitcheck="git diff origin/master --check"
alias gitco="git checkout"
alias gitlog="git log --decorate --graph --abbrev-commit --date=relative"
alias gitrmremote="git push origin --delete"
alias gitrmlocal="git branch -D"
alias gitst="git status"
alias gitcontribstat="git ls-tree -r -z --name-only HEAD -- */*  | sed 's/^/.\//' | xargs -0 -n1 git blame --line-porcelain HEAD |grep -ae \"^author \" | sort | uniq -c | sort -nr"
alias gitupfull="gitco main && git pull --rebase && gitco -"

alias ls='ls --color'
alias k9s="XDG_CONFIG_HOME=${SCRIPT_DIR} k9s"
alias cdpers="cd ~/Projects/Personal"
alias cdext="cd ~/Projects/External"
alias cdsnippet="cd ~/Projects/Personal/snippets"

# cargo
alias cargodepgraph="cargo depgraph --workspace-only --dedup-transitive-deps| dot -Tpng > graph.png"
alias cargofix="cargo clippy --fix --all-features && cargo +nightly fmt"
alias cargofmt="cargo +nightly fmt"
alias cargotest="cargo nextest run --all-features"


# don't close session with ctrl+D
IGNOREEOF=2
