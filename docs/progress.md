# Progress tracker

| Phase | Deliverable | Status |
| --- | --- | --- |
| 0 - Planning and virtualization | Host assessment, network design, recovery plan | In Progress |
| 1 - Windows Server and AD | Working domain, DNS, users, groups, GPO | In Progress |
| 2 - Workstation | Verified domain join and policy application | In Progress |
| 3 - Security logging | Windows, Sysmon, PowerShell telemetry | In Progress |
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

### Employee share — client access validated

Tested from WIN11-01 as SHAHIDTECH\alex.morgan:

| Operation | Observed result |
|---|---|
| Read welcome.txt | Allowed |
| Create alex-write-test.txt | Access denied |
| Append to welcome.txt | Access denied |
| Delete delete-test.txt | Access denied; file remained |
| Re-read welcome.txt | Original two lines unchanged |

Access follows Alex → GG-ShahidTech-Employees →
DL-EmployeeShare-Read → resource permissions.

These SMB tests validate combined share and NTFS restrictions;
they do not isolate either permission layer.

#### Evidence

- [Successful read](../evidence/phase-02/06-employee-share-read-success.png)
- [Creation denied](../evidence/phase-02/07-employee-share-create-denied.png)
- [Modification denied](../evidence/phase-02/08-employee-share-modify-denied.png)
- [Deletion denied](../evidence/phase-02/09-employee-share-delete-denied.png)


### Workstation Group Policy — delivery verified

- Moved WIN11-01 from Computers into ShahidTech/workstations.
- Created ShahidTech-Workstation-Baseline.
- Configured the computer sign-in notice title and text.
- Linked the GPO to workstations; link enabled, not enforced.
- Verified gpresult lists the GPO as applied from DC01.
- Verified legalnoticecaption and legalnoticetext match the policy.
- Confirmed the notice appears before sign-in.
- This notice demonstrates policy delivery; it does not enforce access restrictions.

#### Evidence

- [Computer OU placement](../evidence/phase-02/10-workstation-ou-placement.png)
- [GPO settings](../evidence/phase-02/11-gpo-signin-notice-settings.png)
- [Applied policy](../evidence/phase-02/12-gpo-applied-result.png)
- [Visible notice](../evidence/phase-02/13-gpo-signin-notice-visible.png)

### Workstation domain trust — verified

- Test-ComputerSecureChannel -Verbose returned True on WIN11-01.
- Confirmed the secure channel to ad.shahidtech.test is healthy.
- RSOP identified ShahidTech-Workstation-Baseline as the source of the sign-in notice settings.
- Reviewed GPO linking versus the separate Enforced option.

[Secure-channel verification](../evidence/phase-02/14-domain-secure-channel.png)

### Authentication telemetry and time-zone correlation — verified

- WIN11-01 effective Logon auditing: Success and Failure.
- DC01 effective Kerberos Authentication Service, Kerberos Service
  Ticket Operations, and Credential Validation auditing: Success.
- Local policy GUI showed Not Configured; this did not mean
  effective auditing was disabled.
- Observed event 4624 for SYSTEM with Logon Type 5 (service).
- Observed event 4624 for alex.morgan with Logon Type 10
  (RemoteInteractive), consistent with Enhanced Session activity.
- Negotiate and Key Length 0 alone did not establish the protocol.
- DC01 recorded successful Kerberos TGT requests (4768) for Alex
  from 10.10.10.20, with Result Code 0x0.
- Initial event displays differed because DC01 used Pacific Time
  and WIN11-01 used Eastern Time.
- After UTC normalization, a TGT request and workstation logon
  shared timestamp 2026-11-15T21:37:14Z.
- Matching account, client IP, and time support correlation;
  a timestamp match alone is not a unique session identifier.
- Changed DC01 to Eastern Time and verified the existing latest
  TGT event displays 4:37:16 PM instead of 1:37:16 PM.
- Phase 3 remains in progress.

### Controlled failed logon — verified

- Test: one deliberate incorrect-password runas attempt as alex.morgan.
- Test started: 2026-11-15T20:30:12-05:00.
- Event 4625 recorded on WIN11-01 at 20:30:23 Eastern.
- Logon Type 2; source ::1; logon process seclogo.
- Status 0xC000006D; SubStatus 0xC000006A (incorrect password).
- Result is consistent with the authorized test, not evidence of brute force.
- Underlying authentication protocol remains unconfirmed.

