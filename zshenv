# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# Evaluate JAVA_HOME at start
export JAVA_HOME=$(/usr/libexec/java_home)

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

## Default editor
export VISUAL=/usr/local/bin/nvim
export EDITOR=$VISUAL

# Setup Cask
export PATH="$HOME/.cask/bin:$PATH"

# Setup golang
export GOPATH="$HOME/Sources/golang"
