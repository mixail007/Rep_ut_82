﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщегние.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, Отказ, Заголовок) Экспорт
	
	Если мТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	ИмяТаблицы          = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	ЕстьСерия           = ЕстьРеквизитТабЧастиДокумента("СерияНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьХарактеристика  = ЕстьРеквизитТабЧастиДокумента("ХарактеристикаНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьКоэффициент     = ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти);

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + ИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";


	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",     СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", СтруктураШапкиДокумента.ДоговорКонтрагента); 
	Если СтруктураШапкиДокумента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом 
	 ИЛИ (СтруктураШапкиДокумента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам 
	      И ИмяТабличнойЧасти = "ВозвратнаяТара")Тогда
		Запрос.УстановитьПараметр("Сделка", Неопределено); 
	Иначе
		Запрос.УстановитьПараметр("Сделка", СтруктураШапкиДокумента.Сделка);
	КонецЕсли;
	Запрос.УстановитьПараметр("СтатусПолучения",    мТаблицаДвижений[0].СтатусПолучения);

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры.Представление           КАК ХарактеристикаНоменклатурыПредставление,"
	,"") 
	+ ?(ЕстьКоэффициент, "
	|	СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК ДокументКоличество,", "
	|	СУММА(Док.Количество)                                  КАК ДокументКоличество,") + "
	|	МАКСИМУМ(Остатки.КоличествоОстаток)                    КАК ОстатокКоличество
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПолученные.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|	И Сделка                = &Сделка
	|	И СтатусПолучения        = &СтатусПолучения
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры"
	,"") + "
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	|	, Док.ХарактеристикаНоменклатуры "
	,"") + "
	|
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыПолученные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		КоличествоНаСкладе = ?(Выборка.ОстатокКоличество = NULL, 0, Выборка.ОстатокКоличество);

		Если КоличествоНаСкладе < Выборка.ДокументКоличество Тогда

			СтрокаСообщения = "Остатка " + 
			ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатурыПредставление, "")) +
			" полученного по договору """ + СокрЛП(СтруктураШапкиДокумента.ДоговорКонтрагента) + ?(ЗначениеНеЗаполнено(СтруктураШапкиДокумента.Сделка), "",
			" и по сделке " + СокрЛП(СтруктураШапкиДокумента.Сделка)) +
			""" недостаточно.";

			ОшибкаНетОстатка(СтрокаСообщения, КоличествоНаСкладе, Выборка.ДокументКоличество,
			Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

// Процедура контролирует лимиты возвратной тары, передаваемой покупателю по переданному документу
// и его табличной части. В случае превышения лимита выставляется флаг отказа и 
// выдается сообщегние.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольЛимитовВозвратнойТары(ДокументОбъект, СтруктураШапкиДокумента, Отказ, Заголовок) Экспорт

	ИмяТабличнойЧасти  = "ВозвратнаяТара";
	ИмяДокумента       = ДокументОбъект.Метаданные().Имя;
	ИмяТаблицы         = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);

	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + ИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";


	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",          СтруктураШапкиДокумента.Ссылка);
	
	Запрос.УстановитьПараметр("ДоговорКонтрагента",   СтруктураШапкиДокумента.ДоговорКонтрагента); 
	
	Запрос.УстановитьПараметр("СтатусПолучения",         Перечисления.СтатусыПолученияПередачиТоваров.ВозвратнаяТара);

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,
	|	СУММА(Док.Количество)                                  КАК ДокументКоличество, 
	|	МАКСИМУМ(Остатки.КоличествоОстаток)                    КАК ОстатокКоличество,
	|	МИНИМУМ(Лимиты.ЛимитПоставщика)                        КАК Лимит 
	|   
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПолученные.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|	И СтатусПолучения       = &СтатусПолучения
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура        = Остатки.Номенклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЛимитыВозвратнойТары.СрезПоследних(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ДоговорКонтрагента = &ДоговорКонтрагента
	|	) КАК Лимиты
	|ПО 
	|	Док.Номенклатура                = Лимиты.Номенклатура
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|	И НЕ Лимиты.ЛимитПоставщика ЕСТЬ NULL
	|	И Лимиты.ЛимитПоставщика > 0
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура
	|
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ТоварыПолученные.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		КоличествоОстаток = ?(Выборка.ОстатокКоличество = NULL, 0, Выборка.ОстатокКоличество);

		Если (КоличествоОстаток + Выборка.ДокументКоличество) > Выборка.Лимит Тогда

			СтрокаСообщения = "По " + 
			ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, "", "") +
			" по договору """ + СокрЛП(СтруктураШапкиДокумента.ДоговорКонтрагента) + """ превышен лимит возвратной тары.";

			
			СообщитьОбОшибке(СтрокаСообщения + Символы.ПС + Символы.Таб +
							   "Лимит " + (Выборка.Лимит) + " " + Выборка.ЕдиницаХраненияОстатковПредставление +
							   "; Получено ранее " + КоличествоОстаток + " " + Выборка.ЕдиницаХраненияОстатковПредставление +
							   "; Заказано " + Выборка.ДокументКоличество + " " + Выборка.ЕдиницаХраненияОстатковПредставление, Ложь);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // КонтрольЛимитовВозвратнойТары()


Процедура ПередЗаписью(Отказ, Замещение)
		
	ПроверкаПериодаЗаписей(ЭтотОбъект, Отказ);
	
КонецПроцедуры