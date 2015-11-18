
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

run git clone https://github.com/lukerandall/haskellmode-vim $HOME/.vim/bundle/haskellmode
add haskeline $HOME/.haskeline
add hdevtools.vim $HOME/.vim/plugin/
add ghc-mod.vim $HOME/.vim/plugin/

#
# see docker bugs #6119 and #9934
# hack, for some reason, ownership is changing too root on second .vim/plugin add
#
user root
run chown -R ${USER}: \
    $HOME/.vim/plugin \
    $HOME/.haskeline
user $USER

cmd $SHELL -l
