#!/bin/bash
# encoding: utf-8
# Name  : recover.sh
# Descp : used for 
# Author: jaycee
# Date  : 04/12/18 03:52:19 -0800
__version__=0.1

#set -x                     #print every excution log
#set -e                     #exit when error hanppens

if which apt-get >/dev/null; then
   echo "正在努力为您安装vim程序" > ma6174
   sudo apt-get install -y vim vim-gnome 
   echo "正在努力为您安装ctags程序" > ma6174
   sudo apt-get install -y ctags 
   echo "正在努力为您安装cscope程序" > ma6174
   sudo apt-get install -y cscope 
   echo "正在努力为您安装xclip程序" > ma6174
   sudo apt-get install -y xclip 
   echo "正在努力为您安装astyle程序" > ma6174
   sudo apt-get install -y astyle 
   echo "正在努力为您安装python程序" > ma6174
   sudo apt-get install -y python-setuptools python-dev python3-dev python3-pip python-magic
   echo "正在努力为您安装git程序" > ma6174
   sudo apt-get install -y git 
   echo "正在努力为您安装build tools程序" > ma6174
   sudo apt-get install -y build-essential automake libtool-bin
   echo "正在努力为您安装ssh程序" > ma6174
   sudo apt-get install -y ssh zsh tmux
   echo "正在努力为您安装curl程序" > ma6174
   sudo apt-get install -y libcurl4-gnutls-dev pkg-config 
elif which yum >/dev/null; then
    sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel    
fi

if which pip3 >/dev/null; then
   echo "正在努力为您安装BuildToolBob dependecies程序" > ma6174
   sudo pip3 install PyYAML schema pyparsing python3-sphinx
fi

##Add HomeBrew support on  Mac OS
if which brew >/dev/null;then
    echo "You are using HomeBrew tool"
    brew install vim ctags git astyle
fi

echo "正在努力为您安装autopep8程序" > ma6174
sudo easy_install -ZU autopep8 
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
j
if [ which git > /dev/null ]; then
   cd ~/ && git clone https://github.com/ma6174/vim.git
   #git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
   #mkdir -p ~/.vim/autoload ~/.vim/bundle && \
fi

mv -f ~/vim ~/vim_old
cd ~/ && git clone https://github.com/520lly/linuxProfiles.git .linuxProfiles
if [ "$(uname -a | awk '{ print $2}')" == "ubuntu" ]; then  
   cd ~/.linuxProfiles &&  git checkout -b Ubuntu remotes/origin/Ubuntu
   cp .vimrc ..
   cp .zshrc ..
fi
#mv -f ~/.vim ~/.vim_old
#mv -f ~/vim ~/.vim
#mv -f ~/.vimrc ~/.vimrc_old
#mv -f ~/.vim/.vimrc ~/
echo "正在努力为您安装bundle程序" > ma6174
echo "安装完毕将自动退出" >> ma6174
echo "请耐心等待" >> ma6174
vim ma6174 -c "BundleInstall" -c "q" -c "q"
rm ma6174
echo "安装完成"

echo "正在努力为您安装zsh程序"
if which zsh > /dev/null; then
   sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
   source ~/.zshrc
   sudo chsh -s $(which zsh)
fi
echo "安装zsh完成"

echo "正在努力为您安装fzf程序"
rm ~/.fzf -rf 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
echo "安装完成"

echo "正在努力为您安装fcitx程序"
sudo apt-get install fcitx-pinyin
echo "正在努力为您安装下载搜狗中文输入法程序"
wget http://cdn2.ime.sogou.com/dl/index/1524572264/sogoupinyin_2.2.0.0108_amd64.deb?st=NaSv4PBTLnWzMXJkfjQrqg&e=1543901567&fn=sogoupinyin_2.2.0.0108_amd64.deb ~/Downloads/
sudo dpkg -i ~/Downloads/sogoupinyin_2.2.0.0108_amd64.deb
echo "安装完成"


echo "正在努力为您安装gef程序"
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

if [ which git > /dev/null ]; then
   cd ~/ && git clone https://github.com/BobBuildTool/bob.git ~/tools/
   cd ~/tools/bob
   make
fi

