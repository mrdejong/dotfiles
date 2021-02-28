export LANG=en_US.UTF-8

if [[ $(uname -s) = Darwin ]]; then
    ulimit -n 65536
    ulimit -u 1064
fi

if [ -d "$HOME/.zshenv.d" ]; then
    for EXTENSION_FILE in $(find $HOME/.zshenv.d/ -name '*.zsh'); do
        source "$EXTENSION_FILE"
    done
fi
