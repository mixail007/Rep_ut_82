﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	А.Номенклатура,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА НЕ А.Склад.ЗапретитьИспользование
	                      |					И НЕ А.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ВПути)
	                      |					И НЕ А.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.Ошиповка)
	                      |				ТОГДА А.КоличествоОстаток
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК КоличествоОстаток,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА А.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ВПути)
	                      |				ТОГДА А.КоличествоОстаток
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК КоличествоВПути,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА А.Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.Ошиповка)
	                      |				ТОГДА А.КоличествоОстаток
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК КоличествоНаОшиповке
	                      |ПОМЕСТИТЬ ВТ_Остатки
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		ТоварыНаСкладахОстатки.Склад КАК Склад,
	                      |		ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	                      |		ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
	                      |	ИЗ
	                      |		РегистрНакопления.ТоварыНаСкладах.Остатки(
	                      |				,
	                      |				Номенклатура.ВидТовара = &ВидТовара
	                      |					И ВЫБОР
	                      |						КОГДА &Транзит
	                      |							ТОГДА Склад.Транзитный
	                      |									И Склад.Подразделение = &Подразделение
	                      |						ИНАЧЕ НЕ Склад.Транзитный
	                      |					КОНЕЦ
	                      |					И (НЕ Склад.ЗапретитьИспользование
	                      |						ИЛИ Склад.ЗапретитьИспользование
	                      |							И (Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.ВПути)
	                      |								ИЛИ Склад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.Ошиповка)))) КАК ТоварыНаСкладахОстатки) КАК А
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	А.Номенклатура
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ОстаткиНоменклатурыКонтрагентов.Номенклатура,
	                      |	СУММА(ЕСТЬNULL(ОстаткиНоменклатурыКонтрагентов.Остаток, 0)) КАК Остаток,
	                      |	МАКСИМУМ(ЕСТЬNULL(СрокиДоставки.СрокДоставки, 0)) КАК СрокДоставки
	                      |ПОМЕСТИТЬ ВТ_ОстаткиПоставщиков
	                      |ИЗ
	                      |	РегистрСведений.ОстаткиНоменклатурыКонтрагентов КАК ОстаткиНоменклатурыКонтрагентов
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СрокиДоставки КАК СрокиДоставки
	                      |		ПО ОстаткиНоменклатурыКонтрагентов.Контрагент = СрокиДоставки.Поставщик
	                      |			И (НЕ СрокиДоставки.ОТХ)
	                      |ГДЕ
	                      |	ОстаткиНоменклатурыКонтрагентов.Номенклатура.ВидТовара = &ВидТовара
	                      |	И ОстаткиНоменклатурыКонтрагентов.Подразделение = &Подразделение
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ОстаткиНоменклатурыКонтрагентов.Номенклатура
	                      |
	                      |ИНДЕКСИРОВАТЬ ПО
	                      |	ОстаткиНоменклатурыКонтрагентов.Номенклатура
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ЕСТЬNULL(Остатки.Номенклатура.Код, ЗаказыПоставщикамОстатки.Номенклатура.Код) КАК Код,
	                      |	ЕСТЬNULL(Остатки.Номенклатура, ЗаказыПоставщикамОстатки.Номенклатура) КАК Номенклатура,
	                      |	ЕСТЬNULL(Остатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	                      |	ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) КАК КоличествоЗаказано,
	                      |	ЕСТЬNULL(Остатки.КоличествоОстаток, 0) - ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) КАК СвободныйОстаток,
	                      |	ЕСТЬNULL(ЗаказыПоставщикамОстатки.КоличествоОстаток, 0) - ЕСТЬNULL(ЗаданиеНаОтгрузкуПриход.КоличествоРазгружается, 0) КАК КоличествоВПути1,
	                      |	ЕСТЬNULL(ЗаданиеНаОтгрузкуПриход.КоличествоРазгружается, 0) КАК КоличествоРазгружается,
	                      |	ЕСТЬNULL(Остатки.КоличествоВПути, 0) КАК КоличествоВПути2,
	                      |	ЕСТЬNULL(Остатки.КоличествоНаОшиповке, 0) КАК КоличествоНаОшиповке,
	                      |	ЕСТЬNULL(Остатки.КоличествоОтветХранение, 0) КАК КоличествоОтветХранение,
	                      |	Остатки.уПоставщиков КАК уПоставщиков,
	                      |	Остатки.СрокДоставки КАК СрокДоставки
	                      |ИЗ
	                      |	(ВЫБРАТЬ
	                      |		А.Номенклатура КАК Номенклатура,
	                      |		СУММА(А.КоличествоОстаток) КАК КоличествоОстаток,
	                      |		СУММА(А.КоличествоВПути) КАК КоличествоВПути,
	                      |		СУММА(А.КОличествоНаОшиповке) КАК КоличествоНаОшиповке,
	                      |		СУММА(А.КоличествоОтветХранение) КАК КоличествоОтветХранение,
	                      |		СУММА(А.КоличествоУПоставщиков) КАК уПоставщиков,
	                      |		МАКСИМУМ(А.СрокДоставки) КАК СрокДоставки
	                      |	ИЗ
	                      |		(ВЫБРАТЬ
	                      |			ТоварыНаОтветственномХраненииОстатки.Номенклатура КАК Номенклатура,
	                      |			0 КАК КоличествоОстаток,
	                      |			0 КАК КоличествоВПути,
	                      |			0 КАК КОличествоНаОшиповке,
	                      |			ТоварыНаОтветственномХраненииОстатки.КоличествоОстаток КАК КоличествоОтветХранение,
	                      |			0 КАК КоличествоУПоставщиков,
	                      |			0 КАК СрокДоставки
	                      |		ИЗ
	                      |			РегистрНакопления.ТоварыНаОтветственномХранении.Остатки(
	                      |					,
	                      |					Номенклатура.ВидТовара = &ВидТовара
	                      |						И Контрагент В (&СписокКонтрагентовОТХ)
	                      |						И ВЫБОР
	                      |							КОГДА &Транзит
	                      |								ТОГДА Склад.Транзитный
	                      |										И Склад.Подразделение = &Подразделение
	                      |							ИНАЧЕ НЕ Склад.Транзитный
	                      |						КОНЕЦ
	                      |						И НЕ Склад.ЗапретитьИспользование) КАК ТоварыНаОтветственномХраненииОстатки
	                      |		
	                      |		ОБЪЕДИНИТЬ
	                      |		
	                      |		ВЫБРАТЬ
	                      |			ВТ_Остатки.Номенклатура,
	                      |			ВТ_Остатки.КоличествоОстаток,
	                      |			ВТ_Остатки.КоличествоВПути,
	                      |			ВТ_Остатки.КоличествоНаОшиповке,
	                      |			0,
	                      |			0,
	                      |			0
	                      |		ИЗ
	                      |			ВТ_Остатки КАК ВТ_Остатки
	                      |		
	                      |		ОБЪЕДИНИТЬ ВСЕ
	                      |		
	                      |		ВЫБРАТЬ
	                      |			ВТ_ОстНомПост.Номенклатура,
	                      |			0,
	                      |			0,
	                      |			0,
	                      |			0,
	                      |			ВТ_ОстНомПост.Остаток,
	                      |			ВТ_ОстНомПост.СрокДоставки
	                      |		ИЗ
	                      |			ВТ_ОстаткиПоставщиков КАК ВТ_ОстНомПост) КАК А
	                      |	
	                      |	СГРУППИРОВАТЬ ПО
	                      |		А.Номенклатура) КАК Остатки
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки(
	                      |				,
	                      |				Номенклатура.ВидТовара = &ВидТовара
	                      |					И ВЫБОР
	                      |						КОГДА &Транзит
	                      |							ТОГДА ЗаказПокупателя.Транзит
	                      |									И ЗаказПокупателя.Подразделение = &Подразделение
	                      |						ИНАЧЕ НЕ ЗаказПокупателя.Транзит
	                      |					КОНЕЦ
	                      |					И ЗаказПокупателя.Проверен) КАК ЗаказыПокупателейОстатки
	                      |		ПО Остатки.Номенклатура = ЗаказыПокупателейОстатки.Номенклатура
	                      |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(
	                      |				,
	                      |				Номенклатура.ВидТовара = &ВидТовара
	                      |					И ВЫБОР
	                      |						КОГДА &Транзит
	                      |							ТОГДА ЗаказПоставщику.Транзит
	                      |									И ЗаказПоставщику.Подразделение = &Подразделение
	                      |						ИНАЧЕ НЕ ЗаказПоставщику.Транзит
	                      |					КОНЕЦ
	                      |					И ЗаказПоставщику.ДатаПоступления >= &МинДатаПоступления) КАК ЗаказыПоставщикамОстатки
	                      |		ПО Остатки.Номенклатура = ЗаказыПоставщикамОстатки.Номенклатура
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                      |			ЗаказыПоставщикамОстатки.Номенклатура КАК Номенклатура,
	                      |			ЗаказыПоставщикамОстатки.КоличествоОстаток КАК КоличествоРазгружается
	                      |		ИЗ
	                      |			РегистрНакопления.ЗаказыПоставщикам.Остатки(
	                      |					,
	                      |					Номенклатура.ВидТовара = &ВидТовара
	                      |						И ЗаказПоставщику.ДатаПоступления >= &МинДатаПоступления
	                      |						И ЗаказПоставщику В
	                      |							(ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |								ЗадНаОтгрузку.ЗаказПоставщику
	                      |							ИЗ
	                      |								Документ.ЗаданиеНаОтгрузку.ЗаказыПоставщикам КАК ЗадНаОтгрузку
	                      |							ГДЕ
	                      |								НЕ ЗадНаОтгрузку.Ссылка.ПометкаУдаления
	                      |								И НЕ ЗадНаОтгрузку.Ссылка.Выполнено
	                      |								И ЗадНаОтгрузку.Ссылка.Дата >= &НачРазгрузки
	                      |								И ЗадНаОтгрузку.Ссылка.Дата <= &КонРазгрузки)) КАК ЗаказыПоставщикамОстатки) КАК ЗаданиеНаОтгрузкуПриход
	                      |		ПО (ЗаказыПоставщикамОстатки.Номенклатура = ЗаданиеНаОтгрузкуПриход.Номенклатура)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ВЫБОР
	                      |		КОГДА Остатки.Номенклатура ЕСТЬ NULL 
	                      |			ТОГДА ЗаказыПоставщикамОстатки.Номенклатура.Наименование
	                      |		ИНАЧЕ Остатки.Номенклатура.Наименование
	                      |	КОНЕЦ
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |УНИЧТОЖИТЬ ВТ_Остатки
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |УНИЧТОЖИТЬ ВТ_ОстаткиПоставщиков");
						  
