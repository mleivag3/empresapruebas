#!/bin/bash
set -e
cd "$(dirname "$0")/../terraform"
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
