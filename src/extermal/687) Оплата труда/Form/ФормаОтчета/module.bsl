﻿
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	ЭлементРасшифровкиДанных = ДанныеРасшифровки.Элементы[Расшифровка];
	ЭлементРасшифровкиДанныхПоля = ЭлементРасшифровкиДанных.ПолучитьПоля()[0];
		
		Попытка
			Аналитика1 =ЭлементРасшифровкиДанных.ПолучитьРодителей()[0].ПолучитьПоля()[0].Значение;  //ЭлементРасшифровкиДанных.ПолучитьРодителей()[0].ПолучитьРодителей()[0].ПолучитьРодителей()[0].получитьполя()[0]
		исключение
			Аналитика1 = Неопределено;
		конецпопытки;

		Попытка
			Год =ЭлементРасшифровкиДанных.ПолучитьРодителей()[1].ПолучитьПоля()[0].Значение;  //ЭлементРасшифровкиДанных.ПолучитьРодителей()[0].ПолучитьРодителей()[0].ПолучитьРодителей()[0].получитьполя()[0]
		исключение
			Год = Неопределено;
		конецпопытки;

		//	 Подразделение = Неопределено;
		//	 СтатьяЗатрат = Неопределено;
		//	 Ответственный = Неопределено;
		//	
		//	если ТипЗнч(Аналитика1) = Тип("СправочникСсылка.Подразделения") тогда
		//		Подразделение = Аналитика1;
		//		СтатьяЗатрат =  ЭлементРасшифровкиДанных.ПолучитьРодителей()[0].ПолучитьРодителей()[0].ПолучитьРодителей()[0].получитьполя()[0].Значение;
		//	конецЕсли;
		//	
		//	если ТипЗнч(Аналитика1) = Тип("СправочникСсылка.СтатьиЗатрат") тогда
		//		СтатьяЗатрат = Аналитика1;
		//	конецЕсли;
		//	
		//	если ТипЗнч(Аналитика1) = Тип("СправочникСсылка.Пользователи") тогда
		//		Ответственный = Аналитика1;
		//	конецЕсли;	
		
		если ТипЗнч(Аналитика1) = Тип("СправочникСсылка.ФизическиеЛица") тогда
					СтандартнаяОбработка = Ложь;

			Форма = ПолучитьФорму("ФормаРасшифровки");
			Если Аналитика1 <> неопределено тогда
			Форма.ФизЛицо = Аналитика1;
		   конецЕсли;
			Если год <> неопределено тогда
			ДатаНачала = Дата('20180101');
	        ДатаКонца = Дата('20181231');
			форма.началоПериода = ДобавитьМесяц( ДатаНачала,-12*(2018-Год));
			Форма.КонецПериода = КонецДня(ДобавитьМесяц(ДатаКонца,-12*(2018-Год))); 
		иначе
			форма.началоПериода = Дата('20130101');
			Форма.КонецПериода = Дата('20171231235959'); 
			конецЕсли;
		//	конецЕсли;
			форма.Открыть();
		//
		//
		
			конецЕсли;
		
		
КонецПроцедуры

Процедура ПриОткрытии()
	Если глТекущийПользователь <> справочники.Пользователи.НайтиПоКоду("Малышев")и глТекущийПользователь <> справочники.Пользователи.НайтиПоКоду("Аверкина") и глТекущийПользователь <> справочники.Пользователи.НайтиПоКоду("Алексеева А.Е.")и глТекущийПользователь <> справочники.Пользователи.НайтиПоКоду("Лапенков")и глТекущийПользователь <> справочники.Пользователи.НайтиПоКоду("Соковых Е.С.") тогда
		Закрыть();
	конецЕсли;	
КонецПроцедуры

Процедура ДействияФормыПоПодразделениям(Кнопка)
	Для каждого Настройка Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Если Кнопка.Текст = Настройка.Представление тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(Настройка.Настройки);
			
			//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачФ");
			//ПараметрСКД.Использование = Истина;
			//ПараметрСКД.Значение  = ДобавитьМесяц( ПериодПланирования.ДатаНачала,-12);
			//
			//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонФ");
			//ПараметрСКД.Использование = Истина;
			//ПараметрСКД.Значение  = КонецДня(ДобавитьМесяц( ПериодПланирования.ДатаКонца,-12));  
			//
			//
			//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодПланирования");
			//ПараметрСКД.Использование = Истина;
			//ПараметрСКД.Значение  =  ПериодПланирования;
			
			ЭлементыФормы.ДействияФормы.Кнопки.Кнопка.текст= Настройка.Представление;
			Прервать;
		КонецЕсли;
	конецЦикла;
КонецПроцедуры
