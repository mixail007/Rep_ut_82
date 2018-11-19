﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
			
		
	Параметр1 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	Параметр2 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Параметр1.Значение = ПериодПланирования.ДатаНачала;
	Параметр1.Использование = Истина;
	
	Параметр2.Значение = ПериодПланирования.ДатаКонца;
	Параметр2.Использование = Истина;
	
	Параметр3 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПериодПланирования"));
	Параметр4 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Затраты"));
	
	Параметр3.Значение = ПериодПланирования;
	Параметр3.Использование = Истина;
	
	Параметр4.Значение = ПланыСчетов.Хозрасчетный.ОбщехозяйственныеРасходы;
	Параметр4.Использование = Истина;
	
	//Параметр2 = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ГоловноеПодразделение"));
	//
	//Параметр1.Значение = Справочники.Подразделения.НайтиПоКоду("00005");
	//Параметр1.Использование = Истина;


			
			
	
КонецПроцедуры
