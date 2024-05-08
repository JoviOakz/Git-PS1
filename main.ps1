[string]$var = "Hello World!"

Write-Host $var

$number = 20

$name = Read-Host "Digite seu nome"

if ($number -is [int]) {
    Write-Host "Olá $name, tudo bem?`n"
}

pause


$destinationDirectory = (Get-Location).Path

#Criar o diretório de destino, se não existir
if (-not (Test-Path -Path $destinationDirectory)){
    New-Item -Path $destinationDirectory -ItemType Directory
}
Write-Output "Pasta GitPS inicializada: $destinationDirectory"