#!/usr/bin/env bash

set -e  # Exit immediately if any command fails

HOST='free-and-focus'
USER="ebecerra"
REMOTE="$USER@$HOST"

CORES='24'
RAM='32000'
DISK='200GB'
ZONE='us-central1-c'

function cloud_exec {
    gcloud compute ssh "$REMOTE" --zone="$ZONE" --command="$@"
}

function cloud_create {
    echo "Creating VM: $HOST..."
    gcloud compute instances create "$HOST" \
        --zone="$ZONE" \
        --machine-type=custom-"$CORES"-"$RAM" \
        --image-family=debian-11 \
        --image-project=debian-cloud \
        --boot-disk-size="$DISK" \
        --quiet
}

function cloud_delete {
    echo "Deleting VM: $HOST..."
    gcloud compute instances delete "$HOST" --zone="$ZONE" --quiet
}

# Check if the instance already exists
if gcloud compute instances describe "$HOST" --zone="$ZONE" &>/dev/null; then
    echo "Instance $HOST exists. Deleting and recreating..."
    cloud_delete
    cloud_create
else
    echo "Instance $HOST does not exist. Creating a new one..."
    cloud_create
fi

# Execute setup commands on the VM
cloud_exec "sudo apt update && sudo apt install -y git make"
cloud_exec "git clone https://github.com/elbecerrasoto/deployment_hoox"
cloud_exec "cd deployment_hoox && ./install_hoox.sh"
