CREATE TABLE Покупатель (
    Номер_покупателя CHAR(10) PRIMARY KEY,        
    ФИО CHAR(60) NOT NULL,                     
    Адрес CHAR(100) NOT NULL,                     
    Номер_телефона CHAR(15) NOT NULL               
);

CREATE TABLE Сотрудник (
    Номер_сотрудника CHAR(10) PRIMARY KEY,       
    ФИО CHAR(60) NOT NULL,                      
    Должность CHAR(30) NOT NULL,                  
    Номер_телефона CHAR(15) NOT NULL               
);

-- Таблица "Склад"
CREATE TABLE Склад (
    Номер_склада CHAR(10) PRIMARY KEY,            
    Адрес CHAR(100) NOT NULL,                     
    Вместимость INTEGER DEFAULT 0 CHECK (Вместимость >= 0), 
    Ответственный_сотрудник CHAR(10),             
    CONSTRAINT Склад_Сотрудник_FK FOREIGN KEY (Ответственный_сотрудник)
        REFERENCES Сотрудник (Номер_сотрудника)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Товар (
    Номер_товара CHAR(10) PRIMARY KEY,            
    Название CHAR(50) NOT NULL,                  
    Цена DECIMAL(10,2) CHECK (Цена >= 0),      
    Количество_на_складе INTEGER DEFAULT 0 CHECK (Количество_на_складе >= 0),
    Номер_склада CHAR(10),                       
    CONSTRAINT Товар_Склад_FK FOREIGN KEY (Номер_склада)
        REFERENCES Склад (Номер_склада)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Заказ (
    Номер_заказа CHAR(10) PRIMARY KEY,             
    Дата_заказа DATE NOT NULL,                    
    Статус_заказа CHAR(20) CHECK (Статус_заказа IN ('Новый', 'В обработке', 'Доставлен', 'Отменён')),
    Способ_оплаты CHAR(20) CHECK (Способ_оплаты IN ('Карта', 'Наличные', 'Онлайн')),
    Номер_покупателя CHAR(10) NOT NULL,          
    Номер_сотрудника CHAR(10),                     
    CONSTRAINT Заказ_Покупатель_FK FOREIGN KEY (Номер_покупателя)
        REFERENCES Покупатель (Номер_покупателя)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Заказ_Сотрудник_FK FOREIGN KEY (Номер_сотрудника)
        REFERENCES Сотрудник (Номер_сотрудника)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Доставка (
    Номер_доставки CHAR(10) PRIMARY KEY,         
    Дата_доставки DATE NOT NULL,                 
    Статус_доставки CHAR(20) CHECK (Статус_доставки IN ('В пути', 'Доставлено', 'Отменено')),
    Способ_доставки CHAR(20) CHECK (Способ_доставки IN ('Курьер', 'Самовывоз', 'Почта')),
    Номер_заказа CHAR(10) UNIQUE,                 
    CONSTRAINT Доставка_Заказ_FK FOREIGN KEY (Номер_заказа)
        REFERENCES Заказ (Номер_заказа)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Состав_заказа (
    Номер_заказа CHAR(10),
    Номер_товара CHAR(10),
    Количество INTEGER DEFAULT 1 CHECK (Количество > 0),
    PRIMARY KEY (Номер_заказа, Номер_товара),
    CONSTRAINT Состав_заказа_Заказ_FK FOREIGN KEY (Номер_заказа)
        REFERENCES Заказ (Номер_заказа)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT Состав_заказа_Товар_FK FOREIGN KEY (Номер_товара)
        REFERENCES Товар (Номер_товара)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



