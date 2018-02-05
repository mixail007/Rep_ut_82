﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мКоманда Экспорт;

Перем мСписокНоменклатуры Экспорт;
Перем мКонтрагент Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Заполняет параметры построителя отчета.
//
Процедура ЗаполнитьОбщиеПараметрыПостроителяОтчета()

	ДопКолонка   = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	//ВыводитьКоды = Истина;
	Если ДопКолонка <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить Тогда
		ИмяКолонкиКодов = Строка(ДопКолонка);
	//Иначе
	//	ВыводитьКоды = Ложь;
	КонецЕсли;

	ПостроительОтчета.Параметры.Вставить("ДатаЦенСкидок", ДатаЦенСкидок);
	ПостроительОтчета.Параметры.Вставить("ПустаяСтрока", "");
	ПостроительОтчета.Параметры.Вставить("ДопКолонка", ДопКолонка);
	ПостроительОтчета.Параметры.Вставить("Артикул", Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул);
	ПостроительОтчета.Параметры.Вставить("Код", Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код);
	ПостроительОтчета.Параметры.Вставить("ПустаяХарактеристикаНоменклатуры", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	ПостроительОтчета.Параметры.Вставить("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию ("Программа"));

КонецПроцедуры // ЗаполнитьОбщиеПараметрыПостроителяОтчета()

// Формирует и заполняет построитель отчета по регистру "ЦеныНоменклатуры"
//
Процедура ЗаполнитьПостроительОтчетаПоЦенамНоменклатуры(ВключатьНезаполненные, ЗаполнятьТолькоТекстЗапроса, ВключатьТолькоНаОстатках=ЛОЖЬ) Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ //РАЗЛИЧНЫЕ
	|Тип.Ссылка                                                 КАК ТипЦен,
	|Ном.Ссылка                                                 КАК Номенклатура,
	|Ном.ЭтоГруппа                                              КАК ЭтоГруппа,
	|ВЫБОР 
	|	КОГДА Тип.Рассчитывается ТОГДА
	|		Рег.Цена * (100 + Тип.ПроцентСкидкиНаценки)/100
	|	ИНАЧЕ
	|		Рег.Цена
	|	КОНЕЦ                                                   КАК Цена
	|
	|{ВЫБРАТЬ
	|	Тип.Ссылка.*                                            КАК ТипЦен,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа
	|	//СВОЙСТВА
	|}
	|
	|ИЗ
	|	Справочник.Номенклатура КАК Ном
	|	//СОЕДИНЕНИЯ
	|
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатуры КАК Тип
	|ПО 
	|	ИСТИНА
	|
	|	ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦенСкидок, ) КАК Рег  
	|ПО
	|	(Тип.Ссылка = Рег.ТипЦен И НЕ Тип.Рассчитывается ИЛИ Тип.БазовыйТипЦен = Рег.ТипЦен И Тип.Рассчитывается)
	|	И
	|	Ном.Ссылка = Рег.Номенклатура 
	|";


	Если Не ВключатьНезаполненные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	Ном.Ссылка В (Выбрать Номенклатура ИЗ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦенСкидок,))
		|	//И
		|	//ХарактеристикиНоменклатуры.Ссылка В (Выбрать ХарактеристикаНоменклатуры ИЗ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦенСкидок,))
		|";
	КонецЕсли;

	Если ВключатьТолькоНаОстатках Тогда
		ТекстЗапроса = ТекстЗапроса + "ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	| РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаЦенСкидок) ТоварыНаСкладахОстатки
	| По Ном.Ссылка=ТоварыНаСкладахОстатки.Номенклатура
	|";
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
	|{ГДЕ
	|	Тип.Ссылка.*                                            КАК ТипЦен,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа //,
	|	//Программа
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Номенклатура,
	|	//ХарактеристикаНоменклатуры,
	|	ТипЦен
	|	//СВОЙСТВА
	|
	|ИТОГИ ПО 
	|	Номенклатура ТОЛЬКО ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ
	|";

	ПостроительОтчета.Текст = ТекстЗапроса;

	Если Не ЗаполнятьТолькоТекстЗапроса Тогда

		// Соответствие имен полей в запросе и их представлений в отчете
		СтруктураПредставлениеПолей = Новый Структура(
		"	ТипЦен, 
		|	Номенклатура",
		"Тип цен",
		"Номенклатура");

		ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);

		// отборы по умолчанию
		Пока ПостроительОтчета.Отбор.Количество() > 0 Цикл
			ПостроительОтчета.Отбор.Удалить(0);
		КонецЦикла;

		МассивОтбора = Новый Массив;

		Если ТипыЦенСкидок.Количество() = 0 Тогда
			МассивОтбора.Добавить("ТипЦен");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("ТипЦен",, "Тип цен");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение.ЗагрузитьЗначения(ТипыЦенСкидок.ВыгрузитьКолонку("ТипЦенСкидок"));
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		Если мСписокНоменклатуры = Неопределено Тогда
			МассивОтбора.Добавить("Номенклатура");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("Номенклатура",, "Номенклатура");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение      = мСписокНоменклатуры;
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		
		//ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("Программа",, "Программа");
		//ЭлементОтбора.ВидСравнения  = ВидСравнения.Равно;
		//ЭлементОтбора.Использование = Истина;

		
		ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);

		ЗаполнитьОбщиеПараметрыПостроителяОтчета();

	КонецЕсли;

