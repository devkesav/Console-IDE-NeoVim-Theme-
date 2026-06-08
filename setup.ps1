# Console IDE — Windows Setup Script
# Run this in PowerShell as Administrator to configure fonts and terminal.

Write-Host "=== Console IDE Windows Setup ===" -ForegroundColor Cyan

# 1. Install JetBrainsMono Nerd Font
Write-Host "[1/2] Installing JetBrainsMono Nerd Font..." -ForegroundColor Yellow
try {
    winget install DEVCOM.JetBrainsMonoNerdFont --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Font installed!" -ForegroundColor Green
    } else {
        Write-Host "  Font install failed. Skipping..." -ForegroundColor Red
    }
} catch {
    Write-Host "  Font install failed. Skipping..." -ForegroundColor Red
}

# 2. Update Windows Terminal settings.json
Write-Host "[2/2] Updating Windows Terminal font setting..." -ForegroundColor Yellow
$wtPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$wtPreviewPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

$targetPath = $null
if (Test-Path $wtPath) { $targetPath = $wtPath }
elseif (Test-Path $wtPreviewPath) { $targetPath = $wtPreviewPath }

if ($targetPath) {
    try {
        $settings = Get-Content $targetPath -Raw | ConvertFrom-Json
        if (-not $settings.profiles.defaults) {
            $settings.profiles.defaults = @{}
        }
        $settings.profiles.defaults.fontFace = "JetBrainsMono NFM"
        $settings.profiles.defaults.fontSize = 11
        $settings | ConvertTo-Json -Depth 10 | Set-Content $targetPath -Encoding UTF8
        Write-Host "  Terminal settings updated!" -ForegroundColor Green
    } catch {
        Write-Host "  Failed to update settings.json. Manual step required." -ForegroundColor Red
        Write-Host "  See windows-terminal.json in the repo for reference." -ForegroundColor Yellow
    }
} else {
    Write-Host "  Windows Terminal settings.json not found." -ForegroundColor Red
    Write-Host "  See windows-terminal.json in the repo for manual setup." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done! Restart Windows Terminal for changes to take effect." -ForegroundColor Cyan
