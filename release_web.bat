@echo off

call flutter clean
call flutter pub get
del pubspec.lock

call flutter build web --release

REM rmdir /s /q website
REM mkdir website

xcopy /s /y build\web\ website\