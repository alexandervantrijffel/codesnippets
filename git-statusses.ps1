param($path = (Get-Item -Path ".\" -Verbose).FullName)

Write-Host "For all subfolders of $path,"
Write-Host "Fetching branches and tags from remote "
Write-Host "and showing git status"

$items = @()
Get-ChildItem -Path $path | ?{$_.PSIsContainer } | Foreach-Object -Process {
    if (Test-Path -Path (Join-Path -Path $_.FullName -ChildPath '.git')) {
        pushd $_.FullName
        $branch = git rev-parse --abbrev-ref HEAD
		$fetch = (git fetch) | Out-String 
		$fetch = $fetch.Trim()
		$branchwritten = $FALSE
		if (!([string]::IsNullOrEmpty($fetch))) {
			Write-Host "($($_))"
			$branchwritten = $TRUE
		}
		$status = (git status -uno -u) -join "`r`n" | Out-String
		
		if (-Not ($status -like "*up-to-date*") -or $status -like "*Changes*") {
			if ($branchwritten -eq $FALSE) {
				Write-Host "$($_)"
				$branchwritten = $TRUE
			}
			$status
			
		}
		if ($branchwritten -eq $TRUE) {
			write-host ""
		}
		
        popd
    }
}
