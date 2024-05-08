[string]$var = "Hello World!"

Write-Host $var

$number = 20

$name = Read-Host "Digite seu nome"

if ($number -is [int]) {
    Write-Host "Olá $name, tudo bem?`n"
}

pause