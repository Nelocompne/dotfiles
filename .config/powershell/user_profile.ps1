# 添加环境当前会话的环境变量
# $Env:Path = 'c:\xxx;' + $Env:Path
$env:PATH="$env:USERPROFILE\scoop\shims;$env:PATH"

# 设置终端输出为utf-8编码
# $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# scoop install git curl jq less sudo
# scoop bucket add extras
# scoop install z posh-git oh-my-posh terminal-icons
Import-Module posh-git # 加载完至少300ms
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config '~/.config/powershell/ys.omp.json' | Invoke-Expression
# 加载完至少300ms
Import-Module -Name Terminal-Icons

# scoop install PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
# ~\.config\powershell\PSR.ps1
# 自动补全双边符号

Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr

# scoop install neovim
Set-Alias vim nvim
Set-Alias notepad code

# scoop install ffmpeg yt-dlp neo-cowsay
# scoop install aria2 rclone
# scoop config aria2-enabled false
# scoop install geekuninstaller

# Set-Alias magick ~\ImageMagick\magick.exe

$a_take = curl -s `
'https://v1.hitokoto.cn/?c=k&c=d&c=i&encode=text&charset=gbk' `
--connect-timeout 0.2 -m 0.3
# 防止网络不好获取时间太长，单位秒，可浮点数精确到毫秒

$num = Get-Random -Maximum 101
if ($num % 2 -eq 0)
{ $a_take | cowsay }
else
{ $a_take | cowthink -b }

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function rm_rf ($path) { Remove-Item -Recurse -Force $path }
function kills ($name) { kill -ProcessName $name }

# https://github.com/maharmstone/btrfs/issues/398#issuecomment-872961219
Function Check-FileNameSize([string]$Target) {
    Get-ChildItem -LiteralPath $Target |
    Foreach-Object {
        If ($_ -is [System.IO.DirectoryInfo]) {
            If ([System.Text.Encoding]::UTF8.GetByteCount($_.Name) -gt 255) {
                Write-Output $_.FullName
            }
            Check-FileNameSize($_.FullName)
        }
        Elseif ($_ -is [System.IO.FileInfo]) {
            If ([System.Text.Encoding]::UTF8.GetByteCount($_.Name) -gt 255) {
                Write-Output $_.FullName
            }
        }
        Else {
            Write-Output "Unknown type: $_.FullName"
        }
    }
}
