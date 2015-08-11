require 'nori'
require 'settings'
require 'utils'
require 'tasks'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

#options
activate :automatic_image_sizes
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
DB = Utils.open_db

#Setup Info
Tasks.load_schema
Tasks.load_info
build_hash = Tasks.get_hashes

#build the site
page "teams/*", :layout => :team
build_hash[:teams].each do |team|
  roster = Rosters.hash(team[:id])
  players = roster.map { |r| Players.find(id: r[:player_id]) }
  proxy "/teams/#{team[:alias].downcase}/index.html", "/teams/single.html", :locals => { :team_info => team, :roster => players }, :ignore => true
end
proxy 'teams/index.html', '/teams/list.html', :locals => { :teams => build_hash[:teams]}, :ignore => true
