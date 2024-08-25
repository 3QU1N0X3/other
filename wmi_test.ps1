$serverList = @(
"server01",
"server02",
"server03",
"server04",
"server05",
"10.0.0.1",
"10.0.0.2",
"10.0.0.3",
"10.0.0.4",
"10.0.0.5"
)

#Credential
$username = '' 
$password = ''
# Her bir sunucu için döngü
foreach ($server in $serverList) {
  try {
    # Invoke-Command ile uzak sunucuda işlem yap
    $os = Invoke-Command -ComputerName $server -ScriptBlock {
      Get-WmiObject -Query "SELECT * FROM Win32_OperatingSystem" -ErrorAction Stop
    } -ErrorAction Stop -Credential (New-Object System.Management.Automation.PSCredential($username, (ConvertTo-SecureString -AsPlainText $password -Force)))

    # Sonuçları işleme
    $osCaption = $os.Caption

    # Yazdırma işlemleri (hem console hem dosya)
    $output = "$server : Success --> $osCaption"
    Write-Host $output  # Write to console

    Add-Content -Path "c:\wmi_result.txt" -Value $output  # Append to file
  } catch {
    # Hata yakalama ve yazdırma
    $errorMessage = $_.Exception.Message
    $output = "$server : Error --> $errorMessage"

    Write-Host $output  # Write error to console
    Add-Content -Path "c:\wmi_result.txt" -Value $output  # Append error to file
  }
}
