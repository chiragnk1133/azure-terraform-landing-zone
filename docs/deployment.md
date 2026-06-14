# Deployment Guide

## Prerequisites

- Terraform 1.7 or later
- Azure CLI
- An existing Microsoft Entra tenant
- Existing management, connectivity, and identity subscriptions
- An Azure Storage account for remote Terraform state
- An approved IP address plan

The deployment principal requires:

- Permission to create management groups beneath the configured parent
- Management Group Contributor at the parent management group
- Resource Policy Contributor at the organization management group
- Owner or equivalent resource and role-assignment permissions on the three
  platform subscriptions

Use a dedicated workload identity with federated credentials in CI. Do not use
long-lived client secrets.

## Configure state

1. Copy `backend.tf.example` to `backend.tf`.
2. Replace the resource group, storage account, container, and key.
3. Restrict the state storage account to approved networks.
4. Enable blob versioning, soft delete, a resource lock, and diagnostic logs.
5. Grant the deployment identity `Storage Blob Data Contributor` on the state
   container.

## Configure inputs

Copy `terraform.tfvars.example` to `terraform.tfvars` and update every tenant,
subscription, region, contact, network, and tag value.

Confirm that the five subnet prefixes are contained in `hub_address_space` and
do not overlap. Reserved subnet names must not be changed.

Set `firewall_sku` to `Premium` for TLS inspection and IDPS capabilities, or
`Standard` for baseline firewall inspection only. Set `bastion_sku` to
`Standard` or `Basic` depending on your budget and remote access requirements.

## Validate and plan

```powershell
az login --tenant <tenant-id>
az account set --subscription <management-subscription-id>
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out main.tfplan
terraform show main.tfplan
```

Review policy effects carefully. The allowed-location and Corp public-IP
policies use `deny`. When enabling Azure Firewall Premium, confirm the SKU and
associated operating model with security and networking teams.

## Apply

Apply through an approved pipeline after peer review:

```powershell
terraform apply main.tfplan
```

Do not run an unreviewed interactive apply against production.

## Post-deployment

1. Route subscription Azure Activity logs to the central workspace.
2. Confirm diagnostic settings are enabled for central monitoring, firewall logs, and Bastion logs.
3. Assign the policy initiative identity the roles required for remediation.
4. Review policy compliance and create remediation tasks.
4. Configure Defender for Cloud plans by workload risk and cost approval.
5. Add firewall rules, DNS, routes, and hybrid connectivity.
6. Configure budgets and anomaly alerts on every subscription.
7. Integrate alerts with the incident-management and SIEM platforms.
8. Run access reviews and validate emergency-access procedures.

## Destruction warning

Destroying a landing zone can detach subscriptions, remove policy assignments,
and delete shared networking and logs. Production destruction must use a
separate, approved runbook. Resource locks should be added after initial
deployment.

