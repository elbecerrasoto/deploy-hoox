#!/usr/bin/env bash

MINIFORGE="$HOME/miniforge3"
MAMBA="$MINIFORGE/bin/mamba"
ENV='mamba run --name pandoomain'

ISCAN_VERSION=5.73-104.0
MINIFORGE_VERSION=25.1.1-0

make install-mamba MINIFORGE_VERSION="$MINIFORGE_VERSION" MINIFORGE_INSTALL_DIR="$MINIFORGE"
eval "`$MAMBA shell hook --shell bash`" # tied to miniforge version >25.1.1-0

mamba env create --yes --file environment.yml

$ENV make install-iscan ISCAN_VERSION="$ISCAN_VERSION" ISCAN_DRY="" &
$ENV make install-Rlibs &
wait

INTERPROSCAN="$(realpath interproscan-$ISCAN_VERSION)"
export PATH="${PATH}:$INTERPROSCAN"

$ENV make test
