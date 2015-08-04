class Teams
  def self.xml
    parser = Nori.new

    #Team Building (ha)
    team_info = File.read('./source/data/NWSL_TEAM_INFO.XML')
    team_hash = parser.parse(team_info)
    return team_hash['sports_statistics']['sports_teams']['ifb_soccer_teams']['team_info']
  end
end
