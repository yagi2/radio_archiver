# -*- coding: utf-8 -*-
require 'net/http'
require 'nokogiri'

uri = URI.parse("http://image.hibiki-radio.jp/uploads/data/channel/ff/1658.xml")

res = Net::HTTP.get_response(uri)
unless res.is_a?(Net::HTTPSuccess)
  return nil
end

dom = Nokogiri::HTML.parse(res.body)

protocol = dom.css('protocol').text
domain = dom.css('domain').text
dir = dom.css('dir').text
flv = dom.css('flv').text

m = /^.+?\:(.+)$/.match(flv)
filename_query = m[1]

rtmp_url = "#{protocol}://#{domain}/#{dir}/#{filename_query}"

p rtmp_url

rtmpdump = '/usr/bin/rtmpdump'

current = '/home/yagi2/Dropbox/agqr'
save_dir = "#{current}/data/flv"

mmm_day = Time.now.strftime("%Y%m%d").to_s
flv_path = "#{save_dir}/南條愛乃_エオルゼアより愛をこめて_#{mmm_day}.flv"

p "南條愛乃_エオルゼアより愛をこめて_#{mmm_day}.flv"
  
rec_command = "#{rtmpdump} -r \"#{rtmp_url}\" -o #{flv_path} >/dev/null 2>&1"
  
system rec_command
