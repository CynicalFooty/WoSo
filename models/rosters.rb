class Rosters
  def self.xml
    parser = Nori.new

    roster_info = File.read(NWSL[:file_path]+NWSL[:roster][:file_name])
    roster_hash = parser.parse(roster_info)
    return roster_hash['sports_statistics']['sports_roster']['ifb_soccer_roster']['ifb_team_roster']
  end
end
