# Deploy _pandoomain_ on Google Cloud Platform (GCP)

Easily deploy the **Pandoomain pipeline** on a **Google Cloud Platform (GCP) Virtual Machine (VM)** for protein domain annotation and analysis.

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/elbecerrasoto/deploy-pandoomain
cd deploy-pandoomain
```

### 2️⃣ Set Input Variables

Define the necessary environment variables for your setup:

```sh
USER=my_user     # Example: USER=ebecerra
ZONE=VM_zone     # Example: ZONE='us-central1-c'
NAME=VM_name     # Example: NAME='toxin-prediction'
```

### 3️⃣ Create the Virtual Machine

Run the setup script to provision a VM and install dependencies:

```sh
./createVM.sh "$USER" "$ZONE" "$NAME"
```

> ⏳ **Note:** This step takes approximately **40 minutes**, as it installs all required dependencies, including **InterProScan**, which is particularly time-consuming.

### 4️⃣ Connect and Test the Pipeline

#### 🔹 4.1 Access the VM

```sh
gcloud compute ssh "$NAME" --zone="$ZONE"
```

#### 🔹 4.2 Set Up the Environment

Ensure necessary binaries are accessible:

```sh
eval "`$HOME/miniforge3/bin/mamba shell hook --shell bash`"
mamba activate pandoomain

cd pandoomain

ISCAN_DIR="$(find . -maxdepth 1 -type d -name 'interproscan-*')"
ISCAN_BIN="$(realpath "$ISCAN_DIR/interproscan.sh")"

sudo ln -s "$ISCAN_BIN" /usr/bin/interproscan.sh
```

#### 🔹 4.3 Run the Pandoomain Test

```sh
make test
```

### 5️⃣ Run the Pipeline

1. Edit `config/config.yaml` with your desired configuration.
2. Provide a `genomes.txt` file with genome entries.
3. Create a `queries` directory with necessary query files.

Run the pipeline with:

```sh
snakemake --cores all --configfile config/config.yaml
```

---

## 🔧 Requirements

### ✅ Prerequisites

Ensure you have the **Google Cloud SDK (`gcloud` command)** installed. Install it from:
[Google Cloud SDK Installation Guide](https://cloud.google.com/sdk/docs/install)

### 🔑 Authentication & Setup

Before proceeding, make sure you have:
- Selected a Google Cloud project.
- Logged into your Google Cloud account.

```sh
gcloud auth login
gcloud config set project [PROJECT_ID]
```

