@echo off

:build

call "c:\src\flutter\bin\flutter" pub run build_runner watch --delete-conflicting-outputs

goto end

:end