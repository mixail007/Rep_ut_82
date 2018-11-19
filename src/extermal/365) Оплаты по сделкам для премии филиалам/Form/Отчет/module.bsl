﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ОтчетИнициализация();

КонецПроцедуры

Процедура ПриЗакрытии()

	СохранитьЗначение("НастройкаВнешниеОтчетыОплатыПоФилиаламДляПремийОтчет_7cf81aeb-a8c3-4ab2-998d-1572211b833c", ПостроительОтчетаОтчет.ПолучитьНастройки());

КонецПроцедуры





Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(ДатаНач, ?(ДатаКон='0001-01-01', ДатаКон, КонецДня(ДатаКон)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		ДатаНач = НастройкаПериода.ПолучитьДатуНачала();
		ДатаКон = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
	
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

	ПостроительОтчетаОтчет.Параметры.Вставить("ДатаСменыФормулыРасчета", '20150101000000');
	ПостроительОтчетаОтчет.Параметры.Вставить("КонДата", КонецДня(ДатаКон));
	ПостроительОтчетаОтчет.Параметры.Вставить("НачДата", ДатаНач);
	ПостроительОтчетаОтчет.Параметры.Вставить("СписокНаправленийПродаж", СписокНаправленийПродаж);

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
	|	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента.ОтветственноеЛицо КАК Менеджер,
	|	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Сделка,
	|	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовРасход КАК Оплата,
	|	ПродажиОбороты.СтоимостьОборот - ПродажиСебестоимостьОбороты.СтоимостьОборот КАК ВаловаяПрибыль,
	|	ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(
	|			&НачДата,
	|			&КонДата,
	|			,
	|			,
	|			ДоговорКонтрагента.ОтветственноеЛицо.НаправлениеПродаж В (&СписокНаправленийПродаж)
	|				И (ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|					ИЛИ ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|				И НЕ ДоговорКонтрагента.ТипДоговора = ЗНАЧЕНИЕ(Справочник.ТипыДоговоров.ВозмещаемыеУслуги)
	|				И ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.Позаказам)) КАК ВзаиморасчетыСКонтрагентамиОстаткиИОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Продажи.Обороты(, , , ) КАК ПродажиОбороты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажиСебестоимость.Обороты(, , , ) КАК ПродажиСебестоимостьОбороты
	|			ПО ПродажиОбороты.ЗаказПокупателя = ПродажиСебестоимостьОбороты.ЗаказПокупателя
	|		ПО ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Сделка = ПродажиОбороты.ЗаказПокупателя
	|			И ВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента = ПродажиОбороты.ДоговорКонтрагента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Менеджер
	|ИТОГИ
	|	СУММА(Оплата),
	|	СУММА(ВаловаяПрибыль)
	|ПО
	|	Менеджер
	|АВТОУПОРЯДОЧИВАНИЕ";
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет";
	Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыОплатыПоФилиаламДляПремийОтчет_7cf81aeb-a8c3-4ab2-998d-1572211b833c");
	Если Настройка <> Неопределено Тогда
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры
