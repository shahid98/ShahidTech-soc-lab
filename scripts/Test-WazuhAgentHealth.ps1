#requires -Version 5.1
<#
.SYNOPSIS
Checks the local Windows Wazuh agent and its network path to the manager.
#>
[CmdletBinding()]
param(
    [string]$ManagerAddress = '10.10.10.30',
    [ValidateRange(1, 65535)]
    [int]$Port = 1514
)

$service = Get-Service -Name WazuhSvc -ErrorAction SilentlyContinue
$serviceStatus = if ($service) { [string]$service.Status } else { 'Unavailable' }

$statePath = Join-Path ${env:ProgramFiles(x86)} 'ossec-agent\wazuh-agent.state'
$agentState = 'Unavailable'
try {
    $statusLine = Select-String -LiteralPath $statePath -Pattern "^status='([^']+)'\s*$" `
        -ErrorAction Stop | Select-Object -First 1
    if ($statusLine) {
        $agentState = $statusLine.Matches[0].Groups[1].Value
    }
} catch {
    Write-Verbose "Could not read agent state: $($_.FullyQualifiedErrorId)"
}

$tcpReachable = Test-NetConnection -ComputerName $ManagerAddress -Port $Port `
    -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction Stop

[pscustomobject]@{
    Computer       = $env:COMPUTERNAME
    ServiceStatus  = $serviceStatus
    AgentState     = $agentState
    ManagerAddress = $ManagerAddress
    ManagerPort    = $Port
    TcpReachable   = $tcpReachable
}
