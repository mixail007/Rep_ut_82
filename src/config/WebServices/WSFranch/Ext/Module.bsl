﻿
Функция CreateMovement(Goods, WarehouseFrom, WarehouseTo, GuidYST, Comment)
	URL = "www.franch.yst";
	
	ТипXDTOРезультатОперации = ФабрикаXDTO.Тип(URL, "Result");
	РезультатОперации = ФабрикаXDTO.Создать(ТипXDTOРезультатОперации);
	
	Товары = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "ArrayOfProducts"));
	Ошибка = "";
	Success = истина;
	NumberYST = "";
	//GuidYST = "";
	
	ТаблицаЗаказа = Новый ТаблицаЗначений;
	ТаблицаЗаказа.Колонки.Добавить("НоменклатураКод");
	ТаблицаЗаказа.Колонки.Добавить("НоменклатураСпр");
	ТаблицаЗаказа.Колонки.Добавить("Количество");

	СкладОтправитель = Справочники.Склады.НайтиПоКоду(СокрЛП(WarehouseFrom));
	СкладПолучатель = Справочники.Склады.НайтиПоКоду(СокрЛП(WarehouseTo));
	
	Если не ЗначениеЗаполнено(СкладОтправитель) тогда
			Ошибка = "Не найден склад отправитель с кодом: "+WarehouseFrom;
	        Success = ложь;
	КонецЕсли;
		
	Если не ЗначениеЗаполнено(СкладПолучатель) тогда
			Ошибка = Ошибка+ Символы.ПС + "Не найден склад получатель с кодом: "+WarehouseTo;
	        Success = ложь;
	КонецЕсли;

	Если Success тогда
	
		//Товары
		Для каждого товар из Goods.Product цикл
			СтрокаТЗ = ТаблицаЗаказа.Добавить();
			СтрокаТЗ.НоменклатураКод = товар.Code;
			СтрокаТЗ.Количество =  Число(товар.Quantity);
			СтрокаТЗ.НоменклатураСпр=Справочники.Номенклатура.НайтиПоКоду(СтрокаТЗ.НоменклатураКод);
		КонецЦикла;
		
		Перемещение = ПолучитьПеремещение(GuidYST);
		//Перемещение  = Документы.ПеремещениеТоваров.СоздатьДокумент();
		Если Перемещение.ЭтоНовый() тогда
			Перемещение.Дата = ТекущаяДата();
		КонецЕсли;
		
		Перемещение.ВидОперации = Перечисления.ВидыОперацийПеремещениеТоваров.ТоварыПродукция;
		Перемещение.Организация = Справочники.Организации.НайтиПоКоду("00001");
		Перемещение.Подразделение = Справочники.Подразделения.НайтиПоКоду("00005");
		Перемещение.ОтражатьВБухгалтерскомУчете = истина;
		Перемещение.ОтражатьВНалоговомУчете = истина;
		Перемещение.ОтражатьВУправленческомУчете = истина;
		Перемещение.Комментарий = Comment;
		Перемещение.СкладОтправитель = СкладОтправитель;
		Перемещение.СкладПолучатель = СкладПолучатель;
		
		Перемещение.Товары.Очистить();
		
		Для каждого стр из ТаблицаЗаказа цикл
			нстр = Перемещение.Товары.Добавить();
			нстр.Номенклатура = стр.НоменклатураСпр;
			нстр.Количество = стр.Количество;
			нстр.Склад = СкладПолучатель;
			нстр.ЕдиницаИзмерения = нстр.Номенклатура.ЕдиницаХраненияОстатков;
			нстр.Коэффициент = нстр.ЕдиницаИзмерения.Коэффициент;
			нстр.СпособСписанияОстаткаТоваров = Перечисления.СпособыСписанияОстаткаТоваров.СоСклада;
		КонецЦикла;
		
		Попытка 
			//Перемещение.Записать(РежимЗаписиДокумента.Проведение);
			Перемещение.Записать(РежимЗаписиДокумента.Запись);
			NumberYST = Перемещение.Номер;
			GuidYST = "" + Перемещение.Ссылка.УникальныйИдентификатор();
		Исключение
			Success = ложь;
			Ошибка = Ошибка + Символы.ПС + ОписаниеОшибки();
		КонецПопытки;
	КонецЕсли;
	
	РезультатОперации.Success = Success;
	РезультатОперации.Error = Ошибка;
	РезультатОперации.NumberYST = NumberYST;
	РезультатОперации.GuidYST = GuidYST;
	
	Возврат РезультатОперации;
