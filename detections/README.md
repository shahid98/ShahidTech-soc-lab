# detections

Add verified work here. Document purpose, prerequisites, actual results, and links to supporting lessons or cases. Review all files for sensitive information before staging. Keep raw logs and VM files outside Git.

## Wazuh rule 100100 — incorrect Windows password

[Rule XML](100100-windows-incorrect-password.xml) · [Investigation context](../investigations/004-failed-logon-wazuh-correlation.md) · [Built-in rule baseline](../evidence/phase-06/01-wazuh-failed-logon-rule-baseline.png)

The rule requires built-in parent `60122`, Windows event `4625`, and
substatus `0xC000006A` (incorrect password). It preserves alert level 5.
Wazuh must receive the Windows Security event channel. Deploy the XML in
`/var/ossec/etc/rules/`, validate with `sudo /var/ossec/bin/wazuh-analysisd -t`,
and restart `wazuh-manager` after validation passes.

Both live tests ran as single controlled attempts on WIN11-01 (`002`).

| Test | Source record | Substatus | Indexed rule | Evidence |
| --- | --- | --- | --- | --- |
| Known account, incorrect password | 13607 | `0xc000006a` | `100100`, level 5 | [Positive match](../evidence/phase-06/02-wazuh-incorrect-password-rule-positive.png) |
| Unknown account | 13614 | `0xc0000064` | `60122`, level 5 | [Negative comparison](../evidence/phase-06/03-wazuh-incorrect-password-rule-negative.png) |

The unknown-account alert confirms the negative input reached Wazuh and
matched the built-in parent. A single incorrect-password event records a
credential failure. This rule adds no ATT&CK mapping because the event
alone provides insufficient evidence of an adversary technique.
