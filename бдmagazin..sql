-- 1. Таблица Покупатель
CREATE TABLE "Покупатель" (
    "id_покупателя" VARCHAR(10) PRIMARY KEY,
    "ФИО" VARCHAR(60) NOT NULL,
    "Номер_телефона" VARCHAR(15) NOT NULL,
    "Адрес" VARCHAR(100) NOT NULL
);

COMMENT ON TABLE "Покупатель" IS 'Содержит информацию о клиентах магазина';
COMMENT ON COLUMN "Покупатель"."ФИО" IS 'Фамилия, имя, отчество покупателя';
COMMENT ON COLUMN "Покупатель"."Номер_телефона" IS 'Контактный номер клиента';
COMMENT ON COLUMN "Покупатель"."Адрес" IS 'Адрес проживания покупателя';

-- 2. Таблица Сотрудник
CREATE TABLE "Сотрудник" (
    "id_сотрудника" VARCHAR(10) PRIMARY KEY,
    "ФИО" VARCHAR(60) NOT NULL,
    "Должность" VARCHAR(30) NOT NULL,
    "Номер_телефона" VARCHAR(15) NOT NULL
);

COMMENT ON TABLE "Сотрудник" IS 'Информация о сотрудниках организации';
COMMENT ON COLUMN "Сотрудник"."Должность" IS 'Занимаемая должность сотрудника';

-- 3. Таблица Склад
CREATE TABLE "Склад" (
    "id_склада" VARCHAR(10) PRIMARY KEY,
    "Адрес" VARCHAR(100) NOT NULL,
    "Вместимость" INTEGER DEFAULT 0 CHECK ("Вместимость" >= 0),
    "Номер_склада" VARCHAR(10),
    "Ответственный_сотрудник" VARCHAR(10),
    CONSTRAINT "FK_Склад_Сотрудник" FOREIGN KEY ("Ответственный_сотрудник")
        REFERENCES "Сотрудник" ("id_сотрудника")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Склад" IS 'Сведения о складах хранения товаров';
COMMENT ON COLUMN "Склад"."Ответственный_сотрудник" IS 'ID сотрудника, отвечающего за склад';

-- 4. Таблица Товар
CREATE TABLE "Товар" (
    "id_товара" VARCHAR(10) PRIMARY KEY,
    "id_склада" VARCHAR(10),
    "Название" VARCHAR(50) NOT NULL,
    "Цена" NUMERIC(10,2) CHECK ("Цена" >= 0),
    "Количество_на_складе" INTEGER DEFAULT 0 CHECK ("Количество_на_складе" >= 0),
    CONSTRAINT "FK_Товар_Склад" FOREIGN KEY ("id_склада")
        REFERENCES "Склад" ("id_склада")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Товар" IS 'Каталог товаров, доступных в системе';
COMMENT ON COLUMN "Товар"."Цена" IS 'Стоимость единицы товара в рублях';

-- 5. Таблица Заказ
CREATE TABLE "Заказ" (
    "id_заказа" VARCHAR(10) PRIMARY KEY,
    "id_покупателя" VARCHAR(10) NOT NULL,
    "id_сотрудника" VARCHAR(10),
    "Дата_заказа" DATE NOT NULL,
    "Статус_заказа" VARCHAR(20) CHECK ("Статус_заказа" IN ('Новый', 'В обработке', 'Доставлен', 'Отменён')),
    "Способ_оплаты" VARCHAR(20) CHECK ("Способ_оплаты" IN ('Карта', 'Наличные', 'Онлайн')),
    CONSTRAINT "FK_Заказ_Покупатель" FOREIGN KEY ("id_покупателя")
        REFERENCES "Покупатель" ("id_покупателя")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT "FK_Заказ_Сотрудник" FOREIGN KEY ("id_сотрудника")
        REFERENCES "Сотрудник" ("id_сотрудника")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Заказ" IS 'Информация о заказах клиентов';

-- 6. Таблица Заказ_Товар (связь многие-ко-многим)
CREATE TABLE "Заказ_Товар" (
    "id_заказа" VARCHAR(10),
    "id_товара" VARCHAR(10),
    "Количество" INTEGER DEFAULT 1 CHECK ("Количество" > 0),
    PRIMARY KEY ("id_заказа", "id_товара"),
    CONSTRAINT "FK_ЗаказТовар_Заказ" FOREIGN KEY ("id_заказа")
        REFERENCES "Заказ" ("id_заказа")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT "FK_ЗаказТовар_Товар" FOREIGN KEY ("id_товара")
        REFERENCES "Товар" ("id_товара")
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Заказ_Товар" IS 'Связь между заказами и товарами с указанием количества';

-- 7. Таблица Доставка
CREATE TABLE "Доставка" (
    "id_доставки" VARCHAR(10) PRIMARY KEY,
    "id_заказа" VARCHAR(10) UNIQUE,
    "Дата_доставки" DATE NOT NULL,
    "Статус_доставки" VARCHAR(20) CHECK ("Статус_доставки" IN ('В пути', 'Доставлено', 'Отменено')),
    "Способ_доставки" VARCHAR(20) CHECK ("Способ_доставки" IN ('Курьер', 'Самовывоз', 'Почта')),
    CONSTRAINT "FK_Доставка_Заказ" FOREIGN KEY ("id_заказа")
        REFERENCES "Заказ" ("id_заказа")
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Доставка" IS 'Информация о процессе доставки заказов';
COMMENT ON COLUMN "Доставка"."Способ_доставки" IS 'Метод доставки: курьер, самовывоз или почта';
