require 'mongo_mapper'

configure do
  MongoMapper.setup({'development' => {'url' => ENV['http://localhost:27017']}}, 'development')
end


# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Hack Reactions"
  haml :index
end
