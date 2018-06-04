require 'sinatra'
require 'rerun'
require './models'


# to generate a random string in the irb:
#  require 'securerandom'
#  SecureRandom.hex
set :session_secret, ENV['SEI_SESSION_SECRET']
enable :sessions

 selecteduser = User.all[0] if User.all!=nil

get('/') do
    if session[:user_id]!=nil
         user = User.find(session[:user_id]) 
        @user=user
    end
	erb :index
end

get('/signup') do
     unless session[:user_id]==nil
         user = User.find(session[:user_id]) 
        @user=user
    end
	erb :signup
end

get('/login') do
     unless session[:user_id]==nil
         user = User.find(session[:user_id]) 
        @user=user
    end
	erb :login
end

get('/logout') do 
    
    session[:user_id] = nil
	erb :index	
end

get '/cancelaccount' do 
   user = User.find(session[:user_id])
    p session[:user_id]
    @user=user
    
    user.destroy
    user.posts.destroy_all
     session[:user_id]=nil
    erb :index
end


get('/about') do
    unless session[:user_id]==nil
         user = User.find(session[:user_id]) 
        @user=user
    end
	erb :about
end

get('/blogdetails') do
    @posts = Post.all
    @users = User.all
   if session[:user_id]!=nil
         user = User.find(session[:user_id]) 
        @user=user
    end
    
	erb :blogdetails
end

get '/myposts' do
   unless session[:user_id]==nil
         user = User.find(session[:user_id]) 
        @user=user
    end
    erb :myposts
end

get '/userposts' do 
     if session[:user_id]!=nil
         user = User.find(session[:user_id]) 
        @user=user
    end
   
    @selecteduser = selecteduser
    erb :userposts
end

get '/userposts/:id' do
   @posts = Post.all
    @users = User.all
    if session[:user_id]!=nil
         user = User.find(session[:user_id]) 
        @user=user
    end
    selecteduser = User.find(params[:id])
    @selecteduser = selecteduser
    
   redirect  '/userposts'
#    erb :userposts
end


get('/contact') do
    if session[:user_id]!=nil
         user = User.find(session[:user_id]) 
        @user=user
    end
	erb :contact
end

get '/deletepost/:id' do
      
   post = Post.find(params[:id])
    post.destroy
    redirect '/blogdetails'

end

post('/signup') do
	existing_user = User.find_by(email: params[:email])
	if existing_user != nil
		return redirect '/login'
	end

	user = User.create(
		first_name: params[:f_name],
  		last_name: params[:l_name],
  		email: params[:email],
  		password: params[:password],
	)
	session[:user_id] = user.id
	redirect '/'
end



post('/login') do
	

	user = User.find_by(email: params[:email])
	if user.nil?
        p " my_session " , session[:user_id] 
		return redirect '/login'
	end

	unless user.password == params[:password]
        p " my_session " , session[:user_id] 
		return redirect '/login'
	end
   p " my_session " , session[:user_id] 
	session[:user_id] = user.id
    p " my_session " , session[:user_id] 
	redirect '/'
end

post '/blogpost' do
   user_id = session[:user_id]
	if user_id.nil?
		return redirect '/login'
	end
   

    
    @userpost = Post.create(
        user_id: user_id,
		subject: params[:subject],
  		description: params[:description],
  	)
	
	redirect '/blogdetails'
    
end