[Controlled attempt](../evidence/phase-03/07-controlled-runas-failure.png)
[Failed-logon event](../evidence/phase-03/08-alex-failed-logon-4625.png) 

### Centralized workstation logon auditing — verified

- Created ShahidTech-Workstation-Auditing.
- Defined Audit Logon: Success and Failure.
- Enabled audit subcategory settings to override legacy categories.
- Linked the GPO to workstations; enabled, not enforced.
- Refreshed computer policy on WIN11-01 successfully.
- Fresh gpresult output lists the auditing GPO as applied from DC01.
- auditpol confirms effective Logon auditing: Success and Failure.
- SCENoApplyLegacyAuditPolicy verified as 1.
- Logon auditing was already enabled before deployment; this
  milestone explicitly defines and delivers the intended policy centrally.

[Audit GPO settings](../evidence/phase-03/09-workstation-audit-gpo-settings.png)
[Client verification](../evidence/phase-03/10-workstation-audit-policy-applied.png)

### Process creation and command-line logging — verified

- Initial effective Process Creation policy: No Auditing.
- Enabled Audit Process Creation: Success in the workstation auditing GPO.
- Refreshed WIN11-01 and verified effective auditing: Success.
- Observed event 4688 for Alex launching cmd.exe; command line was initially blank.
- Enabled Include command line in process creation events centrally.
- Verified client ProcessCreationIncludeCmdLine_Enabled value: 1.
- Generated a harmless cmd.exe /c echo ShahidTech-4688-Test invocation.
- Event 4688 recorded Alex, explorer.exe as parent, Medium integrity,
  and the expected command line.
- Command-line logging captures launch arguments, not every command
  subsequently entered into an interactive shell.

[Before configuration](../evidence/phase-03/11-process-creation-audit-before.png)
[GPO setting](../evidence/phase-03/12-process-creation-gpo-setting.png)
[Effective audit policy](../evidence/phase-03/13-process-creation-audit-applied.png)
[Initial process event](../evidence/phase-03/14-cmd-process-created-4688.png)
[Command-line setting applied](../evidence/phase-03/15-commandline-logging-enabled.png)
[Command line recorded](../evidence/phase-03/16-process-commandline-4688.png)

### Windows PowerShell Script Block Logging — verified

- Windows PowerShell Operational channel enabled on WIN11-01.
- ShahidTech-Workstation-Auditing defines EnableScriptBlockLogging
  as DWORD 1.
- Refreshed client policy and verified the client value is 1.
- Executed Write-Output "ShahidTech-4104-Test" as Alex.
- Event 4104 recorded the exact script text at
  2026-11-15 22:37:05 Eastern.
- Event UserId matches Alex's previously verified SID.
- ScriptBlock ID: 790ac94d-51b6-424f-bef1-ca5a92ffef58.
- Script Block Invocation Logging was not verified as enabled.
- Event 4104 establishes captured script content, not successful
  completion or command output.

[Client configuration](../evidence/phase-03/17-powershell-logging-before.png)
[Script-block event](../evidence/phase-03/18-powershell-scriptblock-4104.png)

### Windows PowerShell Module Logging — verified

- Enabled Module Logging in ShahidTech-Workstation-Auditing.
- Configured module-name wildcard *.
- Refreshed WIN11-01 policy and verified EnableModuleLogging = 1
  and ModuleNames entry * = *.
- Opened a new Windows PowerShell session as Alex.
- Executed Write-Output "ShahidTech-4103-Test".
- Event 4103 recorded the cmdlet invocation and parameter binding.
- Related Out-Default event contained the same marker.
- Both events shared user, timestamp, Host ID, Runspace ID,
  and Pipeline ID 8.
- GUI troubleshooting: the leftmost grid asterisk indicated a
  new row; the module wildcard had to be entered in the Value cell.

[Client configuration](../evidence/phase-03/19-module-logging-policy-applied.png)
[Module execution evidence](../evidence/phase-03/20-powershell-module-event-4103.png)

