﻿// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

// Хранит таблицу, использующуюся при проведении документа
Перем ТаблицаПлатежейУпр;

//БАЛАНС (04.12.2007)                       
//
Перем мПроведениеИзФормы Экспорт; 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Определяет номер расчетного счета по
// переданному банковскому счету
//
// Параметры:
//  СчетКонтра - справочник.БанковскиеСчета
//
// Возвращаемое значение
//  Номер расчетного счета
//
Функция ВернутьРасчетныйСчет(СчетКонтра)

	БанкДляРасчетов = СчетКонтра.БанкДляРасчетов;
	Возврат ?(БанкДляРасчетов.Пустая(), СчетКонтра.НомерСчета, БанкДляРасчетов.КоррСчет);

КонецФункции // ВернутьРасчетныйСчет()

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("СчетОрганизации");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("ДатаОплаты","Не указана дата оплаты документа банком!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует структуру полей, обязательных для заполнения при отражении операции во 
// взаиморасчетах
// Возвращаемое значение:
//   СтруктурахПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейРасчетыУпр()

	СтруктураПолей= Новый Структура("Организация,СчетОрганизации, Ответственный,СуммаДокумента");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейРасчетыУпр()

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
			 
			 Если Константы.ОплатыРаспределяютМенеджеры.Получить() и (яштАдминистративныеФункцииДоступны() 
				 или (ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя))  Тогда
			 Иначе	 
				ПроверитьЗначение(Платеж.Сделка, Отказ, Заголовок,"Сделка");
			 КонецЕсли;	
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

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок)

	РасчетыВозврат=НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(ВидОперации);
	КоэффициентСторно=?(РасчетыВозврат=Перечисления.РасчетыВозврат.Возврат,-1,1);
	
	РасчетыСКонтрагентами = ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам;
		
	ДвиженияПоСтатьям=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоПланируемымПлатежам=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоРезерву=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияПоКонтрагентам=ТаблицаПлатежейУпр.Скопировать();
	ДвиженияДенежныхСредств=ТаблицаПлатежейУпр.Скопировать();
	
	ДвиженияПоПланируемымПлатежам.Свернуть("ДокументПланированияПлатежа,ВключатьВПлатежныйКалендарь,ДоговорКонтрагента,Сделка,СтатьяДвиженияДенежныхСредств,Проект","СуммаПлатежа,СуммаВзаиморасчетов,СуммаПлатежаПлан,СуммаУпр");
	ДвиженияПоКонтрагентам.Свернуть("ДоговорКонтрагента,Сделка,ВидДоговора,КонтролироватьДенежныеСредстваКомитента","СуммаПлатежа,СуммаВзаиморасчетов,СуммаУпр,СуммаРегл");
	//***
	//ДвиженияПоКонтрагентам.Свернуть("ДоговорКонтрагента,Сделка,ВидДоговора,КонтролироватьДенежныеСредстваКомитента","СуммаВзаиморасчетов,СуммаУпр,СуммаРегл");
	//***
	ДвиженияДенежныхСредств.Свернуть("ДокументПланированияПлатежа,ДоговорКонтрагента,Сделка,СтатьяДвиженияДенежныхСредств,Проект","СуммаПлатежа,СуммаУпр");
	ДвиженияПоСтатьям.Свернуть("СтатьяДвиженияДенежныхСредств","СуммаПлатежа");
	ДвиженияПоРезерву.Свернуть("ДокументПланированияПлатежа","СуммаПлатежа");
	
	ДвиженияДенежныхСредств.Колонки["СуммаПлатежа"].Имя="Сумма";
		
	Если Оплачено Тогда
				
	// По регистру "Денежные средства"
	НаборДвиженийОстатки 		= Движения.ДенежныеСредства;
	ТаблицаДвиженийОстатки 		= НаборДвиженийОстатки.Выгрузить();

	// По регистру "Денежные средства к получению"
	НаборДвиженийПолучение   = Движения.ДенежныеСредстваКПолучению;
	ТаблицаДвиженийПолучение = НаборДвиженийПолучение.Выгрузить();
	
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
	
	НаборДвиженийОстатки.мПериод              = ДатаОплаты; //КонецДня(ДатаОплаты);
	НаборДвиженийОстатки.мТаблицаДвижений     = ТаблицаДвиженийОстатки;
	Движения.ДенежныеСредства.ВыполнитьПриход();
		
	// По регистру "Денежные средства к получению"
	Для Каждого СтрокаДвижение Из ДвиженияПоСтатьям Цикл
		
		СтрокаДвиженийПолучение = ТаблицаДвиженийПолучение.Добавить();
		СтрокаДвиженийПолучение.БанковскийСчетКасса = СчетОрганизации;
		СтрокаДвиженийПолучение.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
		СтрокаДвиженийПолучение.Сумма               = СтрокаДвижение.СуммаПлатежа;
		СтрокаДвиженийПолучение.ДокументПолучения    = Ссылка;
		СтрокаДвиженийПолучение.СтатьяДвиженияДенежныхСредств=СтрокаДвижение.СтатьяДвиженияДенежныхСредств;
		
	КонецЦикла;
		
	НаборДвиженийПолучение.мПериод              = ДатаОплаты; //КонецДня(ДатаОплаты);
	НаборДвиженийПолучение.мТаблицаДвижений     = ТаблицаДвиженийПолучение;
	Движения.ДенежныеСредстваКПолучению.ВыполнитьРасход();
	
	Для Каждого СтрокаРезерв ИЗ ДвиженияПоРезерву Цикл
	
		// Резервируем денежные средства, если приход планировался и по нему размещались заявки
		Если НЕ СтрокаРезерв.ДокументПланированияПлатежа.Пустая() Тогда
			
			Запрос=Новый Запрос;
			Запрос.Текст="ВЫБРАТЬ
			|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументРезервирования КАК Заявка,
			|	РазмещениеЗаявокНаРасходованиеСредствОстатки.СуммаОстаток КАК СуммаОстаток,
			|	РазмещениеЗаявокНаРасходованиеСредствОстатки.ДокументРезервирования.ДатаРасхода КАК ДокументРезервированияДатаРасхода
			|ИЗ
			|	РегистрНакопления.РазмещениеЗаявокНаРасходованиеСредств.Остатки(, ДокументПланирования=&ДокументПланирования) КАК РазмещениеЗаявокНаРасходованиеСредствОстатки
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДокументРезервированияДатаРасхода";
			
			Запрос.УстановитьПараметр("ДокументПланирования",СтрокаРезерв.ДокументПланированияПлатежа);
			
			Результат=Запрос.Выполнить();
			
			Если НЕ Результат.Пустой() Тогда
				
				СуммаРезерв=СтрокаРезерв.СуммаПлатежа;	
				
				НаборРазмещение=Движения.РазмещениеЗаявокНаРасходованиеСредств;
				ТаблицаРазмещение=НаборРазмещение.Выгрузить();
				ТаблицаРазмещение.Очистить();
				
				НаборРезерв=Движения.ДенежныеСредстваВРезерве;
				ТаблицаРезерв=НаборРезерв.Выгрузить();
				ТаблицаРезерв.Очистить();
				
				Выборка=Результат.Выбрать();
				
				Пока Выборка.Следующий() Цикл
					
					Если Выборка.СуммаОстаток>=СуммаРезерв Тогда
						
						СтрокаРазмещение=ТаблицаРазмещение.Добавить();
						СтрокаРазмещение.ДокументПланирования=СтрокаРезерв.ДокументПланированияПлатежа;
						СтрокаРазмещение.ДокументРезервирования=Выборка.Заявка;
						СтрокаРазмещение.Сумма=СуммаРезерв;
						
						СтрокаРезерв=ТаблицаРезерв.Добавить();
						СтрокаРезерв.БанковскийСчетКасса=СчетОрганизации;
						СтрокаРезерв.ВидДенежныхСредств=Перечисления.ВидыДенежныхСредств.Безналичные;
						СтрокаРезерв.ДокументРезервирования=Выборка.Заявка;
						СтрокаРезерв.Сумма=СуммаРезерв;
						
						Прервать;
						
					Иначе
						
						СтрокаРазмещение=ТаблицаРазмещение.Добавить();
						СтрокаРазмещение.ДокументПланирования=СтрокаРезерв.ДокументПланированияПлатежа;
						СтрокаРазмещение.ДокументРезервирования=Выборка.Заявка;
						СтрокаРазмещение.Сумма=Выборка.СуммаОстаток;
						
						СтрокаРезерв=ТаблицаРезерв.Добавить();
						СтрокаРезерв.БанковскийСчетКасса=СчетОрганизации;
						СтрокаРезерв.ВидДенежныхСредств=Перечисления.ВидыДенежныхСредств.Безналичные;
						СтрокаРезерв.ДокументРезервирования=Выборка.Заявка;
						СтрокаРезерв.Сумма=Выборка.СуммаОстаток;
						
						СуммаРезерв=СуммаРезерв-Выборка.СуммаОстаток;
						
					КонецЕсли;
					
				КонецЦикла;
				
				НаборРазмещение.мПериод=ДатаОплаты; //КонецДня(ДатаОплаты);
				НаборРазмещение.мТаблицаДвижений=ТаблицаРазмещение;
				Движения.РазмещениеЗаявокНаРасходованиеСредств.ВыполнитьРасход();
				
				НаборРезерв.мПериод=ДатаОплаты;  //КонецДня(ДатаОплаты);
				НаборРезерв.мТаблицаДвижений=ТаблицаРезерв;
				Движения.ДенежныеСредстваВРезерве.ВыполнитьПриход();
				
			КонецЕсли;
			
		КонецЕсли;
		
		КонецЦикла;

	КонецЕсли;
	
	Если ОтраженоВОперУчете Тогда

		// По регистру "Денежные средства к получению"
		НаборДвиженийДС   = Движения.ДенежныеСредстваКПолучению;
		ТаблицаДвиженийДС = НаборДвиженийДС.Выгрузить();
		ТаблицаДвиженийДС.Очистить();

		Для Каждого СтрокаДвижение Из ДвиженияПоСтатьям Цикл
			
			СтрокаДвиженийДС = ТаблицаДвиженийДС.Добавить();
			СтрокаДвиженийДС.БанковскийСчетКасса = СчетОрганизации;
			СтрокаДвиженийДС.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Безналичные;
			СтрокаДвиженийДС.Сумма               = СтрокаДвижение.СуммаПлатежа;
			СтрокаДвиженийДС.ДокументПолучения    = Ссылка;
			СтрокаДвиженийДС.СтатьяДвиженияДенежныхСредств=СтрокаДвижение.СтатьяДвиженияДенежныхСредств;
			
		КонецЦикла;

		НаборДвиженийДС.мПериод              = Дата;
		НаборДвиженийДС.мТаблицаДвижений     = ТаблицаДвиженийДС;
		Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
		
		ЕстьПланПоступление=Ложь;
		ЕстьРасчеты=Ложь;
				
		// По регистру "Планируемые поступления денежных средств"
		НаборДвиженийПлан  = Движения.ПланируемыеПоступленияДенежныхСредств;
		ТаблицаДвиженийПлан = НаборДвиженийПлан.Выгрузить();
		ТаблицаДвиженийПлан.Очистить();
							
		// Подготовим таблицу для движений по регистру "РасчетыСКонтрагентами"
		НаборДвиженийКонтрагенты   = Движения.РасчетыСКонтрагентами;
		ТаблицаДвиженийКонтрагенты = НаборДвиженийКонтрагенты.Выгрузить();
		ТаблицаДвиженийКонтрагенты.Очистить();
		
		// По строкам табличной части
		Для Каждого СтрокаПлатеж ИЗ ДвиженияПоПланируемымПлатежам Цикл
			
			ТекущаяСделка = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
							
			Если НЕ СтрокаПлатеж.ДокументПланированияПлатежа.Пустая() Тогда
								
				СуммаПлатежа=СтрокаПлатеж.СуммаПлатежаПлан;											
				СтрокаДвиженийЗаявки = ТаблицаДвиженийПлан.Добавить();
				СтрокаДвиженийЗаявки.СуммаУпр            			= СтрокаПлатеж.СуммаУпр;
				СтрокаДвиженийЗаявки.Сумма                			= СтрокаПлатеж.СуммаПлатежаПлан;
				СтрокаДвиженийЗаявки.СуммаВзаиморасчетов  			= СтрокаПлатеж.СуммаВзаиморасчетов;
				СтрокаДвиженийЗаявки.ДокументПланирования 			= СтрокаПлатеж.ДокументПланированияПлатежа;
				СтрокаДвиженийЗаявки.СтатьяДвиженияДенежныхСредств 	= СтрокаПлатеж.СтатьяДвиженияДенежныхСредств;
				СтрокаДвиженийЗаявки.Проект						 	= СтрокаПлатеж.Проект;
				СтрокаДвиженийЗаявки.ДоговорКонтрагента				= СтрокаПлатеж.ДоговорКонтрагента;
				СтрокаДвиженийЗаявки.Сделка							= СтрокаПлатеж.Сделка;
				
				ЕстьПланПоступление = Истина;
				
				Если НЕ СтрокаПлатеж.ВключатьВПлатежныйКалендарь Тогда // Документ не был проведен по оперативным взаиморасчетам
										
					ЕстьРасчеты=Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Если ((Не ЕстьПланПоступление) ИЛИ ЕстьРасчеты) И РасчетыСКонтрагентами Тогда // Первое упоминание о планируемом платеже в системе
				
				// По регистру "РасчетыСКонтрагентами"
				
				СтрокаДвиженийКонтрагенты = ТаблицаДвиженийКонтрагенты.Добавить();
				СтрокаДвиженийКонтрагенты.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
				СтрокаДвиженийКонтрагенты.РасчетыВозврат      = РасчетыВозврат;
				СтрокаДвиженийКонтрагенты.Сделка              = ?(ЗначениеНеЗаполнено(СтрокаПлатеж.Сделка),ТекущаяСделка,СтрокаПлатеж.Сделка);
				//***
				Если НЕ СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда 
					СтрокаДвиженийКонтрагенты.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаПлатежа*КоэффициентСторно; 
				Иначе
					СтрокаДвиженийКонтрагенты.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно; 
				КонецЕсли;
				СтрокаДвиженийКонтрагенты.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
				
				ЕстьРасчеты = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
				
		Если ЕстьПланПоступление Тогда
			
			НаборДвиженийПлан.мПериод          = Дата;
			НаборДвиженийПлан.мТаблицаДвижений = ТаблицаДвиженийПлан;
			Движения.ПланируемыеПоступленияДенежныхСредств.ВыполнитьРасход();
			
		КонецЕсли;
		
		Если ЕстьРасчеты Тогда
			
			НаборДвиженийКонтрагенты.мПериод          = Дата;
			НаборДвиженийКонтрагенты.мТаблицаДвижений = ТаблицаДвиженийКонтрагенты;
			
			Если КоэффициентСторно=1 Тогда
				
				Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
				
			Иначе
				
				Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Оплачено Тогда  // Проводим по фактическим взаиморасчетам

		// По регистру "Движения денежных средств"
		НаборДвижений = Движения.ДвиженияДенежныхСредств;
		
		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ДвиженияДенежныхСредств, ТаблицаДвижений);
		
		// Недостающие поля.
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.ВидыДенежныхСредств.Безналичные,"ВидДенежныхСредств");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.ВидыДвиженийПриходРасход.Приход,"ПриходРасход");
		ТаблицаДвижений.ЗаполнитьЗначения(СчетОрганизации,"БанковскийСчетКасса");
		ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,"ДокументДвижения");
		ТаблицаДвижений.ЗаполнитьЗначения(Контрагент,"Контрагент");
				
		НаборДвижений.мПериод            = ДатаОплаты; //КонецДня(ДатаОплаты);
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

		Движения.ДвиженияДенежныхСредств.ВыполнитьДвижения();
	
		Если РасчетыСКонтрагентами Тогда
			
			// По регистрам взаиморасчетов с покукпателями и поставщиками для НДС.
			// Движение делается только если документ отражается в БУ.
			Если ОтражатьВБухгалтерскомУчете Тогда

				// Для целей НДС проводим платежи только по операциям с поставщиком и покупателем.
				Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком Тогда

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

					НаборДвиженийСПоставщиками.мПериод            = ДатаОплаты; //КонецДня(ДатаОплаты);
					НаборДвиженийСПоставщиками.мТаблицаДвижений   = ТаблицаДвиженийСПоставщиками;

					Движения.ВзаиморасчетыСПоставщикамиДляНДС.ВыполнитьПриход();

				ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя Тогда

					НаборДвиженийСПокупателями   = Движения.ВзаиморасчетыСПокупателямиДляНДС;
					ТаблицаДвиженийСПокупателями = НаборДвиженийСПокупателями.Выгрузить();

					// По строкам табличной части.
					Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл

						СтрокаДвижений = ТаблицаДвиженийСПокупателями.Добавить();
						СтрокаДвижений.Организация         = Организация;
						СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
						СтрокаДвижений.Сделка              = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);;
						СтрокаДвижений.Сумма               = СтрокаПлатеж.СуммаРегл;

					КонецЦикла;

					НаборДвиженийСПокупателями.мПериод            = ДатаОплаты; //КонецДня(ДатаОплаты);
					НаборДвиженийСПокупателями.мТаблицаДвижений   = ТаблицаДвиженийСПокупателями;

					Движения.ВзаиморасчетыСПокупателямиДляНДС.ВыполнитьРасход();

				КонецЕсли;

			КонецЕсли;

			//курсовые разницы
			Если ВалютаДокумента <> Константы.ВалютаРегламентированногоУчета.Получить() Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Сделка,
				|	СУММА(ПлатежноеПоручениеВходящееРасшифровкаПлатежа.СуммаПлатежа) КАК СуммаПлатежа,
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.КурсВзаиморасчетов,
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента
				|ПОМЕСТИТЬ ВТ_сделки
				|ИЗ
				|	Документ.ПлатежноеПоручениеВходящее.РасшифровкаПлатежа КАК ПлатежноеПоручениеВходящееРасшифровкаПлатежа
				|ГДЕ
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Ссылка = &Ссылка
				|	И ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Сделка <> НЕОПРЕДЕЛЕНО
				|
				|СГРУППИРОВАТЬ ПО
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.Сделка,
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.КурсВзаиморасчетов,
				|	ПлатежноеПоручениеВходящееРасшифровкаПлатежа.ДоговорКонтрагента
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ВТ_сделки.Сделка,
				|	ВТ_сделки.ДоговорКонтрагента КАК Договор,
				|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток - ВТ_сделки.СуммаПлатежа * ВТ_сделки.КурсВзаиморасчетов КАК КурсоваяРазница
				|ИЗ
				|	ВТ_сделки КАК ВТ_сделки
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
				|				&МоментВремени,
				|				Сделка В
				|					(ВЫБРАТЬ
				|						ВТ_сделки.Сделка
				|					ИЗ
				|						ВТ_сделки КАК ВТ_сделки)) КАК ВзаиморасчетыСКонтрагентамиОстатки
				|		ПО ВТ_сделки.Сделка = ВзаиморасчетыСКонтрагентамиОстатки.Сделка
				|			И ВТ_сделки.ДоговорКонтрагента = ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента
				|ГДЕ
				|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток = ВТ_сделки.СуммаПлатежа";
				
				Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				
				ТаблицаКурсовыхРазниц = Запрос.Выполнить().Выгрузить();
			конецЕсли;	  //)


			
			
			
			
			
			
			// По регистру "ВзаиморасчетыСКонтрагентами"
			НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;
			ТаблицаДвижений = НаборДвижений.Выгрузить();

			// По регистру "ДенежныеСредстваКомитента"
			
			ЕстьРасчетыСКомиссионером=Ложь;
			НаборДвиженийКомиссионер = Движения.ДенежныеСредстваКомиссионера;
			ТаблицаДвиженийКомиссионер = НаборДвиженийКомиссионер.Выгрузить();
		
			// По строкам табличной части
			Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл
				
				ТекущаяСделка = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
				
				СтрокаДвижений = ТаблицаДвижений.Добавить();
				СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
				СтрокаДвижений.Сделка              = ТекущаяСделка;
				//***
				Если НЕ СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда 
					СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаПлатежа*КоэффициентСторно; 
				Иначе
					СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно; 
				КонецЕсли;
				СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
				
				
				Если СтрокаПлатеж.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером
					И СтрокаПлатеж.КонтролироватьДенежныеСредстваКомитента Тогда
					
					СтрокаДвиженийКомиссионер = ТаблицаДвиженийКомиссионер.Добавить();
					СтрокаДвиженийКомиссионер.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
					СтрокаДвиженийКомиссионер.Сделка              = ТекущаяСделка;
					//***
					Если НЕ СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда 
						СтрокаДвиженийКомиссионер.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаПлатежа*КоэффициентСторно; 
					Иначе
						СтрокаДвиженийКомиссионер.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно; 
					КонецЕсли;
					СтрокаДвиженийКомиссионер.СуммаУпр            = СуммаУпр*КоэффициентСторно;
					
					ЕстьРасчетыСКомиссионером=Истина;
					
				КонецЕсли;
				
				
				
				
			КонецЦикла;
			
			//курсовые разницы
			Если ВалютаДокумента <> Константы.ВалютаРегламентированногоУчета.Получить() Тогда
				Для каждого стр из ТаблицаКурсовыхРазниц Цикл
					СтрокаДвижений = ТаблицаДвижений.Добавить();
					СтрокаДвижений.ДоговорКонтрагента = стр.Договор;
					СтрокаДвижений.Сделка                = стр.Сделка;
					СтрокаДвижений.СуммаВзаиморасчетов   = 0;
					СтрокаДвижений.СуммаУпр   = стр.курсоваяРазница;
				конецЦикла;
			конецЕсли;
			
			НаборДвижений.мПериод            = ДатаОплаты; //КонецДня(ДатаОплаты);
			НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
			
			Если КоэффициентСторно=1 Тогда
				
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
				
			Иначе
				
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьПриход();
				
			КонецЕсли;
			
			
			
			//А.А. для внутренних переводов денег добавим 2 движения (аналог В/з)
			НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;
			ТаблицаДвижений = НаборДвижений.Выгрузить();
			//ТаблицаДвижений.Очистить();
			Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл
				Если СтрокаПлатеж.ДоговорКонтрагента.переводМеждуСчетами тогда
					
					
					ТекущаяСделка = ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
					
					СтрокаДвижений = ТаблицаДвижений.Добавить();
					СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
					СтрокаДвижений.Сделка              = ТекущаяСделка;
					СтрокаДвижений.видДвижения             = Перечисления.ВидыДвиженийПриходРасход.Приход;
					//***
					Если НЕ СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда 
						СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаПлатежа*КоэффициентСторно; 
					Иначе
						СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно; 
					КонецЕсли;
					СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
					строкаДвижений.Активность = Истина;
                     строкаДвижений.период = Дата;
					СтрокаДвижений = ТаблицаДвижений.Добавить();
					
					
					
					Запрос = Новый Запрос;
					Запрос.Текст = 
					"ВЫБРАТЬ
					|	ДоговорыКонтрагентов.Ссылка
					|ИЗ
					|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
					|ГДЕ
					|	ДоговорыКонтрагентов.Владелец = &Владелец
					|	И ДоговорыКонтрагентов.ТипДоговора = &ТипДоговора
					|	И ДоговорыКонтрагентов.ПереводМеждуСчетами = ИСТИНА";
					
					
					//Если СтрокаПлатеж.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ФормулаАвтоПлюс тогда
					//Запрос.УстановитьПараметр("Владелец",Справочники.Контрагенты.НайтиПоКоду("36092"));
					//ИначеЕсли СтрокаПлатеж.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ШинтрейдЯрославль тогда
					Запрос.УстановитьПараметр("Владелец",Справочники.Контрагенты.НайтиПоКоду("36092"));  //Яршинторг ТК
					//конецЕсли;	
					Запрос.УстановитьПараметр("ТипДоговора", СтрокаПлатеж.ДоговорКонтрагента.ТипДоговора);
					
					Результат = Запрос.Выполнить();
					
					Выборка = Результат.Выбрать();
					
					Выборка.Следующий();
					
					
					
					СтрокаДвижений.ДоговорКонтрагента  = Выборка.Ссылка;
					//СтрокаДвижений.Сделка              = ТекущаяСделка;
					
					СтрокаДвижений.видДвижения             = ВидДвиженияНакопления.Расход;
					//***
					Если НЕ СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда 
						СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаПлатежа*КоэффициентСторно; 
					Иначе
						СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов*КоэффициентСторно; 
					КонецЕсли;
					СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр*КоэффициентСторно;
					
				конецЕсли;
				     строкаДвижений.Активность = Истина;
                     строкаДвижений.период = Дата;
				
			КонецЦикла;
			
			НаборДвижений.мПериод            = ДатаОплаты; //КонецДня(ДатаОплаты);
			НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;
			Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьДвижения();
				
			
			
			
			
			
			//*****************

			
			
			
			
			
			
			
			
			
			
			Если ЕстьРасчетыСКомиссионером Тогда
				
				НаборДвиженийКомиссионер.мПериод          = ДатаОплаты; //КонецДня(ДатаОплаты);
				НаборДвиженийКомиссионер.мТаблицаДвижений = ТаблицаДвижений;
				
				Если КоэффициентСторно=1 Тогда
					
					Движения.ДенежныеСредстваКомиссионера.ВыполнитьРасход();
					
				Иначе
					
					Движения.ДенежныеСредстваКомиссионера.ВыполнитьПриход();
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		КонецЕсли;
			
	КонецЕсли;

	// { Лапенков 20061108
	Если  ОтражатьВЗатратах Тогда  // для отражения ретробонусов
		
			Если (ИтогоЗатрат<>0) и (СуммаДокумента<>ИтогоЗатрат) Тогда 
				Отказ = Истина;
				Сообщить("Не совпадают сумма сторнируемых затрат и сумма документа.", СтатусСообщения.Важное);
			КонецЕсли;
		Если ВидОперации<>Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда	
				
			ТаблицаЗатрат = СформироватьТаблицуЗатрат();
			Если (ТаблицаЗатрат.Количество()>0) Тогда 
				Для Каждого Стр из ТаблицаЗатрат Цикл
					НаборДвижений   = Движения.Затраты.Добавить();
					Если (Стр.Подразделение = Справочники.Подразделения.ПустаяСсылка()) Тогда 
						Отказ = Истина;
						Сообщить("В табличной части ""Затраты (сторно)"" пропущено подразделение.", СтатусСообщения.Важное);
					КонецЕсли;	
					Если (Стр.СтатьяЗатрат = Справочники.СтатьиЗатрат.ПустаяСсылка()) Тогда 
						Отказ = Истина;
						Сообщить("В табличной части ""Затраты (сторно)"" пропущена статья.", СтатусСообщения.Важное);
					КонецЕсли;	
					Если ((Стр.Сумма = 0) или (Стр.Сумма = Неопределено)) Тогда 
						Отказ = Истина;
						Сообщить("В табличной части ""Затраты (сторно)"" пропущена сумма.", СтатусСообщения.Важное)
					КонецЕсли;
					//Адиянов<<< Начало СтатьяЗатратУпр
					Если Стр.СтатьяЗатратУПР = Справочники.СтатьиЗатратУпр.ПустаяСсылка() Тогда 
						Сообщить("В табличной части ""Затраты (сторно)"" пропущена статья затрат УПР.", СтатусСообщения.Важное);
					КонецЕсли;	
					//Адиянов>>> Конец СтатьяЗатратУпр
					
					НаборДвижений.Подразделение  = Стр.Подразделение;
					НаборДвижений.СтатьяЗатрат   = Стр.СтатьяЗатрат;
					НаборДвижений.Сумма          = -Стр.Сумма;
					НаборДвижений.Период          = Дата;
					
					//Адиянов<<< Начало СтатьяЗатратУпр
					НаборДвижений.СтатьяЗатратУпр   = Стр.СтатьяЗатратУпр;
					//Адиянов>>> Конец СтатьяЗатратУпр
					
					Движения.Затраты .Записать();
				КонецЦикла;		
			КонецЕсли;	
		КонецЕсли;		
	КонецЕсли;	
	// } Лапенков 20061108
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Режим, Заголовок)

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа")= СуммаДокумента Тогда
		Сообщить(Заголовок+" 
		|не совпадают сумма документа и ее расшифровка.");

		Отказ = Истина;

	КонецЕсли;

	Если Оплачено Тогда
		ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплатаУпр(), Отказ, Заголовок);
	КонецЕсли;
	
	Если ОтраженоВОперУчете И Режим = РежимПроведенияДокумента.Оперативный И (ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам) Тогда
					
		КонтрольОстатковПоТЧ(?(Оплачено,ДатаОплаты,Дата), РасшифровкаПлатежа, Отказ, Заголовок, Истина);	//КонецДня(ДатаОплаты)		
		
	КонецЕсли;

	Если ОтраженоВОперУчете Тогда
		
		ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейРасчетыУпр(), Отказ, Заголовок);
		
		Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
			
			ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Функция СформироватьСтруктуруКурсыВалютУпр()

	СтруктураГруппаВалют = Новый Структура;
	СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",  Константы.ВалютаУправленческогоУчета.Получить().Код);
	СтруктураГруппаВалют.Вставить("ВалютаДокумента", ВалютаДокумента.Код);

	СтруктураКурсыВалют=ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,?(ДатаОплаты='00010101',Дата,КонецДня(ДатаОплаты)));

	Возврат СтруктураКурсыВалют;

