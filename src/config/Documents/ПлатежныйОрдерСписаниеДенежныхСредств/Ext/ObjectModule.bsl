﻿// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

Перем ТаблицаПлатежейУпр;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

//Заполняет сумму документа и расшифровку платежа по расчетному документу
 //
Процедура ЗаполнитьПоРасчетномуДокументуУпр() Экспорт
	
	Организация=РасчетныйДокумент.Организация;
	СчетОрганизации=РасчетныйДокумент.СчетОрганизации;
	
	Контрагент=РасчетныйДокумент.Контрагент;
	СчетКонтрагента=РасчетныйДокумент.СчетКонтрагента;
	
	ВалютаДокумента=РасчетныйДокумент.ВалютаДокумента;
	СтруктураКурсаДокумента   = ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	
	ВидОперацииДокумент=РасчетныйДокумент.ВидОперации;
	
	Если ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПеречислениеНалога Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПеречислениеНалога
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.ПрочееСписаниеБезналичныхДенежныхСредств Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ПрочееСписаниеБезналичныхДенежныхСредств
	ИначеЕсли ВидОперацииДокумент=Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймамСКонтрагентами Тогда
		ВидОперации=Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам
	Иначе
		ВидОперации=ВидОперацииДокумент;
	КонецЕсли;
		
	ЕстьРасчетыСКонтрагентами=ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=ЕстьРасчетыПоКредитам(ВидОперации);
	
	ОтраженоВОперУчете=РасчетныйДокумент.ОтраженоВОперУчете;
	ОтражатьВБухгалтерскомУчете=РасчетныйДокумент.ОтражатьВБухгалтерскомУчете;
	
	ТекстЗапроса="ВЫБРАТЬ
	|	ДенежныеСредстваКСписаниюОстатки.ДокументСписания,
	|	ДенежныеСредстваКСписаниюОстатки.СуммаОстаток,
	|	ДенежныеСредстваКСписаниюОстатки.СтатьяДвиженияДенежныхСредств,
	|	РасчетныйДокумент.ДоговорКонтрагента,
	|	РасчетныйДокумент.Сделка,
	|	РасчетныйДокумент.Ссылка.СуммаДокумента КАК СуммаДокумента,
	|	РасчетныйДокумент.СуммаПлатежа,
	|	РасчетныйДокумент.КурсВзаиморасчетов,
	|	РасчетныйДокумент.КратностьВзаиморасчетов,
	|	РасчетныйДокумент.СуммаВзаиморасчетов,
	|	РасчетныйДокумент.СтавкаНДС,
	|	РасчетныйДокумент.СуммаНДС,
	|	РасчетныйДокумент.ДокументПланированияПлатежа,
	|	РасчетныйДокумент.Проект 				 
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваКСписанию.Остатки(, ДокументСписания=&РасчетныйДокумент) КАК ДенежныеСредстваКСписаниюОстатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ."+РасчетныйДокумент.Метаданные().Имя+".РасшифровкаПлатежа КАК РасчетныйДокумент
	|		ПО ДенежныеСредстваКСписаниюОстатки.ДокументСписания = РасчетныйДокумент.Ссылка
	|      И  ДенежныеСредстваКСписаниюОстатки.СтатьяДвиженияДенежныхСредств = РасчетныйДокумент.СтатьяДвиженияДенежныхСредств";
	
	Запрос=Новый Запрос;
	Запрос.Текст=ТекстЗапроса;
	Запрос.УстановитьПараметр("РасчетныйДокумент",РасчетныйДокумент);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СтрокаПлатеж=РасшифровкаПлатежа.Добавить();
		
		СтрокаПлатеж.ДоговорКонтрагента=Результат.ДоговорКонтрагента;
		СтрокаПлатеж.Сделка=Результат.Сделка;
		СтрокаПлатеж.КурсВзаиморасчетов=Результат.КурсВзаиморасчетов;
		СтрокаПлатеж.КратностьВзаиморасчетов=Результат.КратностьВзаиморасчетов;
		СтрокаПлатеж.СтавкаНДС=Результат.СтавкаНДС;
		СтрокаПлатеж.СтатьяДвиженияДенежныхСредств=Результат.СтатьяДвиженияДенежныхСредств;
		СтрокаПлатеж.ДокументПланированияПлатежа=Результат.ДокументПланированияПлатежа;
		СтрокаПлатеж.Проект=Результат.Проект;
		
		КоэффициентПересчета=?(Результат.СуммаДокумента=0,0,Результат.СуммаОстаток/Результат.СуммаДокумента);
		
		СтрокаПлатеж.СуммаПлатежа=Результат.СуммаПлатежа*КоэффициентПересчета;
		СтрокаПлатеж.СуммаВзаиморасчетов=Результат.СуммаВзаиморасчетов*КоэффициентПересчета;
		СтрокаПлатеж.СуммаНДС=Результат.СуммаНДС*КоэффициентПересчета;
		
	КонецЦикла;
	
	СуммаДокумента=РасшифровкаПлатежа.Итог("СуммаПлатежа");
		
