#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%


FileDelete, %A_Desktop%\tools\Clash.Mini_v0.2.2_x64\cache.db
FileDelete, C:\Users\%A_UserName%\.config\clash-verge\cache.db
FileDelete, C:\Users\%A_UserName%\.config\clash\cache.db