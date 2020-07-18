# 8mb-encoder

Batch scripts based on Aomenc, FFMPEG, and MKVToolNix to create the highest quality videos under 8MB

![image](https://user-images.githubusercontent.com/39736205/87861680-97b66d00-c916-11ea-92d1-0a67f574b00f.png)

## Required downloads

Place all of the following executables in the `tools` directory

- https://ci.appveyor.com/project/f11894/aom/build/artifacts
	- aom_vmaf > model
	- aom_vmaf > aomenc.exe

- https://www.fosshub.com/MKVToolNix.html
	- Windows portable 64bit > mkvtoolnix > mkvmerge.exe
	
- https://ffmpeg.zeranoe.com/builds/
	- Download Build > bin > ffmpeg.exe
	- Download Build > bin > ffprobe.exe

## Usage

There are 3 ways to use the encode.bat
- Drag your file on encode.bat
- Run `encode.bat <filename>` in cmd where `<filename>` the name of your video file
- Name your file `source.mkv` and run encode.bat by double clicking or via cmd

## Notes

- Muxing with MKVToolNix is not necessary but results in a smaller webm or mkv than ffmpeg
- webm is generally smaller than mkv

## TODO
- Once merging, if not past limit, keep re-encoding audio with higher bitrate until larger than 8MB to fill the rest of the space
	- Increase by 100bps increments