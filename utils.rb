require 'nori'
require 'open-uri'
require 'sequel'
require 'settings'

class Utils
  def self.xml_file_to_hash(file_location)
    parser = Nori.new
    doc = File.open(file_location)
    return parser.parse(doc)
  end

  def self.write_xml_file(url, file_location)
    doc = open(url) { |f| f.read }
    file = File.new(file_location, "wb")
    file.write(doc)
    file.close
  end

  def self.open_db
    return Sequel.connect(DB_PATH)
  end
end
