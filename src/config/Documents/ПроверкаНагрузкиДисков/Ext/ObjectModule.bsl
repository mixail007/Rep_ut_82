﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения<> Неопределено Тогда
		ДокументОснование = ДанныеЗаполнения;
		Для каждого строка из ДокументОснование.товары Цикл
			Если строка.номенклатура.ВидТовара = Перечисления.ВидыТоваров.Диски тогда
				стр = товары.Добавить();
				стр.Номенклатура = Строка.Номенклатура;
				стр.Количество = Строка.Количество;
				стр.Цена = Строка.Цена;
				стр.ВПроцессе = Истина;
		    конецесли;
		конецЦикла;
		товары.Свернуть("Номенклатура,Цена,ВПроцессе","Количество");
		Поставщик = ДанныеЗаполнения.Контрагент;
		Контейнер = ДанныеЗаполнения.Сделка.НомерКонтейнера;

	конецЕсли;
	Если Товары.Количество()=0 Тогда
		Сообщить("Создание документа не требуется");
	конецЕсли;	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
КонецПроцедуры


Процедура ОбработкаУдаленияПроведения(Отказ)
	НаборЗаписей = РегистрыСведений.ПровереннаяНагрузкаДисков.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	наборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	наборЗаписей.Записать();	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	КонецПроцедуры
		
	Процедура ПоместитьВСтопЛист(Номенклатура)
	
	//Номенклатура помещается в стоп-лист
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.Текст = "ВЫБРАТЬ
	|	НоменклатураИмпорт.Номенклатура
	|ИЗ
	|	РегистрСведений.НоменклатураИмпорт КАК НоменклатураИмпорт
	|ГДЕ
	|	НоменклатураИмпорт.Номенклатура = &Номенклатура";
	Записи = Запрос.Выполнить().Выгрузить();
	Если Записи.Количество() = 0 Тогда
		МенеджерЗаписи = РегистрыСведений.НоменклатураИмпорт.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Номенклатура = Номенклатура;
		МенеджерЗаписи.Записать();
		Сообщить("Номенклатура помещена в стоп-лист");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если не значениеЗаполнено(Ответственный) тогда
		Ответственный = глТекущийПользователь;
	конецЕсли;	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	НаборЗаписей = РегистрыСведений.ПровереннаяНагрузкаДисков.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.документ.Установить(Ссылка);
	наборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	наборЗаписей.Записать();	
	
	Для каждого стр из Товары цикл
	//	Если не стр.Дубль тогда	
			Если стр.результат1<>0 Тогда
				Запись = Регистрысведений.ПровереннаяНагрузкаДисков.СоздатьМенеджерЗаписи();
				Запись.Документ= ССылка;
				Запись.Дата= стр.Дата1;
				Запись.Номенклатура = стр.Номенклатура;
				Запись.НомерПартии = стр.НомерПартии;
				Запись.НомерКонтейнера = Контейнер;
				Запись.ТестПройден = стр.ТестПройден1;
				Запись.ПрошедшаяНагрузка = стр.Результат1;
				Запись.Записать();
				
				Если стр.ТестПройден1 = ложь И стр.Результат1 <> 0 Тогда
					ПоместитьВСтопЛист(стр.Номенклатура);
				КонецЕсли; 
				
				
			конецЕсли;
			
			Если стр.результат2<>0 Тогда
				Запись = Регистрысведений.ПровереннаяНагрузкаДисков.СоздатьМенеджерЗаписи();
				Запись.Документ= ССылка;
				Запись.Дата= стр.Дата2;
				Запись.Номенклатура = стр.Номенклатура;
				Запись.НомерПартии = стр.НомерПартии;
				Запись.НомерКонтейнера = Контейнер;
				Запись.ТестПройден = стр.ТестПройден2;
				Запись.ПрошедшаяНагрузка = стр.Результат2;
				Запись.Записать();
				
				Если стр.ТестПройден2 = ложь И стр.Результат2 <> 0 Тогда
					ПоместитьВСтопЛист(стр.Номенклатура);
				КонецЕсли; 
				
				
			конецЕсли;
			Если стр.результат3<>0 Тогда
				Запись = Регистрысведений.ПровереннаяНагрузкаДисков.СоздатьМенеджерЗаписи();
				Запись.Документ= ССылка;
				Запись.Дата= стр.Дата3;
				Запись.Номенклатура = стр.Номенклатура;
				Запись.НомерПартии = стр.НомерПартии;
				Запись.НомерКонтейнера = Контейнер;
				Запись.ТестПройден = стр.ТестПройден3;
				Запись.ПрошедшаяНагрузка = стр.Результат3;
				Запись.Записать();
				
				Если стр.ТестПройден3 = ложь И стр.Результат3 <> 0 Тогда
					ПоместитьВСтопЛист(стр.Номенклатура);
				КонецЕсли; 
			конецЕсли;	
	//	конецЕсли;		
		
	конецЦикла;

КонецПроцедуры
	
		
