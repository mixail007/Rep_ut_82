﻿Перем мВалютаРегламентированногоУчета Экспорт;

//БАЛАНС (04.12.2007)                       
//
Перем мПроведениеИзФормы Экспорт; 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ДокументОснование");

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

#Если Клиент Тогда

// Финкция возвращает пустую таблицу значений под
// табличную часть документа основания.
// 
Функция ИнициализацияТаблицыСтрок()

	Товары = Новый ТаблицаЗначений();

	Товары.Колонки.Добавить("Товар");
	Товары.Колонки.Добавить("ТоварНаименование");
	Товары.Колонки.Добавить("СтранаПроисхождения");
	Товары.Колонки.Добавить("ПредставлениеСтраны");
	Товары.Колонки.Добавить("НомерГТД");
	Товары.Колонки.Добавить("ПредставлениеГТД");
	Товары.Колонки.Добавить("Количество");
	Товары.Колонки.Добавить("ЕдиницаИзмерения");
	Товары.Колонки.Добавить("Цена");
	Товары.Колонки.Добавить("СтавкаНДС");
	Товары.Колонки.Добавить("СуммаНДС");
	Товары.Колонки.Добавить("СтавкаНП");
	Товары.Колонки.Добавить("Сумма");

	Возврат Товары;

КонецФункции

