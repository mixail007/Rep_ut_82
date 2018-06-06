﻿
//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураПараметрыОтбора") Тогда
		
		Если Параметры.СтруктураПараметрыОтбора.Свойство("Статус") Тогда
			
			НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Статус");
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.ПравоеЗначение = Параметры.СтруктураПараметрыОтбора.Статус;
			НовыйЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
		
		Если Параметры.СтруктураПараметрыОтбора.Свойство("ФискальноеУстройство") Тогда
			
			НовыйЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ФискальноеУстройство");
			НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			НовыйЭлементОтбора.ПравоеЗначение = Параметры.СтруктураПараметрыОтбора.ФискальноеУстройство;
			НовыйЭлементОтбора.Использование = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти
