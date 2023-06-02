@echo off
:build

call fvm flutter clean
del pubspec.lock
call fvm flutter pub get

goto end
:end