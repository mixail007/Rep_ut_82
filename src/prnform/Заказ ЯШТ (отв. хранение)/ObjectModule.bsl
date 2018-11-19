﻿Функция Печать() Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Очистить();
	
	
	СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.реплика;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Справочники.Производители.НайтиПоКоду("65");
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.репликаТД;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Справочники.Производители.НайтиПоКоду("3333");                     
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	
		
	Параметр = СхемаКомпоновкиДанных.Параметры.ДатаНач;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = НачалоДня(СсылкаНаОбъект.Дата);
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.ДатаКон;
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = ?(СсылкаНаОбъект.ДатаДействияПо='00010101',КонецГода(ТекущаяДата()), КонецДня(СсылкаНаОбъект.ДатаДействияПо) );
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.Подразделение;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Справочники.Подразделения.НайтиПоКоду("00005");
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.Ссылка;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = СсылкаНаОбъект;
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.ТекДата;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = ТекущаяДата();
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.Транзит;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Ложь;
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ТабДок);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных); 
	
	//ТабДок.ПоказатьУровеньГруппировокСтрок(0);
	
	
    возврат ТабДок;
	
КонецФункции