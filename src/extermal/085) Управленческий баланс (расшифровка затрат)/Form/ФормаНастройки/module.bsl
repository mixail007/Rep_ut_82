﻿

Процедура ВыводПоПризнакуКонтрагентаПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ЗаполнитьПоПризнаку = ВыводПоПризнакуКонтрагента;
КонецПроцедуры

Процедура ПриОткрытии()
	// Вставить содержимое обработчика.
	ВыводПоПризнакуКонтрагента = ЗаполнитьПоПризнаку;
	ТорговаяКомпания = ТорговаяКомпанияЭлемент;
КонецПроцедуры

Процедура ТорговаяКомпанияПриИзменении(Элемент)
	// Вставить содержимое обработчика.
	ТорговаяКомпанияЭлемент = ТорговаяКомпания;
КонецПроцедуры

Процедура ТорговаяКомпанияОчистка(Элемент, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	ТорговаяКомпанияЭлемент = Справочники.Контрагенты.ПустаяСсылка();	
КонецПроцедуры
