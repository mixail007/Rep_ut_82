﻿процедура УстановитьПараметрыВОтчет() экспорт
     Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Производитель"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = Производитель;
        Параметр.Использование = Истина;
	КонецЕсли;

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Скидка"));
	Если Параметр <> Неопределено Тогда
		если Скидка<0 тогда //16.03.2018
        	Параметр.Значение = Скидка;   //отрицательная!
		иначе 
        	Параметр.Значение = -Скидка;  //написали как положительную
		КонецЕсли;
        Параметр.Использование = Истина;
	КонецЕсли;

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВидСравнения"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = ВидСравнения;
        Параметр.Использование = Истина;
	КонецЕсли;

	//+++ 21.11.2018
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаНач"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение.Дата = ДатаНач;
        Параметр.Использование = Истина;
	КонецЕсли;
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаКон"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение.Дата = КонецДня(ДатаКон);
        Параметр.Использование = Истина;
	КонецЕсли;
	
	//+++ доп. условия - лучше через параметры!	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Диски"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = Перечисления.ВидыТоваров.Диски;
        Параметр.Использование = Истина;
	КонецЕсли;
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Литые"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = справочники.НоменклатурныеГруппы.НайтиПоКоду("00026");
        Параметр.Использование = Истина;
	КонецЕсли;
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Штампованные"));
	Если Параметр <> Неопределено Тогда
        Параметр.Значение = справочники.НоменклатурныеГруппы.НайтиПоКоду("00049");
        Параметр.Использование = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
   УстановитьПараметрыВОтчет()
КонецПроцедуры
