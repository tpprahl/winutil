# Path to the custom directory
$customDirectory = "C:\ProgramData\WinUtilSC"

# Path to the custom icon
$iconPath = "$customDirectory\Favicon.ico"

# Path to the desktop shortcut
$desktopPath = [System.Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktopPath\WinUtil.lnk"

# Create the custom directory if it doesn't exist
if (-Not (Test-Path -Path $customDirectory)) {
    New-Item -ItemType Directory -Path $customDirectory
}

# Copy the custom icon to the custom directory
# Assuming the custom icon is located at a known path
$sourceIconPath = "https://github.com/tpprahl/winutil/blob/main/docs/assets/favicon.ico"
Copy-Item -Path $sourceIconPath -Destination $iconPath

# Create the shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Shortcut.Arguments = "-Command `"`"iex \"& { $(irm https://christitus.com/win) }\"`"`""
$Shortcut.IconLocation = $iconPath
$Shortcut.Description = "WinUtil"  # Set the name of the shortcut
$Shortcut.Save()

# Set the shortcut to run as administrator
$ShortcutShell = New-Object -ComObject Shell.Application
$Link = $ShortcutShell.NameSpace($desktopPath).ParseName("WinUtil.lnk")
$LinkVerb = $Link.Verbs() | ? {$_.Name -eq "Run as administrator"}
if ($LinkVerb) {
    $LinkVerb.DoIt()
}

Write-Host "Shortcut created successfully at $shortcutPath and set to run as administrator"
