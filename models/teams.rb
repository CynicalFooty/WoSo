DB ||= Utils.open_db
class Teams < Sequel::Model
  
  def self.hash
    return DB[:teams]
  end

  def self.dump_table
    Utils.table_to_csv("teams")
  end

  def self.create_table
    DB.create_table? :teams do
      primary_key :id
      String      :name
      String      :location
      String      :full_name
      String      :city
      String      :alias
      String      :country
      Integer     :year
    end
  end

  def self.load_table
    Utils.csv_to_table("teams")

    parser = Nori.new

    team_info = File.read(NWSL[:file_path]+NWSL[:team_info][:file_name])
    team_hash = parser.parse(team_info)
    teams_hash = team_hash['sports_statistics']['sports_teams']['ifb_soccer_teams']['team_info']

    teams_hash.each do |team|
      team_sql = "INSERT or IGNORE INTO teams
      (id, name, location, full_name, city, alias, country, year)
      VALUES (#{team['@global_id']}, '#{team['@name']}', '#{team['@name']}',
      '#{team['@location']} #{team['@name']}', '#{team['@city']}', '#{team['@alias']}',
      '#{team['@country']}', #{team['@year_founded']})"
      DB.run(team_sql)
    end
  end
end
