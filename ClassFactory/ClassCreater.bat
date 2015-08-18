::
:: ClassCreater.bat
:: tools
::
:: Created by Carl on 15/05/10.
:: Copyright (c) 2015 Carl. All rights reserved.
::

@echo off

::设置类名
set /p className=class name:

call :strSub TemplateClass.h %className%.h Carl CocosCppTest
call :strSub TemplateClass.cpp %className%.cpp Carl CocosCppTest

pause

goto :eof


::--------------------------------
::--------------------------------
:strSub

::设置环境
setlocal enabledelayedexpansion

cd. > %2

::替换文本中的类名写到新文件中
for /f "tokens=1* delims=:" %%i in ('findstr /n .* %1') do (
	set str=%%j
	if not "!str!"=="" (
		set str=!str:fileName=%2!
		set str=!str:projectName=%4!
		set str=!str:TemplateClass=%className%!
		set str=!str:createTime=%date:~2,8%!
		set str=!str:copyrightYear=%date:~0,4%!
		set str=!str:programmerName=%3!
		echo !str!>> %2
	) else (
		echo.>> %2
	)	
)

goto :eof

