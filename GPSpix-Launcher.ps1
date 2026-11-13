# GPSpix Launcher
# Lets you pick a photo folder, runs the scan (gathergps.html) so gpstagged.txt is written
# into that folder, and opens the map (gps.html).
# Nothing is copied into your photo folder except the gpstagged.txt index file:
# gps.html and gathergps.html stay here and read the photo folder through the browser.
# Keep this file in the same folder as your master gps.html and gathergps.html.

Add-Type -AssemblyName System.Windows.Forms

$srcDir = $PSScriptRoot
$files  = @('gps.html', 'gathergps.html')

function Show-Msg($text, $buttons = 'OK', $icon = 'Information') {
    return [System.Windows.Forms.MessageBox]::Show($text, 'GPSpix Launcher', $buttons, $icon)
}

function Get-Browser {
    # Chrome first, then Edge: both can read and write a folder you pick
    @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LocalAppData\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}

function Open-Page($path, $query = '') {
    $browser = Get-Browser
    if ($browser) {
        $url = ([System.Uri]$path).AbsoluteUri + $query
        Start-Process -FilePath $browser -ArgumentList ('"' + $url + '"')
    } else {
        # No Chrome or Edge found: use the default browser (the folder picking needs Chrome or Edge)
        Start-Process -FilePath $path
    }
}

# 1. Check the master files exist
foreach ($f in $files) {
    if (-not (Test-Path (Join-Path $srcDir $f))) {
        Show-Msg "Cannot find $f in:`n$srcDir`n`nPut the launcher in the same folder as gps.html and gathergps.html." 'OK' 'Error' | Out-Null
        exit 1
    }
}

# 2. Pick the photo folder
$dlg = New-Object System.Windows.Forms.FolderBrowserDialog
$dlg.Description = 'Select the top-level folder of your photo collection'
$dlg.ShowNewFolderButton = $false
if ($dlg.ShowDialog() -ne 'OK') { exit 0 }
$target = $dlg.SelectedPath

# 3. Decide whether to scan
$index = Join-Path $target 'gpstagged.txt'
$scan  = $true
if (Test-Path $index) {
    $when = (Get-Item $index).LastWriteTime
    $ans  = Show-Msg "An index already exists for this folder (made $when).`n`nRescan the photos?`n`nYes = rescan (needed if you added photos)`nNo = just open the map" 'YesNo' 'Question'
    if ($ans -eq 'No') { $scan = $false }
}

# 4. Run the scan; gpstagged.txt ends up in the photo folder
if ($scan) {
    try {
        $downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    } catch {
        $downloads = Join-Path $env:USERPROFILE 'Downloads'
    }

    $start = Get-Date
    Open-Page (Join-Path $srcDir 'gathergps.html')

    Write-Host ''
    Write-Host 'In the browser page that just opened:'
    Write-Host '  1. Click the button to choose a folder'
    Write-Host '  2. Select the SAME photo folder you picked here'
    Write-Host '  3. Allow access if the browser asks'
    Write-Host ''
    Write-Host "Waiting for gpstagged.txt to appear in the photo folder or in $downloads ..."
    Write-Host '(Scanning many photos can take a while. Close this window to cancel.)'

    $found    = $null
    $savedDirect = $false
    $deadline = $start.AddHours(3)
    while ((Get-Date) -lt $deadline -and -not $found -and -not $savedDirect) {
        Start-Sleep -Seconds 3
        # Chrome/Edge save gpstagged.txt straight into the photo folder
        if ((Test-Path $index) -and ((Get-Item $index).LastWriteTime -gt $start)) { $savedDirect = $true; break }
        # Other browsers put it in Downloads
        $found = Get-ChildItem -Path $downloads -Filter 'gpstagged*.txt' -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.LastWriteTime -gt $start } |
                 Sort-Object LastWriteTime -Descending |
                 Select-Object -First 1
    }

    if (-not $found -and -not $savedDirect) {
        Show-Msg "gpstagged.txt was not found in your photo folder or in:`n$downloads`n`nIf your browser saved it somewhere else, move it into:`n$target`nthen run this launcher again and answer No to rescanning." 'OK' 'Warning' | Out-Null
        exit 1
    }

    if ($found) {
        Start-Sleep -Seconds 2   # let the browser finish writing the file
        Move-Item -Path $found.FullName -Destination $index -Force
        Write-Host "Moved gpstagged.txt into $target"
    } else {
        Start-Sleep -Seconds 2
        Write-Host 'gpstagged.txt was saved directly into the photo folder.'
    }
}

# 5. Open the map. "?folder" makes gps.html ask for the photo folder, so it never
#    needs to be copied into it (and ignores any gpstagged.txt sitting next to gps.html).
Open-Page (Join-Path $srcDir 'gps.html') '?folder'
Write-Host 'Done. The map should be opening in your browser.'
Write-Host "In the map, pick '$target' (or click it under Recent folders)."
