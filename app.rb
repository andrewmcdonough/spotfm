require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'meta-spotify'
require 'haml'
require 'scrobbler'


def lastfm_url(username)
  "http://www.last.fm/user/#{username}"
end

def get_top_artists(username)
  u = Scrobbler::User.new(username)
  u.top_artists.collect {|u| u.name }[0..10]
end

def spotify_artist_link(artist)
  begin
    spotify_uri = MetaSpotify::Artist.search(artist)[:artists].first.uri
    "<a href='#{spotify_uri}'>#{artist}</a>"
  rescue
    "<span class='not_found'>#{artist}</span> <span class='not_found_message'>(not found on Spotify)</span>"
  end
end

get '/' do
  @username = params[:username]
  unless @username.nil?
    begin 
      @upcoming_artists = get_top_artists(@username)
    rescue
      @message = "Last.fm user not found: #{@username}"
      @upcoming_artists = []
    end
  end
  haml :index
end
