﻿
Функция CreateSupplierOrder(Partner, Goods, Comment, DocNumber)
	Success = истина;
	Ошибка = "";
	
	URL = "www.yst.ru/ist";
	
	ТипXDTOРезультатОперации = ФабрикаXDTO.Тип(URL, "Result");
	РезультатОперации = ФабрикаXDTO.Создать(ТипXDTOРезультатОперации);
	
	
	Контрагент = Справочники.Контрагенты.НайтиПоКоду(СокрЛП(Partner));
	
	Если не ЗначениеЗаполнено(Контрагент) тогда
		Success = ложь;
		Ошибка = Ошибка+"Не найден контрагент с кодом "+СокрЛП(Partner)+"."; 
	КонецЕсли;
	
	Если Success тогда
		ДоговорПоставки = ПолучитьДоговорПоставки(Контрагент);
    КонецЕсли;

	Если не ЗначениеЗаполнено(ДоговорПоставки) тогда
		Success = ложь;
		Ошибка = Ошибка+"Не найден договор поставки."; 
	КонецЕсли;
	
	Если СокрЛП(DocNumber)="" тогда
		Success = ложь;
		Ошибка = Ошибка+Символы.ПС+"Не указан номер входящего документа.";
	КонецЕсли;
	
	//Поищем заказ по номеру входящего документа, который равен номеру заказа покупателя в базе ИСТ
	Если Success тогда
		ЗаказПоставщикуСсылка = НайтиЗаказПоставщику(Контрагент,СокрЛП(DocNumber));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаказПоставщикуСсылка) тогда
		ЗаказПоставщикуОб = ЗаказПоставщикуСсылка.ПолучитьОбъект();
	Иначе
		ЗаказПоставщикуОб = Документы.ЗаказПоставщику.СоздатьДокумент();
		
		ЗаказПоставщикуОб.Дата = ТекущаяДата();
		ЗаказПоставщикуОб.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643");
		ЗаказПоставщикуОб.Контрагент  = Контрагент;
		
		ДнейОтсрочки = ?(ДоговорПоставки.ДопустимоеЧислоДнейЗадолженности=0, 30, ДоговорПоставки.ДопустимоеЧислоДнейЗадолженности);
		
		ЗаказПоставщикуОб.ДатаПоступления = ТекущаяДата();
		ЗаказПоставщикуОб.ДатаОплаты = ТекущаяДата() + 24*60*60*ДнейОтсрочки;
		ЗаказПоставщикуОб.ДоговорКонтрагента = ДоговорПоставки;
		ЗаказПоставщикуОб.Комментарий = "##Создан автоматически "+ СокрЛП(Comment);
		ЗаказПоставщикуОб.КратностьВзаиморасчетов  = 1;
		ЗаказПоставщикуОб.КурсВзаиморасчетов = 1;
		ЗаказПоставщикуОб.НомерВходящегоДокумента = СокрЛП(DocNumber);
		ЗаказПоставщикуОб.Организация = Справочники.Организации.НайтиПоКоду("00001");
		ЗаказПоставщикуОб.Подразделение = Справочники.Подразделения.НайтиПоКоду("00005");
		ЗаказПоставщикуОб.УчитыватьНДС = истина;
		ЗаказПоставщикуОб.СуммаВключаетНДС = истина;
		
		
		ТаблицаЗаказа = Новый ТаблицаЗначений;
		ТаблицаЗаказа.Колонки.Добавить("Номенклатура");
		ТаблицаЗаказа.Колонки.Добавить("НоменклатураСпр");
		ТаблицаЗаказа.Колонки.Добавить("Количество");
		ТаблицаЗаказа.Колонки.Добавить("Цена");
		
		Для каждого товар из Goods.Product цикл
			СтрокаТЗ = ТаблицаЗаказа.Добавить();
			СтрокаТЗ.Номенклатура = СокрЛП(товар.Code);
			СтрокаТЗ.Количество =  Число(товар.Quantity);
			СтрокаТЗ.НоменклатураСпр=Справочники.Номенклатура.НайтиПоКоду(СтрокаТЗ.Номенклатура);
			
			Если не ЗначениеЗаполнено(СтрокаТЗ.НоменклатураСпр) тогда
				Success = ложь;
				Ошибка = Ошибка+Символы.ПС+"Не найдена номенклатура с кодом: "+СокрЛП(товар.Code);
			КонецЕсли;
			
			СтрокаТЗ.Цена =  Число(товар.Price);
		КонецЦикла;
		
		СписокНом = ТаблицаЗаказа.ВыгрузитьКолонку("НоменклатураСпр");
		ТабОстатковЗаказовПоставщиков = ПолучитьЗаказы(СписокНом, Контрагент);
		
		ЗаказПоставщикуОб.Основание = ПолучитьСезонныйЗаказ(Контрагент, ДоговорПоставки);
		
		Если Success тогда
			отбор = новый структура("Номенклатура");
			для каждого стр из  ТаблицаЗаказа цикл
				отбор.Номенклатура = стр.НоменклатураСпр;
				найденныеСтроки = ТабОстатковЗаказовПоставщиков.найтиСтроки(отбор);
				ОсталосьДобавить = стр.Количество;
				Для каждого НайденнаяСтрока из найденныеСтроки цикл
					Добавляем = мин(стр.Количество,НайденнаяСтрока.КоличествоОстаток);
					нстр = ЗаказПоставщикуОб.Товары.Добавить();
					нстр.Номенклатура = стр.НоменклатураСпр;
					нстр.Количество = Добавляем;
					нстр.Цена = стр.цена;
					нстр.СтавкаНДС = Перечисления.СтавкиНДС.НДС18;
					нстр.ЕдиницаИзмерения = нстр.Номенклатура.ЕдиницаХраненияОстатков;
					нстр.Основание = НайденнаяСтрока.ЗаказПоставщику; //Заказ поставщику "большой", с которого списываются заказы
					
					ПриИзмененииНоменклатурыТабЧасти(нстр, ЗаказПоставщикуОб);
					
					// Рассчитываем реквизиты табличной части.
					РассчитатьСуммуТабЧасти(нстр, ЗаказПоставщикуОб);
					РассчитатьСуммуНДСТабЧасти(нстр, ЗаказПоставщикуОб);
					
					ОсталосьДобавить = ОсталосьДобавить - Добавляем;
					Если ОсталосьДобавить <= 0 тогда
						прервать;
					КонецЕсли;	
				КонецЦикла;	
				
				Если ОсталосьДобавить>0 тогда
					нстр = ЗаказПоставщикуОб.Товары.Добавить();
					нстр.Номенклатура = стр.НоменклатураСпр;
					нстр.Количество = ОсталосьДобавить;
					нстр.Цена = стр.цена;
					нстр.СтавкаНДС = Перечисления.СтавкиНДС.НДС18;
					нстр.ЕдиницаИзмерения = нстр.Номенклатура.ЕдиницаХраненияОстатков;
					нстр.Основание = документы.ЗаказПоставщику.ПустаяСсылка(); 
					
					ПриИзмененииНоменклатурыТабЧасти(нстр, ЗаказПоставщикуОб);
					
					// Рассчитываем реквизиты табличной части.
					РассчитатьСуммуТабЧасти(нстр, ЗаказПоставщикуОб);
					РассчитатьСуммуНДСТабЧасти(нстр, ЗаказПоставщикуОб);

				КонецЕсли;
				
				//нстр = ЗаказПоставщикуОб.Товары.Добавить();
				//нстр.Номенклатура = стр.НоменклатураСпр;
				//нстр.Количество = стр.Количество;
				//нстр.Цена = стр.цена;
				//нстр.СтавкаНДС = Перечисления.СтавкиНДС.НДС18;
				//нстр.ЕдиницаИзмерения = нстр.Номенклатура.ЕдиницаХраненияОстатков;
				//нстр.Основание = Документы.ЗаказПоставщику.ПустаяСсылка(); //Заказ поставщику "большой", с которого списываются заказы
				//ПриИзмененииНоменклатурыТабЧасти(нстр, ЗаказПоставщикуОб);
				//
				//// Рассчитываем реквизиты табличной части.
				//РассчитатьСуммуТабЧасти(нстр, ЗаказПоставщикуОб);
				//РассчитатьСуммуНДСТабЧасти(нстр, ЗаказПоставщикуОб);
			КонецЦикла;
			
			попытка
				ЗаказПоставщикуОб.Записать(РежимЗаписиДокумента.Проведение);
				//ЗаказПоставщикуОб.Записать(РежимЗаписиДокумента.Запись);
				ЗаказПоставщикуСсылка = ЗаказПоставщикуОб.Ссылка;
				Номер = ЗаказПоставщикуОб.Номер;
			исключение
				Success = ложь;
				Ошибка = Ошибка + Символы.ПС+ОписаниеОшибки();
				ЗаказПоставщикуСсылка = Документы.ЗаказПоставщику.ПустаяСсылка();
				Номер = "";
			КонецПопытки;
			
			Если Success тогда
				//Создадим задачу / отправим письмо
				Попытка
					Задача = Задачи.ЗадачиПользователя.СоздатьЗадачу();
					Задача.Дата = ТекущаяДата();
					Задача.Исполнитель = ЗаказПоставщикуОб.ДоговорКонтрагента.ОтветственноеЛицо;
					Задача.Наименование  = "Создан " + ЗаказПоставщикуСсылка + "от поставщика "+ЗаказПоставщикуОб.Контрагент;
					Задача.Описание = "Создан " + ЗаказПоставщикуСсылка + "от поставщика "+ЗаказПоставщикуОб.Контрагент;
					Задача.Оповещение  = истина;
					Задача.Объект = ЗаказПоставщикуСсылка;
					Задача.Записать();
					//письмо
					АдресПолучателя="200200140@yst.ru";
					УЗ = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоКоду("00011");//1c@yst.ru
					СписокФайловВложений=Новый СписокЗначений;
					ТекстСообщения = "Создан заказ поставщику" + Символы.ПС + ЗаказПоставщикуСсылка;
					Тема = "Создан заказ поставщику "+ЗаказПоставщикуОб.Контрагент;  
					//яштРезервыПоТоварам.ПослатьЭлектронноеПисьмо(АдресПолучателя,СписокФайловВложений, УЗ, ТекстСообщения, Тема);
				исключение
			        
					Ошибка = Ошибка + Символы.ПС+ОписаниеОшибки();
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РезультатОперации.Success		 = Success;
	РезультатОперации.OrderNumber	 = Номер;
	РезультатОперации.Order		     = ""+ЗаказПоставщикуСсылка;
	РезультатОперации.Error			 = Ошибка;
	
	Возврат РезультатОперации;
