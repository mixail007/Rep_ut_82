﻿
Перем Контрагент Экспорт;
Перем РасшифровкаПлатежаДок Экспорт;
Перем ОтражатьВБухгалтерскомУчете Экспорт;
Перем ВидОперацииДок Экспорт;
Перем ДатаДок Экспорт;
Перем ТипЗадолженности Экспорт;
Перем ИмяРегистраПлан Экспорт;
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;
Перем ФормаОплаты Экспорт;
Перем ВалютаДокумента Экспорт;
Перем БанковскийСчетКасса Экспорт;
Перем Организация Экспорт;
Перем ДоговорКонтрагента Экспорт;
Перем Сделка Экспорт;
Перем Проект Экспорт;
Перем ВидОперацииПлан Экспорт;
Перем СтатьяДвиженияДенежныхСредств Экспорт;
Перем ВключенныеВПлатежныйКалендарь Экспорт;
Перем Автозаполнение Экспорт;


// Отбирает неоплаченные задолженности по переданным контрагенту и типу задолженности
// и формирует таблицу для подбора.
//
Процедура СформироватьСписокДолгов() Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ // Выбираем задолженности по договорам, ведущимся по расчетным документам или по заказам
	|	РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	РасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
	|	РасчетыСКонтрагентамиОстатки.Сделка.Дата КАК ДатаВозникновения,
	|	РасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты КАК ДатаОплаты,
	|	РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+" КАК СуммаВзаиморасчетов,
	|  	КурсыДоговоры.Курс КАК КурсВзаиморасчетов,
	|  	КурсыДоговоры.Кратность КАК КратностьВзаиморасчетов,
	|	ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента
	|			ТОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+"
	|		КОГДА НЕ РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента 
	|			И НЕ КурсыДоговоры.Курс=0 
	|			И НЕ &КурсДокумента=0
	|			ТОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+"*КурсыДоговоры.Курс * &КратностьДокумента 
	|			/ (&КурсДокумента * КурсыДоговоры.Кратность)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (15,2)) КАК СуммаПлатежа
	|	ИЗ
	|	РегистрНакопления."+ИмяРегистраДолг+".Остатки(, ДоговорКонтрагента.Владелец=&Контрагент  
	//+++ 08.04.2019
	|"+?(ИмяРегистраДолг="ЗаказыПокупателей","И ЗаказПокупателя.Проверен","")+"
	
	|"+?(НЕ ЗначениеНеЗаполнено(Организация)," И (ДоговорКонтрагента.Организация=&Организация ИЛИ ДоговорКонтрагента.Организация=&ПустаяОрганизация)","")+"
	|			И ДоговорКонтрагента.ВидДоговора В ИЕРАРХИИ (&ВидДоговора)
	|			И (ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам 
	|				ИЛИ ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоРасчетнымДокументам
	|				ИЛИ ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоСчетам)) КАК РасчетыСКонтрагентамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаПлатежа, ) КАК КурсыДоговоры
	|		ПО РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов = КурсыДоговоры.Валюта
	|
	|	ГДЕ
	|	(РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток "+ТипЗадолженности+")  
	|"+?(ТекущийДоговор<>Справочники.ДоговорыКонтрагентов.ПустаяСсылка()," и РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = &ДоговорКонтрагентаДляАвтозаполнения","")+"	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	ВЫБРАТЬ // Выбираем задолженности по договорам, ведущимся по договору в целом
	|	РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
	|	РасчетыСКонтрагентамиОстатки.Сделка,
	|	ПоследнееДвижение.Период,
	|	РасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты КАК ДатаОплаты,
	|	РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+",
	|	КурсыДоговоры.Курс,
	|	КурсыДоговоры.Кратность,
	|	ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента
	|			ТОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+"
	|		КОГДА НЕ РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента 
	|			И НЕ КурсыДоговоры.Курс=0 
	|			И НЕ &КурсДокумента=0
	|			ТОГДА РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток"+?(ТипЗадолженности="<0","*(-1)","")+"*КурсыДоговоры.Курс * &КратностьДокумента 
	|			/ (&КурсДокумента * КурсыДоговоры.Кратность)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (15,2)) КАК СуммаПлатежа
	|	ИЗ
	|	РегистрНакопления."+ИмяРегистраДолг+".Остатки(, ДоговорКонтрагента.Владелец=&Контрагент 
		//+++ 08.04.2019
	|"+?(ИмяРегистраДолг="ЗаказыПокупателей","И ЗаказПокупателя.Проверен","")+"
	|"+?(НЕ ЗначениеНеЗаполнено(Организация)," И (ДоговорКонтрагента.Организация=&Организация ИЛИ ДоговорКонтрагента.Организация=&ПустаяОрганизация)","")+"
	|			И ДоговорКонтрагента.ВидДоговора В ИЕРАРХИИ (&ВидДоговора)
	|			И ДоговорКонтрагента.ВедениеВзаиморасчетов=&ПоДоговоруВЦелом) КАК РасчетыСКонтрагентамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаПлатежа, ) КАК КурсыДоговоры
	|		ПО РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов = КурсыДоговоры.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			МАКСИМУМ(РасчетыСКонтрагентами.Период) КАК Период,
	|			РасчетыСКонтрагентами.ДоговорКонтрагента КАК ДоговорКонтрагента
	|		ИЗ
	//+++ 01.04.2019
	|			РегистрНакопления.ВзаимоРасчетыСКонтрагентами КАК РасчетыСКонтрагентами
	|		
	|		СГРУППИРОВАТЬ ПО
	|			РасчетыСКонтрагентами.ДоговорКонтрагента) КАК ПоследнееДвижение
	|		ПО РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = ПоследнееДвижение.ДоговорКонтрагента
	|	ГДЕ
	|	(РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток "+ТипЗадолженности+")" 
	+ ?(ТекущийДоговор<>Справочники.ДоговорыКонтрагентов.ПустаяСсылка()," И РасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = &ДоговорКонтрагентаДляАвтозаполнения","");
	
	Если (ТекущийДоговор<>Справочники.ДоговорыКонтрагентов.ПустаяСсылка()) Тогда 
		Запрос.УстановитьПараметр("ДоговорКонтрагентаДляАвтозаполнения",ТекущийДоговор);
	КонецЕсли;
	Запрос.УстановитьПараметр("ПоРасчетнымДокументам",Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам);
	Запрос.УстановитьПараметр("ПоЗаказам",Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
	Запрос.УстановитьПараметр("ПоСчетам",Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам);
	Запрос.УстановитьПараметр("ПоДоговоруВЦелом",Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом);
		
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("ПустаяОрганизация",Справочники.Организации.ПустаяСсылка());
	Запрос.УстановитьПараметр("ВалютаДокумента",ВалютаДокумента);
	Запрос.УстановитьПараметр("КурсДокумента",КурсДокумента);
	Запрос.УстановитьПараметр("КратностьДокумента",КратностьДокумента);
	Запрос.УстановитьПараметр("ДатаПлатежа",ДатаДок);
	Запрос.УстановитьПараметр("ВидДоговора",ОпределитьВидДоговораСКонтрагентом(ВидОперацииДок));
	
	Если ИмяРегистраДолг="ЗаказыПокупателей" тогда //08.04.2019
		Запрос.Текст = стрЗаменить(Запрос.Текст,".Сделка", ".ЗаказПокупателя");
	КонецЕсли;	
	РасшифровкаПлатежа.Загрузить(Запрос.Выполнить().Выгрузить());
	
	РасшифровкаПлатежа.Сортировать("ДатаОплаты Возр");
		
КонецПроцедуры // СформироватьСписокДолгов()

// Отбирает неоплаченные задолженности по переданным контрагенту и типу задолженности
// и формирует таблицу для подбора.
//
Процедура СформироватьСписокПланируемыхДвижений(ДокументПланирования) Экспорт
	
	Запрос=Новый Запрос;
	
	ТекстУсловия="("+ДокументПланирования+".ВалютаДокумента=&ПустойВалютаДокумента ИЛИ "+ДокументПланирования+".ВалютаДокумента= &ВалютаДокумента)";				 			 
				 
	Если Не ЗначениеНеЗаполнено(ФормаОплаты) Тогда
		ТекстУсловия=ТекстУсловия+"И
		|("+ДокументПланирования+".ФормаОплаты=&ПустойФормаОплаты ИЛИ "+ДокументПланирования+".ФормаОплаты= &ФормаОплаты)";
		
		Запрос.УстановитьПараметр("ФормаОплаты",ФормаОплаты);
		Запрос.УстановитьПараметр("ПустойФормаОплаты",Перечисления.ВидыДенежныхСредств.ПустаяСсылка());	
		
	КонецЕсли;
		
	Если Не ЗначениеНеЗаполнено(БанковскийСчетКасса) Тогда
		
		ТекстУсловия=ТекстУсловия+"И
	             |		("+ДокументПланирования+".БанковскийСчетКасса=&ПустойСчетКасса ИЛИ 
				 |		"+ДокументПланирования+".БанковскийСчетКасса= &БанковскийСчетКасса ИЛИ 
				 |		"+ДокументПланирования+".БанковскийСчетКасса= Неопределено)";

		Запрос.УстановитьПараметр("БанковскийСчетКасса",БанковскийСчетКасса);	
		Запрос.УстановитьПараметр("ПустойСчетКасса",Новый(ТипЗнч(БанковскийСчетКасса)));
		
	КонецЕсли;
				 
	Если Не ЗначениеНеЗаполнено(Контрагент) Тогда
		 
		 Если 		ВидОперацииПлан=Перечисления.ВидыОперацийЗаявкиНаРасходование.ВыдачаДенежныхСредствКассеККМ
			 ИЛИ  	ВидОперацииПлан=Перечисления.ВидыОперацийЗаявкиНаРасходование.ВыдачаДенежныхСредствПодотчетнику Тогда
			 
			 ТекстУсловия=ТекстУсловия+" И
			 |(ЗаявкаНаРасходование.Получатель=&Контрагент ИЛИ ЗаявкаНаРасходование.Получатель=Неопределено)";
			 Запрос.УстановитьПараметр("Контрагент",Контрагент);
			 
		 Иначе
			 
			 ТекстУсловия=ТекстУсловия+" И
			 |("+ДокументПланирования+".Контрагент=&Контрагент ИЛИ "+ДокументПланирования+".Контрагент=&ПустойКонтрагент)";
			 Запрос.УстановитьПараметр("Контрагент",Контрагент);
			 Запрос.УстановитьПараметр("ПустойКонтрагент",Справочники.Контрагенты.ПустаяСсылка());
			 
		 КонецЕсли;
					 
	КонецЕсли;
	
	Если Не ЗначениеНеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|ДоговорКонтрагента=&ДоговорКонтрагента";
		Запрос.УстановитьПараметр("ДоговорКонтрагента",ДоговорКонтрагента);
	КонецЕсли;
	
	Если Не ЗначениеНеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|(СтатьяДвиженияДенежныхСредств=&ПустойСтатьяДвиженияДенежныхСредств ИЛИ СтатьяДвиженияДенежныхСредств=&СтатьяДвиженияДенежныхСредств)";
		Запрос.УстановитьПараметр("СтатьяДвиженияДенежныхСредств",СтатьяДвиженияДенежныхСредств);
		Запрос.УстановитьПараметр("ПустойСтатьяДвиженияДенежныхСредств",Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка());
	КонецЕсли;
				 
	Если Не ЗначениеНеЗаполнено(ВидОперацииПлан) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|"+ДокументПланирования+".ВидОперации = &ВидОперации";
		Запрос.УстановитьПараметр("ВидОперации",ВидОперацииПлан);
	КонецЕсли;
	
	Если Не ЗначениеНеЗаполнено(Организация) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|("+ДокументПланирования+".Организация=&ПустойОрганизация ИЛИ "+ДокументПланирования+".Организация=&Организация)";
		Запрос.УстановитьПараметр("Организация",Организация);
		Запрос.УстановитьПараметр("ПустойОрганизация",Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	
	Если Не ЗначениеНеЗаполнено(Сделка) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|(Сделка=Неопределено ИЛИ Сделка=&Сделка)";
		Запрос.УстановитьПараметр("Сделка",Сделка);
	КонецЕсли;
	
	Если Не ЗначениеНеЗаполнено(Проект) Тогда
		ТекстУсловия=ТекстУсловия+" И
		|(Проект=&ПустойПроект ИЛИ Проект=&Проект)";
		Запрос.УстановитьПараметр("Проект",Проект);
		Запрос.УстановитьПараметр("ПустойПроект",Справочники.Проекты.ПустаяСсылка());
	КонецЕсли;
	
	Если ВключенныеВПлатежныйКалендарь=Истина Тогда
		ТекстУсловия=ТекстУсловия+" И
		|"+ДокументПланирования+".ВключатьВПлатежныйКалендарь=Истина";
	КонецЕсли;
		
	Запрос.Текст="ВЫБРАТЬ
	|	ПланируемыеДвиженияОстатки.ДоговорКонтрагента,
	|	ПланируемыеДвиженияОстатки.Сделка,
	|	ПланируемыеДвиженияОстатки.СтатьяДвиженияДенежныхСредств,
	|	ПланируемыеДвиженияОстатки.Проект,
	|	ПланируемыеДвиженияОстатки."+ДокументПланирования+" КАК ДокументПланирования,
	|ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА НЕ ПланируемыеДвиженияОстатки.СуммаОстаток=0 
	|			ТОГДА ПланируемыеДвиженияОстатки.СуммаОстаток
	|		КОГДА ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента
	|			ТОГДА ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток
	|		КОГДА ПланируемыеДвиженияОстатки.СуммаОстаток=0  
	|			И НЕ КурсыДоговоры.Курс=0 
	|			И НЕ &КурсДокумента=0
	|			ТОГДА ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток*КурсыДоговоры.Курс * &КратностьДокумента 
	|			/ (&КурсДокумента * КурсыДоговоры.Кратность)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (15,2)) КАК СуммаПлатежа,
	|ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА ПланируемыеДвиженияОстатки.СуммаОстаток=0 
	|			ТОГДА КурсыДоговоры.Курс
	|		КОГДА ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента
	|			ТОГДА &КурсДокумента
	|		КОГДА НЕ ПланируемыеДвиженияОстатки.СуммаОстаток=0  
	|			И НЕ &КурсДокумента=0
	|			И НЕ ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток= 0
	|			И НЕ &КратностьДокумента=0 Тогда
	|			ПланируемыеДвиженияОстатки.СуммаОстаток * &КурсДокумента * КурсыДоговоры.Кратность
	|						/ (ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток * &КратностьДокумента)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (10,4)) КАК КурсВзаиморасчетов,
	|ВЫРАЗИТЬ 
	|	(ВЫБОР
	|		КОГДА ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=ПланируемыеДвиженияОстатки."+ДокументПланирования+".ВалютаДокумента
	|			ТОГДА ПланируемыеДвиженияОстатки."+ДокументПланирования+".КурсДокумента
	|		КОГДА НЕ ПланируемыеДвиженияОстатки.СуммаОстаток=0  
	|			И НЕ ПланируемыеДвиженияОстатки."+ДокументПланирования+".КурсДокумента=0
	|			И НЕ ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток= 0
	|			И НЕ ПланируемыеДвиженияОстатки."+ДокументПланирования+".КратностьДокумента=0 Тогда
	|			ПланируемыеДвиженияОстатки.СуммаОстаток * ПланируемыеДвиженияОстатки."+ДокументПланирования+".КурсДокумента * КурсыДоговоры.Кратность
	|						/ (ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток * ПланируемыеДвиженияОстатки."+ДокументПланирования+".КратностьДокумента)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (10,4)) КАК КурсВзаиморасчетовПлан,
	|	ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ПланируемыеДвиженияОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетов,
	|ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов=&ВалютаДокумента
	|			ТОГДА &КратностьДокумента
	|		ИНАЧЕ
	|			КурсыДоговоры.Кратность
	|		КОНЕЦ КАК ЧИСЛО (10,0)) КАК КратностьВзаиморасчетов,
	|	ПланируемыеДвиженияОстатки."+ДокументПланирования+"."
	+?(ДокументПланирования="ЗаявкаНаРасходование","ДатаРасхода","ДатаПоступления")+" КАК ДатаДвижения
	|ИЗ
	|	РегистрНакопления."+ИмяРегистраПлан+".Остатки(,("+ТекстУсловия+"))КАК ПланируемыеДвиженияОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаПлатежа, ) КАК КурсыДоговоры
	|		ПО ПланируемыеДвиженияОстатки.ДоговорКонтрагента.ВалютаВзаиморасчетов = КурсыДоговоры.Валюта";
	
	Запрос.УстановитьПараметр("СуммаДокумента",СуммаДляПодбора);
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.УстановитьПараметр("ВалютаДокумента",ВалютаДокумента);
	Запрос.УстановитьПараметр("ПустойВалютаДокумента",Справочники.Валюты.ПустаяСсылка());
    Запрос.УстановитьПараметр("ДатаПлатежа",ДатаДок);
	Запрос.УстановитьПараметр("КурсДокумента",КурсДокумента);
	Запрос.УстановитьПараметр("КратностьДокумента",КратностьДокумента);
					 
	ПланируемыеДвижения.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ПланируемыеДвижения.Сортировать("ДатаДвижения Возр");
		
