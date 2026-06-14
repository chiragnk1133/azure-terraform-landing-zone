# CAF Design Decisions

| CAF design area | Baseline decision |
|---|---|
| Billing and tenant | One Microsoft Entra tenant; existing subscriptions are supplied as inputs. Enrollment and subscription creation remain organizational prerequisites. |
| Identity and access | Entra ID is the control plane identity provider. Use groups, workload identities, PIM, Conditional Access, and two emergency-access accounts. Avoid standing individual Owner assignments. |
| Resource organization | Separate platform subscriptions and management groups. One application landing-zone subscription per workload environment is the preferred starting model. |
| Network topology | Hub-and-spoke with a connectivity-owned regional hub. Private endpoints and centralized egress are preferred. |
| Security | Microsoft Cloud Security Benchmark policy initiative, location restriction, tag audits, and public-IP denial in Corp. Defender plans are configurable. |
| Observability | Central Log Analytics, subscription activity logs, firewall and Bastion diagnostics, and policy-based monitoring guardrails. |
| Management | Central Log Analytics, alert action group, Azure Automation identity, and security alert example. |
| Governance | Policy inheritance at management-group scope. Exceptions use policy exemptions rather than editing shared definitions. |
| Platform automation | Terraform, remote state, pull-request validation, provider pinning, and reviewed plans. |

## Assumptions

- The organization has three existing platform subscriptions.
- The deployment identity can create management groups beneath the supplied
  parent and can assign subscriptions.
- Address space does not overlap with on-premises or other Azure networks.
- `eastus2` and `centralus` are examples, not compliance recommendations.
- The identity subscription is intentionally empty until an identity
  architecture decision is approved.

## Explicitly excluded

- Billing enrollment and subscription vending implementation
- Tenant creation, custom domains, Conditional Access, and PIM configuration
- Enterprise DNS resolver and private DNS zone inventory
- ExpressRoute circuits and provider-side configuration
- SIEM/SOAR deployment
- Backup vaults and workload recovery policies
- Application spokes and workload resources

These items require tenant, regulatory, network, and workload requirements that
cannot be safely inferred.

