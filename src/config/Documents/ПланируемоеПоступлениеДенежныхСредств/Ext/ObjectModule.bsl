﻿Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

/// Процедура выполняет заполнение суммы документа,
// по регистру "СуммыЗаказов".
//
// Параметры:
//  ДокументОснование  - документ ссылка (Заказ покупателя, Заказ поставщику).
//  ВалютаДокумента    - валюта документа (валюта регламентированного учета организаций)
//  КурсВзаиморасчетов - курс взаиморасчетов по договору
//  КратностьВзаиморасчетов - кратность взаиморасчетов по договору
//
Процедура ЗаполнитьПоЗаказуУпр(СтрокаПлатеж)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Заказ", ДокументОснование);
	Запрос.Текст ="ВЫБРАТЬ
	|	РасчетыСКонтрагентамиОстатки.Сделка Как Сделка,
	|	РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентами.Остатки(, Сделка = &Заказ) КАК РасчетыСКонтрагентамиОстатки";
	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Если Выборка.Следующий() Тогда

		СтрокаПлатеж.Сделка = Выборка.Сделка;

		Если Выборка.Сумма > 0 Тогда

			СтрокаПлатеж.СуммаВзаиморасчетов = Выборка.Сумма;
			СуммаДокумента = ПересчитатьИзВалютыВВалюту(Выборка.Сумма,
			                            СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, 
			                            ВалютаДокумента,
			                            СтрокаПлатеж.КурсВзаиморасчетов, КурсДокумента,
			                            СтрокаПлатеж.КратностьВзаиморасчетов, КратностьДокумента);
			СтрокаПлатеж.СуммаПлатежа = СуммаДокумента;

	КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоЗаказуУпр()

Процедура ЗаполнитьПоРозничнойВыручкеУпр(СтрокаПлатеж)

	Запрос = Новый Запрос;
	Если ДокументОснование.ВидОперации = Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах Тогда
		Запрос.УстановитьПараметр("РозничнаяТочка", ДокументОснование.КассаККМ);
	Иначе
		Запрос.УстановитьПараметр("РозничнаяТочка", ДокументОснование.Склад);
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	СуммаОстаток
	|ИЗ
	|	РегистрНакопления.РозничнаяВыручка.Остатки(, РозничнаяТочка = &РозничнаяТочка)
	|ГДЕ
	|	СуммаОстаток > 0  
	|";

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		СуммаДокумента = Мин(ПересчитатьИзВалютыВВалюту(Выборка.СуммаОстаток, 
		                                мВалютаРегламентированногоУчета, ВалютаДокумента,
		                                1, КурсДокумента, 1, КратностьДокумента),
		                                ПересчитатьИзВалютыВВалюту(ДокументОснование.СуммаДокумента,  мВалютаРегламентированногоУчета, ВалютаДокумента,
		                                1, КурсДокумента, 1, КратностьДокумента));
		СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;
		СтрокаПлатеж.СуммаВзаиморасчетов=СуммаДокумента;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоРозничнойВыручкеУпр()

// Процедура выполняет заполнение суммы документа,
// суммы взаиморасчетов по регистру "ВзаиморачетыСКонтрагентами".
//
Процедура ЗаполнитьПоВзаиморасчетамУпр(СтрокаПлатеж)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДоговорКонтрагента", СтрокаПлатеж.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Сделка", СтрокаПлатеж.Сделка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СуммаВзаиморасчетовОстаток КАК СуммаДолга // в валюте взаиморасчетов
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(,
	|	                                                      ДоговорКонтрагента = &ДоговорКонтрагента
	|	                                                    И Сделка = &Сделка)
	|ГДЕ
	|	СуммаВзаиморасчетовОстаток > 0
	|";
	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда

		СтрокаПлатеж.СуммаВзаиморасчетов=Выборка.СуммаДолга;
		СуммаДокумента = ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаВзаиморасчетов, 
				СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, ВалютаДокумента,
				СтрокаПлатеж.КурсВзаиморасчетов, КурсДокумента,
				СтрокаПлатеж.КратностьВзаиморасчетов, КратностьДокумента);

		СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;

	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоВзаиморасчетамУпр()

