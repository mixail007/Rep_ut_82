﻿
Процедура ДатаПриИзменении(Элемент)
	ПарамДата = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Дата");
	Если НЕ ПарамДата = Неопределено Тогда
   		ПарамДата.Значение = НачалоДня(Дата);
	КонецЕсли;
КонецПроцедуры

Процедура ПриОткрытии()
	Производитель = Новый СписокЗначений;
	Производитель.Добавить(Справочники.Производители.НайтиПоКоду("65"));
	Производитель.Добавить(Справочники.Производители.НайтиПоКоду("3333"));

	ПарамПроизводитель = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Производитель");
	ПарамПроизводитель.Использование = Истина;
	ПарамПроизводитель.Значение  = Производитель;

	Родитель = Новый СписокЗначений;
	Родитель.Добавить(Справочники.Номенклатура.НайтиПоКоду("0000702"));
	Родитель.Добавить(Справочники.Номенклатура.НайтиПоКоду("0000713"));

	ПарамРодитель = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Родитель");
	ПарамРодитель.Использование = Истина;
	ПарамРодитель.Значение  = Родитель;

	ПарамДата = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Дата");
	Если НЕ ПарамДата = Неопределено Тогда
   		ПарамДата.Значение = НачалоГода(НачалоГода(ТекущаяДата())-1);
	КонецЕсли;

	Дата =  НачалоГода(НачалоГода(ТекущаяДата())-1);

КонецПроцедуры
