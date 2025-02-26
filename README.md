# Deploy Hoox

Deploy the **Hoox pipeline** on a **Google Cloud Platform (GCP) Virtual Machine (VM)**.

## Deployment Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/elbecerrasoto/deploy-hoox
cd deploy-hoox
```

### 2. Define Input Variables

Set the following environment variables according to your setup:

```sh
USER=my_user     # Example: USER=ebecerra
ZONE=VM_zone     # Example: ZONE='us-central1-c'
NAME=VM_name     # Example: NAME='toxin-prediction'
```

### 3. Create the Virtual Machine

Run the `createVM.sh` script to set up the VM and install dependencies:

```sh
./createVM.sh "$USER" "$ZONE" "$NAME"
```

> **Note:** This step takes approximately **40 minutes**, as it provisions the VM and installs all required dependencies. Installing **InterProScan** is particularly time-consuming.

### 4. Test the Pipeline Interactively

#### 4.1 Connect to the VM

```sh
gcloud compute ssh "$NAME" --zone="$ZONE"
```

#### 4.2 Make the Binaries Discoverable

Ensure the necessary binaries are accessible:

```sh
eval "`$HOME/miniforge3/bin/mamba shell hook --shell bash`"
mamba activate hoox

cd hoox

ISCAN_DIR="$(find . -maxdepth 1 -type d -name 'interproscan-*')"
ISCAN_BIN="$(realpath "$ISCAN_DIR/interproscan.sh")"

sudo ln -s "$ISCAN_BIN" /usr/bin/interproscan.sh
```

#### 4.3 Run the Hoox Test

```sh
make test
```

### 5. Use the Pipeline

To run Hoox, follow these steps:

1. Edit `config/config.yaml` with the desired configuration.
2. Create a `genomes.txt` file.
3. Create a `queries` directory.

Then, execute the pipeline with:

```sh
snakemake --cores all --configfile config/config.yaml
```

## Requirements

### Prerequisites

Ensure you have the **Google Cloud SDK (`gcloud` command)** installed. You can install it from:
[Google Cloud SDK Installation Guide](https://cloud.google.com/sdk/docs/install)

### Setup

Before proceeding, ensure you have:
- Selected a Google Cloud project.
- Completed authentication and login.

```sh
gcloud auth login
gcloud config set project [PROJECT_ID]
```
