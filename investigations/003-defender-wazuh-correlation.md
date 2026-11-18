# Case 003: Defender detection and quarantine in Wazuh

**Status:** Verified  
**Scope:** Authorized EICAR antivirus test on WIN11-01, November 17, 2026.

## Executive summary

Defender Real-Time Protection detected the EICAR test file and reported a
successful quarantine about 14 seconds later. Wazuh indexed both events for
WIN11-01 (`002`). The known test filename, threat signature, and authorized
test activity support closing the alert as an expected test detection.

## Detection and hypotheses

Defender labeled the signature `Virus:DOS/EICAR_Test_File` (threat ID
`2147519003`) and assigned it `Severe` severity. The signature and the exact
file path matched the planned test in Alex Morgan's lab account. The severity
label alone does not establish impact. The event payload named Alex in the
detection and `NT AUTHORITY\SYSTEM` in the remediation.

## Evidence and timeline

Times below come from Windows Event Viewer and are Eastern (UTC−05:00).
Record IDs come from the corresponding Wazuh documents.

| Local time | Event | Wazuh source record | Evidence |
| --- | --- | --- | --- |
| 23:24:48 | Defender 1116 detected the test file | 593 | [Endpoint](../evidence/phase-04/43-win11-local-defender-eicar-events.png), [Wazuh](../evidence/phase-04/45-win11-defender-detection-central.png) |
| 23:25:02 | Defender 1117 reported quarantine with error code `0x00000000` | 595 | [Endpoint](../evidence/phase-04/44-win11-local-defender-eicar-events-quarentine.png), [Wazuh](../evidence/phase-04/46-win11-defender-quarantine-central.png) |

## Investigation

In Threat Hunting, search the test window using:

```text
agent.id:"002" AND (data.win.system.eventID:"1116" OR data.win.system.eventID:"1117")
```

The two indexed documents match the local evidence by host, Defender channel,
event ID, threat ID, and the path to `ShahidTech-EICAR-Wazuh-Test.txt` under
Alex's temporary directory. The dashboard timestamps and Event Viewer times
are different fields, so this case does not use their difference to calculate
ingestion latency.

## ATT&CK mapping

No technique assigned. This exercise tested antivirus detection and reporting
with the authorized EICAR pattern.

## Response and recovery

Defender reported `Quarantine`, `No additional actions required`, and a
successful operation. The evidence for this run does not include a separate
original-path check. [Case 002](002-defender-eicar-test.md) documents that
check for the earlier local-only exercise.

## Detection validation

Expected and observed results were local 1116 and 1117 events and corresponding
indexed alerts. The screenshots capture the Windows event IDs and source
records. Wazuh rule IDs and exact source UTC timestamps were outside the capture.

## Interview walkthrough

I started with two SIEM alerts from the same endpoint and compared them with
Defender's Operational log. Event 1116 established detection in Alex's session.
Event 1117 showed that Defender, running as SYSTEM, reported successful
quarantine. The shared host, threat ID, and test path tied both records to the
authorized exercise. That let me close the case as a test and identify what I
would capture next time, including a separate original-path check.
