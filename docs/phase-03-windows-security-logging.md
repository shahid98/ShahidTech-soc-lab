# Phase 3: Windows security telemetry

Status: In progress. Endpoint exercises verified on WIN11-01; equivalent DC01 coverage and centralized collection remain pending.

## Purpose and environment

Build enough endpoint visibility to explain who authenticated, which processes ran, what PowerShell processed, and how Defender responded. Validate actual events and outcomes rather than relying solely on configured policies.

WIN11-01 (10.10.10.20/24) is joined to ad.shahidtech.test. DC01 (10.10.10.10) provides AD DS and DNS. Both use the SOC-LAB Private switch with no default gateway in the steady-state lab configuration. Windows PowerShell tests use version 5.1. Exercises use fictional accounts and harmless test content.

## Reviewer walkthrough

1. Read the [failed-logon investigation](../investigations/001-controlled-failed-logon.md) for account, timestamp, failure-code interpretation, and limitations.
2. Read the [Defender EICAR investigation](../investigations/002-defender-eicar-test.md) for detection, remediation, and independent outcome verification.
3. Compare [Security 4688 with Sysmon 1](../evidence/phase-03/45-security-process-event-comparison.png), then follow the [network event](../evidence/phase-03/47-powershell-network-connection.png) back to its [process instance](../evidence/phase-03/48-network-process-guid-correlation.png).
4. Inspect the [versioned Sysmon configuration](../configs/sysmon/sysmon-lab.xml) and the collection limitations below.

## Telemetry and verified results

| Source | Evidence collected | What it does not prove alone |
| --- | --- | --- |
| Security 4624 / 4625 | Successful sessions and a controlled wrong-password failure | Malicious intent or the underlying protocol when the package is only Negotiate |
| DC01 Security 4768 | Successful Kerberos TGT requests for Alex from 10.10.10.20 | Unique linkage to a workstation session from timestamp alone |
| Security 4688 | Account, process, parent, and launch command line | Every subsequent interactive command or successful execution outcome |
| PowerShell 4104 | Script-block text | Completion, output, or intended effect |
| PowerShell 4103 | Cmdlet invocation and parameter binding | Every side effect of a pipeline |
| PowerShell transcript | Session input and displayed text output | Complete process activity or tamper-resistant preservation |
| Defender 1116 / 1117 | EICAR detection and successful quarantine | Protection against all malware |
| Sysmon 1 / 3 / 22 | Process metadata, selected connections, and observed DNS activity | Authentication success, packet contents, or universal DNS coverage |

## Central policy and validation

ShahidTech-Workstation-Auditing is linked to the workstations OU, enabled and not enforced. Verified settings include Logon Success/Failure, Process Creation Success, advanced-audit precedence, process command-line inclusion, Script Block Logging, Module Logging for *, and automatic transcription with the default per-user Documents destination.

Verification used the GPO configuration, fresh client policy results, effective audit/registry values, and actual generated records. The local policy editor's Not Configured display did not mean effective auditing was disabled.

Key evidence: [applied auditing policy](../evidence/phase-03/10-workstation-audit-policy-applied.png), [command line in 4688](../evidence/phase-03/16-process-commandline-4688.png), [4104 script text](../evidence/phase-03/18-powershell-scriptblock-4104.png), [4103 pipeline details](../evidence/phase-03/20-powershell-module-event-4103.png), and [transcript input/output](../evidence/phase-03/22-transcription-command-and-output.png).

A separate harmless file-write exercise confirmed the [actual file contents in Notepad](../evidence/phase-03/24-file-outcome-independent-check.png), supplementing recorded instructions.

## Sysmon configuration and correlation

The built-in Windows Sysmon optional feature was enabled, then its service installed with C:\LabTools\Sysmon\sysmon-lab.xml. The running configuration was inspected using sysmon.exe -c. Schema 4.91 is independent of the executable version.

Current explicit rules:

- ProcessCreate: empty exclude rule; no process exclusions.
- NetworkConnect: include images ending in \powershell.exe; pwsh.exe and other applications are outside this rule.
- DnsQuery: empty exclude rule; no DNS exclusions.
- SHA256 hashing enabled. Other event types must not be assumed disabled merely because they are absent from this XML; process-termination event 5 was also observed.

