Write-Host "=== Användarhanering ==="
$name = Read-Host "Ange användarnamn"
$age = Read-Host "Ange ålder"
Write-Host "Användare: $name, Ålder: $age"

function CreateUser {
    param ($name, $age)
Write-Host "Skapar användare: $name ($age år)"
return $true
}
$result = CreateUser -name "Erik" -age 25

$users = @("Anna", "Erik", "Lisa")
foreach ($user in $users) {
    Write-Host "Bearbetar $user"
}

$service = Read-Host "Ange tjänstens namn"
$status = (Get-Service -Name $service -ErrorAction SilentlyContinue).Status
if ($status -eq "Running") {
    Write-Host "$service är redan igång"
} else {
    Write-Host "Startar $service..."
}

try {
    $service = Read-Host "Ange tjänstens namn"
    $status = (Get-Service -Name $service).Status
    Write-Host "$service är $status"
} catch {
    Write-Error "Tjänsten '$service' hittades inte!"
}

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path "logg.txt" -Value "$timestamp - $Message"
}
Write-Log "Skriptet startades"
Write-Log "Tjänst $service kontrollerades"