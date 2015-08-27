require 'csv'

DB ||= Utils.open_db
class Events < Sequel::Model

  def self.dump_table
    Utils.table_to_csv("events")
  end

  def self.create_table
    DB.create_table! :events do
      Integer     :game_id
      Integer     :seq_number
      Integer     :event_number
      String      :event_text
      String      :button_text
      String      :text
      Integer     :team_id
      String      :team_alias
      Integer     :half
      Integer     :minutes
      Integer     :seconds
      Integer     :half_seconds
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
        #puts event
        x = event.fetch('@x_coord',-1)
        x = x.empty? ? -1 : x
        y = event.fetch('@y_coord',-1)
        y = y.empty? ? -1 : y
        team_id = event['@global_team_id']
        team_alias = Teams[team_id][:alias]
        stoppage_minutes = event.fetch('@additional_minutes',0).to_i
        minutes = event.fetch('@minutes',0).to_i + stoppage_minutes
        half = event.fetch('@half',1).to_i
        seconds = event.fetch('@seconds',0).to_i
        half_seconds = (minutes-45*(half-1))*60+seconds
        button_text = "#{sprintf '%02d', minutes}:#{sprintf '%02d', seconds}"

        game_sql = "INSERT or IGNORE INTO events
        (game_id, seq_number, event_number, event_text, text, half, minutes,
        seconds, additional_minutes, away_score, home_score, x, y, team_id,
        team_alias, half_seconds, button_text)
        VALUES (#{game_id}, #{event['@seq_number']}, #{event['@event_number']},
        '#{event['@event_text']}', '#{event['@text'].gsub("'","''")}', #{event['@half']},
        #{event['@minutes']}, #{event['@seconds']}, #{event['@additional_minutes']},
        #{event['@away_score']}, #{event['@home_score']}, #{x}, #{y}, #{team_id},
        '#{team_alias}', #{half_seconds}, '#{button_text}')"
        results = DB.run(game_sql)
      end
    end

  end
end
