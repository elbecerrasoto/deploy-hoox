#!/usr/bin/env bash

MINIFORGE="$HOME/miniforge3"
MAMBA="$MINIFORGE/bin/mamba"
ENV='mamba run --name hoox'

sudo apt install git make

git clone https://github.com/elbecerrasoto/hoox
cd hoox

make install-mamba MINIFORGE_INSTALL_DIR="$MINIFORGE"
eval "`$MAMBA shell hook --shell bash`"

mamba env create --yes --file environment.yml
$ENV make install-iscan

INTERPROSCAN=`$ENV fd -a interproscan.sh | head -1`
sudo ln -sf  /usr/bin/interproscan.sh "$INTERPROSCAN"

$ENV make test
