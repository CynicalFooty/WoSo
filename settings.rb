BASE_FILE_PATH = File.dirname(__FILE__)
DB_PATH = 'sqlite://woso.db'

NWSL = {
  team_info: {
    file_name: "NWSL_TEAM_INFO.XML",
    description: "Team Bio info"
  },
  roster: {
    file_name: "NWSL_ROSTER.XML",
    description: "Players and current roster"
  },
  game_logs: {
    folder: "game_logs",
    description: "All of the games."
  },
  url: "http://www.nwslsoccer.com/Stats/2015/pbp/",
  file_path: "#{BASE_FILE_PATH}/source/data/"
}