// Функция собирает данные по документу основанию ОтчетКомиссионераОПродажах и 
// возвращает типизированную структуру с данными
// 
Функция СобратьДанныеПоОтчетОПродажахКомиссионера()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ",  ЭтотОбъект.ДокументОснование.Ссылка);
	Запрос.УстановитьПараметр("Курс",      ЭтотОбъект.ДокументОснование.КурсВзаиморасчетов);
	Запрос.УстановитьПараметр("Кратность", ЭтотОбъект.ДокументОснование.КратностьВзаиморасчетов);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Организация,
	|	Организация   КАК Покупатель,
	|	Организация   КАК Грузополучатель,
	|	Контрагент    КАК Поставщик,
	|	Контрагент    КАК Грузоотправитель,
	|	СуммаДокумента          КАК Сумма,
	|	СтавкаНДСВознаграждения КАК СтавкаНДС,
	|	ВалютаДокумента         КАК Валюта,
	|	СуммаВключаетНДС,
	|	УчитыватьНДС,
	|	Товары.(
	|		СУММА(СуммаВознаграждения) КАК Сумма
	|	)
	|ИЗ
	|	Документ.ОтчетКомиссионераОПродажах КАК ОтчетКомиссионераОПродажах
	|
	|ГДЕ
	|	ОтчетКомиссионераОПродажах.Ссылка = &Документ";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
	
	ДанныеДляПечати = Новый Структура();
	ДанныеДляПечати.Вставить("Организация",      Шапка.Организация);
	ДанныеДляПечати.Вставить("Номер",            НомерВходящегоДокумента);
	ДанныеДляПечати.Вставить("Дата",             ДатаВходящегоДокумента);
	ДанныеДляПечати.Вставить("Поставщик",        Шапка.Поставщик);
	ДанныеДляПечати.Вставить("Грузоотправитель", Шапка.Грузоотправитель);
	ДанныеДляПечати.Вставить("Покупатель",       Шапка.Покупатель);
	ДанныеДляПечати.Вставить("Грузополучатель",  Шапка.Грузополучатель);
	ДанныеДляПечати.Вставить("Сумма",            Шапка.Сумма);
	ДанныеДляПечати.Вставить("Валюта",           Шапка.Валюта);
	ДанныеДляПечати.Вставить("УчитыватьНДС",     Истина);
	ДанныеДляПечати.Вставить("СуммаВключаетНДС", Истина);
	ДанныеДляПечати.Вставить("ФИОРуководителя",       );
	ДанныеДляПечати.Вставить("ФИОГлавногоБухгалтера", );

	Товары = ИнициализацияТаблицыСтрок();

	Пока ВыборкаСтрокТовары.Следующий() Цикл
		Строчка = Товары.Добавить();
		Строчка.Товар               = "Комиссионное вознаграждение";
		Строчка.ТоварНаименование   = "Комиссионное вознаграждение";
		Строчка.СтранаПроисхождения = "";
		Строчка.ПредставлениеСтраны = "";
		Строчка.НомерГТД            = "";
		Строчка.ПредставлениеГТД    = "";
		Строчка.Количество          = 1;
		Строчка.ЕдиницаИзмерения    = "";
		Строчка.СтавкаНДС           = Шапка.СтавкаНДС;
		СуммаНДС                    = РассчитатьСуммуНДС(ВыборкаСтрокТовары.Сумма, Шапка.УчитыватьНДС, Шапка.СуммаВключаетНДС, ПолучитьСтавкуНДС(Шапка.СтавкаНДС));
		Строчка.СуммаНДС            = СуммаНДС;
		Строчка.Сумма               = ВыборкаСтрокТовары.Сумма + ?(Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		Строчка.Цена                = ВыборкаСтрокТовары.Сумма - СуммаНДС;
	КонецЦикла;

	ДанныеДляПечати.Вставить("ТабличнаяЧасть", Товары);

	Возврат ДанныеДляПечати;

КонецФункции // СобратьДанныеПоОтчетОПродажахКомиссионера()

// Функция собирает данные по документу основанию Поступление и 
// структуру с данными
// 
Функция СобратьДанныеПоПоступлениюТоваров()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ЭтотОбъект.ДокументОснование.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организация,
	|	Организация           КАК Покупатель,
	|	Организация           КАК Грузополучатель,
	|	Контрагент            КАК Поставщик,
	|	Контрагент            КАК Грузоотправитель,
	|	СуммаДокумента        КАК Сумма,
	|	ВалютаДокумента       КАК Валюта,
	|	УчитыватьНДС          КАК УчитыватьНДС,
	|	СуммаВключаетНДС      КАК СуммаВключаетНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|
	|ГДЕ
	|	ПоступлениеТоваровУслуг.Ссылка = &ДокументОснование";

	ЗапросПоТоварам = Новый Запрос();
	ЗапросПоТоварам.УстановитьПараметр("Курс",            ЭтотОбъект.ДокументОснование.КурсВзаиморасчетов);
	ЗапросПоТоварам.УстановитьПараметр("Кратность",       ЭтотОбъект.ДокументОснование.КратностьВзаиморасчетов);
	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.ДокументОснование.Ссылка);
	ЗапросПоТоварам.Текст = "
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.НомерСтроки,
	|	ВложенныйЗапрос.Товар,
	|	ВложенныйЗапрос.Товар.НаименованиеПолное       КАК ТоварНаименование,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия,
	|	ВложенныйЗапрос.СтранаПроисхождения,
	|	ВложенныйЗапрос.СтранаПроисхождения.НаименованиеПолное КАК ПредставлениеСтраны,
	|	ВложенныйЗапрос.НомерГТД,
	|	ВложенныйЗапрос.НомерГТД.Представление         КАК ПредставлениеГТД,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Количество,
	|	ВложенныйЗапрос.Цена,
	|	ВложенныйЗапрос.Сумма,
	|	ВложенныйЗапрос.СуммаНДС,
	|	ВложенныйЗапрос.СтавкаНДС
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПоТоварам.НомерСтроки							КАК НомерСтроки,
	|		ТаблицаПоТоварам.Номенклатура							КАК Товар,
	|		ТаблицаПоТоварам.ХарактеристикаНоменклатуры             КАК Характеристика,
	|		ТаблицаПоТоварам.СерияНоменклатуры                      КАК Серия,
	|		ТаблицаПоТоварам.СерияНоменклатуры.СтранаПроисхождения  КАК СтранаПроисхождения,
	|		ТаблицаПоТоварам.СерияНоменклатуры.НомерГТД             КАК НомерГТД,
	|		ТаблицаПоТоварам.ЕдиницаИзмерения						КАК ЕдиницаИзмерения,
	|		СУММА(ТаблицаПоТоварам.Количество)   					КАК Количество,
	|		ТаблицаПоТоварам.Цена                КАК Цена,
	|		ТаблицаПоТоварам.Сумма               КАК Сумма,
	|		ТаблицаПоТоварам.СуммаНДС            КАК СуммаНДС,
	|		ТаблицаПоТоварам.СтавкаНДС           КАК СтавкаНДС
	|	ИЗ
	|		Документ.ПоступлениеТоваровУслуг.Товары КАК ТаблицаПоТоварам
	|	
	|	ГДЕ
	|		ТаблицаПоТоварам.Ссылка = &ТекущийДокумент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаПоТоварам.НомерСтроки,
	|		ТаблицаПоТоварам.Номенклатура,
	|		ТаблицаПоТоварам.ХарактеристикаНоменклатуры,
	|		ТаблицаПоТоварам.СерияНоменклатуры,
	|		ТаблицаПоТоварам.ЕдиницаИзмерения,
	|		ТаблицаПоТоварам.СтавкаНДС,
	|		ТаблицаПоТоварам.Цена,
	|		ТаблицаПоТоварам.СерияНоменклатуры.СтранаПроисхождения,
	|		ТаблицаПоТоварам.СерияНоменклатуры.НомерГТД,
	|		ТаблицаПоТоварам.Сумма,
	|		ТаблицаПоТоварам.СуммаНДС) КАК ВложенныйЗапрос

	|ОБЪЕДИНИТЬ ВСЕ

	|ВЫБРАТЬ
	|	ТаблицаПоУслугам.НомерСтроки,
	|	ТаблицаПоУслугам.Содержание,
	|	ТаблицаПоУслугам.Содержание,
	|	"""",
	|	"""",
	|	""Россия"",
	|	""Россия"",
	|	""--"",
	|	""--"",
	|	""шт"",
	|	ТаблицаПоУслугам.Количество,
	|	ТаблицаПоУслугам.Цена,
	|	ТаблицаПоУслугам.Сумма,
	|	ТаблицаПоУслугам.СуммаНДС,
	|	ТаблицаПоУслугам.СтавкаНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Услуги КАК ТаблицаПоУслугам

	|ГДЕ
	|	ТаблицаПоУслугам.Ссылка = &ТекущийДокумент";

	Шапка              = Запрос.Выполнить().Выбрать();
	ВыборкаСтрокТовары = ЗапросПоТоварам.Выполнить().Выбрать();

	Шапка.Следующий();
	ДанныеДляПечати = Новый Структура();
	ДанныеДляПечати.Вставить("Организация",      Шапка.Организация);
	ДанныеДляПечати.Вставить("Номер",            НомерВходящегоДокумента);
	ДанныеДляПечати.Вставить("Дата",             ДатаВходящегоДокумента);
	ДанныеДляПечати.Вставить("Поставщик",        Шапка.Поставщик);
	ДанныеДляПечати.Вставить("Грузоотправитель", Шапка.Грузоотправитель);
	ДанныеДляПечати.Вставить("Покупатель",       Шапка.Покупатель);
	ДанныеДляПечати.Вставить("Грузополучатель",  Шапка.Грузополучатель);
	ДанныеДляПечати.Вставить("Сумма",            Шапка.Сумма);
	ДанныеДляПечати.Вставить("Валюта",           Шапка.Валюта);
	ДанныеДляПечати.Вставить("УчитыватьНДС",     Шапка.УчитыватьНДС);
	ДанныеДляПечати.Вставить("СуммаВключаетНДС", Шапка.СуммаВключаетНДС);
	ДанныеДляПечати.Вставить("ФИОРуководителя",       );
	ДанныеДляПечати.Вставить("ФИОГлавногоБухгалтера", );

	Товары = ИнициализацияТаблицыСтрок();

	Пока ВыборкаСтрокТовары.Следующий() = 1 Цикл

		Строчка = Товары.Добавить();

		Если НЕ ЗначениеНеЗаполнено(ВыборкаСтрокТовары.Товар) Тогда
			Строчка.Товар               = ВыборкаСтрокТовары.Товар;
			Строчка.ТоварНаименование   = СокрЛП(ВыборкаСтрокТовары.ТоварНаименование) + ПредставлениеСерий(ВыборкаСтрокТовары);
		КонецЕсли;

		Строчка.СтранаПроисхождения = ВыборкаСтрокТовары.СтранаПроисхождения;
		Строчка.ПредставлениеСтраны = ?(ЗначениеНеЗаполнено(ВыборкаСтрокТовары.ПредставлениеСтраны), ВыборкаСтрокТовары.СтранаПроисхождения, ВыборкаСтрокТовары.ПредставлениеСтраны);
		Строчка.НомерГТД            = ВыборкаСтрокТовары.НомерГТД;
		Строчка.ПредставлениеГТД    = ВыборкаСтрокТовары.ПредставлениеГТД;
		Строчка.Количество          = ВыборкаСтрокТовары.Количество;
		Строчка.ЕдиницаИзмерения    = ВыборкаСтрокТовары.ЕдиницаИзмерения;
		Строчка.Цена                = ВыборкаСтрокТовары.Цена;
		Строчка.СтавкаНДС           = ВыборкаСтрокТовары.СтавкаНДС;
		Строчка.СуммаНДС            = ВыборкаСтрокТовары.СуммаНДС;
		Строчка.Сумма               = ВыборкаСтрокТовары.Сумма;

	КонецЦикла;

	ДанныеДляПечати.Вставить("ТабличнаяЧасть", Товары);

	Возврат ДанныеДляПечати;