КонецФункции

Функция ПолучитьПеремещение(Guid)
	Если СокрЛП(Guid) <> "" тогда
		УИД = Новый УникальныйИдентификатор(СокрЛП(Guid));
		ПеремещениеСсылка = Документы.ПеремещениеТоваров.ПолучитьСсылку(УИД);
		
		Если (НЕ ПеремещениеСсылка = Документы.ПеремещениеТоваров.ПустаяСсылка()) И (НЕ ПеремещениеСсылка = Неопределено) Тогда
			Возврат ПеремещениеСсылка.ПолучитьОбъект();
		Иначе
			Возврат Документы.ПеремещениеТоваров.СоздатьДокумент();
		КонецЕсли;
	КонецЕсли;
	Возврат Документы.ПеремещениеТоваров.СоздатьДокумент();
КонецФункции

Функция ПолучитьРеализацию(Guid)
	Если СокрЛП(Guid) <> "" тогда
		УИД = Новый УникальныйИдентификатор(СокрЛП(Guid));
		РеализацияСсылка = Документы.РеализацияТоваровУслуг.ПолучитьСсылку(УИД);
		
		Если (НЕ РеализацияСсылка = Документы.РеализацияТоваровУслуг.ПустаяСсылка()) И (НЕ РеализацияСсылка = Неопределено) Тогда
			Возврат РеализацияСсылка.ПолучитьОбъект();
		Иначе
			Возврат Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		КонецЕсли;
	КонецЕсли;
	Возврат Документы.РеализацияТоваровУслуг.СоздатьДокумент();
КонецФункции


Функция ПолучитьСкладПоГуид(Guid)
	 Если СокрЛП(Guid) <> "" тогда
		УИД = Новый УникальныйИдентификатор(СокрЛП(Guid));
		Склад = Справочники.Склады.ПолучитьСсылку(УИД);
		
		Если (НЕ Склад = Справочники.Склады.ПустаяСсылка()) И (НЕ Склад = Неопределено) Тогда
			Возврат Склад;
		Иначе
			Возврат Справочники.Склады.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	Возврат Справочники.Склады.ПустаяСсылка();
КонецФункции

Функция GetAct(Partner, DateFrom, DateTo)
	ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоКоду(44);
	ИмяФайла = ПолучитьИмяВременногоФайла(); 
	ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
	ДвоичныеДанные.Записать(ИмяФайла); 
	Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
		Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
	Иначе 
		Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
	КонецЕсли;
	
	
	Контрагент = Справочники.Контрагенты.НайтиПоКоду(Partner);
	СписокДоговоров = ПолучитьДоговоры(Контрагент);
	
	ТабДок = Обработка.ПолучитьАкт(Контрагент, Справочники.Организации.НайтиПоКоду("00001"), Дата(DateFrom), КонецДня(Дата(DateTo)), ложь, ложь, СписокДоговоров);
	
	
	ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
	ТабДок.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.MXL);
	ДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
	
	возврат ДанныеФайла;
КонецФункции

Функция ПолучитьДоговоры(Контрагент)
	СписокДоговоров = Новый СписокЗначений;
	
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ДоговорыКонтрагентов.Ссылка КАК Договор
	             |ИЗ
	             |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	             |ГДЕ
	             |	ДоговорыКонтрагентов.Владелец = &Владелец
	             |	И НЕ ДоговорыКонтрагентов.Наименование ПОДОБНО ""%*%""";
	Запрос.УстановитьПараметр("Владелец", Контрагент);
	
	Рез = Запрос.Выполнить().Выбрать();
	Пока рез.Следующий() Цикл
		СписокДоговоров.Добавить(Рез.Договор,Рез.Договор);
	КонецЦикла;
	
	Возврат СписокДоговоров;
КонецФункции

Функция CreateSalesDocs(PointId, Partner, Goods, Receipts, GuidYST, IsKTOrder)
	URL = "www.franch.yst";
	
	ТипXDTOРезультатОперации = ФабрикаXDTO.Тип(URL, "Result");
	ТипXDTOТовары = ФабрикаXDTO.Тип(URL, "ArrayOfProducts");
	Товары = ФабрикаXDTO.Создать(ТипXDTOТовары);
	РезультатОперации = ФабрикаXDTO.Создать(ТипXDTOРезультатОперации);
	
	Ошибка    = "";
	Success   = Истина;
	OrderNumber = "";
	OrderGUID = "";
	
	Контрагент = Справочники.Контрагенты.НайтиПоКоду(Partner);
	Если Контрагент = Справочники.Контрагенты.ПустаяСсылка() Тогда
		Success = Ложь;
		Ошибка = "Не удалось найти контрагента";
	КонецЕсли;
	Если Контрагент.ЗапретитьВводЗаказаПокупателя или Контрагент.ЗапретОтгрузки Тогда
		Success = Ложь;
		Ошибка = "Вам запрещено создавать заказы!";
	КонецЕсли;
		
	СпрТочка = Справочники.Точки.НайтиПоРеквизиту("Номер", PointId,,Контрагент);
	
	Набор = РегистрыСведений.СоответствиеКонтрагентовСкладамФРан.СоздатьНаборЗаписей();
	Набор.Отбор.Контрагент.Установить(Контрагент);
	Набор.Отбор.Точка.Установить(СпрТочка);
	Набор.Прочитать();
	
	если Набор.Количество()>0 Тогда
		СкладФР = Набор[0].Склад;
		ДоговорРеализация = ?(IsKTOrder, Набор[0].ДоговорПродажиKolesaTyt, Набор[0].ДоговорПродажи);
		Грузоотправитель = Контрагент;
	Иначе
		СкладФР = Справочники.Склады.ПустаяСсылка();
		ДоговорРеализация = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		Грузоотправитель = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
		
	ТаблицаЗаказа = Новый ТаблицаЗначений;
	ТаблицаЗаказа.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("Строка"	, , Новый КвалификаторыСтроки(200)));
	ТаблицаЗаказа.Колонки.Добавить("НоменклатураСпр",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаЗаказа.Колонки.Добавить("Количество",Новый ОписаниеТипов("Число"));
	ТаблицаЗаказа.Колонки.Добавить("Цена",Новый ОписаниеТипов("Число"));
	
	
	Для каждого Запись из Goods.Product цикл	
		СтрокаТЗ = ТаблицаЗаказа.Добавить();
		СтрокаТЗ.Номенклатура = Запись.Code;
		СтрокаТЗ.Количество = Число(Запись.Quantity);
		//СтрокаТЗ.НоменклатураСпр=Справочники.Номенклатура.НайтиПоКоду(СтрокаТЗ.Номенклатура);
		СтрокаТЗ.Цена =  Число(Запись.Price);	
	КонецЦикла;

	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	тзТаб.Номенклатура,
	             |	тзТаб.Количество,
	             |	тзТаб.Цена
	             |ПОМЕСТИТЬ втТаб
	             |ИЗ
	             |	&тзТаб КАК тзТаб
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	втТаб.Номенклатура,
	             |	втТаб.Количество,
	             |	втТаб.Цена,
	             |	ЕСТЬNULL(СпрНоменклатура.Ссылка, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураСпр,
	             |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 55555) КАК ЦенаB2B
	             |ИЗ
	             |	втТаб КАК втТаб
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	             |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ПериодЦены, ТипЦен = &B2B) КАК ЦеныНоменклатурыСрезПоследних
	             |			ПО СпрНоменклатура.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура
	             |		ПО втТаб.Номенклатура = СпрНоменклатура.Код";
				 Запрос.УстановитьПараметр("тзТаб",ТаблицаЗаказа);
				 Запрос.УстановитьПараметр("ПериодЦены",ТекущаяДата());
				 Запрос.УстановитьПараметр("B2B",Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00032"));
				 
				 
	            ТаблицаЗаказаB2B = Запрос.Выполнить().Выгрузить();
	
	//Создание заказа(ов)
	Если Success Тогда
		
		ПодразделениеЗаказа = Справочники.Подразделения.НайтиПоКоду("00005");
		
		
		//Реализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		Реализация = ПолучитьРеализацию(GuidYST);
		
		Если Реализация.ЭтоНовый() тогда
			Реализация.Дата = ТекущаяДата();
		КонецЕсли;

		Реализация.Организация = Справочники.Организации.НайтиПоКоду("00001");
			
		Реализация.ТипЦен = Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00005"); //Крупный опт
		Реализация.ВалютаДокумента = Справочники.Валюты.НайтиПоКоду("643");
		Реализация.КурсВзаиморасчетов = 1;
		Реализация.КратностьВзаиморасчетов = 1;
		
		Реализация.Контрагент = Контрагент;
		Реализация.Подразделение = ПодразделениеЗаказа;					
		Реализация.Грузоотправитель = Грузоотправитель;
		
		Реализация.Ответственный = Справочники.Пользователи.НайтиПоКоду("Робот (центр - номенклатура)");
		Реализация.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.ПродажаКомиссия;
		Реализация.Комментарий = "Создана автоматически по продажам франчайзи";
		
	
		Реализация.СуммаВключаетНДС = Истина;
		Реализация.УчитыватьНДС	   = Истина;		
		
		Реализация.ДоговорКонтрагента = ДоговорРеализация;
		Реализация.ОтражатьВУправленческомУчете = Истина;
		Реализация.ВидПередачи = Перечисления.ВидыПередачиТоваров.СоСклада;
		//+++)
		
				
		Реализация.Склад = СкладФР;
		
		Для каждого Стр ИЗ ТаблицаЗаказаB2B Цикл
			СтрокаТовары = Реализация.Товары.Добавить();
			СтрокаТовары.Номенклатура = Стр.НоменклатураСпр;
			СтрокаТовары.Коэффициент = 1;
			СтрокаТовары.Количество = Стр.Количество;
			ЗаполнитьЕдиницуЦенуПродажиТабЧасти(СтрокаТовары, Реализация, Константы.ВалютаРегламентированногоУчета.Получить()); 
			ЗаполнитьСтавкуНДСТабЧасти(СтрокаТовары, Реализация);
			
			Если Partner = "П017979" тогда  //ИП Скрипченко
				СтрокаТовары.Цена = Стр.Цена;
			иначе
				СтрокаТовары.Цена = Стр.ЦенаB2B;
			КонецЕсли;
			
			РассчитатьСуммуТабЧасти(СтрокаТовары, Реализация);
			РассчитатьСуммуНДСТабЧасти(СтрокаТовары, Реализация);
			
			Товар = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "Product"));
			Товар.Code=(Строка(Стр.Номенклатура));
			Товар.Quantity=(Число(Стр.Количество));
			
			Если Partner = "П017979" тогда //ИП Скрипченко
				Товар.Price = Стр.Цена;
			иначе	
				Товар.Price=Число(Стр.ЦенаB2B);
			КонецЕсли;
			
			Товары.Product.Добавить(Товар);

		КонецЦикла;
		
		Для каждого Запись из Receipts.Receipt цикл	
			Нстр = Реализация.ДокументыКонтрагентов.Добавить();
			Нстр.Номер = Запись.Number;
			Нстр.GUID = Запись.GUID;
		КонецЦикла;
		
		Реализация.УстановитьНовыйНомер("ТК");
		Реализация.Записать(РежимЗаписиДокумента.Запись);
		
		Если Реализация.Товары.Количество() <> 0 Тогда
			Попытка 
			    Реализация.Записать(РежимЗаписиДокумента.Проведение);
				//Реализация.Записать(РежимЗаписиДокумента.Запись);
			Исключение
				//Реализация.Записать(РежимЗаписиДокумента.Запись);
				Ошибка = Ошибка + Символы.ПС+ОписаниеОшибки();
				Success = ложь;
			КонецПопытки;
			
			OrderGUID = Строка(Реализация.Ссылка.УникальныйИдентификатор());
			OrderNumber = СокрЛП(Реализация.Номер);
		КонецЕсли;  //товары есть
	КонецЕсли;
	
	РезультатОперации.Success		 = Success;
	РезультатОперации.Error			 = Ошибка;
	РезультатОперации.Products       = Товары;
	РезультатОперации.NumberYST		 = OrderNumber;
	РезультатОперации.GuidYST	     = OrderGUID;
	
	Возврат РезультатОперации;	

КонецФункции

Функция GetB2BPrices()
	URL = "www.franch.yst";
	
	Товары = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "ArrayOfProducts"));
	
	
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура.Код КАК Код,
	             |	ЦеныНоменклатурыСрезПоследних.Цена
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |			,
	             |			ТипЦен = &ТипB2B
	             |				И Валюта = &Валюта) КАК ЦеныНоменклатурыСрезПоследних";
	Запрос.УстановитьПараметр("ТипB2B", Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00032")); //Цена B2B Базовая
	Запрос.УстановитьПараметр("Валюта",Справочники.Валюты.НайтиПоКоду("643")); //руб.
	Рез = Запрос.Выполнить().Выбрать();
	
	Пока Рез.Следующий() Цикл
		Товар = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "Product"));
		Товар.Code=Рез.Код;
		Товар.Price=Рез.Цена;
		Товар.Quantity = 0;
		
		Товары.Product.Добавить(Товар);
		
	КонецЦикла;
	
	Возврат Товары;
КонецФункции
