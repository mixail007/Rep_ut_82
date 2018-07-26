﻿

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
//+++ Свои движения ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	// регистр НезавершенноеПроизводство Приход
	Движения.НезавершенноеПроизводство.Записывать = Истина;
	таблМат = Материалы.Выгрузить();
	таблМат.Свернуть("Номенклатура", "Количество, Сумма");  //без дублей по материалам
	Для Каждого ТекСтрокаМатериалы Из  таблМат Цикл
		Движение = Движения.НезавершенноеПроизводство.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаМатериалы.Номенклатура;
		Движение.Количество = ТекСтрокаМатериалы.Количество;
		Движение.Сумма = ТекСтрокаМатериалы.Сумма;
	КонецЦикла;

	// регистр Затраты Материалов ( + ) 
	Движения.Затраты.Записывать = Истина;
	для каждого стрМ из Материалы цикл 	
		Движение = Движения.Затраты.Добавить();
		Движение.Период = Дата;
		
		Движение.Подразделение        = Подразделение;    // реквизит
		Движение.НоменклатурнаяГруппа = НомГруппаЗатрат;  // реквизит
		
		//может быть любая статья! - не Производство, а Недостача/Брак...
		Движение.СтатьяЗатрат         = стрМ.СтатьяЗатрат;      
		Движение.СтатьяЗатратУпр      = стрМ.СтатьяЗатратУПР;
		Движение.Сумма = стрМ.Сумма;
	КонецЦикла;

	
	
//=================Пересчет документов Выпуска ==========================================
таблДок = ДокументыВыпускаПродукции.Выгрузить();
ВсяГотПродукция = таблДок.Итог("ВсяГотПродукция");
	
Для каждого стр1 из таблДок цикл
	Если стр1.ВсяГотПродукция<=0 тогда
		#Если Клиент тогда
			сообщить("Документ: "+строка(стр1.ВыпускПродукции)+" не участвует в распределении доп.затрат!", СтатусСообщения.Внимание);
		#КонецЕсли	
		продолжить;
	КонецЕсли;	
	
	доля1 = стр1.ВсяГотПродукция / ВсяГотПродукция;
	док1  = стр1.ВыпускПродукции.ПолучитьОбъект();
	
	док1.СпособРаспределенияДопЗатрат = СпособРаспределенияДопЗатрат; //Единый для всех выбранных документов выпуска
	
	Для каждого стрЗатрат из ЭтотОбъект.ДопЗатраты цикл
		строки1 = док1.ДопЗатраты.найтиСтроки(новый Структура("СтатьяЗатрат, СтатьяЗатратУПР",стрЗатрат.СтатьяЗатрат, стрЗатрат.СтатьяЗатратУПР) );
		
		Если строки1.Количество()=0 тогда
			стрЗатрат1 = док1.ДопЗатраты.добавить();
			стрЗатрат1.СтатьяЗатрат = стрЗатрат.СтатьяЗатрат;
			стрЗатрат1.СтатьяЗатратУПР = стрЗатрат.СтатьяЗатратУПР;
		иначеЕсли строки1.Количество()=1 тогда
			стрЗатрат1 = строки1[0];
		иначе // не должно быть дублей строк по 2м полям!
			#Если Клиент тогда
				сообщить("В документе "+строка(док1)+" дублируются строки Затрат по СтатьяЗатрат, СтатьяЗатратУПР!", СтатусСообщения.Внимание);
			#КонецЕсли	
		КонецЕсли;	
		
		стрЗатрат1.Сумма = окр(стрЗатрат.Сумма * доля1,2); // до копеек!
		
	КонецЦикла;	
	
