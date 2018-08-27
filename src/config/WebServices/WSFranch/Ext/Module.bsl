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
			Перемещение.Записать(РежимЗаписиДокумента.Проведение);
			//Перемещение.Записать(РежимЗаписиДокумента.Запись);
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

Функция ПолучитьОтчетПоОТХ(Guid)
	Если СокрЛП(Guid) <> "" тогда
		УИД = Новый УникальныйИдентификатор(СокрЛП(Guid));
		ОтчетПоОТХСсылка = Документы.ОтчетПоОТХ.ПолучитьСсылку(УИД);
		
		Если (НЕ ОтчетПоОТХСсылка = Документы.ОтчетПоОТХ.ПустаяСсылка()) И (НЕ ОтчетПоОТХСсылка = Неопределено) Тогда
			Возврат ОтчетПоОТХСсылка.ПолучитьОбъект();
		Иначе
			Возврат Документы.ОтчетПоОТХ.СоздатьДокумент();
		КонецЕсли;
	КонецЕсли;
	Возврат Документы.ОтчетПоОТХ.СоздатьДокумент();
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

Функция CreateSalesDocs(PointId, Partner, Goods, Receipts, GuidYST, IsKTOrder, DateFrom, DateTo)
	
	Если СокрЛП(DateFrom)<>"" тогда
		РезультатОперации = СформироватьРеализации(Partner, Goods, Receipts, GuidYST, IsKTOrder, DateFrom, DateTo); //Схема - Заказ - Реализация - Возврат - реализация
	Иначе
		РезультатОперации = СформироватьРеализацииПоСхемеПеремещений(PointId, Partner, Goods, Receipts, GuidYST, IsKTOrder); //старая схема Заказ - перемещение - реализация
	КонецЕсли;
	
	Возврат РезультатОперации;	

КонецФункции

Функция СформироватьРеализации(Partner, Goods, Receipts, GuidYST, IsKTOrder, DateFrom, DateTo)
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
	
	ОтчетПоОТХ = ПолучитьОтчетПоОТХ(GuidYST);
	Если ОтчетПоОТХ.ДокументыСформированы тогда
		Success = Ложь;
		Ошибка = "По данному отчету ОТХ уже сформированы документы!";
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
	             |	ЕСТЬNULL(СпрНоменклатура.Ссылка, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураСпр
	             |ИЗ
	             |	втТаб КАК втТаб
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	             |		ПО втТаб.Номенклатура = СпрНоменклатура.Код";
	Запрос.УстановитьПараметр("тзТаб",ТаблицаЗаказа);
	
	ТаблицаЗаказа = Запрос.Выполнить().Выгрузить();
	
	Если Success Тогда
		
		Если ОтчетПоОТХ.ЭтоНовый() тогда
			ОтчетПоОТХ.Дата = НачалоДня(ТекущаяДата())-600;
		КонецЕсли;
		
		ОтчетПоОТХ.Контрагент = Контрагент;
		ОтчетПоОТХ.ДатаС = Дата(DateFrom);
		ОтчетПоОТХ.ДатаПо = Дата(DateTo);
		//ОтчетПоОТХ.Ответственный = 
		ОтчетПоОТХ.Комментарий = "Сформирован автоматически по результатам продаж";
		
		ОтчетПоОТХ.Товары.Очистить();
		
		Для каждого стр из  ТаблицаЗаказа цикл
			нстр = ОтчетПоОТХ.Товары.Добавить();
			нстр.Номенклатура = стр.НоменклатураСпр;
			нстр.Количество = стр.Количество;
			
			Товар = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "Product"));
			Товар.Code=(Строка(стр.Номенклатура));
			Товар.Quantity=(Число(стр.Количество));
			Товар.Price = стр.Цена;
			Товары.Product.Добавить(Товар);
		КонецЦикла;
		
		Если ОтчетПоОТХ.Товары.Количество() <> 0 Тогда
			Попытка 
				ОтчетПоОТХ.Записать(РежимЗаписиДокумента.Проведение);
				//Реализация.Записать(РежимЗаписиДокумента.Запись);
			Исключение
				//Реализация.Записать(РежимЗаписиДокумента.Запись);
				Ошибка = Ошибка + Символы.ПС+ОписаниеОшибки();
				Success = ложь;
			КонецПопытки;
			
			OrderGUID = Строка(ОтчетПоОТХ.Ссылка.УникальныйИдентификатор());
			OrderNumber = СокрЛП(ОтчетПоОТХ.Номер);
		КонецЕсли; 
	КонецЕсли; 

	
	РезультатОперации.Success		 = Success;
	РезультатОперации.Error			 = Ошибка;
	РезультатОперации.Products       = Товары;
	РезультатОперации.NumberYST		 = OrderNumber;
	РезультатОперации.GuidYST	     = OrderGUID;
	
	Возврат РезультатОперации;
	
КонецФункции

