@echo off

REM Add the following 2 lines before --aq-mode for vmaf
REM --vmaf-model-path=tools\model\vmaf_v0.6.1.pkl ^
REM --tune=vmaf ^

set video_bitrate=%~n2
echo Video bitrate: %video_bitrate%kbps

REM Set to 6 when testing and debugging for max speed, else 0
set cpu=6
REM Set to 1 to enable row multi-threading, else 0
set row_mt=1
REM Set denoise to 0 for live action, 25 or higher for anime / cartoons to reduce artifacts up to 50
set denoise=0
REM Set aq to 2 for anime / cartoons, else 1, use 0 if weird results or quantization errors
set aq=0

REM set width=480
set width=1280
REM set height=360
set height=720

set framerate=24000/1001

set base_name=%~n1
set temp_dir=temp\
if not exist %temp_dir% mkdir %temp_dir%

tools\ffmpeg ^
	-v 0 ^
	-i %1 ^
	-sn ^
	-map_chapters -1 ^
	-pix_fmt yuv420p ^
	-vsync vfr ^
	-r %framerate% ^
	-f yuv4mpegpipe ^
	-| tools\aomenc.exe - ^
		--passes=2 ^
		--pass=1 ^
		--width=%width% ^
		--height=%height% ^
		--fps=%framerate% ^
		--bit-depth=10 ^
		--kf-max-dist=99999 ^
		--auto-alt-ref=1 ^
		--target-bitrate=%video_bitrate% ^
		--enable-fwd-kf=1 ^
		--lag-in-frames=25 ^
		--cpu-used=%cpu% ^
		--row-mt=%row_mt% ^
		--vmaf-model-path=tools\model\vmaf_v0.6.1.json ^
		--tune=vmaf ^
		--aq-mode=%aq% ^
		--denoise-noise-level=%denoise% ^
		--fpf=%temp_dir%%base_name%-pass1.log ^
		--output=NUL
tools\ffmpeg ^
	-v 0 ^
	-i %1 ^
	-sn ^
	-map_chapters -1 ^
	-pix_fmt yuv420p ^
	-vsync vfr ^
	-r %framerate% ^
	-f yuv4mpegpipe ^
	-| tools\aomenc.exe - ^
		--passes=2 ^
		--pass=2 ^
		--width=%width% ^
		--height=%height% ^
		--fps=%framerate% ^
		--bit-depth=10 ^
		--kf-max-dist=99999 ^
		--auto-alt-ref=1 ^
		--target-bitrate=%video_bitrate% ^
		--enable-fwd-kf=1 ^
		--lag-in-frames=25 ^
		--cpu-used=%cpu% ^
		--row-mt=0 ^
		--vmaf-model-path=tools\model\vmaf_v0.6.1.json ^
		--tune=vmaf ^
		--aq-mode=%aq% ^
		--denoise-noise-level=%denoise% ^
		--fpf=%temp_dir%%base_name%-pass1.log ^
		--output=%temp_dir%%base_name%-video.mkv
echo Video saved: %temp_dir%%base_name%-video.mkv
