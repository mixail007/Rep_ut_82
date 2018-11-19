﻿Функция ПечатьТабеляКонтролера(Тип)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|   Номер,
	|	Дата,
	|	Организация,
	|	Склад,
	|	Сотрудник,
	|	Ответственный,
	|	Подразделение
	|ИЗ
	|	Документ.ПриемкаОТК КАК ПриемкаОТК
	|
	|ГДЕ
	|	ПриемкаОТК.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	ТабДокумент = Новый ТабличныйДокумент;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект.Ссылка);
	Запрос.Текст = "
		|ВЫБРАТЬ Ошиповщик, Номенклатура, Сумма(Количество) КАК Осмотрено, Сумма(Принято) КАК Принято, Сумма(Забраковано) КАК Забраковано		
		|ИЗ
		|Документ.ПриемкаОТК.Товары как ТЧ	
		|ГДЕ
		|ТЧ.Ссылка = &Ссылка	
		|СГРУППИРОВАТЬ ПО Ошиповщик, Номенклатура";

	ЗапросТовары = Запрос.Выполнить().Выгрузить();

	Макет = ПолучитьМакет("Табель");

	// Выводим шапку табеля
	ТекстЗаголовка = "Табель контролера по документу приемки № " + Шапка.Номер + " за " + Формат(Шапка.Дата,"ДЛФ=ДД");
	
	ОбластьМакета       				= Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;	
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета       				= Макет.ПолучитьОбласть("Контролер");
	ОбластьМакета.Параметры.Контролер 	= Шапка.Сотрудник;
	ТабДокумент.Вывести(ОбластьМакета);
	
	// Выводим текст табеля
	ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
	ТабДокумент.Вывести(ОбластьШапки);
	ОбластьСотрудника   = Макет.ПолучитьОбласть("СтрокаСотрудника");
	ОбластьНоменклатуры = Макет.ПолучитьОбласть("СтрокаНоменклатуры");
	ТаблицаТоваров = УбратьПовторяющихсяСотрудников(ЗапросТовары);
	ФлагГруппы = Ложь;
	ЗапросРасценки = новый Запрос;
	ЗапросРасценки.Текст = "
	|Выбрать Сумма
	|Из РегистрСведений.Расценки.СрезПоследних(&Дата, ВидРасценки = &ВидРасценки)";
	ЗапросРасценки.УстановитьПараметр("Дата",Шапка.Дата);
	ЗапросРасценки.УстановитьПараметр("ВидРасценки",Перечисления.ВидыРасценок.РасценкаКонтролераОшиповки);
	Выборка = ЗапросРасценки.Выполнить().Выбрать();
	Выборка.Следующий();
	Расценка = Выборка.Сумма;
	Для й=0 по ТаблицаТоваров.Количество()-1 Цикл
		Стр = ТаблицаТоваров.Получить(й);
		Если (Стр.Ошиповщик<>Справочники.ФизическиеЛица.ПустаяСсылка()) Тогда 
			Если (ФлагГруппы) Тогда
				ТабДокумент.ЗакончитьГруппуСтрок();
			КонецЕсли;
			ОбластьСотрудника.Параметры.Наименование = Стр.Ошиповщик;
			ТабДокумент.Вывести(ОбластьСотрудника);
			ТабДокумент.НачатьГруппуСтрок();
			ОбластьНоменклатуры.Параметры.Наименование = Стр.Номенклатура;
			ОбластьНоменклатуры.Параметры.Осмотрено = Стр.Осмотрено;
			ОбластьНоменклатуры.Параметры.Принято = Стр.Принято;
			ОбластьНоменклатуры.Параметры.Забраковано = Стр.Забраковано;
			ОбластьНоменклатуры.Параметры.Стоимость = Стр.Забраковано * Расценка;
			ТабДокумент.Вывести(ОбластьНоменклатуры);
		Иначе 
			ОбластьНоменклатуры.Параметры.Наименование = Стр.Номенклатура;
			ОбластьНоменклатуры.Параметры.Осмотрено = Стр.Осмотрено;
			ОбластьНоменклатуры.Параметры.Принято = Стр.Принято;
			ОбластьНоменклатуры.Параметры.Забраковано = Стр.Забраковано;
			ОбластьНоменклатуры.Параметры.Стоимость = Стр.Забраковано * Расценка;
			ТабДокумент.Вывести(ОбластьНоменклатуры);
		КонецЕсли;	
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подпись");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;

КонецФункции 

Функция Печать() экспорт
	
	ТабДокумент = ПечатьТабеляКонтролера("Табель");
	Возврат ТабДокумент;
	
КонецФункции
						  
Функция УбратьПовторяющихсяСотрудников(ЗапросТовары)
	
	СвернутыйЗапрос = ЗапросТовары.Скопировать();
	СвернутыйЗапрос.Свернуть("Ошиповщик");
	ИзмененныйЗапрос = ЗапросТовары.Скопировать();
	Для й=0 по СвернутыйЗапрос.Количество()-1 Цикл
		Сотрудник = СвернутыйЗапрос.Получить(й);
		СтрокаТаблицы = ИзмененныйЗапрос.Найти(Сотрудник.Ошиповщик,"Ошиповщик");
		ИндексСтроки =  ИзмененныйЗапрос.Индекс(СтрокаТаблицы);
		Для ц=ИндексСтроки+1 по ИзмененныйЗапрос.Количество()-1 Цикл
			СтрокаДляУдаления = ИзмененныйЗапрос.Получить(ц);
			Если (СтрокаДляУдаления.Ошиповщик = Сотрудник.Ошиповщик) Тогда
				СтрокаДляУдаления.Ошиповщик = Справочники.ФизическиеЛица.ПустаяСсылка();
			Иначе 
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ИзмененныйЗапрос;
	
КонецФункции

