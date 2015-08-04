DB ||= Utils.open_db
class Teams < Sequel::Model
  def self.xml
    parser = Nori.new

    #Team Building (ha)
    team_info = File.read(NWSL[:file_path]+NWSL[:team_info][:file_name])
    team_hash = parser.parse(team_info)
    return team_hash['sports_statistics']['sports_teams']['ifb_soccer_teams']['team_info']
  end
end
