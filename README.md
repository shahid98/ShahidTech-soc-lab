# ShahidTech Enterprise SOC Lab

A practical security operations learning project for ShahidTech, a fictional 50-person company.

**Status: Phase 4 in progress. Wazuh receives Sysmon and PowerShell events from DC01 and WIN11-01. WIN11-01 Defender detection and quarantine events have been verified in Wazuh Threat Hunting.**

## Start here

- [Progress and roadmap](docs/progress.md)
- [Windows security logging guide and evidence](docs/phase-03-windows-security-logging.md)
- [Case 001: controlled failed logon](investigations/001-controlled-failed-logon.md)
- [Case 002: Defender detection and quarantine](investigations/002-defender-eicar-test.md)
- [Planned architecture](docs/architecture.md)
- [Git workflow](docs/git-workflow.md)
- [Lesson template](templates/lesson.md)
- [Investigation template](templates/investigation.md)

## Portfolio walkthrough

Explain the business problem, show the architecture, trace an event from endpoint to SIEM, present your investigation and response, and discuss a limitation and improvement. Link your strongest verified case studies here as you complete them.

Every exercise should explain: objective, implementation, verification, evidence, troubleshooting, and lessons learned. Label simulations clearly. Claim only work backed by actual results.

## Scope

Testing is limited to owned, authorized lab systems on an isolated network. Publish sanitized evidence only. Store VM files and external backups outside Git. Snapshots do not replace backups.
