#!/usr/bin/env bash

MINIFORGE="$HOME/miniforge3"
MAMBA="$MINIFORGE/bin/mamba"
ENV='mamba run --name hoox'


make install-mamba MINIFORGE_INSTALL_DIR="$MINIFORGE"
eval "`$MAMBA shell hook --shell bash`"

mamba env create --yes --file environment.yml

$ENV make install-iscan
$ENV make install-Rlibs

INTERPROSCAN=$(dirname $($ENV fd -a interproscan.sh | head -1))
export PATH="${PATH}:$INTERPROSCAN"

$ENV make test