КонецПроцедуры // СформироватьСписокПланируемыхДвижений()

Функция ПодборПланируемыхДвижений(ИсходнаяРасшифровка,ПодборПоСуммеПлатежа=Истина,КурсПоДоговору=Истина) Экспорт
	
	Если ИмяРегистраПлан="ЗаявкиНаРасходованиеСредств" Тогда
		ИмяДокумента="ЗаявкаНаРасходование";
	Иначе
		ИмяДокумента="ДокументПланирования";
	КонецЕсли;
	
	СформироватьСписокПланируемыхДвижений(ИмяДокумента);
	
	КопияРасшифровкаДок=ИсходнаяРасшифровка.Скопировать();
	КопияРасшифровкаДок.Очистить();
	
	ПланируемыеДвижения.Сортировать("ДатаДвижения Возр");
	
	Для Каждого СтрокаПлатеж ИЗ ИсходнаяРасшифровка Цикл
		
		СтруктураОтбора=Новый Структура;
		СтруктураОтбора.Вставить("ДоговорКонтрагента",СтрокаПлатеж.ДоговорКонтрагента);
		
		Если НЕ (ИмяРегистраДолг="ВзаиморасчетыСКонтрагентами" И СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом) Тогда
			
			СтруктураОтбора.Вставить("Сделка",СтрокаПлатеж.Сделка);
			
		КонецЕсли;
		
		МассивПлан=ПланируемыеДвижения.НайтиСтроки(СтруктураОтбора);
		
		Если ПодборПоСуммеПлатежа Тогда
		
		ВсегоКПодбору=СтрокаПлатеж.СуммаПлатежа;
		
		Для Каждого СтрокаПлан Из МассивПлан Цикл
			
			СтрокаПодобрано=КопияРасшифровкаДок.Добавить();
			СтрокаПодобрано.ДоговорКонтрагента=СтрокаПлан.ДоговорКонтрагента;
			СтрокаПодобрано.Сделка=СтрокаПлан.Сделка;
			СтрокаПодобрано.КурсВзаиморасчетовПлан=СтрокаПлан.КурсВзаиморасчетовПлан;
			
			ВалютаВзаиморасчетов=СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			
			Если КурсПоДоговору ИЛИ СтрокаПлан.КурсВзаиморасчетов=0 Тогда
				
				СтрокаПодобрано.КурсВзаиморасчетов=СтрокаПлатеж.КурсВзаиморасчетов;
				СтрокаПодобрано.КратностьВзаиморасчетов=СтрокаПлатеж.КратностьВзаиморасчетов;
				
			Иначе
				
				СтрокаПодобрано.КурсВзаиморасчетов=СтрокаПлан.КурсВзаиморасчетов;
				СтрокаПодобрано.КратностьВзаиморасчетов=СтрокаПлан.КратностьВзаиморасчетов;
				
			КонецЕсли;
			
			СтрокаПодобрано.ДокументПланированияПлатежа=СтрокаПлан.ДокументПланирования;
			СтрокаПодобрано.СтатьяДвиженияДенежныхСредств=СтрокаПлан.СтатьяДвиженияДенежныхСредств;
			СтрокаПодобрано.Проект=СтрокаПлан.Проект;
			
			Если СтрокаПлан.СуммаПлатежа=ВсегоКПодбору Тогда
				
				СтрокаПодобрано.СуммаПлатежа=СтрокаПлатеж.СуммаПлатежа;
				СтрокаПодобрано.СуммаВзаиморасчетов=СтрокаПлатеж.СуммаВзаиморасчетов;
				
				Если СтрокаПодобрано.КурсВзаиморасчетовПлан>0 Тогда										
				СтрокаПодобрано.СуммаПлатежаПлан=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетовПлан,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Иначе // Документ планирования не таксирован
														
					СтрокаПодобрано.СуммаПлатежаПлан=0;
					
				КонецЕсли;

				ВсегоКПодбору=0;
				СтрокаПлан.СуммаПлатежа=СтрокаПлан.СуммаПлатежа-СтрокаПодобрано.СуммаПлатежаПлан;
				Прервать;
				
			ИначеЕсли СтрокаПлан.СуммаПлатежа>ВсегоКПодбору Тогда
								
				СтрокаПодобрано.СуммаПлатежа=ВсегоКПодбору;
				
				СтрокаПодобрано.СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаПлатежа,ВалютаДокумента,ВалютаВзаиморасчетов,
				КурсДокумента,СтрокаПодобрано.КурсВзаиморасчетов,
				КратностьДокумента,СтрокаПодобрано.КратностьВзаиморасчетов);
				
				Если СтрокаПодобрано.КурсВзаиморасчетовПлан>0 Тогда										
				СтрокаПодобрано.СуммаПлатежаПлан=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетовПлан,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Иначе // Документ планирования не таксирован
														
					СтрокаПодобрано.СуммаПлатежаПлан=0;
					
				КонецЕсли;
				
				СтрокаПлан.СуммаПлатежа=СтрокаПлан.СуммаПлатежа-ВсегоКПодбору;
				ВсегоКПодбору=0;
				
				Прервать;
				
			Иначе
				
				СтрокаПодобрано.СуммаПлатежа=СтрокаПлан.СуммаПлатежа;
				СтрокаПодобрано.СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаПлатежа,ВалютаДокумента,ВалютаВзаиморасчетов,
				КурсДокумента,СтрокаПодобрано.КурсВзаиморасчетов,
				КратностьДокумента,СтрокаПодобрано.КратностьВзаиморасчетов);
				
				Если СтрокаПодобрано.КурсВзаиморасчетовПлан>0 Тогда										
				СтрокаПодобрано.СуммаПлатежаПлан=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетовПлан,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Иначе // Документ планирования не таксирован
														
					СтрокаПодобрано.СуммаПлатежаПлан=0;
					
				КонецЕсли;
				
				ВсегоКПодбору=ВсегоКПодбору-СтрокаПодобрано.СуммаПлатежаПлан;
				СтрокаПлан.СуммаПлатежа=0;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ВсегоКПодбору=СтрокаПлатеж.СуммаВзаиморасчетов;
		
		Для Каждого СтрокаПлан Из МассивПлан Цикл
			
			СтрокаПодобрано=КопияРасшифровкаДок.Добавить();
			СтрокаПодобрано.ДоговорКонтрагента=СтрокаПлан.ДоговорКонтрагента;
			СтрокаПодобрано.Сделка=СтрокаПлан.Сделка;
			СтрокаПодобрано.КурсВзаиморасчетовПлан=СтрокаПлан.КурсВзаиморасчетовПлан;
			
			Если КурсПоДоговору ИЛИ СтрокаПлан.КурсВзаиморасчетов=0 Тогда
				
				СтрокаПодобрано.КурсВзаиморасчетов=СтрокаПлатеж.КурсВзаиморасчетов;
				СтрокаПодобрано.КратностьВзаиморасчетов=СтрокаПлатеж.КратностьВзаиморасчетов;
				
			Иначе
				
				СтрокаПодобрано.КурсВзаиморасчетов=СтрокаПлан.КурсВзаиморасчетов;
				СтрокаПодобрано.КратностьВзаиморасчетов=СтрокаПлан.КратностьВзаиморасчетов;
				
			КонецЕсли;
			
			СтрокаПодобрано.ДокументПланированияПлатежа=СтрокаПлан.ДокументПланирования;
			СтрокаПодобрано.СтатьяДвиженияДенежныхСредств=СтрокаПлан.СтатьяДвиженияДенежныхСредств;
			СтрокаПодобрано.Проект=СтрокаПлан.Проект;
			
			Если СтрокаПлан.СуммаВзаиморасчетов=ВсегоКПодбору Тогда
				
				СтрокаПодобрано.СуммаПлатежа=СтрокаПлатеж.СуммаПлатежа;
				СтрокаПодобрано.СуммаПлатежаПлан=СтрокаПлатеж.СуммаПлатежа;
				СтрокаПодобрано.СуммаВзаиморасчетов=СтрокаПлатеж.СуммаВзаиморасчетов;
				ВсегоКПодбору=0;
				СтрокаПлан.СуммаВзаиморасчетов=СтрокаПлан.СуммаВзаиморасчетов-СтрокаПлатеж.СуммаВзаиморасчетов;
				Прервать;
				
			ИначеЕсли СтрокаПлан.СуммаВзаиморасчетов>ВсегоКПодбору Тогда
				
				СтрокаПодобрано.СуммаВзаиморасчетов=ВсегоКПодбору;
				СтрокаПодобрано.СуммаПлатежа=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетов,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
														
				Если СтрокаПодобрано.КурсВзаиморасчетовПлан>0 Тогда										
				СтрокаПодобрано.СуммаПлатежаПлан=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетовПлан,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Иначе // Документ планирования не таксирован
														
					СтрокаПодобрано.СуммаПлатежаПлан=0;
					
				КонецЕсли;
				
				СтрокаПлан.СуммаВзаиморасчетов=СтрокаПлан.СуммаВзаиморасчетов-ВсегоКПодбору;
				ВсегоКПодбору=0;
				
				Прервать;
				
			Иначе
				
				СтрокаПодобрано.СуммаВзаиморасчетов=СтрокаПлан.СуммаВзаиморасчетов;
				СтрокаПодобрано.СуммаПлатежа=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетов,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Если СтрокаПодобрано.КурсВзаиморасчетовПлан>0 Тогда										
				СтрокаПодобрано.СуммаПлатежаПлан=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
														СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,ВалютаДокумента,
														СтрокаПодобрано.КурсВзаиморасчетовПлан,КурсДокумента,
														СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
														
				Иначе // Документ планирования не таксирован
														
					СтрокаПодобрано.СуммаПлатежаПлан=0;
					
				КонецЕсли;
				
				ВсегоКПодбору=ВсегоКПодбору-СтрокаПлан.СуммаВзаиморасчетов;
				СтрокаПлан.СуммаВзаиморасчетов=0;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ВсегоКПодбору>0 И НЕ НеПревышатьЗапланированныхЗначений Тогда
		
		СтрокаПодобрано=КопияРасшифровкаДок.Добавить();
		СтрокаПодобрано.ДоговорКонтрагента=СтрокаПлатеж.ДоговорКонтрагента;
		СтрокаПодобрано.Сделка=СтрокаПлатеж.Сделка;
		СтрокаПодобрано.КурсВзаиморасчетов=СтрокаПлатеж.КурсВзаиморасчетов;
		СтрокаПодобрано.КратностьВзаиморасчетов=СтрокаПлатеж.КратностьВзаиморасчетов;
		
		Если ПодборПоСуммеПлатежа Тогда
			
			СтрокаПодобрано.СуммаПлатежа=ВсегоКПодбору;
			СтрокаПодобрано.СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаПлатежа,ВалютаДокумента,СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,
			КурсДокумента,СтрокаПодобрано.КурсВзаиморасчетов,
			КратностьДокумента,СтрокаПодобрано.КратностьВзаиморасчетов);
			
		Иначе
			
			СтрокаПодобрано.СуммаВзаиморасчетов=ВсегоКПодбору;
			СтрокаПодобрано.СуммаПлатежа=ПересчитатьИзВалютыВВалюту(СтрокаПодобрано.СуммаВзаиморасчетов,
			СтрокаПодобрано.ДоговорКонтрагента.ВалютаВзаиморасчетов,ВалютаДокумента,
			СтрокаПодобрано.КурсВзаиморасчетов,КурсДокумента,
			СтрокаПодобрано.КратностьВзаиморасчетов,КратностьДокумента);
			
		КонецЕсли;
		
	КонецЕсли;
	
	КонецЦикла;

	Возврат КопияРасшифровкаДок;
	
