# Azure Landing Zone (CAF)

Reference implementation of a Microsoft Cloud Adoption Framework (CAF) platform
landing zone using Terraform.

This repository creates:

- A CAF-aligned management group hierarchy
- Platform subscription placement for management, connectivity, and identity
- Central Log Analytics and Azure Automation resources
- A hub virtual network with Azure Firewall (Standard or Premium), optional Bastion (Standard or Basic), VPN Gateway, and DDoS
- Management-group policy assignments and monitoring guardrails, including audit coverage for firewall and Bastion diagnostics
- Subscription and resource diagnostic settings for firewall, Bastion, and activity logs
- Architecture, security, operations, deployment, and cost documentation

No Azure resources are deployed automatically.

## Quick start

1. Review [docs/architecture.md](docs/architecture.md) and
   [docs/design-decisions.md](docs/design-decisions.md).
2. Copy `terraform.tfvars.example` to `terraform.tfvars`.
3. Supply tenant, subscription, management group, network, and notification values.
4. Authenticate with an identity that has the permissions listed in
   [docs/deployment.md](docs/deployment.md).
5. Run:

```powershell
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out main.tfplan
```

Apply only after reviewing the plan and receiving the required organizational
approval.

## Important scope notes

- This is a platform landing zone baseline. Application landing zones are
  provisioned separately beneath `Corp`, `Online`, or `Sandbox`.
- Subscription creation and billing enrollment are intentionally out of scope.
  Existing subscriptions are associated with management groups.
- Microsoft Entra Conditional Access, Privileged Identity Management, and
  break-glass accounts are tenant-level controls and are documented rather than
  provisioned by this AzureRM stack.
- Azure prices vary by region, agreement, usage, and currency. See
  [docs/cost-estimate.md](docs/cost-estimate.md).

## Repository layout

```text
.
|-- main.tf
|-- providers.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars.example
|-- modules/
|   |-- connectivity/
|   |-- governance/
|   `-- management/
|-- policies/
|-- diagrams/
|-- docs/
`-- .github/workflows/
```

## Microsoft guidance

- [Azure landing zones](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/)
- [Azure landing zone design areas](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-areas)
- [Platform landing zone implementation options](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/implementation-options)