//---------материалы распределяются по той же схеме - пропорционально Доле --------------------
// а уже внутри выпуска - по количеству в спецификации на все товары готовой продукции
//
	Для каждого стрМ из ЭтотОбъект.Материалы цикл
		строки1 = док1.Материалы.найтиСтроки(новый Структура("Номенклатура", стрМ.Номенклатура) ); //СтатьяМатЗатрат, СтатьяМатЗатратУПР - фикс!
		
		Если строки1.Количество()<=1 тогда
			стр1 = док1.Материалы.Добавить();
			стр1.Номенклатура = стрМ.Номенклатура;
			стр1.Распределяется = ИСТИНА;
		Иначе //Если строки1.Количество()>=2 тогда //уже была корректировка! идёт дублем строки по той же номенклатуре
			стр1 = неопределено;
			для i=0 по строки1.Количество()-1 цикл
				Если строки1[i].Распределяется тогда
					стр1 = строки1[i];
				КонецЕсли;
			КонецЦикла;	
			
			Если стр1 = неопределено тогда // нет строк для распределения?! тогда 2-я
			стр1 = строки1[1];
			КонецЕсли;
		
			#Если Клиент тогда
			Если строки1.Количество()>2 тогда
				сообщить("Материал "+строка(стрМ.Номенклатура)+" в документе "+строка(док1)+" повторяется "+строка(строки1.Количество())+" раз!", СтатусСообщения.Внимание);
			КонецЕсли;
			#КонецЕсли	
		КонецЕсли;
		
		стр1.Количество = стрМ.Количество * доля1;
		стр1.Сумма      = стрМ.Сумма * доля1;
		
	КонецЦикла;
	
	попытка
		док1.Записать(РежимЗаписиДокумента.Проведение); // перепроведение!
		#Если Клиент тогда
		Сообщить("Изменен документ: "+строка(док1), СтатусСообщения.Информация );
		#КонецЕсли
	исключение
		#Если Клиент тогда
		Сообщить("Ошибка при проведении документа: "+строка(док1)+" : "+ОписаниеОшибки(), СтатусСообщения.Внимание );
		#КонецЕсли
	КонецПопытки;
	
КонецЦикла;	 //-------------------------------------

//контроль копеек после распределения - пока не готов


//2) ----------перепроведение реализаций (изменение себестоимости продаж)----------------------
масРеализаций = ПолучитьРеализацииЗаПериодПоГотПродукции();
для i=0 по масРеализаций.Количество()-1 цикл
	док1 = масРеализаций[i].ПолучитьОбъект();
	попытка
		док1.Записать(РежимЗаписиДокумента.Проведение); // перепроведение!
		#Если Клиент тогда
		Сообщить("Изменен документ: "+строка(док1), СтатусСообщения.Информация );
		#КонецЕсли
	исключение
		#Если Клиент тогда
		Сообщить("Ошибка при проведении документа: "+строка(док1)+" : "+ОписаниеОшибки(), СтатусСообщения.Внимание );
		#КонецЕсли
	КонецПопытки;
КонецЦикла;	
	
	
// >> нужен стандарный ввод Списания / Оприходования по складу Готовой продукции?!
//	СкладГотовойПродукции = справочники.Склады.НайтиПоНаименованию("Ангар-Ковка");
//
КонецПроцедуры

