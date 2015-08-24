require 'csv'

DB ||= Utils.open_db
class Games < Sequel::Model

  def self.hash
    return DB[:games]
  end

  def self.dump_table
    Utils.table_to_csv("games")
  end

  def self.create_table
    DB.create_table! :games do
      primary_key :id
      String      :home
      String      :away
      String      :week
      String      :date
    end
  end

  def self.load_table
    Utils.csv_to_table("games")

    parser = Nori.new

    game_log_directory = NWSL[:file_path]+NWSL[:game_logs][:folder]
    files = Dir["#{game_log_directory}/*.xml"]
    game_hashes = []
    files.each do |file|
      game_hashes << parser.parse(File.read(file))['sports_statistics']['sports_play_by_play']['soccer_ifb_game']
    end

    game_hashes.each do |game|
      week = game['week']['@week']
      date = "#{game['date']['@year']}-#{game['date']['@month']}-#{game['date']['@date']}"
      away = game['visiting_team']['team_info']['@alias']
      home = game['home_team']['team_info']['@alias']
      id = game['gamecode']['@global_code']
      game_sql = "INSERT or IGNORE INTO games
      (id, home, away, week, date)
      VALUES (#{id}, '#{home}', '#{away}', '#{week}', '#{date}')"
      DB.run(game_sql)
    end
  end
end
