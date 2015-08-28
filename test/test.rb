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
    CORE::Vote.all.destroy

    q = CORE::Question.new(:title=>'Sample Question?', :is_current=>true)
    q.save!

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

  it 'creates new questions and shows them as current' do
    get '/question/new'
    last_response.should.be.ok
    last_response.body.should.include('Add a Question')

    post '/question/create', {:question => {:title=>"Where am I?", :is_current=>true}}, {}

    # get '/'
    CORE::Question.count.should.equal(2)
    # last_response.body.should.include("Where am I?")
    # CORE::Question.last.title.should.equal('Where am I?')



  end

  it 'shows a created question' do
    id = CORE::Question.last.id
    get '/question/show/' + id.to_s
    last_response.should.be.ok
    last_response.body.should.include('Sample Question?')
  end

  it 'shows a created vote' do
    id = CORE::Question.first.id
    post '/vote/create/' + id.to_s, {:vote=> {:content=>"sample vote"}}

    CORE::Question.first.votes.count.should.equal(1)

    get '/'
    last_response.body.should.include('sample vote')

  end



end
