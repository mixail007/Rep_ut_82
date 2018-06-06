﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Для Каждого ТекСтрокаПартииТоваров Из ПартииТоваров Цикл
		
		// регистр ПартииТоваровНаСкладах Расход
		Движение = Движения.ПартииТоваровНаСкладах.Добавить();
		
		Если ТекСтрокаПартииТоваров.Стоимость > 0 Тогда
		
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Количество = ТекСтрокаПартииТоваров.Количество;
			Движение.Стоимость = ТекСтрокаПартииТоваров.Стоимость;
		Иначе
			
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Количество = -ТекСтрокаПартииТоваров.Количество;
		    Движение.Стоимость = -ТекСтрокаПартииТоваров.Стоимость;

		КонецЕсли; 
		
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаПартииТоваров.Номенклатура;
		Движение.Склад = ТекСтрокаПартииТоваров.Склад;
		Движение.ХарактеристикаНоменклатуры = ТекСтрокаПартииТоваров.ХарактеристикаНоменклатуры;
		Движение.СерияНоменклатуры = ТекСтрокаПартииТоваров.СерияНоменклатуры;
		Движение.ДокументОприходования = ТекСтрокаПартииТоваров.ДокументОприходования;
		Движение.СтатусПартии = ТекСтрокаПартииТоваров.СтатусПартии;
		Движение.Заказ = ТекСтрокаПартииТоваров.Заказ;
		Движение.Качество = ТекСтрокаПартииТоваров.Качество;
		
		
		Движение.СписаниеПартий = ИСТИНА;
		Движение.НомерКорСтроки = ТекСтрокаПартииТоваров.НомерСтроки;
		
	КонецЦикла;
	// записываем движения регистров
	Движения.ПартииТоваровНаСкладах.Записать();
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
			
	Если НЕ Отказ Тогда
		
		обЗаписатьПротоколИзменений(ЭтотОбъект);
		
	КонецЕсли; 

КонецПроцедуры
