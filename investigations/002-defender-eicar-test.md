# Case 002: Defender EICAR detection and quarantine

Status: Verified authorized lab test
Host: WIN11-01
Date: 2026-11-16
Time zone: Eastern (UTC-05:00)

## Summary

A harmless EICAR test file created through PowerShell as
SHAHIDTECH\alex.morgan triggered Defender Real-Time Protection.
Defender reported successful quarantine, and the file was no
longer present at its original path.

## Scope

Authorized antivirus validation on the isolated SOC-LAB network.
EICAR is a test pattern; this exercise did not involve real malware.

An earlier test used the Administrator profile. This report
covers the separate Alex-profile attempt at approximately 20:37.

## Timeline

| Time, Eastern | Observation |
|---|---|
| 20:37:37 | Event 1116 detected Virus:DOS/EICAR_Test_File |
| 20:37:50 | Event 1117 reported successful quarantine |
| After remediation | Alex's Test-Path check returned False |

The recorded interval between detection and remediation was 13 seconds.

## Evidence

- [Test identity and command](../evidence/phase-03/37-eicar-alex-test.png)
- [Protection History](../evidence/phase-03/38-eicar-alex-quarantined.png)
- [Detection and remediation events](../evidence/phase-03/39-eicar-detection-and-remediation-events.png)
- [Original path absent](../evidence/phase-03/40-eicar-original-path-absent.png)

## Findings

- Affected path:
  C:\Users\alex.morgan\AppData\Local\Temp\ShahidTech-EICAR-Test.txt
- Detection source: Real-Time Protection.
- Associated process: Windows PowerShell.
- Detection user: SHAHIDTECH\alex.morgan.
- Remediation context: NT AUTHORITY\SYSTEM.
- Action: Quarantine.
- Error code: 0x00000000.
- Action status: No additional actions required.
- Security intelligence version: 1.463.334.0.

SYSTEM in the remediation record does not identify the file's creator.
The missing file supports the remediation evidence but would not,
by itself, establish quarantine.

## Disposition

Expected detection from an authorized test. Left quarantined;
no restore or allow action performed.

## Limitations

This validates one known test pattern and its recorded response.
It does not establish protection against all malware.
Centralized SIEM collection has not yet been verified.

## Interview takeaway

I correlated Defender detection and remediation events with
Protection History and an independent original-path check,
while distinguishing the initiating user from remediation context.