﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	Если ТипЗнч(ДанныеЗаполнения)=ТипЗнч(Документы.ЗаказПокупателя.ПустаяСсылка()) Тогда 
		Контрагент = ДанныеЗаполнения.Контрагент;
		ДокументОснование = ДанныеЗаполнения;
		Для каждого Стр из ДанныеЗаполнения.Товары Цикл
			СтрУ = Товары.Добавить();
			СтрУ.Номенклатура = Стр.Номенклатура;
			СтрУ.Количество = Стр.Количество;
			СтрУ.ЦенаРеализации = Стр.Цена;
			стрУ.Сумма = Стр.Количество*Стр.Цена;
		КонецЦикла;
	иначеЕсли 	ТипЗнч(ДанныеЗаполнения)=Тип("ДокументСсылка.ЗаявкаНаБрак") Тогда 
	  ДокументОснование = ДанныеЗаполнения;
      Подразделение = ДанныеЗаполнения.Подразделение;
	  Контрагент = ДанныеЗаполнения.контрагент;
	  ПричинаВозврата = Перечисления.ПричиныВозвратаТовара.Брак;
	  //Адиянов<<< 20.06.2016
	  ВидДефектаДляУценки = ДанныеЗаполнения.ВидДефектаДляУценки;
	  //Адиянов>>> 20.06.2016
	  Если  ДанныеЗаполнения.Номенклатура <> Справочники.Номенклатура.ПустаяСсылка() Тогда
		 стр= Товары.Добавить();
		 стр.Номенклатура = ДанныеЗаполнения.Номенклатура;
		 Стр.Количество = ДанныеЗаполнения.количество;
		 Стр.Реализация = ДанныеЗаполнения.Реализация;
		 Если стр.Реализация <> Документы.РеализацияТоваровУслуг.ПустаяСсылка() Тогда
			 Отбор = Новый Структура("Номенклатура",Стр.Номенклатура);
			 строки =Стр.Реализация.Товары.НайтиСтроки(Отбор);
			 Если строки.Количество()>0 Тогда
				 стр.СкладРеализации = Строки[0].Склад; 
				 стр.ЦенаРеализации = Строки[0].Цена;
				 стр.Сумма = Стр.Количество*стр.ЦенаРеализации;
			 конецЕсли;
		 Конецесли;
	 КонецЕсли;
	  Если  ДанныеЗаполнения.Расшифровка.Количество() <> 0 Тогда
		 Для каждого ст из   ДанныеЗаполнения.Расшифровка Цикл
		  стр= Товары.Добавить();
		 стр.Номенклатура = ст.Номенклатура;
		 Стр.Количество = ст.количество;
		 Стр.Реализация = ст.Реализация;
		 Если стр.Реализация <> Документы.РеализацияТоваровУслуг.ПустаяСсылка() Тогда
			 Отбор = Новый Структура("Номенклатура",Стр.Номенклатура);
			 строки =Стр.Реализация.Товары.НайтиСтроки(Отбор);
			 Если строки.Количество()>0 Тогда
				 стр.СкладРеализации = Строки[0].Склад; 
				 стр.ЦенаРеализации = Строки[0].Цена;
				 стр.Сумма = Стр.Количество*стр.ЦенаРеализации;
			 конецЕсли;
		 Конецесли;
		 конецЦикла;
	 КонецЕсли;
	 конецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	к=14;	
	//Запрос=новый Запрос;
	//Запрос.Текст="ВЫБРАТЬ
	//             |	ЗаявкаНаВозвратТоваровТовары.Номенклатура,
	//             |	ЗаявкаНаВозвратТоваровТовары.Реализация,
	//             |	ЗаявкаНаВозвратТоваровТовары.Ссылка,
	//             |	ЗаявкаНаВозвратТоваровТовары.Реализация.Сделка КАК ЗаказПокупателя,
	//             |	ЗаявкаНаВозвратТоваровТовары.НомерСтроки
	//             |ПОМЕСТИТЬ втЗаявка
	//             |ИЗ
	//             |	Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	//             |ГДЕ
	//             |	ЗаявкаНаВозвратТоваровТовары.Ссылка = &Ссылка
	//             |;
	//             |
	//             |////////////////////////////////////////////////////////////////////////////////
	//             |ВЫБРАТЬ
	//             |	ПродажиОбороты.ЗаказПокупателя,
	//             |	ПродажиОбороты.Номенклатура,
	//             |	ПродажиОбороты.Регистратор
	//             |ПОМЕСТИТЬ втВозвраты
	//             |ИЗ
	//             |	РегистрНакопления.Продажи.Обороты(
	//             |			&НачПер,
	//             |			,
	//             |			Регистратор,
	//             |			(ДокументПродажи, Номенклатура) В
	//             |				(ВЫБРАТЬ
	//             |					втЗаявка.Реализация,
	//             |					втЗаявка.Номенклатура
	//             |				ИЗ
	//             |					втЗаявка КАК втЗаявка)) КАК ПродажиОбороты
	//             |ГДЕ
	//             |	ПродажиОбороты.Регистратор ССЫЛКА Документ.ВозвратТоваровОтПокупателя
	//             |;
	//             |
	//             |////////////////////////////////////////////////////////////////////////////////
	//             |ВЫБРАТЬ
	//             |	втЗаявка.ЗаказПокупателя,
	//             |	втВозвраты.ЗаказПокупателя КАК ЗаказПокупателяИзВозврата,
	//             |	втВозвраты.Регистратор,
	//             |	втЗаявка.Номенклатура,
	//             |	втЗаявка.НомерСтроки
	//             |ИЗ
	//             |	втЗаявка КАК втЗаявка
	//             |		ЛЕВОЕ СОЕДИНЕНИЕ втВозвраты КАК втВозвраты
	//             |		ПО втЗаявка.ЗаказПокупателя = втВозвраты.ЗаказПокупателя
	//             |			И втЗаявка.Номенклатура = втВозвраты.Номенклатура";
	//			 Запрос.УстановитьПараметр("Ссылка",Ссылка);
	//			 Запрос.УстановитьПараметр("НачПер",НачалоМесяца(НачалоМесяца(Дата)-1));
	//			 //Запрос.УстановитьПараметр("КонПер",ЗаказНаВозврат);
	//			 
	//			 Рез=Запрос.Выполнить().Выбрать();
	//			 КоличествоНетВозврата=0;
	//			 КоличествоБылВозврат=0;

	//			 Если рез.Количество()>0 тогда
	//				 Пока Рез.Следующий() Цикл
	//					 Если Рез.ЗаказПокупателя=Рез.ЗаказПокупателяИзВозврата тогда
	//					 Товары[рез.номерСтроки-1].ДокументВозврата = Рез.Регистратор;
	//				    КонецЕсли;
	//				 КонецЦикла;
	//			 КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаБрак") Тогда
		
		ПроверитьПрочиеЗаявкиНаВозвратПоЗаявкеНаБрак(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Печать()   Экспорт
   // Если  причинаВозврата <> перечисления.ПричиныВозвратаТовара.Брак и Согласованно Тогда	

	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("МакетСлужебнаяЗаписка2");
	
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка|Основная");
	ОбластьШапкаДоп=Макет.ПолучитьОбласть("Шапка|Доп");
	ОбластьСтрока=Макет.ПолучитьОбласть("Строка|Основная");
	ОбластьСтрокаДоп=Макет.ПолучитьОбласть("Строка|Доп");
	ОбластьПодвал=Макет.ПолучитьОбласть("Подвал");
	
	ОбластьШапка.Параметры.Контрагент=Контрагент.НаименованиеПолное;
	ОбластьШапка.Параметры.ИНН=Контрагент.ИНН;
	ОбластьШапка.Параметры.Менеджер=Ответственный.Наименование;
	ОбластьШапка.Параметры.ЗаявкаНаВозврат=ЭтотОбъект.Ссылка;
    ОбластьШапка.Параметры.Номер=Номер;
	
	ОбШтрихКод=ОбластьШапка.Рисунки.Штрихкод.Объект;
	ОбШтрихКод.ТипКода = 4; 
	ОбШтрихКод.Сообщение = СформироватьШКРеализации(Ссылка,"6");//XMLСтрока(ЭтотОбъект.Ссылка.УникальныйИдентификатор()); 
	ОбШтрихКод.ОтображатьТекст = Ложь;
	
	ТабДок.Вывести(ОбластьШапка);
	
	Если ПричинаВозврата = Перечисления.ПричиныВозвратаТовара.Брак тогда
		Если ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаБрак") Тогда
			
			ТабДок.Присоединить(ОбластьШапкаДоп);		
		КонецЕсли;
	КонецЕсли;
	
	//ТабДок.Вывести(ОбластьШапкаДоп);
	
	
	
	//Для Каждого стр из Товары Цикл
	//	ОбластьСтрока.Параметры.СтрокаНоменклатуры=""+Стр.НомерСтроки+". "+стр.Номенклатура+" ("+стр.Номенклатура.Код+") - "+стр.Количество+" шт.";
	//	ОбластьСтрока.Параметры.СтрокаРеализация="от тов.накл. №"+стр.Реализация.Номер+" от "+Формат(стр.Реализация.Дата,"ДФ=dd.MM.yyyy");
	//	ОбластьСтрока.Параметры.СтрокаСклад="Находились на "+стр.СкладРеализации;
	//	табДок.Вывести(ОбластьСтрока);
	//КонецЦикла;
	
	Для Каждого стр из Товары Цикл
		Если стр.Статус = Перечисления.СтатусыСтрокЗаказа.Подтвержден Тогда
		ОбластьСтрока.Параметры.нн=Стр.НомерСтроки;
		
		//+++ 14.09.2017 добавлен Код отдельной колонкой
		ОбластьСтрока.Параметры.Код = стр.Номенклатура.Код; 
		ОбластьСтрока.Параметры.СтрокаНоменклатуры=?(стр.Номенклатура.ВидТовара = перечисления.ВидыТоваров.АКБ
													или стр.Номенклатура.ВидТовара = перечисления.ВидыТоваров.Аксессуары,"("+стр.Номенклатура.Артикул+") ","")+стр.Номенклатура.НаименованиеПолное;
															
		//---05.07.2016 на тот редкий случай, когда реализацию не проставили
		Если не Стр.Реализация = Неопределено Тогда 
			//ОбластьСтрока.Параметры.СтрокаРеализация=стр.Реализация.Номер+" от "+Формат(стр.Реализация.Дата,"ДФ=dd.MM.yyyy");
			ОбластьСтрока.Параметры.СтрокаРеализация=стр.Реализация.Номер;
			ОбластьСтрока.Параметры.Дата=Формат(стр.Реализация.Дата,"ДФ=dd.MM.yyyy");
		КонецЕсли;
		//---05.07.2016
		ОбластьСтрока.Параметры.Количество= стр.Количество;
		ОбластьСтрока.Параметры.СтрокаСклад=стр.СкладРеализации;
		ОбластьСтрока.Параметры.НомерИМ=стр.НомерЗаказаИМ;
		ОбластьСтрока.Параметры.НомерТК=стр.НомерЗаказаТК;
		
		
		табДок.Вывести(ОбластьСтрока);
		
		Если ПричинаВозврата = Перечисления.ПричиныВозвратаТовара.Брак тогда
			Если ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаявкаНаБрак") Тогда
				
				ПараметрыОтбора = Новый Структура;
				ПараметрыОтбора.Вставить("Номенклатура", стр.Номенклатура);
				МассивНашли  = ДокументОснование.Расшифровка.НайтиСтроки( ПараметрыОтбора);
				для каждого стр1 из МассивНашли цикл
					ОбластьСтрокаДоп.Параметры.Действие = стр1.Действие;
					табДок.Присоединить(ОбластьСтрокаДоп);
					Прервать;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		
		конецЕсли;
	КонецЦикла;

	
	ОбластьПодвал.Параметры.Основание="Основание: "+ПричинаВозврата;
	ОбластьПодвал.Параметры.Комментарий=Комментарий;
	ОбластьПодвал.Параметры.КомментарийСклада=КомментарийСклада;
	ОбластьПодвал.Параметры.Дата=Формат(Дата,"ДФ=dd.MM.yyyy");
    ОбластьПодвал.Параметры.Менеджер=Ответственный.Наименование;
	
	табДок.Вывести(ОбластьПодвал);
    табдок.ОтображатьСетку = Ложь;
	табДок.АвтоМасштаб = Истина;
	табДок.Показать();
	//конецЕсли;
конецпроцедуры	

Функция ПечатьТорг2() Экспорт
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("Макет_Торг_2");
	
	ОрганизацияЯШТ = Справочники.Организации.НайтиПоКоду("00001");
	
	Если ЭтоЗявкаИМ() тогда
		ОбластьШапка = Макет.ПолучитьОбласть("Страница1Шапка");
		ОбластьШапка.Параметры.Организация 				= ОрганизацияЯШТ.Наименование;
		ОбластьШапка.Параметры.КодОКПО 					= ОрганизацияЯШТ.КодПоОКПО;
		ОбластьШапка.Параметры.КодОКДП 					= "";
		ОбластьШапка.Параметры.НомерДок 				= "";
		ОбластьШапка.Параметры.ДатаДок 					= Формат(ЭтотОбъект.Дата,"ДФ=dd.MM.yyyy");
		ОбластьШапка.Параметры.АД 						= Формат(ЭтотОбъект.Дата,"ДФ=dd");		
		ОбластьШапка.Параметры.АМ 						= Формат(ЭтотОбъект.Дата,"ДФ=ММММ");
		ОбластьШапка.Параметры.АГ 						= Формат(ЭтотОбъект.Дата,"ДФ=гггг");
		ОбластьШапка.Параметры.МестоПриемкиТовара 		= "г. Ярославль, ул. Базовая, д.3 стр.2";
		ОбластьШапка.Параметры.ТоварнаяНакладная 		= "Реестр на возврат (АБП) "+Комментарий;
		ОбластьШапка.Параметры.Поставщик 				= "АО ""Армадилло Бизнес Посылка""";
		ОбластьШапка.Параметры.Поставщик2 				= "";
		ОбластьШапка.Параметры.ДоговорНом 				= "";
		ОбластьШапка.Параметры.СфНом 					= "";
		ОбластьШапка.Параметры.СФД 						= "";
		ОбластьШапка.Параметры.СФМ 						= "";
		ОбластьШапка.Параметры.СФГ 						= "";
		ОбластьШапка.Параметры.СпособДоставки 			= "Доставка а/м грузоотправителя";
		ОбластьШапка.Параметры.ДатаТоварнойНакладной 	= "";
		ОбластьШапка.Параметры.СкладОтправителяТовара	= "";
		
		табДок.Вывести(ОбластьШапка);
		
		Область = Макет.ПолучитьОбласть("Страница1Таблица1Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница1Таблица1Строка");
		табДок.Вывести(Область);
		
		табДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		Область = Макет.ПолучитьОбласть("Страница2Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2Строка");
		Для к=1 по 5 цикл
			табДок.Вывести(Область);
		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Страница2Продолжение1");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица3Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица3Строка");
		
		НомПункт=1;
		Для каждого стр из Товары Цикл
			Если стр.Повреждение тогда
				Область.Параметры.НомПункт = НомПункт;
				Область.Параметры.Товар = СокрЛП(стр.Номенклатура.Наименование);
				Область.Параметры.ЕдИзм = СокрЛП(стр.Номенклатура.ЕдиницаХраненияОстатков);
				Область.Параметры.Артикул = СокрЛП(стр.Номенклатура.Код);
				Область.Параметры.КолвоДок = стр.Количество;
				Область.Параметры.ЦенаЕд = стр.ЦенаРеализации;
				Область.Параметры.Сумма = стр.Сумма;
				
				НомПункт=НомПункт+1;
				
				табДок.Вывести(Область);
			КонецЕсли;
		КонецЦикла;
		
		табДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		Область = Макет.ПолучитьОбласть("Страница3Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница3Таблица4Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница3Таблица4Строка");
		Для к=1 по НомПункт-1 цикл
			табДок.Вывести(Область);
		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Страница4Шапка");
		
		Область.Параметры.МетодОпределенияКоличества="";
		Область.Параметры.ОписаниеДефектов="";
		Область.Параметры.ЗаключениеКомиссии="При получении товара обнаружен брак в количестве";
		
		Область.Параметры.ПредседательКомиссии 			 = "";
		Область.Параметры.РасшифровкаПодписиПредседателя ="Гаричев Д.Н.";
		Область.Параметры.Чел1 							 = "ст. кладовщик";
		Область.Параметры.РасшЧел1 						 = "Сибриков М.А.";
		Область.Параметры.Чел2 							 = "кладовщик";
		Область.Параметры.РасшЧел2						 = "Войнов В.В.";
		Область.Параметры.Чел3							 = "";
		Область.Параметры.РасшЧел3						 = "";
		Область.Параметры.Предст1						 = "";
		Область.Параметры.РасшПредст1 					 = "";
		Область.Параметры.ТипДокумента 					 = "";
		Область.Параметры.НомерСерия 					 = "";
		Область.Параметры.КемВыданКогда					 = "";
		Область.Параметры.ПечГлавБух 					 = "";
		Область.Параметры.РешениеРуководителя 			 = "";
		табДок.Вывести(Область);
	иначе  //заказ не ИМ
		ОбластьШапка = Макет.ПолучитьОбласть("Страница1Шапка");
		ОбластьШапка.Параметры.Организация 				= ОрганизацияЯШТ.Наименование;
		ОбластьШапка.Параметры.КодОКПО 					= ОрганизацияЯШТ.КодПоОКПО;
		ОбластьШапка.Параметры.КодОКДП 					= "";
		ОбластьШапка.Параметры.НомерДок 				= Номер;
		ОбластьШапка.Параметры.ДатаДок 					= Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy");
		ОбластьШапка.Параметры.АД 						= Формат(ТекущаяДата(),"ДФ=dd");		
		ОбластьШапка.Параметры.АМ 						= Формат(ТекущаяДата(),"ДФ=ММММ");
		ОбластьШапка.Параметры.АГ 						= Формат(ТекущаяДата(),"ДФ=гггг");
		ОбластьШапка.Параметры.МестоПриемкиТовара 		= "г. Ярославль, ул. Базовая, д.3 стр.2";
		ОбластьШапка.Параметры.ТоварнаяНакладная 		= ПолучитьСписокРеализаций();
		ОбластьШапка.Параметры.Поставщик 				= Контрагент;
		ОбластьШапка.Параметры.Поставщик2 				= "";
		ОбластьШапка.Параметры.ДоговорНом 				= "";
		ОбластьШапка.Параметры.СфНом 					= "";
		ОбластьШапка.Параметры.СФД 						= "";
		ОбластьШапка.Параметры.СФМ 						= "";
		ОбластьШапка.Параметры.СФГ 						= "";
		ОбластьШапка.Параметры.СпособДоставки 			= КомментарийСклада;
		ОбластьШапка.Параметры.ДатаТоварнойНакладной 	= "";
		ОбластьШапка.Параметры.СкладОтправителяТовара	= "";
		
		табДок.Вывести(ОбластьШапка);
		
		Область = Макет.ПолучитьОбласть("Страница1Таблица1Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница1Таблица1Строка");
		табДок.Вывести(Область);
		
		табДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		Область = Макет.ПолучитьОбласть("Страница2Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2Строка");
		Для к=1 по 5 цикл
			табДок.Вывести(Область);
		КонецЦикла;
		
		Область = Макет.ПолучитьОбласть("Страница2Продолжение1");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица2");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица3Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница2Таблица3Строка");
		
		НомПункт=1;
		Для каждого стр из Товары Цикл
			Если стр.Повреждение тогда
				Область.Параметры.НомПункт = НомПункт;
				Область.Параметры.Товар = СокрЛП(стр.Номенклатура.Наименование);
				Область.Параметры.ЕдИзм = СокрЛП(стр.Номенклатура.ЕдиницаХраненияОстатков);
				Область.Параметры.Артикул = СокрЛП(стр.Номенклатура.Код);
				Область.Параметры.КолвоДок = стр.Количество;
				Область.Параметры.ЦенаЕд = стр.ЦенаРеализации;
				Область.Параметры.Сумма = стр.Сумма;
				
				НомПункт=НомПункт+1;
				
				табДок.Вывести(Область);
			КонецЕсли;
		КонецЦикла;
		
		табДок.ВывестиГоризонтальныйРазделительСтраниц();
		
		Область = Макет.ПолучитьОбласть("Страница3Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница3Таблица4Шапка");
		табДок.Вывести(Область);
		
		Область = Макет.ПолучитьОбласть("Страница3Таблица4Строка");
		//Для к=1 по НомПункт-1 цикл
		//	табДок.Вывести(Область);
		//КонецЦикла;
		КолВоБракаИтого = 0;
		НомПункт=1;
		Для каждого стр из Товары Цикл
			Если стр.Повреждение тогда
				Область.Параметры.НомПункт = НомПункт;
                Область.Параметры.Артикул = СокрЛП(стр.Номенклатура.Код);
				Область.Параметры.ФактКолво = стр.Количество;
                Область.Параметры.ФактЦена = стр.ЦенаРеализации;
				Область.Параметры.ФактСумма = стр.Сумма;
                Область.Параметры.БракКолво = стр.КоличествоПовреждено;
				
				КолВоБракаИтого=КолВоБракаИтого+стр.КоличествоПовреждено;
				
				НомПункт=НомПункт+1;
				
				табДок.Вывести(Область);
			КонецЕсли;
        КонецЦикла;
		
		
		Область = Макет.ПолучитьОбласть("Страница4Шапка");
		
		Область.Параметры.МетодОпределенияКоличества="";
		Область.Параметры.ОписаниеДефектов="";
		Область.Параметры.ЗаключениеКомиссии="При получении товара обнаружен брак в количестве "+КолВоБракаИтого+" шт.";
		
		Область.Параметры.ПредседательКомиссии 			 = "";
		Область.Параметры.РасшифровкаПодписиПредседателя ="Гаричев Д.Н.";
		Область.Параметры.Чел1 							 = "ст. кладовщик";
		Область.Параметры.РасшЧел1 						 = "Цверава В.У.";
		Область.Параметры.Чел2 							 = "кладовщик";
		Область.Параметры.РасшЧел2						 = "Челин В.Н.";
		Область.Параметры.Чел3							 = "";
		Область.Параметры.РасшЧел3						 = "Невежина И.И.";
		Область.Параметры.Предст1						 = "";
		Область.Параметры.РасшПредст1 					 = "";
		Область.Параметры.ТипДокумента 					 = "";
		Область.Параметры.НомерСерия 					 = "";
		Область.Параметры.КемВыданКогда					 = "";
		Область.Параметры.ПечГлавБух 					 = "";
		Область.Параметры.РешениеРуководителя 			 = "";
		табДок.Вывести(Область);
	КонецЕсли;
	
	Возврат ТабДок;