КонецФункции // СобратьДанныеПоПоступлениюТоваров()

// Функция собирает данные по документу основанию Поступление товаров и услуг в НТТ 
// и возвращает структуру с данными
// 
Функция СобратьДанныеПоПоступлениюТоваровУслугВНТТ()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ЭтотОбъект.ДокументОснование.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Организация,
	|	Организация           КАК Покупатель,
	|	Организация           КАК Грузополучатель,
	|	Контрагент            КАК Поставщик,
	|	Контрагент            КАК Грузоотправитель,
	|	СуммаДокумента        КАК Сумма,
	|	ВалютаДокумента       КАК Валюта,
	|	УчитыватьНДС          КАК УчитыватьНДС,
	|	СуммаВключаетНДС      КАК СуммаВключаетНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку КАК ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку
	|
	|ГДЕ
	|	ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку.Ссылка = &ДокументОснование";

	ЗапросПоТоварам = Новый Запрос();
	ЗапросПоТоварам.УстановитьПараметр("Курс",            ЭтотОбъект.ДокументОснование.КурсВзаиморасчетов);
	ЗапросПоТоварам.УстановитьПараметр("Кратность",       ЭтотОбъект.ДокументОснование.КратностьВзаиморасчетов);
	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.ДокументОснование.Ссылка);
	ЗапросПоТоварам.Текст = "
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.НомерСтроки,
	|	ВложенныйЗапрос.Товар,
	|	ВложенныйЗапрос.Товар.НаименованиеПолное       КАК ТоварНаименование,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия,
	|	ВложенныйЗапрос.СтранаПроисхождения,
	|	ВложенныйЗапрос.СтранаПроисхождения.НаименованиеПолное КАК ПредставлениеСтраны,
	|	ВложенныйЗапрос.НомерГТД,
	|	ВложенныйЗапрос.НомерГТД.Представление         КАК ПредставлениеГТД,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Количество,
	|	ВложенныйЗапрос.Цена,
	|	ВложенныйЗапрос.Сумма,
	|	ВложенныйЗапрос.СуммаНДС,
	|	ВложенныйЗапрос.СтавкаНДС
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПоТоварам.НомерСтроки							КАК НомерСтроки,
	|		ТаблицаПоТоварам.Номенклатура							КАК Товар,
	|		ТаблицаПоТоварам.ХарактеристикаНоменклатуры             КАК Характеристика,
	|		ТаблицаПоТоварам.СерияНоменклатуры                      КАК Серия,
	|		ТаблицаПоТоварам.СерияНоменклатуры.СтранаПроисхождения  КАК СтранаПроисхождения,
	|		ТаблицаПоТоварам.СерияНоменклатуры.НомерГТД             КАК НомерГТД,
	|		ТаблицаПоТоварам.ЕдиницаИзмерения						КАК ЕдиницаИзмерения,
	|		СУММА(ТаблицаПоТоварам.Количество)   					КАК Количество,
	|		ТаблицаПоТоварам.Цена                КАК Цена,
	|		ТаблицаПоТоварам.Сумма               КАК Сумма,
	|		ТаблицаПоТоварам.СуммаНДС            КАК СуммаНДС,
	|		ТаблицаПоТоварам.СтавкаНДС           КАК СтавкаНДС
	|	ИЗ
	|		Документ.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку.Товары КАК ТаблицаПоТоварам
	|	
	|	ГДЕ
	|		ТаблицаПоТоварам.Ссылка = &ТекущийДокумент
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТаблицаПоТоварам.НомерСтроки,
	|		ТаблицаПоТоварам.Номенклатура,
	|		ТаблицаПоТоварам.ХарактеристикаНоменклатуры,
	|		ТаблицаПоТоварам.СерияНоменклатуры,
	|		ТаблицаПоТоварам.ЕдиницаИзмерения,
	|		ТаблицаПоТоварам.СтавкаНДС,
	|		ТаблицаПоТоварам.Цена,
	|		ТаблицаПоТоварам.СерияНоменклатуры.СтранаПроисхождения,
	|		ТаблицаПоТоварам.СерияНоменклатуры.НомерГТД,
	|		ТаблицаПоТоварам.Сумма,
	|		ТаблицаПоТоварам.СуммаНДС) КАК ВложенныйЗапрос

	|ОБЪЕДИНИТЬ ВСЕ

	|ВЫБРАТЬ
	|	ТаблицаПоУслугам.НомерСтроки,
	|	ТаблицаПоУслугам.Содержание,
	|	ТаблицаПоУслугам.Содержание,
	|	"""",
	|	"""",
	|	""Россия"",
	|	""Россия"",
	|	""--"",
	|	""--"",
	|	""шт"",
	|	ТаблицаПоУслугам.Количество,
	|	ТаблицаПоУслугам.Цена,
	|	ТаблицаПоУслугам.Сумма,
	|	ТаблицаПоУслугам.СуммаНДС,
	|	ТаблицаПоУслугам.СтавкаНДС
	|ИЗ
	|	Документ.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку.Услуги КАК ТаблицаПоУслугам

	|ГДЕ
	|	ТаблицаПоУслугам.Ссылка = &ТекущийДокумент";

	Шапка              = Запрос.Выполнить().Выбрать();
	ВыборкаСтрокТовары = ЗапросПоТоварам.Выполнить().Выбрать();

	Шапка.Следующий();
	ДанныеДляПечати = Новый Структура();
	ДанныеДляПечати.Вставить("Организация",      Шапка.Организация);
	ДанныеДляПечати.Вставить("Номер",            НомерВходящегоДокумента);
	ДанныеДляПечати.Вставить("Дата",             ДатаВходящегоДокумента);
	ДанныеДляПечати.Вставить("Поставщик",        Шапка.Поставщик);
	ДанныеДляПечати.Вставить("Грузоотправитель", Шапка.Грузоотправитель);
	ДанныеДляПечати.Вставить("Покупатель",       Шапка.Покупатель);
	ДанныеДляПечати.Вставить("Грузополучатель",  Шапка.Грузополучатель);
	ДанныеДляПечати.Вставить("Сумма",            Шапка.Сумма);
	ДанныеДляПечати.Вставить("Валюта",           Шапка.Валюта);
	ДанныеДляПечати.Вставить("УчитыватьНДС",     Шапка.УчитыватьНДС);
	ДанныеДляПечати.Вставить("СуммаВключаетНДС", Шапка.СуммаВключаетНДС);
	ДанныеДляПечати.Вставить("ФИОРуководителя",       );
	ДанныеДляПечати.Вставить("ФИОГлавногоБухгалтера", );

	Товары = ИнициализацияТаблицыСтрок();

	Пока ВыборкаСтрокТовары.Следующий() = 1 Цикл

		Строчка = Товары.Добавить();

		Если НЕ ЗначениеНеЗаполнено(ВыборкаСтрокТовары.Товар) Тогда
			Строчка.Товар               = ВыборкаСтрокТовары.Товар;
			Строчка.ТоварНаименование   = СокрЛП(ВыборкаСтрокТовары.ТоварНаименование) + ПредставлениеСерий(ВыборкаСтрокТовары);
		КонецЕсли;

		Строчка.СтранаПроисхождения = ВыборкаСтрокТовары.СтранаПроисхождения;
		Строчка.ПредставлениеСтраны = ?(ЗначениеНеЗаполнено(ВыборкаСтрокТовары.ПредставлениеСтраны), ВыборкаСтрокТовары.СтранаПроисхождения, ВыборкаСтрокТовары.ПредставлениеСтраны);
		Строчка.НомерГТД            = ВыборкаСтрокТовары.НомерГТД;
		Строчка.ПредставлениеГТД    = ВыборкаСтрокТовары.ПредставлениеГТД;
		Строчка.Количество          = ВыборкаСтрокТовары.Количество;
		Строчка.ЕдиницаИзмерения    = ВыборкаСтрокТовары.ЕдиницаИзмерения;
		Строчка.Цена                = ВыборкаСтрокТовары.Цена;
		Строчка.СтавкаНДС           = ВыборкаСтрокТовары.СтавкаНДС;
		Строчка.СуммаНДС            = ВыборкаСтрокТовары.СуммаНДС;
		Строчка.Сумма               = ВыборкаСтрокТовары.Сумма;

	КонецЦикла;

	ДанныеДляПечати.Вставить("ТабличнаяЧасть", Товары);

	Возврат ДанныеДляПечати;

КонецФункции // СобратьДанныеПоПоступлениюТоваровУслугВНТТ()

// Функция собирает данные по документу основанию Поступление Доп. расходов и
// структуру с данными
// 
Функция СобратьДанныеДопРасходам()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ЭтотОбъект.ДокументОснование.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Организация,
	|	Организация      КАК Покупатель,
	|	Организация      КАК Грузополучатель,
	|	Контрагент       КАК Поставщик,
	|	Контрагент       КАК Грузоотправитель,
	|	Содержание       КАК СтатьяЗатрат,
	|	ВалютаДокумента  КАК Валюта,
	|	СуммаДокумента   КАК СуммаДокумента,
	|	СуммаНДС         КАК СуммаНДС,
	|	СтавкаНДС,
	|	УчитыватьНДС     КАК УчитыватьНДС,
	|	СуммаВключаетНДС КАК СуммаВключаетНДС,
	|	ВложенныйЗапрос.СуммаДенег
	|ИЗ
	|	(ВЫБРАТЬ
	|		СУММА(ПоступлениеДопРасходовТовары.Сумма) КАК СуммаДенег
	|
	|	ИЗ
	|		Документ.ПоступлениеДопРасходов.Товары КАК ПоступлениеДопРасходовТовары
	|
	|	ГДЕ
	|		Ссылка = &ДокументОснование) КАК ВложенныйЗапрос,
	|	Документ.ПоступлениеДопРасходов КАК ПоступлениеДопРасходов
	|
	|ГДЕ
	|	ПоступлениеДопРасходов.Ссылка = &ДокументОснование
	|";

	Шапка = Запрос.Выполнить().Выбрать();

	Шапка.Следующий();
	ДанныеДляПечати = Новый Структура();
	ДанныеДляПечати.Вставить("Организация",      Шапка.Организация);
	ДанныеДляПечати.Вставить("Номер",            НомерВходящегоДокумента);
	ДанныеДляПечати.Вставить("Дата",             ДатаВходящегоДокумента);
	ДанныеДляПечати.Вставить("Поставщик",        Шапка.Поставщик);
	ДанныеДляПечати.Вставить("Грузоотправитель", Шапка.Грузоотправитель);
	ДанныеДляПечати.Вставить("Покупатель",       Шапка.Покупатель);
	ДанныеДляПечати.Вставить("Грузополучатель",  Шапка.Грузополучатель);
	ДанныеДляПечати.Вставить("Сумма",            0);
	ДанныеДляПечати.Вставить("Валюта",           Шапка.Валюта);
	ДанныеДляПечати.Вставить("УчитыватьНДС",     Шапка.УчитыватьНДС);
	ДанныеДляПечати.Вставить("СуммаВключаетНДС", Шапка.СуммаВключаетНДС);
	ДанныеДляПечати.Вставить("ФИОРуководителя",       );
	ДанныеДляПечати.Вставить("ФИОГлавногоБухгалтера", );

	Товары = ИнициализацияТаблицыСтрок();

	Строчка = Товары.Добавить();
	Строчка.Товар               = Шапка.СтатьяЗатрат;
	Строчка.ТоварНаименование   = Шапка.СтатьяЗатрат;
	Строчка.СтранаПроисхождения = "";
	Строчка.ПредставлениеСтраны = "";
	Строчка.НомерГТД            = "";
	Строчка.ПредставлениеГТД    = "";
	Строчка.Количество          = 1;
	Строчка.ЕдиницаИзмерения    = "";
	СуммаДока         = Шапка.СуммаДокумента + 
	                    ?(Шапка.СуммаВключаетНДС, 0, Шапка.СуммаНДС);
	Строчка.СтавкаНДС = Шапка.СтавкаНДС;
	Строчка.СуммаНДС  = Шапка.СуммаНДС;
	Строчка.Сумма     = Шапка.СуммаДокумента;
	Строчка.Цена      = Шапка.СуммаДокумента;

	ДанныеДляПечати.Вставить("ТабличнаяЧасть", Товары);

	Возврат ДанныеДляПечати;

