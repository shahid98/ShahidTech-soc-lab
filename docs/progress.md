# Progress tracker

| Phase | Deliverable | Status |
| --- | --- | --- |
| 0 - Planning and virtualization | Host assessment, network design, recovery plan | In Progress |
| 1 - Windows Server and AD | Working domain, DNS, users, groups, GPO | Not started |
| 2 - Workstation | Verified domain join and policy application | Not started |
| 3 - Security logging | Windows, Sysmon, PowerShell telemetry | Not started |
| 4 - Wazuh | Centralized logs and agent connectivity | Not started |
| 5 - SOC investigations | Evidence-backed incident reports | Not started |
| 6 - Detection engineering | Tested rules and ATT&CK mappings | Not started |
| 7 - PowerShell | Documented, verified administration scripts | Not started |
| 8 - Entra ID | Cloud identity security exercises | Not started |
| 9 - Defender and Sentinel | Hunting and investigation exercises | Not started |
| 10 - Portfolio | Curated case studies and interview practice | Not started |

### Phase 0 checkpoint — isolated switch verified

- Host: Windows 11 Pro; Ryzen 7 8845HS; 27.8 GB usable RAM.
- Reported free storage: C: 259.16 GB; D: 55.16 GB.
- Hyper-V feature: Enabled.
- Running hypervisor detected: True.
- SOC-LAB: Private switch, verified with Get-VMSwitch.
- Default Switch: Internal; unchanged.
- No virtual machines created yet.
- Phase 0 remains in progress.

## Current task

Record host OS edition, CPU model, installed RAM, available disk space, and virtualization support before choosing a hypervisor. Exclude serial numbers and personal identifiers from public documentation.

## Decisions

2026-11-14: Repository name: shahidtech-soc-lab. Documentation scaffold only; Git not initialized.

## Known issues

Git is unavailable in the terminal and was not found in common installation locations. Hardware and hypervisor remain unverified.

## Session log

After each lesson, record date, change, verification result, evidence link, known issues, next step, and relevant snapshot/external backup. Mark completion only after verification. Record restore checks separately.
