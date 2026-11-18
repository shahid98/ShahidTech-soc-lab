# Case 004: Controlled failed domain logon in Wazuh

**Status:** Verified  
**Scope:** One authorized incorrect-password `runas` attempt on WIN11-01 on November 18, 2026.

## Summary and disposition

WIN11-01 recorded Security event `4625` for the controlled attempt against
`SHAHIDTECH\alex.morgan`. Wazuh indexed the corresponding event for agent
`002`. The account, loopback source, and wrong-password substatus fit the
planned exercise. Closed as an expected test alert. No containment was performed.

## Evidence and correlation

| Source | Observation | Evidence |
| --- | --- | --- |
| WIN11-01 Security log | Event `4625`, record `13502`, November 18 at 17:21:18 Eastern | [Local event](../evidence/phase-05/01-win11-controlled-failed-logon-4625.png) |
| Wazuh Threat Hunting | Same host, channel, event ID and record ID. Windows source time `2026-11-18T22:21:18.3449146Z`. | [Indexed event](../evidence/phase-05/02-win11-failed-logon-wazuh-alert.png) |
| Wazuh Threat Hunting | Subsequent event `4624`, record `13504`, Windows source time `2026-11-18T22:21:27.3512718Z`. | [Failure and success in Wazuh](../evidence/phase-05/03-win11-logon-failure-and-success-wazuh.png) |

To find the event in Threat Hunting, use the relevant dashboard time range
and filter by the endpoint and Windows record fields:

```text
agent.id:"002" AND data.win.system.eventID:"4625" AND data.win.system.eventRecordID:"13502"
```

The dashboard row timestamp differs from the Windows source time. The
comparison uses `data.win.system.systemTime` and the source record ID.
Wazuh indexed the failure under rule `60122` (level 5) and the success
under rule `60118` (level 3).

## Analysis

- Logon type `2` indicates an interactive logon request. `::1` indicates IPv6 loopback.
- Status `0xC000006D` is a general logon failure. Substatus `0xC000006A` identifies an incorrect password.
- `Negotiate` and key length `0` leave the underlying authentication protocol unconfirmed.
- The surrounding search returned one failure and one success for Alex in
  the selected dashboard window. The source timestamps place the success
  about nine seconds after the failure.
- Both records share target account, logon type `2`, source `::1`, subject
  logon ID `0xc7b00`, caller PID `0x2494`, and logon process `seclogo`.
  The success created logon session `0x7fff83`. The shared context supports
  a retry, but the events alone do not establish why the success occurred.
- No brute-force technique was assigned.

## Domain-controller correlation

A Security log query on DC01 for `alex.morgan` returned two Kerberos
events in the investigation window. Both identify WIN11-01 by the client
address `::ffff:10.10.10.20` (IPv4 address `10.10.10.20`).

| DC01 event | Source time (UTC) | Result | Correlated WIN11-01 record |
| --- | --- | --- | --- |
| [4771, record 49719](../evidence/phase-05/04-dc01-authentication-correlation-failure.png) | `22:21:18.2733407` | Preauthentication failure, `0x18` | 4625, record 13502 |
| [4768, record 49720](../evidence/phase-05/04-dc01-authentication-correlation-success.png) | `22:21:27.2779797` | Successful TGT request, `0x0` | 4624, record 13504 |

The account, client address, outcome, and closely aligned source times
support both pairings and corroborate Kerberos involvement in the test.
The workstation's `::1` describes the local logon request, while the DC
record shows the workstation address as seen by DC01. The DC01 evidence
was verified locally in the Security log.


[Case 001](001-controlled-failed-logon.md) documents the earlier local-only test.