КонецФункции // СобратьДанныеДопРасходам()

// Проверяет правильность заполнения шапки документа.
// проставляет прочерки в незаполненных полях печатной формы счета-фактуры
//
Процедура ПроставитьПрочеркиВПустыеПоля(ОбластьМакета)

	Для т = 0 По ОбластьМакета.Параметры.Количество() - 1 Цикл
		
		ТекПараметр = ОбластьМакета.Параметры.Получить(т);
		
		Если (Найти(ТекПараметр, "Продавец:") <> 0)
		   и (СокрЛП(ТекПараметр) = "Продавец:") Тогда
			ОбластьМакета.Параметры.Установить(т, "Продавец: ----");
			
		ИначеЕсли (Найти(ТекПараметр, "Адрес:") <> 0)
			    и (СокрЛП(ТекПараметр) = "Адрес:") Тогда
			ОбластьМакета.Параметры.Установить(т, "Адрес: ----");
			
		ИначеЕсли (Найти(ТекПараметр, "Идентификационный номер продавца (ИНН):") <> 0)
			    и (СокрЛП(ТекПараметр) = "Идентификационный номер продавца (ИНН):") Тогда
			ОбластьМакета.Параметры.Установить(т, "Идентификационный номер продавца (ИНН): ----");
			
		ИначеЕсли (Найти(ТекПараметр, "Грузоотправитель и его адрес:") <> 0)
			    и (СокрЛП(ТекПараметр) = "Грузоотправитель и его адрес:") Тогда
			ОбластьМакета.Параметры.Установить(т, "Грузоотправитель и его адрес: ----");
			
		ИначеЕсли (Найти(ТекПараметр, "Грузополучатель и его адрес:") <> 0)
		   		и (СокрЛП(ТекПараметр) = "Грузополучатель и его адрес:") Тогда
			ОбластьМакета.Параметры.Установить(т, "Грузополучатель и его адрес: ----");
			
		ИначеЕсли (Найти(ТекПараметр, "К платежно-расчетному документу №") <> 0)
		   		и (СокрЛП(ТекПараметр) = "К платежно-расчетному документу №  от") Тогда
			ОбластьМакета.Параметры.Установить(т, "К платежно-расчетному документу № -- от --");
			
		ИначеЕсли (Найти(ТекПараметр, "Покупатель:") <> 0)
		   		и (СокрЛП(ТекПараметр) = "Покупатель:") Тогда
			ОбластьМакета.Параметры.Установить(т, "Покупатель: ----");
			
		ИначеЕсли (Найти(ТекПараметр, "Идентификационный номер покупателя (ИНН):") <> 0)
			    и (СокрЛП(ТекПараметр) = "Идентификационный номер покупателя (ИНН):") Тогда
			ОбластьМакета.Параметры.Установить(т, "Идентификационный номер покупателя (ИНН): ----");
			
		ИначеЕсли ЗначениеНеЗаполнено(ТекПараметр) Тогда
			ОбластьМакета.Параметры.Установить(т, "--");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПроставитьПрочеркиВПустыеПоля()

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьСчетаФактуры(ДанныеДляПечати)

	ТабДокумент = Новый ТабличныйДокумент;

	Если Дата < '20040216' Тогда
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетФактураПолученный_СчетФактура575";
		Макет = ПолучитьОбщийМакет("СчетФактура575");
	Иначе
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетФактураПолученный_СчетФактура84";
		Макет = ПолучитьОбщийМакет("СчетФактура84");
	КонецЕсли;

	Если ДанныеДляПечати.Покупатель = Null Тогда
		Сообщить("В документе основании не указано юр./физ. лицо у организации.");
		Возврат Неопределено;
	КонецЕсли;
	Если ДанныеДляПечати.Поставщик = Неопределено Тогда
		Сообщить("В документе основании не указано юр./физ. лицо контрагента.");
		Возврат Неопределено;
	КонецЕсли;

	СведенияОбПокупателе = СведенияОЮрФизЛице(ДанныеДляПечати.Покупатель, Дата);
	СведенияОПоставщике  = СведенияОЮрФизЛице(ДанныеДляПечати.Поставщик, Дата);

	// Выводим шапку накладной
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(ДанныеДляПечати);
	ОбластьМакета.Параметры.Номер = СформироватьЗаголовокДокумента(ДанныеДляПечати, "Счет-фактура");
	Если Дата < '20040216' Тогда
		ОбластьМакета.Параметры.ПредставлениеПоставщика       = "Продавец: "                                 + ОписаниеОрганизации(СведенияОПоставщике,  "ПолноеНаименование,");
		ОбластьМакета.Параметры.АдресПоставщика               = "Адрес: "                                    + ОписаниеОрганизации(СведенияОПоставщике,  "ЮридическийАдрес,");
		ОбластьМакета.Параметры.ИННпоставщика                 = "Идентификационный номер продавца (ИНН): "   + ОписаниеОрганизации(СведенияОПоставщике,  "ИНН,", Ложь); 
		ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = "Грузоотправитель и его адрес: "             + ОписаниеОрганизации(СведенияОПоставщике,  "ПолноеНаименование,ФактическийАдрес,");
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя  = "Грузополучатель и его адрес: "              + ОписаниеОрганизации(СведенияОбПокупателе, "ПолноеНаименование,ФактическийАдрес,");
		ОбластьМакета.Параметры.ПоДокументу                   = "К платежно-расчетному документу №  от: ";
		ОбластьМакета.Параметры.ПредставлениеПокупателя       = "Покупатель: "                               + ОписаниеОрганизации(СведенияОбПокупателе, "ПолноеНаименование,");
		ОбластьМакета.Параметры.АдресПокупателя               = "Адрес: "                                    + ОписаниеОрганизации(СведенияОбПокупателе, "ЮридическийАдрес,");
		ОбластьМакета.Параметры.ИННПокупателя                 = "Идентификационный номер покупателя (ИНН): " + ОписаниеОрганизации(СведенияОбПокупателе, "ИНН,", Ложь);
	Иначе
		ОбластьМакета.Параметры.ПредставлениеПоставщика       = "Продавец: "                               + ОписаниеОрганизации(СведенияОПоставщике,  "ПолноеНаименование,");
		ОбластьМакета.Параметры.АдресПоставщика               = "Адрес: "                                  + ОписаниеОрганизации(СведенияОПоставщике,  "ЮридическийАдрес,");
		КПП = ОписаниеОрганизации(СведенияОПоставщике, "КПП,", Ложь);
		Если НЕ ЗначениеНеЗаполнено(КПП) Тогда
			КПП = "/" + КПП;
		КонецЕсли;
		ОбластьМакета.Параметры.ИННпоставщика                 = "ИНН/КПП продавца: "                       + ОписаниеОрганизации(СведенияОПоставщике,  "ИНН,", Ложь) + КПП;
		ОбластьМакета.Параметры.ПредставлениеГрузоотправителя = "Грузоотправитель и его адрес: "           + ОписаниеОрганизации(СведенияОПоставщике,  "ПолноеНаименование,ФактическийАдрес,");
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя  = "Грузополучатель и его адрес: "            + ОписаниеОрганизации(СведенияОбПокупателе, "ПолноеНаименование,ФактическийАдрес,");
		ОбластьМакета.Параметры.ПоДокументу                   = "К платежно-расчетному документу №  от: ";
		ОбластьМакета.Параметры.ПредставлениеПокупателя       = "Покупатель: "                             + ОписаниеОрганизации(СведенияОбПокупателе, "ПолноеНаименование,");
		ОбластьМакета.Параметры.АдресПокупателя               = "Адрес: "                                  + ОписаниеОрганизации(СведенияОбПокупателе, "ЮридическийАдрес,");
		КПП = ОписаниеОрганизации(СведенияОбПокупателе, "КПП,", Ложь);
		Если НЕ ЗначениеНеЗаполнено(КПП) Тогда
			КПП = "/" + КПП;
		КонецЕсли;
		ОбластьМакета.Параметры.ИННПокупателя                 = "ИНН/КПП покупателя: "                     + ОписаниеОрганизации(СведенияОбПокупателе, "ИНН,", Ложь) + КПП;
	КонецЕсли;
	
	ПроставитьПрочеркиВПустыеПоля(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ОбластьМакета.Параметры.Заполнить(ДанныеДляПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Строка");

	ИтогоСуммаНДС = 0;
	ИтогоВсего    = 0;

	ВыборкаСтрокТовары = ДанныеДляПечати.ТабличнаяЧасть;

	Для Каждого Строчка Из ВыборкаСтрокТовары Цикл
		ОбластьМакета.Параметры.Заполнить(Строчка);

		Если Строка(Строчка.ПредставлениеСтраны) = "Россия" Тогда
			ОбластьМакета.Параметры.ПредставлениеСтраны  = " ---- ";
		КонецЕсли; 

		СуммаСНДС = Строчка.Сумма + ?(ДанныеДляПечати.СуммаВключаетНДС, 0, Строчка.СуммаНДС);

		Количество  = Строчка.Количество;
		СуммаНДС    = Строчка.СуммаНДС;
		СуммаБезНДС = СуммаСНДС - СуммаНДС;

		ОбластьМакета.Параметры.Количество = Количество;
		ОбластьМакета.Параметры.Цена       = ?(Количество = 0, 0, СуммаБезНДС / Количество);
		ОбластьМакета.Параметры.Стоимость  = СуммаБезНДС;
		ОбластьМакета.Параметры.СуммаНДС   = СуммаНДС;
		ОбластьМакета.Параметры.Всего      = СуммаСНДС;
		ОбластьМакета.Параметры.СтавкаНДС  = Строчка.СтавкаНДС;

		ИтогоСуммаНДС = ИтогоСуммаНДС + СуммаНДС;
		ИтогоВсего    = ИтогоВсего    + СуммаСНДС;
		
		ПроставитьПрочеркиВПустыеПоля(ОбластьМакета);
		ТабДокумент.Вывести(ОбластьМакета);

	КонецЦикла;

	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.ИтогоСуммаНДС = ИтогоСуммаНДС;
	ОбластьМакета.Параметры.ИтогоВсего    = ИтогоВСего;
	
	ПроставитьПрочеркиВПустыеПоля(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.Заполнить(ДанныеДляПечати);
	
	ПроставитьПрочеркиВПустыеПоля(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);

	ТабДокумент.ПолеСверху = 0;
	ТабДокумент.ПолеСлева  = 0;
	ТабДокумент.ПолеСнизу  = 0;
	ТабДокумент.ПолеСправа = 0;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаФактуры()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	КонецЕсли;

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяМакета = "СчетФактура" Тогда

		// Получить экземпляр документа на печать
		ТипОснования = ТипЗнч(ДокументОснование);

		Если НЕ ЗначениеНеЗаполнено(ДокументОснование) Тогда
			Если ТипОснования      = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
				ДанныеДляПечати    = СобратьДанныеПоПоступлениюТоваров();
			ИначеЕсли ТипОснования = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку") Тогда
				ДанныеДляПечати    = СобратьДанныеПоПоступлениюТоваровУслугВНТТ();
			ИначеЕсли ТипОснования = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
				ДанныеДляПечати    = СобратьДанныеПоОтчетОПродажахКомиссионера();
			ИначеЕсли ТипОснования = Тип("ДокументСсылка.ПоступлениеДопРасходов") Тогда
				ДанныеДляПечати    = СобратьДанныеДопРасходам();
			КонецЕсли;
				
		Иначе
			Предупреждение("Не выбран документ-основание для данного счета-фактуры!");
			Возврат;
		КонецЕсли;
			
		Если ТипЗнч(ДанныеДляПечати) = Тип("Соответствие") Тогда
			Возврат;
		ИначеЕсли ДанныеДляПечати = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ТабДокумент = ПечатьСчетаФактуры(ДанныеДляПечати);
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ДополнительныеПечатныеФормы") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
		ОбъектВнешнейФормы = ИмяМакета.ПолучитьОбъект();
		Если ОбъектВнешнейФормы = Неопределено Тогда
			Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяФайла);
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Ссылка;
		ТабДокумент = Обработка.Печать();
	
	КонецЕсли;

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СписокМакетов = Новый СписокЗначений;

	СписокМакетов.Добавить("СчетФактура", "Счет-фактура");

	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ФОРМИРОВАНИЯ ДВИЖЕНИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Дата = Основание.Дата;
	ЭтотОбъект.ДокументОснование = Основание.Ссылка;

КонецПроцедуры // ОбработкаЗаполнения()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если ДокументОснование.Метаданные().Имя = "АвансовыйОтчет" Тогда
		ДвиженияПоРегиструНДСПокупкиПоАвансовымОтчетам(СтруктураШапкиДокумента, Отказ, Заголовок);

	Иначе
		ДвиженияПоРегиструНДСПокупкиПоПрочимПоступлениям(СтруктураШапкиДокумента, Отказ, Заголовок);

	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам()

// Формирование движений по регистру НДСПокупки по прочим поступлениям.
// Процедура используется в тех случаях, когда документ основание счета фактуры
// это документ вида: "Авансовый отчет".
// В качестве исходных данных при проведении документа используются движения
// по регистру "НДСПокупки", сформированные при проведении документа основания.
//
Процедура ДвиженияПоРегиструНДСПокупкиПоАвансовымОтчетам(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = Движения.НДСПокупки.Выгрузить();
	ТаблицаДвижений.Очистить();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",   СтруктураШапкиДокумента.Организация);
	Запрос.УстановитьПараметр("ДокОснование",  СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("СчетФактура",   Ссылка);
	Запрос.УстановитьПараметр("ПредъявленНДС", Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Регистратор,
	|	Организация,
	|	ВидЦенности,
	|	Поставщик,
	|	СчетФактура,
	|	Событие,
	|	СтавкаНДС,
	|	СуммаБезНДСОборот КАК СуммаБезНДС,
	|	НДСОборот         КАК НДС
	|ИЗ
	|	РегистрНакопления.НДСПокупки.Обороты(, , Регистратор, Организация = &Организация И СчетФактура = &СчетФактура И Событие = &ПредъявленНДС) КАК НДСПокупкиОбороты
	|
	|ГДЕ
	|	НДСПокупкиОбороты.Регистратор = &ДокОснование";
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();

	// Переопределяем событие
	РезультатыЗапроса.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПокупки.ПолученСчетФактура, "Событие");

	// Копируем результат в таблицу движений
	Для Каждого СтрокаРезультата Из РезультатыЗапроса Цикл

		СтрокаДвижения = ТаблицаДвижений.Добавить();

		Для Каждого Колонка Из РезультатыЗапроса.Колонки Цикл

			Если ТаблицаДвижений.Колонки.Найти(Колонка.Имя) <> Неопределено Тогда
				СтрокаДвижения[Колонка.Имя] = СтрокаРезультата[Колонка.Имя];
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Движения.НДСПокупки.мПериод = Дата;
	Движения.НДСПокупки.мТаблицаДвижений = ТаблицаДвижений;

	Движения.НДСПокупки.ДобавитьДвижение();

КонецПроцедуры // ДвиженияПоРегиструНДСПокупкиПоПрочимПоступлениям()

// Формирование движений по регистру НДСПокупки по прочим поступлениям.
// Процедура используется в тех случаях, когда документ основание счета фактуры
// это документ вида: "ПоступлениеТоваровИУслуг".
// В качестве исходных данных при проведении документа используются движения
// по регистру "НДСПокупки", сформированные при проведении документа основания.
//
Процедура ДвиженияПоРегиструНДСПокупкиПоПрочимПоступлениям(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = Движения.НДСПокупки.Выгрузить();
	ТаблицаДвижений.Очистить();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",   СтруктураШапкиДокумента.Организация);
	Запрос.УстановитьПараметр("ДокОснование",  СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ПредъявленНДС", Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Регистратор,
	|	Организация,
	|	ВидЦенности,
	|	Поставщик,
	|	СчетФактура,
	|	Событие,
	|	СтавкаНДС,
	|	СуммаБезНДСОборот КАК СуммаБезНДС,
	|	НДСОборот         КАК НДС
	|ИЗ
	|	РегистрНакопления.НДСПокупки.Обороты(, , Регистратор, Организация = &Организация И Событие = &ПредъявленНДС) КАК НДСПокупкиОбороты
	|
	|ГДЕ
	|	НДСПокупкиОбороты.Регистратор = &ДокОснование";
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();

	// Переопределяем событие
	РезультатыЗапроса.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПокупки.ПолученСчетФактура, "Событие");

	// Копируем результат в таблицу движений
	Для Каждого СтрокаРезультата Из РезультатыЗапроса Цикл

		СтрокаДвижения = ТаблицаДвижений.Добавить();

		Для Каждого Колонка Из РезультатыЗапроса.Колонки Цикл

			Если ТаблицаДвижений.Колонки.Найти(Колонка.Имя) <> Неопределено Тогда
				СтрокаДвижения[Колонка.Имя] = СтрокаРезультата[Колонка.Имя];
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	Движения.НДСПокупки.мПериод = Дата;
	Движения.НДСПокупки.мТаблицаДвижений = ТаблицаДвижений;

	Движения.НДСПокупки.ДобавитьДвижение();

КонецПроцедуры // ДвиженияПоРегиструНДСПокупкиПоПрочимПоступлениям()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	Перем ДеревоПолейЗапросаПоШапке;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);

	СтруктураШапкиДокумента   = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Сформируем структуру реквизитов шапки документа
	ДокОснование = ДокументОснование.ПолучитьОбъект();
	
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ДокОснование);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();
	
	Если ДокументОснование.Метаданные().Имя <> "АвансовыйОтчет" Тогда
		ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "УчетАгентскогоНДС"   ,  "УчетАгентскогоНДС");
		ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов", "ВидАгентскогоДоговора", "ВидАгентскогоДоговора");
		
	КонецЕсли;

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ДокОснование, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, );

	// Движения по документу
	Если (Не Отказ)
	   и (ДокументОснование <> Неопределено) Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	//БАЛАНС (04.12.2007)                       
	//
	ЗарегистрироватьОбъект(ЭтотОбъект,Отказ,мПроведениеИзФормы);
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 
	
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

//БАЛАНС (04.12.2007)                       
//
мПроведениеИзФормы = Ложь; 