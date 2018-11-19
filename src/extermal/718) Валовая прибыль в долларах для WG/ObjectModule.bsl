﻿Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	//ЗаполнитьНачальныеНастройкиПоМакету(ПолучитьМакет("ПараметрыОтчетовПродажиКомпании"), СтруктураПредставлениеПолей, МассивОтбора, ОбщийОтчет, "СписокКроссТаблица");
	Текст = "ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Группа
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90230""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Важность
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90184""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Статус
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90218""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	СУММА(ТаблицаРегистра.КоличествоОборот) КАК Количество,
	        |	СУММА(ТаблицаРегистра.КоличествоОборот * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕд,
	        |	СУММА(ТаблицаРегистра.СтоимостьОборот / 58) КАК Стоимость,
	        |	СРЕДНЕЕ(ВЫБОР
	        |			КОГДА ТаблицаРегистра.КоличествоОборот = 0
	        |				ТОГДА ТаблицаРегистра.СтоимостьОборот
	        |			ИНАЧЕ ТаблицаРегистра.СтоимостьОборот / ТаблицаРегистра.КоличествоОборот
	        |		КОНЕЦ / 58) КАК СтоимостьЕдиницы,
	        |	СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот / 58) КАК Себестоимость,
	        |	СРЕДНЕЕ(ВЫБОР
	        |			КОГДА ТаблицаРегистра.КоличествоОборот <> 0
	        |				ТОГДА ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0) / ТаблицаРегистра.КоличествоОборот
	        |			ИНАЧЕ ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0)
	        |		КОНЕЦ / 58) КАК СебестоимостьЕдиницы,
	        |	(ВЫБОР
	        |		КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL 
	        |			ТОГДА 0
	        |		ИНАЧЕ СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |	КОНЕЦ - ВЫБОР
	        |		КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL 
	        |			ТОГДА 0
	        |		ИНАЧЕ СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |	КОНЕЦ) / 58 КАК ВаловаяПрибыль,
	        |	ВЫРАЗИТЬ(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) <> 0
	        |				ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК РентабельностьПродаж,
	        |	ВЫРАЗИТЬ(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) <> 0
	        |				ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПроцентНаценки,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец КАК Покупатель,
	        |	ТаблицаРегистра.Номенклатура КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.Номенклатура.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	        |	Важность.Значение КАК Важность,
	        |	Статус.Значение КАК Статус,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет КАК Интернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал КАК Терминал,
	        |	ЕСТЬNULL(Группа.Значение, ТаблицаРегистра.ДоговорКонтрагента.Владелец) КАК РабочаяГруппа
	        |{ВЫБРАТЬ
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	НоменклатурнаяГруппа.*,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	ТаблицаРегистра.Период,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ГОД)) КАК ПериодГод,
	        |	Важность.*,
	        |	Статус.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |ИЗ
	        |	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ТаблицаРегистра
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажиСебестоимость.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ТаблицаРегистраСебестоимость
	        |		ПО ТаблицаРегистра.Номенклатура = ТаблицаРегистраСебестоимость.Номенклатура
	        |			И ТаблицаРегистра.ХарактеристикаНоменклатуры = ТаблицаРегистраСебестоимость.ХарактеристикаНоменклатуры
	        |			И ТаблицаРегистра.ЗаказПокупателя = ТаблицаРегистраСебестоимость.ЗаказПокупателя
	        |			И ТаблицаРегистра.Подразделение = ТаблицаРегистраСебестоимость.Подразделение
	        |			И ТаблицаРегистра.Регистратор = ТаблицаРегистраСебестоимость.Регистратор
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Важность КАК Важность
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Важность.Объект
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Статус КАК Статус
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Статус.Объект
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Группа КАК Группа
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Группа.Объект
	        |{ГДЕ
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	ТаблицаРегистра.Период,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	(СУММА(ТаблицаРегистра.КоличествоОборот)) КАК Количество,
	        |	(СУММА(ТаблицаРегистра.КоличествоОборот * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент)) КАК КоличествоБазовыхЕд,
	        |	(СУММА(ТаблицаРегистра.СтоимостьОборот)) КАК Стоимость,
	        |	(СУММА(ВЫБОР
	        |				КОГДА ТаблицаРегистра.КоличествоОборот = 0
	        |					ТОГДА ТаблицаРегистра.СтоимостьОборот
	        |				ИНАЧЕ ТаблицаРегистра.СтоимостьОборот / ТаблицаРегистра.КоличествоОборот
	        |			КОНЕЦ)) КАК СтоимостьЕдиницы,
	        |	(СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) КАК Себестоимость,
	        |	(СУММА(ВЫБОР
	        |				КОГДА ТаблицаРегистра.КоличествоОборот <> 0
	        |					ТОГДА ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0) / ТаблицаРегистра.КоличествоОборот
	        |				ИНАЧЕ ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0)
	        |			КОНЕЦ)) КАК СебестоимостьЕдиницы,
	        |	(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL 
	        |				ТОГДА 0
	        |			ИНАЧЕ СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |		КОНЕЦ - ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL 
	        |				ТОГДА 0
	        |			ИНАЧЕ СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |		КОНЕЦ) КАК ВаловаяПрибыль,
	        |	(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистра.КоличествоОборот) = 0
	        |				ТОГДА ВЫБОР
	        |						КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL 
	        |							ТОГДА 0
	        |						ИНАЧЕ СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |					КОНЕЦ - ВЫБОР
	        |						КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL 
	        |							ТОГДА 0
	        |						ИНАЧЕ СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |					КОНЕЦ
	        |			ИНАЧЕ СУММА((ЕСТЬNULL(ТаблицаРегистра.СтоимостьОборот, 0) - ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0)) / ТаблицаРегистра.КоличествоОборот)
	        |		КОНЕЦ) КАК ВаловаяПрибыльЕдиницы,
	        |	(ВЫРАЗИТЬ(ВЫБОР
	        |				КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) <> 0
	        |					ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |				ИНАЧЕ 0
	        |			КОНЕЦ КАК ЧИСЛО(15, 2))) КАК РентабельностьПродаж,
	        |	(ВЫРАЗИТЬ(ВЫБОР
	        |				КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) <> 0
	        |					ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |				ИНАЧЕ 0
	        |			КОНЕЦ КАК ЧИСЛО(15, 2))) КАК ПроцентНаценки,
	        |	(ВЫРАЗИТЬ(Важность.Значение КАК ЧИСЛО(10, 0))) КАК Важность,
	        |	(ВЫРАЗИТЬ(Статус.Значение КАК Перечисление.КатегорииКонтрагентов)).* КАК Статус,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет КАК Интернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал КАК Терминал,
	        |	(ЕСТЬNULL(Группа.Значение, ТаблицаРегистра.ДоговорКонтрагента.Владелец)).* КАК РабочаяГруппа}
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец,
	        |	ТаблицаРегистра.Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.Номенклатура.НоменклатурнаяГруппа,
	        |	Важность.Значение,
	        |	Статус.Значение,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал,
	        |	ЕСТЬNULL(Группа.Значение, ТаблицаРегистра.ДоговорКонтрагента.Владелец)
	        |{УПОРЯДОЧИТЬ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	ТаблицаРегистра.Период,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	(СУММА(ТаблицаРегистра.КоличествоОборот)) КАК Количество,
	        |	(СУММА(ТаблицаРегистра.КоличествоОборот * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент)) КАК КоличествоБазовыхЕд,
	        |	(СУММА(ТаблицаРегистра.СтоимостьОборот)) КАК Стоимость,
	        |	(СУММА(ВЫБОР
	        |				КОГДА ТаблицаРегистра.КоличествоОборот = 0
	        |					ТОГДА ТаблицаРегистра.СтоимостьОборот
	        |				ИНАЧЕ ТаблицаРегистра.СтоимостьОборот / ТаблицаРегистра.КоличествоОборот
	        |			КОНЕЦ)) КАК СтоимостьЕдиницы,
	        |	(СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) КАК Себестоимость,
	        |	(СУММА(ВЫБОР
	        |				КОГДА ТаблицаРегистра.КоличествоОборот <> 0
	        |					ТОГДА ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0) / ТаблицаРегистра.КоличествоОборот
	        |				ИНАЧЕ ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0)
	        |			КОНЕЦ)) КАК СебестоимостьЕдиницы,
	        |	(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL 
	        |				ТОГДА 0
	        |			ИНАЧЕ СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |		КОНЕЦ - ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL 
	        |				ТОГДА 0
	        |			ИНАЧЕ СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |		КОНЕЦ) КАК ВаловаяПрибыль,
	        |	(ВЫБОР
	        |			КОГДА СУММА(ТаблицаРегистра.КоличествоОборот) = 0
	        |				ТОГДА ВЫБОР
	        |						КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL 
	        |							ТОГДА 0
	        |						ИНАЧЕ СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |					КОНЕЦ - ВЫБОР
	        |						КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL 
	        |							ТОГДА 0
	        |						ИНАЧЕ СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |					КОНЕЦ
	        |			ИНАЧЕ СУММА((ЕСТЬNULL(ТаблицаРегистра.СтоимостьОборот, 0) - ЕСТЬNULL(ТаблицаРегистраСебестоимость.СтоимостьОборот, 0)) / ТаблицаРегистра.КоличествоОборот)
	        |		КОНЕЦ) КАК ВаловаяПрибыльЕдиницы,
	        |	(ВЫРАЗИТЬ(ВЫБОР
	        |				КОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) <> 0
	        |					ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистра.СтоимостьОборот)
	        |				ИНАЧЕ 0
	        |			КОНЕЦ КАК ЧИСЛО(15, 2))) КАК РентабельностьПродаж,
	        |	(ВЫРАЗИТЬ(ВЫБОР
	        |				КОГДА СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) <> 0
	        |					ТОГДА 100 * (СУММА(ТаблицаРегистра.СтоимостьОборот) - СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)) / СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	        |				ИНАЧЕ 0
	        |			КОНЕЦ КАК ЧИСЛО(15, 2))) КАК ПроцентНаценки,
	        |	Важность.*,
	        |	Статус.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |ИТОГИ
	        |	СУММА(Количество),
	        |	СУММА(КоличествоБазовыхЕд),
	        |	СУММА(Стоимость),
	        |	СУММА(СтоимостьЕдиницы),
	        |	СУММА(Себестоимость),
	        |	СУММА(СебестоимостьЕдиницы),
	        |	СУММА(ВаловаяПрибыль),
	        |	ВЫРАЗИТЬ(ВЫБОР
	        |			КОГДА СУММА(Стоимость) <> 0
	        |				ТОГДА 100 * (СУММА(Стоимость) - СУММА(Себестоимость)) / СУММА(Стоимость)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК РентабельностьПродаж,
	        |	ВЫРАЗИТЬ(ВЫБОР
	        |			КОГДА СУММА(Себестоимость) <> 0
	        |				ТОГДА 100 * (СУММА(Стоимость) - СУММА(Себестоимость)) / СУММА(Себестоимость)
	        |			ИНАЧЕ 0
	        |		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК ПроцентНаценки
	        |ПО
	        |	ОБЩИЕ
	        |{ИТОГИ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	НоменклатурнаяГруппа.*,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ГОД)) КАК ПериодГод,
	        |	Важность.*,
	        |	Статус.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |АВТОУПОРЯДОЧИВАНИЕ";
	СтруктураПредставлениеПолей = Новый Структура("
	|Количество,
	|КоличествоБазовыхЕд,
	|Стоимость,
	|СтоимостьЕдиницы,
	|Себестоимость,
	|СебестоимостьЕдиницы,
	|ВаловаяПрибыль,
	|РентабельностьПродаж,
	|ПроцентНаценки,
	|Покупатель,
	|ДоговорКонтрагента,
	|ЗаказПокупателя,
	|НоменклатураБазоваяЕдиницаИзмерения,
	|ХарактеристикаНоменклатуры,
	|Подразделение,
	|ПериодДень,
	|ПериодНеделя,
	|ПериодМесяц,
	|ПериодКвартал,
	|ПериодГод,
	|Важность,
	|Статус,
	|Интернет,
	|Терминал,
	|РабочаяГруппа", 
	"Количество товара в единицах хранения остатков",
	"Количество товара в базовых единицах",
	"Продажная стоимость",
	"Продажная стоимость единицы",	
	"Себестоимость",
	"Себестоимость единицы",
	"Валовая прибыль",
	"Рентабельность продаж, %",
	"Процент наценки",
	"Покупатель",
	"Договор контрагента",
	"Заказ покупателя",
	"Базовая единица измерения",
	"Характеристика номенклатуры",
	"Подразделение",
	"По дням",
	"По неделям",
	"По месяцам",
	"По кварталам",
	"По годам",
	"Важность",
	"Статус",
	"Интернет",
	"Терминал",
	"РабочаяГруппа");
	
	Если ОбщийОтчет.ИспользоватьСвойстваИКатегории Тогда
	
	    ТекстПоляСвойств= "";
		ТекстПоляКатегорий = "";

		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "Номенклатура";
		СтрокаТаблицы.Представление = "Номенклатура";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить(); //+++ 11.09.2013
		СтрокаТаблицы.ПутьКДанным = "ДоговорКонтрагента.Владелец";
		СтрокаТаблицы.Представление = "Покупатель";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;
	
		ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, 
				ОбщийОтчет.мСоответствиеНазначений, ПостроительОтчета.Параметры
				,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,ОбщийОтчет.мСтруктураДляОтбораПоКатегориям);
				
		ДобавитьВТекстСвойстваОбщие(Текст, ТекстПоляСвойств, "//ОБЩИЕ_СВОЙСТВА");
      // для избежания двойственности поля Номенклатура в запросе
	    Текст=СтрЗаменить(Текст,"ИНАЧЕ Номенклатура","ИНАЧЕ ТаблицаРегистраСебестоимость.Номенклатура");
	    Текст=СтрЗаменить(Текст,"= Номенклатура","= ТаблицаРегистра.Номенклатура");	
		//Если Ввалюте тогда
	//    Текст=СтрЗаменить(Текст,"&Курс","58");
		//иначе
		//Текст=СтрЗаменить(Текст,"&Курс","1");
		//конецЕсли;
		
				
	УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, ОбщийОтчет.мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;
	
	ПостроительОтчета.Текст = Текст;
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Покупатель");
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Подразделение");
	
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
	ОбщийОтчет.ВыводитьПоказателиВСтроку = Истина;
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Истина;
	
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в единицах хранения", Ложь, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в базовых единицах", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("Стоимость", "Продажная стоимость в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СтоимостьЕдиницы", "Продажная стоимость единцы в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("Себестоимость", "Себестоимость в валюте упр. учета", Ложь, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СебестоимостьЕдиницы", "Себестоимость единицы в валюте упр. учета", Ложь, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("ВаловаяПрибыль", "Валовая прибыть в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РентабельностьПродаж", "Рентабельность продаж, %", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("ПроцентНаценки", "Процент наценки", Истина, "ЧЦ=15; ЧДЦ=2");

	ОбщийОтчет.мНазваниеОтчета = "Отчет по валовой прибыли";
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Ложь;
	ОбщийОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Установим дату начала отчета
	Если ЗначениеНеЗаполнено(ОбщийОтчет.ДатаНач) Тогда
		
		Если Не ЗначениеНеЗаполнено(глТекущийПользователь) Тогда
			ОбщийОтчет.ДатаНач = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ОсновнаяДатаНачалаОтчетов");
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		
		//+++ 26.06.2013 - ограничение по подразделению
		Если НЕ ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "СтаршийМенеджерПодразделения") Тогда
           СообщитьОбОшибке("У вас недостаточно прав для просмотра данного отчета!");
		   Возврат;
	    КонецЕсли;
		
	 	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ИспользоватьМеханизмДележкиДляГруппы") тогда 
			СписокМенеджеров = ПолучитьСписокПользователейСвоейГруппы();
			Если ОбщийОтчет.ПостроительОтчета.Отбор.Найти("ДоговорКонтрагента") = неопределено тогда
				ОбщийОтчет.ПостроительОтчета.Отбор.Добавить("ДоговорКонтрагента");
			КонецЕсли;
			
			СписокДоговоровМенеджера = ПолучитьСписокДоговоровМенеджера(СписокМенеджеров);
			ОбщийОтчет.ПостроительОтчета.Отбор.ДоговорКонтрагента.Использование = Истина;
			ОбщийОтчет.ПостроительОтчета.Отбор.ДоговорКонтрагента.ВидСравнения = ВидСравнения.ВСписке;
			ОбщийОтчет.ПостроительОтчета.Отбор.ДоговорКонтрагента.Значение = СписокДоговоровМенеджера;
       
			//СписокКонтр = ПолучитьСписокКонтрагентовМенеджера(СписокМенеджеров);
			//ОбщийОтчет.ПостроительОтчета.Отбор.Покупатель.Использование = Истина;
			//ОбщийОтчет.ПостроительОтчета.Отбор.Покупатель.ВидСравнения = ВидСравнения.ВСписке;
			//ОбщийОтчет.ПостроительОтчета.Отбор.Покупатель.Значение = СписокКонтр;
        Иначе
			ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
	    	ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Значение = ДоступноеПодразделение;
			ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Использование = Истина;
			ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.ВидСравнения = ВидСравнения.Равно;
		КонецЕсли;	
	КонецЕсли;

	//ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("РентабельностьПродаж", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
	//ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("ПроцентНаценки", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПРоцедуры

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура Настроить(Параметры) Экспорт

	ОбщийОтчет.Настроить(Параметры, ЭтотОбъект);

КонецПроцедуры

// Возвращает основную форму отчета, связанную с данным экземпляром отчета
//
// Параметры
//	Нет
//
Функция ПолучитьОсновнуюФорму() Экспорт
	
	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;
	
КонецФункции // ПолучитьОсновнуюФорму()

// Возвращает форму настройки 
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	
//
Функция ПолучитьФормуНастройки() Экспорт
	
	ОбщийОтчет.мВыбиратьИспользованиеСвойств = Истина;//+++ 11.09.2013
	
	ФормаНастройки = ОбщийОтчет.ПолучитьФорму("ФормаНастройка");
	
	Возврат ФормаНастройки;
	
КонецФункции // ПолучитьФормуНастройки()

// Процедура обработки расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровки(РасшифровкаСтроки, ПолеТД, ВысотаЗаголовка, СтандартнаяОбработка) Экспорт
	
	// Добавление расшифровки из колонки
	Если ТипЗнч(РасшифровкаСтроки) = Тип("Структура") Тогда
		
		// Расшифровка колонки находится в заголовке колонки
		РасшифровкаКолонки = ПолеТД.Область(ВысотаЗаголовка+2, ПолеТД.ТекущаяОбласть.Лево).Расшифровка;

		Расшифровка = Новый Структура;

		Для каждого Элемент Из РасшифровкаСтроки Цикл
			Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;

		Если ТипЗнч(РасшифровкаКолонки) = Тип("Структура") Тогда

			Для каждого Элемент Из РасшифровкаКолонки Цикл
				Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;

		КонецЕсли; 

		ОбщийОтчет.ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОбъект);

	КонецЕсли;
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру, в которую складываются настройки
//
Функция СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	ОбщийОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураНастроек, ПоказыватьЗаголовок);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Заполняет настройки из структуры - кроме состояния панели "Отбор"
//
Процедура ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет=Неопределено) Экспорт
	
	// Если отчет, вызвавший порцедуру, не передан, то считаем, что ее вызвал этот отчет
	Если Отчет = Неопределено Тогда
		Отчет = ЭтотОбъект;
	КонецЕсли;

	ОбщийОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет);
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "Продажи";