//4.1
SELECT "ФИО",
	RIGHT("Номер_телефона", 5) AS "Номер без кода"
FROM "Покупатель";

//4.2
SELECT TO_CHAR("Дата_заказа",'DD FMMonth YYYY "года"') AS "дата полност"