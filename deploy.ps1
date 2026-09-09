# Full deploy: compile Java + copy complete web app (merge, does not wipe running server blindly).
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$webapp = Join-Path $root "src\main\webapp"
$classes = Join-Path $root "build\classes"
$src = Join-Path $root "src\main\java"
$servletApi = Join-Path $root "lib\jakarta.servlet-api-6.0.0.jar"
$mysqlJar = Join-Path $root "src\main\webapp\WEB-INF\lib\mysql-connector-j-8.3.0.jar"
$logoSrc = Join-Path $root "logo\logo.png"
$logoDest = Join-Path $root "src\main\webapp\images\logo.png"
if (Test-Path $logoSrc) {
    New-Item -ItemType Directory -Force -Path (Split-Path $logoDest) | Out-Null
    Copy-Item $logoSrc $logoDest -Force
}

if (-not (Test-Path $servletApi)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $servletApi) | Out-Null
    Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar" -OutFile $servletApi
}

if (-not (Test-Path $mysqlJar)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $mysqlJar) | Out-Null
    Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar" -OutFile $mysqlJar
}

# Tomcat runs on Java 21 — compile with JDK 21 (not Java 26 from PATH).
$jdk21 = "C:\Program Files\Java\jdk-21"
$javac = Join-Path $jdk21 "bin\javac.exe"
if (-not (Test-Path $javac)) {
    throw "JDK 21 not found at $jdk21. Install JDK 21 or update deploy.ps1."
}

New-Item -ItemType Directory -Force -Path $classes | Out-Null
$javaFiles = Get-ChildItem $src -Recurse -Filter "*.java" | ForEach-Object { $_.FullName }
& $javac -encoding UTF-8 --release 21 -d $classes -cp "$servletApi;$mysqlJar" @javaFiles
Write-Host "Compiled for Java 21 to $classes"

function Deploy-To($target) {
    if (-not $target) { return }
    New-Item -ItemType Directory -Force -Path $target | Out-Null

    # Copy static web files (JSP, CSS, images)
    robocopy $webapp $target /E /XD classes /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

    # Copy compiled classes
    $destClasses = Join-Path $target "WEB-INF\classes"
    New-Item -ItemType Directory -Force -Path $destClasses | Out-Null
    robocopy $classes $destClasses /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

    # Ensure MySQL driver is present
    $destLib = Join-Path $target "WEB-INF\lib"
    New-Item -ItemType Directory -Force -Path $destLib | Out-Null
    Copy-Item $mysqlJar (Join-Path $destLib (Split-Path $mysqlJar -Leaf)) -Force

    Write-Host "Deployed to $target"
}

$eclipseDeploy = "C:\Users\nepal\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\ArmoraBikeRentals"
$standaloneDeploy = "C:\apache-tomcat-9.0.115\apache-tomcat-10.1.36\webapps\ArmoraBikeRentals"

Deploy-To $eclipseDeploy
Deploy-To $standaloneDeploy

Write-Host ""
Write-Host "Done. Restart Tomcat (Stop, then Start) in Eclipse, then open:"
Write-Host "  http://localhost:8080/ArmoraBikeRentals/"
