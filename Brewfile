cask_args appdir: "/Applications"

## util
brew "coreutils"
brew "curl"
brew "fzf"
brew "grep"
brew "jq"
brew "lsd"
brew "nkf"
brew "ripgrep"
brew "tealdeer"
brew "tree"
brew "tree-sitter"
brew "watch"
brew "yq"
brew "zoxide"

## git
brew "gh"
brew "ghq"
brew "git"

## editor
brew "neovim"
brew "shellcheck"

## language
brew "fnm"
brew "goenv"
brew "pnpm"
brew "rbenv"
brew "rust"
brew "uv"

## infra
brew "awscli"
brew "docker"
brew "docker-compose"

## other
# brew "mysql@5.7"
# brew "openssl"
# brew "postgresql@14"
# brew "shared-mime-info" # mimemagic gem
brew "starship"
brew "stow"

cask "alfred"
cask "claude"
cask "claude-code"
cask "clipy"
cask "cmux"
cask "cursor"
cask "figma"
cask "font-hack-nerd-font"
cask "gcloud-cli"
cask "google-chrome"
cask "google-japanese-ime"
cask "iterm2"
# cask "mysqlworkbench"
cask "raycast"
# cask "sequel-pro"
cask "shottr"
cask "slack"
# cask "sourcetree"
cask "tableplus"
cask "visual-studio-code"
cask "zoom"

## vscode extensions
vscode "anthropic.claude-code"
vscode "castwide.solargraph"
vscode "davidanson.vscode-markdownlint"
vscode "eamodio.gitlens"
vscode "ecmel.vscode-html-css"
vscode "github.github-vscode-theme"
vscode "github.vscode-github-actions"
vscode "github.vscode-pull-request-github"
vscode "golang.go"
vscode "karunamurti.haml"
vscode "mechatroner.rainbow-csv"
vscode "mhutchie.git-graph"
vscode "ms-azuretools.vscode-containers"
vscode "ms-ceintl.vscode-language-pack-ja"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-vsliveshare.vsliveshare"
vscode "oderwat.indent-rainbow"
vscode "redhat.vscode-yaml"
vscode "shopify.ruby-lsp"
vscode "sianglim.slim"
vscode "simonsiefke.svg-preview"
vscode "streetsidesoftware.code-spell-checker"

## personal only
if ENV["HOMEBREW_MACHINE_TYPE"] == "personal"
  ## backup
  brew "mackup"
  brew "mas"

  cask "appcleaner"
  cask "docker-desktop"
  cask "dropbox"
  cask "session-manager-plugin"

  mas "Duplicate Photos Fixer Pro", id: 963642514
  mas "Kindle", id: 302584613
  mas "LINE", id: 539883307
  mas "Microsoft OneNote", id: 784801555
end

## work only
if ENV["HOMEBREW_MACHINE_TYPE"] == "work"
  ## infra
  brew "aqua"
  brew "azure-cli"
  brew "k9s"
  brew "kubectl"
  brew "kustomize"
  brew "stern"
  brew "terraform"

  cask "microsoft-teams"
  cask "rancher"

  ## vscode extensions
  vscode "biomejs.biome"
  vscode "charliermarsh.ruff"
  vscode "graphql.vscode-graphql-syntax"
  vscode "hashicorp.terraform"
  vscode "ms-kubernetes-tools.vscode-kubernetes-tools"
  vscode "ms-toolsai.jupyter"
  vscode "ms-toolsai.jupyter-keymap"
  vscode "ms-toolsai.jupyter-renderers"
  vscode "ms-toolsai.vscode-jupyter-cell-tags"
  vscode "ms-toolsai.vscode-jupyter-slideshow"
  vscode "mtsmfm.vscode-k8s-quick-attach"
end
