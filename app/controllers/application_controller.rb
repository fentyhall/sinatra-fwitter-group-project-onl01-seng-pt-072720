require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do 
    erb :index
  end 
  
  get '/signup' do 
    # binding.pry
    if logged_in? 
      redirect to '/tweets'
    else 
      erb :index
    end 
  end 

  post '/signup' do 
    if params[:username] == "" || params[:email] == "" || params[:password] == "" 
      redirect to '/signup'
    else  
      User.create(username: params[:username], email: params[:email], password: params[:password])
      redirect to '/tweets'
    end 
  end 

  get '/login' do 
    if logged_in? 
      redirect to '/tweets'
    else  
      erb :'users/login'
    end 
  end 

  post '/login' do 
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else  
      redirect to '/login'
    end 
  end 

  get '/logout' do
    if logged_in? 
      session.clear 
      redirect '/login' 
    else  
      redirect '/index'
    end 
  end 

  helpers do 
    def logged_in?
      !!session[:user_id]
    end 

    def current_user
      User.find(session[:user_id])
    end 
  end 
end
