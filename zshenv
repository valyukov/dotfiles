# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:=/usr/local/bin::$PATH"

# Evaluate JAVA_HOME at start
export JAVA_HOME=$(/usr/libexec/java_home)

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

## Default editor
export VISUAL=mvim
export EDITOR=$VISUAL
export GIT_EDITOR='/usr/local/bin/mvim -f --nomru -c "au VimLeave * !open -a Terminal"'

# Setup Cask
export PATH="$HOME/.cask/bin:$PATH"
