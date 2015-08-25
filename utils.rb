require 'nori'
require 'open-uri'
require 'sequel'
require 'settings'
require 'csv'

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

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

  def self.table_to_csv(model)
    table = DB[model.to_sym]
    columns = table.columns.map {|x| x.to_s}
    CSV.open("#{DATA_FILE_PATH}/#{model}.csv", "w+") do |csv|
      csv << columns
      table.each do |row|
        csv << row.values
      end
    end
  end

  def self.csv_to_table(model)
    table_csv_path = "#{DATA_FILE_PATH}/#{model}.csv"
    if File.file?(table_csv_path)
      file = File.open(table_csv_path)
      csv = CSV.new(file,:headers => true, :header_converters => [:symbol, :blank_to_nil])
      table_hash = csv.to_a.map {|row| row.to_hash }
      table_hash.each do |game|
        columns = game.keys.map { |s| "#{s}" }.join(', ')
        values = game.values.map { |s| s.nil? ? "''" : "'#{s.gsub("'","''")}'" }.join(', ')
        game_sql = "INSERT or IGNORE INTO #{model}
        (#{columns}) VALUES (#{values})"
        DB.run(game_sql)
      end
    end
  end

  def self.open_db
    if DB_MEMORY
      return Sequel.sqlite
    else
      return Sequel.connect(DB_PATH)
    end
  end
end