For the cmd.exe marker test, Security 4688 PID 0xed4 matched Sysmon PID 3796; parent PID 0x930 matched 2352. Host, time, identity, command line, and process identifiers supported correlation. A hash identifies file contents, not whether a particular use is benign.

For the network test, ProcessGuid {3d3dad4e-cbfc-6afb-3b03-000000000a00} linked PowerShell's creation to its connection from 10.10.10.20:49854 to 10.10.10.10:389 about 46 seconds later. This establishes recorded connection metadata, not successful LDAP authentication. Child processes have their own ProcessGuid and refer to the parent through ParentProcessGuid.

## Troubleshooting and evidence limits

| Observation | Investigation and result |
| --- | --- |
| DC01 and workstation events appeared three hours apart | Verified Pacific versus Eastern display zones, normalized timestamps to UTC, then standardized DC01 to Eastern. This was a time-zone issue, not demonstrated clock drift. |
| Security log still reported 20 MiB after successful gpupdate | Client report confirmed the 128 MiB policy and winning GPO. After a normal restart, active capacity reported 128 MiB. No log clearing was performed. |
| Update-MpSignature returned RPC error 0x800706be | Subsequent status showed fresh signatures and enabled real-time protection. The mechanism that refreshed signatures was not established. Temporary update networking was removed. |
| nslookup returned an answer with initial timeouts and Unknown server | Exact forward A query worked; reverse query timed out and reverse zone was absent. Created an AD-integrated secure-update reverse zone and DC01 PTR. Exact forward and reverse retests then succeeded without timeouts. Original non-trailing-dot behavior was not retested. |
| nslookup process existed without matching Sysmon DNS event | Expanded DNS filtering beyond PowerShell; additional background processes and a PowerShell positive control produced event 22. No nslookup-attributed record was observed in the inspected attempts. The exact visibility-gap cause remains unconfirmed. |

DNS evidence: [missing reverse zone](../evidence/phase-03/55-reverse-zone-missing.png), [zone and PTR](../evidence/phase-03/56-reverse-zone-and-ptr-created.png), [successful retest](../evidence/phase-03/57-dns-reverse-and-forward-retest.png), [expanded process coverage](../evidence/phase-03/61-expanded-dns-process-coverage.png), and [positive control](../evidence/phase-03/62-dns-collection-positive-control.png).

## Retention and preservation

| WIN11-01 channel | Verified maximum | Mode / management |
| --- | --- | --- |
| Security | 128 MiB | Circular; domain GPO |
| Windows PowerShell Operational | 64 MiB | Circular; local change |
| Sysmon Operational | 64 MiB | Circular; inspected and retained |
| Defender Operational | 16 MiB | Circular; inspected and retained |

Security records spanned 41.97 hours at one measurement. This is an observed range, not a retention guarantee or proof of uninterrupted collection. No event 255 records were found in the retained Sysmon log; this does not establish zero historical loss.

Raw logs and transcripts stay outside Git. Screenshots are reviewed examples, not forensic originals. Transcripts in a user's Documents folder are not centrally protected against modification or deletion. Independent VM backup remains unavailable; snapshots and Git history are not substitutes.

## Remaining work

- Verify equivalent required telemetry on DC01; do not extrapolate workstation settings to the domain controller.
- Build and validate Wazuh forwarding, agent health, and ingestion for each source.
- Define central retention, access control, integrity protection, and collection-failure monitoring.
- Expand and test telemetry according to investigation needs, recording volume and coverage tradeoffs.
- Keep the nslookup visibility limitation explicit until additional evidence establishes its cause.

## Interview explanation

I configured workstation auditing through Group Policy and validated it using generated events, not just policy reports. I investigated a controlled failed logon and a harmless Defender test, then correlated Security and Sysmon process records and linked a network connection to its process GUID. I also diagnosed time-zone, DNS, and log-capacity issues. Central SIEM collection and broader server coverage are the next steps; current evidence is local endpoint validation.

For the complete chronological record, see the [progress tracker](progress.md). Historical checkpoints describe the state at their time; later entries supersede earlier pending items.
