@echo off

REM Add the following 2 lines before --aq-mode for vmaf
REM --vmaf-model-path=tools\model\vmaf_v0.6.1.pkl ^
REM --tune=vmaf ^

REM Set to 5 when testing for max speed, else 0
set cpu=0
REM Set denoise to 0 for live action, 25 or higher for anime / cartoons to reduce artifacts up to 50
set denoise=0
REM Set aq to 2 for anime / cartoons, else 1, use 0 if weird results or quantization errors
set aq=1
set bitrate_video=64
set framerate=12000/1001
set width=480
set height=360

set base_name=%~n1
set temp_dir=temp\
if not exist %temp_dir% mkdir %temp_dir%

echo Encoding video pass 1 from %1 @ ~%bitrate_video%kbps
tools\ffmpeg ^
	-v 0 ^
	-i %1 ^
	-sn ^
	-map_chapters -1 ^
	-pix_fmt yuv420p ^
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
		--target-bitrate=%bitrate_video% ^
		--enable-fwd-kf=1 ^
		--lag-in-frames=25 ^
		--cpu-used=%cpu% ^
		--row-mt=0 ^
		--vmaf-model-path=tools\model\vmaf_v0.6.1.pkl ^
		--tune=vmaf ^
		--aq-mode=%aq% ^
		--denoise-noise-level=%denoise% ^
		--fpf=%temp_dir%%base_name%-pass1.log ^
		--output=NUL
echo Encoding video pass 2 from %1 @ ~%bitrate_video%kbps
tools\ffmpeg ^
	-v 0 ^
	-i %1 ^
	-sn ^
	-map_chapters -1 ^
	-pix_fmt yuv420p ^
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
		--target-bitrate=%bitrate_video% ^
		--enable-fwd-kf=1 ^
		--lag-in-frames=25 ^
		--cpu-used=%cpu% ^
		--row-mt=0 ^
		--vmaf-model-path=tools\model\vmaf_v0.6.1.pkl ^
		--tune=vmaf ^
		--aq-mode=%aq% ^
		--denoise-noise-level=%denoise% ^
		--fpf=%temp_dir%%base_name%-pass1.log ^
		--output=%temp_dir%%base_name%-video.mkv
echo Saved encoded video to "%temp_dir%%base_name%-video.mkv"