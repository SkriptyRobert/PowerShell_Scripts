#===========================
#Enter Ps-Sesion
#===========================

#$session = New-PSSession -ComputerName -Credential Get-Credential
#Invoke-Command -Session $session -ScriptBlock { Test-Path -Path C:\File.txt } ######REMOTE COPY 


#===========================
#Enter path and her test 
#===========================

do
{

$path=Read-host "***Zadej cestu, kde se nachazi adresar, nebo soubor, ktery se bude zalohovat.***" 
$Destination= "c:\BackUp"
$folderName= (get-item $path).BaseName

$DataTest=Test-Path -Path $path 


if ($DataTest -like "true")  
 {  
    $DataTime= (Get-item $path).LastWriteTime 
    $DataCount=(Get-ChildItem -Path $path -Recurse).count  
    write-host "Cesta $path nalezena. Nachazi se zde celkem $DataCount polozek ke kopirovani. Posledni upravy byli provedeny $DataTime." -ForegroundColor Green 
    
}
else
{
    Write-host "Uvedena cesta nebyla nalezena! Opakuj" -BackgroundColor Red -ForegroundColor white

}

}until ($DataTest -like "true")

#===========================
#Temporery folder on local server for compres data, before remote copy 
#===========================

#Get-ChildItem -Path "$path" | Copy-Item -Destination $Destination -Recurse

Compress-Archive -Path $path -CompressionLevel Optimal -Update -DestinationPath $Destination\$folderName

Start-Sleep -Seconds 1
write-host "Data byli zkomprimovany do lokaniho adresare $Destination." -BackgroundColor Yellow
pause

#===========================
#ROBOCOPY- Start copy compresed file from Srv1 to Srv2 **OR copy on network share folder 
#===========================

$Sourcepath1 = "C:\BackUp"
$DestinationPath1 = "\\server1\C$\BackUp1"
$filetransfer = "\\server1\c$\transferlog.txt"

robocopy $sourcePath1 $destinationPath1 /E /Z /V /LOG+:$filetransfer /NP /w:6 /r:7 
#robocopy $sourcePath2 $destinationPath2 /E /DCOPY:DAT /COPYALL /LOG:$filetransfer /MIR /TEE /W:3 /ZB /V /timfix /sl /r:7 /COPY:DAT  

#===========================
#Send Email using Google SMTP with info about BackUp
#===========================

#$EmFrom = "robert.pesout@gmail.com"
#$username = "robert.pesout"
#$pwd = "**************"
#$EmTo = "marketa.pesoutova@gmail.com"
#$Server = "smtp.gmail.com"
#$port = 587
#$Subj = "Byla provedena zaloha + BackUp Log:"
#$Body = "Test 123"
#$Att = "D:\BackupD\copylog.txt"
#$securepwd = ConvertTo-SecureString $pwd -AsPlainText -Force
#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $securepwd
#Send-MailMessage -To $EmTo -From $EmFrom -Body $Body -Subject $Subj -Attachments $Att -SmtpServer $Server -port $port -UseSsl  -Credential $cred

Write-Host "===========HOTOVO==========="



