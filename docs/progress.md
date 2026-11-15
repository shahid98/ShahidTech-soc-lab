# Progress tracker

| Phase | Deliverable | Status |
| --- | --- | --- |
| 0 - Planning and virtualization | Host assessment, network design, recovery plan | In Progress |
| 1 - Windows Server and AD | Working domain, DNS, users, groups, GPO | In Progress |
| 2 - Workstation | Verified domain join and policy application | Not started |
| 3 - Security logging | Windows, Sysmon, PowerShell telemetry | Not started |
| 4 - Wazuh | Centralized logs and agent connectivity | Not started |
| 5 - SOC investigations | Evidence-backed incident reports | Not started |
| 6 - Detection engineering | Tested rules and ATT&CK mappings | Not started |
| 7 - PowerShell | Documented, verified administration scripts | Not started |
| 8 - Entra ID | Cloud identity security exercises | Not started |
| 9 - Defender and Sentinel | Hunting and investigation exercises | Not started |
| 10 - Portfolio | Curated case studies and interview practice | Not started |

### Phase 0 checkpoint — VM storage configured

- Host: Windows 11 Pro; Ryzen 7 8845HS; 27.8 GB usable RAM.
- Reported free storage: C: 259.16 GB; D: 99.8 GB.
- Hyper-V feature: Enabled.
- Running hypervisor detected: True.
- SOC-LAB: Private switch, verified with Get-VMSwitch.
- Hyper-V default configuration path: C:\SOC-Lab\VirtualMachines
- Hyper-V default virtual disk path: C:\SOC-Lab\VirtualHardDisks
- Installation media folder: C:\SOC-Lab\ISO
- Verified default paths with Get-VMHost.
- Get-VM returned no registered virtual machines.
- Default Switch: Internal; unchanged.
- No virtual machines created yet.
- Phase 0 remains completed.

### DC01 domain promotion — baseline verified

- Created forest/domain: ad.shahidtech.test.
- NetBIOS name: SHAHIDTECH.
- Forest and domain functional levels configured as Windows Server 2025.
- NTDS and DNS services verified Running.
- LDAP domain-controller SRV record resolves to dc01.ad.shahidtech.test:389.
- DC01 hostname resolves to 10.10.10.10.
- SYSVOL and NETLOGON shares verified present.
- dcdiag passed Connectivity, Advertising, SysVolCheck, and NetLogons.
- DNS delegation warning accepted because no parent DNS zone exists in this isolated lab.
- Pre-AD checkpoint exists; no independent backup available.
- Evaluation activation and updates remain pending.
- Phase 1 remains in progress.

## Decisions

2026-11-14: Repository name: shahidtech-soc-lab. Documentation scaffold only; Git initialized.



## Session log

After each lesson, record date, change, verification result, evidence link, known issues, next step, and relevant snapshot/external backup. Mark completion only after verification. Record restore checks separately.
