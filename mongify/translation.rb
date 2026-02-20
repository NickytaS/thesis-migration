# Mongify translation for Blog DB
table 'users' do
  column 'id', :key
  column 'username', :string
  column 'email', :string
  column 'display_name', :string
  column 'created_at', :datetime
end

table 'posts' do
  column 'id', :key
  column 'user_id', :integer, :references => 'users'
  column 'title', :string
  column 'body', :text
  column 'status', :string
  column 'created_at', :datetime
end

table 'comments' do
  column 'id', :key
  column 'post_id', :integer, :references => 'posts'
  column 'author', :string
  column 'content', :text
  column 'created_at', :datetime
end
