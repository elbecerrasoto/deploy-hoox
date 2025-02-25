#!/usr/bin/env bash

MINIFORGE="$HOME/miniforge3"
MAMBA="$MINIFORGE/bin/mamba"
ENV='mamba run --name hoox'

# CORES='24'
# NAME='free-and-focus'

# gcloud compute instances create "$NAME" \
#     --zone=us-central1-a \
#     --machine-type=custom-"${CORES}"-32000 \
#     --image-family=debian-11 \
#     --image-project=debian-cloud \
#     --boot-disk-size=200GB


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

# gcloud compute instances delete "$NAME" --zone=us-central1-c
