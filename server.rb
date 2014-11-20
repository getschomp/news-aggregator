require 'sinatra'
require 'pry'

get '/articles' do
  @stories = File.readlines('stories.csv')
  @story = []
  @stories.each do |story|
    @story << story.gsub('\n', '').split(',')
  end
  erb :index
end

get '/articles/new' do
  erb :form
end

post '/articles/new' do
  @title = params['title']
  @url = params['url']
  @description = params['description']

  if @title.empty? || @url.empty? || @description.length < 20
    # if the parameters are empty only redirect to an error page
    @errormessage="The form was not filled out correctly. All feilds are required, the url must be valid, and the description must be 20 characters."
    erb :form
  else
    File.open('stories.csv', 'a') do |file|
      file.puts("#{@title}, #{@url}, #{@description}")
    end
    redirect '/articles'
  end
end

 # These lines can be removed since they are using the default values. They've
 # been included to explicitly show the configuration options.
 set :views, File.dirname(__FILE__) + '/views'
 set :public_folder, File.dirname(__FILE__) + '/public'
