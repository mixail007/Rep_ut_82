﻿
Процедура ПриОткрытии()
	СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			
	Параметр = СхемаКомпоновкиДанных.Параметры.Склад;
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = Справочники.Склады.НайтиПоКоду("02332");
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.Заказ;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = СсылкаНаОбъект;
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	Результат = ЭлементыФормы.ПолеТабличногоДокумента1;
	Результат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных); 
	
	Результат.ПоказатьУровеньГруппировокСтрок(0);

КонецПроцедуры

Процедура ОсновныеДействияФормыОсновныеДействияФормыВыполнить(Кнопка)
	СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
			
	Параметр = СхемаКомпоновкиДанных.Параметры.Склад;
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = Справочники.Склады.НайтиПоКоду("02332");
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
	
	Параметр = СхемаКомпоновкиДанных.Параметры.Заказ;
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = СсылкаНаОбъект;
		Параметр.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	КонецЕсли;
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	Результат = ЭлементыФормы.ПолеТабличногоДокумента1;
	Результат.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных); 
	
	Результат.ПоказатьУровеньГруппировокСтрок(0);

КонецПроцедуры
