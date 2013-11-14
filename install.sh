#! /bin/bash

# vimrc
cp ~/.vimrc ~/.vimrc.bak
ln -s $PWD/vimrc ~/.vimrc

# bashrc
cp ~/.bashrc ~/.bashrc.bak
ln -s $PWD/bashrc ~/.bashrc
