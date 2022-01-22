<#
.SYNOPSIS
Creates entries to a log file

.DESCRIPTION
Creates an entry of a specified severity into the log file.

.OUTPUTS
A *.log file with specific name or location (Default is script root named log.log)

.PARAMETER Message
The log message entered into the log file.

.PARAMETER severity
The severity set for the log message within the log file. (Info, Warning, Error)

.PARAMETER logLocation
The directory of the log file.

.PARAMETER logName
The name of the log file. Should be a *.log extension. The default location is the area the script was executed.

.EXAMPLE
write-log -Message "Oh no Jurgen was here"
.EXAMPLE
write-log -Message "Oh no Jurgen was here" -severity "Error"
.EXAMPLE
write-log -Message "Oh no Jurgen was here" -severity "Error" -LogLocation "C:\temp\ffsJurgen.log"
<#
.SYNOPSIS
Creates entries to a log file.

.DESCRIPTION
Creates an entry of a specified severity into the log file.

.OUTPUTS
A *.log or *.txt file with specific name or location.

.PARAMETER Message
The log message entered into the log file.

.PARAMETER severity
The severity set for the log message within the log file. (Info, Warning, Error).

.PARAMETER logLocation
The directory of the log file.  If left blank the log will be located in the Write-Log module folder.

.PARAMETER DateFormat
String format if a specific date format is desired.

.EXAMPLE
write-log -Message "Info worthy log"
.EXAMPLE
write-log -Message "Error message!! OH NO!" -severity "Error"
.EXAMPLE
write-log -Message "Errorrrr!!!!" -severity "Error" -LogLocation "C:\temp\Events.log"

.NOTES
This module can be found in the following GitHub Repo: https://github.com/PowershellGroup/Write-Log-Module
#>

Function Write-Log {
  Param(
      [Parameter(Position=0, Mandatory=$true, HelpMessage="Enter your log message.")]
      [string]$Message,

      [Parameter(Position=1, HelpMessage="Enter the log level severity between.")]
      [ArgumentCompleter({'Info','Warning','Error'})]
      [string]$severity = "Info",

      [Parameter(Position=2, HelpMessage="Directory for the log file. Extension must be .log or .txt")]
      [string]$logLocation = "$PSScriptRoot\Events.log",

      [Parameter(Position=3, HelpMessage="String format of the date. E.g. dd/MM/yyyy")]
      [string]$DateFormat
  )

  $extension = [System.IO.Path]::GetExtension($logLocation)
  if(!($extension -eq ".log") -and !($extension -eq ".txt")) {
    throw "Invalid log file extension. Please use .log or .txt" 
  }

  if(!(test-path $logLocation)) {
    new-item $logLocation -Force | out-null
  }

  if($null -eq $DateFormat) {
    [DateTime]$Date = Get-Date
    $timeStamp = $date.ToShortDateString() + " " + $date.ToShortTimeString()
  } else {
      $timeStamp = Get-date -Format $DateFormat
  }

  $Output = "$timeStamp - [$severity] $Message"
  Add-Content $logLocation -value $Output
  Write-Host "$Output"
}

Export-ModuleMember -Function Write-Log
.NOTES
This module can be found in the following GitHub Repo: https://github.com/captainqwerty/Write-Log
#>

Function Write-Log {
  Param(
      [Parameter(Position=0, Mandatory=$true, HelpMessage="Enter your log message.")]
      [string]$Message,

      [Parameter(Position=1, HelpMessage="Enter the log level severity between.")]
      [ValidateSet("Info", "Warning", "Error")]
      [string]$severity = "Info",

      [Parameter(Position=2, HelpMessage="Directory for the log file.")]
      [string]$logLocation = "$PSScriptRoot\log.log"
  )

  if(!(test-path $logLocation)) {
    new-item $logLocation -Force | out-null
  }
  
  $timeStamp = Get-date -Format "dd/MM/yyyy HH:mm:ss"
  $Output = "$timeStamp - [$severity] $Message"
  Add-Content $logLocation -value $Output
  Write-Host "$Output"
}

Export-ModuleMember -Function Write-Log