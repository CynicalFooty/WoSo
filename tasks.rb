require 'rubygems'
require 'open-uri'
require 'nori'
require 'settings'
require 'utils'

class Tasks
  def self.download_nwsl
    # parse the HTML document with all the links to the XML files.
    utils.write_xml_file(NWSL[:url]+NWSL[:roster][:file_name], NWSL[:file_path]+NWSL[:roster][:file_name])
  end

  def self.process_xml(audit=false)
    roster_hash = utils.xml_file_to_hash(NWSL[:file_path]+NWSL[:roster][:file_name])
    rosters = roster_hash['sports_statistics']['sports_roster']['ifb_soccer_roster']['ifb_team_roster']
    rosters.each do |roster|
      players = roster['ifb_roster_player'].map {|x| x}
      players.each do |player|
        #insert team and player ID to team_roster
        #insert player to team
      end
    end
  end

  def self.load_schema
    Teams.create_table
    Rosters.create_table
    Players.create_table
    Games.create_table
  end

  def self.load_info
    Teams.load_table
    Rosters.load_table
    Players.load_table
    Games.load_table
  end

  def self.get_hashes
    return {
      teams: Teams.hash,
      players: Players.hash,
      games: Games.hash
    }
  end

  def self.dump_info
    #if no database; return
    #dump backup info to csv
  end
end
