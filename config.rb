require 'nori'
require 'settings'
require 'utils'
require 'tasks'
Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

#options
#activate :trailing_slashes #This should have worked. Didn't. Add / everywhere
activate :relative_assets
set :relative_links, true
activate :automatic_image_sizes
set :css_dir, './stylesheets'
set :js_dir, './javascripts'
set :images_dir, './images'

#Setup Info
Tasks.load_schema
Tasks.load_info
Tasks.dump_info

teams = Teams.all
teams.each do |team|
  roster= Rosters.hash(team[:id])
  players = roster.map { |r| Players.find(id: r[:player_id]) }
  proxy "/teams/#{team[:alias].downcase}/index.html", "/models/teams/single.html",
        :locals => { :team_info => team, :roster => players }, :ignore => true
end
proxy '/teams/index.html', '/models/teams/list.html',
      :locals => { :teams => teams}, :ignore => true

players = Players.all
players.each do |player|
  proxy "/players/#{player[:url_name]}/index.html", "/models/players/single.html",
        :locals => { :player => player }, :ignore => true
end
proxy '/players/index.html', '/models/players/list.html',
      :locals => { :players => players}, :ignore => true

games = Games.all
games.each do |game|
  proxy "/games/NWSL#{game[:id]}/index.html", "/models/games/single.html",
        :locals => { :game => game }, :ignore => true
  proxy "/games/NWSL#{game[:id]}/stats/index.html", "/models/games/stats.html",
        :locals => { :game => game }, :ignore => true
  events = Events.where(:game_id => game.id)
  proxy "/games/NWSL#{game[:id]}/pbp/index.html", "/models/games/pbp.html",
        :locals => { :game => game, :events => events }, :ignore => true
end
proxy '/games/index.html', '/models/games/list.html',
      :locals => { :games => games}, :ignore => true

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :git
  deploy.branch = 'gh-pages' # default: gh-pages
end

# For diagnosis
#require 'ruby-prof'
#RubyProf.start
#result = RubyProf.stop
# Print a flat profile to text
#printer = RubyProf::FlatPrinter.new(result)
#printer.print(STDOUT)
