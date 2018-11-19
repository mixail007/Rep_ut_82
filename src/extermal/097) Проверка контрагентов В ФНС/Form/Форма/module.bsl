﻿

Процедура ПроверитьНаСервере()
	Ошибки.Очистить();	
	УРЛ = "http://npchk.nalog.ru/FNSNDSCAWS_2?wsdl";
	Определения = Новый WSОпределения(УРЛ);
	WSСервис = Определения.Сервисы[0];
	Прокси = Новый WSПрокси(Определения, WSСервис.URIПространстваИмен, WSСервис.Имя, WSСервис.ТочкиПодключения[0].Имя);    
	Фабрика = Прокси.ФабрикаXDTO;
	ТипWSПараметра = Фабрика.Пакеты.Получить("http://ws.unisoft/FNSNDSCAWS2/Request").Получить("NdsRequest2");
	WSПараметры = Прокси.ФабрикаXDTO.Создать(ТипWSПараметра);
	NP = ТипWSПараметра.Свойства[0];
	КоличествоЗаписанных = 1;
	Для Каждого Контрагент Из Контрагенты.НайтиСтроки(Новый Структура("Пометка", Истина)) Цикл
		
		Если КоличествоЗаписанных % 10000 = 0 Тогда 
			Проверенные = Прокси.NdsRequest2(WSПараметры);
			ОбработкаРезультата(Проверенные);	
			WSПараметры.NP.Clear();
			КоличествоЗаписанных = 1;
		КонецЕсли;
		
		Попытка
			КПП = СокрЛП(Строка(Контрагент.КПП));
			DT = ?(ФлагИспользоватьДатуВТабличномПоле, Контрагент.Дата, Дата);
			Параметр = Прокси.ФабрикаXDTO.Создать(NP.Тип);
			Параметр.INN = СокрЛП(Строка(Контрагент.ИНН));
			Если Не ПустаяСтрока(КПП) Тогда 
				Параметр.KPP = КПП;
			КонецЕсли;
			Если Не DT = '00010101' Тогда
				Параметр.DT = Формат(DT, "ДФ = ""дд.ММ.гггг""");
			КонецЕсли;
			WSПараметры.NP.Add(Параметр);	
		Исключение
			Ошибки.Добавить().ОписаниеОшибки = Строка(ОписаниеОшибки());
		КонецПопытки;
		КоличествоЗаписанных = КоличествоЗаписанных + 1;
	КонецЦикла;
	Если WSПараметры.NP.Count() > 0 Тогда 
		Проверенные = Прокси.NdsRequest2(WSПараметры); 	
		ОбработкаРезультата(Проверенные);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаРезультата(Проверенные)
	Для Каждого Проверенный Из Проверенные.NP Цикл 
		ИНН = Строка(Проверенный.INN);
		КПП = Строка(Проверенный.KPP);
		Статус = Проверенный.State;
		НайденныеСтроки = Контрагенты.НайтиСтроки(Новый Структура("ИНН,КПП", ИНН, КПП));
		Для Каждого Элемент Из НайденныеСтроки Цикл 
			Элемент.Существует = ?(Число(Статус) = 4, Ложь, Истина);
			Элемент.Статус = Статус;
		КонецЦикла;
	КонецЦикла;			   
	
КонецПроцедуры

Процедура Проверить(Команда)
	ПроверитьНаСервере();
КонецПроцедуры

Процедура ЗагрузитьКонтрагентовНаСервере()
	Контрагенты.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СправочникКонтрагенты.Ссылка КАК Контрагент,
	|	СправочникКонтрагенты.ИНН,
	|	СправочникКонтрагенты.КПП,
	|	ИСТИНА КАК Пометка,
	|	ЛОЖЬ КАК Существует
	|ИЗ
	|	Справочник.Контрагенты КАК СправочникКонтрагенты
	|ГДЕ
	|	НЕ СправочникКонтрагенты.ЭтоГруппа";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		нСтрока = Контрагенты.Добавить();
		ЗаполнитьЗначенияСвойств(нСтрока, Выборка);
		нСтрока.Дата = ТекущаяДата();
	КонецЦикла;
КонецПроцедуры

Процедура ЗагрузитьКонтрагентовНаСервереИНН()
	Контрагенты.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СправочникКонтрагенты.Ссылка КАК Контрагент,
	               |	СправочникКонтрагенты.ИНН,
	               |	СправочникКонтрагенты.КПП,
	               |	ИСТИНА КАК Пометка,
	               |	ЛОЖЬ КАК Существует
	               |ИЗ
	               |	Справочник.Контрагенты КАК СправочникКонтрагенты
	               |ГДЕ
	               |	НЕ СправочникКонтрагенты.ЭтоГруппа
	               |	И СправочникКонтрагенты.ИНН > """"";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		нСтрока = Контрагенты.Добавить();
		ЗаполнитьЗначенияСвойств(нСтрока, Выборка);
		нСтрока.Дата = ТекущаяДата();
	КонецЦикла;
КонецПроцедуры

Процедура ЗагрузитьКонтрагентовНаСервереИННЮрЛица()
Контрагенты.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СправочникКонтрагенты.Ссылка КАК Контрагент,
	               |	СправочникКонтрагенты.ИНН,
	               |	СправочникКонтрагенты.КПП,
	               |	ИСТИНА КАК Пометка,
	               |	ЛОЖЬ КАК Существует
	               |ИЗ
	               |	Справочник.Контрагенты КАК СправочникКонтрагенты
	               |ГДЕ
	               |	НЕ СправочникКонтрагенты.ЭтоГруппа
	               |	И СправочникКонтрагенты.ИНН > """"
	               |	И СправочникКонтрагенты.ЮрФизЛицо = &ЮрФизЛицо";
				   Запрос.УстановитьПараметр("ЮрФизЛицо",Перечисления.ЮрФизЛицо.ЮрЛицо);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		нСтрока = Контрагенты.Добавить();
		ЗаполнитьЗначенияСвойств(нСтрока, Выборка);
		нСтрока.Дата = ТекущаяДата();
	КонецЦикла;
КонецПроцедуры

Процедура ЗагрузитьКонтрагентов(Команда)
	ЗагрузитьКонтрагентовНаСервере();
КонецПроцедуры

Процедура ЗагрузитьКонтрагентовИНН(Команда)
	ЗагрузитьКонтрагентовНаСервереИНН();
КонецПроцедуры

Процедура УстановитьФлажкиНаСервере(Фл = Истина)
	Для Каждого Элемент Из Контрагенты Цикл
		Элемент.Пометка = Фл;
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьФлажки(Команда)
	УстановитьФлажкиНаСервере();
КонецПроцедуры

Процедура СнятьФлажки(Команда)
	УстановитьФлажкиНаСервере(Ложь);
КонецПроцедуры

Процедура ФлагИспользоватьДатуВТабличномПолеПриИзменении(Элемент)
	ФлагИспользоватьДатуВТабличномПолеПриИзмененииНаСервере();
КонецПроцедуры

Процедура ФлагИспользоватьДатуВТабличномПолеПриИзмененииНаСервере()
	ЭлементыФормы.Дата.Видимость = Не ФлагИспользоватьДатуВТабличномПоле;
	ЭлементыФормы.ТабличноеПоле1.Колонки.Дата.Видимость = ФлагИспользоватьДатуВТабличномПоле;
КонецПроцедуры

Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФлагИспользоватьДатуВТабличномПолеПриИзмененииНаСервере();
	Дата = ТекущаяДата();
КонецПроцедуры

Процедура ПриОткрытии()
	Дата = ТекущаяДата();
КонецПроцедуры

