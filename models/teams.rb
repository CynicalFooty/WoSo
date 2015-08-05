DB ||= Utils.open_db
class Teams < Sequel::Model
  def self.xml
    parser = Nori.new

    #Team Building (ha)
    team_info = File.read(NWSL[:file_path]+NWSL[:team_info][:file_name])
    team_hash = parser.parse(team_info)
    return team_hash['sports_statistics']['sports_teams']['ifb_soccer_teams']['team_info']
  end

  def self.hash
    return DB[:teams]
  end

  def self.create_table
    DB.create_table? :teams do
      primary_key :id
      String      :name
      String      :location
      String      :alias
    end
  end

  def self.load_table
    team_hash = self.xml
    team_hash.each do |team|
      team_sql = "INSERT or IGNORE INTO teams (id, name, location, alias)
      VALUES (#{team['@global_id']}, '#{team['@display_name']}', '#{team['@city']}', '#{team['@alias']}')"
      DB.run(team_sql)
    end
  end
end
