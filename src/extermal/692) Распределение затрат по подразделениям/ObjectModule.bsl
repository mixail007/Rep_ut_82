﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
список = Новый списокЗначений;
Список.Добавить(Справочники.СтатьиЗатрат.НайтиПоКоду("О0177"));//ндс
Список.Добавить(Справочники.СтатьиЗатрат.НайтиПоКоду("О0172"));//прибыль местный
Список.Добавить(Справочники.СтатьиЗатрат.НайтиПоКоду("О0174"));//прибыль федеральный	

ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтатьиНалогов"));
ПараметрСКД.Использование = Истина;
ПараметрСКД.Значение  =список;

ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НДС"));
ПараметрСКД.Использование = истина ;
ПараметрСКД.Значение  =Справочники.СтатьиЗатрат.НайтиПоКоду("О0177");
	
//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("прибыль"));
//ПараметрСКД.Использование = Истина;
//ПараметрСКД.Значение  =Справочники.СтатьиЗатрат.НайтиПоКоду("О0172");

КонецПроцедуры