КонецФункции

Функция ПолучитьСписокРеализаций()
	Реализации = товары.ВыгрузитьКолонки("Реализация");
	Для каждого стр из товары цикл
		Если стр.Повреждение тогда
			нстр = Реализации.Добавить();
			ЗаполнитьЗначенияСвойств(нстр,стр);
		КонецЕсли;
	КонецЦикла;
	Реализации.Свернуть("Реализация");
	Реализации.Сортировать("Реализация");
	стр = "по реализациям №";
	Если Реализации.Количество()=1 тогда
		Возврат "по реализации №"+Реализации[0].Реализация.Номер+" от "+ Формат(Реализации[0].Реализация.Дата,"ДФ=dd.MM.yyyy");
	Иначе 
		Для каждого реализация из Реализации цикл
			стр = стр+реализация.Реализация.Номер+" от "+ Формат(реализация.Реализация.Дата,"ДФ=dd.MM.yyyy")+", "+Символы.ПС;
		КонецЦикла;
		стр = лев(стр,СтрДлина(стр)-3); //убираем последни ,
	конецЕсли;
	Возврат стр;
КонецФункции


Функция ЭтоЗявкаИМ()
	
	НаправлениеПродажКолесаТУТ = Справочники.НаправленияПродаж.НайтиПоКоду("16");
	
	Для каждого стр из товары цикл
		Если стр.Реализация.ДоговорКонтрагента.ОтветственноеЛицо.НаправлениеПродаж = НаправлениеПродажКолесаТУТ тогда
			Возврат истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ложь;
КонецФункции

Функция ПечатьАКТ() Экспорт
	Для Каждого стр из товары Цикл
		Если стр.Повреждение тогда
			ТабДок=Новый ТабличныйДокумент;
			Макет=ПолучитьМакет("Макет_Акт_Об_Обнаружении_Повреждений_Груза");
			
			Если Контрагент = Справочники.Контрагенты.НайтиПоКоду("П000382") тогда
				Получатель = ""+Контрагент;
			иначе
				Получатель = "ЗАО ТК ""Яршинторг""";
			КонецЕсли;
			
			ОбластьАКТ = Макет.ПолучитьОбласть("АКТ");
			ОбластьАКТ.Параметры.Клиент 					= стр.Отправитель;
			ОбластьАКТ.Параметры.Получатель 				= Получатель;
			ОбластьАКТ.Параметры.АдресМестаСоставления 		= "150044, Ярославская обл, Ярославль г, Базовая ул, дом № 3, стр.2";
			ОбластьАКТ.Параметры.НомерДПД 					= сокрЛП(стр.НомерЗаказаТК);
			ОбластьАКТ.Параметры.Номенклатура 					= сокрЛП(стр.Номенклатура);
			ОбластьАКТ.Параметры.ФилиалСоставления  = "YAR";
			табДок.Вывести(ОбластьАКТ);
			
			ТабДок.ОтображатьСетку = ложь;
			ТабДок.АвтоМасштаб=истина;
			
			табДок.Показать();
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция ПечатьПретензии() Экспорт
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("Макет_Претензия_В_ТК");
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока=Макет.ПолучитьОбласть("Строка");
	ОбластьУслуги=Макет.ПолучитьОбласть("услуги");
	ОбластьВсего=Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал=Макет.ПолучитьОбласть("Подвал");
	ОбластьРеквизиты=Макет.ПолучитьОбласть("Реквизиты");

	
	Организация = Справочники.Организации.НайтиПоКоду("00001");
	СведенияОПоставщике = СведенияОЮрФизЛице(Организация, Ссылка.Дата);
	ОписаниеОрганизации=ОписаниеОрганизации(СведенияОПоставщике, "ЮридическийАдрес,ИНН,КПП,НомерСчета,Банк,БИК,КоррСчет,Телефоны");
	//БанковскийСчетОрганизации1  = Организация.ОсновнойБанковскийСчет;
    //Сообщить(к);
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаявкаНаВозвратТоваровТовары.Ссылка,
	             |	ЗаявкаНаВозвратТоваровТовары.Номенклатура КАК Товар,
	             |	ЗаявкаНаВозвратТоваровТовары.Количество,
	             |	ЗаявкаНаВозвратТоваровТовары.ЦенаРеализации КАК Цена,
	             |	ЗаявкаНаВозвратТоваровТовары.Сумма КАК Сумма,
	             |	ЗаявкаНаВозвратТоваровТовары.НомерЗаказаТК КАК НомерЗаказаТК,
	             |	ЗаявкаНаВозвратТоваровТовары.Отправитель КАК Отправитель,
	             |	ЗаявкаНаВозвратТоваровТовары.Номенклатура.Код КАК КодТовара,
	             |	ЗаявкаНаВозвратТоваровТовары.НомерЗаказаИМ КАК НомерЗаказаИМ
	             |ПОМЕСТИТЬ Товары
	             |ИЗ
	             |	Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	             |ГДЕ
	             |	ЗаявкаНаВозвратТоваровТовары.Ссылка = &Ссылка
	             |	И ЗаявкаНаВозвратТоваровТовары.Повреждение
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЗаказПокупателяУслуги.Ссылка,
	             |	ЗаказПокупателяУслуги.Содержание,
	             |	ЗаказПокупателяУслуги.Номенклатура,
	             |	ЗаказПокупателяУслуги.Сумма,
	             |	ЗаказПокупателяУслуги.Цена
	             |ПОМЕСТИТЬ Услуги
	             |ИЗ
	             |	Документ.ЗаказПокупателя.Услуги КАК ЗаказПокупателяУслуги
	             |ГДЕ
	             |	ЗаказПокупателяУслуги.Ссылка.НомерВходящегоДокумента В
	             |			(ВЫБРАТЬ
	             |				ЗаявкаНаВозвратТоваровТовары.НомерЗаказаИМ КАК НомерЗаказаИМ
	             |			ИЗ
	             |				Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	             |			ГДЕ
	             |				ЗаявкаНаВозвратТоваровТовары.Ссылка = &Ссылка
	             |				И ЗаявкаНаВозвратТоваровТовары.Повреждение)
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	Товары.Ссылка,
	             |	Товары.Товар,
	             |	Товары.Количество,
	             |	Товары.Цена,
	             |	Товары.Сумма КАК СуммаТоваров,
	             |	Товары.НомерЗаказаТК КАК НомерЗаказаТК,
	             |	Товары.Отправитель КАК Отправитель,
	             |	Товары.КодТовара,
	             |	Товары.НомерЗаказаИМ КАК НомерЗаказаИМ,
	             |	Услуги.Содержание,
	             |	ЕстьNull(Услуги.Сумма, 0) КАК СуммаУслуг,
		         |	ЕстьNull(Товары.Сумма, 0) + ЕстьNull(Услуги.Сумма, 0) КАК СуммаВсего

	             |ИЗ
	             |	Товары КАК Товары
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Услуги КАК Услуги
	             |		ПО Товары.НомерЗаказаИМ = Услуги.Ссылка.НомерВходящегоДокумента
	             |ИТОГИ
	             |	СУММА(СуммаТоваров),
	             |	МАКСИМУМ(НомерЗаказаИМ),
	             |	СУММА(СуммаУслуг),
	             |	СУММА(СуммаВсего)
	             |ПО
	             |	НомерЗаказаТК,
	             |	Отправитель";
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	ВыборкаЗаказы = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаЗаказы.Следующий() Цикл
		ОбластьШапка.Параметры.НомерЗаказаТК = ВыборкаЗаказы.НомерЗаказаТК;
		ОбластьШапка.Параметры.НомерЗаказаИМ = ВыборкаЗаказы.НомерЗаказаИМ;

		ВыборкаОтправитель = ВыборкаЗаказы.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОтправитель.Следующий() Цикл
			ОбластьРеквизиты.Параметры.ОписаниеОрганизации=ОписаниеОрганизации;
			табДок.Вывести(ОбластьРеквизиты);

			ОбластьШапка.Параметры.НомерЗаказаТК=ВыборкаОтправитель.НомерЗаказаТК;
			ОбластьШапка.Параметры.Отправитель=ВыборкаОтправитель.Отправитель;

			табДок.Вывести(ОбластьШапка);
			ВыборкаДетали = ВыборкаОтправитель.Выбрать();
			пп=1;
			СуммаПретензииТоваров  = ВыборкаОтправитель.СуммаТоваров;
			СуммаПретензииУслуг  = ВыборкаОтправитель.СуммаУслуг;
			СуммаПретензии  = ВыборкаОтправитель.СуммаВсего;

			Пока ВыборкаДетали.Следующий() Цикл
				ОбластьСтрока.Параметры.ПП = пп;
				ОбластьСтрока.Параметры.Заполнить(ВыборкаДетали);
				пп=пп+1;
				табДок.Вывести(ОбластьСтрока);
			КонецЦикла;
			
			//итог
			ОбластьСтрока.Параметры.ПП = "";
			ОбластьСтрока.Параметры.Товар = "";
			ОбластьСтрока.Параметры.Цена = "";
			ОбластьСтрока.Параметры.КодТовара = "ИТОГО";

			ОбластьСтрока.Параметры.Количество = "";
			ОбластьСтрока.Параметры.СуммаТоваров = СуммаПретензииТоваров;
			табДок.Вывести(ОбластьСтрока);
			
			ОбластьУслуги.Параметры.СуммаУслуг = СуммаПретензииУслуг;
			табДок.Вывести(ОбластьУслуги);
			
            ОбластьВсего.Параметры.СуммаВсего = СуммаПретензии;
			табДок.Вывести(ОбластьВсего);

		КонецЦикла;
		ОбластьПодвал.Параметры.СуммаПретензии = СуммаПретензии;
		ОбластьПодвал.Параметры.ДатаПретензии = Формат(Ссылка.Дата,"ДФ=dd.MM.yyyy");
		табДок.Вывести(ОбластьПодвал);
		ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
	  Возврат ТабДок;
