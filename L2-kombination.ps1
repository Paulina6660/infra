$server = Read-Host "Ange serverns namn" #frågar användare om servernamn
try {$ping = Test-Connection -ComputerName $server -Count 2 -Quiet -ErrorAction Stop
    if ($ping -eq $true) {
        Write-Host "$server svarar och är redan igång"
        Write-Log "$server svarar"
    } else {
        Write-Host "$server svarar inte"
        Write-Log "$server svarar inte"
    } 
}
catch {
    Write-Error "Ett fel uppstod"
}

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "logg.txt" -Value "$timestamp - $Message"
}
Write-Log "Skriptet startades"
Write-Log "Server: $server, kontrollerades"