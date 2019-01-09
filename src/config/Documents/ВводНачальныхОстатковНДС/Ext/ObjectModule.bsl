﻿Перем мВалютаРегламентированногоУчета Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура проверяет корректность заполнения реквизитов шапки документа
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	// Укажем, что надо проверить:
	СтрРекв = "Организация";
					
	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(СтрРекв), Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет корректность заполнения реквизитов таб. части документа
//
Процедура ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСпоАвансамПолученным Тогда
		ОбязательныеРеквизиты = "Контрагент, ДоговорКонтрагента, ДатаСФ, НомерСФ, ДатаПлатежноРасчетногоДокумента, НомерПлатежноРасчетногоДокумента, ВидЦенности, СтавкаНДС";
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСНеПолученныйОтПокупателей Тогда
		ОбязательныеРеквизиты = "Контрагент, ДоговорКонтрагента, ВидЦенности, СтавкаНДС, ДатаСФ, НомерСФ";
		
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСПоПриобретеннымЦенностям Тогда
		ОбязательныеРеквизиты = "Контрагент, ДоговорКонтрагента, ВидЦенности, СтавкаНДС";
		
	КонецЕсли;
	
	//проверка заполнения обязательных реквизитов
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", Новый Структура(ОбязательныеРеквизиты), Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеТабЧасти()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоСтрокам - результат запроса по табличной части "ДанныеПоСФ",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуДокумента(РезультатЗапроса, СтруктураШапкиДокумента)

	ТаблицаДокумента = РезультатЗапроса.Выгрузить();

	Возврат ТаблицаДокумента;

КонецФункции // ПодготовитьТаблицуТоваров()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА ПО РЕГИСТРАМ

// Процедура формирования движений по регистрам.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, ТаблицаДопСведений, Отказ,Заголовок)

	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСпоАвансамПолученным Тогда
		СформироватьДвиженияВводаОстатковПоРегиструВзаиморасчетыСПокупателямиДляНДС(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок);
		
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСНеПолученныйОтПокупателей Тогда
		СформироватьДвиженияВводаОстатковПоРегиструНДСПродажи(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок);
		
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийВводНачОстатковНДС.НДСПоПриобретеннымЦенностям Тогда
		СформироватьДвиженияВводаОстатковПоРегиструНДСПокупки(СтруктураШапкиДокумента, ТаблицаДокумента, ТаблицаДопСведений, Отказ, Заголовок);
		
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирования движений по регистру НДС покупки при вводе остатков по НДС 
// по поставщикам.
//
Процедура СформироватьДвиженияВводаОстатковПоРегиструНДСПокупки(СтруктураШапкиДокумента, ТаблицаДокумента, ТаблицаДопСведений, Отказ,Заголовок)
	
	ТаблицаДвиженийПокупки = Движения.НДСПокупки.Выгрузить();
	ТаблицаДвиженийПокупки.Очистить();
	
	ТаблицаДвиженийПродажи = Движения.НДСПродажи.Выгрузить();
	ТаблицаДвиженийПродажи.Очистить();
	
	Для Каждого СтрокаДок Из ТаблицаДокумента Цикл
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.НДСОплачен, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.НДСВключенВСтоимость, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.ПредполагаетсяСтавка0, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);
		ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету0, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи);

	КонецЦикла;
		
	Если ТаблицаДвиженийПокупки.Количество() > 0 Тогда
		Движения.НДСПокупки.мПериод          = Дата;
		Движения.НДСПокупки.мТаблицаДвижений = ТаблицаДвиженийПокупки;

		Движения.НДСПокупки.ДобавитьДвижение();
		Движения.НДСПокупки.Записать();

	КонецЕсли;
	
	Если ТаблицаДвиженийПродажи.Количество() > 0 Тогда
		Движения.НДСПродажи.мПериод          = Дата;
		Движения.НДСПродажи.мТаблицаДвижений = ТаблицаДвиженийПродажи;

		Движения.НДСПродажи.ДобавитьДвижение();
		Движения.НДСПродажи.Записать();

	КонецЕсли;
	
