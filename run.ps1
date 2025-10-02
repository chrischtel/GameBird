# This script is used to run the GameBird application
# It is used for development purposes only

# Check if the application is already running
$process = Get-Process -Name "GameBird" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "GameBird is already running"
    exit
}

# Run the application
Write-Host "Running GameBird..."
Start-Process -FilePath "C:\Users\chris\GameBird\build\GameBird.exe"