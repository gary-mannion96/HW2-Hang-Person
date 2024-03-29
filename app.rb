# Author: Gary Mannion

require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  get '/guess' do
    redirect '/show'
  end

  # Use existing methods in HangpersonGame to process a guess.
  post '/guess' do
    letter = params[:guess].to_s[0]

    # Checks to make sure the letter is valid
    if(letter.nil? || letter.empty? || letter[/[a-zA-Z]+/] != letter)
      flash[:message] = "Invalid guess."
    else
      # If a guess is repeated, set flash[:message] to "You have already used that letter."
      if(@game.guess(letter) == false)
        flash[:message] = "You have already used that letter."
      end
    end
    redirect '/show'
  end
  
  get '/show' do
    
    if(@game.instance_variable_get(:@check_win_or_lose) == :win)
      redirect '/win'
    end

    if(@game.instance_variable_get(:@check_win_or_lose) == :lose)
      redirect '/lose'
    end
    
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    
    if(@game.instance_variable_get(:@check_win_or_lose) == :play)
      redirect '/show'
    end
   
    if(@game.instance_variable_get(:@check_win_or_lose) == :lose)
      redirect '/lose'
    end

    erb :win # You may change/remove this line
  end
  
  get '/lose' do

    if(@game.instance_variable_get(:@check_win_or_lose) == :play)
      redirect '/show'
    end

    if(@game.instance_variable_get(:@check_win_or_lose) == :win)
      redirect '/win'
    end

    erb :lose # You may change/remove this line
  end
end