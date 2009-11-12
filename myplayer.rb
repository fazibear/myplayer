require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'cgi'

MYSPACE_SEARCH_URL = "http://searchservice.myspace.com/index.cfm?fuseaction=sitesearch.results&type=Music&qry=%s&musictype=2&pg=%i"
MYSPACE_SEARCH_RASULT_XPATH = '/html/body/div[@id="wrap"]/form[@id="aspnetForm"]/div[@id="siteSearchContent"]/div[@id="leftColumn"]/div[@class="artistSearchResult artistPageResult"]'

MYSPACE_PROFILE_URL = "http://myspace.com/%s"
MYSPACE_PROFILE_PLAYER_XPATH = '/html/body/table//div[@id="profile_mp3Player"]'

LAST_FM_SIMILAR_URL = "http://ws.audioscrobbler.com/2.0/artist/%s/similar"
LAST_FM_SIMILAR_XPATH = "/similarartists/artist/name"

get '/' do
  @@last_player ||= ''
  @last_player = @@last_player
  erb :index
end

get '/search/:query/:page' do
  begin
    query = params[:query] || ''
    query =  CGI::escape(query)
    page = params[:page] || 1
    @result = []
    doc = Nokogiri::HTML(open(MYSPACE_SEARCH_URL % [query, page]))
    doc.xpath(MYSPACE_SEARCH_RASULT_XPATH).each do |res|
      image = res.xpath('./div/a/img').first
      link =  res.xpath('./span/a').first
      if image && link
        @result << {
          :name => image.attributes['title'].to_s,
          :code => link.attributes['href'].to_s.gsub('http://www.myspace.com/','')
        } 
      end
    end
  rescue => e
  end
  erb :search
end

get '/player/:profile' do
  begin
    @player = ""
    doc = Nokogiri::HTML(open(MYSPACE_PROFILE_URL % params[:profile]))
    doc.xpath(MYSPACE_PROFILE_PLAYER_XPATH).each do |player|
      @player = player.to_s
    end
  rescue => e
  end
  @@last_player = @player
  erb :player
end

get '/similar/:query' do
  begin
    query = params[:query] || ''
    query =  CGI::escape(query)
    @result = []
    puts query
    doc = Nokogiri::XML(open(LAST_FM_SIMILAR_URL % query))
    doc.xpath(LAST_FM_SIMILAR_XPATH).each do |name|
      @result << name.content
    end
  rescue => e
  end
  erb :similar
end