КонецФункции

Функция ПолучитьЗаказы(СписокНоменклатуры, Контрагент)
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику КАК ЗаказПоставщику,
	             |	ЗаказыПоставщикамОстатки.Номенклатура,
	             |	ЗаказыПоставщикамОстатки.КоличествоОстаток
	             |ИЗ
	             |	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	             |			,
	             |			ДоговорКонтрагента.Владелец = &ИСТ
	             |				И Номенклатура В (&СписокНоменклатуры)
	             |				И НЕ ЗаказПоставщику.Комментарий ПОДОБНО ""%##Создан автоматически%""
	             |				И НЕ ЗаказПоставщику.Комментарий ПОДОБНО ""%#Заказ покупателя"") КАК ЗаказыПоставщикамОстатки
	             |ГДЕ
	             |	ЗаказыПоставщикамОстатки.КоличествоОстаток > 0
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	ЗаказПоставщику
	             |АВТОУПОРЯДОЧИВАНИЕ";
				 Запрос.УстановитьПараметр("ИСТ",Контрагент);
				 Запрос.УстановитьПараметр("СписокНоменклатуры",СписокНоменклатуры);
				 
				 рез = Запрос.Выполнить().Выгрузить();
				 Возврат рез;
КонецФункции

Функция ПолучитьСезонныйЗаказ(Контрагент,Договор)
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ЗаказПоставщикуСезонный.Ссылка КАК СезонныйЗаказПоставщику
	             |ИЗ
	             |	Документ.ЗаказПоставщикуСезонный КАК ЗаказПоставщикуСезонный
	             |ГДЕ
	             |	ЗаказПоставщикуСезонный.Проведен
	             |	И ЗаказПоставщикуСезонный.Контрагент = &Контрагент
	             |	И ЗаказПоставщикуСезонный.ДоговорКонтрагента = &ДоговорКонтрагента
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	ЗаказПоставщикуСезонный.Дата УБЫВ
	             |АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента",Договор);
	
	Рез = Запрос.Выполнить().Выбрать();
	
	Пока Рез.Следующий() Цикл
		возврат рез.СезонныйЗаказПоставщику;
	КонецЦикла;
	
	Возврат Документы.ЗаказПоставщикуСезонный.ПустаяСсылка();
	
