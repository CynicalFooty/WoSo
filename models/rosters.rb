DB ||= Utils.open_db
class Rosters < Sequel::Model

  def self.hash(team_id=nil)
    if team_id
      return DB[:rosters].filter(:team_id => team_id)
    else
      return DB[:rosters]
    end
  end

  def self.dump_table
    Utils.table_to_csv("rosters")
  end

  def self.create_table
    DB.create_table! :rosters do
      Integer     :team_id
      Integer     :player_id
      primary_key ([:team_id, :player_id])
    end
  end

  def self.load_table
    Utils.csv_to_table("rosters")

    parser = Nori.new

    roster_info = File.read(NWSL[:file_path]+NWSL[:roster][:file_name])
    roster_hash = parser.parse(roster_info)
    team_rosters_hash = roster_hash['sports_statistics']['sports_roster']['ifb_soccer_roster']['ifb_team_roster']
    team_rosters_hash.each do |team|
      team_id = team['team_info']['@global_id']
      team['ifb_roster_player'].each do |player|
        player_id = player['player_code']['@global_id']
        roster_sql = "INSERT or IGNORE INTO rosters
        (team_id, player_id)
        VALUES (#{team_id}, #{player_id})"
        DB.run(roster_sql)
      end
    end
  end

end
