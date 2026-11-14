# Planned architecture

Design only: no VMs currently verified. IPs, subnet, gateway, DNS domain, hypervisor, and adapter settings are TBD.

```mermaid
flowchart LR
  subgraph LAB[Isolated virtual lab - planned]
    DC[DC01: Windows Server / AD / DNS]
    WIN[WIN11-01: domain workstation]
    SIEM[SOC-SIEM: Ubuntu / Wazuh]
    KALI[KALI-01: authorized testing]
    WIN -->|Authentication and DNS| DC
    DC -->|Security telemetry| SIEM
    WIN -->|Security telemetry| SIEM
    KALI -->|Controlled simulation| WIN
  end
```

WIN11-02 is an optional later workstation. Cloud exercises are later extensions subject to budget and licensing checks.

Use an isolated virtual network with temporary internet access only when required. No public inbound exposure. Document and explain every IP, DNS setting, gateway, adapter, and firewall exception before deployment.

| Host | IP | DNS | Adapter | Verification |
| --- | --- | --- | --- | --- |
| DC01 | TBD | TBD | TBD | Pending |
| WIN11-01 | TBD | TBD | TBD | Pending |
| SOC-SIEM | TBD | TBD | TBD | Pending |
| KALI-01 | TBD | TBD | TBD | Pending |
