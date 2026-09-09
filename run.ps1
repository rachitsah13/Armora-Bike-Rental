# Deploy app and start Tomcat 10 (use when Eclipse server is stopped).
$ErrorActionPreference = "Stop"

$env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
$env:JRE_HOME = $env:JAVA_HOME
$env:CATALINA_HOME = "C:\apache-tomcat-9.0.115\apache-tomcat-10.1.36"

& (Join-Path $PSScriptRoot "deploy.ps1")

# Stop any existing Tomcat on port 8080
$on8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | Select-Object -First 1
if ($on8080) {
    Write-Host "Port 8080 is in use. Stop Eclipse Tomcat first, then run this script again."
    Write-Host "Or only use Eclipse: run deploy.ps1, then Stop/Start Tomcat in Eclipse."
    exit 1
}

Write-Host "Starting Tomcat..."
Start-Process -FilePath "$env:CATALINA_HOME\bin\catalina.bat" -ArgumentList "run" -WorkingDirectory $env:CATALINA_HOME
Start-Sleep -Seconds 12

$r = curl.exe -s -o NUL -w "%{http_code}" "http://localhost:8080/ArmoraBikeRentals/"
Write-Host "ArmoraBikeRentals status: $r"
Write-Host "Open: http://localhost:8080/ArmoraBikeRentals/"
