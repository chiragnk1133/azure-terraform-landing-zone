# Cost Estimate

## Important caveat

This is a planning estimate, not a quote. Azure pricing varies by region,
currency, agreement, reservations, data volume, rules, and traffic. Validate the
final design in the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
for the deployment region on the day of approval.

## Baseline monthly planning range (USD)

Assumptions: one region, 730 hours/month, 100 GB/month Log Analytics ingestion,
90-day interactive retention, light automation usage, low network processing,
and no workload resources.

| Component | Quantity | Planning estimate/month |
|---|---:|---:|
| Management groups and Azure Policy | N/A | $0 |
| Log Analytics ingestion | 100 GB | $250-$350 |
| Log retention beyond included allowance | Usage dependent | $0-$50 |
| Azure Monitor alerts and queries | Light usage | $10-$50 |
| Azure Automation | Light usage | $0-$20 |
| Azure Firewall Standard | 730 hours plus data | $900-$1,300 |
| Standard public IPs | 1 | $3-$5 |
| **Default baseline total** | | **$1,163-$1,775** |

## Optional monthly additions

| Optional service | Planning estimate/month |
|---|---:|
| Azure Bastion Standard | $200-$400 plus outbound data |
| VPN Gateway `VpnGw1AZ` | $150-$250 plus data |
| DDoS Network Protection | $2,500-$3,500, subject to plan pricing |
| Defender for Servers Plan 2 | Per protected server |
| Defender for Storage | Per storage account and/or transactions |
| Defender for Key Vault | Per protected vault/transactions |
| Microsoft Sentinel | Ingestion, analytics, and retention dependent |
| Second regional hub | Approximately another regional network baseline |

## Primary cost drivers

1. Azure Firewall runtime and processed data.
2. Log Analytics ingestion and retention.
3. Defender plans multiplied by protected resources.
4. DDoS Network Protection.
5. Cross-region and internet data transfer.

## Cost controls

- Set subscription budgets at 50%, 75%, 90%, and 100%.
- Enable cost anomaly alerts.
- Require `CostCenter`, `Owner`, and `Environment` tags.
- Use commitment tiers only after ingestion is stable.
- Route verbose logs selectively and use archive for long retention.
- Keep optional platform services disabled until requirements justify them.
- Review firewall and logging costs monthly.

