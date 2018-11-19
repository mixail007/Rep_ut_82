﻿перем ТипИнформационнойБазыДляПодключения ,	
	ИмяСервераИнформационнойБазыДляПодключения ,
	ИмяИнформационнойБазыНаСервереДляПодключения ,
	ПользовательИнформационнойБазыДляПодключения ,
	ПарольИнформационнойБазыДляПодключения  ,	ВерсияПлатформыИнформационнойБазыДляПодключения ;
Перем ОбъектПодключения, РезультатПодключения Экспорт;


Процедура КнопкаВыполнитьНажатие(Кнопка)
	РезультатПодключения = ВыполнитьПодключениеКИБПриемнику(,,БазаИсточник);
	
	Если РезультатПодключения = Неопределено Тогда
		Предупреждение("Возникли ошибки при подключении к информационной базе ЯШТ УТ.");
		Возврат
	КонецЕсли;
	Если НачалоПериода=Дата(1,1,1) тогда
		Предупреждение("Выберите дату начала периода!");
		Возврат
	КонецЕсли;
	Если КонецПериода=Дата(1,1,1) тогда
		КонецПериода = НачалоПериода;
	КонецЕсли;
	
	Если НачалоДня(НачалоПериода) > КонецДня(КонецПериода) тогда
		Предупреждение("     Неверно задан период!
		|Дата начала > даты окончания!");
		Возврат
	КонецЕсли;
	
	Состояние("Выполняется запрос к внешней базе БП Зем...");
	
	ТЗРеализацииЗем = ВыполнитьЗапросКВнешнейБазеЗем(НачалоДня(НачалоПериода), КонецДня(КонецПериода),БазаИсточник);
	тз=новый ТаблицаЗначений;
	тз.Колонки.Добавить("Флаг",Новый ОписаниеТипов("Булево"));
	тз.Колонки.Добавить("Дата");
	тз.Колонки.Добавить("Номер");
	тз.Колонки.Добавить("Сумма");
	тз.Колонки.Добавить("Комментарий");
	тз.Колонки.Добавить("Ссылка");
	Для Каждого Строка Из ТЗРеализацииЗем Цикл
		нстр=тз.Добавить();
		нстр.флаг=Истина;
		нстр.Дата=Строка.Ссылка.Date;
		нстр.Номер=Строка.Ссылка.number;
		нстр.Сумма=Строка.Ссылка.СуммаДокумента;
		нстр.Комментарий=Строка.Ссылка.Комментарий;
		нстр.Ссылка=Строка.Ссылка;
		//нстр.Наименование=""+Строка.Ссылка.Date+" "+Строка.ССылка.number+" "+Строка.ССылка.СуммаДокумента+" "+Строка.ССылка.Комментарий;
	КонецЦикла;
	ТабПолеРеализации=тз;
	ЭлементыФормы.ТабПолеРеализации.СоздатьКолонки();
	ЭлементыФормы.ТабПолеРеализации.Колонки.Ссылка.Видимость=Ложь;
	ЭлементыФормы.ТабПолеРеализации.Колонки.Флаг.ДанныеФлажка="Флаг";
	ЭлементыФормы.ТабПолеРеализации.Колонки.Флаг.РежимРедактирования=РежимРедактированияКолонки.Непосредственно;
КонецПроцедуры

Функция ВыполнитьПодключениеКИБПриемнику(РезультатПодключения = Неопределено, СтрокаСообщенияОбОшибке = "", База) Экспорт
		
		СтруктураПодключения = СформироватьСтруктуруДляПодключения(База);
		ОбъектПодключения = ПодключитсяКИнформационнойБазе(СтруктураПодключения, СтрокаСообщенияОбОшибке);	
	
	Возврат ОбъектПодключения;
	
КонецФункции
Функция СформироватьСтруктуруДляПодключения(База)
	
	СтруктураПодключения = Новый Структура();
	
	СтруктураПодключения.Вставить("ТипПодключения", 1);
	СтруктураПодключения.Вставить("ФайловыйРежим", ложь);
	СтруктураПодключения.Вставить("АутентификацияWindows", Ложь);
	//СтруктураПодключения.Вставить("КаталогИБ", КаталогИнформационнойБазыДляПодключения);
	СтруктураПодключения.Вставить("ИмяСервера", ИмяСервераИнформационнойБазыДляПодключения);
	Если База="БП Землянский" тогда
		 СтруктураПодключения.Вставить("ИмяИБНаСервере", "v82ib_zemvorob_bp");
		 СтруктураПодключения.Вставить("Пользователь", ПользовательИнформационнойБазыДляПодключения);
		 СтруктураПодключения.Вставить("Пароль", ПарольИнформационнойБазыДляПодключения);
	ИначеЕсли База="БП Воробьев" тогда    //ЕДИНАЯ БАЗА С 31.08.2015
		 СтруктураПодключения.Вставить("ИмяИБНаСервере", "v82ib_zemvorob_bp");
		 //СтруктураПодключения.Вставить("Пользователь", "Головкина Анна");
		 //СтруктураПодключения.Вставить("Пароль", "274fyyf");
		 СтруктураПодключения.Вставить("Пользователь", ПользовательИнформационнойБазыДляПодключения);
		 СтруктураПодключения.Вставить("Пароль", ПарольИнформационнойБазыДляПодключения);
	КонецЕсли;
	//СтруктураПодключения.Вставить("ИмяИБНаСервере", ИмяИнформационнойБазыНаСервереДляПодключения);
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

Функция ВыполнитьЗапросКВнешнейБазеЗем(НачДата,КонДата,База) Экспорт 
	
	ЗапросВнешнийЗем = ОбъектПодключения.NewObject("Запрос");
	Если База = "БП Землянский" тогда
		ЗапросВнешнийЗем.Текст = "
		|ВЫБРАТЬ
		|	РеализацияТоваровУслугУслуги.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияТоваровУслугУслуги
		|ГДЕ
		|	РеализацияТоваровУслугУслуги.Ссылка.Контрагент.Код = ""000000003""
		|	И РеализацияТоваровУслугУслуги.Ссылка.ДоговорКонтрагента.Код = ""000000098""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Организация.Код = ""000000002""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Проведен = ИСТИНА
		|	И РеализацияТоваровУслугУслуги.Номенклатура.Код = ""000000465  ""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		//|	И НЕ РеализацияТоваровУслугУслуги.Ссылка.Комментарий ПОДОБНО ""%+30%""
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка"; 
	Иначе
		ЗапросВнешнийЗем.Текст = "
		|ВЫБРАТЬ
		|	РеализацияТоваровУслугУслуги.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияТоваровУслугУслуги
		|ГДЕ
		|	РеализацияТоваровУслугУслуги.Ссылка.Контрагент.Код = ""000000003""
		|	И РеализацияТоваровУслугУслуги.Ссылка.ДоговорКонтрагента.Код = ""000000001""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Организация.Код = ""000000001""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Проведен = ИСТИНА
		|	И РеализацияТоваровУслугУслуги.Номенклатура.Код = ""000000465  ""
		|	И РеализацияТоваровУслугУслуги.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
		//|	И НЕ РеализацияТоваровУслугУслуги.Ссылка.Комментарий ПОДОБНО ""%+30%""
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка"; 
	КонецЕсли;
	
	
	ЗапросВнешнийЗем.УстановитьПараметр("ДатаНач",НачДата);	
	ЗапросВнешнийЗем.УстановитьПараметр("ДатаКон",КонецДня(КонДата));
	
	РезультатЗапросаКЗем = ЗапросВнешнийЗем.Выполнить().Выгрузить();
	ОбъектПодключения = Неопределено;
	
	Возврат РезультатЗапросаКЗем;	
	
КонецФункции //


Процедура ПриОткрытии()
	ЭлементыФормы.БазаИсточник.СписокВыбора.Очистить();
    ЭлементыФормы.БазаИсточник.СписокВыбора.Добавить("БП Землянский");
    ЭлементыФормы.БазаИсточник.СписокВыбора.Добавить("БП Воробьев");
    ЭлементыФормы.БазаИсточник.Значение = "БП Землянский";
	
	
	ТипИнформационнойБазыДляПодключения = 0;	
	ИмяСервераИнформационнойБазыДляПодключения = "server";
	//ИмяИнформационнойБазыНаСервереДляПодключения = "v82ib_zem_bp";
	ПользовательИнформационнойБазыДляПодключения = "Робот";
	ПарольИнформационнойБазыДляПодключения = "09876";
	ВерсияПлатформыИнформационнойБазыДляПодключения = "V82";
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачалоПериода, ?(КонецПериода='0001-01-01', КонецПериода, КонецДня(КонецПериода)));
	Если НастройкаПериода.Редактировать() Тогда
		НачалоПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонецПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ОсновныеДействияФормыДействие(Кнопка)
	Если БазаИсточник="БП Землянский" тогда
		ЗемлянскийКонтр=Справочники.Контрагенты.НайтиПоКоду("00216  ");
		Договор = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("Б7346",ложь,,ЗемлянскийКонтр);
		//БанковскийСчет=Справочники.БанковскиеСчета.НайтиПоКоду(00382,ложь,,ЗемлянскийКонтр);
		БанковскийСчет=Справочники.БанковскиеСчета.НайтиПоКоду("00382",ложь,,ЗемлянскийКонтр);
		СкладУслуг=Справочники.Склады.НайтиПоКоду("00196");
		Номенклатура=Справочники.Номенклатура.НайтиПоКоду("ЛН00039");
		ОрганизацияЯШТ=Справочники.Организации.НайтиПоКоду("00001");
		ПодразделениеГоловное=Справочники.Подразделения.НайтиПоКоду("00005");
		СтатьяАвтоуслугиГрузовой=Справочники.СтатьиЗатрат.НайтиПоКоду("К0115");
	ИначеЕсли БазаИсточник="БП Воробьев" тогда
		ЗемлянскийКонтр=Справочники.Контрагенты.НайтиПоКоду("93833  ");
		Договор = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("Б9088",ложь,,ЗемлянскийКонтр);
		//БанковскийСчет=Справочники.БанковскиеСчета.НайтиПоКоду(00382,ложь,,ЗемлянскийКонтр);
		БанковскийСчет=Справочники.БанковскиеСчета.НайтиПоКоду("06284",ложь,,ЗемлянскийКонтр);
		СкладУслуг=Справочники.Склады.НайтиПоКоду("00196");
		Номенклатура=Справочники.Номенклатура.НайтиПоКоду("ЛН00039");
		ОрганизацияЯШТ=Справочники.Организации.НайтиПоКоду("00001");
		ПодразделениеГоловное=Справочники.Подразделения.НайтиПоКоду("00005");
		СтатьяАвтоуслугиГрузовой=Справочники.СтатьиЗатрат.НайтиПоКоду("К0115");
	КонецЕсли;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ПоступлениеТоваровУслуг.Номер,
	             |	ПоступлениеТоваровУслуг.Дата,
	             |	ПоступлениеТоваровУслуг.Проверен
	             |ИЗ
	             |	Документ.ПоступлениеТоваровУслуг КАК ПоступлениеТоваровУслуг
	             |ГДЕ
	             |	ПоступлениеТоваровУслуг.НомерВходящегоДокумента = &НомерВходящегоДокумента
	             |	И ПоступлениеТоваровУслуг.ДатаВходящегоДокумента = &ДатаВходящегоДокумента";
	
	тз=ЭлементыФормы.ТабПолеРеализации.Значение;
	Для каждого стр из тз Цикл
		Если стр.Флаг тогда
			входНомер=стр.Ссылка.Number;
			входНомер=СтрЗаменить(входНомер,"ВА","");
			// удаление ведущих нулей
			Пока Лев(входНомер, 1)="0" Цикл
				входНомер=Сред(входНомер, 2);
			КонецЦикла;
			
            Запрос.УстановитьПараметр("НомерВходящегоДокумента",входНомер);						 
			Запрос.УстановитьПараметр("ДатаВходящегоДокумента",НачалоДня(стр.Ссылка.Date));
			Рез=Запрос.Выполнить().Выбрать();
			//ВыборкаДокументов = Документы.ПоступлениеТоваровУслуг.Выбрать(НачалоДня(стр.Ссылка.Date), КонецДня(стр.Ссылка.Date), Новый Структура("НомерВходящегоДокумента", входНомер));
			Если Рез.Количество()>0 Тогда
				Рез.Следующий();
				Сообщить("Поступление № "+Рез.Номер+" от "+
				Рез.Дата+" по реализации № "+
				стр.Ссылка.Number+" от "+стр.Ссылка.Date+" уже СФОРМИРОВАНО"+
				?(Рез.Проверен, " И ПРОВЕРЕНО!", "!"));
				
			Иначе
				//Создадим док
				Док=Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
				//Док.Дата= стр.Ссылка.Date;
				Док.Дата= ТекущаяДата();
				Док.НомерВходящегоДокумента=входНомер;
				Док.ДатаВходящегоДокумента=стр.Ссылка.Date;
				Док.Организация=ОрганизацияЯШТ;
				Док.Контрагент=ЗемлянскийКонтр;
				Док.ДоговорКонтрагента=Договор;
				//Док.УстановитьНовыйНомер();
				УстановитьНомерДокумента(Док);
				Док.БанковскийСчетКонтрагента=БанковскийСчет;
				Док.СкладОрдер=СкладУслуг;
				Док.Подразделение=ПодразделениеГоловное;
				Док.ВалютаДокумента=Док.ДоговорКонтрагента.ВалютаВзаиморасчетов;
				Док.ВидПоступления=Перечисления.ВидыПоступленияТоваров.НаСклад;
				Док.КурсВзаиморасчетов=1;
				Док.КратностьВзаиморасчетов=1;
				Док.ОтражатьВБухгалтерскомУчете=Ложь;
				Док.ОтражатьВНалоговомУчете=Ложь;
				Док.ОтражатьВУправленческомУчете=Истина;
				Услуги=Док.Услуги;
				Комм="";
				Для Каждого СтрокаУслуги Из стр.Ссылка.Услуги Цикл
					Если СтрокаУслуги.Номенклатура.Код="000000465  " тогда
						НоваяСтрокаУслуги                  = Услуги.Добавить();
						НоваяСтрокаУслуги.Номенклатура     = Номенклатура;
						НоваяСтрокаУслуги.Содержание       = "Транспортные услуги";//СтрокаУслуги.Содержание;
						НоваяСтрокаУслуги.Количество       = СтрокаУслуги.Количество;
						НоваяСтрокаУслуги.Цена             = СтрокаУслуги.Цена;
						НоваяСтрокаУслуги.Сумма            = СтрокаУслуги.Сумма;
						НоваяСтрокаУслуги.СтавкаНДС        = перечисления.СтавкиНДС.БезНДС;
						НоваяСтрокаУслуги.СуммаНДС         = СтрокаУслуги.СуммаНДС;									   
						НоваяСтрокаУслуги.Подразделение    = ПодразделениеГоловное;
						НоваяСтрокаУслуги.СтатьяЗатрат     = СтатьяАвтоуслугиГрузовой;
						Комм=Комм+СтрокаУслуги.Содержание+" ";
					КонецЕсли;	
				КонецЦикла;
				Док.Комментарий=Комм;
				Док.Записать(РежимЗаписиДокумента.Проведение);
				Сообщить("Новый документ: "+Док);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	Сообщить("Готово.");

КонецПроцедуры

Процедура усФлажкиНажатие(Элемент)
	Для каждого стр из ЭлементыФормы.ТабПолеРеализации.Значение цикл
		стр.Флаг=истина;
	КонецЦикла;
КонецПроцедуры

Процедура снятьФлажкиНажатие(Элемент)
	Для каждого стр из ЭлементыФормы.ТабПолеРеализации.Значение цикл
		стр.Флаг=ложь;
	КонецЦикла;
КонецПроцедуры
