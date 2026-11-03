function Write-Log { #logg
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "logg.txt" -Value "$timestamp - $Message"
}

$mappar = @( # mappstruktur
    "C:\Projekt\",
    "C:\Projekt\Logs\",
    "C:\Projekt\Config\",
    "C:\Projekt\Backup\"
)
foreach ($mapp in $mappar) {
    if (-Not (Test-Path $mapp)) {
        New-Item -ItemType Directory -Path $mapp
        Write-Host "Mappen $mapp har skapats."
        Write-Log "Mappen $mapp har skapats."
        
    } else {
        Write-Host "Mappen $mapp finns redan."
        Write-Log "Mappen $mapp finns redan."
    }
}

$iis = Get-WindowsFeature -Name Web-Server # iis installation
if ($iis.Installed -eq $false) {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Write-Host "IIS har installerats."
    Write-Log "IIS har installerats."
} else {
    Write-Host "IIS är redan installerat."
    Write-Log "IIS är redan installerat."

}
#startar IIS
Start-Service -Name "W3SVC"
Set-Service -Name "W3SVC"

Write-Log "IIS startades"

# Skapar index.html
$html = @"
<html>
<body>
    <h1>Webbplats</h1>
    <p>Detta är en automatisk webbplats.</p>
</body>
</html>
"@
$html | Out-File -FilePath "C:\inetpub\wwwroot\index.html"
Write-Log "Index.html skapades"

try {   #kontrollerar om webbplatsen är tillgänglig
    $result = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
    if ($result.StatusCode -eq 200) {
        Write-Host "Webbplatsen är tillgänglig."
        Write-Log "Webbplatsen är tillgänglig."
    } else {
        Write-Host "Webbplatsen är inte tillgänglig. Statuskod: $($result.StatusCode)"
        Write-Log "Webbplatsen är inte tillgänglig. Statuskod: $($result.StatusCode)"
    }
} catch {
    Write-Host "Ett fel uppstod vid kontroll av webbplatsen: $($_.Exception.Message)"
    Write-Log "Ett fel uppstod vid kontroll av webbplatsen: $($_.Exception.Message)"
}