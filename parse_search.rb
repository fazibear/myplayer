require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'

MYSPACE_SEARCH_URL = "http://searchservice.myspace.com/index.cfm?fuseaction=sitesearch.results&type=Music&qry=%s&musictype=2&pg=%i"
MYSPACE_SEARCH_RASULT_XPATH = '/html/body/div[@id="wrap"]/form[@id="aspnetForm"]/div[@id="siteSearchContent"]/div[@id="leftColumn"]/div[@class="artistSearchResult artistPageResult"]/span[@class="artistInfo"]/a'
 
5.times do |x|
  doc = Nokogiri::HTML(open(MYSPACE_SEARCH_URL % ['rust', x]))
  doc.xpath(MYSPACE_SEARCH_RASULT_XPATH).each do |link|
    puts link.attributes['href'].to_s.gsub('http://www.myspace.com/','')
  end
end
