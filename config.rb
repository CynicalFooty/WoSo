require 'nori'
require 'settings'
require 'utils'
require 'tasks'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

#options
#activate :trailing_slashes
activate :relative_assets
set :relative_links, true
activate :automatic_image_sizes
set :css_dir, './stylesheets'
set :js_dir, './javascripts'
set :images_dir, './images'

DB = Utils.open_db

#Setup Info
Tasks.load_schema
Tasks.load_info
build_hash = Tasks.get_hashes

#build the site
#page "teams/*", :layout => :teams
build_hash[:teams].each do |team|
  roster = Rosters.hash(team[:id])
  players = roster.map { |r| Players.find(id: r[:player_id]) }
  proxy "/teams/#{team[:alias].downcase}/index.html", "/teams/single.html", :locals => { :team_info => team, :roster => players }, :ignore => true
end
proxy '/teams/index.html', '/teams/list.html', :locals => { :teams => build_hash[:teams]}, :ignore => true

#page "players/*", :layout => :players
build_hash[:players].each do |player|
  proxy "/players/#{player[:full_name].gsub(/[^0-9a-z]/i, '').downcase}/index.html", "/players/single.html", :locals => { :player => player }, :ignore => true
end
proxy '/players/index.html', '/players/list.html', :locals => { :players => build_hash[:players]}, :ignore => true

build_hash[:games].each do |game|
  proxy "/games/NWSL#{game[:id]}/index.html", "games/list.html", :locals => { :game => game }, :ignore => true
end
proxy '/games/index.html', '/games/list.html', :locals => { :games => build_hash[:games]}, :ignore => true

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :git
  deploy.branch   = 'gh-pages' # default: gh-pages
end
