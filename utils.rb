require 'nori'
require 'open-uri'

def xml_file_to_hash(file_location)
  doc = File.open(file_location)
  return parser.parse(doc)
end

def write_xml_file(url, file_location)
  doc = open(url) { |f| f.read }
  file = File.new(file_location, "wb")
  file.write(doc)
  file.close
end
