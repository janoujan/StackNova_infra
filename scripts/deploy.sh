#!/bin/bash

set -e

echo "=== Terraform Init ==="

cd terraform

terraform init

terraform apply -auto-approve

cd ..

echo "=== Ansible ==="

ansible-playbook \
-i ansible/inventory.ini \
ansible/playbook.yml

echo "=== Déploiement terminé ==="