#! /bin/bash

# vimrc
mv ~/.vimrc ~/.vimrc.bak
ln -s $PWD/vimrc ~/.vimrc

# bashrc
mv ~/.bashrc ~/.bashrc.bak
ln -s $PWD/bashrc ~/.bashrc