### Windows PowerShell transcription — content verified

- Workstation auditing GPO enables transcription.
- Verified EnableTranscripting = 1 on WIN11-01.
- No custom output directory configured.
- Observed a transcript under Alex's Documents/20261115 folder.
- Transcript identifies SHAHIDTECH\alex.morgan, WIN11-01,
  Windows PowerShell 5.1, and process ID 13900.
- Captured whoami and its output.
- Captured Write-Output "ShahidTech-Transcript-Test" and its output.
- Raw transcripts remain outside Git; reviewed screenshot used as evidence.
- Limitation: user-local storage is not centrally protected or tamper-resistant.
- Clean transcript closure was not established by the captured excerpt.

[Client policy](../evidence/phase-03/21-transcription-policy-applied.png)
[Command and output](../evidence/phase-03/22-transcription-command-and-output.png)

### Script outcome verification — completed

- Created ShahidTech-Outcome-Test.txt in Alex's temporary folder.
- Test-Path returned True.
- Get-Content returned "Authorized lab outcome test."
- Opened the file separately in Notepad and confirmed matching content.
- Transcript recorded the commands and verification output.
- Lesson: recorded script content alone does not prove its intended effect.

[Recorded checks](../evidence/phase-03/23-script-outcome-verification.png)
[File inspected separately](../evidence/phase-03/24-file-outcome-independent-check.png)

### Security log capacity — verified after restart

- Initial Security log maximum: 20971520 bytes (20 MiB).
- Retention mode: Circular.
- Configured 131072 KB (128 MiB) in the workstation auditing GPO.
- gpupdate succeeded, but the active log initially remained at 20 MiB.
- Client policy report confirmed the intended value and winning GPO.
- After a normal workstation restart, Get-WinEvent reported
  134217728 bytes (128 MiB), still Circular.
- No log clearing or manual local size override was performed.
- Larger capacity provides more buffer, not a guaranteed retention period.
- Troubleshooting lesson: policy delivery and active service
  configuration require separate verification.

[Initial configuration](../evidence/phase-03/25-security-log-retention-before.png)
[Policy delivery](../evidence/phase-03/26-security-log-policy-delivered.png)
[Active capacity after restart](../evidence/phase-03/27-security-log-capacity-after-restart.png)

### Observed log history and PowerShell capacity — verified

- WIN11-01 Security log observed range:
  2026-11-15 01:03:37 to 2026-11-16 19:02:00 Eastern.
- Observed span: 41.97 hours; not a guaranteed retention period
  or proof of uninterrupted collection.
- PowerShell Operational log initially had a 15 MiB limit.
- Increased its limit locally to 67108864 bytes (64 MiB).
- Verified Circular retention remained unchanged.
- PowerShell channel capacity is locally configured;
  Security log capacity is managed through the domain GPO.
- Centralized collection remains pending.

[Observed Security history](../evidence/phase-03/28-security-log-observed-timespan.png)
[PowerShell log capacity](../evidence/phase-03/29-powershell-log-capacity.png)

### Defender intelligence refresh and network restoration — verified

- Defender antivirus and real-time protection were enabled.
- Initial signature timestamp: 2025-09-16.
- Temporarily connected WIN11-01 to Default Switch with DHCP
  and automatic DNS for updates.
- Update-MpSignature returned RPC error 0x800706be, recorded in
  the session's pasted command output; no error screenshot was captured.
- Subsequent status showed signature version 1.463.334.0,
  updated 2026-11-16, signature age 0, and real-time protection enabled.
- Fresh signatures were verified; the exact update mechanism
  responsible was not established.
- Reconnected WIN11-01 to SOC-LAB and restored:
  10.10.10.20/24, DNS 10.10.10.10, no default gateway.
- Network profile recognized ad.shahidtech.test.

[Initial Defender status](../evidence/phase-03/30-defender-status-before.png)
[Verified Defender signature status](../evidence/phase-03/31-defender-signature-status.png)
[Lab network restored](../evidence/phase-03/32-lab-network-restored.png)

### Defender operational telemetry — baseline verified

- Defender Operational channel enabled, with a 16 MiB limit
  and Circular retention.
