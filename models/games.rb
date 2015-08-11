DB ||= Utils.open_db
class Games < Sequel::Model
  def self.xml
    parser = Nori.new

    #Team Building (ha)
    #game_info = File.read(NWSL[:file_path]+NWSL[:game_info][:file_name])
    #todo each do
    #game_hash = parser.parse(game_info)
    #return game_hash #todo xml
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
    game_hash = self.xml
    game_hash.each do |game|
      game_sql = "INSERT or IGNORE INTO games
      (id, full_name)
      VALUES (#{game['@global_id']}, '#{game['@name']}'"
      DB.run(game_sql)
    end
  end
end
