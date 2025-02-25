#!/usr/bin/env bash

HOST='free-and-focus'
USER="ebecerra"
REMOTE="$USER@$HOST"

CORES='24'
RAM='32000'
DISK='200GB'
ZONE='us-central1-c'

SOURCE='install_hoox.sh'
DESTINATION='install_hoox.sh'


gcloud compute instances create "$HOST" \
    --zone="$ZONE" \
    --machine-type=custom-"$CORES"-"$RAM" \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --boot-disk-size="$DISK"


gcloud compute ssh "$REMOTE" \
    --zone="$ZONE" \
    --command="sudo apt install -y git make"



# gcloud compute instances delete "$HOST" --zone="$ZONE"
