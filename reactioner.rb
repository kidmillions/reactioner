module CORE

  class Question
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name,                type: String
    # many :votes
    # field :published_at,        type: Time
  end

  class Main < Sinatra::Base
    register Sinatra::Flash

    configure :development do
      enable :sessions, :logging, :dump_errors, :inline_templates
      enable :methodoverride
      set :root, File.dirname(__FILE__)
      logger = Logger.new($stdout)

      Mongoid.configure do |config|
        name = "reactiondb"
        host = "localhost"
        config.connect_to(name)
        #config.logger = Logger.new($stdout, :warn)
        config.logger = logger
      end
    end

    before do
      @q = Question.all
      if @q.empty?
        flash[:notice] = "No questions found!"
      end
    end

    get '/' do
      @title = "Hack Reactions"
      haml :index
    end

    get '/question/list' do
      @title = 'All Questions'
      @questions = Question.all()
      haml :list
    end

    get '/question/create' do
      Question.create(
        name: "Sample Question",
      )

      @message = 'CREATED, ASSHOLE'
      haml :create

    end

  end


end
