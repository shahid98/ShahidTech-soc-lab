# scripts

Add verified work here. Document purpose, prerequisites, actual results, and links to supporting lessons or cases. Review all files for sensitive information before staging. Keep raw logs and VM files outside Git.

## Windows logging baseline

[Test-WindowsLoggingBaseline.ps1](Test-WindowsLoggingBaseline.ps1) checks
whether the local Security, Windows PowerShell Operational, and Sysmon
Operational channels are enabled, circular, and sized to the lab baseline.
It reports the newest retained record for each required event ID using
metadata only.

Run from elevated Windows PowerShell 5.1 on the target VM:

```powershell
.\Test-WindowsLoggingBaseline.ps1 |
    Format-Table Computer, EventId, Enabled, SizeMiB, Mode, Configuration, EventCheck, RecordId -AutoSize
```

| Channel | Minimum size | Event IDs | WIN11-01 | DC01 |
| --- | --- | --- | --- | --- |
| Security | 128 MiB | 4688 | Found, record 13688 | Found, record 50321 |
| Windows PowerShell Operational | 64 MiB | 4103, 4104 | Found, records 12658 and 12659 | Found, records 2128 and 2127 |
| Sysmon Operational | 64 MiB | 1 | Found, record 8091 | Found, record 5854 |

All three channels were enabled and circular on both hosts and met the
minimum sizes. A retained event confirms local availability at the time
of the check. Central delivery and continuous collection require separate tests.

[WIN11-01 output](../evidence/phase-07/01-win11-windows-logging-baseline.png) ·
[DC01 output](../evidence/phase-07/02-dc01-windows-logging-baseline.png)

## Wazuh agent health

[Test-WazuhAgentHealth.ps1](Test-WazuhAgentHealth.ps1) reports the status
of `WazuhSvc`, the agent's local connection state, and TCP reachability
to the manager. It expects the standard Windows Wazuh agent install path.
Run from elevated Windows PowerShell 5.1 on the target VM:

```powershell
.\Test-WazuhAgentHealth.ps1 -ManagerAddress 10.10.10.30 -Port 1514 | Format-List
```

Both WIN11-01 and DC01 reported `Running`, `connected`, and `True` for TCP
reachability to `10.10.10.30:1514`. This is a point-in-time connection
check. Use a fresh endpoint event to verify delivery and indexing.

[WIN11-01 output](../evidence/phase-07/03-win11-wazuh-agent-health.png) ·
[DC01 output](../evidence/phase-07/04-dc01-wazuh-agent-health.png)
