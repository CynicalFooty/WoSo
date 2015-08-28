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
    Players.create_table
    Games.create_table

    Rosters.create_table
    Events.create_table
  end

  def self.load_info
    Teams.load_table
    Players.load_table
    Games.load_table

    Rosters.load_table
    Events.load_table
  end

  def self.dump_info
    #dump backup info to csv
    Teams.dump_table    
    Players.dump_table
    Games.dump_table

    Rosters.dump_table
    Events.dump_table
  end
end
