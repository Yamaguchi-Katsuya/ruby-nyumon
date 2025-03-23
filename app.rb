require 'sinatra'
require 'json'
require 'sinatra/activerecord'
require './models/todo'

set :bind, '0.0.0.0'

ActiveRecord::Base.establish_connection(
  YAML.load_file('config/database.yml')[ENV['RACK_ENV'] || 'development']
)

get '/' do
  'Hello, World!'
end

require './db/todos'
get '/todos' do
  @todos = Todo.all
  erb :todos
end

post '/todos' do
  Todo.create(title: params[:title])
  redirect '/todos'
end

get '/todos/:id/edit' do
  @todo = Todo.find(params[:id])
  erb :edit
end

put '/todos/:id' do
  @todo = Todo.find(params[:id])
  @todo.update(title: params[:title])
  redirect '/todos'
end

delete '/todos/:id' do
  @todo = Todo.find(params[:id])
  @todo.destroy
  redirect '/todos'
end

get '/api/todos' do
  content_type :json
  todos = Todo.all
  JSON.pretty_generate(todos)
end

post '/api/todos' do
  content_type :json
  data = JSON.parse request.body.read
  todo = Todo.create(title: data['title'])
  JSON.pretty_generate(todo)
end

get '/api/todos/:id' do
  content_type :json
  todo = Todo.find(params[:id])
  JSON.pretty_generate(todo)
end

put '/api/todos/:id' do
  content_type :json
  data = JSON.parse request.body.read
  todo = Todo.find(params[:id])
  todo = todo.update(title: data['title'])
  JSON.pretty_generate(todo)
end

delete '/api/todos/:id' do
  todo = Todo.find(params[:id])
  todo.destroy
  JSON.pretty_generate({message: 'TODO deleted'})
end
