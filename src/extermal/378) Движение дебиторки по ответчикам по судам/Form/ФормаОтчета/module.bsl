﻿
Процедура ПриОткрытии()
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Категория");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = Справочники.КатегорииОбъектов.НайтиПоКоду("00035");
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = НачалоДня(ТекущаяДата()-7*24*60*60);
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = КонецДня(ТекущаяДата());
КонецПроцедуры


Процедура ДействияФормыДействие(Кнопка)
	ЭтотОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат);   //стандартное формирование, далее своё получение по COMу
	
	
	//удалитьфайлы(КаталогВременныхФайлов(),"*.mxl");
	
	UsrPwd = "Usr=""Робот (центр - номенклатура)"";Pwd=""09876""";
	//Base  = "File=""C:\Базы 1С\Бухгалтерия ЯШТ копия";
	//Base   = "File=""C:\Базы 1С\Бухгалтерия ЯШТ копия"""; 
	Base   =  "Srvr=""server:3041"";Ref=""v83ib_yst_bp""";
	v8connect = Новый COMОбъект("V83.ComConnector");
	СтрокаСоединенияCOM = Base+";"+UsrPwd;
	Попытка
		Соединение = v8connect.Connect(СтрокаСоединенияCOM);
		#Если Клиент Тогда
			Сообщить(строка(ТекущаяДата())+" Успешно Установлено подключение к базе 1С V8:"+base, СтатусСообщения.Информация);
		#КонецЕсли
	Исключение
		#Если Клиент Тогда
			Сообщить("НЕТ подключения к базе 1С V8:"+base+" ! ", СтатусСообщения.Внимание);
		#КонецЕсли
		Возврат;
	КонецПопытки;
	
	////////////////////////////
	
	параметр1 = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
	параметр2 = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	//
	//Дата1 = параметр1.Значение;
	//Дата2 = параметр2.Значение;
	//// Вставить содержимое обработчика.
	//ОтчетБУ = Соединение.Отчеты.ОборотноСальдоваяВедомостьПоСчету.Создать();
	//ОтчетБУ.РежимРасшифровки = Истина;
	//ОтчетБУ.Счет = Соединение.ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям ;
	//ОтчетБУ.Организация = Соединение.Справочники.Организации.НайтиПоКоду("00015");
	//ОтчетБУ.НачалоПериода = НачалоДня(Дата1);
	//ОтчетБУ.КонецПериода  = КонецДня(Дата2);
	//ОтчетБУ.СохранятьНастройкуОтчета = ложь;
	//ОтчетБУ.Настроить();
	//ОтчетБУ.НастройкиФормы.Вставить("ВыводитьЗаголовок", ложь);
	//ОтчетБУ.НастройкиФормы.Вставить("ВыводитьПодписи", ложь);
	//
	
	запрос  = Соединение.NewObject("Запрос");
	
	запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ		
	|	ОстаткиИОбороты.Субконто1 КАК Субконто1,
	|	ОстаткиИОбороты.Субконто2 КАК Субконто2,
	|	ОстаткиИОбороты.Субконто3 КАК Субконто3,		
	|	ПРЕДСТАВЛЕНИЕ(ОстаткиИОбороты.Субконто3) КАК Субконто3Представление,		
	|	ОстаткиИОбороты.Подразделение КАК Подразделение,
	|	ОстаткиИОбороты.СуммаНачальныйОстатокДт КАК БУНачальныйОстатокДт,
	|	ОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокДт КАК БУНачальныйРазвернутыйОстатокДт,
	|	ОстаткиИОбороты.СуммаНачальныйОстатокКт КАК БУНачальныйОстатокКт,
	|	ОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокКт КАК БУНачальныйРазвернутыйОстатокКт,
	|	ОстаткиИОбороты.СуммаОборотДт КАК БУОборотДт,
	|	ОстаткиИОбороты.СуммаОборотКт КАК БУОборотКт,
	|	ОстаткиИОбороты.СуммаКонечныйОстатокДт КАК БУКонечныйОстатокДт,
	|	ОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт КАК БУКонечныйРазвернутыйОстатокДт,
	|	ОстаткиИОбороты.СуммаКонечныйОстатокКт КАК БУКонечныйОстатокКт,
	|	ОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт КАК БУКонечныйРазвернутыйОстатокКт,		
	|	ОстаткиИОбороты.КоличествоНачальныйОстатокДт КАК КоличествоНачальныйОстатокДт,
	|	ОстаткиИОбороты.КоличествоНачальныйРазвернутыйОстатокДт КАК КоличествоНачальныйРазвернутыйОстатокДт,
	|	ОстаткиИОбороты.КоличествоНачальныйОстатокКт КАК КоличествоНачальныйОстатокКт,
	|	ОстаткиИОбороты.КоличествоНачальныйРазвернутыйОстатокКт КАК КоличествоНачальныйРазвернутыйОстатокКт,
	|	ОстаткиИОбороты.КоличествоОборотДт КАК КоличествоОборотДт,
	|	ОстаткиИОбороты.КоличествоОборотКт КАК КоличествоОборотКт,
	|	ОстаткиИОбороты.КоличествоКонечныйОстатокДт КАК КоличествоКонечныйОстатокДт,
	|	ОстаткиИОбороты.КоличествоКонечныйРазвернутыйОстатокДт КАК КоличествоКонечныйРазвернутыйОстатокДт,
	|	ОстаткиИОбороты.КоличествоКонечныйОстатокКт КАК КоличествоКонечныйОстатокКт,
	|	ОстаткиИОбороты.КоличествоКонечныйРазвернутыйОстатокКт КАК КоличествоКонечныйРазвернутыйОстатокКт	
	|	
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОстаткиИОбороты(&НачалоПериода, &КонецПериода, , , Счет В ИЕРАРХИИ (&Счет), ,Организация = &Организация ) КАК ОстаткиИОбороты" ;
	
	
	запрос.УстановитьПараметр("НачалоПериода", Дата(параметр1.Значение));
	запрос.УстановитьПараметр("КонецПериода", Дата(параметр2.Значение));
	запрос.УстановитьПараметр("Счет", Соединение.ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям);
	запрос.УстановитьПараметр("Организация", Соединение.Справочники.Организации.НайтиПоКоду("00015"));
	
	ТЗ = запрос.Выполнить().Выгрузить();
	
	
	ТаблицаИзБухгалтерии = Новый ТаблицаЗначений;
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто1Код",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(11)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто1Наименование",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(30)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто2Код",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(11)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто2Наименование",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(50)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто3Код",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(11)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("Субконто3Наименование",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(50)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("ПодразделениеКод",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(11)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("ПодразделениеНаименование",    Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(50)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУНачальныйОстатокДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУНачальныйОстатокКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУОборотДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУОборотКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУКонечныйОстатокДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("БУКонечныйОстатокКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоНачальныйОстатокДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоНачальныйОстатокКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоОборотДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоОборотКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоКонечныйОстатокДт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	ТаблицаИзБухгалтерии.Колонки.Добавить("КоличествоКонечныйОстатокКт",    Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15, 2)));
	
	
	
	ВсегоСтрок = ТЗ.Count()-1;
	Для НомерСтроки = 0 По ВсегоСтрок Цикл
		Строка = ТЗ.Get(НомерСтроки);
		НоваяСтрока						 = ТаблицаИзБухгалтерии.Добавить();
		НоваяСтрока.Субконто1Наименование = СокрЛП(Строка.Субконто1.Description);
		НоваяСтрока.Субконто1Код			 = СокрЛП(Строка.Субконто1.Code);
		НоваяСтрока.Субконто2Наименование = СокрЛП(Строка.Субконто2.Description);
		НоваяСтрока.Субконто2Код			 = СокрЛП(Строка.Субконто2.Code);
		Если Строка.Субконто3 <> Неопределено тогда
			НоваяСтрока.Субконто3Наименование = Строка.Субконто3Представление;
			//НоваяСтрока.Субконто3Код			 = Строка.Субконто3.Code; 
		КонецЕсли;
		// НоваяСтрока.Субконто3			 = Строка.Субконто3;
		НоваяСтрока.ПодразделениеНаименование = СокрЛП(Строка.Подразделение.Description);
		НоваяСтрока.ПодразделениеКод			 = СокрЛП(Строка.Подразделение.Code);
		НоваяСтрока.БУНачальныйОстатокДт	 = Строка.БУНачальныйОстатокДт;
		НоваяСтрока.БУНачальныйОстатокКт	 = Строка.БУНачальныйОстатокКт;
		НоваяСтрока.БУОборотДт			 = Строка.БУОборотДт;
		НоваяСтрока.БУОборотКт			 = Строка.БУОборотКт;
		НоваяСтрока.БУКонечныйОстатокДт	 = Строка.БУКонечныйОстатокДт;
		НоваяСтрока.БУКонечныйОстатокКт	 = Строка.БУКонечныйОстатокКт;
		
		НоваяСтрока.КоличествоНачальныйОстатокДт = Строка.КоличествоНачальныйОстатокДт;
		НоваяСтрока.КоличествоНачальныйОстатокКт = Строка.КоличествоНачальныйОстатокКт;
		
		НоваяСтрока.КоличествоОборотДт = Строка.КоличествоОборотДт;
		НоваяСтрока.КоличествоОборотКт = Строка.КоличествоОборотКт;
		
		НоваяСтрока.КоличествоКонечныйОстатокДт = Строка.КоличествоКонечныйОстатокДт;
		НоваяСтрока.КоличествоКонечныйОстатокКт = Строка.КоличествоКонечныйОстатокКт;
		
	КонецЦикла;
	
	Соединение = Неопределено;
	
	
	
	запрос 		= новый Запрос;
	запрос.Текст 	= 	   "ВЫБРАТЬ *
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ВТ КАК ВТ
	|	   
	|;
	|
	|/////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Субконто1Наименование,
	|	ВТ.Субконто1Код,
	|	ВТ.Субконто2Код,
	|	ВТ.Субконто2Наименование,
	|	ВТ.Субконто3Наименование,
	|	ВТ.ПодразделениеНаименование,
	|	ВТ.ПодразделениеКод,
	|	ВТ.БУНачальныйОстатокДт,
	|	ВТ.БУНачальныйОстатокКт,
	|	ВТ.БУОборотДт,
	|	ВТ.БУОборотКт,
	|	ВТ.БУКонечныйОстатокДт,
	|	ВТ.БУКонечныйОстатокКт,
	|	ВТ.КоличествоКонечныйОстатокКт,
	|	ВТ.КоличествоКонечныйОстатокДт,
	|	ВТ.КоличествоНачальныйОстатокДт,
	|	ВТ.КоличествоНачальныйОстатокКт,
	|	ВТ.КоличествоОборотКт,
	|	ВТ.КоличествоОборотДт,
	|	ДоговорыКонтрагентов.Ссылка КАК ДоговорСсылка,
	|	Контрагенты.Ссылка КАК КонтрагентСсылка,
	|	Подразделения.Ссылка КАК ПодразделениеСсылка
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО ВТ.Субконто1Код = Контрагенты.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Подразделения КАК Подразделения
	|		ПО ВТ.ПодразделениеКод = Подразделения.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО ВТ.Субконто2Код = ДоговорыКонтрагентов.Код И ДоговорыКонтрагентов.Владелец = Контрагенты.Ссылка" ;
	
	
	запрос.УстановитьПараметр("ВТ", ТаблицаИзБухгалтерии);
	
	ТЗ  =запрос.Выполнить().Выгрузить();
	
	
	
	
	НаборыДанных = Новый Структура("ТЗ", ТЗ);
	//СКД = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	СКД = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных1"); 
	//КомпоновщикНастроек.ЗагрузитьНастройки(СКД.Настройки); 
	
	
	КомпМакета = новый КомпоновщикМакетаКомпоновкиДанных;
	макетКомп = КомпМакета.Выполнить(СКД, СКД.НастройкиПоУмолчанию);
	ПроцессорКомпДанных = новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпДанных.Инициализировать(макетКомп, НаборыДанных);
	
	вывод = новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	вывод.УстановитьДокумент(ЭлементыФормы.РезультатБУ);
	вывод.Вывести(ПроцессорКомпДанных, истина);
	
	
	
	
	
	//результат.Записать(КаталогВременныхФайлов()+"\ОтчетПоОтветчикамПоСудам.mxl");
	///////////////////////////////
	
	//ТабДок = новый ТабличныйДокумент;
	//ТабДок.Прочитать(КаталогВременныхФайлов()+"\ОтчетПоОтветчикамПоСудам.mxl");
	//ЭлементыФормы.РезультатБУ.Вывести(ТабДок);
	
	
	
КонецПроцедуры
   
