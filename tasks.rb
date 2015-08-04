require 'rubygems'
require 'open-uri'
require 'sqlite-rb'
require 'nori'
require_relative 'scraper_settings'
require_relative 'utils'

class tasks
  def download_nwsl
    # parse the HTML document with all the links to the XML files.
    utils.write_xml_file(NWSL[:url]+NWSL[:roster][:url], "./source/data/NWSL_ROSTER.xml")
  end

  def process_xml(audit=false)
    roster_hash = utils.xml_file_to_hash('./source/data/NWSL_ROSTER.xml')
    rosters = roster_hash['sports_statistics']['sports_roster']['ifb_soccer_roster']['ifb_team_roster']
    rosters.each do |roster|
      players = roster['ifb_roster_player'].map {|x| x}
      players.each do |player|
        #insert team and player ID to team_roster
        #insert player to team
      end
    end
  end

  def load_schema
    #if database does exist; return
    #create database
    #load schema
  end

  def load_info
    #if no database; return
    #load backup info
  end

  def dump_info
    #if no database; return
    #dump backup info to csv
  end
end
