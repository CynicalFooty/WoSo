require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nori'
require 'settings'
require 'utils'

class Tasks
  def self.download_nwsl
    agent = Mechanize.new{ | agent| agent.history.max_size = 0}
    parser = Nori.new

    agent.user_agent = 'Mozilla/5.0'
    agent.pluggable_parser.default = Mechanize::Download

    roster_url = NWSL[:url] + NWSL[:roster][:file_name]
    roster_file_path = NWSL[:file_path] + NWSL[:roster][:file_name]
    agent.get(roster_url).save!(roster_file_path)

    schedule_url = NWSL[:url] + NWSL[:schedule][:file_name]
    schedule_file_path = NWSL[:file_path] + NWSL[:schedule][:file_name]
    agent.get(schedule_url).save!(schedule_file_path)

    schedule_hash = parser.parse(File.read(schedule_file_path))
    games = schedule_hash['sports_statistics']['sports_schedule']['soccer_ifb_schedule']['game_schedule']
    games.each do |game|
      game_code = game['gamecode']['@code']
      game_url = NWSL[:url] + NWSL[:game_logs][:file_name_base] + game_code + NWSL[:game_logs][:file_extension]
      game_file_path = NWSL[:file_path] + NWSL[:game_logs][:folder] + NWSL[:game_logs][:file_name_base] + game_code + NWSL[:game_logs][:file_extension]
      begin
        agent.get(game_url).save!(game_file_path)
      rescue
        p "#{game_code} not yet played."
      end
    end
  end

  def self.load_schema
    Teams.create_table
    Players.create_table
    Games.create_table

    Rosters.create_table
    Events.create_table
  end

  def self.load_info
    Teams.load_table
    Players.load_table
    Games.load_table

    Rosters.load_table
    Events.load_table
  end

  def self.dump_info
    #dump backup info to csv
    Teams.dump_table
    Players.dump_table
    Games.dump_table

    Rosters.dump_table
    Events.dump_table
  end
end