КонецПроцедуры // ЗаполнитьПостроительОтчетаПоЦенамНоменклатуры()

// Формирует и заполняет построитель отчета по регистру "ЦеныНоменклатурыКонтрагентов"
//
// Возвращаемое значение:
//   Текст запроса
//
Процедура ЗаполнитьПостроительОтчетаПоЦенамНоменклатурыКонтрагентов(ВключатьНезаполненные, ЗаполнятьТолькоТекстЗапроса) Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ //РАЗЛИЧНЫЕ
	|Тип.Ссылка                                                 КАК ТипЦен,
	|Ном.Ссылка                                                 КАК Номенклатура,
	|Ном.ЭтоГруппа                                              КАК ЭтоГруппа,
	|ХарактеристикиНоменклатуры.Ссылка                          КАК ХарактеристикаНоменклатуры,
	|Ном.Родитель                                               КАК Группа,
	|ВЫБОР
	|	КОГДА Ном.НаименованиеПолное ПОДОБНО &ПустаяСтрока 
	|	ТОГДА Ном.Наименование 
	|	ИНАЧЕ Ном.НаименованиеПолное КОНЕЦ                      КАК ПолноеНаименование,
	|ВЫБОР
	|	КОГДА &ДопКолонка = &Артикул
	|		ТОГДА Ном.Артикул
	|	КОГДА &ДопКолонка = &Код
	|		ТОГДА Ном.Код
	|	ИНАЧЕ
	|		NULL
	|	КОНЕЦ                                                   КАК Артикул,
	|Рег.ЕдиницаИзмерения                                       КАК ЕдиницаИзмерения,
	|Рег.Валюта,
	|NULL                                                       КАК ПроцентСкидкиНаценки,
	|Рег.Цена                                                   КАК Цена
	|
	|{ВЫБРАТЬ
	|	Тип.Владелец.*                                          КАК Контрагент,
	|	Тип.Ссылка.*                                            КАК ТипЦен,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа
	|	//СВОЙСТВА
	|}
	|
	|ИЗ
	|	Справочник.Номенклатура КАК Ном
	|	//СОЕДИНЕНИЯ
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ТипыЦенНоменклатурыКонтрагентов КАК Тип
	|ПО 
	|	ИСТИНА
	|
	|СОЕДИНЕНИЕ
	|	(ВЫБРАТЬ
	|		Характеристики.Ссылка   КАК Ссылка,
	|		Характеристики.Владелец КАК Владелец
	|	ИЗ
	|		Справочник.ХарактеристикиНоменклатуры КАК Характеристики
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		&ПустаяХарактеристикаНоменклатуры КАК Ссылка,
	|		Номенклатура.Ссылка               КАК Владелец
	|	ИЗ
	|		Справочник.Номенклатура КАК Номенклатура
	|
	|	) КАК ХарактеристикиНоменклатуры
	|ПО 
	|	ХарактеристикиНоменклатуры.Владелец = Ном.Ссылка
	|
	|	ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(&ДатаЦенСкидок, ) КАК Рег  
	|ПО
	|	Тип.Ссылка = Рег.ТипЦен
	|	И
	|	Ном.Ссылка = Рег.Номенклатура 
	|	И
	|	Рег.ХарактеристикаНоменклатуры = ХарактеристикиНоменклатуры.Ссылка
	|
	|ГДЕ
	|	НЕ Ном.Набор
	|	И НЕ Тип.ТипЦеныНоменклатуры = &ПустойТипЦен
	|";

	Если Не ВключатьНезаполненные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	Ном.Ссылка В (Выбрать Номенклатура ИЗ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(&ДатаЦенСкидок,))
		|	И
		|	ХарактеристикиНоменклатуры.Ссылка В (Выбрать ХарактеристикаНоменклатуры ИЗ РегистрСведений.ЦеныНоменклатурыКонтрагентов.СрезПоследних(&ДатаЦенСкидок,))
		|";
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
	|{ГДЕ
	|	Тип.Владелец.*                                          КАК Контрагент,
	|	Тип.Ссылка.*                                            КАК ТипЦен,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры,
	|	ТипЦен
	|	//СВОЙСТВА
	|
	|ИТОГИ ПО 
	|	Номенклатура ТОЛЬКО ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ
	|";

	ПостроительОтчета.Текст = ТекстЗапроса;
	ПостроительОтчета.Параметры.Вставить("ПустойТипЦен", Справочники.ТипыЦенНоменклатуры.ПустаяСсылка());

	Если Не ЗаполнятьТолькоТекстЗапроса Тогда

		// Соответствие имен полей в запросе и их представлений в отчете
		СтруктураПредставлениеПолей = Новый Структура(
		"	ТипЦен, 
		|	Номенклатура",
		"Тип цен",
		"Номенклатура");

		ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);

		// отборы по умолчанию
		Пока ПостроительОтчета.Отбор.Количество() > 0 Цикл
			ПостроительОтчета.Отбор.Удалить(0);
		КонецЦикла;

		МассивОтбора = Новый Массив;
		Если мКонтрагент = Неопределено Тогда
			МассивОтбора.Добавить("Контрагент");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("Контрагент",, "Контрагент");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.Равно;
			ЭлементОтбора.Значение      = мКонтрагент;
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		Если ТипыЦенСкидок.Количество() = 0 Тогда
			МассивОтбора.Добавить("ТипЦен");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("ТипЦен",, "Тип цен");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение.ЗагрузитьЗначения(ТипыЦенСкидок.ВыгрузитьКолонку("ТипЦенСкидок"));
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		Если мСписокНоменклатуры = Неопределено Тогда
			МассивОтбора.Добавить("Номенклатура");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("Номенклатура",, "Номенклатура");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение      = мСписокНоменклатуры;
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);

		ЗаполнитьОбщиеПараметрыПостроителяОтчета();

	КонецЕсли;

КонецПроцедуры // ЗаполнитьПостроительОтчетаПоЦенамНоменклатурыКонтрагентов()

// Формирует и заполняет построитель отчета по регистру "СкидкиНаценкиНоменклатуры"
//
// Возвращаемое значение:
//   Текст запроса
//
Процедура ЗаполнитьПостроительОтчетаПоСкидкамНаценкамНоменклатуры(ВключатьНезаполненные, ЗаполнятьТолькоТекстЗапроса) Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ //РАЗЛИЧНЫЕ
	|Тип.Ссылка                                                 КАК ТипСкидокНаценок,
	|Ном.Ссылка                                                 КАК Номенклатура,
	|Ном.ЭтоГруппа                                              КАК ЭтоГруппа,
	|ХарактеристикиНоменклатуры.Ссылка                          КАК ХарактеристикаНоменклатуры,
	|Ном.Родитель                                               КАК Группа,
	|ВЫБОР
	|	КОГДА Ном.НаименованиеПолное ПОДОБНО &ПустаяСтрока 
	|	ТОГДА Ном.Наименование 
	|	ИНАЧЕ Ном.НаименованиеПолное КОНЕЦ                      КАК ПолноеНаименование,
	|ВЫБОР
	|	КОГДА &ДопКолонка = &Артикул
	|		ТОГДА Ном.Артикул
	|	КОГДА &ДопКолонка = &Код
	|		ТОГДА Ном.Код
	|	ИНАЧЕ
	|		NULL
	|	КОНЕЦ                                                   КАК Артикул,
	|Рег.ПроцентСкидкиНаценки                                   КАК ПроцентСкидкиНаценки
	|
	|{ВЫБРАТЬ
	|	Тип.Ссылка.*                                            КАК ТипСкидокНаценок,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа
	|	//СВОЙСТВА
	|}
	|
	|ИЗ
	|	Справочник.Номенклатура КАК Ном
	|	//СОЕДИНЕНИЯ
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ Справочник.ТипыСкидокНаценок КАК Тип
	|ПО 
	|	ИСТИНА
	|
	|СОЕДИНЕНИЕ
	|	(ВЫБРАТЬ
	|		Характеристики.Ссылка   КАК Ссылка,
	|		Характеристики.Владелец КАК Владелец
	|	ИЗ
	|		Справочник.ХарактеристикиНоменклатуры КАК Характеристики
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		&ПустаяХарактеристикаНоменклатуры КАК Ссылка,
	|		Номенклатура.Ссылка               КАК Владелец
	|	ИЗ
	|		Справочник.Номенклатура КАК Номенклатура
	|
	|	) КАК ХарактеристикиНоменклатуры
	|ПО 
	|	ХарактеристикиНоменклатуры.Владелец = Ном.Ссылка
	|
	|	ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.СкидкиНаценкиНоменклатуры.СрезПоследних(&ДатаЦенСкидок, ) КАК Рег  
	|ПО
	|	Тип.Ссылка = Рег.ТипСкидкиНаценки
	|	И
	|	Ном.Ссылка = Рег.Номенклатура 
	|	И
	|	Рег.ХарактеристикаНоменклатуры = ХарактеристикиНоменклатуры.Ссылка
	|
	|ГДЕ
	|	НЕ Ном.Набор
	|";

	Если Не ВключатьНезаполненные Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	Ном.Ссылка В (Выбрать Номенклатура ИЗ РегистрСведений.СкидкиНаценкиНоменклатуры.СрезПоследних(&ДатаЦенСкидок,))
		|	И
		|	ХарактеристикиНоменклатуры.Ссылка В (Выбрать ХарактеристикаНоменклатуры ИЗ РегистрСведений.СкидкиНаценкиНоменклатуры.СрезПоследних(&ДатаЦенСкидок,))
		|";
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
	|{ГДЕ
	|	Тип.Ссылка.*                                            КАК ТипСкидокНаценок,
	|	Ном.Ссылка.*                                            КАК Номенклатура,
	|	Ном.Родитель.*                                          КАК Группа
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|}
	|
	|УПОРЯДОЧИТЬ ПО 
	|	Номенклатура,
	|	ХарактеристикаНоменклатуры,
	|	ТипСкидокНаценок
	|	//СВОЙСТВА
	|
	|ИТОГИ ПО 
	|	Номенклатура ТОЛЬКО ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ
	|";

	ПостроительОтчета.Текст = ТекстЗапроса;

	Если Не ЗаполнятьТолькоТекстЗапроса Тогда

		// Соответствие имен полей в запросе и их представлений в отчете
		СтруктураПредставлениеПолей = Новый Структура(
		"	ТипСкидокНаценок, 
		|	Номенклатура",
		"Тип скидок/наценок",
		"Номенклатура");

		ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);

		// отборы по умолчанию
		Пока ПостроительОтчета.Отбор.Количество() > 0 Цикл
			ПостроительОтчета.Отбор.Удалить(0);
		КонецЦикла;

		МассивОтбора = Новый Массив;
		Если ТипыЦенСкидок.Количество() = 0 Тогда
			МассивОтбора.Добавить("ТипСкидокНаценок");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("ТипСкидокНаценок",, "Тип скидок/наценок");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение.ЗагрузитьЗначения(ТипыЦенСкидок.ВыгрузитьКолонку("ТипЦенСкидок"));
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		Если мСписокНоменклатуры = Неопределено Тогда
			МассивОтбора.Добавить("Номенклатура");
		Иначе
			ЭлементОтбора = ПостроительОтчета.Отбор.Добавить("Номенклатура",, "Номенклатура");
			ЭлементОтбора.ВидСравнения  = ВидСравнения.ВСписке;
			ЭлементОтбора.Значение      = мСписокНоменклатуры;
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
		ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);

		ЗаполнитьОбщиеПараметрыПостроителяОтчета();

	КонецЕсли;

КонецПроцедуры // ЗаполнитьПостроительОтчетаПоСкидкамНаценкамНоменклатуры()

мСписокНоменклатуры = Неопределено;
мКонтрагент         = Неопределено;