/// Возвращает структуру, содержащую поля шапки, обязательные для заполнения
//
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей - структура с именами реквизитов шапки
//
Функция СтруктураОбязательныхПолейШапка()
	
	Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда		
		СтруктураПолей= Новый Структура("Контрагент, 
		|Ответственный,Состояние");					
	Иначе 		
		СтруктураПолей= Новый Структура("Ответственный,Состояние,ВалютаДокумента");	
	КонецЕсли;
			
	Возврат СтруктураПолей;
	
КонецФункции // СтруктураОбязательныхПолейШапка()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если ЗначениеНеЗаполнено(Значение) Тогда 
		
		ОшибкаПриПроведении("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение())

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
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,"Сделка");
				Если Отказ Тогда
					Сообщить("По выбранному договору установлен способ ведения взаиморасчетов ""по заказам (счетам)""! 
					|Заполните поле ""Сделка""!");
				КонецЕсли;
				
			КонецЕсли;

			Если Не ЗначениеНеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				СообщитьОбОшибке("Выбран договор контрагента, не соответстветствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;

		КонецЕсли;
		
		Если ВключатьВПлатежныйКалендарь Тогда
			ПроверитьЗначение(Платеж.СуммаПлатежа,Отказ, Заголовок,"Сумма платежа");
        КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТЧ

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураКурсыВалют)

	РасчетыВозврат=НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(ВидОперации);
	КоэффициентСторно=?(РасчетыВозврат=Перечисления.РасчетыВозврат.Возврат,-1,1);
	
	// По регистру "ПланируемыеПоступленияДенежныхСредств"
	
	НаборДвиженийПлан = Движения.ПланируемыеПоступленияДенежныхСредств;
	ТаблицаДвиженийПлан = НаборДвиженийПлан.Выгрузить();
	ТаблицаДвиженийПлан.Очистить();
	
	// По регистру "РасчетыСКонтрагентами"	
	НаборДвиженийКонтрагенты = Движения.РасчетыСКонтрагентами;
	ТаблицаДвиженийКонтрагенты = НаборДвиженийКонтрагенты.Выгрузить();
	ТаблицаДвиженийКонтрагенты.Очистить();
	
	Для Каждого Платеж Из РасшифровкаПлатежа Цикл
		
		Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
			ВалютаВзаиморасчетов= Платеж.ДоговорКонтрагента.ВалютаВзаиморасчетов;
		Иначе
			ВалютаВзаиморасчетов=ВалютаДокумента;
		КонецЕсли;
			
		СтруктураКурсВзаиморасчетов=ПолучитьКурсВалюты(ВалютаВзаиморасчетов,?(ДатаПоступления='00010101',Дата,ДатаПоступления));
				
		СуммаУпр = ПересчитатьИзВалютыВВалюту(Платеж.СуммаВзаиморасчетов,ВалютаВзаиморасчетов,, 
												СтруктураКурсВзаиморасчетов.Курс,
												СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
												СтруктураКурсВзаиморасчетов.Кратность,
												СтруктураКурсыВалют.ВалютаУпрУчетаКратность);

		
		СтрокаДвиженийПлан = ТаблицаДвиженийПлан.Добавить();
		СтрокаДвиженийПлан.ДоговорКонтрагента           			= Платеж.ДоговорКонтрагента;
		СтрокаДвиженийПлан.Сделка 									= Платеж.Сделка;
		СтрокаДвиженийПлан.СуммаВзаиморасчетов      				= Платеж.СуммаВзаиморасчетов;
		СтрокаДвиженийПлан.СуммаУпр    								= СуммаУпр;
		СтрокаДвиженийПлан.Сумма    								= Платеж.СуммаПлатежа;
		СтрокаДвиженийПлан.ДокументПланирования			        	= Ссылка;
		СтрокаДвиженийПлан.СтатьяДвиженияДенежныхСредств          	= Платеж.СтатьяДвиженияДенежныхСредств;
		СтрокаДвиженийПлан.Проект						          	= Платеж.Проект;
		
		Если (ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам) И ВключатьВПлатежныйКалендарь Тогда
								
			СтрокаДвиженийКонтрагенты = ТаблицаДвиженийКонтрагенты.Добавить();
			СтрокаДвиженийКонтрагенты.ДоговорКонтрагента    		= Платеж.ДоговорКонтрагента;
			СтрокаДвиженийКонтрагенты.РасчетыВозврат           		= РасчетыВозврат;	
			СтрокаДвиженийКонтрагенты.Сделка			 			= Платеж.Сделка;
			СтрокаДвиженийКонтрагенты.СуммаВзаиморасчетов      		= Платеж.СуммаВзаиморасчетов*КоэффициентСторно;
			СтрокаДвиженийКонтрагенты.СуммаУпр    					= СуммаУпр*КоэффициентСторно;
				
		КонецЕсли;
		
	КонецЦикла;
	
	НаборДвиженийПлан.мПериод            = ?(ДатаПоступления='00010101',Дата,ДатаПоступления);
	НаборДвиженийПлан.мТаблицаДвижений   = ТаблицаДвиженийПлан;	
	Движения.ПланируемыеПоступленияДенежныхСредств.ВыполнитьПриход();
	
	Если (ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам) И ВключатьВПлатежныйКалендарь Тогда
										
		НаборДвиженийКонтрагенты.мПериод            = ?(ДатаПоступления='00010101',Дата,ДатаПоступления);
		НаборДвиженийКонтрагенты.мТаблицаДвижений   = ТаблицаДвиженийКонтрагенты;
		
		Если КоэффициентСторно=1 Тогда
			
			Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
			
		Иначе
			
			Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок)
	
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейШапка(), Отказ, Заголовок);
	
	Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
		
		ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
		
	КонецЕсли;

