﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
	
	ЭлементыФормы.ДопРасходы.Очистить();
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("Дата1",НачПериода);
	Запрос.УстановитьПараметр("Дата2",КонПериода);
	Запрос.Текст = "
	|Выбрать Ссылка, ДокументПартии, Сумма(СуммаТовара) как Сумма Из 
	|Документ.ПоступлениеДопРасходов.Товары
	|Где (Ссылка.Дата между &Дата1 и &Дата2) и (Ссылка.Проведен = Истина)
	|Сгруппировать по Ссылка, ДокументПартии";
	
	Выб = Запрос.Выполнить().Выбрать();
	
	Макет = ПолучитьМакет("Макет");
	ТаблицаММ = новый ТаблицаЗначений;
	ТаблицаММ.Колонки.Добавить("Документ");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	СтрММ = Макет.ПолучитьОбласть("Строка");
	ЭлементыФормы.ДопРасходы.Вывести(Шапка);
	
	Пока Выб.Следующий() Цикл
		
		СуммаДопРасходов 	= Выб.Сумма;
		Попытка 
			СуммаДокПартии		= Выб.ДокументПартии.Товары.Итог("Сумма");
		Исключение
			СуммаДокПартии		= Выб.ДокументПартии.СуммаДокумента;
		Конецпопытки;
		ДокументПартии		= Выб.ДокументПартии;
		
		Если (СуммаДопРасходов <> СуммаДокПартии) Тогда 
		// Восстанавливаем	
			//Сообщить(Строка(Выб.Ссылка) + "    " + Строка(СуммаДопРасходов));
			//Сообщить(Строка(Выб.ДокументПартии) + "      " + Строка(СуммаДокПартии));
			Проводить = Ложь;
			Объект = Выб.Ссылка.получитьОбъект();
			МассивУд = новый Массив;
			Для каждого стр из Объект.Товары Цикл
				Если (стр.ДокументПартии = ДокументПартии) Тогда
					// Удаляем строки соотв. нашему документу партии
					МассивУд.Добавить(Стр);
					Проводить = Истина;
				КонецЕсли;
			КонецЦикла;
			
			//Для каждого Стр из МассивУд Цикл
			//	Объект.Товары.Удалить(Стр);
			//КонецЦикла;
			
			Если (Проводить) Тогда
				СтрТММ = ТаблицаММ.Добавить();
				СтрТММ.Документ = Объект.ССылка;
			//	Попытка 
			//		Объект.ЗаполнитьТоварыПоПоступлениюТоваров(ДокументПартии, Объект.Товары);
			//	Исключение
			//		;
			//	Конецпопытки;
			//	Объект.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
			
		КонецЕсли;
		                   
	КонецЦикла;
	
	ТаблицаММ.Свернуть("Документ");
	Для Каждого СтрТММ из ТаблицаММ Цикл
		СтрММ.Параметры.Документ = СтрТММ.Документ;
		ЭлементыФормы.ДопРасходы.Вывести(СтрММ);                    
	КонецЦикла;
	                                                     
	ЭлементыФормы.ДопРасходы.Показать();
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура ДопРасходыОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры
