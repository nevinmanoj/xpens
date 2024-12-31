# Encode-FirebaseConfig.ps1

$filePath = "android/app/google-services.json"

try {
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((Get-Content -Path $filePath -Raw))) | Set-Clipboard
    Write-Host "Successfully encoded $filePath and copied to clipboard"
} catch {
    Write-Error "Error processing file: $_"
}