КонецФункции

Функция ПолучитьДоговорПоставки(Контрагент)
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ДоговорыКонтрагентов.Ссылка КАК ДоговорКонтрагента
	             |ИЗ
	             |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	             |ГДЕ
	             |	ДоговорыКонтрагентов.Владелец = &Владелец
	             |	И ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ
	             |	И ДоговорыКонтрагентов.Организация = &Организация
	             |	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
	             |	И ДоговорыКонтрагентов.ТипДоговора = &ТипДоговора
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	ДоговорыКонтрагентов.Номер УБЫВ
	             |АВТОУПОРЯДОЧИВАНИЕ";
				 Запрос.УстановитьПараметр("Владелец",Контрагент);
				 Запрос.УстановитьПараметр("Организация",Справочники.Организации.НайтиПоКоду("00001"));
				 Запрос.УстановитьПараметр("ВидДоговора",Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
				 Запрос.УстановитьПараметр("ТипДоговора",Справочники.ТипыДоговоров.НайтиПоКоду("00027")); //поставка

				 Рез = Запрос.Выполнить().Выбрать();
				 
				 Пока Рез.Следующий() Цикл
					 Возврат Рез.ДоговорКонтрагента
				 КонецЦикла;
				 
				 Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
КонецФункции

Функция НайтиЗаказПоставщику(Контрагент,НомерВходящегоДокумента)
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
	               |ИЗ
	               |	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	               |ГДЕ
	               |	ЗаказПоставщику.Контрагент = &Контрагент
	               |	И ЗаказПоставщику.НомерВходящегоДокумента = &НомерВходящегоДокумента
	               |	И ЗаказПоставщику.Дата МЕЖДУ &ДатаН И &ДатаК";
				   Запрос.УстановитьПараметр("Контрагент",Контрагент);
				   Запрос.УстановитьПараметр("НомерВходящегоДокумента",СокрЛП(НомерВходящегоДокумента));
				   Запрос.УстановитьПараметр("ДатаН",началоГода(ТекущаяДата()));
				   Запрос.УстановитьПараметр("ДатаК",КонецГода(ТекущаяДата()));
				   
				   Рез = Запрос.Выполнить().Выбрать();
				   
				   Пока Рез.Следующий() Цикл
					   возврат Рез.ЗаказПоставщику;
				   КонецЦикла;

				   Возврат Документы.ЗаказПоставщику.ПустаяСсылка();
КонецФункции

Функция CreateApplicationForTransport(IsReverse, Address, weight = 0, volume = 0, DeliveryDateFrom, DeliveryDateOn)
	Success = истина;
	Ошибка = "";
	
	URL = "www.yst.ru/ist";
	
	ТипXDTOРезультатОперации = ФабрикаXDTO.Тип(URL, "Result");
	РезультатОперации = ФабрикаXDTO.Создать(ТипXDTOРезультатОперации);

	
	Если СокрЛП(Address) = "" тогда
		Success = ложь;
		Ошибка = "Адрес пустой";
	КонецЕсли;
	
	Если Success тогда
		ЗаявкаНаТранспорт = Документы.ЗаявкаНаТранспорт.СоздатьДокумент();
		ЗаявкаНаТранспорт.Дата = ТекущаяДата();
		ЗаявкаНаТранспорт.Вес = weight;
		ЗаявкаНаТранспорт.Объем  = volume;
		ЗаявкаНаТранспорт.Подразделение = Справочники.Подразделения.НайтиПоКоду("00192"); //ист
		ЗаявкаНаТранспорт.Контрагент = Справочники.Контрагенты.НайтиПоКоду("94072"); //ИСТ
		ЗаявкаНаТранспорт.Обратка  = IsReverse;
		ЗаявкаНаТранспорт.ДатаДоставкиС = Дата(DeliveryDateFrom);
		ЗаявкаНаТранспорт.ДатаДоставкиПо = Дата(DeliveryDateOn);
		ЗаявкаНаТранспорт.Адрес = СокрЛП(Address);
		
		нстр = ЗаявкаНаТранспорт.Точки.Добавить();
		нстр.ТочкаМаршрута = "";
		
		ЗаявкаНаТранспорт.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	РезультатОперации.Success		 = Success;
	РезультатОперации.OrderNumber	 = ЗаявкаНаТранспорт.Номер;
	РезультатОперации.Order		     = ""+ЗаявкаНаТранспорт.Ссылка.УникальныйИдентификатор();
	РезультатОперации.Error			 = Ошибка;
	
	Возврат РезультатОперации;
КонецФункции
