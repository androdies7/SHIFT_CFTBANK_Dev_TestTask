--- Задания

--- Сформируйте отчет, который содержит все счета, относящиеся к продуктам типа ДЕПОЗИТ, принадлежащих клиентам, у которых нет открытых продуктов типа КРЕДИТ.

SELECT a.name AS account_name, a.saldo, a.acc_num 
FROM accounts a 
JOIN products p ON a.product_ref = p.id 
JOIN product_type pt ON p.product_type_id = pt.id 
WHERE pt.name = 'ДЕПОЗИТ' 
AND p.client_ref NOT IN (
    SELECT p2.client_ref 
    FROM products p2 
    JOIN product_type pt2 ON p2.product_type_id = pt2.id 
    WHERE pt2.name = 'КРЕДИТ' 
    AND p2.close_date IS NULL 
) 
LIMIT 0, 1000;


--- Сформируйте выборку, который содержит средние движения по счетам в рамках одного произвольного дня, в разрезе типа продукта.

SELECT pt.name AS product_type, AVG(r.sum) AS avg_transaction_sum, r.oper_date
FROM records r
JOIN accounts a ON r.acc_ref = a.id
JOIN products p ON a.product_ref = p.id
JOIN product_type pt ON p.product_type_id = pt.id
GROUP BY pt.name, r.oper_date
ORDER BY r.oper_date;


---Сформируйте выборку, в который попадут клиенты, у которых были операции по счетам за прошедший месяц от текущей даты. Выведите клиента и сумму операций за день в разрезе даты.

SELECT c.name AS client_name, SUM(r.sum) AS total_operations, r.oper_date
FROM records r
JOIN accounts a ON r.acc_ref = a.id
JOIN clients c ON a.client_ref = c.id
WHERE r.oper_date >= CURDATE() - INTERVAL 1 MONTH
GROUP BY c.name, r.oper_date
ORDER BY r.oper_date;


--- В результате сбоя в базе данных разъехалась информация между остатками и операциями по счетам. Напишите нормализацию (процедуру выравнивающую данные), которая найдет такие счета и восстановит остатки по счету.

UPDATE accounts a
JOIN (
    SELECT r.acc_ref, SUM(
        CASE 
            WHEN r.dt = 1 THEN -r.sum  -- дебет
            WHEN r.dt = 0 THEN r.sum  -- кредит
        END
    ) AS calculated_saldo
    FROM records r
    GROUP BY r.acc_ref
) AS r_sum ON a.id = r_sum.acc_ref
SET a.saldo = r_sum.calculated_saldo;


--- Сформируйте выборку, который содержит информацию о клиентах, которые полностью погасили кредит, но при этом не закрыли продукт и пользуются им дальше (по продукту есть операция новой выдачи кредита).

SELECT c.name, p.name AS product_name, a.saldo, p.open_date, p.close_date
FROM clients c
JOIN products p ON c.id = p.client_ref
JOIN product_type pt ON p.product_type_id = pt.id
JOIN accounts a ON a.product_ref = p.id
WHERE pt.name = 'КРЕДИТ'
  AND a.saldo >= 0  -- Полностью погашен
  AND p.close_date IS NULL  -- Продукт не закрыт
  AND EXISTS (
    SELECT 1
    FROM records r
    WHERE r.acc_ref = a.id
      AND r.dt = 1  -- Новая выдача кредита (дебет)
  );


--- Закройте продукты (установите дату закрытия равную текущей) типа КРЕДИТ, у которых произошло полное погашение, но при этом не было повторной выдачи.

UPDATE products p
JOIN product_type pt ON p.product_type_id = pt.id
JOIN accounts a ON a.product_ref = p.id
LEFT JOIN records r ON r.acc_ref = a.id
SET p.close_date = CURDATE()  -- дата закрытия на текущую дату
WHERE pt.name = 'КРЕДИТ'  -- продукт типа "КРЕДИТ"
  AND a.saldo >= 0  -- продукт полностью погашен
  AND p.close_date IS NULL  -- еще не закрыт
  AND NOT EXISTS (  -- проверка на отсутствие новой выдачи кредита (дебет)
    SELECT 1
    FROM records r2
    WHERE r2.acc_ref = a.id
      AND r2.dt = 1  -- Новая выдача кредита (дебетовая операция)
  );


-- Закройте возможность открытия (установите дату окончания действия) для типов продуктов, по счетам продуктов которых, не было движений более одного месяца.

UPDATE product_type pt
SET pt.end_date = CURDATE()  -- установка даты окончания действия на текущую дату
WHERE pt.id IN (
    SELECT DISTINCT p.product_type_id
    FROM products p
    JOIN accounts a ON p.id = a.product_ref
    LEFT JOIN records r ON a.id = r.acc_ref
    WHERE r.oper_date < CURDATE() - INTERVAL 1 MONTH  -- Нет движений за последний месяц
    OR r.oper_date IS NULL  -- Нет операций вообще
);


-- В модель данных добавьте сумму договора по продукту. Заполните поле для всех продуктов суммой максимальной дебетовой операции по счету для продукта типа КРЕДИТ, и суммой максимальной кредитовой операции по счету продукта для продукта типа ДЕПОЗИТ или КАРТА.

-- Добавим новое поле contract_sum в таблицу products
ALTER TABLE products
ADD COLUMN contract_sum DECIMAL(10, 2);  -- новое поле для суммы договора

-- Обновим данные в новом поле contract_sum
-- Обновляем суммы для продуктов типа КРЕДИТ (максимальная дебетовая операция)
UPDATE products p
JOIN accounts a ON p.id = a.product_ref
JOIN product_type pt ON p.product_type_id = pt.id
SET p.contract_sum = (
    SELECT MAX(r.sum)
    FROM records r
    WHERE r.acc_ref = a.id
    AND r.dt = 1  -- дебетовая операция
)
WHERE pt.name = 'КРЕДИТ';

-- Обновляем суммы для продуктов типа ДЕПОЗИТ и КАРТА (максимальная кредитовая операция)
UPDATE products p
JOIN accounts a ON p.id = a.product_ref
JOIN product_type pt ON p.product_type_id = pt.id
SET p.contract_sum = (
    SELECT MAX(r.sum)
    FROM records r
    WHERE r.acc_ref = a.id
    AND r.dt = 0  -- кредитовая операция
)
WHERE pt.name IN ('ДЕПОЗИТ', 'КАРТА');

-- проверка
SELECT * FROM products;

