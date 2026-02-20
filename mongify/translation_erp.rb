# Mongify translation for ERP DB
table 'departments' do
  column 'id', :key
  column 'name', :string
end

table 'employees' do
  column 'id', :key
  column 'department_id', :integer, :references => 'departments'
  column 'manager_id', :integer, :references => 'employees'
  column 'first_name', :string
  column 'last_name', :string
  column 'hire_date', :date
  column 'email', :string
  column 'salary', :decimal
end

table 'projects' do
  column 'id', :key
  column 'name', :string
  column 'start_date', :date
  column 'end_date', :date
end

table 'project_assignments' do
  column 'project_id', :integer, :references => 'projects'
  column 'employee_id', :integer, :references => 'employees'
  column 'role', :string
  column 'allocation_percent', :integer
end

table 'attendance' do
  column 'id', :key
  column 'employee_id', :integer, :references => 'employees'
  column 'date', :date
  column 'status', :string
end

table 'suppliers' do
  column 'id', :key
  column 'name', :string
  column 'contact', :string
end

table 'warehouses' do
  column 'id', :key
  column 'name', :string
  column 'location', :string
end

table 'inventory_items' do
  column 'id', :key
  column 'sku', :string
  column 'description', :string
  column 'unit_cost', :decimal
end

table 'warehouse_stock' do
  column 'warehouse_id', :integer, :references => 'warehouses'
  column 'item_id', :integer, :references => 'inventory_items'
  column 'quantity', :integer
  column 'quantity_available', :integer
end

table 'purchase_orders' do
  column 'id', :key
  column 'supplier_id', :integer, :references => 'suppliers'
  column 'order_date', :date
  column 'status', :string
end

table 'po_line_items' do
  column 'po_id', :integer, :references => 'purchase_orders'
  column 'item_id', :integer, :references => 'inventory_items'
  column 'qty', :integer
  column 'unit_price', :decimal
end

table 'accounts' do
  column 'id', :key
  column 'account_code', :string
  column 'name', :string
end

table 'journal_entries' do
  column 'id', :key
  column 'entry_date', :date
  column 'description', :string
end

table 'journal_lines' do
  column 'id', :key
  column 'journal_id', :integer, :references => 'journal_entries'
  column 'account_id', :integer, :references => 'accounts'
  column 'debit', :decimal
  column 'credit', :decimal
end
