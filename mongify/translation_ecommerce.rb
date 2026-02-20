# Mongify translation for Ecommerce DB
table 'categories' do
  column 'id', :key
  column 'name', :string
end

table 'customers' do
  column 'id', :key
  column 'first_name', :string
  column 'last_name', :string
  column 'email', :string
  column 'created_at', :datetime
end

table 'products' do
  column 'id', :key
  column 'category_id', :integer, :references => 'categories'
  column 'name', :string
  column 'description', :text
  column 'price', :decimal
  column 'sku', :string
  column 'available', :boolean
  column 'created_at', :datetime
end

table 'addresses' do
  column 'id', :key
  column 'customer_id', :integer, :references => 'customers'
  column 'line1', :string
  column 'city', :string
  column 'country', :string
  column 'postal_code', :string
end

table 'payment_methods' do
  column 'id', :key
  column 'customer_id', :integer, :references => 'customers'
  column 'type', :string
  column 'details', :text
end

table 'payments' do
  column 'id', :key
  column 'order_id', :integer
  column 'payment_method_id', :integer, :references => 'payment_methods'
  column 'amount', :decimal
  column 'paid_at', :datetime
end

table 'orders' do
  column 'id', :key
  column 'customer_id', :integer, :references => 'customers'
  column 'order_date', :datetime
  column 'status', :string
  column 'total', :decimal
end

table 'order_items' do
  column 'order_id', :integer, :references => 'orders'
  column 'product_id', :integer, :references => 'products'
  column 'quantity', :integer
  column 'unit_price', :decimal
end

table 'reviews' do
  column 'id', :key
  column 'product_id', :integer, :references => 'products'
  column 'customer_id', :integer, :references => 'customers'
  column 'rating', :integer
  column 'comment', :text
  column 'created_at', :datetime
end

table 'product_images' do
  column 'id', :key
  column 'product_id', :integer, :references => 'products'
  column 'url', :string
  column 'alt_text', :string
end
