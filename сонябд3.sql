-- Таблица "Инструктор": содержит информацию об инструкторах автошколы
CREATE TABLE "Инструктор" (
    "ID_инструктора" VARCHAR(10) PRIMARY KEY,
    "ФИО" VARCHAR(60) NOT NULL,
    "Категории" VARCHAR(50),
    "Номер_телефона" VARCHAR(15)
);

COMMENT ON TABLE "Инструктор" IS 'Информация об инструкторах автошколы';
COMMENT ON COLUMN "Инструктор"."Категории" IS 'Категории водительских прав, которые преподаёт инструктор';


-- Таблица "Группа": учебные группы, прикреплённые к инструкторам
CREATE TABLE "Группа" (
    "ID_группы" VARCHAR(10) PRIMARY KEY,
    "ID_инструктора" VARCHAR(10),
    "Название" VARCHAR(50),
    "Дата_начала" DATE,
    CONSTRAINT "FK_Группа_Инструктор" FOREIGN KEY ("ID_инструктора")
        REFERENCES "Инструктор" ("ID_инструктора")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Группа" IS 'Учебные группы, формируемые в автошколе';
COMMENT ON COLUMN "Группа"."Дата_начала" IS 'Дата начала обучения группы';


-- Таблица "Курсант": ученики автошколы
CREATE TABLE "Курсант" (
    "ID_курсанта" VARCHAR(10) PRIMARY KEY,
    "ID_группы" VARCHAR(10),
    "ФИО" VARCHAR(60),
    "Дата_рождения" DATE,
    "Номер_телефона" VARCHAR(15),
    CONSTRAINT "FK_Курсант_Группа" FOREIGN KEY ("ID_группы")
        REFERENCES "Группа" ("ID_группы")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Курсант" IS 'Курсанты, обучающиеся в автошколе';
COMMENT ON COLUMN "Курсант"."Дата_рождения" IS 'Дата рождения курсанта';


-- Таблица "Автомобиль": транспортные средства, используемые для обучения
CREATE TABLE "Автомобиль" (
    "ID_автомобиля" VARCHAR(10) PRIMARY KEY,
    "ID_инструктора" VARCHAR(10),
    "Модель" VARCHAR(50),
    "Категория" VARCHAR(20),
    CONSTRAINT "FK_Автомобиль_Инструктор" FOREIGN KEY ("ID_инструктора")
        REFERENCES "Инструктор" ("ID_инструктора")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Автомобиль" IS 'Автомобили, на которых проходит обучение вождению';
COMMENT ON COLUMN "Автомобиль"."Категория" IS 'Категория транспортного средства (например, B, C)';


-- Таблица "Вождение": записи о практических занятиях
CREATE TABLE "Вождение" (
    "ID_вождения" VARCHAR(10) PRIMARY KEY,
    "ID_курсанта" VARCHAR(10),
    "ID_инструктора" VARCHAR(10),
    "ID_автомобиля" VARCHAR(10),
    "Дата_и_время" TIMESTAMP,
    "Отработанные_часы" NUMERIC(4,2) CHECK ("Отработанные_часы" >= 0),
    "Маршрут" VARCHAR(100),
    CONSTRAINT "FK_Вождение_Курсант" FOREIGN KEY ("ID_курсанта")
        REFERENCES "Курсант" ("ID_курсанта")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT "FK_Вождение_Инструктор" FOREIGN KEY ("ID_инструктора")
        REFERENCES "Инструктор" ("ID_инструктора")
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT "FK_Вождение_Автомобиль" FOREIGN KEY ("ID_автомобиля")
        REFERENCES "Автомобиль" ("ID_автомобиля")
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Вождение" IS 'Занятия по вождению, проводимые с курсантами';
COMMENT ON COLUMN "Вождение"."Дата_и_время" IS 'Дата и время практического занятия';
COMMENT ON COLUMN "Вождение"."Отработанные_часы" IS 'Количество часов, отработанных на занятии';


-- Таблица "Предмет": теоретические дисциплины, изучаемые курсантами
CREATE TABLE "Предмет" (
    "ID_предмета" VARCHAR(10) PRIMARY KEY,
    "Название" VARCHAR(50),
    "Количество_часов" INTEGER CHECK ("Количество_часов" >= 0)
);

COMMENT ON TABLE "Предмет" IS 'Теоретические дисциплины, входящие в программу обучения';
COMMENT ON COLUMN "Предмет"."Количество_часов" IS 'Количество учебных часов по предмету';


-- Таблица "Группа_Предмет": связь многие-ко-многим между группами и предметами
CREATE TABLE "Группа_Предмет" (
    "ID_группы" VARCHAR(10),
    "ID_предмета" VARCHAR(10),
    PRIMARY KEY ("ID_группы", "ID_предмета"),
    CONSTRAINT "FK_ГП_Группа" FOREIGN KEY ("ID_группы")
        REFERENCES "Группа" ("ID_группы")
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT "FK_ГП_Предмет" FOREIGN KEY ("ID_предмета")
        REFERENCES "Предмет" ("ID_предмета")
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE "Группа_Предмет" IS 'Распределение предметов по учебным группам';
