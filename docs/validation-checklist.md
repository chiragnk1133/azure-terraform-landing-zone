# Validation Checklist

## Before plan

- [ ] Tenant and all subscription IDs are correct.
- [ ] Parent management group exists.
- [ ] Deployment identity permissions are approved.
- [ ] State backend is private, protected, and accessible.
- [ ] Allowed regions satisfy data residency requirements.
- [ ] Hub address space is approved and non-overlapping.
- [ ] Security and ownership contacts are monitored.
- [ ] Optional services have cost approval.

## Plan review

- [ ] No subscription is moved unexpectedly.
- [ ] No existing policy assignment is replaced.
- [ ] Deny policies have been impact-assessed.
- [ ] Resource names and regions are correct.
- [ ] Firewall, Bastion, VPN, DDoS, and Defender flags match approval.
- [ ] Estimated monthly cost is accepted.

## After apply

- [ ] Management-group hierarchy and subscription placement are correct.
- [ ] Policy assignments report compliance data.
- [ ] Central workspace receives Azure Activity and firewall logs.
- [ ] Security alert notification is tested.
- [ ] Firewall threat intelligence and DNS proxy are validated.
- [ ] Budgets and anomaly alerts exist.
- [ ] Privileged access and emergency accounts are tested.
- [ ] Terraform state and pipeline audit logs are protected.