КонецФункции // ПодборПланируемыхДвижений()

Процедура ЗаполнитьРасшифровкуПоДолгам(ПодборПоСуммеПлатежа=Истина,КурсПоДоговору=Истина) Экспорт
	
	СформироватьСписокДолгов();
	
	СтавкаНДС=ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ОсновнаяСтавкаНДС");
	ВсегоПлатежей=0;
	
	РеглУчет=НЕ ОтражатьВБухгалтерскомУчете=Неопределено;
	
	Если Не СпособЗаполнения="ТЧ" Тогда
	
		Если СпособЗаполнения="ЛИФО" Тогда
			
			РасшифровкаПлатежа.Сортировать("ДатаВозникновения Убыв");
			
		КонецЕсли;
					
		Для Каждого СтрокаДолг Из РасшифровкаПлатежа Цикл
			
			Если ПодбиратьСумму Тогда
				
				Если ВсегоПлатежей+СтрокаДолг.СуммаПлатежа <= СуммаДляПодбора Тогда
					
					СуммаПлатежа=СтрокаДолг.СуммаПлатежа;
					СуммаВзаиморасчетов=СтрокаДолг.СуммаВзаиморасчетов;
					
					ВсегоПлатежей=ВсегоПлатежей+СтрокаДолг.СуммаПлатежа;
					
				ИначеЕсли ВсегоПлатежей<СуммаДляПодбора Тогда
					
					СуммаПлатежа=СуммаДляПодбора-ВсегоПлатежей;
					СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СуммаПлатежа,ВалютаДокумента,СтрокаДолг.ДоговорКонтрагента.ВалютаВзаиморасчетов,
																	КурсДокумента,СтрокаДолг.КурсВзаиморасчетов,
																	КратностьДокумента,СтрокаДолг.КратностьВзаиморасчетов);
					ВсегоПлатежей=СуммаДляПодбора;												
																	
				Иначе
					
					Прервать;
					
				КонецЕсли;
				
			Иначе
				
				СуммаПлатежа=СтрокаДолг.СуммаПлатежа;
				СуммаВзаиморасчетов=СтрокаДолг.СуммаВзаиморасчетов;
				
			КонецЕсли;
			
			СтрокаПлатеж=РасшифровкаПлатежаДок.Добавить();
			СтрокаПлатеж.ДоговорКонтрагента=СтрокаДолг.ДоговорКонтрагента;
			СтрокаПлатеж.Сделка=СтрокаДолг.Сделка;
			СтрокаПлатеж.СуммаПлатежа=СуммаПлатежа;
			СтрокаПлатеж.КурсВзаиморасчетов=СтрокаДолг.КурсВзаиморасчетов;
			СтрокаПлатеж.КратностьВзаиморасчетов=СтрокаДолг.КратностьВзаиморасчетов;
			СтрокаПлатеж.СуммаВзаиморасчетов=СуммаВзаиморасчетов;
						
		КонецЦикла;
		
	Иначе
		
		Для Каждого СтрокаПлатеж Из РасшифровкаПлатежаДок Цикл

			СтруктураОтбора=Новый Структура;
			СтруктураОтбора.Вставить("ДоговорКонтрагента",СтрокаПлатеж.ДоговорКонтрагента);
			СтруктураОтбора.Вставить("Сделка",СтрокаПлатеж.Сделка);
			
			СтрокаДолг = НайтиСтрокуТабЧасти(РасшифровкаПлатежа, СтруктураОтбора);
			
			Если НЕ СтрокаДолг=Неопределено Тогда
				
				КурсВзаиморасчетов=?(СтрокаПлатеж.КурсВзаиморасчетов=0,СтрокаДолг.КурсВзаиморасчетов,СтрокаПлатеж.КурсВзаиморасчетов);
				КратностьВзаиморасчетов=?(СтрокаПлатеж.КратностьВзаиморасчетов=0,СтрокаДолг.КратностьВзаиморасчетов,СтрокаПлатеж.КратностьВзаиморасчетов);
				
				Если ПодбиратьСумму Тогда
					
					Если ВсегоПлатежей+СтрокаДолг.СуммаПлатежа <= СуммаДляПодбора Тогда
						
						СтрокаПлатеж.СуммаПлатежа=СтрокаДолг.СуммаПлатежа;
						ВсегоПлатежей=ВсегоПлатежей+СтрокаДолг.СуммаПлатежа;
						
					ИначеЕсли ВсегоПлатежей<СуммаДляПодбора Тогда
						
						СтрокаПлатеж.СуммаПлатежа=СуммаДляПодбора-ВсегоПлатежей;
						ВсегоПлатежей=СуммаДляПодбора;
						
					Иначе
						
						Прервать;
						
					КонецЕсли;
					
				Иначе
					
					СтрокаПлатеж.СуммаПлатежа=СтрокаДолг.СуммаПлатежа;
					
				КонецЕсли;
				
				СтрокаПлатеж.СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаПлатежа,ВалютаДокумента,СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов,
															КурсДокумента,КурсВзаиморасчетов,
															КратностьДокумента,КратностьВзаиморасчетов);
																		
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ПодбиратьПланируемыеДвижения Тогда
		
		РасшифровкаПлатежаДок.Загрузить(ПодборПланируемыхДвижений(РасшифровкаПлатежаДок.Выгрузить(),ПодборПоСуммеПлатежа,КурсПоДоговору));
		
	КонецЕсли;
	
	Если РеглУчет Тогда
		
		Для Каждого СтрокаПлатеж Из РасшифровкаПлатежаДок Цикл
			
			ЗаполнитьРеквизитыРеглУчета(СтрокаПлатеж,Организация, Контрагент, СтавкаНДС);
			
		КонецЦикла;
		
	КонецЕсли;
			
КонецПроцедуры // ЗаполнитьРасшифровкуПоДолгам()

// Заполняет расшифровку расчетного документа по документам планируемого движения
// денежных средств

Процедура ЗаполнитьРасшифровкуПоПланам() Экспорт
	
	Если ИмяРегистраПлан="ЗаявкиНаРасходованиеСредств" Тогда
		ИмяДокумента="ЗаявкаНаРасходование";
	Иначе
		ИмяДокумента="ДокументПланирования";
	КонецЕсли;
	
	СформироватьСписокПланируемыхДвижений(ИмяДокумента);
	
	СтавкаНДС=ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ОсновнаяСтавкаНДС");
	ВсегоПлатежей=0;
	
	РеглУчет=НЕ ОтражатьВБухгалтерскомУчете=Неопределено;
	
	Если СпособЗаполнения="ЛИФО" Тогда
		
		ПланируемыеДвижения.Сортировать("ДатаДвижения Убыв");
		
	КонецЕсли;
	
	Для Каждого СтрокаПлан Из ПланируемыеДвижения Цикл
		
			КурсВзаиморасчетов      = СтрокаПлан.КурсВзаиморасчетов;
			КратностьВзаиморасчетов = СтрокаПлан.КратностьВзаиморасчетов;
			
		Если ПодбиратьСумму Тогда
			
			Если ВсегоПлатежей+СтрокаПлан.СуммаПлатежа <= СуммаДляПодбора Тогда
				
				СуммаПлатежа=СтрокаПлан.СуммаПлатежа;
				СуммаВзаиморасчетов=СтрокаПлан.СуммаВзаиморасчетов;
				
				ВсегоПлатежей=ВсегоПлатежей+СтрокаПлан.СуммаПлатежа;
				
			ИначеЕсли ВсегоПлатежей<СуммаДляПодбора Тогда
				
				СуммаПлатежа=СуммаДляПодбора-ВсегоПлатежей;
				СуммаВзаиморасчетов=ПересчитатьИзВалютыВВалюту(СуммаПлатежа,ВалютаДокумента,СтрокаПлан.ДоговорКонтрагента.ВалютаВзаиморасчетов,
						КурсДокумента,КурсВзаиморасчетов,
						КратностьДокумента,КратностьВзаиморасчетов);
						ВсегоПлатежей=СуммаДляПодбора;												
				
			Иначе
				
				Прервать;
				
			КонецЕсли;
			
		Иначе
			
			СуммаПлатежа=СтрокаПлан.СуммаПлатежа;
			СуммаВзаиморасчетов=СтрокаПлан.СуммаВзаиморасчетов;
			
		КонецЕсли;
		
		СтрокаПлатеж=РасшифровкаПлатежаДок.Добавить();
		
		СтрокаПлатеж.ДоговорКонтрагента=СтрокаПлан.ДоговорКонтрагента;
		СтрокаПлатеж.Сделка=СтрокаПлан.Сделка;
		СтрокаПлатеж.СуммаПлатежа=СуммаПлатежа;
		СтрокаПлатеж.КурсВзаиморасчетов=КурсВзаиморасчетов;
		СтрокаПлатеж.КратностьВзаиморасчетов=КратностьВзаиморасчетов;
		СтрокаПлатеж.СуммаВзаиморасчетов=СуммаВзаиморасчетов;
		СтрокаПлатеж.ДокументПланированияПлатежа=СтрокаПлан.ДокументПланирования;
		СтрокаПлатеж.СтатьяДвиженияДенежныхСредств=СтрокаПлан.СтатьяДвиженияДенежныхСредств;
		СтрокаПлатеж.Проект=СтрокаПлан.Проект;
		СтрокаПлатеж.КурсВзаиморасчетовПлан=КурсВзаиморасчетов;
		СтрокаПлатеж.СуммаПлатежаПлан=СуммаПлатежа;
		
		Если РеглУчет Тогда
			
			ЗаполнитьРеквизитыРеглУчета(СтрокаПлатеж,Организация, Контрагент, СтавкаНДС);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьРасшифровкуПоПланам()
