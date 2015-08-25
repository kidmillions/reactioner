module CORE

  class Question
    include Mongoid::Document
    include Mongoid::Timestamps
    field :_id,                   type: BSON::ObjectId
    field :title,                type: String
    # many :votes
    # field :published_at,        type: Time
  end

  class Vote
    include Mongoid::Document
    field :content,              type: String
    field :positive,             type: Integer, default: 0
    field :negative,             type: Integer, default: 0


  end


  class Main < Sinatra::Base
    register Sinatra::Flash

    configure :development do
      enable :sessions, :logging, :dump_errors
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

    get '/question/all' do
      @title = 'All Questions'
      @questions = Question.all()
      haml :list
    end


    get '/question/show/:id' do |id|
      @q = Question.find(id)
      haml :show
    end

    post '/question/create' do
      q = Question.new(params[:question])
      if q.save
        @message = 'CREATED, ASSHOLE'
      else
        "Error saving doc"
      end
      haml :index

    end

    get '/question/new' do
      q = Question.new
      haml :new
    end


  end


end