- Inspected five recent events; all were configuration-change
  event 5007, not malware detections.
- Observed initialization, service-state, notification-related,
  and MAPS failure timestamp changes.
- Current Defender service, antivirus, and real-time protection
  status all verified True.
- WIN11-01 remains at 10.10.10.20, DNS 10.10.10.10,
  with no default gateway.
- Isolation is a plausible explanation for cloud-connectivity
  failures; their exact cause remains unconfirmed.
- Information-level severity alone does not establish benign activity.

[Channel configuration](../evidence/phase-03/33-defender-channel-status.png)
[Configuration events](../evidence/phase-03/34-defender-configuration-events.png)
[Protection and isolation](../evidence/phase-03/35-defender-protection-and-isolation.png)

### Sysmon process telemetry — verified

- Enabled the built-in Sysmon optional feature on WIN11-01.
- Installed its service using C:\LabTools\Sysmon\sysmon-lab.xml.
- Verified Sysmon service Running and Operational channel enabled.
- Configuration schema: 4.91; SHA256 hashing enabled.
- ProcessCreate uses an empty exclude filter.
- Generated a harmless cmd.exe marker command as Alex.
- Correlated Sysmon event 1 with Security event 4688 using
  host, timestamp, executable, command line, and process IDs.
- Child PID: decimal 3796 = hexadecimal 0xed4.
- Parent PID: decimal 2352 = hexadecimal 0x930.
- Sysmon additionally supplied process GUIDs and an executable hash.
- Network-connection collection remains disabled.

[Sysmon installation](../evidence/phase-03/42-sysmon-installation.png)
[Loaded configuration](../evidence/phase-03/43-sysmon-loaded-configuration.png)
[Sysmon process event](../evidence/phase-03/44-sysmon-process-create.png)
[Cross-log correlation](../evidence/phase-03/45-security-process-event-comparison.png)

### Sysmon process-to-network correlation — verified

- Added a NetworkConnect include rule for powershell.exe.
- Verified the running Sysmon configuration loaded the rule.
- Event 3 recorded Alex's PowerShell process initiating TCP traffic
  from 10.10.10.20:49854 to DC01 at 10.10.10.10:389.
- Correlated event 3 with process-creation event 1 using the exact
  ProcessGuid: {3d3dad4e-cbfc-6afb-3b03-000000000a00}.
- Process PID: 4836; parent explorer.exe, PID 6364.
- Process integrity: Medium.
- Event UTC timestamps place the connection about 46 seconds
  after process creation.
- Connection metadata does not establish LDAP authentication
  or application-level success.

[Loaded network filter](../evidence/phase-03/46-sysmon-network-filter-loaded.png)
[Network connection](../evidence/phase-03/47-powershell-network-connection.png)
[Process correlation](../evidence/phase-03/48-network-process-guid-correlation.png)

### Sysmon capacity and internal-error check — verified

- Sysmon Operational logging is enabled.
- Maximum size: 65536 KB (64 MiB).
- Retention: overwrite oldest events as needed.
- Kept existing capacity and retention settings unchanged.
- Filtering retained records for event 255 returned zero matches.
- No retained internal-error events were observed; this does not
  prove complete historical collection or absence of event loss.

[Log capacity](../evidence/phase-03/49-sysmon-log-capacity-before.png)
[Internal-error check](../evidence/phase-03/50-sysmon-internal-error-check.png)

### Sysmon DNS-query telemetry — verified

- Added a DnsQuery include rule targeting powershell.exe.
- Sysmon validated and loaded the updated XML.
- Alex queried dc01.ad.shahidtech.test from WIN11-01.
- Resolve-DnsName returned 10.10.10.10.
- Sysmon event 22 recorded PowerShell PID 7268, Alex's identity,
  QueryStatus 0, and QueryResults 10.10.10.10.
- DNS resolution does not establish a subsequent connection
  or successful authentication.
- Collection is scoped to Windows PowerShell for this DNS rule;
  it does not cover all applications.

[Loaded DNS rule](../evidence/phase-03/51-sysmon-dns-filter-loaded.png)
[Query and event evidence](../evidence/phase-03/52-powershell-dns-query.png)

### DNS reverse-lookup troubleshooting — verified

