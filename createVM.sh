#!/usr/bin/env bash
set -e
# Deploy the pandoomain pipeline
# on a Google Cloud Plataform Virtual Machine.
# The excution time of this script is:
# around 40 minutes

USER="$1"
ZONE="$2"
NAME="$3"
REMOTE="$USER@$NAME"

CORES='24'
RAM='32000'
DISK='200GB'


function wait_for_ssh {
    echo "Waiting for SSH to be available on $NAME..."
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
    echo "Creating VM: $NAME..."
    gcloud compute instances create "$NAME" \
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
    echo "Deleting VM: $NAME..."
    gcloud compute instances delete "$NAME" --zone="$ZONE" --quiet
}


# Check if the instance already exists
if gcloud compute instances describe "$NAME" --zone="$ZONE" &>/dev/null; then
    echo "Instance $NAME exists. Deleting and recreating..."
    cloud_delete
    cloud_create
else
    echo "Instance $NAME does not exist. Creating a new one..."
    cloud_create
fi


wait_for_ssh


cloud_exec "sudo apt update && sudo apt install -y git make"
cloud_exec "git clone https://github.com/elbecerrasoto/deploy-pandoomain"
cloud_exec "git clone https://github.com/elbecerrasoto/pandoomain"
cloud_exec "cd $HOME/pandoomain && $HOME/deploy-pandoomain/install_pandoomain.sh"
