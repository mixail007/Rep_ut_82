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
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНач");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = НачалоДня(НачПериода);
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаКон");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = КонецДня(КонПериода);
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтборДаты");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Ложь;
КонецПроцедуры

Процедура НачПериодаПриИзменении(Элемент)
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаНач");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = НачалоДня(НачПериода);
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтборДаты");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Истина;

КонецПроцедуры

Процедура КонПериодаПриИзменении(Элемент)
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаКон");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = КонецДня(КонПериода);
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтборДаты");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Истина;
КонецПроцедуры

Процедура ПриОткрытии()
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ОтборДаты");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Ложь;
	
	Ответственный = глТекущийПользователь;
КонецПроцедуры

Процедура КонтрагентПриИзменении(Элемент)
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Контрагент");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Контрагент;
КонецПроцедуры

Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДоговорКонтрагента");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = ДоговорКонтрагента;
КонецПроцедуры

Процедура ОтветственныйПриИзменении(Элемент)
	//ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Менеджер");
	//ПараметрСКД.Использование = Истина;
	//ПараметрСКД.Значение = Ответственный;

КонецПроцедуры
