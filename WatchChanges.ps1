$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = Get-Location
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $false
$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName
"Watching for changes in $(Get-Location)..."

while($true){
    $result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed `
        -bor [System.IO.WatcherChangeTypes]::Renamed `
        -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
	if($result.TimedOut) {
		continue;
	}
    Write-Host "Change in " + $result.Name
    if ($args) {
        & $args[0] $args[1..$($args.Count - 1)]
		"Watching for changes in $(Get-Location)..."
    }
}