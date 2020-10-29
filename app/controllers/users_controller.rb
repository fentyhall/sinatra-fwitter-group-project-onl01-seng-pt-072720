class UsersController < ApplicationController
    configure do 
        enable :sessions
        set :session_secret, "password_security"
    end 

    
end
