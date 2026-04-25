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
cask "claude-code"
cask "clipy"
cask "cursor"
cask "figma"
cask "font-hack-nerd-font"
cask "google-chrome"
cask "google-japanese-ime"
cask "iterm2"
# cask "mysqlworkbench"
# cask "sequel-pro"
cask "shottr"
cask "slack"
# cask "sourcetree"
cask "tableplus"
cask "visual-studio-code"
cask "zoom"

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
  brew "azure-cli"
  brew "k9s"
  brew "kubectl"
  brew "kustomize"
  brew "stern"
  brew "terraform"

  cask "gcloud-cli"
  cask "microsoft-teams"
  cask "rancher"
end