::配置库路径
set lib_name=libmdb.so
set lib_dir=D:\svn\prolin_wsp\unattended\mdb\main\mdb\default
set self_lib_dir=..\lib

set cur_dir=%cd%
cd %lib_dir%
make
cd %cur_dir%

copy %lib_dir%\%lib_name% %self_lib_dir%\

choice /t 5 /d n /m "press y to lock the message, n or 5s timeout to exit"
if errorlevel 2 goto eof
pause
:eof