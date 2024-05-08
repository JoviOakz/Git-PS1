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
        $a
    )

    $aPath = Join-Path -Path $currentDirectory -ChildPath $a
    $inPath = Select-String -Path $gitTxt -Pattern $a

    if ($inPath) {
        Write-Host "Arquivo ja foi adicionado"
    }
    else {
        if (Test-Path -Path $aPath) {
            Add-Content -Path $gitTxt -Value $a
            Write-Host "Arquivo adicionado"
        }
        else {
            Write-Host "Arquivo nao encontrado"
        }
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

        if ($currentArquive -ne "") {
            Copy-Item -Path "$currentDirectory\$currentArquive" -Destination $Commit -Recurse
            Write-Host "$currentDirectory\$currentArquive"
        }
    }

    Set-Content -Path $gitTxt -Value ""
}