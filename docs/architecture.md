# Architecture

## Target state

This implementation follows the Microsoft CAF distinction between a platform
landing zone and application landing zones.

The platform landing zone consists of:

- **Management subscription:** Central logging, alerting, automation, and
  security operations integration.
- **Connectivity subscription:** Regional hub network and optional shared
  network security and hybrid connectivity services.
- **Identity subscription:** Reserved for shared identity infrastructure when
  required. Microsoft Entra ID itself remains tenant-scoped.

Application teams receive separate subscriptions beneath:

- **Corp:** Internal or hybrid workloads that require private connectivity.
- **Online:** Internet-facing workloads.
- **Sandbox:** Experimentation with constrained access and budgets.
- **Decommissioned:** Quarantined subscriptions pending final deletion.

## Management group hierarchy

```text
Tenant Root
`-- <organization>
    |-- Platform
    |   |-- Management
    |   |-- Connectivity
    |   `-- Identity
    |-- Landing Zones
    |   |-- Corp
    |   `-- Online
    |-- Sandbox
    `-- Decommissioned
```

Policy is assigned high in the hierarchy and inherited. Exceptions should be
time-bound policy exemptions with an owner, justification, and expiry date.

## Network topology

The baseline uses hub-and-spoke networking:

- The hub is owned by the connectivity subscription.
- Workload VNets are owned by application subscriptions.
- Azure Firewall provides controlled egress and east-west inspection when
  enabled.
- Private endpoints are preferred for supported platform services.
- VPN Gateway, Bastion, and DDoS Network Protection are optional because their
  need and cost depend on the organization.
- Workload VNet peering, route tables, DNS zones, firewall rule collections,
  and on-premises VPN connections belong in workload or connectivity expansion
  modules after IPAM and traffic requirements are approved.

## Observability

The management subscription contains a central Log Analytics workspace. The
connectivity module sends Azure Firewall logs and metrics to this workspace.
The landing zone also routes Azure Activity logs from management and
connectivity subscriptions into the central workspace.

Azure Policy assignments enforce approved regions, required tags, public IP
controls, and monitoring guardrails. Diagnostic settings are a first-class part
of the platform observability baseline. A custom policy audits Azure Firewall
and Azure Bastion diagnostics to ensure telemetry is collected centrally.

## Availability and resilience

- Azure Firewall, Bastion, and public IPs are zone-aware in supported regions.
- Production should use at least two approved regions when business continuity
  requirements demand it.
- A second regional hub is not created by default because address space,
  routing, failover, and budget decisions are tenant-specific.
- Terraform state must use an Azure Storage backend with versioning, soft
  delete, private access, and Entra authentication.

## Editable diagram

- Source: `diagrams/landing-zone.mmd`
- FigJam: https://www.figma.com/board/JP9hnF0wVnzz32i8vOWNhc

