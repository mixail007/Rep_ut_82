﻿
функция ПолучитьЗаказыДляПечати()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",СсылкаНаОбъект);
	
	Если ТипЗнч(СсылкаНаОбъект)= Тип("ДокументСсылка.ЗаказПокупателя") тогда
		
		Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |	Заказы.ЗаказПокупателя
		             |ПОМЕСТИТЬ втЗаказы
		             |ИЗ
		             |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |		ЗаказПокупателяЗаказы.ЗаказПокупателя КАК ЗаказПокупателя
		             |	ИЗ
		             |		Документ.ЗаказПокупателя.Заказы КАК ЗаказПокупателяЗаказы
		             |	ГДЕ
		             |		ЗаказПокупателяЗаказы.Ссылка = &Ссылка
		             |	
		             |	ОБЪЕДИНИТЬ ВСЕ
		             |	
		             |	ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |		ЗаказПокупателя.Ссылка
		             |	ИЗ
		             |		Документ.ЗаказПокупателя КАК ЗаказПокупателя
		             |	ГДЕ
		             |		ЗаказПокупателя.Ссылка = &Ссылка) КАК Заказы
		             |;
		             |
		             |////////////////////////////////////////////////////////////////////////////////
		             |ВЫБРАТЬ
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Ссылка КАК Ссылка,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.НомерСтроки,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Поле КАК Поле,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Значение,
		             |	ЗаказПокупателяСсылка.Товары.(
		             |		Количество,
		             |		Номенклатура,
		             |		Номенклатура.Код,
		             |		Номенклатура.ВидТовара,
		             |		ЕдиницаИзмерения
		             |	),
		             |	ЗаказПокупателяСсылка.НомерВходящегоДокумента,
		             |	ЗаказПокупателяСсылка.ТранспортнаяКомпания,
		             |	ЗаказПокупателяСсылка.Организация,
		             |	ЗаказПокупателяСсылка.КомментарийДляСклада,
		             |	ЗаказПокупателяСсылка.Номер,
		             |	ЗаказПокупателяСсылка.Комментарий,
		             |	ЗаказПокупателяСсылка.Бонусы.(
		             |		Номенклатура,
		             |		Количество,
		             |		Номенклатура.Код,
		             |		Номенклатура.ВидТовара,
		             |		Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения
		             |	)
		             |ИЗ
		             |	втЗаказы КАК втЗаказы
		             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.РеквизитыЗаказаТК КАК ЗаказПокупателяРеквизитыЗаказаТК
		             |		ПО втЗаказы.ЗаказПокупателя = ЗаказПокупателяРеквизитыЗаказаТК.Ссылка
		             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателяСсылка
		             |		ПО втЗаказы.ЗаказПокупателя = ЗаказПокупателяСсылка.Ссылка
		             |
		             |УПОРЯДОЧИТЬ ПО
		             |	Ссылка,
		             |	Поле,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.НомерСтроки
		             |ИТОГИ ПО
		             |	Ссылка
		             |АВТОУПОРЯДОЧИВАНИЕ";
		
	ИначеЕсли ТипЗнч(СсылкаНаОбъект)= Тип("ДокументСсылка.ЗаданиеНаПеремещение") тогда
		Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |	Заказы.ЗаказПокупателя
		             |ПОМЕСТИТЬ втЗаказы
		             |ИЗ
		             |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |		ЗаданиеНаПеремещениеЗаказыПокупателей.ЗаказПокупателя КАК ЗаказПокупателя
		             |	ИЗ
		             |		Документ.ЗаданиеНаПеремещение.ЗаказыПокупателей КАК ЗаданиеНаПеремещениеЗаказыПокупателей
		             |	ГДЕ
		             |		ЗаданиеНаПеремещениеЗаказыПокупателей.Ссылка = &Ссылка
		             |	
		             |	ОБЪЕДИНИТЬ ВСЕ
		             |	
		             |	ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |		ЗаказПокупателяЗаказы.ЗаказПокупателя
		             |	ИЗ
		             |		Документ.ЗаказПокупателя.Заказы КАК ЗаказПокупателяЗаказы
		             |	ГДЕ
		             |		ЗаказПокупателяЗаказы.Ссылка В
		             |				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		             |					ЗаданиеНаПеремещениеЗаказыПокупателей.ЗаказПокупателя КАК ЗаказПокупателя
		             |				ИЗ
		             |					Документ.ЗаданиеНаПеремещение.ЗаказыПокупателей КАК ЗаданиеНаПеремещениеЗаказыПокупателей
		             |				ГДЕ
		             |					ЗаданиеНаПеремещениеЗаказыПокупателей.Ссылка = &Ссылка)) КАК Заказы
		             |;
		             |
		             |////////////////////////////////////////////////////////////////////////////////
		             |ВЫБРАТЬ
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Ссылка КАК Ссылка,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.НомерСтроки,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Поле КАК Поле,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.Значение,
		             |	ЗаказПокупателяСсылка.Товары.(
		             |		Количество,
		             |		Номенклатура,
		             |		Номенклатура.Код,
		             |		Номенклатура.ВидТовара,
		             |		ЕдиницаИзмерения
		             |	),
		             |	ЗаказПокупателяСсылка.НомерВходящегоДокумента,
		             |	ЗаказПокупателяСсылка.ТранспортнаяКомпания,
		             |	ЗаказПокупателяСсылка.Организация,
		             |	ЗаказПокупателяСсылка.КомментарийДляСклада,
		             |	ЗаказПокупателяСсылка.Номер,
		             |	ЗаказПокупателяСсылка.Комментарий,
		             |	ЗаказПокупателяСсылка.Бонусы.(
		             |		Номенклатура,
		             |		Количество,
		             |		Номенклатура.Код,
		             |		Номенклатура.ВидТовара,
		             |		Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения
		             |	)
		             |ИЗ
		             |	втЗаказы КАК втЗаказы
		             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.РеквизитыЗаказаТК КАК ЗаказПокупателяРеквизитыЗаказаТК
		             |		ПО втЗаказы.ЗаказПокупателя = ЗаказПокупателяРеквизитыЗаказаТК.Ссылка
		             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя КАК ЗаказПокупателяСсылка
		             |		ПО втЗаказы.ЗаказПокупателя = ЗаказПокупателяСсылка.Ссылка
		             |
		             |УПОРЯДОЧИТЬ ПО
		             |	Ссылка,
		             |	Поле,
		             |	ЗаказПокупателяРеквизитыЗаказаТК.НомерСтроки
		             |ИТОГИ ПО
		             |	Ссылка
		             |АВТОУПОРЯДОЧИВАНИЕ";
	КонецЕсли;
	
	Рез=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	возврат Рез;
