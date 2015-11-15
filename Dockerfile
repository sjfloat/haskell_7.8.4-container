
from sjfloat/dev

env DEBIAN_FRONTEND noninteractive

user root

#
# get stack
#
run wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/debian/fpco.key | apt-key add -
run echo 'deb http://download.fpcomplete.com/debian/jessie stable main'| tee /etc/apt/sources.list.d/fpco.list
run apt-get update && apt-get install -y \
    stack \
    libtinfo-dev
run apt-get clean
run rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

env HOME /home/$USER
add stack.yaml $HOME/.stack/global/stack.yaml
run chown -R ${USER}: $HOME

user $USER
workdir $HOME
run stack setup
run stack install cabal-install
run stack path --bin-path | path-to-setup stack

run . $HOME/.profile && cabal update && cabal install \
    ghc-mod \
    happy \
    hdevtools \
    hlint \
    hoogle \
    HUnit \
    parsec

add haskeline $HOME/.haskeline
add ghc-mod.vim $HOME/.vim/plugin/
add hdevtools.vim $HOME/.vim/plugin/

cmd $SHELL -l
