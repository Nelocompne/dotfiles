#Requires AutoHotkey v2.0

KOMGA := " \local\share\komga-1.15.1.jar "
KOMGAENV := ' --komga.config-dir="\local\etc\komga-data\.komga" '
WORKDIR := '\local\share\jdk-17.0.13+11\bin\'
JUSTGO := " /c title komga service && java.exe -jar -Xmx1g " KOMGA KOMGAENV

;MSGBOX JUSTGO

Run A_ComSpec JUSTGO, WORKDIR, "Min"
