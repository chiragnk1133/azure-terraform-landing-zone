# Security Controls

## Control matrix

| Domain | Control | Implementation | Status |
|---|---|---|---|
| Governance | Hierarchical guardrails | Management groups and inherited Azure Policy | Implemented |
| Governance | Approved regions | Custom deny policy | Implemented |
| Governance | Resource ownership metadata | Audit `Environment`, `Owner`, `CostCenter`, and `DataClassification` tags | Implemented |
| Security posture | Microsoft Cloud Security Benchmark | Built-in policy initiative at organization scope | Implemented |
| Network | Restrict public exposure | Public IP creation denied under Corp | Implemented |
| Network | Central inspection | Azure Firewall Premium or Standard, threat intelligence alert mode, DNS proxy | Configurable |
| Network | Secure administration | Azure Bastion Standard or Basic; no direct VM public IP requirement | Configurable |
| Network | DDoS protection | DDoS Network Protection plan | Configurable |
| Logging | Central security telemetry | Log Analytics workspace with 90-day default retention | Implemented |
| Logging | Network diagnostics | Firewall logs and metrics sent to central workspace | Implemented |
| Logging | Activity log collection | Subscription activity logs routed to central Log Analytics | Implemented |
| Logging | Resource diagnostics | AuditIfNotExists policy for Azure Firewall and Azure Bastion diagnostic settings | Configurable |
| Governance | Monitoring and diagnostics enforcement | Policy assignments for locations, tags, public IPs, and diagnostics | Implemented |
| Detection | Critical deletion monitoring | Scheduled-query alert and security action group | Implemented |
| Identity | Least privilege | Group-based RBAC, PIM, managed identities | Operational control |
| Identity | Strong authentication | Phishing-resistant MFA and Conditional Access | Tenant control |
| Identity | Emergency access | Two cloud-only emergency accounts, monitored and tested | Tenant control |
| Data | Private service access | Private endpoints and disabled public network access | Workload control |
| Data | Encryption | Platform-managed encryption minimum; CMK where risk requires | Workload control |
| Vulnerability | Defender for Cloud | Defender plans for servers, storage, and Key Vault | Configurable |
| DevSecOps | IaC review | Pull requests, fmt/init/validate checks, reviewed plans | Implemented |
| Secrets | No static credentials | OIDC federation and managed identities | Pipeline control |
| Recovery | State protection | Versioning, soft delete, lock, restricted state account | Deployment prerequisite |

## Mandatory tenant controls

These controls are not safely provisioned through this AzureRM stack and must be
implemented in Microsoft Entra ID:

1. Require phishing-resistant MFA for privileged roles.
2. Block legacy authentication.
3. Use Privileged Identity Management for eligible administrative access.
4. Maintain two cloud-only emergency-access accounts with separate strong
   credentials and high-severity sign-in alerts.
5. Review guest access and privileged role assignments regularly.
6. Use workload identity federation for CI/CD.

## Policy rollout

Policy should progress through:

1. `audit` and impact analysis.
2. Remediation of existing resources.
3. `deny` for new noncompliant resources.
4. Time-bound exemptions with business owner and expiry.

The baseline immediately denies unapproved locations and public IPs in Corp.
Change these effects to audit during migration if existing resources would
otherwise block critical operations.

## Logging requirements

- Send Azure Activity logs from all subscriptions to the central workspace.
- Enable resource logs for identity, network, secrets, databases, compute, and
  security services.
- Protect logs from modification with least privilege and immutable archival
  where regulatory requirements apply.
- Tune retention and archive tiers to incident-response and compliance needs.

