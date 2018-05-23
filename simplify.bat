@echo off
rem You can delete all lines that contains unrecognizable words if your system language is not Chinese.

setlocal EnableDelayedExpansion
set py=python
(%py% --version>nul 2>nul)||(set py=py)
(%py% --version>nul 2>nul)||(echo 没有找到 Python.&goto:eof)

if "%~1"=="" (
	echo 命令行：%0 ^<文件名^> [块宽度] [块高度] [模型]
	echo Command: %0 ^<file^> [tile width] [tile height] [model]
	echo.
	echo 程序会将处理后的图片保存至与原图片相同的路径中并命名为“out_”+原文件名。
	goto:eof
)
call:rtime
set tmpdir="%~dpn1_tmp"
set dw=%~2
set dh=%~3
set model=%~4
if "%dw%"=="" set dw=500
if "%dh%"=="" set dh=500
if "%model%"=="" set model=model_gan.t7
md %tmpdir%
%py% imdiv.py --img "%~1" --out_fmt %tmpdir%/div_%%d_%%d.png --dw %dw% --dh %dh%
set count_all=0
for %%i in (%tmpdir%\div_*.png) do set /a count_all+=1
set count_y=0
for %%i in (%tmpdir%\div_*.png) do (
	echo !count_y!/%count_all%: %%i → out_%%~nxi...
	%py% simplify.py --img %%i --out %tmpdir%/out_%%~nxi --model %model%
	set /a count_y+=1
)
set count_x=0
for %%i in (%tmpdir%\div_0_*.png) do (
	set /a count_x+=1
)
set /a count_y/=count_x
for %%i in (%model%) do set model_name=%%~ni
%py% imcmb.py --img_fmt %tmpdir%/out_div_%%d_%%d.png --out "%~dp1/%model_name%_%dw%_%dh%_%~nx1" --nx %count_x% --ny %count_y%
echo Saved to %~dp1%model_name%_%dw%_%dh%_%~nx1.
rd /s /q %tmpdir%
call:etime
goto:eof
:rtime
set h0=%h1%
set m0=%m1%
set s0=%s1%
set h1=%time:~0,2%
set m1=%time:~3,2%
set s1=%time:~6,2%
goto:eof
:etime
call:rtime
set /a s1-=s0
if /i %s1% lss 0 (
	set /a s1+=60
	set /a m1-=1
)
set /a m1-=m0
if /i %m1% lss 0 (
	set /a m1+=60
	set /a h1-=1
)
set /a h1-=h0
if /i %h1% lss 0 set /a h1+=24
echo Time: %h1%:%m1%:%s1%.
goto:eof