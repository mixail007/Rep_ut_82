﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	// нет ли дублей строк
	
	Проверка = Товары.Выгрузить();
	Проверка.Свернуть("Типоразмер,модель");
	Если Товары.Количество()<> Проверка.Количество() тогда
		Сообщить("В документе указанно несколько строк с одинаковым типоразмером и моделью!"); 
		Отказ = Истина;
	конецЕсли;	
	
	//не было ли  в предыдущих документах такого
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таб.Типоразмер,
	|	Таб.Модель
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&Таб КАК Таб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СозданиеПрограммПоКованнымДискамТовары.ТипоРазмер,
	|	СозданиеПрограммПоКованнымДискамТовары.Модель
	|ПОМЕСТИТЬ УжеБыло
	|ИЗ
	|	Документ.СозданиеПрограммПоКованнымДискам.Товары КАК СозданиеПрограммПоКованнымДискамТовары
	|ГДЕ
	|	СозданиеПрограммПоКованнымДискамТовары.Ссылка <> &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.Типоразмер,
	|	ВТ.Модель
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ УжеБыло КАК УжеБыло
	|		ПО ВТ.Типоразмер = УжеБыло.ТипоРазмер
	|			И ВТ.Модель = УжеБыло.Модель
	|ГДЕ
	|	НЕ УжеБыло.ТипоРазмер ЕСТЬ NULL 
	|	И НЕ УжеБыло.Модель ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Таб", Товары);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если не результат.Пустой() тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			сообщить("По типоразмеру "+выборка.типоразмер+" и модели "+Выборка.Модель+" уже есть данные о программе! ");	
			отказ = истина;
			
			
		КонецЦикла;
	конецесли;
	
	Если не Отказ тогда
	//запишем веса
	Для каждого стр из товары цикл
	ВыборкаЕд = справочники.ЕдиницыИзмерения.Выбрать(,стр.Номенклатура,,);
	ВыборкаЕд.Следующий();
	Ед = ВыборкаЕд.ПолучитьОбъект();
	Ед.Вес = стр.Вес;
	Ед.Записать();
		
	конеццикла;	
	конецЕсли;
	
	
	
КонецПроцедуры
