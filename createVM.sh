#!/usr/bin/env bash

set -e  # Exit on any error

HOST='free-and-focus'
USER="ebecerra"
REMOTE="$USER@$HOST"

CORES='24'
RAM='32000'
DISK='200GB'
ZONE='us-central1-c'

# Function to check if SSH is available
function wait_for_ssh {
    echo "Waiting for SSH to be available on $HOST..."
    until gcloud compute ssh "$REMOTE" --zone="$ZONE" --command="echo SSH is ready" &>/dev/null; do
        echo "SSH not available yet. Retrying in 5 seconds..."
        sleep 5
    done
    echo "SSH is now available!"
}

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
        --tags=allow-ssh \
        --metadata=startup-script="sudo systemctl enable --now ssh" \
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

# Wait for SSH to be ready
wait_for_ssh

# Execute setup commands on the VM
cloud_exec "sudo apt update && sudo apt install -y git make"
cloud_exec "git clone https://github.com/elbecerrasoto/deploy-hoox"
cloud_exec "git clone https://github.com/elbecerrasoto/hoox"
cloud_exec "cd $HOME/hoox && $HOME/deploy-hoox/install_hoox.sh"