КонецФункции

Функция СформироватьТаблицуЗатрат()
	
	ТаблицаЗатрат = Затраты.Выгрузить();
	
	//Адиянов<<< Начало СтатьяЗатратУпр
	//{{ ТаблицаЗатрат.Свернуть("Подразделение,СтатьяЗатрат","Сумма");
	ТаблицаЗатрат.Свернуть("Подразделение,СтатьяЗатрат,СтатьяЗатратУпр","Сумма");
	//Адиянов>>> Конец СтатьяЗатратУпр
	
	
	Возврат ТаблицаЗатрат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если Основание  = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
	ЗаполнитьПриходПоОснованию(ЭтотОбъект, Основание, глТекущийПользователь);
	
		//{ Лапенков 20061107 заполнить затраты из док. осн.
    Если (ЕстьРеквизитДокумента("ВидОперации",Основание.Метаданные())) Тогда 
		Если Основание.ВидОперации=Перечисления.ВидыОперацийППИсходящее.РасчетыПоКредитамИЗаймамСКонтрагентами Тогда
			ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам;
		ИначеЕсли 	Основание.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ПрочееСписаниеБезналичныхДенежныхСредств Тогда
			ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств;
		ИначеЕсли 	Основание.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ВозвратДенежныхСредствПокупателю Тогда
			ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя;
		ИначеЕсли 	Основание.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ОплатаПоставщику Тогда
			ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком;
		ИначеЕсли 	Основание.ВидОперации=Перечисления.ВидыОперацийППИсходящее.ПрочиеРасчетыСКонтрагентами Тогда
			ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами;
		КонецЕсли;
	КонецЕсли;
    Контрагент=Основание.Контрагент;   
	
	МетаданныеДокументаОснования = Основание.Метаданные();	
	Если ЕстьРеквизитДокумента("СчетОрганизации", МетаданныеДокументаОснования) Тогда
		СчетОрганизации=Основание.СчетОрганизации;		
	КонецЕсли; 

	Если ЕстьРеквизитДокумента("СчетКонтрагента", МетаданныеДокументаОснования) Тогда
		СчетКонтрагента=Основание.СчетКонтрагента;			
	КонецЕсли;
	
	//ДоговорКонтрагента=Основание.ДоговорКонтрагента;
	Если ЕстьТабЧастьДокумента("РасшифровкаПлатежа", МетаданныеДокументаОснования) Тогда
		РасшифровкаПлатежа.Загрузить(Основание.РасшифровкаПлатежа.Выгрузить());
	КонецЕсли;
	
	Если ЕстьТабЧастьДокумента("РасшифровкаПлатежа", МетаданныеДокументаОснования) Тогда
	  	Если Основание.Затраты.Количество()>0 Тогда
			Затраты.Загрузить(Основание.Затраты.Выгрузить());
		ИначеЕсли не (Основание.Подразделение.Пустая()) и не (Основание.СтатьяЗатрат.Пустая()) Тогда
				стр=Затраты.Добавить();
			    стр.Подразделение=Основание.Подразделение;
				стр.СтатьяЗатрат=Основание.СтатьяЗатрат;
			    стр.Сумма=Основание.СуммаДокумента;
		КонецЕсли;	
	КонецЕсли;	
			
 //} Лапенков 20061107

	
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
	
	ТаблицаПлатежейУпр=ПолучитьТаблицуПлатежейУпр(?(Оплачено,ДатаОплаты,Дата),ВалютаДокумента,Ссылка, "ПлатежноеПоручениеВходящее");  //КонецДня(ДатаОплаты)
	
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

	//для траншевого кредитного договора запишем срузу срок возврата А.А. 03.03.17
	Если ДоговорКонтрагента.Кр_Транш тогда
		Запись = Регистрысведений.КредитныеЛинии.СоздатьМенеджерЗаписи();
		Запись.ВидДвижения=Перечисления.ВидыДвиженийПриходРасход.Расход;
		Запись.КредитныйДоговор = ДоговорКонтрагента;
		Запись.Дата = НачалоДня(Дата)+ДоговорКонтрагента.Кр_СрокТранша*24*60*60;
		Запись.Сумма = СуммаДокумента;
		Запись.Записать(Истина);
	конецЕсли;
	
	

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ЧастичнаяОплата Тогда
		Сообщить("По документу "+ПредставлениеДокументаПриПроведении(Ссылка)+" уже прошла частичная оплата.
		|Перед отменой проведения документа необходимо отменить проведение платежных ордеров.");
		Отказ=Истина;
	КонецЕсли;
	
	//яштПени.ПроверитьНачисленияПени(ЭтотОбъект.Ссылка, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если  (ЭтоНовый()) Тогда 
		ТекущееПодразделение = ?(СчетОрганизации.Подразделение = Справочники.Подразделения.ПустаяСсылка(),?(Подразделение = Справочники.Подразделения.ПустаяСсылка(),Справочники.Подразделения.НайтиПоКоду("00005"),подразделение), СчетОрганизации.Подразделение);
		Подразделение = ТекущееПодразделение;
		Если (СчетОрганизации.Подразделение<>Справочники.Подразделения.ПустаяСсылка()) Тогда 
			УстановитьНовыйНомер(СокрЛП(ТекущееПодразделение.ПрефиксИБ));
		Иначе 
			УстановитьНовыйНомер(СокрЛП(Организация.Префикс));
		КонецЕсли;
  КонецЕсли;

	ПроверкаВозможностиИзмененияДокумента(ЭтотОбъект, Отказ);
	//яштПени.ПроверитьНачисленияПени(ЭтотОбъект.Ссылка, Отказ);

	//БАЛАНС (04.12.2007)                       
	//
	//Адиянов<<<
	Если НЕ Отказ И мПроведениеИзФормы Тогда
		ПроверкаЗаполненияСтатьиЗатратУпр(ЭтотОбъект,Отказ);
	КонецЕсли; 		
	//Адиянов>>>
	
	Если не ЗначениеЗаполнено(СчетОрганизации.Подразделение) тогда
	ЗарегистрироватьОбъект(ЭтотОбъект,Отказ,мПроведениеИзФормы);
	конецЕсли;
	
	
	
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

	
КонецПроцедуры


мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

//БАЛАНС (04.12.2007)                       
//
мПроведениеИзФормы = Ложь;