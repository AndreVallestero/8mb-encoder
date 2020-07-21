@echo off

set LIMIT=8388157
set base_name=%~n1
set temp_dir=temp\

if "%~1" == "" (set source_file=source.mkv) else (set source_file=%1)
echo Source file: %source_file%
echo Size limit: %LIMIT%B

for /f "tokens=* usebackq" %%d in (`"tools\ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 %source_file%"`) do (
	set duration=%%d
)
for /f "tokens=1 delims=." %%d  in ("%duration%") do (set duration=%%d)
echo Source duration: %duration%s& echo.

if "%~2" == "custom" goto :custom

REM Refine this formula. 20minutes should at least be 14kbps. 30minutes should be 12kbps
set /a "audio_bitrate=1320000 / %duration% + 10000"
if %audio_bitrate% GTR 32768 (set audio_bitrate=32768)
if %audio_bitrate% LSS 10240 (set audio_bitrate=10240)
call tools\audio.bat %source_file% %audio_bitrate%
FOR %%A IN (%temp_dir%%base_name%-audio.opus) DO set audio_size=%%~zA
echo Audio size: %audio_size%B& echo.

set /a "video_bitrate=(%LIMIT% - %audio_size%) * 8 / (%duration% * 1024)"
call tools\video.bat %source_file% %video_bitrate%
FOR %%A IN (%temp_dir%%base_name%-video.mkv) DO set video_size=%%~zA
echo Video size: %video_size%B& echo.

call tools\merge.bat %source_file%
FOR %%A IN (%base_name%-8mb.webm) DO set final_size=%%~zA
echo Final size: %final_size%B& echo.
echo 8MB encode complete
pause
goto :eof

:custom
call tools\audio.bat %source_file% 12k
call tools\video.bat %source_file% 128
call tools\merge.bat %source_file%
goto :eof
