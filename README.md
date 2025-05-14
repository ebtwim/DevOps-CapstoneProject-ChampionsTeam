Here is your updated documentation, formatted as a complete doc:

---

# 3-Tier Kubernetes App on Azure (Terraform)

This repository contains Terraform code to provision a **Capstone-Project--Terraform** on Azure, including:

* **Azure Kubernetes Service (AKS)**
* **Azure SQL Database**
* **Virtual Network (VNet)** and **Subnets**

Team members collaborate on this code using **GitHub** for version control and **Azure Blob Storage** for Terraform remote state.

---

## 📁 Project Structure

```
terraform/
├── Azurerm/                             # Reusable Terraform modules for Azure resources
│   ├── azurerm_aks                      # Module to create an AKS cluster
│   ├── azurerm_mssql_virtual_network_rule  # SQL VNet rule
│   ├── azurerm_resource_group
│   ├── azurerm_sql_db
│   ├── azurerm_subnets
│   └── azurerm_virtual_network
└── solution/                            # Root Terraform project for this capstone
    ├── backend.tf                       # Remote state backend configuration
    ├── local.tf                         # Local variables (project prefix, location, etc.)
    ├── main.tf                          # Module instantiations
    ├── output.tf                        # Terraform outputs (kube_config, etc.)
    └── providers.tf                     # Provider and backend declarations
```

---

## 🛠 Prerequisites

* [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
* [Terraform CLI](https://www.terraform.io/downloads.html) (v1.5+ recommended)
* Azure subscription with **Contributor** access
* Git (for version control)

---

## ⚙️ Terraform Remote State with Azure Blob Storage

To enable safe, collaborative Terraform workflows, this project uses a **remote backend** configured on **Azure Blob Storage**. Here's how it works:

### 1. Central State Storage

Instead of storing `terraform.tfstate` locally on each machine, the state file is stored in an Azure Storage Account and Blob Container. This ensures:

* A single source of truth for your infrastructure state
* Prevention of conflicting changes
* History of state versions maintained by Azure

### 2. Azure Resources for Remote State

* **Resource Group**: `DevOps1-tfstate-rg`
* **Storage Account**: `devopstfstatechamp` (globally unique)
* **Blob Container**: `tfstate`

### 3. How Team Collaboration Works

* All team members clone the GitHub repo containing the Terraform code and the `backend.tf` file.
* On first `terraform init`, Terraform reads the backend configuration and connects to the specified Storage Account and Container.
* Terraform downloads the current state into memory, locks it for exclusive writes, and uploads any changes back to the blob.
* Other team members automatically use the same state and cannot overwrite each other’s work.

### 4. No Extra Steps for Team Members

After one person creates the Storage Account and Container (manually or via Terraform), **everyone** only needs to run:

```bash
terraform init
terraform plan
terraform apply
```

Terraform handles locking and unlocking the state behind the scenes.

---

## 📝 Explanation of `backend.tf`

The `backend.tf` file configures Terraform’s remote backend.

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "DevOps1-tfstate-rg"
    storage_account_name  = "devopstfstatechamp"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```

* `backend "azurerm"` tells Terraform to use Azure Blob Storage as the backend.
* `resource_group_name`, `storage_account_name`, and `container_name` specify where the state is stored.
* `key` is the blob name for your state file. You can use paths (e.g., `envs/dev/terraform.tfstate`) to separate environments.

> **Important**: Do **not** commit any actual state files or the `.terraform` directory to Git. This configuration is enough for Terraform to fetch and store the state remotely.

---

## 🚀 Deployment Steps

### 1. Authenticate with Azure

```bash
az login
```

### 2. Create Remote State Resources (only one person does this once)

```bash
az group create --name DevOps1-tfstate-rg --location "East US"
az storage account create --name devopstfstatechamp --resource-group DevOps1-tfstate-rg --location "East US" --sku Standard_LRS --kind StorageV2
az storage container create --name tfstate --account-name devopstfstatechamp --auth-mode login
```

### 3. Initialize Terraform

```bash
cd terraform/solution
terraform init
```

> Approve migration if prompted.

### 4. Preview Infrastructure

```bash
terraform plan
```

### 5. Apply Changes

```bash
terraform apply
```

### 6. Access AKS Cluster (optional for app deployment)

```bash
# Backup existing kube config (optional)
mv ~/.kube/config ~/.kube/config_backup

# Append the cluster config from Terraform output
terraform output kube_config >> ~/.kube/config

# Edit out the EOT markers if present (use a text editor)
# Verify access to cluster
kubectl get nodes
```

---

## 👥 Notes for Team Collaboration

You do **NOT** need to create your own Azure Storage Account.

The remote state is already configured in `backend.tf` to use shared storage:

* Storage Account: `devopstfstatechamp`
* Container: `tfstate`

### Make sure you:

* Have access to the Azure subscription.
* Get assigned at least these roles:

  * **Contributor**
  * **Storage Blob Data Contributor**

### Clone this repository:

```bash
git clone https://github.com/wejdann/Capstone-Project--Terraform.git
cd Capstone-Project--Terraform/terraform/solution
```

### Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

Terraform handles remote state automatically. All changes are stored centrally to avoid conflicts.

---
