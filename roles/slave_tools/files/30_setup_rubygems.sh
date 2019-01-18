#!/bin/bash -e

grep -q GEM_HOME ~jenkins/.profile && exit 0

sudo -H -u jenkins sh <<EOS
set -x
GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
cat <<EOE >> \$HOME/.profile
# ruby gem home and path
GEM_HOME=\$GEM_HOME; export GEM_HOME
PATH=\\\$GEM_HOME/bin:\\\$PATH; export PATH
EOE
EOS

