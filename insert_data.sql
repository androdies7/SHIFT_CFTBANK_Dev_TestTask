-- Вставка данных в таблицу tarifs
INSERT INTO tarifs VALUES (1,'Тариф за выдачу кредита', 10);
INSERT INTO tarifs VALUES (2,'Тариф за открытие счета', 10);
INSERT INTO tarifs VALUES (3,'Тариф за обслуживание карты', 10);

-- Вставка данных в таблицу product_type
INSERT INTO product_type VALUES (1, 'КРЕДИТ', '2018-01-01', NULL, 1);
INSERT INTO product_type VALUES (2, 'ДЕПОЗИТ', '2018-01-01', NULL, 2);
INSERT INTO product_type VALUES (3, 'КАРТА', '2018-01-01', NULL, 3);

-- Вставка данных в таблицу clients
INSERT INTO clients VALUES (1, 'Сидоров Иван Петрович', 'Россия, Московская облать, г. Пушкин', '2001-01-01', 'Россия, Московская облать, г. Пушкин, ул. Грибоедова, д. 5', '2222 555555, выдан ОВД г. Пушкин, 10.01.2015');
INSERT INTO clients VALUES (2, 'Иванов Петр Сидорович', 'Россия, Московская облать, г. Клин', '2001-01-01', 'Россия, Московская облать, г. Клин, ул. Мясникова, д. 3', '4444 666666, выдан ОВД г. Клин, 10.01.2015');
INSERT INTO clients VALUES (3, 'Петров Сиодр Иванович', 'Россия, Московская облать, г. Балашиха', '2001-01-01', 'Россия, Московская облать, г. Балашиха, ул. Пушкина, д. 7', '4444 666666, выдан ОВД г. Клин, 10.01.2015');

-- Вставка данных в таблицу products
INSERT INTO products VALUES (1, 1, 'Кредитный договор с Сидоровым И.П.', 1, '2015-06-01', NULL);
INSERT INTO products VALUES (2, 2, 'Депозитный договор с Ивановым П.С.', 2, '2017-08-01', NULL);
INSERT INTO products VALUES (3, 3, 'Карточный договор с Петровым С.И.', 3, '2017-08-01', NULL);

-- Вставка данных в таблицу accounts
INSERT INTO accounts VALUES (1, 'Кредитный счет для Сидоровым И.П.', -2000, 1, '2015-06-01', NULL, 1, '45502810401020000022');
INSERT INTO accounts VALUES (2, 'Депозитный счет для Ивановым П.С.', 6000, 2, '2017-08-01', NULL, 2, '42301810400000000001');
INSERT INTO accounts VALUES (3, 'Карточный счет для Петровым С.И.', 8000, 3, '2017-08-01', NULL, 3, '40817810700000000001');

-- Вставка данных в таблицу records
INSERT INTO records VALUES (1, 1, 5000, 1, '2015-06-01');
INSERT INTO records VALUES (2, 0, 1000, 1, '2015-07-01');
INSERT INTO records VALUES (3, 0, 2000, 1, '2015-08-01');
INSERT INTO records VALUES (4, 0, 3000, 1, '2015-09-01');
INSERT INTO records VALUES (5, 1, 5000, 1, '2015-10-01');
INSERT INTO records VALUES (6, 0, 3000, 1, '2015-10-01');

INSERT INTO records VALUES (7, 0, 10000, 2, '2017-08-01');
INSERT INTO records VALUES (8, 1, 1000, 2, '2017-08-05');
INSERT INTO records VALUES (9, 1, 2000, 2, '2017-09-21');
INSERT INTO records VALUES (10, 1, 5000, 2, '2017-10-24');
INSERT INTO records VALUES (11, 0, 6000, 2, '2017-11-26');

INSERT INTO records VALUES (12, 0, 120000, 3, '2017-09-08');
INSERT INTO records VALUES (13, 1, 1000, 3, '2017-10-05');
INSERT INTO records VALUES (14, 1, 2000, 3, '2017-10-21');
INSERT INTO records VALUES (15, 1, 5000, 3, '2017-10-24');