КонецФункции

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//Если РольДоступна("ПолныеПрава") Тогда 
	//	нетДокументов = Ложь;
	//КонецЕсли;
	Если Не Согласованно Тогда
		Отказ  = ПроверитьСрокВозврата();  // Сакулина
	КонецЕсли;
	Если не Отказ тогда
		Отказ = ПроверитьСоответствиеКонтрагентов();
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьСрокВозврата()
	Отказ = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Значение КАК ДнейВозврата,
	|	ЗначенияСвойствОбъектов.Объект КАК Контрагент
	|ПОМЕСТИТЬ ВТСрок
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Объект = &Контрагент
	|	И ЗначенияСвойствОбъектов.Свойство = &СвойствоДопустимыйСрокВозврата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаявкаНаВозвратТоваровТовары.Номенклатура,
	|	ЗаявкаНаВозвратТоваровТовары.Реализация.Дата,
	|	ЗаявкаНаВозвратТоваровТовары.Ссылка.Дата КАК ВозвратаДата,
	|	ЕСТЬNULL(ВТСрок.ДнейВозврата, 30) КАК ДнейВозврата
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСрок КАК ВТСрок
	|		ПО ЗаявкаНаВозвратТоваровТовары.Ссылка.Контрагент = ВТСрок.Контрагент
	|ГДЕ
	|	ЗаявкаНаВозвратТоваровТовары.Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Диски)
	|	И ЗаявкаНаВозвратТоваровТовары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТТовары.Номенклатура,
	|	РАЗНОСТЬДАТ(НАЧАЛОПЕРИОДА(ВТТовары.РеализацияДата, ДЕНЬ), НАЧАЛОПЕРИОДА(ВТТовары.ВозвратаДата, ДЕНЬ), ДЕНЬ) КАК ФактДнейВозврата,
	|	ВТТовары.РеализацияДата,
	|	ВТТовары.ВозвратаДата,
	|	ВТТовары.ДнейВозврата,
	|	ВТТовары.Номенклатура.Представление
	|ИЗ
	|	ВТТовары КАК ВТТовары ";
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.УстановитьПараметр("СвойствоДопустимыйСрокВозврата",ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90208"));
	Запрос.УстановитьПараметр("Ссылка",Ссылка);

	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если  Окр((НачалоДня(Выборка.ВозвратаДата)-НачалоДня(Выборка.РеализацияДата))/60/60/24) > Выборка.ДнейВозврата Тогда
			Сообщить(" По товару: "+ Выборка.НоменклатураПредставление + " допустимый срок возврата " + 
			Выборка.ДнейВозврата +" дней. С момента реализации прошло " + Выборка.ФактДнейВозврата + " дней.");
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Отказ;	
КонецФункции

Процедура ПроверитьНоменклатуруВРеализации(стр) экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументТовары.Ссылка,
	
	//+++ 13.12.2016 -- один товар в разных строках документа (но по 1 цене!)---  см. Заявка № 12954
	|	ДокументТовары.Цена,
	|	СУММА(ДокументТовары.Количество) КАК Количество,
	
	|	ВЫБОР
	|		КОГДА СУММА(ПродажиОбороты.КоличествоОборот) > 0
	|			ТОГДА ВЫРАЗИТЬ(СУММА(ПродажиОбороты.СтоимостьОборот) / СУММА(ПродажиОбороты.КоличествоОборот) КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЦенаПродажиОборот
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары,
	|	РегистрНакопления.Продажи.Обороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			,
	|			ДокументПродажи = &Ссылка
	|				И Номенклатура = &Номенклатура) КАК ПродажиОбороты
	|ГДЕ
	|	ДокументТовары.Ссылка = &Ссылка
	|	И ДокументТовары.Номенклатура = &Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокументТовары.Ссылка,
	|	ДокументТовары.Цена";
	
	Запрос.УстановитьПараметр("НачалоПериода", стр.Реализация.Дата);
	Запрос.УстановитьПараметр("КонецПериода", ТекущаяДата());
	Запрос.УстановитьПараметр("Количество", стр.Количество);
	Запрос.УстановитьПараметр("Номенклатура", стр.Номенклатура);
	Запрос.УстановитьПараметр("Ссылка", стр.Реализация);
	
	Если ТипЗнч(стр.Реализация) = тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"РеализацияТоваровУслуг","ОтчетОРозничныхПродажах");
	КонецЕсли;
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Если стр.Количество <= ВыборкаДетальныеЗаписи.Количество Тогда 
		стр.ЦенаРеализации = ВыборкаДетальныеЗаписи.ЦенаПродажиОборот;	
		Иначе
			Сообщить("В документе реализации содержится меньшее количество " + стр.Номенклатура+ ". Исправлено на " + ВыборкаДетальныеЗаписи.Количество);
			стр.Количество = ВыборкаДетальныеЗаписи.Количество;
			стр.ЦенаРеализации = ВыборкаДетальныеЗаписи.ЦенаПродажиОборот;
		КонецЕсли; 		
	КонецЕсли;  
