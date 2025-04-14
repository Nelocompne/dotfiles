#Requires AutoHotkey v2.0

SUWA := " \local\share\Suwayomi-Server-v1.1.1-r1535-windows-x64\bin\Suwayomi-Server.jar "
SUWAENV := ' -Dsuwayomi.tachidesk.config.server.rootDir="\local\etc\Suwayomi-Server" '
WORKDIR := '\local\share\Suwayomi-Server-v1.1.1-r1535-windows-x64\jre\bin'
JUSTGO := " /c title Suwayomi Server && java.exe -jar -Xmx1g " SUWAENV SUWA

;MSGBOX JUSTGO
Run A_ComSpec JUSTGO, WORKDIR, "Min"