КонецФункции	
 
// общая процедура печати
функция Печать() Экспорт
	
	ТабДокумент = неопределено;
	Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) тогда
		#Если Клиент тогда
			Предупреждение("Не выбран документ!", 30);		
		#КонецЕсли
	КонецЕсли;
	
	//формируем список заказов
	
	ВыборкаЗаказыДляПечати=ПолучитьЗаказыДляПечати();
	
	ТабНаклеек=новый ТаблицаЗначений;
	ТабНаклеек.Колонки.Добавить("ЗаказНомер");
	ТабНаклеек.Колонки.Добавить("НоменклатураКод");
	ТабНаклеек.Колонки.Добавить("ПоставщикКод");
	ТабНаклеек.Колонки.Добавить("Количество");
	ТабНаклеек.Колонки.Добавить("Организация");
	ТабНаклеек.Колонки.Добавить("ТелефонКонтрагента");
	ТабНаклеек.Колонки.Добавить("Контрагент");
	ТабНаклеек.Колонки.Добавить("Номенклатура");
	ТабНаклеек.Колонки.Добавить("НомерBITRIX");
	ТабНаклеек.Колонки.Добавить("Поставщик");
	ТабНаклеек.Колонки.Добавить("ШК");
	ТабНаклеек.Колонки.Добавить("АдресКуда");
	ТабНаклеек.Колонки.Добавить("НаправлениеОтгрузки");
	ТабНаклеек.Колонки.Добавить("ВидНоменклатуры");
	ТабНаклеек.Колонки.Добавить("КомментарийДляСклада");
	ТабНаклеек.Колонки.Добавить("DPD");
	
	ТабНаклеек.Очистить();
	
	Пока ВыборкаЗаказыДляПечати.Следующий() Цикл
		ВыборкаДетали = ВыборкаЗаказыДляПечати.выбрать();
		ШК="";
		Грузополучатель = "";
		Товары = неопределено;
		НомерВх = "";
		Пока ВыборкаДетали.Следующий() цикл 
			НомерВх = СокрЛП(ВыборкаДетали.НомерВходящегоДокумента);
			Если НомерВх = "" тогда
				НомерВх = СокрЛП(ВыборкаДетали.Номер);
			КонецЕсли;
			Товары = ВыборкаДетали.Товары.Выгрузить();
			Бонусы = ВыборкаДетали.Бонусы.Выгрузить();
			Если ВыборкаДетали.Поле="ШК" и ВыборкаДетали.Значение <> "" тогда
				ШК=ВыборкаДетали.Значение;
			ИначеЕсли ВыборкаДетали.Поле="Грузополучатель"	и ВыборкаДетали.Значение <> "" тогда
				Грузополучатель = ВыборкаДетали.Значение;
			КонецЕсли;
			Организация = ВыборкаДетали.Организация;
			НаправлениеОтгрузки = ВыборкаДетали.ТранспортнаяКомпания;
			КомментарийДляСклада = СокрЛП(ВыборкаДетали.КомментарийДляСклада);
			
			ДПД = "";
			Если найти(ВыборкаДетали.Комментарий,"DPD Москва")>0 тогда
				ДПД = "DPD Москва";
			ИначеЕсли найти(ВыборкаДетали.Комментарий,"DPD")>0 тогда
				ДПД = "DPD";	
			КонецЕсли;	
		КонецЦикла;
		
		Если ШК<>"" тогда
			МассивШК = РаботаСDPD.РазложитьСтрокуВМассивПодстрокDPD(ШК,";");
			Для каждого эл из МассивШК цикл
				ШКВрем = СокрЛП(эл);
				Если ШКВрем <>""  тогда
					//KTY18V1V9190055V2 надо вытащить код номенклатуры
					//Сообщить(ШКВрем);
					КодНом = "";
					КолV=0;
					Для стр = 0 по СтрДлина(ШКВрем)-1 цикл
						СледующийСимвол = Сред(ШКВрем, СтрДлина(ШКВрем)-стр, 1);
						Если СледующийСимвол="V" тогда
							КолV=КолV+1; 
						КонецЕсли;
						
						Если КолV = 1 и  СледующийСимвол<>"V" тогда
							КодНом = СледующийСимвол+КодНом;
						КонецЕсли;
						
						Если КолV>1 тогда
							прервать;
						КонецЕсли;
					КонецЦикла; 
					Если КодНом<>"" тогда
						Если КодНом<>"AKS" и КодНом<>"KRP" и КодНом<>"DOC" тогда
							СтрНом="";
							стрТовары = Товары.Найти(КодНом,"НоменклатураКод");
							Если стрТовары<>неопределено тогда
								стрНом = ""+стрТовары.Номенклатура;
								Если кодНом = "9178010" тогда //пакеты
									стрНом = ""+стрТовары.Номенклатура+" "+стрТовары.Количество+стрТовары.ЕдиницаИзмерения;
								КонецЕсли;
							Иначе
								Сообщить("в заказе не найдена номенклатура по коду: "+КодНом);
							КонецЕсли;
						ИначеЕсли КодНом="AKS" тогда
							СтрНом="";
							отбор = новый структура("НоменклатураВидТовара");
							отбор.НоменклатураВидТовара = Перечисления.ВидыТоваров.Аксессуары;
							найденныеСтроки  = Товары.НайтиСтроки(отбор);
							Если найденныеСтроки.Количество()>0 тогда
								Для каждого найденнаяСтрока из  найденныеСтроки цикл
									Если найденнаяСтрока.НоменклатураКод<>"9178010" тогда
										СтрНом=СтрНом +"арт."+найденнаяСтрока.Номенклатура.Артикул+":" //+++ 04.10.2017  по просьбе Михаила Смирнова
												+найденнаяСтрока.Номенклатура+" "+найденнаяСтрока.Количество+найденнаяСтрока.ЕдиницаИзмерения+Символы.ПС;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
							
							найденныеСтроки  = Бонусы.НайтиСтроки(отбор);
							Если найденныеСтроки.Количество()>0 тогда
								Для каждого найденнаяСтрока из  найденныеСтроки цикл
									Если найденнаяСтрока.НоменклатураКод<>"9178010" тогда
										СтрНом=СтрНом +"арт."+найденнаяСтрока.Номенклатура.Артикул+":" //+++ 04.10.2017  по просьбе Михаила Смирнова
												+найденнаяСтрока.Номенклатура+" "+найденнаяСтрока.Количество+найденнаяСтрока.ЕдиницаИзмерения+Символы.ПС;
									КонецЕсли;
								КонецЦикла;
							КонецЕсли;
						ИначеЕсли КодНом="KRP" тогда
							СтрНом="";
							отбор = новый структура("НоменклатураВидТовара");
							отбор.НоменклатураВидТовара = Перечисления.ВидыТоваров.Прочее;
							найденныеСтроки  = Товары.НайтиСтроки(отбор);
							Если найденныеСтроки.Количество()>0 тогда
								Для каждого найденнаяСтрока из  найденныеСтроки цикл
									СтрНом=СтрНом+ найденнаяСтрока.Номенклатура+" "+найденнаяСтрока.Количество+найденнаяСтрока.ЕдиницаИзмерения+Символы.ПС;
								КонецЦикла;
							КонецЕсли;
						ИначеЕсли КодНом="DOC" тогда
							СтрНом="Пакет документов";
						КонецЕсли;
					иначе
						Сообщить("Не найден код номенклатуры");
					КонецЕсли;
					нстр = ТабНаклеек.Добавить();
					нстр.ЗаказНомер = НомерВх;
					нстр.Контрагент = Грузополучатель;
					
					Если КомментарийДляСклада<>"" тогда
						СтрНом = "СМОТРИ КОММЕНТАРИЙ"+Символы.ПС+СтрНом;
					КонецЕсли;
					нстр.Номенклатура = СтрНом;
					
					нстр.поставщик = "ЗАО ТК Яршинторг";
					нстр.DPD = ДПД;
					нстр.НаправлениеОтгрузки = НаправлениеОтгрузки;
					нстр.Организация = Организация;
					нстр.ШК = ШКВрем;
					нстр.КомментарийДляСклада = КомментарийДляСклада;
				КонецЕсли;
			КонецЦикла;
		иначе
			Сообщить("Для заказа"+ ВыборкаЗаказыДляПечати.Ссылка+" не назаначены штрихкоды");
		КонецЕсли;
	КонецЦикла;
	
	Макет = ПолучитьМакет("Макет");
	Наклейка = Макет.ПолучитьОбласть("Наклейка|Наклейка_В");
	НаклейкаГ = Макет.ПолучитьОбласть("Наклейка|Наклейка_В ");
	Разделитель = Макет.ПолучитьОбласть("Разделитель");
	ТабДокумент  = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_Наклейка";
	нпп=0;
	Для каждого стр из  ТабНаклеек цикл
		нпп=нпп+1;
		Наклейка.Параметры.Заполнить(стр);
		ОбШтрихКод=Наклейка.Рисунки.ШК.Объект;
		ОбШтрихКод.Сообщение = стр.ШК; 
		ОбШтрихКод.ТекстКода = СокрЛП(стр.ШК);
		
		НаклейкаГ.Параметры.Заполнить(стр);
		ОбШтрихКодГ=НаклейкаГ.Рисунки.ШК.Объект;
		ОбШтрихКодГ.Сообщение = стр.ШК; 
		ОбШтрихКодГ.ТекстКода = СокрЛП(стр.ШК);
		
		Если нпп%2=0 тогда
			ТабДокумент.Присоединить(Наклейка);
		Иначе
			ТабДокумент.Вывести(НаклейкаГ);
		КонецЕсли;
		Если нпп%2=0 тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
	КонецЦикла;
	
	
	ТабДокумент.ОтображатьЗаголовки=Ложь;
	ТабДокумент.ОтображатьСетку = ложь;
	ТабДокумент.Защита = истина;
	возврат ТабДокумент;
	
КонецФункции