КонецПроцедуры	

Функция ПолучитьТекстЗапросаДляКонтроляТоваровПоЗаявкеНаБрак()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	тзТовары.Номенклатура,
	|	тзТовары.Количество
	|ПОМЕСТИТЬ втТовары
	|ИЗ
	|	&тзТовары КАК тзТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	зтЗаявкаНаБракТовары.Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(втТовары.Номенклатура) КАК НоменклатураПредставление,
	|	втТовары.Номенклатура.Код КАК НоменклатураКод,
	|	ЕСТЬNULL(зтЗаявкаНаБракТовары.Количество, 0) КАК КоличествоЗаявкаНаБрак,
	|	ЕСТЬNULL(зтЗаявкиНаВозвратТовары.Количество, 0) КАК КоличествоЗаявкиНаВозврат,
	|	втТовары.Количество КАК КоличествоТекЗаявкаНаВозврат,
	|	ЕСТЬNULL(зтЗаявкаНаБракТовары.Количество, 0) - ЕСТЬNULL(зтЗаявкиНаВозвратТовары.Количество, 0) КАК КоличествоЗаявкаНаБракМинусЗаявкиНаВозврат,
	|	ЕСТЬNULL(зтЗаявкаНаБракТовары.Количество, 0) - ЕСТЬNULL(зтЗаявкиНаВозвратТовары.Количество, 0) - втТовары.Количество КАК КоличествоОстаток
	|ИЗ
	|	втТовары КАК втТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаявкаНаБракРасшифровка.Номенклатура КАК Номенклатура,
	|			СУММА(ЗаявкаНаБракРасшифровка.Количество) КАК Количество
	|		ИЗ
	|			Документ.ЗаявкаНаБрак.Расшифровка КАК ЗаявкаНаБракРасшифровка
	|		ГДЕ
	|			ЗаявкаНаБракРасшифровка.Ссылка = &ЗаявкаНаБрак
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ЗаявкаНаБракРасшифровка.Номенклатура) КАК зтЗаявкаНаБракТовары
	|		ПО втТовары.Номенклатура = зтЗаявкаНаБракТовары.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаявкаНаВозвратТоваровТовары.Номенклатура КАК Номенклатура,
	|			СУММА(ЗаявкаНаВозвратТоваровТовары.Количество) КАК Количество
	|		ИЗ
	|			Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	|		ГДЕ
	|			ЗаявкаНаВозвратТоваровТовары.Ссылка В
	|					(ВЫБРАТЬ
	|						ЗаявкаНаВозвратТоваров.Ссылка
	|					ИЗ
	|						Документ.ЗаявкаНаВозвратТоваров КАК ЗаявкаНаВозвратТоваров
	|					ГДЕ
	|						ЗаявкаНаВозвратТоваров.ДокументОснование ССЫЛКА Документ.ЗаявкаНаБрак
	|						И ЗаявкаНаВозвратТоваров.ДокументОснование = &ЗаявкаНаБрак
	|						И ЗаявкаНаВозвратТоваров.Дата < &Период)
	|			И НЕ ЗаявкаНаВозвратТоваровТовары.Ссылка = &ТекущЗаявкНаВозвр
	//Миронычев
	|           И ЗаявкаНаВозвратТоваровТовары.Ссылка.Проведен = Истина
	//КонецМиронычев
		
	|		СГРУППИРОВАТЬ ПО
	|			ЗаявкаНаВозвратТоваровТовары.Номенклатура) КАК зтЗаявкиНаВозвратТовары
	|		ПО втТовары.Номенклатура = зтЗаявкиНаВозвратТовары.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(зтЗаявкаНаБракТовары.Количество, 0) - ЕСТЬNULL(зтЗаявкиНаВозвратТовары.Количество, 0) - втТовары.Количество < 0";
	
	Возврат ТекстЗапроса;
	
