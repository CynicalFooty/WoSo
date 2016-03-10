BASE_FILE_PATH = File.dirname(__FILE__)
DATA_FILE_PATH = "#{BASE_FILE_PATH}/source/data"
DB_MEMORY = false
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
    description: "All of the games. Each game has a date and unique code",
    example: "NWSL_PBP_GAME2015053011869.XML",
    file_name_base: "/NWSL_PBP_GAME",
    file_extension: ".xml"
  },
  schedule: {
    file_name: "NWSL_SCHEDULE.XML"
  },
  url: "http://www.nwslsoccer.com/Stats/2015/pbp/",
  file_path: "#{BASE_FILE_PATH}/raw_data/"
}
