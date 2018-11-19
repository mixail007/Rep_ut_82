﻿Перем ОбъектПодключения, РезультатПодключения Экспорт;
Перем ДеревоОтличий;
Перем мФакторинг;

Функция ВыполнитьПодключениеКИБПриемнику(РезультатПодключения = Неопределено, СтрокаСообщенияОбОшибке = "") Экспорт
	
	Если РезультатПодключения = Неопределено Тогда
	
		СтруктураПодключения = СформироватьСтруктуруДляПодключения();
		ОбъектПодключения = ПодключитсяКИнформационнойБазе(СтруктураПодключения, СтрокаСообщенияОбОшибке);
		
		Если ОбъектПодключения = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Попытка
			РезультатПодключения = ОбъектПодключения.Обработки.УниверсальныйОбменДаннымиXML.Создать();
		Исключение
			СтрокаСообщенияОбОшибке = "При попытке создания обработки ОбменДаннымиXML произошла ошибка:" + ОписаниеОшибки();
			#Если Клиент тогда
			Сообщить(СтрокаСообщенияОбОшибке, СтатусСообщения.Важное);
			#КонецЕсли
			РезультатПодключения = Неопределено;
		КонецПопытки;
	
	КонецЕсли;
	
	Если РезультатПодключения = Неопределено Тогда
		Возврат РезультатПодключения;
	КонецЕсли;
		
	Возврат РезультатПодключения;
	
КонецФункции

