# Powershell Profile
# Goes into .config/powershell/Microsoft.PowerShell_profile.ps1

function prompt {
	Write-Host "PS " -NoNewLine -ForegroundColor Yellow
    Write-Host "[$(/etc/htb/vpnbash.sh)]" -NoNewLine -ForegroundColor Green
    Write-Output " $PWD > "
}

Write-Output "Welcome to Pwnbox, Powered by Parrot OS"