КонецПроцедуры // ЗаполнитьПоРасчетномуДокументуУпр()

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("ДатаОплаты","Не указана дата оплаты документа банком!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплата()

// Формирует структуру полей, обязательных для заполнения при отражении операции во 
// взаиморасчетах
// Возвращаемое значение:
//   СтруктурахПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейРасчетыУпр()

	Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда

		СтруктураПолей = Новый Структура("Организация, Контрагент, Ответственный");
		СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");

	Иначе

		СтруктураПолей = Новый Структура("Организация, СуммаДокумента,Ответственный");
		СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");

	КонецЕсли;

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплата()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)

	Если ЗначениеНеЗаполнено(Значение) Тогда 

		ОшибкаПриПроведении("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);

	КонецЕсли;

КонецПроцедуры // ПроверитьЗначение()

// Проверяет заполнение табличной части документа
//
Процедура ПроверитьЗаполнениеТЧ(Отказ, Заголовок)

	Для Каждого Платеж Из РасшифровкаПлатежа Цикл

		ПроверитьЗначение(Платеж.ДоговорКонтрагента,Отказ, Заголовок,"Договор");
		ПроверитьЗначение(Платеж.СуммаВзаиморасчетов,Отказ, Заголовок,"Сумма взаиморасчетов");

		Если Не Отказ Тогда

			// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
			Если Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам
			 ИЛИ Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда

				ПроверитьЗначение(Платеж.Сделка, Отказ, Заголовок,"Сделка");
				Если Отказ Тогда
					Сообщить("По выбранному договору установлен способ ведения взаиморасчетов ""по заказам""! 
					|Заполните поле ""Сделка""!");
				КонецЕсли;

			КонецЕсли;

			Если Не ЗначениеНеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				СообщитьОбОшибке("Выбран договор контрагента, не соответстветствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТЧ

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Режим, Заголовок)

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа")= СуммаДокумента Тогда
		Сообщить(Заголовок+" 
		|не совпадают сумма документа и ее расшифровка.");

		Отказ = Истина;

	КонецЕсли;
	
	Если ОтраженоВОперУчете И Режим = РежимПроведенияДокумента.Оперативный И (ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам) Тогда
					
		КонтрольОстатковПоТЧ(Дата, РасшифровкаПлатежа, Отказ, Заголовок, Истина);			
		
	КонецЕсли;

	Если ОтраженоВОперУчете Тогда
		
		ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейРасчетыУпр(), Отказ, Заголовок);
		
		Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
			
			ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок)

	РасчетыВозврат=НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(ВидОперации);
	КоэффициентСторно=?(РасчетыВозврат=Перечисления.РасчетыВозврат.Возврат,-1,1);
	
	РасчетыСКонтрагентами = ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам;
		
	ДвиженияПоСтатьям=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоЗаявкам=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоРезерву=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоКонтрагентам=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияДенежныхСредств=ТаблицаПлатежейУпр.Скопировать();
	
	ДвиженияПоЗаявкам.Свернуть("ДокументПланированияПлатежа,ВключатьВПлатежныйКалендарь,ДоговорКонтрагента,Сделка,СтатьяДвиженияДенежныхСредств,Проект","СуммаПлатежа,СуммаВзаиморасчетов,СуммаПлатежаПлан,СуммаУпр");
	ДвиженияПоКонтрагентам.Свернуть("ДоговорКонтрагента,Сделка,ВидДоговора, КонтролироватьДенежныеСредстваКомитента","СуммаВзаиморасчетов,СуммаУпр,СуммаРегл");
	ДвиженияДенежныхСредств.Свернуть("ДокументПланированияПлатежа,ДоговорКонтрагента,Сделка,СтатьяДвиженияДенежныхСредств,Проект","СуммаПлатежа,СуммаУпр");
	ДвиженияПоСтатьям.Свернуть("СтатьяДвиженияДенежныхСредств","СуммаПлатежа");
	ДвиженияПоРезерву.Свернуть("ДокументПланированияПлатежа","СуммаПлатежаПлан");
	
	ДвиженияДенежныхСредств.Колонки["СуммаПлатежа"].Имя="Сумма";
		
	// По регистру "Денежные средства"
	НаборДвиженийОстатки 		= Движения.ДенежныеСредства;
	ТаблицаДвиженийОстатки 		= НаборДвиженийОстатки.Выгрузить();

	// По регистру "Денежные средства к списанию"
	НаборДвиженийСписание   = Движения.ДенежныеСредстваКСписанию;
	ТаблицаДвиженийСписание = НаборДвиженийСписание.Выгрузить();
	
	СтрокаКурсыВалют=ТаблицаПлатежейУпр[0];
							
	СуммаУпр = ПересчитатьИзВалютыВВалюту(СуммаДокумента, ВалютаДокумента,
			Константы.ВалютаУправленческогоУчета.Получить(), 
			СтрокаКурсыВалют.КурсДокумента,
			СтрокаКурсыВалют.КурсУпрУчета, 
			СтрокаКурсыВалют.КратностьДокумента,
			СтрокаКурсыВалют.КратностьУпрУчета);
				
	СтрокаДвиженийОстатки = ТаблицаДвиженийОстатки.Добавить();
	СтрокаДвиженийОстатки.БанковскийСчетКасса = СчетОрганизации;
	СтрокаДвиженийОстатки.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
	СтрокаДвиженийОстатки.Сумма               = СуммаДокумента;
	СтрокаДвиженийОстатки.СуммаУпр            = СуммаУпр;
		
	// По регистру "Денежные средства к списанию"
	Для Каждого СтрокаДвижение Из ДвиженияПоСтатьям Цикл
		
		СтрокаДвиженийСписание = ТаблицаДвиженийСписание.Добавить();
		СтрокаДвиженийСписание.БанковскийСчетКасса = СчетОрганизации;
		СтрокаДвиженийСписание.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвиженийСписание.Сумма               = СтрокаДвижение.СуммаПлатежа;
		СтрокаДвиженийСписание.ДокументСписания    = ?(РасчетныйДокумент=Неопределено,Ссылка,РасчетныйДокумент);
		СтрокаДвиженийСписание.СтатьяДвиженияДенежныхСредств=СтрокаДвижение.СтатьяДвиженияДенежныхСредств;
		
	КонецЦикла;
	
	НаборДвиженийОстатки.мПериод              = КонецДня(ДатаОплаты);
	НаборДвиженийОстатки.мТаблицаДвижений     = ТаблицаДвиженийОстатки;
	Движения.ДенежныеСредства.ВыполнитьРасход();
	
	НаборДвиженийСписание.мПериод              = КонецДня(ДатаОплаты);
	НаборДвиженийСписание.мТаблицаДвижений     = ТаблицаДвиженийСписание;
	Движения.ДенежныеСредстваКСписанию.ВыполнитьРасход();	

	Если ОтраженоВОперУчете И РасчетныйДокумент=Неопределено Тогда
		
		// По регистру "Денежные средства к списанию"
		НаборДвиженийДС   = Движения.ДенежныеСредстваКСписанию;
		ТаблицаДвиженийДС = НаборДвиженийДС.Выгрузить();
		ТаблицаДвиженийДС.Очистить();

		Для Каждого СтрокаДвижение Из ДвиженияПоСтатьям Цикл
			
			СтрокаДвиженийДС = ТаблицаДвиженийДС.Добавить();
			СтрокаДвиженийДС.БанковскийСчетКасса = СчетОрганизации;
			СтрокаДвиженийДС.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
			СтрокаДвиженийДС.Сумма               = СтрокаДвижение.СуммаПлатежа;
			СтрокаДвиженийДС.ДокументСписания    = Ссылка;
			СтрокаДвиженийДС.СтатьяДвиженияДенежныхСредств=СтрокаДвижение.СтатьяДвиженияДенежныхСредств;
			
		КонецЦикла;

		НаборДвиженийДС.мПериод              = Дата;
		НаборДвиженийДС.мТаблицаДвижений     = ТаблицаДвиженийДС;
		Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
		
		ЕстьРезерв=Ложь;
		ЕстьРазмещение=Ложь;
		ЕстьЗаявка=Ложь;
		ЕстьРасчеты=Ложь;
		
		// По регистру "Денежные средства в резерве"
		НаборДвиженийРезерв   = Движения.ДенежныеСредстваВРезерве;
		ТаблицаДвиженийРезерв = НаборДвиженийРезерв.Выгрузить();
		ТаблицаДвиженийРезерв.Очистить();
		
		// По регистру "Размещение заявок на расходование средств"
		НаборДвиженийРазмещение  = Движения.РазмещениеЗаявокНаРасходованиеСредств;
		ТаблицаДвиженийРазмещение = НаборДвиженийРазмещение.Выгрузить();
		ТаблицаДвиженийРазмещение.Очистить();
		
		// По регистру "Заявки на расходование средств"
		НаборДвиженийЗаявки   = Движения.ЗаявкиНаРасходованиеСредств;
		ТаблицаДвиженийЗаявки = НаборДвиженийЗаявки.Выгрузить();
		ТаблицаДвиженийЗаявки.Очистить();
		
		// Проверим необходимость списания суммы платежного поручения по заявкам из регистра "ДенежныеСредстваРезерв"
		Для Каждого СтрокаЗаявка Из ДвиженияПоРезерву Цикл
			
			Если НЕ СтрокаЗаявка.ДокументПланированияПлатежа.Пустая() Тогда
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ДокументЗаявка",СтрокаЗаявка.ДокументПланированияПлатежа);
				Запрос.УстановитьПараметр("БанковскийСчетКасса",СчетОрганизации);
				Запрос.Текст = "ВЫБРАТЬ
				|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК СуммаОстаток
				|ИЗ
				|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(, ДокументРезервирования = &ДокументЗаявка И БанковскийСчетКасса=&БанковскийСчетКасса) КАК ДенежныеСредстваВРезервеОстатки";
				Результат = Запрос.Выполнить().Выбрать();
				
				Если Результат.Следующий() И (НЕ Результат.СуммаОстаток=NULL) Тогда
					
					СтрокаДвижений = ТаблицаДвиженийРезерв.Добавить();
					СтрокаДвижений.БанковскийСчетКасса = СчетОрганизации;
					СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
					СтрокаДвижений.Сумма               = ?(Результат.СуммаОстаток <СтрокаЗаявка.СуммаПлатежаПлан,Результат.СуммаОстаток,СтрокаЗаявка.СуммаПлатежаПлан);
					СтрокаДвижений.ДокументРезервирования = СтрокаЗаявка.ДокументПланированияПлатежа;
					
					ЕстьРезерв=Истина;
					
				КонецЕсли;
				
				Запрос=Новый Запрос;
				Запрос.Текст="ВЫБРАТЬ
				|	РазмещениеЗаявок.ДокументПланирования КАК ДокументПланирования,
				|	РазмещениеЗаявок.СуммаОстаток КАК СуммаОстаток,
				// Ранжируем планиуемые поступления для закрытия. Первыми закрывается размещение по планируемым поступлениям,
				// у которых совпадает счет, затем форма оплаты, затем организация.
				|	(ВЫБОР КОГДА РазмещениеЗаявок.ДокументПланирования.БанковскийСчетКасса=&СчетОрганизации
				|		Тогда 4
				|	Иначе 0
				|	Конец
				|  + ВЫБОР КОГДА РазмещениеЗаявок.ДокументПланирования.ФормаОплаты=&ФормаОплаты
				|		Тогда 2
				|	Иначе 0
				|	Конец
				|  + ВЫБОР КОГДА РазмещениеЗаявок.ДокументПланирования.Организация=&Организация
				|		Тогда 1
				|	Иначе 0
				|	Конец) КАК Релевантность,
				|	РазмещениеЗаявок.ДокументПланирования.ДатаПоступления КАК ДатаПоступления
				|ИЗ
				|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(, ДокументРезервирования=&ДокументРезервирования) КАК РазмещениеЗаявок
				|ГДЕ НЕ((РазмещениеЗаявок.СуммаОстаток) ЕСТЬ NULL )";
				
				Запрос.УстановитьПараметр("СчетОрганизации",СчетОрганизации);
				Запрос.УстановитьПараметр("ФормаОплаты",Перечисления.ВидыДенежныхСредств.Безналичные);
				Запрос.УстановитьПараметр("Организация",Организация);
				Запрос.УстановитьПараметр("ДокументРезервирования",СтрокаЗаявка.ДокументПланированияПлатежа);
				
				ТабРазмещение=Запрос.Выполнить().Выгрузить();
				
				ТабРазмещение.Сортировать("Релевантность Убыв,ДатаПоступления Возр");
				
				СуммаКСписанию=СтрокаЗаявка.СуммаПлатежаПлан;
				
				Для Каждого Строка Из ТабРазмещение Цикл
					
					ЕстьРазмещение=Истина;
					
					СтрокаДвижение=ТаблицаДвиженийРазмещение.Добавить();
					СтрокаДвижение.ДокументПланирования=Строка.ДокументПланирования;
					СтрокаДвижение.ДокументРезервирования=СтрокаЗаявка.ДокументПланированияПлатежа;
					
					Если Строка.СуммаОстаток>=СуммаКСписанию Тогда
						
						СтрокаДвижение.Сумма=СуммаКСписанию;
						Прервать;
						
					Иначе
						
						СтрокаДвижение.Сумма=Строка.СуммаОстаток;
						СуммаКСписанию=СуммаКСписанию-Строка.СуммаОстаток;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьРезерв тогда
			
			НаборДвиженийРезерв.мПериод          = Дата;
			НаборДвиженийРезерв.мТаблицаДвижений = ТаблицаДвиженийРезерв;	
			Движения.ДенежныеСредстваВРезерве.ВыполнитьРасход();
			
		КонецЕсли;
		
		Если ЕстьРазмещение Тогда
			
			НаборДвиженийРазмещение.мПериод          = Дата;
			НаборДвиженийРазмещение.мТаблицаДвижений = ТаблицаДвиженийРазмещение;	
			Движения.РазмещениеЗаявокНаРасходованиеСредств.ВыполнитьРасход();
			
		КонецЕсли;
					
		//+++ 01.04.2019 ВЫКЛЮЧЕНО движение по регистру "РасчетыСКонтрагентами"
		//НаборДвиженийКонтрагенты   = Движения.РасчетыСКонтрагентами;
		//ТаблицаДвиженийКонтрагенты = НаборДвиженийКонтрагенты.Выгрузить();
		//ТаблицаДвиженийКонтрагенты.Очистить();
		
		// По строкам табличной части
		Для Каждого СтрокаПлатеж ИЗ ДвиженияПоЗаявкам Цикл
			
			ТекущаяСделка = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
							
			Если НЕ СтрокаПлатеж.ДокументПланированияПлатежа.Пустая() Тогда
								
				СуммаПлатежа=СтрокаПлатеж.СуммаПлатежаПлан;											
				СтрокаДвиженийЗаявки = ТаблицаДвиженийЗаявки.Добавить();
				СтрокаДвиженийЗаявки.СуммаУпр            			= СтрокаПлатеж.СуммаУпр;
				СтрокаДвиженийЗаявки.Сумма                			= СтрокаПлатеж.СуммаПлатежаПлан;
				СтрокаДвиженийЗаявки.СуммаВзаиморасчетов  			= СтрокаПлатеж.СуммаВзаиморасчетов;
				СтрокаДвиженийЗаявки.ЗаявкаНаРасходование 			= СтрокаПлатеж.ДокументПланированияПлатежа;
				СтрокаДвиженийЗаявки.СтатьяДвиженияДенежныхСредств 	= СтрокаПлатеж.СтатьяДвиженияДенежныхСредств;
				СтрокаДвиженийЗаявки.Проект						 	= СтрокаПлатеж.Проект;
				СтрокаДвиженийЗаявки.ДоговорКонтрагента				= СтрокаПлатеж.ДоговорКонтрагента;
				СтрокаДвиженийЗаявки.Сделка							= СтрокаПлатеж.Сделка;
				
				ЕстьЗаявка = Истина;
				
				//Если НЕ СтрокаПлатеж.ВключатьВПлатежныйКалендарь Тогда // Документ не был проведен по оперативным взаиморасчетам
				//	ЕстьРасчеты=Истина;
				//КонецЕсли;
				
			КонецЕсли;
			
		//+++ 01.04.2019 ВЫКЛЮЧЕНО	движение по регистру "РасчетыСКонтрагентами"
		  // Если ((Не ЕстьЗаявка) ИЛИ ЕстьРасчеты) И РасчетыСКонтрагентами Тогда // Первое упоминание о планируемом платеже в системе
		  //  	СтрокаДвиженийКонтрагенты = ТаблицаДвиженийКонтрагенты.Добавить();
		  //  	СтрокаДвиженийКонтрагенты.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
		  //  	СтрокаДвиженийКонтрагенты.РасчетыВозврат      = РасчетыВозврат;
		  //  	СтрокаДвиженийКонтрагенты.Сделка              = ?(ЗначениеНеЗаполнено(СтрокаПлатеж.Сделка),ТекущаяСделка,СтрокаПлатеж.Сделка);
		  //  	СтрокаДвиженийКонтрагенты.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно;
		  //  	СтрокаДвиженийКонтрагенты.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
		  //  	ЕстьРасчеты = Истина;
		  //  КонецЕсли;
			
		КонецЦикла;
				
		Если ЕстьЗаявка Тогда
			
			НаборДвиженийЗаявки.мПериод          = Дата;
			НаборДвиженийЗаявки.мТаблицаДвижений = ТаблицаДвиженийЗаявки;
			Движения.ЗаявкиНаРасходованиеСредств.ВыполнитьРасход();
			
		КонецЕсли;
		
	//01.04.2019
		//Если ЕстьРасчеты Тогда
		//	НаборДвиженийКонтрагенты.мПериод          = Дата;
		//	НаборДвиженийКонтрагенты.мТаблицаДвижений = ТаблицаДвиженийКонтрагенты;
		//	Если КоэффициентСторно=1 Тогда
		//		Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
		//	Иначе
		//		Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
		//	КонецЕсли;
		//КонецЕсли;
		
	КонецЕсли;

	Если ОтраженоВОперУчете Тогда  // Проводим по фактическим взаиморасчетам

		// По регистру "Движения денежных средств"
		НаборДвижений = Движения.ДвиженияДенежныхСредств;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ДвиженияДенежныхСредств, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.ВидыДенежныхСредств.Безналичные,"ВидДенежныхСредств");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.ВидыДвиженийПриходРасход.Расход,"ПриходРасход");
		ТаблицаДвижений.ЗаполнитьЗначения(СчетОрганизации,"БанковскийСчетКасса");
		ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,"ДокументДвижения");
		ТаблицаДвижений.ЗаполнитьЗначения(Контрагент,"Контрагент");
				
		НаборДвижений.мПериод            = КонецДня(ДатаОплаты);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
	
		Если РасчетыСКонтрагентами Тогда
			
			// По регистрам взаиморасчетов с покукпателями и поставщиками для НДС.
			// Движение делается только если документ отражается в БУ.
			Если ОтражатьВБухгалтерскомУчете Тогда

				// Для целей НДС проводим платежи только по операциям с поставщиком и покупателем.
				Если ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ОплатаПоставщику Тогда

					НаборДвиженийСПоставщиками   = Движения.ВзаиморасчетыСПоставщикамиДляНДС;
					ТаблицаДвиженийСПоставщиками = НаборДвиженийСПоставщиками.Выгрузить();

					// По строкам табличной части.
					Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл

						СтрокаДвижений = ТаблицаДвиженийСПоставщиками.Добавить();
						СтрокаДвижений.Организация         = Организация;
						СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
						СтрокаДвижений.Сделка              = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
						СтрокаДвижений.Сумма               = СтрокаПлатеж.СуммаРегл;

					КонецЦикла;

					НаборДвиженийСПоставщиками.мПериод            = КонецДня(ДатаОплаты);
					НаборДвиженийСПоставщиками.мТаблицаДвижений   = ТаблицаДвиженийСПоставщиками;

					Движения.ВзаиморасчетыСПоставщикамиДляНДС.ВыполнитьРасход();

				ИначеЕсли ВидОперации = Перечисления.ВидыОперацийСписаниеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПокупателю Тогда

					НаборДвиженийСПокупателями   = Движения.ВзаиморасчетыСПокупателямиДляНДС;
					ТаблицаДвиженийСПокупателями = НаборДвиженийСПокупателями.Выгрузить();

					// По строкам табличной части.
					Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл

						СтрокаДвижений = ТаблицаДвиженийСПокупателями.Добавить();
						СтрокаДвижений.Организация         = Организация;
						СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
						СтрокаДвижений.Сделка              = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);;
						СтрокаДвижений.Сумма               = (-1) * СтрокаПлатеж.СуммаРегл;

					КонецЦикла;

					НаборДвиженийСПокупателями.мПериод            = КонецДня(ДатаОплаты);
					НаборДвиженийСПокупателями.мТаблицаДвижений   = ТаблицаДвиженийСПокупателями;

					Движения.ВзаиморасчетыСПокупателямиДляНДС.ВыполнитьРасход();

				КонецЕсли;

			КонецЕсли;

			// По регистру "ВзаиморасчетыСКонтрагентами"
			НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;
			ТаблицаДвижений = НаборДвижений.Выгрузить();

			// По регистру "ДенежныеСредстваКомитента"
			
			ЕстьРасчетыСКомитентом=Ложь;
			НаборДвиженийКомитент = Движения.ДенежныеСредстваКомитента;
			ТаблицаДвиженийКомитент = НаборДвиженийКомитент.Выгрузить();
		
			// По строкам табличной части
			Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл

				ТекущаяСделка = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);

				СтрокаДвижений = ТаблицаДвижений.Добавить();
				СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
				СтрокаДвижений.Сделка              = ТекущаяСделка;
				СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно;
				СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
				
				Если СтрокаПлатеж.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом
					И СтрокаПлатеж.КонтролироватьДенежныеСредстваКомитента Тогда
					
					СтрокаДвиженийКомитент = ТаблицаДвиженийКомитент.Добавить();
					СтрокаДвиженийКомитент.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
					СтрокаДвиженийКомитент.Сделка              = ТекущаяСделка;
					СтрокаДвиженийКомитент.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно;
					СтрокаДвиженийКомитент.СуммаУпр            = СуммаУпр*КоэффициентСторно;
					
					ЕстьРасчетыСКомитентом=Истина;
					
				КонецЕсли;
		   
			КонецЦикла;

			НаборДвижений.мПериод            = КонецДня(ДатаОплаты);
			НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
			
			Если КоэффициентСторно=1 Тогда
				
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьПриход();
				
			Иначе
				
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
				
			КонецЕсли;
			
			Если ЕстьРасчетыСКомитентом Тогда
				
				НаборДвиженийКомитент.мПериод          = КонецДня(ДатаОплаты);
				НаборДвиженийКомитент.мТаблицаДвижений = ТаблицаДвижений;
				
				Если КоэффициентСторно=1 Тогда
					
					Движения.ДенежныеСредстваКомитента.ВыполнитьРасход();
					
				Иначе
					
					Движения.ДенежныеСредстваКомитента.ВыполнитьПриход();
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	// Затраты (Чарчан)
	Если  ОтражатьВЗатратах  Тогда		
		Если (ИтогоЗатрат<>0) и (СуммаДокумента<>ИтогоЗатрат) Тогда 
			Отказ = Истина;
			Сообщить("Не совпадают сумма затрат и сумма документа.", СтатусСообщения.Важное);
		КонецЕсли;
		ТаблицаЗатрат = СформироватьТаблицуЗатрат();
		ИтогоЗатрат = СформироватьИтогПоЗатратам();
		Если (ТаблицаЗатрат.Количество()>0) Тогда 
			Для Каждого Стр из ТаблицаЗатрат Цикл
				НаборДвижений   = Движения.Затраты.Добавить();
				Если (Стр.Подразделение = Справочники.Подразделения.ПустаяСсылка()) Тогда 
					Отказ = Истина;
					Сообщить("В табличной части ""Затраты"" пропущено подразделение.", СтатусСообщения.Важное);
				КонецЕсли;	
				Если (Стр.СтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка()) Тогда 
					Отказ = Истина;
					Сообщить("В табличной части ""Затраты"" пропущена статья.", СтатусСообщения.Важное);
				КонецЕсли;	
				Если ((Стр.Сумма = 0) или (Стр.Сумма = Неопределено)) Тогда 
					Отказ = Истина;
					Сообщить("В табличной части ""Затраты"" пропущена сумма.", СтатусСообщения.Важное)
				КонецЕсли;	
				//Адиянов<<< Начало СтатьяЗатратУпр
				Если (Стр.СтатьяЗатратУпр = Справочники.СтатьиЗатратУПР.ПустаяСсылка()) Тогда 
					Сообщить("В табличной части ""Затраты"" пропущена статья затрат УПР.", СтатусСообщения.Важное);
				КонецЕсли;	
				//Адиянов>>> Конец СтатьяЗатратУпр
				
				НаборДвижений.Подразделение   = Стр.Подразделение;
				НаборДвижений.СтатьяЗатрат    = Стр.СтатьяЗатрат;
				НаборДвижений.Сумма           = Стр.Сумма;
				НаборДвижений.Период          = Дата;
				//Адиянов<<< Начало СтатьяЗатратУпр
				НаборДвижений.СтатьяЗатратУпр = Стр.СтатьяЗатратУпр;
				//Адиянов>>> Конец СтатьяЗатратУпр
				Движения.Затраты .Записать();
			КонецЦикла;		
		КонецЕсли;
		
	КонецЕсли;	
    ////
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание=неопределено)
	Если Основание=неопределено тогда //23.08.2016
		возврат;
	КонецЕсли;	
	Если ЕстьРеквизитДокумента("Оплачено",Основание.Метаданные()) Тогда
		
		Если Основание.Оплачено Тогда
			Сообщить("Платежный ордер не вводится на основании документов, уже исполненных банком.");
			Возврат;
		КонецЕсли;
		
		РасчетныйДокумент = Основание.Ссылка;
		ЗаполнитьПоРасчетномуДокументуУпр();
		
	Иначе
		
		ЗаполнитьРасходПоОснованию(ЭтотОбъект, Основание, глТекущийПользователь);
		
	КонецЕсли;
		
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)
		
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураКурсаДокумента = ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
		
	ЕстьРасчетыСКонтрагентами=ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=ЕстьРасчетыПоКредитам(ВидОперации);
				
	ПроверитьЗаполнениеДокументаУпр(Отказ, Режим, Заголовок);
	
	ТаблицаПлатежейУпр=ПолучитьТаблицуПлатежейУпр(Дата,ВалютаДокумента,Ссылка, "ПлатежныйОрдерСписаниеДенежныхСредств");
	
	// Проверим на возможность проведения в БУ и НУ
	Если ОтражатьВБухгалтерскомУчете или ОтражатьВНалоговомУчете тогда
		
		НомерСтроки=1;
		
		Для каждого СтрокаОплаты из ТаблицаПлатежейУпр Цикл
			
			Если ТаблицаПлатежейУпр.Количество()=1 Тогда
				ДополнениеЗаголовка="";
			Иначе
				ДополнениеЗаголовка="Строка "+НомерСтроки+" - ";
				НомерСтроки=НомерСтроки+1;
			КонецЕсли;
			
			ПроверкаВозможностиПроведенияВ_БУ_НУ(СтрокаОплаты.ДоговорКонтрагента, ВалютаДокумента,ОтражатьВБухгалтерскомУчете,
					ОтражатьВНалоговомУчете, мВалютаРегламентированногоУчета, Истина ,Отказ, Заголовок, ДополнениеЗаголовка,
					СтрокаОплаты.ВалютаВзаиморасчетов, СтрокаОплаты.РасчетыВУсловныхЕдиницах);
					
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Проверить заполнение подразделения, если нужно. 
	Если (Константы.ОбязательнаяУстановкаПодразделений.Получить() = Истина) Тогда 
		Если (Подразделение = Справочники.Подразделения.ПустаяСсылка()) Тогда 
			Отказ = Истина;
			Сообщить("Перед проведением, установите подразделение.", СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрамУпр(Режим, Отказ, Заголовок);
	КонецЕсли;
	
	Если (Не РасчетныйДокумент=Неопределено) И (Не Отказ) И (НЕ РасчетныйДокумент.ЧастичнаяОплата) Тогда
		
		ИзменяемыйДокумент=РасчетныйДокумент.ПолучитьОбъект();	
		ИзменяемыйДокумент.ЧастичнаяОплата=Истина;
		ИзменяемыйДокумент.Записать(РежимЗаписиДокумента.Запись);
		
	КонецЕсли;

	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Проверим необходимость снятия флага частичной оплаты у расчетного документа
	
	Если Не РасчетныйДокумент=Неопределено Тогда	
		
		Запрос=Новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка
		|ИЗ
		|	Документ.ПлатежныйОрдерСписаниеДенежныхСредств КАК ПлатежныйОрдерСписаниеДенежныхСредств
		|
		|ГДЕ
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Ссылка <> &Ссылка И
		|  ПлатежныйОрдерСписаниеДенежныхСредств.РасчетныйДокумент=&РасчетныйДокумент И
		|	ПлатежныйОрдерСписаниеДенежныхСредств.Проведен";
		
		Запрос.УстановитьПараметр("Ссылка",Ссылка);
		Запрос.УстановитьПараметр("РасчетныйДокумент",РасчетныйДокумент);
		
		Результат=Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			
			ИзменяемыйДокумент=РасчетныйДокумент.ПолучитьОбъект();
			ИзменяемыйДокумент.ЧастичнаяОплата=Ложь;
			ИзменяемыйДокумент.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЕсли;
				
	КонецЕсли;

КонецПроцедуры

Функция СформироватьИтогПоЗатратам() Экспорт
	
	Итого = Затраты.Итог("Сумма");
	Если (Итого=0 и Подразделение<>Справочники.Подразделения.ПустаяСсылка()) Тогда 
		Итого = СуммаДокумента;
	КонецЕсли;
	Если (ИтогоЗатрат <> Итого) Тогда 
		ИтогоЗатрат = Итого;	
	КонецЕсли;
	
	Возврат Итого;
	
КонецФункции

Функция СформироватьТаблицуЗатрат()
	
	ТаблицаЗатрат = Затраты.Выгрузить();
	//Адиянов<<< Начало СтатьяЗатратУпр
	//{{ТаблицаЗатрат.Свернуть("Подразделение,СтатьяЗатрат","Сумма");
	ТаблицаЗатрат.Свернуть("Подразделение,СтатьяЗатрат,СтатьяЗатратУпр","Сумма");
	//Адиянов>>> Конец СтатьяЗатратУпр
	
	Возврат ТаблицаЗатрат;
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//Адиянов<<<
	Если НЕ Отказ Тогда
		ПроверкаЗаполненияСтатьиЗатратУпр(ЭтотОбъект,Отказ);
	КонецЕсли; 		
	//Адиянов>>>

	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