КонецПроцедуры // СформироватьДвиженияВводаОстатковПоРегиструНДСПокупки()

// Процедура вызывается из СформироватьДвиженияВводаОстатковПоРегиструНДСПокупки.
// Формирование движений по регистру НДСПокупки для определенного события.
//
Процедура ОтработатьДвиженияПоСобытию(СтруктураШапкиДокумента, СтрокаДок, ТаблицаДопСведений, ТекСобытие, ТаблицаДвиженийПокупки, ТаблицаДвиженийПродажи)
	
	СписокСобытий = Новый СписокЗначений;
	
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком, "");
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.НДСОплачен, "Оплата");
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.НДСВключенВСтоимость,  "ВключеноВСтоимость");
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.ПредполагаетсяСтавка0, "Ставка0");
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету,  "Предъявлено");
	СписокСобытий.Добавить(Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету0, "Предъявлено0");
	
	Суффикс = СписокСобытий.НайтиПоЗначению(ТекСобытие);
	
	Если (СтрокаДок["СуммаБезНДС"+Суффикс.Представление] + СтрокаДок["НДС"+Суффикс.Представление]) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПоиска   = Новый Структура("КлючСтроки,Событие", СтрокаДок.КлючСтроки, ТекСобытие);
	ДопСтроки         = ТаблицаДопСведений.НайтиСтроки(СтруктураПоиска);

	Если ДопСтроки.Количество() > 0 Тогда
		// Движения ввода остатков формируются по дополнительным строкам
		Для Каждого ДопСтрокаДок Из ДопСтроки Цикл
			СтрокаДвижения = ТаблицаДвиженийПокупки.Добавить();
			
			СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
			СтрокаДвижения.ВидЦенности = СтрокаДок.ВидЦенности;
			СтрокаДвижения.Поставщик  = СтрокаДок.Контрагент;
			СтрокаДвижения.СчетФактура = СтрокаДок.СчетФактура;
			СтрокаДвижения.Событие     = ТекСобытие;
			СтрокаДвижения.СтавкаНДС   = СтрокаДок.СтавкаНДС;
			
			СтрокаДвижения.СуммаБезНДС = ДопСтрокаДок.СуммаБезНДС;
			СтрокаДвижения.НДС         = ДопСтрокаДок.НДС;
			
			// Устанавливаем значения доп реквизитов в движениях
			СтрокаДвижения.ДокументОплаты = ДопСтрокаДок.ДокументОплаты;
			
			Если (ТекСобытие = Перечисления.СобытияПоНДСПокупки.ПредполагаетсяСтавка0)
			   и (ДопСтрокаДок.ДокументОтгрузки <> Неопределено) Тогда
				// Выполняем дополнительное специфичное движение по регистру НДСПродажи
				СтрокаДвижения = ТаблицаДвиженийПродажи.Добавить();

				СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
				СтрокаДвижения.ВидЦенности = СтрокаДок.ВидЦенности;
				СтрокаДвижения.Покупатель  = ДопСтрокаДок.ДокументОтгрузки.Контрагент;
				СтрокаДвижения.СчетФактура = ДопСтрокаДок.ДокументОтгрузки;
				СтрокаДвижения.Событие     = Перечисления.СобытияПоНДСПродажи.Реализация;
				СтрокаДвижения.СтавкаНДС   = Перечисления.СтавкиНДС.НДС0;
				СтрокаДвижения.СуммаБезНДС = ДопСтрокаДок.ДокументОтгрузки.СуммаДокумента;
			
			КонецЕсли;
			
		КонецЦикла
		
	Иначе
		// Движение ввода остатков формируется по основной строке
		СтрокаДвижения = ТаблицаДвиженийПокупки.Добавить();
		
		СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
		СтрокаДвижения.ВидЦенности = СтрокаДок.ВидЦенности;
		СтрокаДвижения.Поставщик  = СтрокаДок.Контрагент;
		СтрокаДвижения.СчетФактура = СтрокаДок.СчетФактура;
		СтрокаДвижения.Событие     = ТекСобытие;
		СтрокаДвижения.СтавкаНДС   = СтрокаДок.СтавкаНДС;
		СтрокаДвижения.СуммаБезНДС = СтрокаДок["СуммаБезНДС"+Суффикс.Представление];
		СтрокаДвижения.НДС         = СтрокаДок["НДС"+Суффикс.Представление];
		
	КонецЕсли;
	
	Если (ТекСобытие = Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком)
	   и (СтрокаДок.ПредъявленСФ) Тогда
		// Дополнительно движение ввода остатков отражающее факт получения счет-фактуры
		СтрокаДвижения = ТаблицаДвиженийПокупки.Добавить();
		
		СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
		СтрокаДвижения.ВидЦенности = СтрокаДок.ВидЦенности;
		СтрокаДвижения.Поставщик  = СтрокаДок.Контрагент;
		СтрокаДвижения.СчетФактура = СтрокаДок.СчетФактура;
		СтрокаДвижения.Событие     = Перечисления.СобытияПоНДСПокупки.ПолученСчетФактура;
		СтрокаДвижения.СтавкаНДС   = СтрокаДок.СтавкаНДС;
		СтрокаДвижения.СуммаБезНДС = СтрокаДок["СуммаБезНДС"];
		СтрокаДвижения.НДС         = СтрокаДок["НДС"];
	   
	КонецЕсли;
	
КонецПроцедуры // ОтработатьДвиженияПоСобытию()

// Процедура формирования движений по регистру НДС продажи при вводе остатков по НДС 
// неполученному от покупателей.
//
Процедура СформироватьДвиженияВводаОстатковПоРегиструНДСПродажи(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок)
	
	ТаблицаДвиженийПродажи = Движения.НДСПродажи.Выгрузить();
	ТаблицаДвиженийПродажи.Очистить();
	
	Для Каждого СтрокаДок Из ТаблицаДокумента Цикл
		СтрокаДвижения = ТаблицаДвиженийПродажи.Добавить();

		СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
		СтрокаДвижения.ВидЦенности = СтрокаДок.ВидЦенности;
		СтрокаДвижения.Покупатель  = СтрокаДок.Контрагент;
		СтрокаДвижения.СчетФактура = СтрокаДок.СчетФактура;
		СтрокаДвижения.Событие     = Перечисления.СобытияПоНДСПродажи.Реализация;
		СтрокаДвижения.СтавкаНДС   = СтрокаДок.СтавкаНДС;
		СтрокаДвижения.СуммаБезНДС = СтрокаДок.СуммаБезНДС;
		СтрокаДвижения.НДС         = СтрокаДок.НДС;
		
		СтрокаДвижения.Номенклатура = СтрокаДок.Номенклатура;

	КонецЦикла;
	
	Если ТаблицаДвиженийПродажи.Количество() > 0 Тогда
		Движения.НДСПродажи.мПериод          = Дата;
		Движения.НДСПродажи.мТаблицаДвижений = ТаблицаДвиженийПродажи;

		Движения.НДСПродажи.ДобавитьДвижение();
		Движения.НДСПродажи.Записать();

	КонецЕсли;
	
КонецПроцедуры // СформироватьДвиженияПоРегиструНДСПродажи()

// Процедура формирования движений по регистру Взаиморасчеты с покупателями для НДС при вводе
// остатков НДС по авансам и задолженностям покупателей.
//
Процедура СформироватьДвиженияВводаОстатковПоРегиструВзаиморасчетыСПокупателямиДляНДС(СтруктураШапкиДокумента, ТаблицаДокумента, Отказ,Заголовок)
	
	ТаблицаДвиженийПокупатели = Движения.ВзаиморасчетыСПокупателямиДляНДС.Выгрузить();
	ТаблицаДвиженийПокупатели.Очистить();
	
	Для Каждого СтрокаДок Из ТаблицаДокумента Цикл
		СтрокаДвижения = ТаблицаДвиженийПокупатели.Добавить();
		
		СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
		СтрокаДвижения.ДоговорКонтрагента = СтрокаДок.ДоговорКонтрагента;
		СтрокаДвижения.Сделка = ОпределитьСделкуСтрокиТЧ(ЭтотОбъект, СтрокаДок);
		
		СтрокаДвижения.Сумма = СтрокаДок.СуммаБезНДС + СтрокаДок.НДС;
		
	КонецЦикла;
		
	Если ТаблицаДвиженийПокупатели.Количество() > 0 Тогда
		Движения.ВзаиморасчетыСПокупателямиДляНДС.мПериод          = Дата;
		Движения.ВзаиморасчетыСПокупателямиДляНДС.мТаблицаДвижений = ТаблицаДвиженийПокупатели;
		Движения.ВзаиморасчетыСПокупателямиДляНДС.ВыполнитьРасход();
		Движения.ВзаиморасчетыСПокупателямиДляНДС.Записать();

	КонецЕсли;
	
КонецПроцедуры // СформироватьДвиженияВводаОстатковПоРегиструВзаиморасчетыСПокупателямиДляНДС()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ УПРАВЛЕНИЯ ПОДЧИНЕННЫМИ ДОКУМЕНТАМИ

// Процедура проведения подчиненных документов счет-фактура.
// Выбирает все счета-фактуры в которых в качестве документа
// основания указан текущий документ и перепроводит их.
//
Процедура ОбработкаПодчиненныхДокументовСчетФактутра(Провести = Истина)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Запрос.УстановитьПараметр("ПризнакПроведения", Не Провести);
	
	Запрос.Текст = "ВЫБРАТЬ
					|	СчетФактураВыданный.Ссылка КАК Ссылка
					|ИЗ
					|	Документ.СчетФактураВыданный КАК СчетФактураВыданный

					|ГДЕ
					|	СчетФактураВыданный.Проведен = &ПризнакПроведения И
					|	СчетФактураВыданный.ПометкаУдаления = Ложь И
					|	СчетФактураВыданный.ДокументОснование.Ссылка = &ДокументОснование

					|УПОРЯДОЧИТЬ ПО
					|	Ссылка";
	
	ТабРез = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрРез Из ТабРез Цикл
		ТекСчетФактура = СтрРез.Ссылка.ПолучитьОбъект();
		Если НЕ ТекСчетФактура.ПометкаУдаления Тогда
			ТекСчетФактура.Проведен = Провести;
			
			Если Провести Тогда
				ТекСчетФактура.Записать(РежимЗаписиДокумента.Проведение);
			Иначе
				ТекСчетФактура.Записать(РежимЗаписиДокумента.ОтменаПроведения);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ОбработкаПодчиненныхДокументовСчетФактутра()

// Процедура проведения подчиненных документов "ОтражениеРеализацииТоваровИУслугНДС".
// Выбирает все документы отражения реализации, в которых в качестве документа
// основания указан текущий документ и проводит их (делает непроведенными).
//
Процедура ОбработкаПодчиненныхДокументовОтраженияРеализации(Провести = Истина)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Запрос.УстановитьПараметр("ПризнакПроведения", Не Провести);
	
	Запрос.Текст = "ВЫБРАТЬ
					|	ОтражениеРеализацииТоваровИУслугНДС.Ссылка КАК Ссылка,
					|	СчетФактураВыданный.Ссылка КАК СсылкаСФ
					|ИЗ
					|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
					|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтражениеРеализацииТоваровИУслугНДС КАК ОтражениеРеализацииТоваровИУслугНДС
					|		ПО СчетФактураВыданный.ДокументОснование = ОтражениеРеализацииТоваровИУслугНДС.Ссылка

					|ГДЕ
					|	ОтражениеРеализацииТоваровИУслугНДС.Проведен = &ПризнакПроведения И
					|	(ОтражениеРеализацииТоваровИУслугНДС.ПометкаУдаления = ЛОЖЬ) И
					|	ОтражениеРеализацииТоваровИУслугНДС.РасчетныйДокумент = &ДокументОснование

					|УПОРЯДОЧИТЬ ПО
					|	Ссылка";
	
	ТабРез = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрРез Из ТабРез Цикл
		ТекРеализация = СтрРез.Ссылка.ПолучитьОбъект();
		Если Провести Тогда
			ТекРеализация.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ТекРеализация.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
		
		Если ТипЗнч(СтрРез.СсылкаСФ) = Тип("ДокументСсылка.СчетФактураВыданный") Тогда
			ТекСчетФактура = СтрРез.СсылкаСФ.ПолучитьОбъект();
			Если НЕ ТекСчетФактура.ПометкаУдаления Тогда
				Если Провести Тогда
					ТекСчетФактура.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					ТекСчетФактура.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ОбработкаПодчиненныхДокументовОтраженияРеализации()

// Процедура проведения подчиненных документов "ОтражениеПоступленияТоваровИУслугНДС".
// Выбирает все документы отражения реализации, в которых в качестве документа
// основания указан текущий документ и проводит их (делает непроведенными).
//
Процедура ОбработкаПодчиненныхДокументовОтраженияПоступления(Провести = Истина)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	Запрос.УстановитьПараметр("ПризнакПроведения", Не Провести);
	
	Запрос.Текст = "ВЫБРАТЬ
					|	ОтражениеПоступленияТоваровИУслугНДС.Ссылка КАК Ссылка,
					|	СчетФактураПолученный.Ссылка КАК СсылкаСФ
					|ИЗ
					|	Документ.ОтражениеПоступленияТоваровИУслугНДС КАК ОтражениеПоступленияТоваровИУслугНДС
					|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураПолученный КАК СчетФактураПолученный
					|		ПО ОтражениеПоступленияТоваровИУслугНДС.Ссылка = СчетФактураПолученный.ДокументОснование.Ссылка

					|ГДЕ
					|	ОтражениеПоступленияТоваровИУслугНДС.Проведен = &ПризнакПроведения И
					|	(ОтражениеПоступленияТоваровИУслугНДС.ПометкаУдаления = ЛОЖЬ) И
					|	ОтражениеПоступленияТоваровИУслугНДС.РасчетныйДокумент = &ДокументОснование

					|УПОРЯДОЧИТЬ ПО
					|	Ссылка";
	
	ТабРез = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрРез Из ТабРез Цикл
		ТекПоступление = СтрРез.Ссылка.ПолучитьОбъект();
		Если Провести Тогда
			ТекПоступление.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			ТекПоступление.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
		
		Если ТипЗнч(СтрРез.СсылкаСФ) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
			ТекСчетФактура = СтрРез.СсылкаСФ.ПолучитьОбъект();
			Если НЕ ТекСчетФактура.ПометкаУдаления Тогда
				Если Провести Тогда
					ТекСчетФактура.Записать(РежимЗаписиДокумента.Проведение);
				Иначе
					ТекСчетФактура.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ОбработкаПодчиненныхДокументовОтраженияРеализации()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОшибкаПроведенияПоСтроке(СтрокаОС, ТекстСобщения,Заголовок,Статус)
	
	НачалоСообщения = "- строка № "+СтрокаОС.НомерСтроки+", инв. номер ОС <"+СтрокаОС.ИнвентарныйНомерРегл+"> : ";
	СообщитьОбОшибке(НачалоСообщения+ТекстСобщения, Статус, Заголовок)
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ)

	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабЧасти(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Контрагент", 		  "Контрагент");
	СтруктураПолей.Вставить("ДоговорКонтрагента", "ДоговорКонтрагента");
	СтруктураПолей.Вставить("Сделка",			  "Сделка");
	СтруктураПолей.Вставить("ДатаСФ", 			  "ДатаСФ");
	СтруктураПолей.Вставить("НомерСФ", 			  "НомерСФ");
	СтруктураПолей.Вставить("ДатаПлатежноРасчетногоДокумента",  "ДатаПлатежноРасчетногоДокумента");
	СтруктураПолей.Вставить("НомерПлатежноРасчетногоДокумента", "НомерПлатежноРасчетногоДокумента");
	СтруктураПолей.Вставить("СчетФактура", 		  "СчетФактура");
	СтруктураПолей.Вставить("ВидЦенности",		  "ВидЦенности");
	СтруктураПолей.Вставить("СтавкаНДС",		  "СтавкаНДС");
	СтруктураПолей.Вставить("Номенклатура",		  "Номенклатура");
	СтруктураПолей.Вставить("ПредъявленСФ",		  "ПредъявленСФ");
	СтруктураПолей.Вставить("СуммаБезНДС",		  "СуммаБезНДС");
	СтруктураПолей.Вставить("НДС",		 		  "НДС");
	СтруктураПолей.Вставить("СуммаБезНДСОплата",  "СуммаБезНДСОплата");
	СтруктураПолей.Вставить("НДСОплата",		  "НДСОплата");
	СтруктураПолей.Вставить("СуммаБезНДСВключеноВСтоимость",	"СуммаБезНДСВключеноВСтоимость");
	СтруктураПолей.Вставить("НДСВключеноВСтоимость",			"НДСВключеноВСтоимость");
	СтруктураПолей.Вставить("СуммаБезНДССтавка0",				"СуммаБезНДССтавка0");
	СтруктураПолей.Вставить("НДССтавка0",						"НДССтавка0");
	СтруктураПолей.Вставить("СуммаБезНДСПредъявлено", 	"СуммаБезНДСПредъявлено");
	СтруктураПолей.Вставить("НДСПредъявлено",		  	"НДСПредъявлено");
	СтруктураПолей.Вставить("СуммаБезНДСПредъявлено0", 	"СуммаБезНДСПредъявлено0");
	СтруктураПолей.Вставить("НДСПредъявлено0",		   	"НДСПредъявлено0");
	СтруктураПолей.Вставить("КлючСтроки",				"КлючСтроки");

	РезультатЗапросаПоСтрокам = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ДанныеПоСФ", СтруктураПолей);

	// Подготовим таблицу для проведения.
	ТаблицаДокумента = ПодготовитьТаблицуДокумента(РезультатЗапросаПоСтрокам, СтруктураШапкиДокумента);
	
	СтруктураДопПолей = Новый Структура();
	СтруктураДопПолей.Вставить("КлючСтроки", 	"КлючСтроки");
	СтруктураДопПолей.Вставить("Событие", 		"Событие");
	СтруктураДопПолей.Вставить("ДокументОплаты", "ДокументОплаты");
	СтруктураДопПолей.Вставить("ДокументОтгрузки", "ДокументОтгрузки");
	СтруктураДопПолей.Вставить("СуммаБезНДС", 	"СуммаБезНДС");
	СтруктураДопПолей.Вставить("НДС", 			"НДС");
	
	РезультатЗапросаПоСтрокам = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ДополнительныеСведения", СтруктураДопПолей);
	
	// Подготовим таблицу содержащую дополнительные сведения.
	ТаблицаДопСведений = ПодготовитьТаблицуДокумента(РезультатЗапросаПоСтрокам, СтруктураШапкиДокумента);
	
	Если Не Отказ Тогда
		ОбработкаПодчиненныхДокументовСчетФактутра();
		
		ОбработкаПодчиненныхДокументовОтраженияРеализации();

		ОбработкаПодчиненныхДокументовОтраженияПоступления();
		
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаДокумента, ТаблицаДопСведений, Отказ, Заголовок);
			
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ОбработкаПодчиненныхДокументовСчетФактутра(Ложь);
	
	ОбработкаПодчиненныхДокументовОтраженияРеализации(Ложь);
	
	ОбработкаПодчиненныхДокументовОтраженияПоступления(Ложь);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
