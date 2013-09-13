require "pg"
require "faker"


conn = PG.connect dbname: "sinatra_crud", host: "localhost"
100.times do |i|
	name = Faker::Name.name.gsub("'","")
	gender = ["male", "female"].sample
	birthday = "1978-09-17"
	sql = "INSERT INTO eclectic_me (name,gender,birthday)
				 VALUES (
				 	'#{name}',
				 	'#{gender}',
				 	'#{birthday}'"
	conn.exec sql
end