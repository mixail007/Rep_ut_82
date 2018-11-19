﻿Перем НомерНаПечать Экспорт;

Функция Печать(НомерДока = "") Экспорт
	
	НомерНаПечать = НомерДока;
	Если Не Метаданные.Имя = "УправлениеТорговлей" Тогда
	//	Сообщить("Печатная форма предназначена для использования в конфигурации ""Управление торговлей""", СтатусСообщения.Внимание);
	КонецЕсли;
	
	//Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		Возврат ПечатьДокумента(СсылкаНаОбъект);
	//КонецЕсли;
	
КонецФункции // Печать

Функция ПечатьДокумента(СсылкаНаОбъект)
			
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УпаковочныйЛист_Экспорт";
	
	ОрганизацияТТ=?(СсылкаНаОбъект.Организация=Справочники.Организации.НайтиПоКоду("00004"),истина,ложь);
	
	Если СсылкаНаОбъект.Контрагент.ДвуязычныйЭкспорт Тогда
		ДваЯзыка = Истина;
		ИмяМакета = "УпаковочныйЛистДваЯзыка";
	Иначе
		ДваЯзыка = Ложь;
		
		ДваЯзыка = Ложь;
		Если ОрганизацияТТ тогда
			ИмяМакета = "PACKING";
		иначе
			ИмяМакета = "УпаковочныйЛистРус";
		КонецЕсли;
		
		ИмяМакета = "УпаковочныйЛистРус";
	КонецЕсли;
	
	Если ОрганизацияТТ тогда
			ИмяМакета = "PACKING";
	КонецЕсли;
	
	Макет = ПолучитьМакет(ИмяМакета);
	ОбластьШапка        = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока       = Макет.ПолучитьОбласть("Строка");
	ОбластьИтог         = Макет.ПолучитьОбласть("Итого");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Документ.Номенклатура.Код КАК Код,
	               |	Документ.Номенклатура КАК Номенклатура,
				   |	Документ.Номенклатура.Производитель КАК Производитель,
	               |	Документ.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	СУММА(Документ.Количество) КАК Количество,
				   |	СУММА(ВЫБОР КОГДА Документ.КоличествоМест > 0 Тогда Документ.КоличествоМест ИНАЧЕ Документ.Количество КОНЕЦ) КАК КоличествоМест,
	               |	СУММА(Документ.Сумма) КАК Сумма,
				   |	СУММА(Документ.Вес) КАК ВесБрутто,
	               |	Документ.Цена КАК Цена
	               |ИЗ
	               |	Документ.Заказпокупателя.Товары КАК Документ
	               |ГДЕ
	               |	Документ.Ссылка = &ТекущийДокумент
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	Документ.Номенклатура,
	               |	Документ.ЕдиницаИзмерения,
	               |	Документ.Цена,
	               |	Документ.Номенклатура.Код,
				   |	Документ.Номенклатура.Производитель
	               |УПОРЯДОЧИТЬ ПО
	               |	ПОДСТРОКА(Документ.Номенклатура.НаименованиеПолное, 1, 50)
				   |";
	

	ТЗТоваров = Запрос.Выполнить().Выгрузить();
	
	//вывод шапки
	ВидАдресаЮрАнгл = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("38846");
	ВидАдресаФактАнгл = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("38847");
	АдресДоставки = Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00021");
		
	ОбластьШапка.Параметры.ПечНаименованиеТовара = СформироватьНаименованиеТовара(ТЗтоваров, ДваЯзыка,ОрганизацияТТ);
	
	Грузоотправитель = СсылкаНаОбъект.Организация;
	ФактАдресГО = "150044, Россия, Ярославль, ул. Базовая, 3, строение 2";
	//ФактАдресПродавца = "Ярославль, 150049, Россия, ул. Лисицына, дом 7";
	//со 2 апреля 2015 изменился адрес
	ФактАдресПродавца = "150014, Россия, Ярославль, ул. Салтыкова-Щедрина, дом 21, офис 507";
	
	Если ОрганизацияТТ тогда
		ФактАдресГО = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
	    ФактАдресПродавца = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
	КонецЕсли;
	
	Покупатель  = СсылкаНаОбъект.Контрагент;
	СведенияОПокупателе     = СведенияОЮрФизЛице(Покупатель,  СсылкаНаОбъект.Дата);
	
	Грузополучатель  = ?(ЗначениеЗаполнено(СсылкаНаОбъект.Грузополучатель), СсылкаНаОбъект.Грузополучатель,   СсылкаНаОбъект.Контрагент);
	СведенияОГрузополучателе     = СведенияОЮрФизЛице(Грузополучатель,       СсылкаНаОбъект.Дата);
	Если СокрЛП(СсылкаНаОбъект.АдресДоставки)= "" Тогда
		ФактАдресГП = ОписаниеОрганизации(СведенияОГрузополучателе, "ФактическийАдрес,");
		ФактАдресГП = ?(СокрЛП(ФактАдресГП)="", ОписаниеОрганизации(СведенияОГрузополучателе, "ЮридическийАдрес,"), СокрЛП(ФактАдресГП));
	Иначе
		ФактАдресГП = СокрЛП(СсылкаНаОбъект.АдресДоставки);
	КонецЕсли;

	
	Если ДваЯзыка Тогда
		Если ОрганизацияТТ тогда
			//ОбластьШапка.Параметры.ГрузоотправительНаименование = "Tire Technology Co LTD, Китай/TYRE TECHNOLOGY CO.,LIMITED";
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
			ОбластьШапка.Параметры.ПродавецНаименование = "Tire Technology Co LTD, Китай/TYRE TECHNOLOGY CO.,LIMITED";
			//ОбластьШапка.Параметры.ФактАдресПродавца = "YAROSLAVL 150049,RUSSIA, LISITSINA STR., 7 / "+ФактАдресПродавца;
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Покупатель,Перечисления.ТипыКонтактнойИнформации.Адрес,ВидАдресаЮрАнгл));
			
			ОбластьШапка.Параметры.АдресПокупателяАнгл = РегАдреса.Представление;
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Грузополучатель,Перечисления.ТипыКонтактнойИнформации.Адрес,АдресДоставки));
			//ОбластьШапка.Параметры.АдресГрузополучателяАнгл = РегАдреса.Представление;
			ОбластьШапка.Параметры.Договор    = СсылкаНаОбъект.ДоговорКонтрагента.Номер+" dtd "+формат(СсылкаНаОбъект.ДоговорКонтрагента.Дата,"ДЛФ=D");
            ОбластьШапка.Параметры.ПокупательНаименование = СведенияОПокупателе.ПолноеНаименование;
		Иначе
			//грузоотправитель и продавец
			ОбластьШапка.Параметры.ГрузоотправительНаименование = "JSC TRADING COMPANY “YARSHINTORG” / "+строка(Грузоотправитель.НаименованиеПолное);
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = "150044, RUSSIA, YAROSLAVL, BAZOVAYA STR., 3,BUILDING.2 / "+ФактАдресГО;
			ОбластьШапка.Параметры.ПродавецНаименование = "ShinTrade Yaroslavl Ltd / Общество с ограниченной ответственностью «ШинТрейд Ярославль»";
			//ОбластьШапка.Параметры.ФактАдресПродавца = "YAROSLAVL 150049,RUSSIA, LISITSINA STR., 7 / "+ФактАдресПродавца;
			ОбластьШапка.Параметры.ФактАдресПродавца = "150014, RUSSIA, YAROSLAVL, SALTYKOVA-SHCHEDRINA STR., 21, OFFICE 507 / "+ФактАдресПродавца;
			//грузополучатель и покупатель
			ОбластьШапка.Параметры.ПокупательНаименование = СведенияОПокупателе.ПолноеНаименование;
			ОбластьШапка.Параметры.АдресПокупателя = СведенияОПокупателе.ЮридическийАдрес;
			ОбластьШапка.Параметры.ГрузополучательНаименование = СведенияОГрузополучателе.ПолноеНаименование;
			ОбластьШапка.Параметры.АдресГрузополучателя = ФактАдресГП;
			//получаем юр.адрес на английском языке
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Покупатель,Перечисления.ТипыКонтактнойИнформации.Адрес, ВидАдресаЮрАнгл));
			ОбластьШапка.Параметры.АдресПокупателяАнгл = РегАдреса.Представление;
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Грузополучатель,Перечисления.ТипыКонтактнойИнформации.Адрес, АдресДоставки));
			ОбластьШапка.Параметры.АдресГрузополучателяАнгл = РегАдреса.Представление;
			ОбластьШапка.Параметры.Договор    = СсылкаНаОбъект.ДоговорКонтрагента.Номер+" dtd/от "+формат(СсылкаНаОбъект.ДоговорКонтрагента.Дата,"ДЛФ=D");
			
		КонецЕсли;
		
	Иначе
		Если ОрганизацияТТ тогда
			//ОбластьШапка.Параметры.ГрузоотправительНаименование = "Tire Technology Co LTD, Китай/TYRE TECHNOLOGY CO.,LIMITED";
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
			ОбластьШапка.Параметры.ПродавецНаименование = "TYRE TECHNOLOGY CO.,LIMITED";
			//ОбластьШапка.Параметры.ФактАдресПродавца = "YAROSLAVL 150049,RUSSIA, LISITSINA STR., 7 / "+ФактАдресПродавца;
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = "NO.20,HONGKONG MIDDLE ROAD,QINGDAO,CHINA";
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Покупатель,Перечисления.ТипыКонтактнойИнформации.Адрес, ВидАдресаЮрАнгл));
			ОбластьШапка.Параметры.АдресПокупателяАнгл = РегАдреса.Представление;
			РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Грузополучатель,Перечисления.ТипыКонтактнойИнформации.Адрес, ВидАдресаФактАнгл));
			//ОбластьШапка.Параметры.АдресГрузополучателяАнгл = РегАдреса.Представление;
			ОбластьШапка.Параметры.Договор    = СсылкаНаОбъект.ДоговорКонтрагента.Номер+" dtd "+формат(СсылкаНаОбъект.ДоговорКонтрагента.Дата,"ДЛФ=D");
            ОбластьШапка.Параметры.ПокупательНаименование = СведенияОПокупателе.ПолноеНаименование;
		Иначе
			//грузоотправитель и продавец
			ОбластьШапка.Параметры.ГрузоотправительНаименование = строка(Грузоотправитель.НаименованиеПолное);
			ОбластьШапка.Параметры.ФактАдресГрузоотправителя = ФактАдресГО;
			ОбластьШапка.Параметры.ПродавецНаименование = "Общество с ограниченной ответственностью «ШинТрейд Ярославль»";
			ОбластьШапка.Параметры.ФактАдресПродавца = ФактАдресПродавца;
			//грузополучатель и покупатель
			ОбластьШапка.Параметры.ПокупательНаименование = СведенияОПокупателе.ПолноеНаименование;
			ОбластьШапка.Параметры.АдресПокупателя = СведенияОПокупателе.ЮридическийАдрес;
			ОбластьШапка.Параметры.ГрузополучательНаименование = СведенияОГрузополучателе.ПолноеНаименование;
			ОбластьШапка.Параметры.АдресГрузополучателя = ФактАдресГП;
			ОбластьШапка.Параметры.Договор    = СсылкаНаОбъект.ДоговорКонтрагента.Номер+" от "+формат(СсылкаНаОбъект.ДоговорКонтрагента.Дата,"ДЛФ=D");
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если НомерНаПечать = "" Тогда
		Если СсылкаНаОбъект.НомерФормулаАвто = 0 Тогда
			НомерДокумента = ЭтотОбъект.ПолучитьФорму("ВводНомераШинтрейдЯрославль").ОткрытьМодально();
		Иначе
			НомерДокумента = СтрЗаменить(Строка(СсылкаНаОбъект.НомерФормулаАвто),Символы.НПП,"");
		КонецЕсли;
	Иначе
		НомерДокумента = НомерНаПечать;
	КонецЕсли;
	ОбластьШапка.Параметры.Номер = СокрЛП(НомерДокумента);
	ОбластьШапка.Параметры.Дата  = Формат(СсылкаНаОбъект.Дата, "ДФ=dd.MM.yyyy");
	РегАдреса = РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Покупатель,Перечисления.ТипыКонтактнойИнформации.Адрес, ВидАдресаЮрАнгл));

	ОбластьШапка.Параметры.УсловиеПоставки =""+ СсылкаНаОбъект.УсловиеПоставкиНаЭкспорт+" "+РегАдреса.комментарий;
	
	ТабДокумент.Вывести(ОбластьШапка);
	ТабДокумент.Вывести(ОбластьШапкаТаблицы);
	//конец вывод шапки
	
	ИтВесНетто = 0;
	ИтКоличествоМест = 0;
	ИтКомплКоличество = 0;
	НомСтр = 0;
	Для Каждого Строка Из ТЗТоваров Цикл
		
		НомСтр = НомСтр+1;
		ОбластьСтрока.Параметры.НомерСтроки = НомСтр;
		ОбластьСтрока.Параметры.Код = Строка.Номенклатура.Код;
		//ОбластьСтрока.Параметры.Номенклатура = Строка.Номенклатура.НаименованиеПолное;
		ОбластьСтрока.Параметры.Номенклатура = СтрЗаменить(Строка.Номенклатура.НаименованиеПолное, "Диск","Wheel");
		ОбластьСтрока.Параметры.Количество = Строка.Количество;
		Если Строка.КоличествоМест = 0 Тогда
			ОбластьСтрока.Параметры.КоличествоМест = Строка.Количество;
			ИтКоличествоМест = ИтКоличествоМест+Строка.Количество;
		Иначе
			ОбластьСтрока.Параметры.КоличествоМест = Строка.КоличествоМест;
			ИтКоличествоМест = ИтКоличествоМест+Строка.КоличествоМест;
		КонецЕсли;	
		ОбластьСтрока.Параметры.ВесБрутто  = Строка.ВесБрутто;
		
		Если Строка.Номенклатура.ВидТовара = Перечисления.ВидыТоваров.Диски Тогда
			парам1   = Строка.Номенклатура.Типоразмер;
			ЭтоЛитойДиск = Строка.Номенклатура.ПринадлежитЭлементу(Справочники.Номенклатура.НайтиПоКоду("0001753"));
			ДваВОдном = Строка.КоличествоМест/Строка.Количество;
			//ВесНетто = Строка.ВесБрутто - ВесУпаковки(парам1, ЭтоЛитойДиск) * Строка.Количество * ?(ДваВОдном=0,1,ДваВОдном);
			ВесНетто = Строка.ВесБрутто - ВесУпаковки(парам1, ЭтоЛитойДиск) * Строка.Количество;
		Иначе
			ВесНетто = Строка.ВесБрутто;
		КонецЕсли;
		ОбластьСтрока.Параметры.ВесНетто = ВесНетто;
		ИтВесНетто = ИтВесНетто+ВесНетто;
		
		ОбластьСтрока.Параметры.ШтрихКод   =  ПолучитьШтрихКодЯШТ(Строка.Номенклатура.Код);
		//болты и гайки только для Replica
		//КомплКоличество = ?(Найти(врег(Строка.Номенклатура.Производитель.Наименование),"REPLICA")=0, 0,
		// 							число(Строка.Номенклатура.Типоразмер.КоличествоОтверстий));
		//должно быть как в спецификации
		ТекПроизводитель = Строка.Номенклатура.Производитель.Наименование;
		Если Найти(врег(ТекПроизводитель),"REPLICA")>0
			или врег(ТекПроизводитель)="TOP DRIVER"
			или врег(ТекПроизводитель)="CATWILD"
			или врег(ТекПроизводитель)="YST"
			Тогда
			КомплКоличество = число(Строка.Номенклатура.Типоразмер.КоличествоОтверстий);
		Иначе // название производителя = Брэнд
			КомплКоличество = 0;
		КонецЕсли;	
		
		
		ОбластьСтрока.Параметры.КомплКоличество = КомплКоличество;
		ИтКомплКоличество = ИтКомплКоличество+КомплКоличество;
		
		ТабДокумент.Вывести(ОбластьСтрока);
		
	КонецЦикла;
	
	//Итог
	ОбластьИтог.Параметры.ИтогКоличество = ТЗТоваров.Итог("Количество");
	ОбластьИтог.Параметры.ИтогКоличествоМест = ИтКоличествоМест;
	ОбластьИтог.Параметры.ИтогВесБрутто = ТЗТоваров.Итог("ВесБрутто");
	ОбластьИтог.Параметры.ИтогВесНетто = ИтВесНетто;
	ОбластьИтог.Параметры.ИтогКомплКоличество = ИтКомплКоличество;


	ТабДокумент.Вывести(ОбластьИтог);
		
