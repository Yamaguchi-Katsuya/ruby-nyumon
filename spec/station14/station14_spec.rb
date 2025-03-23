require 'spec_helper'
require 'rack/test'
require 'json'
require_relative '../../app'

RSpec.describe 'API: TODOリスト操作', clear_db: true do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:all) do
    start_server
  end

  after(:all) do
    stop_server
  end

  let(:test_todo) { { title: 'テスト用TODO' } }
  let!(:todo_id) do
    DB.execute('INSERT INTO todos (title) VALUES (?)', [test_todo[:title]])
    DB.last_insert_row_id
  end

  describe 'GET /api/todos/:id' do
    before { get "/api/todos/#{todo_id}" }

    it 'ステータスコード200を返すこと' do
      expect(last_response.status).to eq 200
    end

    it 'JSON形式でレスポンスが返されること' do
      expect(last_response.content_type).to include('application/json')
    end

    it '指定したIDのTODOを取得できること' do
      response_body = JSON.parse(last_response.body)
      expect(response_body[1]).to eq(test_todo[:title])
    end
  end
end