функция мПолучитьДокументы() Экспорт
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Ссылка как ВыпускПродукции,
	                |	ВЫБОР
	                |		КОГДА ОтчетПроизводстваЗаСменуГотоваяПродукция.СпособРаспределенияДопЗатрат = &СпособРаспределенияДопЗатрат
	                |			ТОГДА ОтчетПроизводстваЗаСменуГотоваяПродукция.ВсяГотПродукция
	                |		ИНАЧЕ -111
	                |	КОНЕЦ КАК ВсяГотПродукция
	                |ИЗ
	                |	Документ.ОтчетПроизводстваЗаСмену КАК ОтчетПроизводстваЗаСменуГотоваяПродукция
	                |ГДЕ
	                |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Дата МЕЖДУ &ДатаНач И &ДатаКон
	                |	И ОтчетПроизводстваЗаСменуГотоваяПродукция.Проведен
	                |	И ОтчетПроизводстваЗаСменуГотоваяПродукция.Организация = &Организация
	                |	И ОтчетПроизводстваЗаСменуГотоваяПродукция.Подразделение = &Подразделение";
	 
	 Запрос.УстановитьПараметр("Организация",   Организация );
	 Запрос.УстановитьПараметр("Подразделение", Подразделение );
	 Запрос.УстановитьПараметр("СпособРаспределенияДопЗатрат",СпособРаспределенияДопЗатрат);
	  
	 Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца( ПериодРасчета ) );
	 Запрос.УстановитьПараметр("ДатаКон", КонецМесяца( ПериодРасчета )  );
	 
	 Результат = Запрос.Выполнить();
	 табл      = Результат.Выгрузить();	 
	 
	Для каждого стр1 из табл цикл
		Если стр1.ВсяГотПродукция<=0 тогда
			#Если Клиент тогда
				сообщить("В документе: "+строка(стр1.ВыпускПродукции)+" указан ДРУГОЙ способ распределения доп.затрат!", СтатусСообщения.Внимание);
			#КонецЕсли	
		КонецЕсли;	
		//---------------делаем новый пересчет!---------------------	
		Если СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоСумме тогда
			ВсяГотПродукция1 =стр1.ВыпускПродукции.ГотоваяПродукция.Итог("СуммаПлан");  едИзм = "р.";
		ИначеЕсли СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоКоличеству тогда
			ВсяГотПродукция1 =стр1.ВыпускПродукции.ГотоваяПродукция.Итог("Количество");едИзм= "шт.";
		ИначеЕсли СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоВесу тогда
			ВсяГотПродукция1 = 0; едИзм = "кг.";
			Для каждого стрГ из стр1.ВыпускПродукции.ГотоваяПродукция цикл
				ВсяГотПродукция1 = ВсяГотПродукция1 + стрГ.Номенклатура.ЕдиницаХраненияОстатков.Вес * стрГ.Количество;
			КонецЦикла;
		КонецЕсли;
		//-----------меняем таблДок и ВсяГотПродукция ---------------------------
		стр1.ВсяГотПродукция = ВсяГотПродукция1;
		#Если Клиент тогда
		сообщить("   Выполнен автоматический расчет по документу >> "+строка(ВсяГотПродукция1)+едИзм, СтатусСообщения.Информация);
		#КонецЕсли	
	КонецЦикла;
	 
	 возврат табл;
	 
КонецФункции

функция ПолучитьРеализацииЗаПериодПоГотПродукции()
 мас = новый массив;
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ различные
	 |	РеализацияТоваровУслугТовары.Ссылка  как Реализация
	 |ИЗ
	 |	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	 |ГДЕ
	 |	РеализацияТоваровУслугТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &ДатаКон
	 |	И РеализацияТоваровУслугТовары.Ссылка.Проведен
	 |	И РеализацияТоваровУслугТовары.Номенклатура В("
	 +"ВЫБРАТЬ
  |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Номенклатура
  |ИЗ
  |	Документ.ОтчетПроизводстваЗаСмену.ГотоваяПродукция КАК ОтчетПроизводстваЗаСменуГотоваяПродукция
  |ГДЕ
  |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Ссылка В (&СписДок)"
  	+")";
	 Запрос.УстановитьПараметр("ДатаНач", НачалоМесяца( ПериодРасчета ) );														
	 Запрос.УстановитьПараметр("ДатаКон", КонецМесяца( ПериодРасчета ) );														
	 Запрос.УстановитьПараметр("СписДок",  ДокументыВыпускаПродукции.ВыгрузитьКолонку("ВыпускПродукции") );
	 
	 Результат = Запрос.Выполнить();
	 табл = Результат.Выгрузить();	
	 мас = табл.ВыгрузитьКолонку("Реализация");
	 возврат мас;
КонецФункции