//-------------------печати и подписи---------------------------------------
	ОбластьСтрока1 = Макет.ПолучитьОбласть("ПодвалШапка");
	
	Если ДваЯзыка Тогда
		ОбластьСтрока1.Параметры.ПечПоставщик = "ShinTrade Yaroslavl Ltd / Общество с ограниченной ответственностью «ШинТрейд Ярославль»";
		Если ОрганизацияТТ тогда
			ОбластьСтрока1.Параметры.ПечПоставщик = "TYRE TECHNOLOGY CO.,LIMITED";
			ОбластьСтрока1.Параметры.ПечРуководитель="Zhang Diantao";
		КонецЕсли;
	Иначе	
		ОбластьСтрока1.Параметры.ПечПоставщик = "Общество с ограниченной ответственностью «ШинТрейд Ярославль»";
		Если ОрганизацияТТ тогда
			ОбластьСтрока1.Параметры.ПечПоставщик = "TYRE TECHNOLOGY CO.,LIMITED";
			ОбластьСтрока1.Параметры.ПечРуководитель="Zhang Diantao";
		КонецЕсли;
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьСтрока1);
		
	ТабДокумент.АвтоМасштаб = Истина;
	ТабДокумент.ОтображатьСетку = Ложь;
	
	Возврат ТабДокумент;
				   
