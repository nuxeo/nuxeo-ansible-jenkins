#!/bin/bash -e

# add user installed gems bin to PATH
if which ruby >/dev/null && which gem >/dev/null; then

    sudo -H -u jenkins sh <<"EOF"
GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
echo "GEM_HOME=$GEM_HOME" >>  $HOME/.ssh/environment
echo "PATH=$GEM_HOME/bin:$PATH" >>  $HOME/.ssh/environment
EOF

fi
