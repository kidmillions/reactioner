class Question
  include MongoMapper::Document

  key :name,                String
  key :votes,               Hash
  key :published_at,        Time
  timestamps!
end