КонецФункции

Функция СформироватьНаименованиеТовара(ТЗтоваров, ДваЯзыка,ОрганизацияТТ=ложь)
	
	ГруппаЛитые = Справочники.Номенклатура.НайтиПоКоду("0001753"); //это из алюминия легковые
	ГруппаГрузовые = Справочники.Номенклатура.НайтиПоКоду("9004163");  //это грузовые
	ГруппаШтампованные = Справочники.Номенклатура.НайтиПоКоду("0001755"); //это стальные легковые
	
	ЕстьАлюминиевые = Ложь;
	ЕстьСтальные = Ложь;
	ЕстьГрузовые = Ложь;
	ЕстьАксессуары = Ложь;
	ЕстьШины = Ложь;
	Для Каждого Стр из ТЗТоваров Цикл
		ЭтоЛитойДиск = Стр.Номенклатура.ПринадлежитЭлементу(ГруппаЛитые);
		ЭтоШтампованныйДиск = Стр.Номенклатура.ПринадлежитЭлементу(ГруппаШтампованные);
		ЭтоГрузовойДиск = Стр.Номенклатура.ПринадлежитЭлементу(ГруппаГрузовые);
		Если ЭтоЛитойДиск Тогда
			ЕстьАлюминиевые = Истина;
		ИначеЕсли ЭтоШтампованныйДиск Тогда
			ЕстьСтальные = Истина;
		ИначеЕсли ЭтоГрузовойДиск Тогда 
			ЕстьГрузовые = Истина;
		ИначеЕсли Стр.Номенклатура.ВидТовара = Перечисления.ВидыТоваров.Аксессуары Тогда
			ЕстьАксессуары = Истина;
		ИначеЕсли Стр.Номенклатура.ВидТовара = Перечисления.ВидыТоваров.Шины Тогда
			ЕстьШины = Истина;
		КонецЕсли;	
	КонецЦикла;	
	ПечНаименованиеТовара = "";
	ПечНаименованиеТовараАнгл = "";
	Если ЕстьАлюминиевые Тогда
		ПечНаименованиеТовара = ПечНаименованиеТовара+"Новые алюминиевые";
		ПечНаименованиеТовараАнгл = ПечНаименованиеТовараАнгл+"New aluminum";
	КонецЕсли;
	Если ЕстьСтальные Тогда
		ПечНаименованиеТовара = ?(ПечНаименованиеТовара = "","Новые стальные", ПечНаименованиеТовара+", стальные");
		ПечНаименованиеТовараАнгл = ?(ПечНаименованиеТовараАнгл = "","New steel", ПечНаименованиеТовараАнгл+", steel");
	КонецЕсли;
	Если ПечНаименованиеТовара <> "" Тогда
		ПечНаименованиеТовара = ПечНаименованиеТовара+" колеса для легковых автомобилей, ";
		ПечНаименованиеТовараАнгл = ПечНаименованиеТовараАнгл+" wheels for passenger cars, ";
	КонецЕсли;
	Если ЕстьГрузовые Тогда
		ПечНаименованиеТовара = ПечНаименованиеТовара+"Новые колеса для грузовых автомобилей, ";
		ПечНаименованиеТовараАнгл = ПечНаименованиеТовараАнгл+"New wheels for trucks, ";
	КонецЕсли;
	Если ЕстьШины Тогда
		ПечНаименованиеТовара = ПечНаименованиеТовара+"Шины, ";
		ПечНаименованиеТовараАнгл = ПечНаименованиеТовараАнгл+"Tires, ";
	КонецЕсли;	
	Если ЕстьАксессуары Тогда
		ПечНаименованиеТовара = ПечНаименованиеТовара+"Аксессуары, ";
		ПечНаименованиеТовараАнгл = ПечНаименованиеТовараАнгл+"Accessories, ";
	КонецЕсли;	
	
	ПечНаименованиеТовара = Лев(ПечНаименованиеТовара, СтрДлина(ПечНаименованиеТовара)-2);
	ПечНаименованиеТовараАнгл = Лев(ПечНаименованиеТовараАнгл, СтрДлина(ПечНаименованиеТовараАнгл)-2);
	
	Если ДваЯзыка и не организацияТТ Тогда
		возврат ПечНаименованиеТовараАнгл+" / "+ПечНаименованиеТовара;
	ИначеЕсли организацияТТ	тогда
		возврат ПечНаименованиеТовараАнгл;
	Иначе	
		возврат ПечНаименованиеТовара;
	КонецЕсли;
	
