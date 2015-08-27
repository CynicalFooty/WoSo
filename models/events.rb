require 'csv'

DB ||= Utils.open_db
class Events < Sequel::Model

  def self.hash
    return DB[:events]
  end

  def self.dump_table
    Utils.table_to_csv("events")
  end

  def self.create_table
    DB.create_table! :events do
      Integer     :game_id
      Integer     :seq_number
      Integer     :event_number
      String      :event_text
      String      :text
      Integer     :half
      Integer     :minutes
      Integer     :seconds
      Integer     :additional_minutes
      Integer     :away_score
      Integer     :home_score
      Integer     :x
      Integer     :y
      primary_key ([:game_id, :seq_number])
    end
  end

  def self.load_table
    Utils.csv_to_table("events")

    parser = Nori.new

    game_log_directory = NWSL[:file_path]+NWSL[:game_logs][:folder]
    files = Dir["#{game_log_directory}/*.xml"]
    files.each do |file|
      game_hash = parser.parse(File.read(file))
      event_hashes = parser.parse(File.read(file))['sports_statistics']['sports_play_by_play']['soccer_ifb_game']['plays']['play']
      game_id = game_hash['sports_statistics']['sports_play_by_play']['soccer_ifb_game']['gamecode']['@global_code']
      event_hashes.each do |event|
        x = event['@x_coord'].empty? ? 0 : event['@x_coord']
        y = event['@y_coord'].empty? ? 0 : event['@y_coord']
        game_sql = "INSERT or IGNORE INTO events
        (game_id, seq_number, event_number, event_text, text, half, minutes,
        seconds, additional_minutes, away_score, home_score, x, y)
        VALUES (#{game_id}, #{event['@seq_number']}, #{event['@event_number']},
        '#{event['@event_text']}', '#{event['@text'].gsub("'","''")}', #{event['@half']},
        #{event['@minutes']}, #{event['@seconds']}, #{event['@additional_minutes']},
        #{event['@away_score']}, #{event['@home_score']}, #{x},
        #{y})"
        DB.run(game_sql)
      end
    end

  end
end