Функция СформироватьРеализацииПоСхемеПеремещений(PointId, Partner, Goods, Receipts, GuidYST, IsKTOrder)
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
	|	ЕСТЬNULL(СпрНоменклатура.Ссылка, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК НоменклатураСпр
	|ИЗ
	|	втТаб КАК втТаб
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО втТаб.Номенклатура = СпрНоменклатура.Код";
	Запрос.УстановитьПараметр("тзТаб",ТаблицаЗаказа);
	
	ТаблицаЗаказа = Запрос.Выполнить().Выгрузить();
	
	//Создание заказа(ов)
	Если Success Тогда
		
		ПодразделениеЗаказа = Справочники.Подразделения.НайтиПоКоду("00005");
		
		
		//Реализация = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
		Реализация = ПолучитьРеализацию(GuidYST);
		
		Если Реализация.ЭтоНовый() тогда
			Реализация.Дата = НачалоДня(ТекущаяДата())-600;
		КонецЕсли;
		
		Реализация.Товары.Очистить();
		Реализация.ТаблицаБригады.Очистить();
		Реализация.ТоварыАдресноеХранение.Очистить();
		Реализация.ДанныеПоПогрузке.Очистить();
		Реализация.Услуги.Очистить();
		
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
		
		
		//цены
		СписокНом = ТаблицаЗаказа.ВыгрузитьКолонку("НоменклатураСпр");
		ТабЗнач1  = Новый ТаблицаЗначений;
		ТабЗнач1  = ОбменСУТИнтернетМагазин.ПолучитьЦеныДляКонтрагента(Контрагент, СписокНом, ТекущаяДата());
		
		Если Partner = "П017979" тогда  //ИП Скрипченко
		иначе
			услПредоплатногоДоговора = (Реализация.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.НайтиПоКоду("00001")
			или Реализация.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ПредоплатаПоСчетам //+++14.08.2017
			или Реализация.ДоговорКонтрагента.ТипДоговора = Справочники.ТипыДоговоров.ФакторингПредоплата);//22.05.2017
			
			Если ТипЗнч(ТабЗнач1) = Тип("Строка") Тогда // нет политики ценообразования документом
				табЗнач1  = новый ТаблицаЗначений;
				табЗнач1  = ОбменСУТИнтернетМагазин.ПолучитьЦеныДляКонтрагента_РегСв(Контрагент, СписокНом); //из регистра сведений
			КонецЕсли;	
		КонецЕсли;
		//
		
		Для каждого Стр1 ИЗ ТаблицаЗаказа Цикл
			СтрокаТовары = Реализация.Товары.Добавить();
			СтрокаТовары.Номенклатура = Стр1.НоменклатураСпр;
			СтрокаТовары.Коэффициент = 1;
			СтрокаТовары.Количество = Стр1.Количество;
			ЗаполнитьЕдиницуЦенуПродажиТабЧасти(СтрокаТовары, Реализация, Константы.ВалютаРегламентированногоУчета.Получить()); 
			ЗаполнитьСтавкуНДСТабЧасти(СтрокаТовары, Реализация);
			
			Если Partner = "П017979" тогда  //ИП Скрипченко
				СтрокаТовары.Цена = Стр1.Цена;
			иначе
				стр2 = табЗнач1.найти(стр1.НоменклатураСпр, "Номенклатура");
				стр1Цена = стр1.Цена;
				Если стр2 = неопределено Тогда
					стр2МинимальнаяЦена = 0;
				Иначе
					//+++ 10.09.2015 Цена ПРЕДОПЛАТНАЯ с доп.скидкой
					Если услПредоплатногоДоговора Тогда
						попытка
							стр2МинимальнаяЦена = стр2.ЦенаСоСкидкойПредоплаты; 
						исключение // если экспортные цены или из Политики... то там нет поля ЦенаСоСкидкойПредоплаты	
							стр2МинимальнаяЦена = стр2.МинимальнаяЦена;
						КонецПопытки;	
					Иначе // как было
						стр2МинимальнаяЦена = стр2.МинимальнаяЦена;
					КонецЕсли;
				КонецЕсли;
				Если стр1Цена<>стр2МинимальнаяЦена Тогда
					стр1.Цена = стр2МинимальнаяЦена; // изменение Цены по политике ценообразования
				КонецЕсли;
				СтрокаТовары.Цена = стр1.Цена;
			КонецЕсли;
			
			РассчитатьСуммуТабЧасти(СтрокаТовары, Реализация);
			РассчитатьСуммуНДСТабЧасти(СтрокаТовары, Реализация);
			
			Товар = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(URL, "Product"));
			Товар.Code=(Строка(Стр1.Номенклатура));
			Товар.Quantity=(Число(Стр1.Количество));
			Товар.Price = СтрокаТовары.Цена;
			Товары.Product.Добавить(Товар);
		КонецЦикла;
		
		Для каждого Запись из Receipts.Receipt цикл	
			Нстр = Реализация.ДокументыКонтрагентов.Добавить();
			Нстр.Номер = Запись.Number;
			Нстр.GUID = Запись.GUID;
		КонецЦикла;
		
		Если Реализация.ЭтоНовый() тогда
			Реализация.УстановитьНовыйНомер("ТК");
		КонецЕсли;
		
		//Реализация.Записать(РежимЗаписиДокумента.Запись);
		
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
