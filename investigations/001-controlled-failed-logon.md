# Case 001: Controlled failed domain-account logon

Status: Verified lab exercise
Classification: Authorized test; no incident established

## Summary

A single deliberate incorrect-password runas attempt on WIN11-01
produced Security event 4625 for SHAHIDTECH\alex.morgan.
The observed event is consistent with the controlled test.

## Scope and objective

Generate one failed authentication attempt and investigate its
endpoint evidence. Testing was limited to the isolated ShahidTech lab.

## Timeline

| Time, Eastern (UTC-05:00) | Observation |
|---|---|
| 2026-11-15 20:30:12 | Test timestamp recorded before running runas |
| 2026-11-15 20:30:23 | WIN11-01 recorded event 4625 |

The command returned error 1326: user name or password incorrect.

## Evidence

- [Controlled runas attempt](../evidence/phase-03/07-controlled-runas-failure.png)
- [Event 4625](../evidence/phase-03/08-alex-failed-logon-4625.png)

| Field | Observed value |
|---|---|
| Failed account | SHAHIDTECH\alex.morgan |
| Logon Type | 2 — Interactive |
| Status | 0xC000006D — logon failure |
| SubStatus | 0xC000006A — incorrect password |
| Source address | ::1 — IPv6 loopback |
| Logon Process | seclogo |
| Caller Process | C:\Windows\System32\svchost.exe |
| Authentication Package | Negotiate |
| Key Length | 0 |

## Analysis

The account, timing, interactive logon type, loopback address, and
incorrect-password substatus support correlation with the runas test.

Type 2 does not require a desktop sign-in. The caller process path
alone does not establish whether activity is benign or malicious.

Negotiate and Key Length 0 do not conclusively identify Kerberos
or NTLM.

## Disposition and response

Expected outcome of an authorized test. No containment performed.
The single observed failure does not establish brute-force activity.

## Limitations and next checks

This report examines one endpoint event, not a comprehensive search
for other activity. A real investigation would review surrounding
failures, subsequent successes, source systems, and relevant
domain-controller evidence.

## ATT&CK assessment

No adversary technique assigned: this single authorized failed
attempt does not establish brute force.

## Lesson learned

Distinguish observed facts from inference, correlate timestamps,
and use failure substatus to refine a general error.