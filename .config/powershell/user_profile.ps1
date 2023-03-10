# python3.11 ';C:\Users\Minn\AppData\Local\Programs\Python\Python311\Scripts\;C:\Users\Minn\AppData\Local\Programs\Python\Python311\;'
# python3.10 ';C:\Users\Minn\AppData\Local\Programs\Python\Python310\Scripts\;C:\Users\Minn\AppData\Local\Programs\Python\Python310\;'
$Env:Path = 'C:\Users\Minn\AppData\Local\Programs\Python\Python310\Scripts\;' + 'C:\Users\Minn\AppData\Local\Programs\Python\Python310\;' + 'C:\Users\Minn\Desktop\bin\PortableGit\bin;' + $Env:Path

$progbin = '~\Desktop\bin'
$proggit = '~\Desktop\bin\PortableGit'
$progps = '~\Desktop\bin\psutils'
# 设置为utf-8格式
# $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# posh-git
# Import-Module $progbin\posh-git\src\posh-git.psd1
# 这玩意加载太耗时了，至少300ms起步

# oh-my-posh
Set-Alias oh-my-posh $progbin'\posh-windows-amd64.exe'
oh-my-posh init pwsh | Invoke-Expression
oh-my-posh init pwsh --config $progbin'\oh-my-posh\themes\ys.omp.json' | Invoke-Expression
# 加载完至少300ms

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
# ~\.config\powershell\PSR.ps1
# 自动补全双边符号

# from git
Set-Alias git $proggit\bin\git.exe
Set-Alias bash $proggit\bin\bash.exe
Set-Alias sh $proggit\bin\sh.exe
Set-Alias tig $proggit\usr\bin\tig.exe
Set-Alias less $proggit\usr\bin\less.exe

Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr

# vscode NO.1
Set-Alias notepad code
Set-Alias nano code
Set-Alias vim code
Set-Alias nvim code
Set-Alias emacs code
# neovim: xD
Set-Alias vi $progbin\nvim*\bin\nvim.exe

# utils
# https://github.com/stedolan/jq 管道json格式化输出
Set-Alias jq $progbin\jq*.exe
# https://github.com/gerardog/gsudo
Set-Alias gsudo $progbin\gsudo.exe
Set-Alias curl $progbin\curl*\bin\curl.exe

# https://github.com/lukesampson/psutils
Set-Alias psudo $progps\sudo.ps1
Set-Alias gitignore $progps\gitignore.ps1
Set-Alias ln $progps\ln.ps1
Set-Alias at $progps\runat.ps1
Set-Alias say $progps\say.ps1
Set-Alias shasum $progps\shasum.ps1
Set-Alias time $progps\time.ps1
Set-Alias touch $progps\touch.ps1

Set-Alias sudo gsudo

# ffmpeg
Set-Alias ffmpeg $progbin\ffmpeg.exe
Set-Alias ffplay $progbin\ffplay.exe
Set-Alias ffprobe $progbin\ffprobe.exe

# download
Set-Alias aria2c $progbin\aria2c.exe
Set-Alias yt-dlp $progbin\yt-dlp.exe
Set-Alias rclone $progbin\rclone.exe

# proxy
# https://github.com/SagerNet/sing-box
Set-Alias sing-box $progbin\sing-box.exe
# https://github.com/oluceps/clash2sing-box
Set-Alias ctos $progbin\ctos.exe

# view
Set-Alias magick $progbin\ImageMagick*\magick.exe
Set-Alias img $progbin\ImageMagick*\IMDisplay.exe
Set-Alias music $progbin\foobar2000\foobar2000.exe
Set-Alias mpv $progbin\mpv*\mpv.exe
Set-Alias ndd $progbin\ndd*\notepad--.exe
Set-Alias ahk $progbin\SciTE4AHK*\SciTE\SciTE.exe

# cowsay https://github.com/Code-Hex/Neo-cowsay
Set-Alias cowsay $progbin\cowsay*\cowsay.exe
Set-Alias cowthink $progbin\cowsay*\cowthink.exe
curl -s 'https://v1.hitokoto.cn/?c=k&c=d&c=i&encode=text&charset=gbk' \
--connect-timeout 0.2 -m 0.3 | cowsay
# 防止网络不好获取时间太长，单位秒，可浮点数精确到毫秒

# geek uninstall
Set-Alias geek $progbin\geek.exe

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function rm_rf ($path) { Remove-Item -Recurse -Force $path }
function kills ($name) { kill -ProcessName $name }