# Operations

## Ownership

| Capability | Accountable team |
|---|---|
| Management groups and policy | Cloud governance |
| Hub networking, DNS, and firewall | Network platform |
| Central monitoring and alert routing | Cloud operations |
| Entra ID and privileged access | Identity and security |
| Application subscriptions | Workload teams with platform guardrails |
| Terraform modules and pipelines | Platform engineering |

## Routine cadence

- Daily: Review critical security and availability alerts.
- Weekly: Review policy compliance, failed deployments, and cost anomalies.
- Monthly: Patch platform-managed systems, review Defender recommendations,
  inspect firewall rules, and review budgets.
- Quarterly: Review privileged access, policy exemptions, architecture drift,
  recovery procedures, and approved regions.
- Annually: Revalidate the landing-zone design against CAF and regulatory
  requirements.

## Change process

1. Open a pull request with code, design decision, cost impact, and rollback.
2. Run formatting, initialization, validation, security scanning, and plan.
3. Obtain platform and security approval for policy or network changes.
4. Apply through federated CI identity.
5. Validate policy compliance, logs, alerts, routes, and service health.

## Subscription vending minimum

Each application landing-zone request should capture:

- Workload and business owner
- Environment and criticality
- Corp or Online classification
- Data classification and regulatory scope
- Region and network requirements
- Cost center and budget
- Platform integrations
- Recovery objectives

