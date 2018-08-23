#!/bin/bash -e

# add user installed gems bin to PATH
if which ruby >/dev/null && which gem >/dev/null; then
    export GEM_HOME="$(ruby -rubygems -e 'puts Gem.user_dir')"
    PATH="$GEM_HOME/bin:$PATH"
fi