КонецФункции	


Функция ВесУпаковки(типоразмер, ЭтоЛитойДиск = Ложь)
	Попытка
		индексД = ?(типоразмер.Диаметр="",0, число(типоразмер.Диаметр)-13);  
		
		Если индексД>=0 тогда
			Если ЭтоЛитойДиск Тогда
				масса = новый Массив;
				масса.Добавить(0.430); //13
				масса.Добавить(0.650); //14
				масса.Добавить(0.700); //15
				масса.Добавить(0.870); //16
				масса.Добавить(0.950); //17
				масса.Добавить(1.100);  //18
				масса.Добавить(1.200);  //19
				масса.Добавить(1.400);  //20
				масса.Добавить(1.550);  //21
				масса.Добавить(1.700); //22 
				m = масса[индексД];
			Иначе
				масса = новый Массив;
				масса.Добавить(0.300); //13
				масса.Добавить(0.400); //14
				масса.Добавить(0.500); //15
				масса.Добавить(0.600); //16
				масса.Добавить(0.700); //17
				m = масса[индексД];
			КонецЕсли;
		Иначе // это болты или гайки
			m = 0;
		КонецЕсли;
	Исключение
		m = 0;
	КонецПопытки;
	возврат Окр(m,3);
КонецФункции	

функция ПолучитьШтрихКодЯШТ(Код)

Если стрДлина(Код)<7 тогда
	код1 = Формат(число(Код), "ЧЦ=7; ЧВН=");
иначе 
	код1 = код;
КонецЕсли;	
	
ШтрихКод = "05000"+ Код;
ШтрихКод = ШтрихКод + КонтрольныйСимволEAN(ШтрихКод, 13);

возврат ШтрихКод;

КонецФункции
