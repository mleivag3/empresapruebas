#!/bin/bash
set -e
cd "$(dirname "$0")/../terraform"
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
