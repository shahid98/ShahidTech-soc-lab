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

### AD organization and first employee — verified

- Created ShahidTech OU at the domain root.
- Created Employees and workstations child OUs.
- Verified accidental-deletion protection on all three OUs.
- Created fictional employee Alex Morgan in Employees.
- Sign-in name: alex.morgan@ad.shahidtech.test.
- Account enabled; password change required at next sign-in.
- Verified group membership: Domain Users only.
- Employee workstation sign-in remains untested.
- DC01 remains in the Domain Controllers OU.

### Employee security group — verified

- Created GG-ShahidTech-Employees as a Global security group.
- Added alex.morgan.
- Verified Alex's memberships: Domain Users and GG-ShahidTech-Employees.
- No resource permissions assigned to the employee group yet.
- Reviewed OU organization, group-based access, and least privilege.

### Employee share — configured; client testing pending

- Created DL-EmployeeShare-Read as a Domain Local security group.
- Nested GG-ShahidTech-Employees inside it.
- Verified recursive membership resolves to alex.morgan.
- Created C:\LabShares\EmployeeShare on DC01 for this lab exercise.
- Disabled NTFS inheritance while preserving existing entries.
- Removed BUILTIN\Users permission entries.
- Granted DL-EmployeeShare-Read inheritable Read & execute.
- Published EmployeeShare with share-level Read for the access group.
- Administrators retain Full Control at share and NTFS levels.
- Created welcome.txt and verified inherited read permissions.
- Pending: verify Alex can read but cannot create, modify, or delete files.
- Lab limitation: file sharing is hosted on the domain controller.

### WIN11-01 — domain sign-in and Enhanced Session verified

- Installed Windows 11 Pro; Windows computer name is WIN11-01.
- Configured 10.10.10.20/24 with DNS 10.10.10.10 and no gateway.
- Verified domain-controller DNS discovery from the workstation.
- Joined ad.shahidtech.test; verified PartOfDomain is True.
- Signed in as SHAHIDTECH\alex.morgan; logon server was DC01.
- Enhanced Session initially denied Alex remote logon.
- Added Alex to WIN11-01's local Remote Desktop Users group.
- Confirmed Enhanced Session works without granting Alex administrator privileges.
- Employee-share read and denied-write tests remain pending.

#### Troubleshooting evidence

![Enhanced Session remote-logon denial](../evidence/phase-02/04-enhanced-session-access-denied.png)

## Decisions

2026-11-14: Repository name: shahidtech-soc-lab. Documentation scaffold only; Git initialized.



## Session log

After each lesson, record date, change, verification result, evidence link, known issues, next step, and relevant snapshot/external backup. Mark completion only after verification. Record restore checks separately.
