#Adding homebrew to PATH
export PATH=/opt/homebrew/bin:$PATH

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found
zinit snippet OMZP::copyfile
zinit snippet OMZP::copypath
zinit snippet OMZP::dircycle
zinit snippet OMZP::dirhistory
zinit snippet OMZP::gcloud
zinit snippet OMZP::git
# zinit snippet OMZP::httpie
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
# zinit snippet OMZP::pass
zinit snippet OMZP::sudo
zinit snippet OMZP::tmuxinator

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias airbyte-dev-pf='kubectl port-forward -n airbyte svc/dev-airbyte-airbyte-webapp-svc 8000:80'
alias airbyte-prod-pf='kubectl port-forward -n airbyte svc/prod-airbyte-airbyte-webapp-svc 8000:80'
alias bq-setup='source ~/Gorila/inits/bq.sh'
alias cls='clear -x'
alias ls='ls --color'
alias temporal-dev-sec-setup='source ~/Gorila/inits/temporal_sec_dev.sh'
alias temporal-prod-bi-setup='source ~/Gorila/inits/temporal_bi_prod.sh'
alias ua='pamac update -a'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Environment Variables
export BROWSER="$(which firefox)"
export EDITOR='nvim'
export GPG_TTY="$(tty)"
export GPG_TTY=$(tty)
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin
export PATH=$PATH:/home/piero/.temporalio/bin
export PATH=$PATH:$HOME/.local/bin
export PYENV_ROOT
export XDG_CURRENT_DESKTOP=Hyprland
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@17/17.0.14/libexec/openjdk.jdk/Contents/Home"
# Added by dbt Fusion extension (ensure dbt binary dir on PATH)
if [[ ":$PATH:" != *":/home/pieroc/.local/bin:"* ]]; then
  export PATH=/home/pieroc/.local/bin:"$PATH"
fi
# Added by dbt Fusion extension
alias dbtf=/home/pieroc/.local/bin/dbt

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/pieroc/google-cloud-sdk/path.zsh.inc' ]; then . '/home/pieroc/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/pieroc/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/pieroc/google-cloud-sdk/completion.zsh.inc'; fi

# Added by dbt installer
export PATH="$PATH:/home/pieroc/.local/bin"
# Segredos do pass, carregados sob demanda. Nenhum valor mora neste arquivo
# (dotfiles e publico) e abrir um terminal nao decripta nada.
#
# Por que exportar de verdade em vez de passar inline no comando: o devcontainer
# usa "${localEnv:GITLAB_TOKEN}" no remoteEnv, e o docker compose interpola os
# env_file a partir do ambiente do shell que o chamou. Os dois leem o ambiente
# do processo pai, nao a linha de comando.
#
# Por que preexec em vez de wrapper de funcao: preexec ve a linha crua digitada,
# entao pega alias (dbtf) tambem, e nao entra em conflito com as funcoes que os
# plugins do zinit definem.
revena-tokens() {
  export GITLAB_TOKEN="$(pass show revena/gitlab-pat)"
  export DATABRICKS_TOKEN="$(pass show revena/databricks/pat | head -1)"
}

# Ferramentas que precisam dos tokens no ambiente. Adicione aqui se faltar alguma.
#
# O padrao casa o nome em qualquer posicao da linha, inclusive dentro de um
# caminho: ./scripts/glab_update_mr_description.sh chama glab como processo
# filho, e preexec nao dispara pra processo filho. Se so olhassemos a primeira
# palavra, o glab de dentro do script rodaria sem token e tomaria 401.
#
# Falso positivo (ex.: "grep docker log.txt") custa um pass show que o agente ja
# tem em cache, ou seja ~nada. Falso negativo custa um 401 confuso. Erra pro
# lado de disparar.
_revena_secret_re='(^|[/[:space:]])(dbtf|docker-compose|docker|devcontainer|codium|cursor|code|dbt|glab)([[:space:]_.:=/-]|$)'

_revena_maybe_load_tokens() {
  [[ -n $GITLAB_TOKEN && -n $DATABRICKS_TOKEN ]] && return 0
  [[ $1 =~ $_revena_secret_re ]] || return 0
  revena-tokens
}

export HONCHO_PEER_NAME="$USER"

_honcho_maybe_load_key() {
  [[ -n $HONCHO_API_KEY ]] && return 0
  [[ $1 =~ '(^|[/[:space:]])claude([[:space:]]|$)' ]] || return 0
  export HONCHO_API_KEY="$(pass show honcho/claude-code/api-key | head -1)"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _revena_maybe_load_tokens
add-zsh-hook preexec _honcho_maybe_load_key

# Dentro de ~/Projetos (recursivo) o Claude Code usa a conta pessoal: login,
# settings e plugins ficam em ~/.claude-pessoal. Fora dele, volta pro ~/.claude.
_claude_pick_account() {
  if [[ $PWD == $HOME/Projetos || $PWD == $HOME/Projetos/* ]]; then
    export CLAUDE_CONFIG_DIR="$HOME/.claude-pessoal"
  else
    unset CLAUDE_CONFIG_DIR
  fi
}
add-zsh-hook chpwd _claude_pick_account
_claude_pick_account

# bun completions
[ -s "/home/pieroc/.bun/_bun" ] && source "/home/pieroc/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
