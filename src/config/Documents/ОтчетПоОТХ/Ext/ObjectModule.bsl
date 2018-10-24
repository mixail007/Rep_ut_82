﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		//
		//Проверим оплату
		Запрос = новый Запрос;
		Запрос.Текст="ВЫБРАТЬ
		             |	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток
		             |ИЗ
		             |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(, Сделка = &ЗаказПокупателя) КАК ВзаиморасчетыСКонтрагентамиОстатки";
					 Запрос.УстановитьПараметр("ЗаказПокупателя",ДанныеЗаполнения.Ссылка);
					 Рез = Запрос.Выполнить().Выгрузить();
					 
					 Если Рез.Количество()=0 тогда
						 ВызватьИсключение("По "+ДанныеЗаполнения.Ссылка+" нет оплаты или реализация уже проведена. ");
						 Возврат;
					 ИначеЕсли рез[0].СуммаВзаиморасчетовОстаток>-ДанныеЗаполнения.Ссылка.СуммаДокумента тогда
						 ВызватьИсключение("По "+ДанныеЗаполнения.Ссылка+" сумма оплаты меньше суммы заказа.");
						 Возврат;
					 КонецЕсли;
		// Заполнение шапки
		Отчет = ОтчетОТХ(ДанныеЗаполнения.Ссылка);
		Если ЗначениеЗаполнено(Отчет) тогда
			//Сообщить("По "+ДанныеЗаполнения.Ссылка+" уже есть проведенный ОтчетПоОТХ: "+Отчет);
			ВызватьИсключение("По "+ДанныеЗаполнения.Ссылка+" уже есть проведенный ОтчетПоОТХ: "+Отчет);
			Возврат;
		КонецЕсли;
		 
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		Контрагент = Справочники.Точки.НайтиПоРеквизиту("Номер",(ДанныеЗаполнения.Ссылка.НомерТорговойТочкиКонтрагента)).Владелец; //Справочники.Контрагенты.НайтиПоКоду("П017979"); //Скрипченко К.В.
		ДатаС = ТекущаяДата();
		ДатаПо = ТекущаяДата();
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
		КонецЦикла;
		Дата = ТекущаяДата();
		Записать();
		РазобратьПоFIFO();
		СоздатьПакетДокументов();
	КонецЕсли;
КонецПроцедуры

