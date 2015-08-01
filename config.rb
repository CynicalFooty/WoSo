require 'nori'

#options

activate :automatic_image_sizes
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :relative_links, true

#Build out the site

parser = Nori.new

#Team Building (ha)
team_info = File.read('./source/data/NWSL_TEAM_INFO.XML')
team_hash = parser.parse(team_info)
teams = team_hash['sports_statistics']['sports_teams']['ifb_soccer_teams']['team_info']

page "teams/*", :layout => :team
teams.each do |team|
  proxy "/teams/#{team['@alias'].downcase}/index.html", "/teams/single.html", :locals => { :team_info => team }, :ignore => true
end
proxy 'teams/index.html', '/teams/list.html', :locals => { :teams => teams}, :ignore => true
