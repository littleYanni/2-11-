//1
SELECT P."ФИО",
       COUNT(Z."id_заказа") AS "Количество заказов"
FROM "Покупатель" P
LEFT JOIN "Заказ" Z ON Z."id_покупателя" = P."id_покупателя"
GROUP BY P."ФИО";



//2
SELECT S."Адрес",
       AVG(T."Цена") AS "Средняя цена"
FROM "Склад" S
JOIN "Товар" T ON T."id_склада" = S."id_склада"
GROUP BY S."Адрес";



//3
SELECT "Название", "Цена"
FROM "Товар"
WHERE "Цена" > (SELECT AVG("Цена") FROM "Товар");


//4
SELECT S."ФИО",
       COUNT(Z."id_заказа") AS "Количество заказов"
FROM "Сотрудник" S
JOIN "Заказ" Z ON Z."id_сотрудника" = S."id_сотрудника"
GROUP BY S."ФИО";



//5
SELECT S."Адрес",
       SUM(T."Количество_на_складе") AS "Всего товаров"
FROM "Склад" S
JOIN "Товар" T ON T."id_склада" = S."id_склада"
GROUP BY S."Адрес"
HAVING SUM(T."Количество_на_складе") > 50;


//6
SELECT ZT."id_заказа", T."Название", ZT."Количество"
FROM "Заказ_Товар" ZT
JOIN "Товар" T ON T."id_товара" = ZT."id_товара"
WHERE ZT."Количество" > (SELECT AVG("Количество") FROM "Заказ_Товар");



//7
SELECT Z."id_заказа",
       SUM(T."Цена" * ZT."Количество") AS "Сумма заказа"
FROM "Заказ" Z
JOIN "Заказ_Товар" ZT ON ZT."id_заказа" = Z."id_заказа"
JOIN "Товар" T ON T."id_товара" = ZT."id_товара"
GROUP BY Z."id_заказа"
HAVING SUM(T."Цена" * ZT."Количество") > 20000;


//8
SELECT T."Название", T."Цена", T."id_склада"
FROM "Товар" T
WHERE T."Цена" > (
    SELECT AVG(T2."Цена")п
    FROM "Товар" T2
    WHERE T2."id_склада" = T."id_склада"
);



//9
SELECT P."ФИО",
       SUM(T."Цена" * ZT."Количество") AS "Сумма покупок"
FROM "Покупатель" P
JOIN "Заказ" Z ON Z."id_покупателя" = P."id_покупателя"
JOIN "Заказ_Товар" ZT ON ZT."id_заказа" = Z."id_заказа"
JOIN "Товар" T ON T."id_товара" = ZT."id_товара"
GROUP BY P."ФИО";



//10
SELECT "Способ_доставки",
       COUNT("id_доставки") AS "Доставлено"
FROM "Доставка"
WHERE "Статус_доставки" = 'Доставлено'
GROUP BY "Способ_доставки";
