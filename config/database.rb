db_name = "fantasy-football-nerd_#{App.environment}"

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: "db/#{db_name}"
)
