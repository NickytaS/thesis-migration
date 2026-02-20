# Verify MySQL contains the test databases and sample row counts
# Usage: .\scripts\verify-mysql.ps1

$queries = @(
  "SHOW DATABASES;",
  "SELECT table_schema,table_name,table_rows FROM information_schema.tables WHERE table_schema IN ('blog_db','ecommerce_db','erp_db');",
  "USE blog_db; SELECT 'blog.users', COUNT(*) FROM users;",
  "USE blog_db; SELECT 'blog.posts', COUNT(*) FROM posts;",
  "USE blog_db; SELECT 'blog.comments', COUNT(*) FROM comments;",
  "USE ecommerce_db; SELECT 'ecom.customers', COUNT(*) FROM customers;",
  "USE ecommerce_db; SELECT 'ecom.products', COUNT(*) FROM products;",
  "USE erp_db; SELECT 'erp.employees', COUNT(*) FROM employees;",
  "USE erp_db; SELECT 'erp.inventory_items', COUNT(*) FROM inventory_items;"
)

foreach ($q in $queries) {
  Write-Host "--- SQL: $q"
  docker exec mysql8 mysql -uroot -prootpassword -e "$q"
}
