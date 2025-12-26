## Overview
This project uses **Terraform** to provision a functional **EC2 web server** that serves a simple HTML page.  

## Project Structure

```
.github/                           # GitHub metadata
│   └── workflows/
        └── terraform.yaml         # GitOps pipeline
    
main/                              # Main configuration
    
modules/                           # Reusable Terraform modules
    
.tflint.hcl                        # Configuration for TFLint
.tfsec.yml                         # Configuration for tfsec
.gitignore                         # Git ignored files
README.md                          # Project overview and usage
.env-gh-secrets                    # Github Secrets file
state.config                       # Remote state config
```

---

## Tools Used

| Tool                           | Purpose                                               |
| ------------------------------ | ----------------------------------------------------- |
| Terraform                      | Provisioning and managing infrastructure              |
| TFLint                         | Linting and enforcing Terraform best practices        |
| tfsec                          | Static analysis for Terraform security issues         |
| GitHub Actions                 | CI/CD automation for linting, testing, and deployment |

---

## Getting Started

### Prerequisites

Make sure you have the following installed:

* [Terraform](https://www.terraform.io/downloads)
* [TFLint](https://github.com/terraform-linters/tflint)
* [tfsec](https://aquasecurity.github.io/tfsec/)

### Initialize Terraform

```bash
cd main      
terraform init -upgrade -backend-config="/../state.config" 
```

### Format, Validate & Scan

```bash
terraform fmt -recursive           # Format code
terraform validate                 # Validate syntax and structure
tflint                             # Lint Terraform code
tfsec --config-file .tfsec.yml     # Security scan
```

###  Plan & Apply

```bash
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

---
