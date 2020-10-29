class TweetsController < ApplicationController
    get '/tweets' do
        if logged_in? && current_user
            @user = current_user
            erb :'tweets/tweets'
        else 
            redirect to '/login'
        end 
    end 

    get '/tweets/new' do
        if logged_in? && current_user
            erb :'tweets/new'
        else 
            redirect to '/login'
        end 
    end 

    post '/tweets' do 
        if params[:content] == ""
            redirect to '/tweets/new'
          else  
            tweet = Tweet.create(content: params[:content])
            current_user.tweets << tweet
            redirect to "/tweets/#{tweet.id}"
        end 
    end 

    get '/tweets/:id' do 
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && (@tweet.user_id == current_user.id)
            erb :'tweets/show_tweet'
        else
            redirect to '/login'
        end 
    end 

    get '/tweets/:id/edit' do 
        if logged_in? && current_user
            @tweet = Tweet.find_by_id(params[:id])
            erb :'tweets/edit_tweet'
        else 
            redirect to '/login'
        end 
    end

    patch '/tweets/:id' do 
        @tweet = Tweet.find_by_id(params[:id])

        if params[:content] == ""
            redirect to "/tweets/#{@tweet.id}/edit"
        else  
            @tweet.content = params[:content]
            @tweet.save

            redirect to "/tweets/#{@tweet.id}"
        end 
    end 

    delete '/tweets/:id' do 
        @tweet = Tweet.find_by_id(params[:id])

        if !logged_in? && !current_user
            redirect to '/login'
        else 
            @tweet.delete 

            redirect to '/tweets'
        end 
    end 
end
