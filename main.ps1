$currentDirectory = (Get-Location).Path
$gitDirectory = Join-Path -Path $currentDirectory -ChildPath "Git"
$gitTxt = Join-Path -Path $gitDirectory -ChildPath "add.txt"
$gitCommits = Join-Path -Path $gitDirectory -ChildPath "Commits"

function gitInit {
    if (-not (Test-Path -Path $gitDirectory)) {
        New-Item -Path $gitDirectory -ItemType Directory | Out-Null
        New-Item -Path $gitTxt -ItemType File | Out-Null
        New-Item -Path $gitCommits -ItemType Directory | Out-Null
        Write-Host "Diretorio 'Git' criado em: $gitDirectory"
    }
    else {
        Write-Host "Diretorio 'Git' ja exite em: $gitDirectory"
    }
}

function gitAdd {
    param (
        [string]$a
    )

    $aPath = Join-Path -Path $currentDirectory -ChildPath $a
    $inPath = Select-String -Path $gitTxt -Pattern $a

    if ($inPath) {
        Write-Host "Arquivo ja foi adicionado"
    }
    else {
        if (Test-Path -Path $aPath) {
            Add-Content -Path $gitTxt -Value $a
        }
        else {
            $allArquives = Get-ChildItem -Path $currentDirectory -Recurse -Name

            foreach ($name in $allArquives) {
                if ($name -match $a) {
                    $aPath = Join-Path -Path $currentDirectory -ChildPath $name
                    Add-Content -Path $gitTxt -Value $name
                }
            }
        }
    }
}

function gitAdd. {
    $inPath = Select-String -Path $gitTxt -Pattern "."

    if (-not $inPath) {
        Add-Content -Path $gitTxt -Value "."
    }
}

function gitCommit {
    param (
        [string]$m
    )

    $dataCrua = Get-Date
    $data = $dataCrua.ToString("ddMMyyyyHHmmss")

    $Commit = Join-Path -Path $gitCommits -ChildPath "$m-$data"
    New-Item -Path $Commit -ItemType Directory | Out-Null

    $linhas = Get-Content -Path $gitTxt
    $numeroDeLinhas = $linhas.Length

    for ($i = 0; $i -lt $numeroDeLinhas; $i++) {
        $currentArquive = $linhas[$i]

        if ($currentArquive -eq ".") {
            $allArquives = Get-ChildItem -Path $currentDirectory -Name

            foreach ($name in $allArquives) {
                if ($name -notmatch "Git") {
                    $currentPath = Join-Path -Path $currentDirectory -ChildPath $name
                    
                    Copy-Item -Path $currentPath -Destination $Commit -Recurse
                    Write-Host $currentPath
                }
            }
        }
        else {
            $currentPath = Join-Path -Path $currentDirectory -ChildPath $currentArquive
            
            if ($currentPath -ne "$currentDirectory\") {
                $allArquives = Get-ChildItem -Path $currentDirectory -Directory -Name
                
                foreach ($name in $allArquives) {
                    if ($currentArquive -match $name) {
                        $copyPaste = Join-Path -Path $currentDirectory -ChildPath $name
                        $copyArquive = Join-Path -Path $currentDirectory -ChildPath $currentArquive
                        
                        New-Item -Path $copyPaste -ItemType Directory | Out-Null

                        Copy-Item -Path $copyArquive -Destination $copyPaste -Recurse
                    } else {
                        Copy-Item -Path $currentPath -Destination $Commit -Recurse
                    }
                }
            }
        }
    }

    Set-Content -Path $gitTxt -Value ""
}