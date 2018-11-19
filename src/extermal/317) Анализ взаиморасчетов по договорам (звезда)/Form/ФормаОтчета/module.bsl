﻿
Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачДата, ?(КонДата='0001-01-01', КонДата, КонецДня(КонДата)));
	Если НастройкаПериода.Редактировать() Тогда
		НачДата = НастройкаПериода.ПолучитьДатуНачала();
		КонДата = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
	ПараметрДанныхНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачДата");
	ПараметрДанныхНачалоПериода.Значение = НачДата;
	ПараметрДанныхНачалоПериода.Использование = Истина;
	ПараметрДанныхНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонДата");
	ПараметрДанныхНачалоПериода.Значение = КонДата;
	ПараметрДанныхНачалоПериода.Использование = Истина;
КонецПроцедуры

Процедура НачДатаПриИзменении(Элемент)
	ПараметрДанныхНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачДата");
	ПараметрДанныхНачалоПериода.Значение = НачДата;
	ПараметрДанныхНачалоПериода.Использование = Истина;
КонецПроцедуры

Процедура КонДатаПриИзменении(Элемент)
	ПараметрДанныхНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонДата");
	ПараметрДанныхНачалоПериода.Значение = КонДата;
	ПараметрДанныхНачалоПериода.Использование = Истина;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	НачДата = НачалоГода(ТекущаяДата());
	КонДата = НачалоДня(ТекущаяДата())-1;
КонецПроцедуры
