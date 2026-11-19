#requires -Version 5.1
<#
.SYNOPSIS
Checks the ShahidTech Windows logging baseline on the local computer.
.DESCRIPTION
Reports channel configuration and the newest retained record for each
required event ID. Run from an elevated Windows PowerShell session.
#>
[CmdletBinding()]
param()

$channels = @(
    @{ Name = 'Security'; MinimumSize = 128MB; EventIds = @(4688) }
    @{ Name = 'Microsoft-Windows-PowerShell/Operational'; MinimumSize = 64MB; EventIds = @(4103, 4104) }
    @{ Name = 'Microsoft-Windows-Sysmon/Operational'; MinimumSize = 64MB; EventIds = @(1) }
)

foreach ($channel in $channels) {
    $configuration = $null
    $configurationResult = 'Meets baseline'
    try {
        $configuration = Get-WinEvent -ListLog $channel.Name -ErrorAction Stop
        if (-not $configuration.IsEnabled -or
            $configuration.MaximumSizeInBytes -lt $channel.MinimumSize -or
            $configuration.LogMode -ne 'Circular') {
            $configurationResult = 'Below baseline'
        }
    } catch {
        $configurationResult = "Unavailable ($($_.FullyQualifiedErrorId))"
    }

    foreach ($eventId in $channel.EventIds) {
        $record = $null
        $eventResult = 'Found'
        try {
            $record = Get-WinEvent -FilterHashtable @{
                LogName = $channel.Name
                Id      = $eventId
            } -MaxEvents 1 -ErrorAction Stop
        } catch {
            if ($_.FullyQualifiedErrorId -like 'NoMatchingEventsFound,*') {
                $eventResult = 'No retained match'
            } else {
                $eventResult = "Unavailable ($($_.FullyQualifiedErrorId))"
            }
        }

        $sizeMiB = if ($null -ne $configuration.MaximumSizeInBytes) {
            $configuration.MaximumSizeInBytes / 1MB
        }
        $sourceUtc = if ($null -ne $record.TimeCreated) {
            $record.TimeCreated.ToUniversalTime().ToString('o')
        }

        [pscustomobject]@{
            Computer      = $env:COMPUTERNAME
            LogName       = $channel.Name
            Enabled       = $configuration.IsEnabled
            SizeMiB       = $sizeMiB
            MinimumMiB    = $channel.MinimumSize / 1MB
            Mode          = $configuration.LogMode
            Configuration = $configurationResult
            EventId       = $eventId
            EventCheck    = $eventResult
            RecordId      = $record.RecordId
            EventUtc      = $sourceUtc
        }
    }
}
