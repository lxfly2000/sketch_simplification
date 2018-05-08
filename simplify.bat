@echo off
rem You can delete all lines that contains unrecognizable words if your system language is not Chinese.

set py=python
(%py% --version>nul 2>nul)||(set py=py)
(%py% --version>nul 2>nul)||(echo 没有找到 Python.&goto:eof)

if "%~1"=="" (
	echo 命令行：%0 ^<文件名^>
	echo Command: %0 ^<file^>
	echo.
	echo 程序会将处理后的图片保存至与原图片相同的路径中并命名为“out_”+原文件名。
	goto:eof
)
md tmp
%py% imdiv.py --img "%~1" --out_fmt tmp/div_%%d_%%d.png
set count_y=0
for %%i in (tmp\div_*.png) do (
	%py% simplify.py --img %%i --out tmp/out_%%~nxi
	set /a count_y+=1
)
set count_x=0
for %%i in (tmp\div_0_*.png) do (
	set /a count_x+=1
)
set /a count_y/=count_x
%py% imcmb.py --img_fmt tmp/out_div_%%d_%%d.png --out "%~dp1/out_%~nx1" --nx %count_x% --ny %count_y%
rd /s /q tmp
