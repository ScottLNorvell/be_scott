require "sinatra"
require "sinatra/reloader"
require "active_support/all"
require "active_record"
require 'digest/sha2'

# include 'item' model
require './models/scott'
require './models/eclectic_instrument'
require './models/mad_skill'

enable :sessions

# configure ActiveRecord: connect to postgres
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/be_scott')

# configure ActiveRecord: connect to postgres
# ActiveRecord::Base.establish_connection(
#   :adapter => "postgresql",
#   :host => "localhost",
#   :username => "scottsMac", # Put your postgres username here
#   :password => "",
#   :database => "be_scott"
# )

# output ActiveRecord sql to console
ActiveRecord::Base.logger = Logger.new(STDOUT)

buttons = {
	not_logged_in: [
		{text: "become a Scott", url: "/signup"},
		{text: "log in (as Scott)", url: "/login"}
	],
	logged_in: [
		{text: "acquire a mad_skill", url: "/scott/new_mad_skill"},
		{text: "acquire an eclectic_instrument", url: "/scott/new_eclectic_instrument"}
	]
}



before do
	if session[:scott]
		@buttons = buttons[:logged_in]
		@scott = session[:scott]
	else
		@scott = nil 
		@buttons = buttons[:not_logged_in]
	end
end

get "/" do
	erb :home 
end

# LOGIN pages
get "/login" do
  erb :login
end

post "/login" do
  name = params[:scott]
  password = Digest::SHA2.hexdigest params[:password]
  scott = Scott.where(name: name, password: password).first
  p scott
  if scott
    session[:scott] = scott
    redirect "/scott"
  else
    erb :login
  end
end

get "/logout" do
	session[:scott] = nil
	redirect "/"
end

get "/signup" do
	erb :signup
end

post "/signup" do
	scott_params = params[:scott]
	scott = Scott.new

	scott.password = Digest::SHA2.hexdigest scott_params["password"]
	scott.name = scott_params["name"]
	scott.gender = scott_params["gender"]
	scott.type_of_scott = scott_params["type_of_scott"]
	
	if scott.save
		session[:scott] = scott
		redirect "/scott"
	else
		erb :signup
	end
end

get "/scott" do
	# @scott = Scott.find(params[:scott_id])
	erb :show
end

## NEW mad skill
get "/scott/new_mad_skill" do

	erb :new_mad_skill
end

post "/scott/new_mad_skill" do
	skill = @scott.mad_skills.new params[:skill]
	skill.save
	redirect "/scott"
end

## NEW eclectic instrument
get "/scott/new_eclectic_instrument" do
	
	erb :new_eclectic_instrument
end

post "/scott/new_eclectic_instrument" do
	ei = @scott.eclectic_instruments.new params[:ei]
	ei.save
	redirect "/scott"
end







