ENV['RACK_ENV'] = 'test'


require 'bundler/setup'
Bundler.require('default')
require 'rack/test'
require File.dirname(__FILE__) + './reactioner.rb'

class Bacon::Context
  include Rack::Test::Methods
end


describe "Hack Reactioner" do

  def app
    CORE::Main
  end

  before do
    CORE::Question.all.destroy
  end

  it 'responds to index' do
    get '/'
    last_response.should.be.ok
    last_response.body.should.include('Hack Reactions')
  end

  it 'shows all of the questions' do
    get '/question/all'
    last_response.should.be.ok

  end

  it 'creates new questions' do
    get '/question/new'
    last_response.should.be.ok
    last_response.body.should.include('Add a Question')

    post '/question/create', {:question => {:title=>"Where am I?"}}, {}

    last_response.body.should.include("Question created!")
    CORE::Question.last.title.should.equal('Where am I?')

  end

  it 'shows a created question' do
    q = CORE::Question.new(:title=>'Does this work?')
    q.save!
    id = CORE::Question.last.id
    get '/question/show/' + id.to_s
    last_response.should.be.ok
    last_response.body.should.include('Does this work?')
  end



end
