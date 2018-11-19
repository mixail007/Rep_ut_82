﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ВедомостьОстатковТоваровИнициализация();

КонецПроцедуры

Процедура ПриЗакрытии()

	СохранитьЗначение("НастройкаВнешниеОтчетыВедомостьОстатковТоваровВедомостьОстатковТоваров_002b63ec-13d1-4d73-958f-8d356bf0c607", ПостроительОтчетаВедомостьОстатковТоваров.ПолучитьНастройки());

КонецПроцедуры

Процедура ДействияФормыВедомостьОстатковТоваровНастройка(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА(ВедомостьОстатковТоваров)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Форма = ВнешнийОтчетОбъект.ПолучитьФорму("ВедомостьОстатковТоваровНастройка");
	Форма.ПостроительОтчета = ПостроительОтчетаВедомостьОстатковТоваров;
	Настройка = ПостроительОтчетаВедомостьОстатковТоваров.ПолучитьНастройки();
	Если Форма.ОткрытьМодально() = Истина Тогда
		ВедомостьОстатковТоваровВывести();
	Иначе
		ПостроительОтчетаВедомостьОстатковТоваров.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА
КонецПроцедуры

Процедура ДействияФормыВедомостьОстатковТоваровСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(ВедомостьОстатковТоваров)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ВедомостьОстатковТоваровВывести();

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура ВедомостьОстатковТоваровВывести()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ(ВедомостьОстатковТоваров)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ЭлементыФормы.ПолеТабличногоДокумента.Очистить();

	ПостроительОтчетаВедомостьОстатковТоваров.Параметры.Вставить("Период", КонецДня(Период));
	ПостроительОтчетаВедомостьОстатковТоваров.Параметры.Вставить("Склад", Склад);

	ПостроительОтчетаВедомостьОстатковТоваров.Выполнить();
	ПостроительОтчетаВедомостьОстатковТоваров.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Вместе;
	ПостроительОтчетаВедомостьОстатковТоваров.РазмещениеРеквизитовИзмеренийВСтроках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаВедомостьОстатковТоваров.РазмещениеРеквизитовИзмеренийВКолонках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаВедомостьОстатковТоваров.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.БезОформления);
	ПостроительОтчетаВедомостьОстатковТоваров.Макет = ВнешнийОтчетОбъект.ПолучитьМакет("ВедомостьОстатковТоваров");
	ПостроительОтчетаВедомостьОстатковТоваров.Макет.Параметры.Склад = Склад;
	ПостроительОтчетаВедомостьОстатковТоваров.Макет.Параметры.Период = Лев(Период, 10);
	ПостроительОтчетаВедомостьОстатковТоваров.ОформитьМакет();
	ПостроительОтчетаВедомостьОстатковТоваров.Вывести(ЭлементыФормы.ПолеТабличногоДокумента);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ
КонецПроцедуры

Процедура ВедомостьОстатковТоваровИнициализация()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ(ВедомостьОстатковТоваров)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ПостроительОтчетаВедомостьОстатковТоваров.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Склад КАК Склад,
	|	ПРЕДСТАВЛЕНИЕ(ТоварыНаСкладахОстатки.Склад),
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(ТоварыНаСкладахОстатки.Номенклатура),
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(
	|			&Период,
	|			(НЕ Склад.ЗапретитьИспользование)
	|				И (НЕ Склад.Транзитный)
	|				И Склад = &Склад) КАК ТоварыНаСкладахОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склад,
	|	Номенклатура
	|ИТОГИ
	|	СУММА(КоличествоОстаток)
	|ПО
	|	ОБЩИЕ,
	|	Склад ИЕРАРХИЯ,
	|	Номенклатура ИЕРАРХИЯ
	|АВТОУПОРЯДОЧИВАНИЕ";
	ПостроительОтчетаВедомостьОстатковТоваров.ЗаполнитьНастройки();
	ПостроительОтчетаВедомостьОстатковТоваров.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаВедомостьОстатковТоваров.ТекстЗаголовка = "Ведомость остатков товаров по складу " + Склад + " на конец дня";
	Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыВедомостьОстатковТоваровВедомостьОстатковТоваров_002b63ec-13d1-4d73-958f-8d356bf0c607");
	Если Настройка <> Неопределено Тогда
		ПостроительОтчетаВедомостьОстатковТоваров.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры












