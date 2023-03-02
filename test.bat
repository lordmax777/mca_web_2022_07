@echo off
set year=%DATE:~10,4%
set month=%DATE:~4,2%
set day=%DATE:~7,2%
set hour=%TIME:~0,2%
set minute=%TIME:~3,2%
set second=%TIME:~6,2%
set datestr=%year%-%month%-%day% %hour%:%minute%:%second%
echo The current date is: %datestr%