Процедура РазобратьПоFIFO() экспорт
	товары.Свернуть("Номенклатура","Количество");	
	Скрипченко = Справочники.Контрагенты.НайтиПоКоду("П017979");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Табл.Номенклатура,
	|	Табл.количество
	|ПОМЕСТИТЬ ВТ_Таблица
	|ИЗ
	|	&Табл КАК Табл
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТоварыПереданныеОстатки.Сделка КАК Документ.ЗаказПокупателя) КАК Сделка,
	|	ТоварыПереданныеОстатки.Номенклатура,
	|	ТоварыПереданныеОстатки.КоличествоОстаток,
	|	ТоварыПереданныеОстатки.СуммаВзаиморасчетовОстаток
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.ТоварыПереданные.Остатки(
	|			&Дата,
	|			ДоговорКонтрагента.Владелец = &Контрагент
	|				И 99 = 99) КАК ТоварыПереданныеОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Таблица.Номенклатура КАК Номенклатура,
	|	ВТ_Таблица.количество КАК количество,
	|	ЕСТЬNULL(ВТ_Остатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(ВТ_Остатки.СуммаВзаиморасчетовОстаток, 0) КАК СуммаВзаиморасчетовОстаток,
	|	ЕСТЬNULL(ВТ_Остатки.Сделка, ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка)) КАК Сделка,
	|	ЕСТЬNULL(ВТ_Остатки.Сделка.ДоговорКонтрагента, ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК ДоговорКонтрагента,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(ЕСТЬNULL(РеализацияТоваровУслуг.Дата, ДАТАВРЕМЯ(1, 1, 1)), ДЕНЬ) < &ДатаС
	|			ТОГДА &ДатаС
	|		ИНАЧЕ НАЧАЛОПЕРИОДА(РеализацияТоваровУслуг.Дата, ДЕНЬ)
	|	КОНЕЦ КАК ДатаОтгрузки,
	|	ЕСТЬNULL(РеализацияТоваровУслуг.Номер, """") КАК НомерОтгрузки
	|ИЗ
	|	ВТ_Таблица КАК ВТ_Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|			ПО ВТ_Остатки.Сделка = РеализацияТоваровУслуг.Сделка
	|		ПО ВТ_Таблица.Номенклатура = ВТ_Остатки.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	ВТ_Остатки.Сделка.МоментВремени
	|ИТОГИ
	|	СРЕДНЕЕ(количество),
	|	СУММА(КоличествоОстаток),
	|	СУММА(СуммаВзаиморасчетовОстаток)
	|ПО
	|	Номенклатура";
	
	Запрос.УстановитьПараметр("Табл", Товары);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	Запрос.УстановитьПараметр("ДатаС", ДатаС);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ГоловноеПодразделение", Справочники.Подразделения.НайтиПоКоду("00005"));
	Если Контрагент = Скрипченко тогда
		Запрос.Текст=СтрЗаменить(Запрос.Текст,"99 = 99", "Сделка.Подразделение = &ГоловноеПодразделение");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	ВыборкаНоменклатура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		Если  выборкаНоменклатура.количество> ВыборкаНоменклатура.КоличествоОстаток тогда
			Сообщить("У контрагента остатка номенклатуры "+выборкаНоменклатура.Номенклатура.Код +" "+выборкаНоменклатура.Номенклатура +" на хранении не достаточно!");
			продолжить;
		конецЕсли;
		распределить= ВыборкаНоменклатура.Количество;
		Выборка = ВыборкаНоменклатура.Выбрать();
		
		Пока Выборка.Следующий() и Распределить>0 Цикл
			Строка = ТоварыПоЗаказам.Добавить();
			Строка.номенклатура = Выборка.номенклатура;
			строка.Заказ = Выборка.Сделка;
			строка.ДоговорКонтрагента = Выборка.ДоговорКонтрагента;
			строка.ДатаОтгрузки = Выборка.датаОтгрузки;
			строка.НомерОтгрузки = Выборка.НомерОтгрузки;

			если Распределить<Выборка.КоличествоОстаток тогда
				списать = Распределить;
				строка.количество = Списать;
			иначе
				списать = Выборка.КоличествоОстаток;
			конецЕсли;  
			распределить=распределить-списать;
			
			строка.количество = Списать;
			строка.Сумма = Списать*(выборка.СуммаВзаиморасчетовОстаток/выборка.КоличествоОстаток);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура СоздатьПакетДокументов(ДоговорРеализации = неопределено) экспорт
	ГоловноеПодразделение = Справочники.Подразделения.НайтиПоКоду("00005");
	
	если товары.итог("Количество")<> товарыПоЗаказам.итог("Количество") тогда
		Сообщить("Не все товары распределены по заказам");
	иначе
		
		//0. найдем или создадим Склад
		нужныйСклад = справочники.Склады.НайтиПоНаименованию(""+ СокрЛП(Контрагент.код)+" (ОТХ)");
		Если НужныйСклад = Справочники.Склады.ПустаяСсылка() тогда
			НужныйСклад = справочники.Склады.СоздатьЭлемент();
			НужныйСклад.Наименование =""+ СокрЛП(Контрагент.код)+" (ОТХ)";
			НужныйСклад.Комментарий = Контрагент.Наименование;
			НужныйСклад.ВидСклада = Перечисления.ВидыСкладов.Оптовый;
			НужныйСклад.Записать();
		конецЕсли;
		
		//1. Создаем возврат
		списокВозвратов = новый списокЗначений;
		Заказы = ТоварыПоЗаказам.Выгрузить(,"Заказ");
		Заказы.свернуть("Заказ");
		для каждого стр из Заказы цикл
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	РеализацияТоваровУслуг.Ссылка
			|ИЗ
			|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|ГДЕ
			|	РеализацияТоваровУслуг.Сделка = &Сделка";
			
			Запрос.УстановитьПараметр("Сделка", стр.Заказ);
			
			Результат = Запрос.Выполнить().Выгрузить();
			
			Строки = ТоварыПоЗаказам.НайтиСтроки(Новый структура("Заказ",стр.Заказ));
			ДокВозврат = Документы.ВозвратТоваровОтПокупателя.СоздатьДокумент();
			ДокВозврат.Заполнить(стр.Заказ);
			
			ДокВозврат.Подразделение = ГоловноеПодразделение;
			
			
			если стр.Заказ.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ПредоплатаПоСчетам тогда
				ДокВозврат.Дата = ТекущаяДата()-1;
			иначе
				ДокВозврат.Дата = ДатаС;
			конецесли;
            ДокВозврат.ВидПоступления = перечисления.ВидыПоступленияТоваров.НаСклад;
			
			СтрокаПрефикс = "ТК";
			Если ДокВозврат.Подразделение.ПрефиксИБ<>"" Тогда
				СтрокаПрефикс = ДокВозврат.подразделение.ПрефиксИБ;
			КонецЕсли;	
			ДокВозврат.УстановитьНовыйНомер(СтрокаПрефикс);	

			
			ДокВозврат.Товары.очистить();
			ДокВозврат.Комментарий = "Продажи по договору отх";
			Для каждого ст из Строки цикл
				с = ДокВозврат.Товары.Добавить();
				с.номенклатура = ст.номенклатура;
				с.количество = ст.количество;
				с.ЕдиницаИзмерения = ст.номенклатура.ЕдиницаХраненияОстатков;
				с.Коэффициент =1;
				с.Цена =  ст.Сумма/ст.Количество;
				с.СтавкаНДС = Перечисления.СтавкиНДС.БезНДС;
				с.Сумма = ст.Сумма;
				с.ДокументПартии = Результат[0].ссылка;
				с.Качество = справочники.Качество.Новый;
				с.склад = нужныйСклад.Ссылка;
			конецЦикла;
			списокВозвратов.Добавить(ДокВозврат);
		конецЦикла;
		//2.Создаем заказы
		
		списокЗаказов = Новый СписокЗначений;
		если ЗначениеЗаполнено(ДокументОснование)  тогда
			
			Заказ = ДокументОснование.ПолучитьОбъект();
			//Заказ.Проверен = Истина;
			//Заказ.записать(РежимЗаписиДокумента.Проведение);
			СписокЗаказов.Добавить(Заказ);
		иначе
			Договоры = ТоварыПоЗаказам.Выгрузить(,"ДоговорКонтрагента,ДатаОтгрузки");
			Договоры.свернуть("ДоговорКонтрагента,ДатаОтгрузки");
			
			
			Для каждого стр из Договоры Цикл
				// найдем или создадим нужный договор
				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	ДоговорыКонтрагентов.Ссылка
				|ИЗ
				|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
				|ГДЕ
				|	ДоговорыКонтрагентов.ОтветственноеЛицо = &ОтветственноеЛицо
				|	И ДоговорыКонтрагентов.ТипДоговора = &ТипДоговора
				|	И ДоговорыКонтрагентов.Владелец = &Владелец
				|	И 99 = 99";
				
				Если ДоговорРеализации<>неопределено тогда
					Запрос.УстановитьПараметр("Договор", ДоговорРеализации);
					Запрос.Текст=СтрЗаменить(Запрос.Текст,"99 = 99","ДоговорыКонтрагентов.Ссылка = &Договор");
				КонецЕсли;
				Запрос.УстановитьПараметр("ОтветственноеЛицо", стр.ДоговорКонтрагента.ОтветственноеЛицо);
				//11.09.18 Смирнов
				Запрос.УстановитьПараметр("Владелец", стр.ДоговорКонтрагента.Владелец);
				Запрос.УстановитьПараметр("ТипДоговора", Справочники.ТипыДоговоров.ОтсрочкаОТХ);
				
				Результат = Запрос.Выполнить();
				
				Если не результат.Пустой() тогда
					Выборка = Результат.Выбрать();
					Выборка.Следующий();
					нужныйДоговор = Выборка.ссылка;
				иначе
					новДог = стр.договорконтрагента.Скопировать();
					НовДог.Наименование = "Договор отсрочки ОТХ";
					НовДог.типДоговора = Справочники.ТипыДоговоров.ОтсрочкаОТХ;
					НовДог.Записать();
					нужныйДоговор = новДог.ссылка; 
				конецЕсли;
				
				Отбор = Новый структура;
				Отбор.Вставить("ДоговорКонтрагента",стр.ДоговорКонтрагента);
				Отбор.Вставить("ДатаОтгрузки",стр.ДатаОтгрузки);
				
				Строки = ТоварыПоЗаказам.НайтиСтроки(отбор);
				
				Заказ = Строки[0].Заказ.Скопировать();
				Заказ.Дата = ДатаС;
				
				Заказ.Подразделение = ГоловноеПодразделение;
				
				Заказ.РазрешитьГрузитьТоварыИзСтопЛиста = истина;
				
				СтрокаПрефикс = "ТК";
				Если Заказ.Подразделение.ПрефиксИБ<>"" Тогда
					СтрокаПрефикс = Заказ.подразделение.ПрефиксИБ;
				КонецЕсли;	
				Заказ.УстановитьНовыйНомер(СтрокаПрефикс);	
				
				//	 Заказ.Заполнить(ТаблицаНавозврат[0].Заказ);
				Заказ.ДоговорКонтрагента = НужныйДоговор;
				Заказ.ДатаОтгрузки = стр.ДатаОтгрузки;
				Заказ.ДатаОплаты = ДатаПо+7*24*60*60;
				Заказ.грузоотправитель = контрагент;
				Заказ.Товары.Очистить();
				Для каждого стр1 из строки цикл
					ст = Заказ.Товары.Добавить();
					ст.Номенклатура = стр1.номенклатура;
					ст.количество = стр1.количество;
					ст.ЕдиницаИзмерения = стр1.номенклатура.ЕдиницаХраненияОстатков;
					ст.Коэффициент =1;
					ст.Цена =  стр1.Сумма/стр1.Количество;
					ст.СтавкаНДС = Перечисления.СтавкиНДС.НДС18;
					ст.Сумма = стр1.Сумма;
				конецЦикла;
				//24.10.18 Смирнов, если 2 товара с разной ценой, то объединяем в 1 строчку со средней
				//Заказ.Товары.Свернуть("Номенклатура,ЕдиницаИзмерения,Коэффициент,Цена,СтавкаНДС","количество,Сумма");
				Заказ.Товары.Свернуть("Номенклатура,ЕдиницаИзмерения,Коэффициент,СтавкаНДС","количество,Сумма");
				
				Для каждого стрЗ из Заказ.Товары цикл
					стрЗ.Цена =  стрЗ.Сумма/стрЗ.Количество;
				КонецЦикла;

				
				
				///--------------------------------------------------
				СписокЗаказов.Добавить(Заказ);
			конецЦикла; 
		конецЕсли;
		
		начатьТранзакцию();
		
		Для каждого воз из  списокВозвратов цикл
			Док =Воз.Значение;  
			Док.Записать(РежимЗаписиДокумента.Проведение);
			
			нстрДоки = СформированныеДокументы.Добавить();
			нстрДоки.Документ = Док.Ссылка;
		конецЦикла;
		
		Для каждого зак из списокЗаказов цикл
			Заказ = Зак.Значение;
			
			Заказ.Проверен = Истина;
			Заказ.РазрешитьГрузитьТоварыИзСтопЛиста = истина;
			Заказ.Записать(РежимЗаписиДокумента.Проведение);
			
			нстрДоки = СформированныеДокументы.Добавить();
			нстрДоки.Документ = Заказ.Ссылка;
			
			//3. Создаем реализацию
			
			Реализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
			Реализация.Заполнить(Заказ.ссылка);
			
			если Заказ.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ПредоплатаПоСчетам тогда
				реализация.Дата = КонецДня(ТекущаяДата())-61;
			иначе
				Реализация.Дата = КонецДня(Заказ.ДатаОтгрузки)-61;
			конецесли;
			СтрокаПрефикс = "ТК";
			Если Реализация.Подразделение.ПрефиксИБ<>"" Тогда
				СтрокаПрефикс = Реализация.подразделение.ПрефиксИБ;
			КонецЕсли;	
			Реализация.УстановитьНовыйНомер(СтрокаПрефикс);	
			Реализация.грузоотправитель = контрагент;

			Реализация.Товары.Очистить();
			
			Для каждого стр из Заказ.ссылка.Товары Цикл
				нстр = Реализация.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(нстр, стр);
				нстр.СпособСписанияОстаткаТоваров = Перечисления.СпособыСписанияОстаткаТоваров.СоСклада;
				нстр.Склад = НужныйСклад.Ссылка;  
				нстр.Качество = справочники.Качество.Новый;
				
				РассчитатьСуммуТабЧасти(нстр, Реализация);
		        РассчитатьСуммуНДСТабЧасти(нстр, Реализация);
			КонецЦикла;
			
			//Для каждого стр из Реализация.Товары цикл
			//	стр.Склад = НужныйСклад.Ссылка;  
			//	стр.Качество = справочники.Качество.Новый;
			//конецЦикла;
			
			реализация.Записать(РежимЗаписиДокумента.Проведение);
			//реализация.Записать(РежимЗаписиДокумента.Запись);
			
			нстрДоки = СформированныеДокументы.Добавить();
			нстрДоки.Документ = реализация.Ссылка;

			
			Если ЗначениеЗаполнено(ДокументОснование) тогда
				Если Справочники.Точки.НайтиПоРеквизиту("Номер",(ДокументОснование.НомерТорговойТочкиКонтрагента)).Владелец.Код ="П017979" тогда
					//Обратимся в WS Формулы, что бы закрыть заказ и списать с ОТХ
					СписатьсОТХВФормуле();
				КонецЕсли;
			КонецЕсли;
			
		конецЦикла;
		
		ДокументыСформированы = Истина;
		
		Если ДокументыСформированы  тогда
			
			Записать(РежимЗаписиДокумента.Проведение);
			
			ЗафиксироватьТранзакцию();
			
			Если ЗначениеЗаполнено(ДокументОснование) тогда
				реализация.ПолучитьФорму("ФормаДокумента").Открыть();
			КонецЕсли;
		иначе
			ОтменитьТранзакцию();
		конецЕсли;		
	конецЕсли;
КонецПроцедуры

Процедура СписатьсОТХВФормуле()
	URL = "http://ServiceFormula";
	Прокси = WSссылки.WSFormula.СоздатьWSПрокси(URL, "ServiceFormula", "ServiceFormulaSoap12");
	
	Прокси.Пользователь = "FormulaAdmin";
	Прокси.Пароль = "3edcvfr4";
	
	Фабрика = Прокси.ФабрикаXDTO;
	
	тзРеал = ТоварыПоЗаказам.Выгрузить();
	тзРеал.Свернуть("ДатаОтгрузки,НомерОтгрузки");
	
	отбор = новый Структура("ДатаОтгрузки,НомерОтгрузки");
	
	КодСклада = 0;
		Если ДокументОснование.НомерТорговойТочкиКонтрагента = 7474 тогда //Мостецкая
			КодСклада = 2;
		ИначеЕсли ДокументОснование.НомерТорговойТочкиКонтрагента = 7475 тогда //Толбухина
			КодСклада = 3;
		ИначеЕсли ДокументОснование.НомерТорговойТочкиКонтрагента = 7476 тогда //Ленинградский
			КодСклада = 6;	
		ИначеЕсли ДокументОснование.НомерТорговойТочкиКонтрагента = 7479 тогда //Базовая
			КодСклада = 4;		
		КонецЕсли;
	
	Для каждого стр из тзРеал цикл
		МассивТовары = Фабрика.Создать(Фабрика.Тип("http://Formula", "ArrayOfProducts"));

		ЗаполнитьЗначенияСвойств(отбор, стр);
		НайденныеСтроки = ТоварыПоЗаказам.НайтиСтроки(отбор);
		
		Для каждого найденнаяСтрока из НайденныеСтроки цикл
			Товар = Фабрика.Создать(Фабрика.Тип("http://Formula", "Product"));
			Товар.Code.Добавить(прав(СокрЛП(найденнаяСтрока.Номенклатура.Код),7));
			Товар.Quantity.Добавить(найденнаяСтрока.Количество);
			Товар.Price = Окр(найденнаяСтрока.Сумма/найденнаяСтрока.Количество,0);
			Товар.Storage.Добавить(КодСклада);
			Товар.Point.Добавить(КодСклада);
			МассивТовары.Products.Добавить(Товар);
			зЗаказ = найденнаяСтрока.Заказ;
		КонецЦикла;
		
		Попытка
			дДата = стр.ДатаОтгрузки;
			//2015-08-01T00:00:00
			дДата = Формат(дДата,"ДФ=yyyy-MM-ddThh:mm:ss");
			Рез = Прокси.ReturnFromResponsibleStorage(МассивТовары, стр.НомерОтгрузки, дДата, зЗаказ.Номер, ""+ДокументОснование.КоординатыДоставки, "");
			Если Рез.Success = ложь тогда
				Комментарий = Комментарий+" # "+Рез.Error;
				GuidСтороннейОрганизации = Рез.OrderNumber;
				Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;		
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
		
КонецПроцедуры

Функция ОтчетОТХ(Заказ)
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ОтчетПоОТХ.Ссылка
	             |ИЗ
	             |	Документ.ОтчетПоОТХ КАК ОтчетПоОТХ
	             |ГДЕ
	             |	ОтчетПоОТХ.ДокументОснование = &ДокументОснование";
	Запрос.УстановитьПараметр("ДокументОснование", Заказ);
	Рез = Запрос.Выполнить().Выбрать();
	Пока Рез.Следующий() цикл
		Возврат Рез.Ссылка;
	КонецЦикла;
	
	Возврат Документы.ОтчетПоОТХ.ПустаяСсылка();
	
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	#Если Клиент Тогда
		Если ЗначениеЗаполнено(Менеджер) тогда
			Менеджер =  Параметрысеанса.ТекущийПользователь;
		конецЕсли;	
	#КонецЕсли
КонецПроцедуры

Процедура ОтправитьДоки() экспорт
	Для каждого стрДок из СформированныеДокументы цикл
		если ТипЗнч(стрДок.Документ) = Тип("ДокументСсылка.РеализацияТоваровУслуг") тогда
			текДок = стрДок.Документ;
			текДок.ПолучитьОбъект().ПеренестиДокиВБухгалтерию();
			
			//
			имя = "ТОРГ-12 (Яршинторг)";
			имяМакета = Справочники.ДополнительныеПечатныеФормы.НайтиПоНаименованию(имя);

			текДок.ПолучитьОбъект().Печать(имяМакета, 1, ложь);

			ТабДок = Новый ТабличныйДокумент();
			Попытка
				ТабДок.Прочитать(КаталогВременныхфайлов()+Ссылка.Номер+".mxl");
				табДок.АвтоМасштаб = Истина;
				Табдок.ОтображатьСетку = Ложь;
				ТабДок.ТолькоПросмотр = Истина;
				Макет = ПолучитьОбщийМакет("ШтрихКодДляУПД");
				ОбластьШтриха = Макет.ПолучитьОбласть("Штрих");
				Рисунок = ОбластьШтриха.Рисунки.Штрихкод;
				Тд = Новый ТабличныйДокумент;
				ОбШтрихКод=ОбластьШтриха.Рисунки.Штрихкод.Объект ;
				ОбШтрихКод.ТипКода = 4; 
				ОбШтрихКод.Сообщение = СформироватьШКРеализации(Ссылка,"8");//XMLСтрока(ЭтотОбъект.Ссылка.УникальныйИдентификатор()); 
				ОбШтрихКод.ОтображатьТекст = Ложь;
				
				Тд.Вывести(ОбластьШтриха);
				ТД.Вывести(ТабДок);
				ТД.Рисунки.D1.Верх = ТД.Рисунки.ШтрихКод.Верх;   
				ТД.Рисунки.D1.Лево = ТД.Рисунки.ШтрихКод.Лево;   
				тд.УдалитьОбласть(ТД.Область("Штрих"),ТипСмещенияТабличногоДокумента.ПоВертикали);   
				тд.АвтоМасштаб = Истина;
				Тд.ОтображатьСетку = Ложь;
				Тд.ТолькоПросмотр = Истина;
				тд.ОтображатьЗаголовки = ложь;   
				ТД.Показать();
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЦикла
КонецПроцедуры
