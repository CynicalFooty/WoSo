DB ||= Utils.open_db
class Players < Sequel::Model

  def self.hash
    return DB[:players]
  end

  def self.dump_table
    Utils.table_to_csv("players")
  end

  def self.create_table
    DB.create_table! :players do
      primary_key :id
      String      :first_name
      String      :last_name
      String      :full_name
      String      :url_name
      String      :country
    end
  end

  def self.load_table
    Utils.csv_to_table("players")

    parser = Nori.new

    roster_info = File.read(NWSL[:file_path]+NWSL[:roster][:file_name])
    roster_hash = parser.parse(roster_info)
    players_roster_hash = roster_hash['sports_statistics']['sports_roster']['ifb_soccer_roster']['ifb_team_roster']

    players_roster_hash.each do |team|
      team['ifb_roster_player'].each do |player|
        first_name = player['name']['@first_name'].gsub("'","''")
        last_name = player['name']['@last_name'].gsub("'","''")
        full_name = "#{first_name} #{last_name}"
        url_name = full_name.gsub(/[^0-9a-z]/i, '').downcase
        player_sql = "INSERT or IGNORE INTO players
          (id, first_name, last_name, full_name, url_name, country)
        VALUES
          (#{player['player_code']['@global_id']}, '#{first_name}',
          '#{last_name}', '#{full_name}', '#{url_name}',
          '#{player['nationality']['@name']}'
          )"
        DB.run(player_sql)
      end
    end
  end
end
