CREATE TABLE Покупатель (
    id_покупателя CHAR(10) PRIMARY KEY,
    ФИО CHAR(60) NOT NULL,
    Номер_телефона CHAR(15) NOT NULL,
    Адрес CHAR(100) NOT NULL
);

CREATE TABLE Сотрудник (
    id_сотрудника CHAR(10) PRIMARY KEY,
    ФИО CHAR(60) NOT NULL,
    Должность CHAR(30) NOT NULL,
    Номер_телефона CHAR(15) NOT NULL
);

CREATE TABLE Склад (
    id_склада CHAR(10) PRIMARY KEY,
    Адрес CHAR(100) NOT NULL,
    Вместимость INTEGER DEFAULT 0 CHECK (Вместимость >= 0),
    Номер_склада CHAR(10),
    Ответственный_сотрудник CHAR(10),
    CONSTRAINT FK_Склад_Сотрудник FOREIGN KEY (Ответственный_сотрудник)
        REFERENCES Сотрудник (id_сотрудника)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Товар (
    id_товара CHAR(10) PRIMARY KEY,
    id_склада CHAR(10),
    Название CHAR(50) NOT NULL,
    Цена DECIMAL(10,2) CHECK (Цена >= 0),
    Количество_на_складе INTEGER DEFAULT 0 CHECK (Количество_на_складе >= 0),
    CONSTRAINT FK_Товар_Склад FOREIGN KEY (id_склада)
        REFERENCES Склад (id_склада)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Заказ (
    id_заказа CHAR(10) PRIMARY KEY,
    id_покупателя CHAR(10) NOT NULL,
    id_сотрудника CHAR(10),
    Дата_заказа DATE NOT NULL,
    Статус_заказа CHAR(20) CHECK (Статус_заказа IN ('Новый', 'В обработке', 'Доставлен', 'Отменён')),
    Способ_оплаты CHAR(20) CHECK (Способ_оплаты IN ('Карта', 'Наличные', 'Онлайн')),
    CONSTRAINT FK_Заказ_Покупатель FOREIGN KEY (id_покупателя)
        REFERENCES Покупатель (id_покупателя)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Заказ_Сотрудник FOREIGN KEY (id_сотрудника)
        REFERENCES Сотрудник (id_сотрудника)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Заказ_Товар (
    id_заказа CHAR(10),
    id_товара CHAR(10),
    Количество INTEGER DEFAULT 1 CHECK (Количество > 0),
    PRIMARY KEY (id_заказа, id_товара),
    CONSTRAINT FK_ЗаказТовар_Заказ FOREIGN KEY (id_заказа)
        REFERENCES Заказ (id_заказа)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_ЗаказТовар_Товар FOREIGN KEY (id_товара)
        REFERENCES Товар (id_товара)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Доставка (
    id_доставки CHAR(10) PRIMARY KEY,
    id_заказа CHAR(10) UNIQUE,
    Дата_доставки DATE NOT NULL,
    Статус_доставки CHAR(20) CHECK (Статус_доставки IN ('В пути', 'Доставлено', 'Отменено')),
    Способ_доставки CHAR(20) CHECK (Способ_доставки IN ('Курьер', 'Самовывоз', 'Почта')),
    CONSTRAINT FK_Доставка_Заказ FOREIGN KEY (id_заказа)
        REFERENCES Заказ (id_заказа)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