КонецПроцедуры

Процедура КоманднаяПанель1Прочитать(Кнопка)
	// Вставить содержимое обработчика.
	
	Заказ.Очистить();
	ФормаЭкселя = ПолучитьФорму("ЧтениеИзЭксель");
	ТаблицаЗаказа = ФормаЭкселя.ОткрытьМодально();
	
	Если Не ЗначениеЗаполнено(ТаблицаЗаказа) Тогда 
		Возврат;
	КонецЕсли;
	//Теперь записываем таблицу заказа в форму и считываем остатки.
	Для каждого Стр из ТаблицаЗаказа Цикл
		СтрУ = Заказ.Добавить();
		ЗаполнитьЗначенияСвойств(СтрУ,Стр);
	КонецЦикла;
	// Заполняем остатки. 
	
	СписокНом = ТаблицаЗаказа.выгрузитьколонку("Номенклатура");
	
	ТО = ПолучитьОстатки(СписокНом);
	
	Для каждого Стр из Заказ Цикл
		
		СтрН = ТО.Найти(Стр.Номенклатура,"Номенклатура");
		
		Если ЗначениеЗаполнено(СтрН) Тогда 
			Стр.ОстаткиВБазе 	= СтрН.СвободныйОстаток;
			
			Если (Стр.Количество + стр.ОстаткиВБазе)<стр.МинОстаток Тогда 
				Стр.Заказ = стр.ОстаткиВБазе;
			Иначе 
				Стр.Заказ = стр.МинОстаток - Стр.Количество;
			КонецЕсли;
			
			Если стр.Заказ<0 Тогда 
				стр.Заказ=0;
			КонецЕсли;
			
		КонецЕсли;	
	
	КонецЦИкла;
	
	ЭлементыФормы.Заказ.Колонки.Номенклатура.ТолькоПросмотр = истина;
	ЭлементыФормы.Заказ.Колонки.Количество.ТолькоПросмотр = истина;
	ЭлементыФормы.Заказ.Колонки.МинимальныйОстаток.ТолькоПросмотр = истина;
	ЭлементыФормы.Заказ.Колонки.ОстаткиВБазе.ТолькоПросмотр = истина;
	
