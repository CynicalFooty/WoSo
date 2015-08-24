require 'rubygems'
require 'open-uri'
require 'nori'
require 'settings'
require 'utils'

class Tasks
  def self.download_nwsl
    # parse the HTML document with all the links to the XML files.
    #utils.write_xml_file(NWSL[:url]+NWSL[:roster][:file_name], NWSL[:file_path]+NWSL[:roster][:file_name])
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
    #dump backup info to csv
    Games.dump_table
    Players.dump_table
    Rosters.dump_table
    Teams.dump_table
  end
end
