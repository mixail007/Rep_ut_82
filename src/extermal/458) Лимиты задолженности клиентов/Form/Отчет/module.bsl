﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ОтчетИнициализация();
	Менеджер.Очистить();
	
	///Менеджер = новый СписокЗначений;
 	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ИспользоватьМеханизмДележкиДляГруппы")
		и не ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОтображатьТолькоСобственныеЗаказы") тогда
		
		гр = ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь,"ГруппаПользователейДляРаспределенияЗаказов");
		 Для каждого эл из гр.ПользователиГруппы цикл
		 	Менеджер.Добавить( эл.Пользователь );
		 КонецЦикла;
		
	Иначе //филиалы...
		 
		 
		// только себя
	   Менеджер.Добавить(глТекущийПользователь);
	КонецЕсли;	

	ДатаСреза = ТекущаяДата();
	
КонецПроцедуры

Процедура ПриЗакрытии()

	СохранитьЗначение("НастройкаВнешниеОтчетыЛимитЗадолженностиКлиентовОтчет_f9e35454-4ed8-4a64-a5d2-85548831716f", ПостроительОтчетаОтчет.ПолучитьНастройки());

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

	ПостроительОтчетаОтчет.Параметры.Вставить("ДатаСреза", ДатаСреза);
	ПостроительОтчетаОтчет.Параметры.Вставить("Менеджер", Менеджер);

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
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента) КАК Менеджер,
	|	ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец) КАК Контрагент,
	|	СУММА(ЕСТЬNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток, 0)) КАК СуммаВзаиморасчетов,
	|	СУММА(ЕСТЬNULL(ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток, 0)) КАК СуммаЗаказов,
	|	МАКСИМУМ(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности)) - СУММА(ЕСТЬNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток, 0) + ЕСТЬNULL(ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток, 0)) КАК Остаток,
	|	МАКСИМУМ(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности)) КАК Лимит
	|{ВЫБРАТЬ
	|	Контрагент.*,
	|	СуммаВзаиморасчетов,
	|	СуммаЗаказов,
	|	Лимит,
	|	Остаток}
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	|			&ДатаСреза,
	|			ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента В (&Менеджер)
	|				И ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки(
	|				&ДатаСреза,
	|				ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента В (&Менеджер)
	|					И ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|					И ЗаказПокупателя.Проверен) КАК ЗаказыПокупателейОстатки
	|		ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец = ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец
	|			И ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец = ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец
	|{ГДЕ
	|	(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец)).* КАК Контрагент,
	|	(ЕСТЬNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток, 0)) КАК СуммаВзаиморасчетов,
	|	(ЕСТЬNULL(ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток, 0)) КАК СуммаЗаказов,
	|	(МАКСИМУМ(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности)) - СУММА(ЕСТЬNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток, 0) + ЕСТЬNULL(ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток, 0))) КАК Остаток,
	|	(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ДопустимаяСуммаЗадолженности)) КАК Лимит,
	|	(ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента)).* КАК Менеджер}
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец),
	|	ЕСТЬNULL(ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента, ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента)
	|{УПОРЯДОЧИТЬ ПО
	|	Менеджер.*,
	|	Контрагент.*}
	|{ИТОГИ ПО
	|	Менеджер.*,
	|	Контрагент.*}";
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет";
	//Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыЛимитЗадолженностиКлиентовОтчет_f9e35454-4ed8-4a64-a5d2-85548831716f");
	//Если Настройка <> Неопределено Тогда
	//	ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	//КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры




