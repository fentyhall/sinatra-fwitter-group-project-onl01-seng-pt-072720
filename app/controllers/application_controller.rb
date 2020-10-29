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
    if logged_in? && current_user
      redirect to "/tweets"
    else 
      erb :'users/create_user'
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
    if logged_in? && current_user
      redirect to '/tweets'
    else  
      erb :'users/login'
    end 
  end 

  post '/login' do 
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/tweets'
    else  
      redirect to '/login'
    end 
  end 

  get '/logout' do
    if logged_in? && current_user
      erb :'users/logout'
    else  
      redirect "/login"
    end 
  end 
  
  post '/logout' do 
    session.clear
    redirect "/login"
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