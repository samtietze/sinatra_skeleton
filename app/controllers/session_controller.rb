# get '/session-inspector' do
#   session.inspect
# end

get '/login' do
  erb :'/sessions/new'
end

post '/login' do
  @user = User.authenticate(params[:email], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    status 401
    @errors = ['Bad username/password combo']
    erb :'/sessions/new'
  end
end

delete '/logout' do
  session.delete(:user_id)
  redirect '/'
end