Функция СформироватьСтруктуруДляПодключения()
	
	СтруктураПодключения = Новый Структура();
	СтруктураПодключения.Вставить("ТипПодключения", 1);
	СтруктураПодключения.Вставить("ФайловыйРежим", ТипИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("АутентификацияWindows", АутентификацияWindowsИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("КаталогИБ", КаталогИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("ИмяСервера", ИмяСервераИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("ИмяИБНаСервере", ИмяИнформационнойБазыНаСервереДляПодключения);
	СтруктураПодключения.Вставить("Пользователь", ПользовательИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("Пароль", ПарольИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("ВерсияПлатформы", ВерсияПлатформыИнформационнойБазыДляПодключения);	
	
	Возврат СтруктураПодключения;
	
КонецФункции

Функция ПодключитсяКИнформационнойБазе(СтруктураПодключения, СтрокаСообщенияОбОшибке = "")
	
	Перем СтрокаПодключения;
	
	ПараметровДостаточно = ОпределитьДостсточностьПараметровДляПодключенияКИнформационнойБазе(СтруктураПодключения, СтрокаПодключения, СтрокаСообщенияОбОшибке);
	
	Если Не ПараметровДостаточно Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не СтруктураПодключения.АутентификацияWindows Тогда
		Если НЕ ПустаяСтрока(СтруктураПодключения.Пользователь) Тогда
			СтрокаПодключения = СтрокаПодключения + ";Usr = """ + СтруктураПодключения.Пользователь + """";
		КонецЕсли;
		Если НЕ ПустаяСтрока(СтруктураПодключения.Пароль) Тогда
			СтрокаПодключения = СтрокаПодключения + ";Pwd = """ + СтруктураПодключения.Пароль + """";
		КонецЕсли;
	КонецЕсли;
	
	//"V8" или "V81"
	ОбъектПодключения = СтруктураПодключения.ВерсияПлатформы;
	
	СтрокаПодключения = СтрокаПодключения + ";";
	
	Попытка
		#Если Клиент Тогда
		Состояние("Выполняется подключение к информационной базе ...");
		#КонецЕсли
		Если  СтруктураПодключения.ТипПодключения = 0 Тогда
			ОбъектПодключения = ОбъектПодключения +".Application";
			ТекCOMОбъект = Новый COMОбъект(ОбъектПодключения);
			ТекCOMОбъект.Connect(СтрокаПодключения);
		Иначе
			ОбъектПодключения = ОбъектПодключения +".COMConnector";
			ТекCOMПодключение = Новый COMОбъект(ОбъектПодключения);
			ТекCOMОбъект = ТекCOMПодключение.Connect(СтрокаПодключения);
		КонецЕсли;
			
		#Если Клиент Тогда
			Состояние("Соединение установлено");
			Состояние();
		#КонецЕсли		
			
	Исключение
		
		СтрокаСообщенияОбОшибке = "При попытке подключения к информационной базе произошла следующая ошибка:" + Символы.ПС 
						+ ОписаниеОшибки();
		#Если Клиент Тогда
			СообщитьОбОшибкеДляПользователю(СтрокаСообщенияОбОшибке);
		    Состояние("Соединение установить не удалось");
			Состояние();
		#КонецЕсли
							
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат ТекCOMОбъект;
	
КонецФункции

Функция ОпределитьДостсточностьПараметровДляПодключенияКИнформационнойБазе(СтруктураПодключения, СтрокаПодключения = "", СтрокаСообщенияОбОшибке = "") Экспорт
	
	НаличиеОшибок = Ложь;
	
	Если СтруктураПодключения.ФайловыйРежим  Тогда
		
		Если ПустаяСтрока(СтруктураПодключения.КаталогИБ) Тогда
			
			СтрокаСообщенияОбОшибке = "Не задан каталог информационной базы-приемника";
			#Если Клиент Тогда
			Сообщить(СтрокаСообщенияОбОшибке, СтатусСообщения.Важное);
			#КонецЕсли
			НаличиеОшибок = Истина;
			
		КонецЕсли;
		
		СтрокаПодключения = "File=""" + СтруктураПодключения.КаталогИБ + """";
	Иначе
		
		Если ПустаяСтрока(СтруктураПодключения.ИмяСервера) Тогда
			
			СтрокаСообщенияОбОшибке = "Не задано имя сервера 1С:Предприятия информационной базы-приемника";
			#Если Клиент Тогда
			Сообщить(СтрокаСообщенияОбОшибке, СтатусСообщения.Важное);
			#КонецЕсли
			НаличиеОшибок = Истина;
			
		КонецЕсли;
		
		Если ПустаяСтрока(СтруктураПодключения.ИмяИБНаСервере) Тогда
			
			СтрокаСообщенияОбОшибке = "Не задано имя информационной базы-приемника на сервере 1С:Предприятия";
			#Если Клиент Тогда
			Сообщить(СтрокаСообщенияОбОшибке, СтатусСообщения.Важное);
			#КонецЕсли
			НаличиеОшибок = Истина;
			
		КонецЕсли;		
		
		СтрокаПодключения = "Srvr = """ + СтруктураПодключения.ИмяСервера + """; Ref = """ + СтруктураПодключения.ИмяИБНаСервере + """";		
		
	КонецЕсли;
	
	Возврат НЕ НаличиеОшибок;	
	
КонецФункции

Процедура СообщитьОбОшибкеДляПользователю(Знач ТекстСообщения) Экспорт

	НачалоСлужебногоСообщения    = Найти(ТекстСообщения, "{");
	ОкончаниеСлужебногоСообщения = Найти(ТекстСообщения, "}:");
	
	Если ОкончаниеСлужебногоСообщения > 0 
		И НачалоСлужебногоСообщения > 0 
		И НачалоСлужебногоСообщения < ОкончаниеСлужебногоСообщения Тогда
		
		ТекстСообщения = Лев(ТекстСообщения, (НачалоСлужебногоСообщения - 1)) +
		                 Сред(ТекстСообщения, (ОкончаниеСлужебногоСообщения + 2));
						 
	КонецЕсли;
	
	Сообщить(СокрЛП(ТекстСообщения), СтатусСообщения.Важное);

КонецПроцедуры

#Если Клиент Тогда
// событие при нажатии на кнопку выбора у каталога 
Функция ОбработчикКаталогНачалоВыбора(Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	РезультатВыбора = ВыбратьКаталог(Элемент.Значение);
	
	Возврат РезультатВыбора;
	
КонецФункции

#КонецЕсли

Функция ПолучитьДеревоОтличий(НачДата,КонДата) Экспорт


Состояние("Выполняется запрос к Внешней Базе...");
	// строим таблицу документов внешней базы по UUID
	РезультатЗапросаКВнешнейБазе = ВыполнитьЗапросКВнешнейБазе(НачДата,КонДата);
	
Состояние("Выполняется Заполнение таблицы документов Внешней Базы...");
	ДеревоВнешнейБазы = РезультатЗапросаКВнешнейБазе.Выгрузить(ОбъектПодключения.ОбходРезультатаЗапроса.Прямой);
	УстановитьУИД(ДеревоВнешнейБазы);
	
Состояние("Выполняется запрос к Внешней Базе...");
	// строим таблицу документов внешней базы по дате и номеру
	ТаблицаПоДатеИНомеру =  ВыполнитьЗапросКВнешнейБазеПоДатеИНомеру(НачДата,КонДата);
	

	
Состояние("Выполняется запрос к Текущей Базе...");
	ДеревоОтличий.Очистить();	
	РезультатЗапросаКТекБазе = ВыполнитьЗапросКТекБазе(НачДата,КонДата);
	Выборка = РезультатЗапросаКТекБазе.Выбрать(ОбходРезультатаЗапроса.Прямой);
	
Состояние("Выполняется сравнение...");
	Пока Выборка.Следующий() Цикл
		Примечание = "+ НОВЫЙ +";//+++
		Соответствует = Истина;
		СтрокаДокументаВнешняя = ДеревоВнешнейБазы.Найти(Строка(Выборка.Документ.УникальныйИдентификатор()),"УИД");
		Если СтрокаДокументаВнешняя = Неопределено Тогда
			Соответствует = Ложь;
		//+++ 17.10.2011 дополнительное сравнение ПСК	
		иначеЕсли ЕстьРеквизитДокумента("Проведен", СтрокаДокументаВнешняя.Документ.Метаданные()) 
			и ЕстьРеквизитДокумента("Проведен",Выборка.Документ.Метаданные()) тогда
			Если (СтрокаДокументаВнешняя.Документ.Проведен<>Выборка.Документ.Проведен) тогда 
			Соответствует = Ложь;
			Примечание = "Проведен ("+?(СтрокаДокументаВнешняя.Документ.Проведен,"Да","Нет")+")";
			КонецЕсли;
		иначеЕсли ЕстьРеквизитДокумента("СуммаДокумента", СтрокаДокументаВнешняя.Документ.Метаданные()) 
			и ЕстьРеквизитДокумента("СуммаДокумента",Выборка.Документ.Метаданные()) тогда
			Если (Окр(СтрокаДокументаВнешняя.Документ.СуммаДокумента,2)<>Окр(Выборка.Документ.СуммаДокумента,2)) тогда 
			Соответствует = Ложь;
			Примечание = "Изм.Суммы = ("+Число(Окр(СтрокаДокументаВнешняя.Документ.СуммаДокумента,2)-Окр(Выборка.Документ.СуммаДокумента,2))+"р.)";
			КонецЕсли;
			Если СтрокаДокументаВнешняя.Документ.Закрыт тогда
			Примечание = "НЕизм.Сумма: "+Число(Окр(СтрокаДокументаВнешняя.Документ.СуммаДокумента,2)-Окр(Выборка.Документ.СуммаДокумента,2))+"р.";
			КонецЕсли;
			
		иначеЕсли ЕстьРеквизитДокумента("Контрагент", СтрокаДокументаВнешняя.Документ.Метаданные()) 
			    и ЕстьРеквизитДокумента("Контрагент",Выборка.Документ.Метаданные()) тогда
			Если (СтрокаДокументаВнешняя.Документ.Контрагент.ИНН<>Выборка.Документ.Контрагент.ИНН) 
			и (СтрокаДокументаВнешняя.Документ.Контрагент.НаименованиеПолное<>Выборка.Документ.Контрагент.НаименованиеПолное) тогда 
			Соответствует = Ложь;
			Примечание = "Контрагент ("+СтрокаДокументаВнешняя.Документ.Контрагент.НаименованиеПолное+")";
				Если СтрокаДокументаВнешняя.Документ.Закрыт тогда
				Примечание = "Контрагент БП: "+СтрокаДокументаВнешняя.Документ.Контрагент.НаименованиеПолное; 
				КонецЕсли;
			КонецЕсли;
		//+++) 17.10.2011 дополнительное сравнение
		КОнецЕсли;	
		
		Если  Не Соответствует тогда
		  Если (ТипЗнч(Выборка.Документ)=Тип("ДокументСсылка.КомплектацияНоменклатуры")) Тогда // ищем в таблице ДеревоВнешнейБазыПоДатеИНомеру
			СтруктураПоиска=Новый Структура("Номер,Дата");
			СтруктураПоиска.Номер= Выборка.Документ.Номер+"*";
			СтруктураПоиска.Дата= Строка(Выборка.Документ.Дата);
			СтрокиДокументаВнешние=ТаблицаПоДатеИНомеру.НайтиСтроки(СтруктураПоиска);
			Если СтрокиДокументаВнешние.Количество()=0 Тогда
				Соответствует = Ложь;
			Иначе	 
				Соответствует = Истина;
			КонецЕсли;	 
		  ИначеЕсли (ТипЗнч(Выборка.Документ)=Тип("ДокументСсылка.ОперацияПоОтветственномуХранению")) Тогда // ищем в таблице ДеревоВнешнейБазыПоДатеИНомеру
			СтруктураПоиска=Новый Структура("Номер,Дата");
			СтруктураПоиска.Номер= Выборка.Документ.Номер+" С";   //"ТК03515 С  "
			СтруктураПоиска.Дата= Строка(Выборка.Документ.Дата);
			СтрокиДокументаВнешние=ТаблицаПоДатеИНомеру.НайтиСтроки(СтруктураПоиска);
			Если СтрокиДокументаВнешние.Количество()=0 Тогда
				Соответствует = Ложь;
			Иначе	 
				Соответствует = Истина;
			КонецЕсли;	 
	
		  КонецЕсли;
	  КонецЕсли; //не соответствует
		
		Если НЕ Соответствует Тогда
		СтрокаДокумента =ДеревоОтличий.Добавить();
		СтрокаДокумента.Документ =Выборка.Документ;
		СтрокаДокумента.Примечание = Примечание; //+++
		КонецЕсли;	
	КонецЦикла;
Состояние(" ");
		
	возврат ДеревоОтличий;
	
	КонецФункции


 

// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция ПолучитьПредставлениеИзВнешнегоИсточника(СтрокаДоговораВнешняя)

	Возврат СтрокаДоговораВнешняя.Наименование;	

КонецФункции // ПолучитьПредставлениеИзВнешнегоИсточника()
 

// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция ПолучитьСсылкуИзВнешнегоИсточника(СтрокаВнешняя,ИмяСпр)

	НовыйУИД = Новый УникальныйИдентификатор(СтрокаВнешняя.УИД);
	
	Ссылка = Справочники[ИмяСпр].ПолучитьСсылку(НовыйУИД);
	Если Ссылка.Пустая() Тогда
		Наименование = СтрокаВнешняя[ИмяСпр+"Наименование"];
		Сообщить(Наименование); 
		Возврат Наименование;
	Иначе
		Возврат Ссылка;
	КонецЕсли; 

КонецФункции // ПолучитьСсылкуИзВнешнегоИсточника()
 
// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция ВыполнитьЗапросКТекБазе(НачДата,КонДата)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документы.Документ КАК Документ
	|ИЗ
	|	(ВЫБРАТЬ
	|		РеализацияТоваровУслуг.Ссылка КАК Документ,
	|		РеализацияТоваровУслуг.Номер КАК Номер
	|	ИЗ
	|		Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|	ГДЕ
	|		РеализацияТоваровУслуг.Дата МЕЖДУ &НачДата И &КонДата
	|		И РеализацияТоваровУслуг.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПоступлениеТоваровУслуг.Ссылка,
	|		ПоступлениеТоваровУслуг.Номер
	|	ИЗ
	|		Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|	ГДЕ
	|		ПоступлениеТоваровУслуг.Дата МЕЖДУ &НачДата И &КонДата
	|		И ПоступлениеТоваровУслуг.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПлатежноеПоручениеИсходящее.Ссылка,
	|		ПлатежноеПоручениеИсходящее.Номер
	|	ИЗ
	|		Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
	|	ГДЕ
	|		ПлатежноеПоручениеИсходящее.Дата МЕЖДУ &НачДата И &КонДата
	|		И ПлатежноеПоручениеИсходящее.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ОприходованиеТоваров.Ссылка,
	|		ОприходованиеТоваров.Номер
	|	ИЗ
	|		Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	|	ГДЕ
	|		ОприходованиеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|		И ОприходованиеТоваров.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПриходныйКассовыйОрдер.Ссылка,
	|		ПриходныйКассовыйОрдер.Номер
	|	ИЗ
	|		Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|	ГДЕ
	|		ПриходныйКассовыйОрдер.Дата МЕЖДУ &НачДата И &КонДата
	|		И ПриходныйКассовыйОрдер.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		РасходныйКассовыйОрдер.Ссылка,
	|		РасходныйКассовыйОрдер.Номер
	|	ИЗ
	|		Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|	ГДЕ
	|		РасходныйКассовыйОрдер.Дата МЕЖДУ &НачДата И &КонДата
	|		И РасходныйКассовыйОрдер.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		АвансовыйОтчет.Ссылка,
	|		АвансовыйОтчет.Номер
	|	ИЗ
	|		Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|	ГДЕ
	|		АвансовыйОтчет.Дата МЕЖДУ &НачДата И &КонДата
	|		И АвансовыйОтчет.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		КомплектацияНоменклатуры.Ссылка,
	|		КомплектацияНоменклатуры.Номер
	|	ИЗ
	|		Документ.КомплектацияНоменклатуры КАК КомплектацияНоменклатуры
	|	ГДЕ
	|		КомплектацияНоменклатуры.Дата МЕЖДУ &НачДата И &КонДата
	|		И КомплектацияНоменклатуры.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		СчетФактураПолученный.Ссылка,
	|		СчетФактураПолученный.Номер
	|	ИЗ
	|		Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|	ГДЕ
	|		СчетФактураПолученный.Дата МЕЖДУ &НачДата И &КонДата
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ВозвратТоваровОтПокупателя.Ссылка,
	|		ВозвратТоваровОтПокупателя.Номер
	|	ИЗ
	|		Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	|	ГДЕ
	|		ВозвратТоваровОтПокупателя.Дата МЕЖДУ &НачДата И &КонДата
	|		И ВозвратТоваровОтПокупателя.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		СчетФактураВыданный.Ссылка,
	|		СчетФактураВыданный.Номер
	|	ИЗ
	|		Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|	ГДЕ
	|		СчетФактураВыданный.Дата МЕЖДУ &НачДата И &КонДата
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПеремещениеТоваров.Ссылка,
	|		ПеремещениеТоваров.Номер
	|	ИЗ
	|		Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|	ГДЕ
	|		ПеремещениеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|		И ПеремещениеТоваров.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		СписаниеТоваров.Ссылка,
	|		СписаниеТоваров.Номер
	|	ИЗ
	|		Документ.СписаниеТоваров КАК СписаниеТоваров
	|	ГДЕ
	|		СписаниеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|		И СписаниеТоваров.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ТребованиеНакладная.Ссылка,
	|		ТребованиеНакладная.Номер
	|	ИЗ
	|		Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|	ГДЕ
	|		ТребованиеНакладная.Дата МЕЖДУ &НачДата И &КонДата
	|		И ТребованиеНакладная.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ПлатежноеПоручениеВходящее.Ссылка,
	|		ПлатежноеПоручениеВходящее.Номер
	|	ИЗ
	|		Документ.ПлатежноеПоручениеВходящее КАК ПлатежноеПоручениеВходящее
	|	ГДЕ
	|		ПлатежноеПоручениеВходящее.Дата МЕЖДУ &НачДата И &КонДата
	|		И ПлатежноеПоручениеВходящее.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		ОперацияПоОтветственномуХранению.Ссылка,
	|		ОперацияПоОтветственномуХранению.Номер
	|	ИЗ
	|		Документ.ОперацияПоОтветственномуХранению КАК ОперацияПоОтветственномуХранению
	|	ГДЕ
	|		ОперацияПоОтветственномуХранению.Дата МЕЖДУ &НачДата И &КонДата
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ОтчетКомиссионераОПродажах.Ссылка,
	|		ОтчетКомиссионераОПродажах.Номер
	|	ИЗ
	|		Документ.ОтчетКомиссионераОПродажах КАК ОтчетКомиссионераОПродажах
	|	ГДЕ
	|		ОтчетКомиссионераОПродажах.Дата МЕЖДУ &НачДата И &КонДата
	|		И ОтчетКомиссионераОПродажах.ОтражатьВБухгалтерскомУчете
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ВозвратТоваровПоставщику.Ссылка,
	|		ВозвратТоваровПоставщику.Номер
	|	ИЗ
	|		Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|	ГДЕ
	|		ВозвратТоваровПоставщику.Дата МЕЖДУ &НачДата И &КонДата
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировкаРеализации.Ссылка,
	|		КорректировкаРеализации.Номер
	|	ИЗ
	|		Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|	ГДЕ
	|		КорректировкаРеализации.Дата МЕЖДУ &НачДата И &КонДата
	|		И КорректировкаРеализации.ОтражатьВБухгалтерскомУчете
	|) КАК Документы
	|ГДЕ
	|	Документы.Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Документы.Документ.Дата
	|";
	
	Запрос.УстановитьПараметр("НачДата", НачДата);
	Запрос.УстановитьПараметр("КонДата",КонецДня(КонДата));
	
	Возврат Запрос.Выполнить();
	
КонецФункции // ВыполнитьЗапросКТекБазе()
 
// <Описание функции>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   – <описание возвращаемого значения>
//
Функция ВыполнитьЗапросКВнешнейБазе(НачДата,КонДата)

	Запрос = ОбъектПодключения.NewObject("Запрос");
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Документ,
	|	РеализацияТоваровУслуг.Номер
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПоступлениеТоваровУслуг.Ссылка,
	|	ПоступлениеТоваровУслуг.Номер
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	|ГДЕ
	|	ПоступлениеТоваровУслуг.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ОприходованиеТоваров.Ссылка,
	|	ОприходованиеТоваров.Номер
	|ИЗ
	|	Документ.ОприходованиеТоваров КАК ОприходованиеТоваров
	|ГДЕ
	|	ОприходованиеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПриходныйКассовыйОрдер.Ссылка,
	|	ПриходныйКассовыйОрдер.Номер
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|ГДЕ
	|	ПриходныйКассовыйОрдер.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.Номер
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	АвансовыйОтчет.Ссылка,
	|	АвансовыйОтчет.Номер
	|ИЗ
	|	Документ.АвансовыйОтчет КАК АвансовыйОтчет
	|ГДЕ
	|	АвансовыйОтчет.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КомплектацияНоменклатуры.Ссылка,
	|	КомплектацияНоменклатуры.Номер
	|ИЗ
	|	Документ.КомплектацияНоменклатуры КАК КомплектацияНоменклатуры
	|ГДЕ
	|	КомплектацияНоменклатуры.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СчетФактураПолученный.Ссылка,
	|	СчетФактураПолученный.Номер
	|ИЗ
	|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
	|ГДЕ
	|	СчетФактураПолученный.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровОтПокупателя.Ссылка,
	|	ВозвратТоваровОтПокупателя.Номер
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя КАК ВозвратТоваровОтПокупателя
	|ГДЕ
	|	ВозвратТоваровОтПокупателя.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СчетФактураВыданный.Ссылка,
	|	СчетФактураВыданный.Номер
	|ИЗ
	|	Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|ГДЕ
	|	СчетФактураВыданный.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПеремещениеТоваров.Ссылка,
	|	ПеремещениеТоваров.Номер
	|ИЗ
	|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
	|ГДЕ
	|	ПеремещениеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СписаниеТоваров.Ссылка,
	|	СписаниеТоваров.Номер
	|ИЗ
	|	Документ.СписаниеТоваров КАК СписаниеТоваров
	|ГДЕ
	|	СписаниеТоваров.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ТребованиеНакладная.Ссылка,
	|	ТребованиеНакладная.Номер
	|ИЗ
	|	Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|ГДЕ
	|	ТребованиеНакладная.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ПоступлениеНаРасчетныйСчет.Ссылка,
	|	ПоступлениеНаРасчетныйСчет.Номер
	|ИЗ
	|	Документ.ПоступлениеНаРасчетныйСчет КАК ПоступлениеНаРасчетныйСчет
	|ГДЕ
	|	ПоступлениеНаРасчетныйСчет.Дата МЕЖДУ &НачДата И &КонДата
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СписаниеСРасчетногоСчета.Ссылка,
	|	СписаниеСРасчетногоСчета.Номер
	|ИЗ
	|	Документ.СписаниеСРасчетногоСчета КАК СписаниеСРасчетногоСчета
	|ГДЕ
	|	СписаниеСРасчетногоСчета.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ОтчетКомиссионераОПродажах.Ссылка,
	|	ОтчетКомиссионераОПродажах.Номер
	|ИЗ
	|	Документ.ОтчетКомиссионераОПродажах КАК ОтчетКомиссионераОПродажах
	|ГДЕ
	|	ОтчетКомиссионераОПродажах.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ВозвратТоваровПоставщику.Ссылка,
	|	ВозвратТоваровПоставщику.Номер
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|ГДЕ
	|	ВозвратТоваровПоставщику.Дата МЕЖДУ &НачДата И &КонДата
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	КорректировкаРеализации.Ссылка,
	|	КорректировкаРеализации.Номер
	|ИЗ
	|	Документ.КорректировкаРеализации КАК КорректировкаРеализации
	|ГДЕ
	|	КорректировкаРеализации.Дата МЕЖДУ &НачДата И &КонДата
	|";
	//|";
    СтрокаНачДата=СТрока(НачДата);
	Запрос.УстановитьПараметр("НачДата",НачДата);
	
	СтрокаКонДата=СТрока(КонДата);
	Запрос.УстановитьПараметр("КонДата",КонецДня(КонДата) );
                 
	
	Возврат Запрос.Выполнить();
	
КонецФункции // ВыполнитьЗапросКВнешнейБазе()

Функция ВыполнитьЗапросКВнешнейБазеПоДатеИНомеру(НачДата,КонДата)
    ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Номер");
	ТЗ.Колонки.Добавить("Дата");
	
Запрос = ОбъектПодключения.NewObject("Запрос");
Запрос.Текст = 
"ВЫБРАТЬ
|	ПередачаТоваров.Ссылка Документ,
|	ПередачаТоваров.Номер Номер,
|	ПередачаТоваров.Дата Дата
|ИЗ
|	Документ.ПередачаТоваров КАК ПередачаТоваров
|ГДЕ
|	ПередачаТоваров.Дата МЕЖДУ &НачДата И &КонДата   
|ОБЪЕДИНИТЬ
|ВЫБРАТЬ
|	ПоступлениеИзПереработки.Ссылка Документ,
|	ПоступлениеИзПереработки.Номер Номер,
|	ПоступлениеИзПереработки.Дата Дата
|ИЗ
|	Документ.ПоступлениеИзПереработки КАК ПоступлениеИзПереработки
|ГДЕ
|	ПоступлениеИзПереработки.Дата МЕЖДУ &НачДата И &КонДата
|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ОперацияПоОтветственномуХранению.Ссылка как Документ,
	|	ОперацияПоОтветственномуХранению.Номер,
	|	ОперацияПоОтветственномуХранению.Дата
	|ИЗ
	|	Документ.СписаниеТоваров КАК ОперацияПоОтветственномуХранению
	|ГДЕ
	|	ОперацияПоОтветственномуХранению.Дата МЕЖДУ &НачДата И &КонДата";

СтрокаНачДата=СТрока(НачДата);
Запрос.УстановитьПараметр("НачДата",НачДата);
	
СтрокаКонДата=СТрока(КонДата);
Запрос.УстановитьПараметр("КонДата",КонецДня(КонДата) );
                 
	
Выборка=Запрос.Выполнить().Выбрать();

Пока Выборка.Следующий() Цикл
	строкаТЗ=ТЗ.Добавить();
	строкаТЗ.Номер=СокрЛП(Строка(Выборка.Номер));
	строкаТЗ.Дата=Строка(Выборка.Дата);
КонецЦикла;	
Возврат ТЗ;

КонецФункции	

Процедура УстановитьУИД(ДеревоВнешнейБазы)

	ДеревоВнешнейБазы.Колонки.Добавить("УИД");	
	
	Для каждого СтрокаДокумента Из ДеревоВнешнейБазы Цикл
		
		//СтрокаДокумента.УИД = ОбъектПодключения.String(СтрокаДокумента.Документ.УникальныйИдентификатор());
	    СтрокаДокумента.УИД  =ОбъектПодключения.глВернутьСтрокуUUID(СтрокаДокумента.Документ);
	КонецЦикла; 

КонецПроцедуры
 

ВерсияПлатформыИнформационнойБазыДляПодключения = "V83";
АутентификацияWindowsИнформационнойБазыДляПодключения = Ложь;

ДеревоОтличий = Новый ТаблицаЗначений;
ДеревоОтличий.Колонки.Добавить("Документ");
ДеревоОтличий.Колонки.Добавить("Примечание");

мФакторинг = Справочники.ТипыДоговоров.НайтиПоНаименованию("Факторинг");