КонецФункции // ПолучитьТекстЗапросаДляКонтроляТоваровПоЗаявкеНаБрак()

Процедура ПроверитьПрочиеЗаявкиНаВозвратПоЗаявкеНаБрак(Отказ)
	
	тзТовары = Товары.Выгрузить(, "Номенклатура, Количество");
	тзТовары.Свернуть("Номенклатура", "Количество");
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапросаДляКонтроляТоваровПоЗаявкеНаБрак();
	Если ЭтоНовый() Тогда
		Период = ТекущаяДата();
	Иначе
		Период = Дата;
	КонецЕсли;
	Запрос.УстановитьПараметр("Период"           , Период);
	Запрос.УстановитьПараметр("ЗаявкаНаБрак"     , ДокументОснование);
	Запрос.УстановитьПараметр("ТекущЗаявкНаВозвр", Ссылка);
	Запрос.УстановитьПараметр("тзТовары"         , тзТовары);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
		#Если Клиент Тогда
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				Сообщить("" + Ссылка + " :: товара """ + Выборка.НоменклатураПредставление + """ (" + 
					Выборка.НоменклатураКод + ") доступно для возврата " + Выборка.КоличествоЗаявкаНаБракМинусЗаявкиНаВозврат + 
					", а указано " + Выборка.КоличествоТекЗаявкаНаВозврат);
			КонецЦикла;
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры // ПроверитьПрочиеЗаявкиНаВозвратПоЗаявкеНаБрак()

//Миронычев
Функция ПолучитьСписокПечатныхФорм() Экспорт
   # Если Клиент Тогда
	СписокМакетов = Новый СписокЗначений;
   ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;
   # КонецЕсли
КонецФункции // ПолучитьСписокПечатныхФорм()
//КонецМиронычев


Процедура ПриЗаписи(Отказ)
	Регистрируем = Истина;
	Для каждого стр из Товары Цикл
		Если не ЗначениеЗаполнено(стр.реализация) тогда
			регистрируем = Ложь;
		конецЕсли;	
	конецЦикла;
	Если регистрируем тогда
		СписокПричин = Новый СписокЗначений;
		СписокПричин.Добавить(Перечисления.ПричиныВозвратаТовара.Брак);
		СписокПричин.Добавить(Перечисления.ПричиныВозвратаТовара.БракАКБ);
		СписокПричин.Добавить(Перечисления.ПричиныВозвратаТовара.БракВыгрузка);
		
		Если не Отказ и списокПричин.НайтиПоЗначению(ЭтотОбъект.ПричинаВозврата)= неопределено  Тогда
			Запрос1 = Новый Запрос;
			Запрос1.Текст = "ВЫБРАТЬ 
			|	Авторизация.Наименование КАК База,
			|	Авторизация.Логин,
			|	Авторизация.Пароль
			|ИЗ
			|	Справочник.Авторизация КАК Авторизация
			|ГДЕ
			|	Авторизация.Владелец = &Владелец";
			
			Запрос1.УстановитьПараметр("Владелец", ЭтотОбъект.Контрагент);
			Результат = Запрос1.Выполнить();
			Если не Результат.Пустой() Тогда //ДЛЯ ВСЕХ КЛИЕНТОВ STORE и TERMINAL
				Попытка
					ОбменСУТИнтернетМагазин.ВключитьРегистрациюОбъектаОИМ(ЭтотОбъект, Контрагент.ПриниматьЗаказыЧерезСайт ); //  по объекту
				Исключение
					#Если Клиент Тогда
						СообщитьОбОшибке("Заявка: "+строка(ссылка)+" не может быть добавлен в план обмена! "+ОписаниеОшибки() );
					#КонецЕсли	
				КонецПопытки;
			КонецЕсли;	
		КонецЕсли;
	конецЕсли;
КонецПроцедуры

Функция ПроверитьСоответствиеКонтрагентов()
	отк=ложь;
	Для каждого стр из Товары Цикл
		Если ЗначениеЗаполнено(стр.Реализация) и типЗнч(стр.Реализация) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
			Если Контрагент<>стр.Реализация.Контрагент и стр.Реализация.Контрагент<>Справочники.Контрагенты.НайтиПоКоду("94247") и //94247  разничный покупатель ДПД
				 Контрагент<>стр.Реализация.Контрагент и стр.Реализация.Контрагент<>Справочники.Контрагенты.НайтиПоКоду("П005342") тогда //подорожник  
				Сообщить("В строке: "+ стр.НомерСтроки+" Контрагент в реализации не равен контрагенту в заявке!!!");
				Отк =истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат отк;
КонецФункции
