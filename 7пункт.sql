

-- 1. Просмотр справочников
SELECT id, name, description FROM roles ORDER BY id;
SELECT id, role_id, full_name, email, created_at FROM users ORDER BY id;
SELECT id, name, type, description FROM categories ORDER BY id;
SELECT id, name FROM payment_methods ORDER BY id;

-- 2. Просмотр операций с названиями категорий и способов оплаты
SELECT t.id, t.user_id, u.full_name AS user_name, t.type, t.amount,
       t.transaction_date, c.name AS category, pm.name AS payment_method,
       t.description
FROM transactions t
JOIN users u ON u.id = t.user_id
JOIN categories c ON c.id = t.category_id
LEFT JOIN payment_methods pm ON pm.id = t.payment_method_id
ORDER BY t.transaction_date DESC, t.id DESC;

-- 3. Добавление операции
INSERT INTO transactions
    (user_id, category_id, payment_method_id, type, amount, description, transaction_date)
VALUES
    (1, 1, 1, 'expense', 250.00, 'Пример расхода', CURRENT_DATE)
RETURNING *;

-- 4. Изменение операции с id=1 (пример; поменяйте ID при необходимости)
UPDATE transactions
SET amount = 300.00, description = 'Исправленное описание'
WHERE id = 1
RETURNING *;

-- 5. Удаление: сначала проверьте запись. Сам DELETE оставлен закомментированным.
SELECT * FROM transactions WHERE id = 1;
-- DELETE FROM transactions WHERE id = 1 RETURNING *;

-- 6. Операции конкретного пользователя
SELECT * FROM transactions
WHERE user_id = 1
ORDER BY transaction_date DESC;

-- 7. Операции за текущий месяц
SELECT * FROM transactions
WHERE transaction_date >= date_trunc('month', CURRENT_DATE)::date
  AND transaction_date < (date_trunc('month', CURRENT_DATE) + INTERVAL '1 month')::date
ORDER BY transaction_date DESC;

-- 8. Расходы за указанный период
SELECT * FROM transactions
WHERE type = 'expense'
  AND transaction_date BETWEEN DATE '2026-10-01' AND DATE '2026-10-31'
ORDER BY transaction_date DESC;

-- 9. Поиск по описанию
SELECT * FROM transactions
WHERE description ILIKE '%тест%'
ORDER BY transaction_date DESC;

-- 10. Фильтр по категории
SELECT * FROM transactions WHERE category_id = 1 ORDER BY transaction_date DESC;

-- 11. Сортировка по сумме
SELECT * FROM transactions ORDER BY amount DESC;

-- 12. Итоги доходов, расходов и баланса пользователя
SELECT
  COALESCE(SUM(amount) FILTER (WHERE type = 'income'), 0) AS total_income,
  COALESCE(SUM(amount) FILTER (WHERE type = 'expense'), 0) AS total_expense,
  COALESCE(SUM(amount) FILTER (WHERE type = 'income'), 0)
    - COALESCE(SUM(amount) FILTER (WHERE type = 'expense'), 0) AS balance
FROM transactions
WHERE user_id = 1;

-- 13. Расходы по категориям
SELECT c.name AS category, SUM(t.amount) AS total_expense
FROM transactions t
JOIN categories c ON c.id = t.category_id
WHERE t.user_id = 1 AND t.type = 'expense'
GROUP BY c.id, c.name
ORDER BY total_expense DESC;

-- 14. Доходы и расходы по месяцам
SELECT date_trunc('month', transaction_date)::date AS month,
       COALESCE(SUM(amount) FILTER (WHERE type = 'income'), 0) AS income,
       COALESCE(SUM(amount) FILTER (WHERE type = 'expense'), 0) AS expense
FROM transactions
WHERE user_id = 1
GROUP BY date_trunc('month', transaction_date)
ORDER BY month;

-- 15. Количество операций и сумма по способам оплаты
SELECT pm.name AS payment_method, COUNT(t.id) AS operations_count,
       COALESCE(SUM(t.amount), 0) AS total_amount
FROM payment_methods pm
LEFT JOIN transactions t ON t.payment_method_id = pm.id
GROUP BY pm.id, pm.name
ORDER BY operations_count DESC;

-- 16. Количество пользователей по ролям
SELECT r.name AS role, COUNT(u.id) AS users_count
FROM roles r
LEFT JOIN users u ON u.role_id = r.id
GROUP BY r.id, r.name
ORDER BY users_count DESC;

-- 17. Проверка несовпадения типа операции и типа категории
SELECT t.id, t.type AS transaction_type, c.type AS category_type, c.name AS category
FROM transactions t
JOIN categories c ON c.id = t.category_id
WHERE t.type <> c.type;

-- 18. Проверка количества записей в основных таблицах
SELECT 'roles' AS table_name, COUNT(*) AS row_count FROM roles
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'payment_methods', COUNT(*) FROM payment_methods
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions
ORDER BY table_name;
