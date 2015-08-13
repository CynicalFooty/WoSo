DB ||= Utils.open_db
class Games < Sequel::Model
  def self.xml_to_hashes
    parser = Nori.new

    game_log_directory = NWSL[:file_path]+NWSL[:game_logs][:folder]
    files = Dir["#{game_log_directory}/*.xml"]
    game_hashes = []
    files.each do |file|
      game_hashes << parser.parse(File.read(file))['sports_statistics']['sports_play_by_play']['soccer_ifb_game']
    end

    return game_hashes
  end

  def self.hash
    return DB[:games]
  end

  def self.csv
    #teams = DB[:teams]
    #csv = File.open("#{NWSL[:file_path]+NWSL[:team_info][:file_name]}.csv",'w')
    #csv << teams.columns.map {|c| c.to_s}
    #then split out each team
  end

  def self.create_table
    DB.create_table? :games do
      primary_key :id
      String      :full_name
    end
  end

  def self.load_table
    game_hashes = self.xml_to_hashes
    game_hashes.each do |game|
      visitor = game['visiting_team']['team_info']['@alias']
      home = game['home_team']['team_info']['@alias']
      game_name = "#{home} vs #{visitor}"
      id = game['gamecode']['@global_code']
      game_sql = "INSERT or IGNORE INTO games
      (id, full_name)
      VALUES (#{id}, '#{game_name}')"
      DB.run(game_sql)
    end
  end
end
