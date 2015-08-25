module CORE

  class Question
    include Mongoid::Document
    include Mongoid::Timestamps
    field :_id,                  type: BSON::ObjectId
    field :title,                type: String
    has_many :votes, dependent: :destroy
    # many :votes
    # field :published_at,        type: Time
  end

  class Vote
    include Mongoid::Document
    field :_id,                  type: BSON::ObjectId
    field :content,              type: String
    field :positive,             type: Integer, default: 0
    field :negative,             type: Integer, default: 0
    belongs_to :question

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

    before do
      @q = Question.all
      if @q.empty?
        flash[:notice] = "No questions found!"
      end
    end

    get '/' do
      @title = "Hack Reactions"
      if !request.websocket?
        @message = 'no socket detected'
        haml :index
      else
        @message = []
        request.websocket do |ws|
          ws.onopen do
            ws.send("Hello!")
            settings.sockets << ws
            @message << "Hello World!"
          end

          ws.onclose do
            warn("websocket closed")
            settings.sockets.delete(ws)
            @message << 'websocket closed'
          end

        end

      end


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
