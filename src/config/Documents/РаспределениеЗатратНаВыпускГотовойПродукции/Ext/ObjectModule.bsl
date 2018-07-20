﻿

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

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
		Движение.СтатьяЗатрат         = стрМ.СтатьяМатЗатрат;      
		Движение.СтатьяЗатратУпр      = стрМ.СтатьяМатЗатратУПР;
		Движение.Сумма = стрМ.Сумма;
	КонецЦикла;

// >> нужен стандарный ввод Списания / Оприходования по складу Готовой продукции?!
//	СкладГотовойПродукции = справочники.Склады.НайтиПоНаименованию("Ангар-Ковка");
//
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
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
			ВсяГотПродукция1 =стр1.ВыпускПродукции.ГотоваяПродукция.Итог("Сумма");  едИзм = "р.";
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