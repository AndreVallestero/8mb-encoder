@echo off

REM sample rates: 8, 12, 16, 24, 48(default)
REM -ar is better than -cutoff
REM removing chapters saves a few KB

REM adjusting sample rate affects quality much more than bitrate
REM set sample_rate=16k
REM -ar %sample_rate% ^
set bitrate_audio=12k

set base_name=%~n1
set temp_dir=temp\
if not exist %temp_dir% mkdir %temp_dir%

echo Encoding audio from %1 @ ~%bitrate_audio%bps
tools\ffmpeg ^
	-v 0 ^
	-stats ^
	-i %1 ^
	-vn ^
	-c:a libopus ^
	-b:a %bitrate_audio% ^
	-ac 1 ^
	-sn ^
	-map_chapters -1 ^
	%temp_dir%%base_name%-audio.opus
echo Saved encoded audio to "%temp_dir%%base_name%-audio.opus"