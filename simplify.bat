@echo off
rem You can delete all lines that contains unrecognizable words if your system language is not Chinese.

rem �����Ҫʵ����ק����ִ�еĲ�������Ҫָ���㰲װ�� Anaconda3 ��·����
rem If you want to simplify your image by dragging files onto this script, you should specify the path where Anaconda3 is installed.
set conda_dir=G:\Anaconda3

if "%~1"=="" (
	echo �����У�%0 ^<�ļ���^>
	echo Command: %0 ^<file^>
	echo.
	echo ����Ὣ������ͼƬ��������ԭͼƬ��ͬ��·���в�����Ϊ��out_��+ԭ�ļ�����
	echo ��ʾ������ Anaconda3 �����л��������и����
	goto:eof
)
(conda -V>nul 2>nul)||(call "%conda_dir%\Scripts\activate.bat" 2>nul)||(
	echo ��û���� Anaconda3 ���������и����
	goto:eof
)
md tmp
python imdiv.py --img "%~1" --out_fmt tmp/div_%%d_%%d.png
set count_y=0
for %%i in (tmp\div_*.png) do (
	python simplify.py --img %%i --out tmp/out_%%~nxi
	set /a count_y+=1
)
set count_x=0
for %%i in (tmp\div_0_*.png) do (
	set /a count_x+=1
)
set /a count_y/=count_x
python imcmb.py --img_fmt tmp/out_div_%%d_%%d.png --out "%~dp1/out_%~nx1" --nx %count_x% --ny %count_y%
rd /s /q tmp
