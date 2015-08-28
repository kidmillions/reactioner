module CORE

  class Question
    include Mongoid::Document
    include Mongoid::Timestamps
    field :title,                type: String
    field :is_current,           type: Boolean, default: false
    embeds_many :votes

    # many :votes
    # field :published_at,        type: Time
  end

  class Vote
    include Mongoid::Document
    field :content,              type: String
    field :positive,             type: Integer, default: 0
    field :negative,             type: Integer, default: 0
    embedded_in :question

  end

#   EventMachine.run do
#
#     class Main < Sinatra::Base
#       configure :development do
#         enable :sessions, :logging, :dump_errors
#         enable :methodoverride
#         set :sockets, []
#         set :server, 'thin'
#         set :root, File.dirname(__FILE__)
#         logger = Logger.new($stdout)
#         Mongoid.configure do |config|
#           name = "reactiondb"
#           host = "localhost"
#           config.connect_to(name)
#           #config.logger = Logger.new($stdout, :warn)
#           config.logger = logger
#         end
#       end
#
#       before do
#         @q = Question.all
#         if @q.empty?
#           flash[:notice] = "No questions found!"
#         end
#       end
#
#
#       get '/' do
#         haml :index
#       end
#     end
#
#     @channel = EM::Channel.new
#
#     EventMachine::WebSocket.start(:host => '0.0.0.0', :port=> 5000) do |ws|
#       ws.onopen {
#         sid = @channel.subscribe { |msg| ws.send msg }
#         @channel.push "#{sid} connected!"
#
#         ws.onmessage { |msg|
#           @channel.push "<#{sid}>: #{msg}"
#         }
#
#         ws.onclose {
#           @channel.unsubscribe(sid)
#         }
#       }
#
#     end
#
#     # Main.run!({:port => 3000})
#
#
#   end
#



  class Main < Sinatra::Base
    register Sinatra::Flash


    configure :development do
      enable :sessions, :logging, :dump_errors
      enable :methodoverride
      set :public_folder, 'public'
      set :sockets, []
      set :server, 'thin'
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

    configure :test do
      enable :sessions
      set :public_folder, 'public'
      set :sockets, []
      set :server, 'thin'
      set :root, File.dirname(__FILE__)
      Mongoid.configure do |config|
        name = "reactiondbtest"
        host = "localhost"
        config.connect_to(name)
        config.logger.level = Logger::UNKNOWN
        # config.logger = Logger.new(nil)
        #config.logger = Logger.new($stdout, :warn)
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
      @current_question = Question.where(:is_current => true).first
      # if !request.websocket?
      #   @message = 'no socket detected'
      #   haml :index
      # else
      #   @message = []
      #   request.websocket do |ws|
      #     ws.onopen do
      #       ws.send("Hello!")
      #       settings.sockets << ws
      #       @message << "Hello World!"
      #     end
      #
      #     ws.onclose do
      #       warn("websocket closed")
      #       settings.sockets.delete(ws)
      #       @message << 'websocket closed'
      #     end
      #
      #   end
      #
      # end


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
      if q.is_current?
        Question.where(:is_current=>true).update_all(:is_current=>false)
      end
      q.save
      if q.save
        flash[:notice] = "Question created"
        # @message = 'Question created!'
      else
        "Error saving doc"
      end
      redirect '/'
    end

    get '/question/new' do
      q = Question.new
      haml :new
    end

    post '/vote/create/:id' do |question_id|
      q = Question.find(question_id)
      q.votes << Vote.new(params[:vote])
      q.save!
      if q.save
        # @message = 'Ya voted, ya dingus!'
        flash[:notice] = "Vote submitted"
      else
        "Error saving vote"
      end
      redirect '/'
    end

    post '/vote/:id' do |vote_id|
      vote_data = params
      p vote_data
      v = Question.find(vote_data[:question_id]).votes.find(vote_id)
      if vote_data[:vote_type] == 'positive'
        v.positive += 1
      elsif vote_data[:vote_type] == 'negative'
        v.negative += 1
      end
      v.save!

      redirect '/'

    end





  end


end