- Observed nslookup timeouts despite receiving the correct forward answer.
- An explicit, trailing-dot A query returned an authoritative
  NOERROR response, but initial server identification still timed out.
- Direct PTR lookup timed out; DC01 had no reverse lookup zone.
- Created AD-integrated 10.10.10.in-addr.arpa with secure updates.
- Added PTR: 10.10.10.10 → dc01.ad.shahidtech.test.
- WIN11-01 then resolved the PTR successfully.
- Repeated trailing-dot A query identified DC01 by name and
  returned 10.10.10.10 without timeouts.
- Original non-trailing-dot query was not yet retested.
- Sysmon DNS filter coverage comparison remains pending.

[Observed timeout](../evidence/phase-03/53-nslookup-timeout-observed.png)
[Forward-query diagnosis](../evidence/phase-03/54-dns-forward-query-debug.png)
[Missing reverse zone](../evidence/phase-03/55-reverse-zone-missing.png)
[Zone and PTR created](../evidence/phase-03/56-reverse-zone-and-ptr-created.png)
[Successful retest](../evidence/phase-03/57-dns-reverse-and-forward-retest.png)

### Sysmon DNS coverage comparison — observed

- Sysmon event 1 recorded Alex launching nslookup.exe.
- Test command requested DC01's A record through 10.10.10.10.
- ProcessGuid: {3d3dad4e-d889-6afb-e503-000000000a00}.
- An exact event-22 query for that ProcessGuid returned
  NoMatchingEventsFound.
- This is consistent with the configured powershell.exe-only
  DNS filter, but does not establish the filter as the sole cause.
- Earlier PowerShell testing produced event 22 successfully.
- Lesson: absence of telemetry does not establish absence of activity.

[nslookup process](../evidence/phase-03/58-nslookup-process-created.png)
[No matching DNS event](../evidence/phase-03/59-nslookup-dns-event-not-found.png)

### Expanded Sysmon DNS coverage — verified with limitations

- Replaced the PowerShell-only DnsQuery include rule with an
  empty exclude rule.
- Verified Sysmon validated and loaded the configuration.
- Observed event 22 from additional background processes.
- Inspected nslookup attempts had no matching event 22.
- A subsequent Resolve-DnsName test as Alex produced event 22
  for powershell.exe, PID 6948.
- QueryStatus 0 and QueryResults 10.10.10.10 matched the lookup.
- Collection works, but coverage of every DNS query path is
  not established. The nslookup visibility gap remains unexplained.
- NetworkConnect collection remains limited to powershell.exe.

[Expanded rule](../evidence/phase-03/60-sysmon-dns-expanded-filter.png)
[Additional process coverage](../evidence/phase-03/61-expanded-dns-process-coverage.png)
[Positive control](../evidence/phase-03/62-dns-collection-positive-control.png)

## Decisions

2026-11-14: Repository name: shahidtech-soc-lab. Documentation scaffold only; Git initialized.



## Session log

After each lesson, record date, change, verification result, evidence link, known issues, next step, and relevant snapshot/external backup. Mark completion only after verification. Record restore checks separately.

### Phase 3 portfolio guide

- Consolidated verified results, evidence, configuration scope, troubleshooting, and limitations in [the Phase 3 guide](phase-03-windows-security-logging.md).
- Updated repository Sysmon XML to match the verified expanded DNS rule.
- Phase 3 remains in progress; DC01 parity and centralized forwarding remain pending.

### DC01 authentication auditing — centrally configured and verified

- Recorded initial DC01 authentication auditing: Success only.
- Created ShahidTech-DomainController-Auditing.
- Enabled advanced audit subcategory precedence.
- Configured Success and Failure for:
  - Kerberos Authentication Service
  - Kerberos Service Ticket Operations
  - Credential Validation
- Linked the GPO to Domain Controllers; enabled, not enforced.
- Retained Default Domain Controllers Policy.
- Refreshed DC01 computer policy.
- gpresult confirmed the new GPO applied.
- auditpol confirmed all three subcategories: Success and Failure.
- Local Security Policy confirmed audit precedence Enabled.
- New controlled authentication-failure event validation remains pending.
- DC01 Process Creation auditing remains unconfigured by this GPO.