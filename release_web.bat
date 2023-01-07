@echo off

call flutter clean
call flutter pub get
del pubspec.lock

call flutter build web --release

rmdir /s /q website
mkdir website

xcopy /s /y build\web\ website\