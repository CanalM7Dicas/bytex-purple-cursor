$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'cursors'
$target = Join-Path $env:LOCALAPPDATA 'Cursors\ByteX'
$state = Join-Path $env:LOCALAPPDATA 'ByteX Purple Cursor\previous-cursors.json'
$key = 'HKCU:\Control Panel\Cursors'
$files = [ordered]@{ Arrow='pointer.cur'; Help='help.cur'; AppStarting='working.ani'; Wait='busy.ani'; Crosshair='cross.cur'; IBeam='beam.cur'; NWPen='pencil.cur'; No='no.cur'; SizeNS='size_ns.cur'; SizeWE='size_we.cur'; SizeNWSE='size_nwse.cur'; SizeNESW='size_nesw.cur'; SizeAll='size_all.cur'; UpArrow='up.cur'; Hand='link.cur'; Pin='pin.cur'; Person='person.cur' }

foreach ($file in $files.Values) {
    if (-not (Test-Path -LiteralPath (Join-Path $source $file) -PathType Leaf)) { throw "Arquivo necessário ausente: $file" }
}

if (-not (Test-Path -LiteralPath $state)) {
    $old = [ordered]@{ '(Default)' = (Get-Item -LiteralPath $key).GetValue('') }
    $values = Get-ItemProperty -LiteralPath $key
    foreach ($name in $files.Keys) { $old[$name] = $values.$name }
    New-Item -ItemType Directory -Path (Split-Path $state) -Force | Out-Null
    $old | ConvertTo-Json | Set-Content -LiteralPath $state -Encoding UTF8
}

New-Item -ItemType Directory -Path $target -Force | Out-Null
$paths = [ordered]@{}
foreach ($name in $files.Keys) {
    $file = $files[$name]
    Copy-Item -LiteralPath (Join-Path $source $file) -Destination (Join-Path $target $file) -Force
    $paths[$name] = Join-Path $target $file
}
New-Item -Path (Join-Path $key 'Schemes') -Force | Out-Null
Set-ItemProperty -LiteralPath (Join-Path $key 'Schemes') -Name 'ByteX Purple Cursor' -Value ($paths.Values -join ',')
Set-Item -LiteralPath $key -Value 'ByteX Purple Cursor'
foreach ($name in $paths.Keys) { Set-ItemProperty -LiteralPath $key -Name $name -Value $paths[$name] }

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class ByteXApplyRefresh {
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW", SetLastError = true)]
    public static extern bool Refresh(uint action, uint parameter, IntPtr value, uint flags);
}
'@
if (-not [ByteXApplyRefresh]::Refresh(0x57, 0, [IntPtr]::Zero, 3)) { throw 'Tema salvo, mas a tela não atualizou. Aplique-o em Configurações > Mouse > Ponteiros.' }
Write-Host 'ByteX Purple Cursor aplicado. Restore-Theme.bat recupera o tema anterior.' -ForegroundColor Green
