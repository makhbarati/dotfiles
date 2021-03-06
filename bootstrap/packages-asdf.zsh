#!/usr/bin/env zsh

step "Securing zsh compinit directories"
compaudit | xargs chmod go-w

step "Setting up asdf"
source "$(brew --prefix asdf)/asdf.sh"
source "$(brew --prefix asdf)/etc/bash_completion.d/asdf.bash"

step "Setting Ruby compilation vars"
source "$HOME/.ruby-build-vars"

step "Installing Ruby"
ruby_version="$(asdf list-all ruby | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort | tail -1)"
if ! asdf versions ruby | grep -Fq "$ruby_version"; then
    step "Installing Ruby $ruby_version"
    asdf install ruby "$ruby_version"
    asdf global ruby "$ruby_version"
    gem ctags

    step "Configuring Bundler"
    number_of_cores=$(sysctl -n hw.ncpu)
    bundle config --global jobs "$((number_of_cores - 1))"
fi

echo "Installing node..."
asdf plugin-add nodejs
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
node_version="$(asdf list-all nodejs | tail -1)"
asdf install nodejs "$node_version"
asdf global nodejs "$node_version"

echo "Installing Python..."
asdf plugin-add python
conda_version="$(asdf list-all python | grep anaconda3 | tail -1)"
asdf install python "$conda_version"
pip install pynvim
pip2 install pynvim

echo "Installing Java..."
asdf plugin-add java
java_version="$(asdf list-all java | grep openjdk | tail -1)"
asdf install java "$java_version"

echo "Installing Elixir..."
asdf plugin-add elixir
elixir_version="$(asdf list-all elixir | grep -E '\d+\.\d+\.\d+-otp' | tail -1)"
asdf install elixir "$elixir_version"

echo "Installing Erlang..."
asdf plugin-add erlang
erlang_version="$(asdf list-all erlang | tail -1)"
asdf install erlang "$erlang_version"

echo "Installing Ruby..."
asdf plugin-add ruby
ruby_version="$(asdf list-all ruby | grep -E '^\d+\.\d+\.\d+$')"
asdf install ruby "$ruby_version"

echo "Installing Postgres..."
asdf plugin-add postgres
postgres_version="$(asdf list-all postgres | tail -1)"
asdf install postgres "$postgres_version"
