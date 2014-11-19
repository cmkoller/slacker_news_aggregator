require 'sinatra'

def process_article_data
  article_data = File.read("articles.csv")
  article_data = article_data.split("\n")
  processed_data = []

  article_data.each do |article|
    processed_data << article.split(",")
  end

  processed_data
end

def get_existing_urls
  urls = []
  process_article_data.each do |article|
    urls << article[2]
  end
  urls
end

get '/' do
  redirect '/articles'
end

get '/articles' do
  @articles = process_article_data
  erb :articles
end

get '/articles/new' do
  @articles = process_article_data
  @urls = get_existing_urls
  erb :index
end

post '/articles' do
  # Read the input from the form the user filled out
  article_name = params['article_name']
  article_description = params['article_description']
  article_url = params['article_url']

  # Open the "articles" csv file and append the article name
  File.open('articles.csv', 'a') do |file|
    file.puts("#{article_name},#{article_description},#{article_url}")
  end

  @articles = process_article_data
  erb :articles
end
