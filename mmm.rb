# -*- coding: utf-8 -*-

p Time.now.strftime("%Y%m%d").to_s + " [mmm.rb] start up."

if Time.now.friday? && ((Time.now.day > 7 && Time.now.day <= 14) || (Time.now.day > 21 && Time.now.day <= 28)) then 
  p "録音開始"

  mmm_day = Time.now.strftime("%Y%m%d").to_s
  rtmpdump = '/usr/bin/rtmpdump'
  mmm_stream_url = "rtmp://051.mediaimage.jp/marine-str/media/mp3:mmm" + mmm_day
  
  current = '/home/yagi2/Dropbox/agqr'
  save_dir = "#{current}/data/flv"
  
  flv_path = "#{save_dir}/由佳・ありさ・未奈美のMラジ_#{mmm_day}.flv"
  
  rec_command = "#{rtmpdump} -r #{mmm_stream_url} -o #{flv_path} >/dev/null 2>&1"
  
  system rec_command
end
