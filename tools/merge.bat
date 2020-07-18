@echo off

set base_name=%~n1
set temp_dir=temp\

tools\mkvmerge %temp_dir%%base_name%-video.mkv %temp_dir%%base_name%-audio.opus -w -o %base_name%-8mb.webm
echo Final merge saved: %base_name%-8mb.webm