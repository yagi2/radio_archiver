# -*- coding: utf-8 -*-
ffmpeg = '/usr/bin/ffmpeg'

flv_files = Dir.glob("**/*.flv")

flv_files.each { |f| 
  flv_path = Dir.pwd + "/" + f
  mp4_path = Dir.pwd[0, Dir.pwd.rindex("/")] + "/mp4/conv/" + f[0, f.rindex(".")] + ".mp4"
  save_dir = mp4_path[0, mp4_path.rindex("/")]

  Dir.mkdir(save_dir) if !File.exist?(save_dir)

  p " "
  p "CONVERT FLV to MP4 : " + f
  p " "
  
  convert_command = "#{ffmpeg} -i #{flv_path} -threads 5 -vcodec libx264 -vpre libx264-default #{mp4_path}"

  system convert_command
  p save_dir
}

p "FINISH CONVERT"
