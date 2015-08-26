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

  it 'responds to index' do
    get '/'
    last_response.should.be.ok?
    last_response.body.should.include('Hack Reactions')
  end

end


#
#
# class ReactionerText < MiniTest::Unit::TestCase
#   include Rack::Test::Methods
#
#   def app
#     CORE::Main
#   end
#
#   def test_index
#     get '/'
#     assert last_response.ok?
#     assert last_response.body.include?('Hack Reactions')
#   end
#
#   def test_new_question_form
#     get '/question/new'
#     assert last_response.ok?
#
#   end
#
#   def test_list_questions
#     get '/question/all'
#     assert last_response.ok?
#   end
#
#   def test_test_creation
#     get '/question/new'
#     assert last_response.ok?
#     assert last_response.body.include('Add a Question')
#
#
#     post '/question/create'
#
#
#   end
#
#   def test_show_question
#     q = CORE::Question.new(:title=>'Does this work?')
#     q.save!
#     id = CORE::Question.last.id
#     puts id.to_s
#     get '/question/show/' + id.to_s
#     assert last_response.ok?
#     assert last_response.body.include?('Does this work?')
#     CORE::Question.find(id).delete
#   end
#
#
#
#
#
# end
