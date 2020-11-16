require 'sinatra'
require 'sinatra/reloader'

enable :sessions

get "/" do
  session[:guesses] = []
  session[:tries] = 7
  erb :welcome
end  

get '/home' do
  random_number = rand(1..100)
  if  !session[:randomnumber]
    session[:win] = false
    session[:randomnumber] = random_number
  end
  @guess = params["guess"].to_i
  @message = session[:message]
  erb :home, :locals => {:random_number => random_number}
end

post "/home" do
  guess = params["guess"].to_i
  check_guess(guess)
  redirect "/home?guess=#{@guess}"
end

get '/reset' do
  random_number = rand(1..100)
  session[:win] = "false"  
  session[:guesses] = []
  session[:tries] = 7
  session[:randomnumber] = random_number
  @message = session[:message]
  redirect "/home"
end

get '/results' do
  erb :results
end

def check_guess(guess)
  if guess.to_i == session[:randomnumber]  
    session[:win] = "true"
    session[:message] = "CONGRATULATIONS! You have guessed the number!"
    else
      session[:tries] = session[:tries].to_i - 1
      session[:guesses] << params[:guess]
      if session[:tries].to_i == 0     
        redirect "/results"
      end     
      if guess.to_i > session[:randomnumber] + 10 
          session[:message] = "Your guess is too high"
        elsif guess.to_i < session[:randomnumber] - 10 
            session[:message] = "Your guess is too much low"
        elsif guess.to_i > session[:randomnumber] 
          session[:message] = "Your guess is close, but too high" 
        else guess.to_i < session[:randomnumber]
            session[:message] = "Your guess is too low"
      end
  end
end



