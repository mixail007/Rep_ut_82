﻿Функция Печать() Экспорт
	ТабДокумент = новый ТабличныйДокумент;
	макет = ПолучитьМакет("Макет");
	ОбластьШапка = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПоставщик = Макет.ПолучитьОбласть("Поставщик");
	ОбластьПокупатель = Макет.ПолучитьОбласть("Покупатель");
	ОбластьПокупатель = Макет.ПолучитьОбласть("Покупатель");
	ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока  = Макет.ПолучитьОбласть("Строка");
	ОбластьИтого  = Макет.ПолучитьОбласть("Итого");
	ОбластьСуммаПрописью  = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьПодписи  = Макет.ПолучитьОбласть("Подписи");

																														

	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаказПокупателяЗаказы.ЗаказПокупателя
	             |ПОМЕСТИТЬ втЗаказы
	             |ИЗ
	             |	Документ.ЗаказПокупателя.Заказы КАК ЗаказПокупателяЗаказы
	             |ГДЕ
	             |	ЗаказПокупателяЗаказы.Ссылка = &Ссылка
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ЗаказПокупателя.Ссылка
	             |ИЗ
	             |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	             |ГДЕ
	             |	ЗаказПокупателя.Ссылка = &Ссылка
	             |	И НЕ ЗаказПокупателя.НомерВходящегоДокумента = """"
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЗаказПокупателяТовары.Ссылка КАК Ссылка,
	             |	ЗаказПокупателяТовары.Номенклатура,
	             |	ЗаказПокупателяТовары.Количество,
	             |	ЗаказПокупателяТовары.Цена,
	             |	ЗаказПокупателя.РеквизитыЗаказаТК.(
	             |		Ссылка,
	             |		НомерСтроки,
	             |		Поле,
	             |		Значение
	             |	),
	             |	ЗаказПокупателя.НомерВходящегоДокумента,
	             |	ЗаказПокупателяТовары.Номенклатура.Код,
	             |	ЗаказПокупателяТовары.ЕдиницаИзмерения,
	             |	ЗаказПокупателяТовары.Сумма КАК Сумма,
	             |	ЗаказПокупателя.Дата,
	             |	ЗаказПокупателя.ВалютаДокумента
	             |ИЗ
	             |	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателя
	             |		ПО ЗаказПокупателяТовары.Ссылка = ЗаказПокупателя.Ссылка
	             |ГДЕ
	             |	ЗаказПокупателяТовары.Ссылка В
	             |			(ВЫБРАТЬ
	             |				втЗаказы.ЗаказПокупателя
	             |			ИЗ
	             |				втЗаказы)
	             |
	             |ОБЪЕДИНИТЬ ВСЕ
	             |
	             |ВЫБРАТЬ
	             |	ЗаказПокупателяУслуги.Ссылка,
	             |	ЗаказПокупателяУслуги.Номенклатура,
	             |	ЗаказПокупателяУслуги.Количество,
	             |	ЗаказПокупателяУслуги.Цена,
	             |	ЗаказПокупателя.РеквизитыЗаказаТК.(
	             |		Ссылка,
	             |		НомерСтроки,
	             |		Поле,
	             |		Значение
	             |	),
	             |	ЗаказПокупателя.НомерВходящегоДокумента,
	             |	ЗаказПокупателяУслуги.Номенклатура.Код,
	             |	NULL,
	             |	ЗаказПокупателяУслуги.Сумма,
	             |	ЗаказПокупателя.Дата,
	             |	ЗаказПокупателя.ВалютаДокумента
	             |ИЗ
	             |	Документ.ЗаказПокупателя.Услуги КАК ЗаказПокупателяУслуги
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателя
	             |		ПО ЗаказПокупателяУслуги.Ссылка = ЗаказПокупателя.Ссылка
	             |ГДЕ
	             |	ЗаказПокупателяУслуги.Ссылка В
	             |			(ВЫБРАТЬ
	             |				втЗаказы.ЗаказПокупателя
	             |			ИЗ
	             |				втЗаказы)
	             |ИТОГИ
	             |	СУММА(Сумма)
	             |ПО
	             |	Ссылка";
				 Запрос.УстановитьПараметр("Ссылка",СсылкаНаОбъект);
				 ВыборкаЗаказ = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				 
				 Пока ВыборкаЗаказ.Следующий() Цикл
					 ВыборкаДетали = ВыборкаЗаказ.Выбрать();
					 ВыборкаДетали.Следующий();
					 РеквизитыТК = ВыборкаДетали.РеквизитыЗаказаТК.выгрузить();
					 РеквизитыТК.сортировать("НомерСтроки");
					 Грузополучатель = "";
					 АдресГрузополучателя = "";
					 ТелефонГрузополучателя = "";
					 ТелефонГрузополучателя2 = "";
					 НомерЗаказа = "";

					 Для каждого стр из РеквизитыТК цикл
						 Если стр.Поле="Адрес покупателя" тогда
							  АдресГрузополучателя = стр.Значение;
							 прервать;
						 КонецЕсли;
					 КонецЦикла;
					 Для каждого стр из РеквизитыТК цикл
						 Если стр.Поле="Грузополучатель" тогда
							  Грузополучатель = стр.Значение;
							 прервать;
						 КонецЕсли;
					 КонецЦикла;
					 
					 Для каждого стр из РеквизитыТК цикл
						 Если стр.Поле="ContactPhone" или стр.Поле="ТелефонКонтрагента" тогда
							  ТелефонГрузополучателя = стр.Значение;
							 прервать;
						 КонецЕсли;
					 КонецЦикла;
					 
					 Для каждого стр из РеквизитыТК цикл
						 Если стр.Поле="ContactPhone_Dop" тогда
							  ТелефонГрузополучателя2 = стр.Значение;
							 прервать;
						 КонецЕсли;
					 КонецЦикла;


					 
					 ОбластьШапка.Параметры.ТекстЗаголовка="Товарный чек №"+ВыборкаДетали.НомерВходящегоДокумента+" от "+Формат(ВыборкаДетали.Дата,"ДФ='dd MMMM yyyy'; ДЛФ=DD")+"г.";
					 ТабДокумент.Вывести(ОбластьШапка);
					 ОбластьПоставщик.Параметры.ПредставлениеПоставщика="Закрытое акционерное общество Торговая компания ""Яршинторг""
					 |Телефон для связи 8-800-333-81-87 (бесплатный звонок по РФ)";
					 ТабДокумент.Вывести(ОбластьПоставщик);
					 ОбластьПокупатель.Параметры.ПредставлениеПолучателя=СокрЛП(Грузополучатель)+", адрес: "+АдресГрузополучателя+", тел: "+ТелефонГрузополучателя+", "+ТелефонГрузополучателя2;
					 ТабДокумент.Вывести(ОбластьПокупатель);
                     ТабДокумент.Вывести(ОбластьШапкаТаблицы);
																																	
					 ВыборкаДетали.Сбросить();
					 пп=0;
					 Пока ВыборкаДетали.Следующий() цикл
						 пп=пп+1;
						 ОбластьСтрока.Параметры.НомерСтроки = пп;
						 ОбластьСтрока.Параметры.Артикул = ВыборкаДетали.НоменклатураКод;
						 ОбластьСтрока.Параметры.Товар = ВыборкаДетали.Номенклатура;
						 ОбластьСтрока.Параметры.ЕдиницаЦены = ВыборкаДетали.ЕдиницаИзмерения;
						 ОбластьСтрока.Параметры.Цена = ВыборкаДетали.Цена;
						 ОбластьСтрока.Параметры.Количество = ВыборкаДетали.Количество;
                         ОбластьСтрока.Параметры.Сумма = ВыборкаДетали.Сумма;
						 ТабДокумент.Вывести(ОбластьСтрока);
						 
					 КонецЦикла;
					 ОбластьИтого.Параметры.Всего = ВыборкаЗаказ.Сумма;
					 ТабДокумент.Вывести(ОбластьИтого);
					 ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока="Всего наименований "+пп+", на сумму "+Формат(ВыборкаЗаказ.Сумма,"ЧДЦ=2")+"руб.";
					 ОбластьСуммаПрописью.Параметры.СуммаПрописью=ЧислоПрописью(ВыборкаЗаказ.Сумма, "Л=ru_RU;ДП=Истина","рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
					 
					 ТабДокумент.Вывести(ОбластьСуммаПрописью);
					 ОбластьПодписи.Параметры.ОтветственныйПредставление="Махова Н.К.";
					 ОбластьПодписи.Параметры.Получил="";
					 ТабДокумент.Вывести(ОбластьПодписи);
					 ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				 КонецЦикла;
	
	
	
	Возврат ТабДокумент;
КонецФункции
