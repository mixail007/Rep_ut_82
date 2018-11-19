﻿
Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =ДобавитьМесяц(НачПериода,-3);

	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаН"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =НачПериода;
	
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =ДобавитьМесяц(КонПериода,1);

	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаК"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =КонецДня(КонПериода);

КонецПроцедуры

Процедура НачПериодаПриИзменении(Элемент)
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =ДобавитьМесяц(НачПериода,-3);

	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаН"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =НачПериода;

КонецПроцедуры

Процедура КонПериодаПриИзменении(Элемент)
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =ДобавитьМесяц(КонПериода,1);

	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДатаК"));
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =КонецДня(КонПериода);
КонецПроцедуры