КонецПроцедуры

Процедура КоманднаяПанель1СоздатьЗаказ(Кнопка)
	// Вставить содержимое обработчика.
	
	ЗаказХ = Документы.ЗаказПокупателя.СоздатьДокумент();
	ЗаказХ.Организация = Справочники.Организации.НайтиПоКоду("00001");
	ЗаказХ.Контрагент = Контрагент;
	ЗаказХ.ДоговорКонтрагента = Договор;
	//ЗаполнитьШапкуДокумента(ЗаказХ, глТекущийПользователь, Константы.ВалютаРегламентированногоУчета.Получить(), "Продажа");
	
	Для каждого Стр из Заказ Цикл
		Если (Стр.Заказ=0) Тогда 
			Продолжить;
		КонецЕсли;
		
		СтрУ = ЗаказХ.Товары.Добавить();
		СтрУ.Номенклатура = Стр.Номенклатура;
		СтрУ.ЕдиницаИзмерения = Стр.Номенклатура.ЕдиницаХраненияОстатков;
		СтрУ.ЕдиницаИзмеренияМест = СтрУ.ЕдиницаИзмерения;
		СтрУ.Коэффициент = 1;
		СтрУ.Количество = Стр.Заказ;
		СтрУ.СтавкаНДС = ?(ЗначениеЗАполнено(Стр.Номенклатура.СтавкаНДС),Стр.Номенклатура.СтавкаНДС,Перечисления.СтавкиНДС.НДС18);
		
	КонецЦикла;
	
	ЗаказХ.ДоговорКонтрагента = Договор;
	ЗаказХ.ПолучитьФорму("ФормаДокумента").Открыть();
КонецПроцедуры

Процедура Разделитель(Кнопка)
	// Вставить содержимое обработчика.
	
КонецПроцедуры

Процедура ЗаказПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	// Вставить содержимое обработчика.
	Если (Данныестроки.Количество + Данныестроки.ОстаткиВБазе)<Данныестроки.МинОстаток Тогда 
		Оформлениестроки.ЦветТекста = WebЦвета.Красный;
	Иначе 
		Оформлениестроки.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаказОстаткиВБазеНачалоВыбора(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

Процедура ПередСохранениемЗначений(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура КоманднаяПанель2ПодобратьПоАналогам(Кнопка)
	// Вставить содержимое обработчика.
	// Вставить содержимое обработчика.
	
	ФормаАналогов = ПолучитьФорму("ПодборПоАналогам");
	ФормаАналогов.Номенклатура = ЭлементыФормы.Заказ.ТекущиеДанные.Номенклатура;
	ФормаАналогов.КоличествоНеобходимо = ЭлементыФормы.Заказ.ТекущиеДанные.МинОстаток - (ЭлементыФормы.Заказ.ТекущиеДанные.Количество + ЭлементыФормы.Заказ.ТекущиеДанные.ОстаткиВБазе);
	СписокАналогов = ФормаАналогов.Открытьмодально();
	
	Если ЗначениеЗаполнено(СписокАналогов) Тогда 
		Для каждого Стр из СписокАналогов Цикл
			Стру = Заказ.Добавить();
			ЗаполнитьЗначенияСвойств(Стру,Стр);
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры
