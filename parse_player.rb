require 'rubygems'
require 'nokogiri'
require 'open-uri'

MYSPACE_PROFILE_URL = "http://myspace.com/%s"
MYSPACE_PROFILE_PLAYER_XPATH = '/html/body/table//div[@id="profile_mp3Player"]'
 
doc = Nokogiri::HTML(open(MYSPACE_PROFILE_URL % 'officialrustmusic'))
doc.xpath(MYSPACE_PROFILE_PLAYER_XPATH).each do |player|
  puts player
end