КонецПроцедуры

Функция СформироватьСтруктуруКурсыВалютУпр()

	СтруктураГруппаВалют = Новый Структура;
	СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",  Константы.ВалютаУправленческогоУчета.Получить().Код);
	СтруктураГруппаВалют.Вставить("ВалютаДокумента", ВалютаДокумента.Код);

	СтруктураКурсыВалют=ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,?(ДатаПоступления='00010101',Дата,ДатаПоступления));

	Возврат СтруктураКурсыВалют;

КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

	ДокументОснование= Основание.Ссылка;
	СтрокаПлатеж     = РасшифровкаПлатежа.Добавить();
	СпособЗаполнения = "Не заполнять";

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") 
		ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда

		ДатаПоступления=Основание.ДатаОплаты;
		
		СтрокаПлатеж.ДоговорКонтрагента   = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
		
		Если (ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя"))
			И (СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
			ИЛИ СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам) Тогда
			
			СтрокаПлатеж.Сделка=Основание;
			
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") И СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
			
			СтрокаПлатеж.Сделка=Основание;
			
		КонецЕсли;

		ВидОперации = Перечисления.ВидыОперацийПланируемоеПоступлениеДС.ОплатаПокупателя;

		Если НЕ ЗначениеНеЗаполнено(Основание.СтруктурнаяЕдиница) Тогда
			
			Если ТипЗнч(Основание.СтруктурнаяЕдиница)=Тип("СправочникСсылка.Кассы") Тогда
				ФормаОплаты=Перечисления.ВидыДенежныхСредств.Наличные;
			Иначе
				ФормаОплаты=Перечисления.ВидыДенежныхСредств.Безналичные;
			КонецЕсли;
			
			БанковскийСчетКасса = Основание.СтруктурнаяЕдиница;
		Иначе
			ФормаОплаты=Перечисления.ВидыДенежныхСредств.Наличные;
			БанковскийСчетКасса = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяКасса");
		КонецЕсли;

		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") И Основание.Проведен  Тогда
			СпособЗаполнения = "По заказу";
		Иначе
			СпособЗаполнения = "По сумме документа";
		КонецЕсли;

		СтруктураКурсаДокумента = ПолучитьКурсВалюты(ВалютаДокумента,ДатаПоступления);
		КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КратностьДокумента      = СтруктураКурсаДокумента.Кратность;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		 или (ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах")) Тогда

		СтрокаПлатеж.ДоговорКонтрагента   = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

		ВидОперации = Перечисления.ВидыОперацийПланируемоеПоступлениеДС.ОплатаПокупателя;

		Если НЕ ЗначениеНеЗаполнено(Контрагент.ОсновнойБанковскийСчет) Тогда
			СчетКонтрагента = Контрагент.ОсновнойБанковскийСчет;
		КонецЕсли;

		СчетОрганизации     = Организация.ОсновнойБанковскийСчет;

		Если СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда
			СтрокаПлатеж.Сделка = Основание;
			Если Основание.Проведен Тогда
				СпособЗаполнения = "По взаиморасчетам";
			КонецЕсли;
		Иначе
			СтрокаПлатеж.Сделка = Основание.Сделка;
			Если Основание.Проведен Тогда
				СпособЗаполнения = "По сумме документа";
			КонецЕсли;
		КонецЕсли;

		Если НЕ СчетОрганизации.Пустая() Тогда
			ВалютаДокумента = СчетОрганизации.ВалютаДенежныхСредств;
		Иначе
			ВалютаДокумента = мВалютаРегламентированногоУчета;
		КонецЕсли;

		СтруктураКурсаДокумента = ПолучитьКурсВалюты(ВалютаДокумента,Дата);
		КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КратностьДокумента      = СтруктураКурсаДокумента.Кратность;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда

		ВидОперации = Перечисления.ВидыОперацийПланируемоеПоступлениеДС.ВозвратДенежныхСредствПоставщиком;
		Контрагент  = Основание.Контрагент;

		СтрокаПлатеж.ДоговорКонтрагента   = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

		Если НЕ ЗначениеНеЗаполнено(Контрагент.ОсновнойБанковскийСчет) Тогда
			СчетКонтрагента = Контрагент.ОсновнойБанковскийСчет;
		КонецЕсли;

		СчетОрганизации     = Организация.ОсновнойБанковскийСчет;

		Если СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = 
				                    Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда
			СтрокаПлатеж.Сделка = Основание;
			Если Основание.Проведен Тогда
				СпособЗаполнения = "По взаиморасчетам";
			КонецЕсли;
		Иначе
			СтрокаПлатеж.Сделка = Основание.Сделка;
			Если Основание.Проведен Тогда
				СпособЗаполнения = "По сумме документа";
			КонецЕсли;
		КонецЕсли;

		Если НЕ СчетОрганизации.Пустая() Тогда
			ВалютаДокумента=СчетОрганизации.ВалютаДенежныхСредств;
		Иначе
			ВалютаДокумента=мВалютаРегламентированногоУчета;
		КонецЕсли;

		СтруктураКурсаДокумента = ПолучитьКурсВалюты(ВалютаДокумента,Дата);
		КурсДокумента           = СтруктураКурсаДокумента.Курс;
		КратностьДокумента      = СтруктураКурсаДокумента.Кратность;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда

		ВидОперации = Перечисления.ВидыОперацийПланируемоеПоступлениеДС.ПриходДенежныхСредствРозничнаяВыручка;
		ФормаОплаты=Перечисления.ВидыДенежныхСредств.Наличные;
		
		Если Основание.ВидОперации=Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах Тогда
			ВидПриемаРозничнойВыручки=Перечисления.ВидПриемаРозничнойВыручки.ИзКассы; 	
			КассаККМ   = Основание.КассаККМ;
		ИначеЕсли Основание.ВидОперации=Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетНТТОПродажах Тогда
			ВидПриемаРозничнойВыручки=Перечисления.ВидПриемаРозничнойВыручки.ИзНТТ; 	
			КассаККМ   = Основание.Склад;
		КонецЕсли;
		
		ВалютаДокумента=мВалютаРегламентированногоУчета;
		КурсДокумента=1;
		КратностьДокумента=1;
		
		СпособЗаполнения = "По розничной выручке";	
		
	КонецЕсли;

	Если СпособЗаполнения = "По заказу" Тогда

		ЗаполнитьПоЗаказуУпр(СтрокаПлатеж);
		
	ИначеЕсли СпособЗаполнения = "По розничной выручке" Тогда
		ЗаполнитьПоРозничнойВыручкеУпр(СтрокаПлатеж);

	ИначеЕсли СпособЗаполнения = "По взаиморасчетам" Тогда

		ЗаполнитьПоВзаиморасчетамУпр(СтрокаПлатеж);

	ИначеЕсли СпособЗаполнения = "По сумме документа" Тогда

		СтруктураКурсаОснования = ПолучитьКурсВалюты(Основание.ВалютаДокумента, Основание.Дата);
		КурсОснования=СтруктураКурсаОснования.Курс;
		КратностьОснования=СтруктураКурсаОснования.Кратность;

		ОснованиеСуммаДокумента  = Основание.СуммаДокумента;
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
			ОснованиеСуммаДокумента = ОснованиеСуммаДокумента - Основание.СуммаВознаграждения;
		КонецЕсли;

		СтрокаПлатеж.СуммаВзаиморасчетов = ПересчитатьИзВалютыВВалюту(ОснованиеСуммаДокумента, Основание.ВалютаДокумента, Основание.ДоговорКонтрагента.ВалютаВзаиморасчетов,
		                                   КурсОснования, Основание.КурсВзаиморасчетов, КратностьОснования, Основание.КратностьВзаиморасчетов);
		СуммаДокумента = ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаВзаиморасчетов, СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, ВалютаДокумента, СтрокаПлатеж.КурсВзаиморасчетов,
		                 КурсДокумента, СтрокаПлатеж.КратностьВзаиморасчетов,КратностьДокумента);

		СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;

	КонецЕсли;

	ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнойОтветственный");
	ОтраженоВОперУчете = Истина;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	ЕстьРасчетыСКонтрагентами=ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=ЕстьРасчетыПоКредитам(ВидОперации);

	ПроверитьЗаполнениеДокументаУпр(Отказ,Заголовок);

	СтруктураКурсыВалют = СформироватьСтруктуруКурсыВалютУпр();

	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураКурсыВалют);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

