$ErrorActionPreference = 'Stop'
$state = Join-Path $env:LOCALAPPDATA 'ByteX Purple Cursor\previous-cursors.json'
$key = 'HKCU:\Control Panel\Cursors'
if (-not (Test-Path -LiteralPath $state -PathType Leaf)) {
    Write-Host 'Não há tema anterior salvo. Nenhuma configuração foi alterada.' -ForegroundColor Yellow
    exit 0
}
$old = Get-Content -LiteralPath $state -Raw | ConvertFrom-Json
Set-Item -LiteralPath $key -Value $old.'(Default)'
foreach ($name in @('Arrow','Help','AppStarting','Wait','Crosshair','IBeam','NWPen','No','SizeNS','SizeWE','SizeNWSE','SizeNESW','SizeAll','UpArrow','Hand','Pin','Person')) {
    $value = $old.$name
    Set-ItemProperty -LiteralPath $key -Name $name -Value $(if ($null -eq $value) { '' } else { $value })
}
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class ByteXRestoreRefresh {
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfoW", SetLastError = true)]
    public static extern bool Refresh(uint action, uint parameter, IntPtr value, uint flags);
}
'@
if (-not [ByteXRestoreRefresh]::Refresh(0x57, 0, [IntPtr]::Zero, 3)) { throw 'Tema restaurado, mas a tela não atualizou. Aplique o tema anterior em Configurações > Mouse > Ponteiros.' }
Remove-Item -LiteralPath $state
Write-Host 'Tema anterior restaurado.' -ForegroundColor Green
