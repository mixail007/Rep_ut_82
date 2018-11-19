﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	естьЗаписи=ложь;
	Для каждого стрДоки из ВыбранныеДоки Цикл
		Если стрДоки.флажок тогда
			естьЗаписи=истина;
			прервать;
		КонецЕсли;
	КонецЦикла;
	Если естьЗаписи тогда
		ДокКорректировка=Документы.КорректировкаЗаписейРегистровНакопления.СоздатьДокумент();
		ДокКорректировка.Дата=ТекущаяДата();
		ДокКорректировка.Комментарий="Курсовые разницы";
		ДокКорректировка.Организация=Справочники.Организации.НайтиПоКоду("00001");
		табРег=ДокКорректировка.ТаблицаРегистровНакопления.Добавить();
		ТабРег.Имя="ВзаиморасчетыСКонтрагентами";
		ТабРег.Представление="Взаиморасчеты с контрагентами";
		ДокКорректировка.Записать();
		ВзаиморасчетыСКонтрагентами = РегистрыНакопления.ВзаиморасчетыСКонтрагентами.СоздатьНаборЗаписей();
		ВзаиморасчетыСКонтрагентами.Отбор.Регистратор.Значение = ДокКорректировка.Ссылка;
		ВзаиморасчетыСКонтрагентами.Очистить();
		
		
		Для каждого стрДоки из ВыбранныеДоки Цикл
			Если стрДоки.флажок тогда
				
				ЗаписьВзаиморасчетыСКонтрагентами = ВзаиморасчетыСКонтрагентами.Добавить();
				ЗаписьВзаиморасчетыСКонтрагентами.Период = ТекущаяДата();
				ЗаписьВзаиморасчетыСКонтрагентами.Активность = Истина;
				ЗаписьВзаиморасчетыСКонтрагентами.ВидДвижения = ?(стрДоки.СуммаУпрОстаток<0,ВидДвиженияНакопления.Приход,ВидДвиженияНакопления.Расход);
				ЗаписьВзаиморасчетыСКонтрагентами.ДоговорКонтрагента = стрДоки.ДоговорКонтрагента;
				ЗаписьВзаиморасчетыСКонтрагентами.Сделка = стрДоки.Сделка;
				ЗаписьВзаиморасчетыСКонтрагентами.Регистратор = ДокКорректировка.Ссылка;
				ЗаписьВзаиморасчетыСКонтрагентами.СуммаУпр = ?(стрДоки.СуммаУпрОстаток<0,-стрДоки.СуммаУпрОстаток,стрДоки.СуммаУпрОстаток);
				ВзаиморасчетыСКонтрагентами.Записать();
				
			КонецЕсли;	   
		КонецЦикла;
		ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОсновныеДействияФормыВыполнить.Доступность=ложь;
	КонецЕсли;
КонецПроцедуры

Процедура ОсновныеДействияФормыкнОтобрать(Кнопка)
	СписокКонтрагентов=Новый СписокЗначений;
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91735")); //FREEMAN RACING WHEELS INC
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93695")); //NINGBO PARTNER INTERNATIONAL TRADE CO., LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91535")); //JIANGSU SAINTY MACHINERY I&E CORP. LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("П000715")); //Zhejiang Jingu Company Ltd
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93777")); //Steel Strips Wheels Limited
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93694")); //Zhangzhou Shuangsheng WHeels Co., ltd
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91834")); //NINGBO LONGTIME MACHINE CO.,LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("П001626")); //XIAMEN YONGXINGXUN INDUSTRY AND TRADE CO., LTD	
	
	Запрос=новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	А.ДоговорКонтрагентаВладелец как Контрагент,
	|	А.ДоговорКонтрагента,
	|	А.Сделка,
	//|	А.СуммаВзаиморасчетовОстаток,
	|	А.СуммаУпрОстаток,
	|	ИСТИНА КАК флажок
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК ДоговорКонтрагентаВладелец,
	|		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
	|		ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетовОстаток,
	|		ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток
	|	ИЗ
	|		РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	|				,
	|				ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком)
	|					И ДоговорКонтрагента.Владелец В (&СписокКонтрагентов)) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|	ГДЕ
	|		ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток = 0
	|		И ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток <> 0) КАК А
	|ГДЕ
	|	А.Сделка <> НЕОПРЕДЕЛЕНО";
	Запрос.УстановитьПараметр("СписокКонтрагентов",СписокКонтрагентов);
	Рез=Запрос.Выполнить().Выгрузить();
	ВыбранныеДоки=рез;
	
	ЭлементыФормы.ВыбранныеДоки.СоздатьКолонки();
	ЭлементыФормы.ВыбранныеДоки.Колонки.Добавить("фл","фл");
	Колонки = ЭлементыФормы.ВыбранныеДоки.Колонки;
	Индекс=Колонки.Индекс(Колонки["фл"]);
	ЭлементыФормы.ВыбранныеДоки.Колонки.Сдвинуть(Колонки["фл"],-Индекс);
	ЭлементыФормы.ВыбранныеДоки.Колонки.фл.РежимРедактирования=РежимРедактированияКолонки.Непосредственно;
	ЭлементыФормы.ВыбранныеДоки.Колонки.фл.ДанныеФлажка="флажок";
	ЭлементыФормы.ВыбранныеДоки.Колонки.флажок.видимость=ложь;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОсновныеДействияФормыВыполнить.Доступность=истина;
КонецПроцедуры
