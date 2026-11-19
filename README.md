# ShahidTech Enterprise SOC Lab

A practical security operations learning project for ShahidTech, a fictional 50-person company.

**Status: Phase 6 complete. The portfolio includes evidence-backed Defender and domain-authentication investigations, plus live-tested Wazuh rules for single and repeated incorrect-password logons. Phase 7 covers PowerShell administration scripts.**

## Start here

- [Progress and roadmap](docs/progress.md)
- [Windows security logging guide and evidence](docs/phase-03-windows-security-logging.md)
- [Case 001: controlled failed logon](investigations/001-controlled-failed-logon.md)
- [Case 002: Defender detection and quarantine](investigations/002-defender-eicar-test.md)
- [Case 003: Defender detection and quarantine in Wazuh](investigations/003-defender-wazuh-correlation.md)
- [Case 004: Controlled failed domain logon in Wazuh](investigations/004-failed-logon-wazuh-correlation.md)
- [Wazuh detection rules and validation](detections/README.md)
- [Planned architecture](docs/architecture.md)
- [Git workflow](docs/git-workflow.md)
- [Lesson template](templates/lesson.md)
- [Investigation template](templates/investigation.md)

## Portfolio walkthrough

Explain the business problem, show the architecture, trace an event from endpoint to SIEM, present your investigation and response, and discuss a limitation and improvement. Link your strongest verified case studies here as you complete them.

Every exercise should explain: objective, implementation, verification, evidence, troubleshooting, and lessons learned. Label simulations clearly. Claim only work backed by actual results.

## Scope

Testing is limited to owned, authorized lab systems on an isolated network. Publish sanitized evidence only. Store VM files and external backups outside Git. Snapshots do not replace backups.
