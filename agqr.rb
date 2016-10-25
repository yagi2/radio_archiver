# -*- coding: utf-8 -*-
# record AGQR
# usage: use with crontab
# 29,59 * * * * sleep 55; ruby agqr.rb
# requirements
# crontab, ruby >= 2.0, ffmpeg, rtmpdump

require 'yaml'

rtmpdump = '/usr/bin/rtmpdump'
ffmpeg = '/usr/bin/ffmpeg'
agqr_stream_url = 'rtmp://fms-base1.mitene.ad.jp/agqr/aandg22'

current = '/home/yagi2/Dropbox/agqr'

save_dir = "#{current}/data"
Dir.mkdir(save_dir) if !File.exist?(save_dir)

schedule = "#{current}/schedule.yaml"
if !File.exist?(schedule)
  puts "Config file (#{schedule}) is not found!"
  puts "Please make #{schedule}."
  exit 1
end

today = Time.now

# WDAY = %w(日 月 火 水 木 金 土).zip((0..6).to_a).to_h

schedule_yaml = YAML.load_file(schedule)
schedule_yaml.each do |program|

  #program_wday = WDAY[program['wday']]
  program_wday = program['wday']

  is_next_day_program = false

  # appropriate wday
  h, m = program['time'].split(':').map(&:to_i)
  if h.zero? && m.zero?
    # check next day's wday
    # if today.wday is 6 (Sat), next_wday is 0 (Sun)
    next_wday = (today.wday + 1).modulo(7)
    is_appropriate_wday = program_wday == next_wday
    is_next_day_program = true
  else
    # check today's wday
    is_appropriate_wday = program_wday == today.wday
  end

  # appropriate time
  if is_next_day_program
    # 日付を跨ぐので録音開始の日付が1日ずれる
    next_day = today + 60 * 60 * 24
    # today.day + 1 してたら 31 を超えるとTimeがエラー吐く
    program_start = Time.new(next_day.year, next_day.month, next_day.day, h, m, 0)
  else
    program_start = Time.new(today.year, today.month, today.day, h, m, 0)
  end

  is_appropriate_time = (program_start - today).abs < 120

  length = program['length'] * 60 + 10

  if is_appropriate_wday && is_appropriate_time
    title = (program['title'].to_s + '_' + today.strftime('%Y%m%d')).gsub(' ','')
    flv_path = "#{save_dir}/flv/#{title}.flv"

    # record stream
    rec_command = "#{rtmpdump} -r #{agqr_stream_url} --live -B #{length} -o #{flv_path} >/dev/null 2>&1"
    system rec_command

    # encode flv -> m4a
    m4a_path = "#{save_dir}/mp3/#{title}.m4a"
    m4a_encode_command = "#{ffmpeg} -y -i #{flv_path} -vn -acodec copy #{m4a_path} >/dev/null 2>&1"
    system m4a_encode_command

    # encode m4a -> mp3
    mp3_path = "#{save_dir}/mp3/#{title}.mp3"
    mp3_encode_command = "#{ffmpeg} -i #{m4a_path} #{mp3_path} >/dev/null 2>&1"
    system mp3_encode_command

    # delete m4a
    system "rm -rf #{m4a_path}"

    # encode flv -> mp4
    mp4_path = "#{save_dir}/mp4/#{title}.mp4"
    mp4_encode_command = "#{ffmpeg} -i #{flv_path} -vcodec libx264 -vpre libx264-default #{mp4_path} > /dev/null 2>&1"
    system mp4_encode_command
    
    # delete flv file
    system "rm -rf #{flv_path}"
  end

end
