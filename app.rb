require "sinatra"
require "sinatra/reloader"
require "active_support/all"
require "active_record"
require 'digest/sha2'

# include 'item' model
require './models/scott'
require './models/eclectic_instrument'
require './models/mad_skill'
require "./config"

enable :sessions

# configure ActiveRecord: connect to postgres
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/be_scott')

# output ActiveRecord sql to console
ActiveRecord::Base.logger = Logger.new(STDOUT)



before do
	if session[:scott]
		@buttons = $CONFIG[:buttons][:logged_in]
		@scott = session[:scott]
	else
		@scott = nil 
		@buttons = $CONFIG[:buttons][:not_logged_in]
	end
end

before "/scott*" do
	unless session[:scott]
		redirect "/signup"
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
	@types_of_scott = $CONFIG[:types_of_scott]
	# $CONFIG.to_s
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
	@playability_words = $CONFIG[:playability_words]
	@skill_words = $CONFIG[:skill_words]
	erb :show
end



## NEW mad skill
get "/scott/new_mad_skill" do
	@skill_genres = $CONFIG[:skill_genres]
	@post_path = "/new_mad_skill"
	erb :new_mad_skill
end

post "/scott/new_mad_skill" do
	skill = @scott.mad_skills.new params[:skill]
	skill.save

	redirect "/scott"
end



## EDIT mad skill
get "/scott/edit_mad_skill/:skill_id" do
	begin
		@mad_skill = @scott.mad_skills.find params[:skill_id]
		@post_path = "/edit_mad_skill/#{@mad_skill.id}"
	rescue 
		redirect "/scott"
	end
	@skill_genres = $CONFIG[:skill_genres]
	erb :new_mad_skill
end

post "/scott/edit_mad_skill/:skill_id" do
	begin
		ms = @scott.mad_skills.find params[:skill_id]
		ms.update_attributes params[:skill]
	rescue 
	end
	redirect "/scott"
end

## DELETE mad skill
get "/scott/delete_mad_skill/:skill_id" do
	begin
		ms = @scott.mad_skills.find params[:skill_id]
		ms.destroy
	rescue 
	end
	redirect "/scott"
end



## NEW eclectic instrument
get "/scott/new_eclectic_instrument" do
	@instrument_genres = $CONFIG[:instrument_genres]
	@post_path = "/new_eclectic_instrument"
	erb :new_eclectic_instrument
end

post "/scott/new_eclectic_instrument" do
	ei = @scott.eclectic_instruments.new params[:ei]
	ei.save

	redirect "/scott"
end



## EDIT eclectic instrument
get "/scott/edit_eclectic_instrument/:instrument_id" do
	begin
		@eclectic_instrument = @scott.eclectic_instruments.find params[:instrument_id]
		@post_path = "/edit_eclectic_instrument/#{@eclectic_instrument.id}"
		# session[:ei_id] = @eclectic_instrument.id
	rescue
		redirect "/scott"
	end

	@instrument_genres = $CONFIG[:instrument_genres]
	erb :new_eclectic_instrument
end

post "/scott/edit_eclectic_instrument/:instrument_id" do
	begin
		ei = @scott.eclectic_instruments.find params[:instrument_id]
		ei.update_attributes params[:ei]
		session[:ei_id] = nil
	rescue
	end

	redirect "/scott"
end


## DELETE mad skill
get "/scott/delete_eclectic_instrument/:instrument_id" do
	begin
		eclectic_instrument = @scott.eclectic_instruments.find params[:instrument_id]
		eclectic_instrument.destroy
	rescue 
	end
	redirect "/scott"
end








