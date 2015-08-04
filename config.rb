require 'nori'
require 'settings'
require 'utils'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
#options

activate :automatic_image_sizes
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :relative_links, true
DB = Utils.open_db

teams = Teams.xml
rosters = Rosters.xml

page "teams/*", :layout => :team
teams.each do |team|
  proxy "/teams/#{team['@alias'].downcase}/index.html", "/teams/single.html", :locals => { :team_info => team }, :ignore => true
end
proxy 'teams/index.html', '/teams/list.html', :locals => { :teams => teams}, :ignore => true

#rosters.each do |roster|
#  players = roster['ifb_roster_player']
#  players.each do |player|
#    proxy "/players/#{player[]}"
#  end
#end
