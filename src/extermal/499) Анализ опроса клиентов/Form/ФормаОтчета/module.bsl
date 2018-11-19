﻿Перем ТаблЗнач;

Процедура ПериодОпросаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	Элемент.СписокВыбора.Очистить();
	Элемент.СписокВыбора.Добавить(Формат('20160601',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20160801',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20170101',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20170601',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20170801',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20180101',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20180601',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20180801',"ДФ='ММММ гггг'"));
	Элемент.СписокВыбора.Добавить(Формат('20190101',"ДФ='ММММ гггг'"));
	ТаблЗнач = Новый Массив;
	ТаблЗнач.Добавить('20160601');
	ТаблЗнач.Добавить('20160801');
	ТаблЗнач.Добавить('20170101');
	ТаблЗнач.Добавить('20170601');
	ТаблЗнач.Добавить('20170801');
	ТаблЗнач.Добавить('20180101');
    ТаблЗнач.Добавить('20180601');
    ТаблЗнач.Добавить('20180801');
    ТаблЗнач.Добавить('20190101');
КонецПроцедуры

Процедура ПериодОпросаПриИзменении(Элемент)
	Для i=0 по ЭлементыФормы.ПериодОпроса.СписокВыбора.Количество()-1 Цикл 
		Если ЭлементыФормы.ПериодОпроса.СписокВыбора[i].Значение = Элемент.Значение Тогда
			Период = ТаблЗнач[i];
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета");
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =Период;

КонецПроцедуры

Процедура ПериодОпросаОчистка(Элемент, СтандартнаяОбработка)
	Период = Дата(1,1,1);
КонецПроцедуры

Процедура ПриОткрытии()
	Период = Дата(1,1,1);
	ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПериодОтчета");
	ПараметрСКД.Использование = Истина;
	ПараметрСКД.Значение  =Период;

КонецПроцедуры
