﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ОтчетИнициализация();

КонецПроцедуры

Процедура ПриЗакрытии()

	СохранитьЗначение("НастройкаВнешниеОтчетыОтчетПоДоговорамОтчет_a756c365-2dc4-4620-b856-d17193d8e4b7", ПостроительОтчетаОтчет.ПолучитьНастройки());

КонецПроцедуры

Процедура ДействияФормыОтчетНастройка(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Форма = ВнешнийОтчетОбъект.ПолучитьФорму("ОтчетНастройка");
	Форма.ПостроительОтчета = ПостроительОтчетаОтчет;
	Настройка = ПостроительОтчетаОтчет.ПолучитьНастройки();
	Если Форма.ОткрытьМодально() = Истина Тогда
		ОтчетВывести();
	Иначе
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА
КонецПроцедуры

Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ОтчетВывести();

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура ОтчетВывести()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ЭлементыФормы.ПолеТабличногоДокумента.Очистить();

	ПостроительОтчетаОтчет.Параметры.Вставить("ВедениеВзаиморасчетов", перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
	ПостроительОтчетаОтчет.Параметры.Вставить("ВидДоговора", перечисления.ВидыДоговоровКонтрагентов.СПокупателем);

	ПостроительОтчетаОтчет.Выполнить();
	ПостроительОтчетаОтчет.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Вместе;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВСтроках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВКолонках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.Классика);
	ПостроительОтчетаОтчет.Вывести(ЭлементыФормы.ПолеТабличногоДокумента);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ
КонецПроцедуры

Процедура ОтчетИнициализация()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ПостроительОтчетаОтчет.Текст =
	"ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.Код КАК КодПокупателя,
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Покупатель,
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Код КАК КодДоговора,
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК СуммаДолга,
	|	БумажныеДоговорыСрезПоследних.Период КАК Дата,
	|	БумажныеДоговорыСрезПоследних.Номер,
	|	БумажныеДоговорыСрезПоследних.ДатаОкончанияДействия,
	|	БумажныеДоговорыСрезПоследних.Состояние,
	|	БумажныеДоговорыСрезПоследних.ЕстьДоговорПоручительства,
	|	БумажныеДоговорыСрезПоследних.ЕстьКопииПравоустанавливающихДокументов,
	|	БумажныеДоговорыСрезПоследних.ДопустимоеЧислоДнейЗадолженности
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	|			,
	|			ДоговорКонтрагента.Владелец.Покупатель
	|				И ДоговорКонтрагента.ВидДоговора = &ВидДоговора
	|				И ДоговорКонтрагента.ВедениеВзаиморасчетов = &ВедениеВзаиморасчетов) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.БумажныеДоговоры.СрезПоследних КАК БумажныеДоговорыСрезПоследних
	|		ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец = БумажныеДоговорыСрезПоследних.Контрагент
	|			И ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Дата = БумажныеДоговорыСрезПоследних.Период
	|			И ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Номер = БумажныеДоговорыСрезПоследних.Номер
	|ГДЕ
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток > 0";
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет";
	Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыОтчетПоДоговорамОтчет_a756c365-2dc4-4620-b856-d17193d8e4b7");
	Если Настройка <> Неопределено Тогда
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры
