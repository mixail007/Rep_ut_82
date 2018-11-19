﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = НачалоДня(дата1);
        Параметр.Использование = Истина;
	КонецЕсли;

	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = КонецДня(дата2);
        Параметр.Использование = Истина;
	КонецЕсли;
	
	Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НаправлениеПродаж"));
    Если Параметр <> Неопределено Тогда
        Параметр.Значение = Справочники.НаправленияПродаж.НайтиПоНаименованию("18. ""Колеса ТУТ""");
        Параметр.Использование = Истина;
	КонецЕсли;
КонецПроцедуры
