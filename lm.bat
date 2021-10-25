@echo off
REM 配置区==================================================
REM 工程目录
set prj_dir=..
REM SDK目录（注意路径不要有中文或者空格等符号）
set sdk_dir=D:\software\SDK\prolin
REM 下载工具路径（不涉及下载的工程无需关注）（注意路径不要有中文或者空格等符号）
set loader_dir=D:\software\tool\pax\TermAssist\tools
REM 下载信道的虚拟串口号（不涉及下载的工程无需关注）
set com_index=5
REM 设置应用执行程序名（如果工程名与执行程序名相同，此处不需要设置）
set bin_name=
REM 配置区---------------------------------------------------




REM 配置计算或默认配置区=============
set cur_dir=%cd%
cd %prj_dir%
set prj_dir=%cd%
cd %cur_dir%
if "%bin_name%"=="" (
	for %%i in (%prj_dir%) do (set bin_name=%%~nxi)
)
set xcb=%loader_dir%\xcb
set zip=%loader_dir%\7za
set output_zip=%prj_dir%\pkg\%bin_name%.aip
set zip_files_list=appinfo .\default\%bin_name% res\ data\ lib\
set zip_add_files_list=appinfo .\default\%bin_name%
set make=%sdk_dir%\sdk\tools\msys\bin\make
REM 配置计算或默认配置区-------------



REM 对外提供的命令选项==============
if "%1"=="make" (
	REM 编译
	call :func_prolin_build
) else if "%1"=="clean" (
	REM 清空编译产物
	call :func_prolin_build clean
) else if "%1"=="pack" (
	REM 打包app
	call :func_prolin_pack  %zip_files_list%
) else if "%1"=="add_pack" (
	REM 增量打包app（仅打包执行程序）
	call :func_prolin_pack %zip_add_files_list%
) else if "%1"=="load" (
	REM 安装app
	call :func_prolin_xcb_op installer aip %output_zip%
) else if "%1"=="clear" (
	REM 清除APP
	call :func_prolin_xcb_op installer uaip MAINAPP
) else if "%1"=="log" (
	REM 查询日志
	echo log [start]
	call :func_prolin_xcb_op logcat -c
	call :func_prolin_xcb_op logcat "*:e"
) else if "%1"=="telnetd" (
	REM 打开telnet服务器
	call :func_prolin_xcb_op telnetd
) else (
	REM 默认仅编译
	call :func_prolin_build
)
REM 对外提供的命令选项---------------



REM 隔离函数区
goto:eof



REM 函数区======================================
:func_prolin_pack
echo "pack"
echo zip=%zip%
echo bin_name=%bin_name%
echo output_zip=%output_zip%
echo zip_files_list=%zip_files_list%
del /q %output_zip%
cd %prj_dir%
@echo on
%zip% a -r -tzip %output_zip% %*
@echo off
cd %cur_dir%
goto:eof

:func_prolin_xcb_op
%xcb% connect com:COM%com_index%
%xcb% %*
goto:eof

:func_prolin_build
%make% %1
goto:eof

REM 函数区-----------------------------------------



REM 说明区==========================================
goto comment
脚本说明
环境部署流程】
1、把该脚本文件夹(bat)放置到工程的编译目录下(一般为default或default_runthos，makefile所处目录)
2、使用文本编辑器lm.bat文件，按提示配置脚本

脚本指南】
lm make：仅编译
lm clean：仅clean
lm load：仅安装
lm pack: 仅打包
lm: 仅编译

组合使用示例：
lm make & lm load： 编译后进行安装
以此类推
:comment
REM 说明区-------------------------------------------