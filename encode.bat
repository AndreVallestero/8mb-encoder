@echo off

if "%~1" == "" (
	call tools\audio.bat source.mkv
	call tools\video.bat source.mkv
	call tools\merge.bat source.mkv
) else (
	call tools\audio.bat %1%
	call tools\video.bat %1%
	call tools\merge.bat %1%
)
