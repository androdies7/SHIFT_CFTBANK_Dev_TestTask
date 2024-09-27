CREATE TABLE clients (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    place_of_birth VARCHAR(100),
    date_of_birth DATE,
    address VARCHAR(1000),
    passport VARCHAR(100)
);


CREATE TABLE product_type (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    begin_date DATE,
    end_date DATE,
    tarif_ref INT
);


CREATE TABLE products (
    id INT PRIMARY KEY,
    product_type_id INT,
    name VARCHAR(100),
    client_ref INT,
    open_date DATE,
    close_date DATE,
    FOREIGN KEY (product_type_id) REFERENCES product_type(id),
    FOREIGN KEY (client_ref) REFERENCES clients(id)
);


CREATE TABLE accounts (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    saldo DECIMAL(10, 2),
    client_ref INT,
    open_date DATE,
    close_date DATE,
    product_ref INT,
    acc_num VARCHAR(25),
    FOREIGN KEY (client_ref) REFERENCES clients(id),
    FOREIGN KEY (product_ref) REFERENCES products(id)
);


CREATE TABLE records (
    id INT PRIMARY KEY,
    dt INT,
    sum DECIMAL(10, 2),
    acc_ref INT,
    oper_date DATE,
    FOREIGN KEY (acc_ref) REFERENCES accounts(id)
);


CREATE TABLE tarifs (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    cost DECIMAL(10, 2)
);
