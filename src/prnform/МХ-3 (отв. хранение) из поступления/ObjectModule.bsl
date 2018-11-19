﻿
Перем КоличествоСтрокНаЛисте;
Перем КоличествоСтрокШапки;
Перем КоличествоСтрокПодвала;	
Перем КоличествоСтрокШапкиВторойСтраницы;

Функция ПолучитьСуммуПрописью(ВсегоКоличество,ВсегоСумма, ВалютаДокумента)
	СтрокаВозврата = "Всего получено: " + Лев(ЧислоПрописью(ВсегоКоличество,"НД=ложь"),Найти(ЧислоПрописью(ВсегоКоличество,"НД=ложь"),"00") - 1) + "единиц(ы) товара. На сумму: " + ЧислоПрописью(ВсегоСумма, ,ВалютаДокумента.ПараметрыПрописиНаРусском);	
	Возврат СтрокаВозврата;
КонецФункции

Процедура УстановитьЗначенияКоличестваСтрокНаЛисте()
	КоличествоСтрокНаЛисте	= 57;
	КоличествоСтрокШапки 	= 28;
	КоличествоСтрокПодвала	= 33;	
	КоличествоСтрокШапкиВторойСтраницы = 6;
КонецПроцедуры

// Функция берет реквизиты шапки документа и возвращает структуру.
Функция ЗаполнитьРеквизитыШапки(ДокументСсылка)
	СтруктураШапки = Новый Структура;
	ЗапросПоРеквизитам = Новый Запрос;
	ЗапросПоРеквизитам.УстановитьПараметр("Ссылка",ДокументСсылка);
	ЗапросПоРеквизитам.Текст = "
	|ВЫБРАТЬ
	|		Организация,
	|		Контрагент,
	| 		Номер,	
	|		Дата
	|ИЗ 	Документ.ПоступлениеТоваровУслуг как Док	 
	|ГДЕ    Док.Ссылка = &Ссылка";
	
	Шапка = ЗапросПоРеквизитам.Выполнить().Выбрать();
	Если Шапка.Следующий() Тогда
		СведенияОбОрганизации 				= СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
		СведенияОПоклажедателе 				= "";
		Если не ЗначениеНеЗаполнено(Шапка.Контрагент) Тогда
		СведенияОПоклажедателе 				= СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.Дата);
		КонецЕсли;

	    ПредставлениеОрганизации 			= ОписаниеОрганизации(СведенияОбОрганизации,"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		ПредставлениеПоклажедателя     		= ОписаниеОрганизации(СведенияОПоклажедателе);
		Валюта								= Шапка.Организация.ОсновнойБанковскийСчет.ВалютаДенежныхСредств;
		СтруктураШапки.Вставить("Организация",ПредставлениеОрганизации);
		СтруктураШапки.Вставить("Поклажедатель",ПредставлениеПоклажедателя);
		СтруктураШапки.Вставить("Номер",Шапка.Номер);
		СтруктураШапки.Вставить("Дата",Формат(Шапка.Дата,"ДФ = ""дд.мм.гггг"""));
		СтруктураШапки.Вставить("Валюта",Валюта);
		Возврат СтруктураШапки;
	КонецЕсли; 
	Возврат Неопределено;
КонецФункции

Функция ПечатьДокумента(СтруктураШапки,ДокументОприходования,КоличествоКопий=1,НаПринтер=Истина);
	
	ЗапросПоТоварам = Новый Запрос;
	ЗапросПоТоварам.УстановитьПараметр("Ссылка",ДокументОприходования);
	ЗапросПоТоварам.УстановитьПараметр("Дата",ДокументОприходования.Дата);
	ТабДок = новый ТабличныйДокумент;
	
	
	
	ЗапросПоТоварам.Текст =   "ВЫБРАТЬ
	                          |	Док.Наименование КАК Наименование,
	                          |	Док.Код КАК Код,
	                          |	Док.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	                          |	Док.КодЕдиницы КАК КодЕдиницы,
	                          |	Док.Количество КАК Количество,
	                          |	Док.Цена КАК Цена,
	                          |	Док.Сумма КАК Сумма
	                          |ИЗ
	                          |	(ВЫБРАТЬ
	                          |		ПоступлениеТоваровУслугТовары.Номенклатура.Наименование КАК Наименование,
	                          |		ПоступлениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
	                          |		ПоступлениеТоваровУслугТовары.Номенклатура.Код КАК Код,
	                          |		ПоступлениеТоваровУслугТовары.Номенклатура.БазоваяЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	                          |		ПоступлениеТоваровУслугТовары.Номенклатура.БазоваяЕдиницаИзмерения.Код КАК КодЕдиницы,
	                          |		ПоступлениеТоваровУслугТовары.Склад КАК Склад,
	                          |		ПоступлениеТоваровУслугТовары.Количество КАК Количество,
	                          |		ПоступлениеТоваровУслугТовары.Цена КАК Цена,
	                          |		ПоступлениеТоваровУслугТовары.Сумма КАК Сумма
	                          |	ИЗ
	                          |		Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
	                          |	ГДЕ
	                          |		ПоступлениеТоваровУслугТовары.Ссылка = &Ссылка) КАК Док
	                          |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                          |			ТоварыНаОтветственномХранении.Номенклатура КАК Номенклатура,
	                          |			ТоварыНаОтветственномХранении.Склад КАК Склад,
	                          |			ВЫБОР
	                          |				КОГДА ТоварыНаОтветственномХранении.Количество > 0
	                          |					ТОГДА ВЫРАЗИТЬ(ТоварыНаОтветственномХранении.Стоимость / ТоварыНаОтветственномХранении.Количество КАК ЧИСЛО(15, 2))
	                          |				ИНАЧЕ 0
	                          |			КОНЕЦ КАК Цена,
	                          |			ТоварыНаОтветственномХранении.Стоимость КАК Сумма
	                          |		ИЗ
	                          |			РегистрНакопления.ТоварыНаОтветственномХранении КАК ТоварыНаОтветственномХранении
	                          |		ГДЕ
	                          |			ТоварыНаОтветственномХранении.Регистратор = &Ссылка) КАК ТоварыНаОтветственномХранении
	                          |		ПО Док.Номенклатура = ТоварыНаОтветственномХранении.Номенклатура
	                          |			И Док.Склад = ТоварыНаОтветственномХранении.Склад";

	
	Выборка = ЗапросПоТоварам.Выполнить().Выбрать();
	
	Если (Выборка.Количество()>0) Тогда 
		Если (Выборка.Количество() + КоличествоСтрокШапки + КоличествоСтрокПодвала)> КоличествоСтрокНаЛисте Тогда	 		
			// Многостраничный вывод
			// Первая страница
        	МакетОсновной 							= ПолучитьМакет("МакетПервойСтраницы");
			МакетОстальные 							= ПолучитьМакет("МакетВторойСтраницы");
			ШапкаОсновная							= МакетОсновной.ПолучитьОбласть("Шапка");
			ШапкаОсновная.Параметры.Организация 	= СтруктураШапки.Организация;
			ШапкаОсновная.Параметры.Поклажедатель 	= СтруктураШапки.Поклажедатель;
			ШапкаОсновная.Параметры.Номер 			= СтруктураШапки.Номер;				
			ШапкаОсновная.Параметры.Дата 			= ДокументОприходования.Дата;	
			ШапкаОсновная.Параметры.Страница		= "Страница 1";
			ТабДок.Вывести(ШапкаОсновная);
			СтрокаОсновная							= МакетОсновной.ПолучитьОбласть("Строка");
			Номер 									= 1;
			ИтогоКоличество 						= 0;
			ИтогоСумма 								= 0;
			НомерПозиции							= КоличествоСтрокШапки + 1;
			КоличествоВВыборке						= Выборка.Количество();
			
			Условие = Выборка.Следующий();
			Пока (Условие) и (НомерПозиции<=(КоличествоСтрокНаЛисте)) Цикл
				СтрокаОсновная.Параметры.Номер 			= 	Номер;
				СтрокаОсновная.Параметры.Наименование 	= 	Выборка.Наименование;
				СтрокаОсновная.Параметры.Код			=	Выборка.Код;
				СтрокаОсновная.Параметры.ЕдНаим			=   Выборка.ЕдиницаИзмерения;
				СтрокаОсновная.Параметры.ЕдКод			= 	Выборка.КодЕдиницы;
				СтрокаОсновная.Параметры.Количество		= 	Выборка.Количество;
				СтрокаОсновная.Параметры.Цена			= 	Выборка.Цена;
				СтрокаОсновная.Параметры.Стоимость		= 	Выборка.Сумма;
				Номер 									= 	Номер 	+ 1;
				ИтогоКоличество 						= 	ИтогоКоличество 	+ Выборка.Количество;
				ИтогоСумма 								= 	ИтогоСумма		+ Выборка.Сумма;
				ТабДок.Вывести(СтрокаОсновная);
				НомерПозиции							= 	НомерПозиции + 1;
				Условие 								= 	Выборка.Следующий();
				КоличествоВВыборке						= 	КоличествоВВыборке - 1;
			КонецЦикла;
			СтрокаИтого 							= МакетОсновной.ПолучитьОбласть("СтрокаИтого"); 
			СтрокаИтого.Параметры.ИтогоКоличество 	= ИтогоКоличество;
			СтрокаИтого.Параметры.ИтогоСтоимость 	= ИтогоСумма;
			ТабДок.Вывести(СтрокаИтого);
			// Остальные страницы
			ВсегоКоличество 						= ИтогоКоличество;
			ВсегоСумма								= ИтогоСумма;
			ИтогоКоличество							= 0;
			ИтогоСумма								= 0;
			Страница 								= 1;

			Если (Условие) Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				Страница 								= Страница 								+ 1;
				НомерПозиции = КоличествоСтрокШапкиВторойСтраницы;
				ШапкаВторая								= МакетОстальные.ПолучитьОбласть("Шапка");
				ШапкаВторая.Параметры.Страница			= "Страница " + Строка(Страница);
				ТабДок.Вывести(ШапкаВторая);			
				СтрокаОстальные							= МакетОстальные.ПолучитьОбласть("Строка");			
				Условие 								= Истина;				
				НачалоСтраницы = Ложь;
				
				Пока Условие Цикл								
					СтрокаОстальные.Параметры.Номер 			= 	Номер;
					СтрокаОстальные.Параметры.Наименование 		= 	Выборка.Наименование;
					СтрокаОстальные.Параметры.Код				=	Выборка.Код;
					СтрокаОстальные.Параметры.ЕдНаим			=   Выборка.ЕдиницаИзмерения;
					СтрокаОстальные.Параметры.ЕдКод				= 	Выборка.КодЕдиницы;
					СтрокаОстальные.Параметры.Количество		= 	Выборка.Количество;
					СтрокаОстальные.Параметры.Цена				= 	Выборка.Цена;
					СтрокаОстальные.Параметры.Стоимость			= 	Выборка.Сумма;
					Номер 										= 	Номер 	+ 1;
					ИтогоКоличество 							= 	ИтогоКоличество 	+ Выборка.Количество;
					ИтогоСумма 									= 	ИтогоСумма			+ Выборка.Сумма;
					ТабДок.Вывести(СтрокаОстальные);
					НомерПозиции								= НомерПозиции + 1;
					Если ((НомерПозиции>=(КоличествоСтрокНаЛисте))) Тогда
				// Выведем итого
						НомерПозиции 							= КоличествоСтрокШапкиВторойСтраницы;
						СтрокаИтого 							= МакетОсновной.ПолучитьОбласть("СтрокаИтого"); 
						СтрокаИтого.Параметры.ИтогоКоличество 	= ИтогоКоличество;
						СтрокаИтого.Параметры.ИтогоСтоимость 	= ИтогоСумма;
						ВсегоСумма 								= ВсегоСумма + ИтогоСумма;
						ВсегоКоличество 						= ВсегоКоличество + ИтогоКоличество;
						ТабДок.Вывести(СтрокаИтого);
						ИтогоКоличество 						= 0;
						ИтогоСумма 								= 0;					
						НачалоСтраницы = Истина;
					КонецЕсли;
					Условие 									= Выборка.Следующий(); 
					КоличествоВВыборке						= 	КоличествоВВыборке - 1;
					Если (Условие и НачалоСтраницы) Тогда
						ТабДок.ВывестиГоризонтальныйРазделительСтраниц();	
						Страница								= Страница + 1;
						ШапкаВторая.Параметры.Страница			= "Страница " + Строка(Страница);
						ТабДок.Вывести(ШапкаВторая);			
						НачалоСтраницы 							= Ложь;
					ИначеЕсли((Не(Условие))) Тогда 
						СтрокаИтого 							= МакетОсновной.ПолучитьОбласть("СтрокаИтого"); 
						СтрокаИтого.Параметры.ИтогоКоличество 	= ИтогоКоличество;
						СтрокаИтого.Параметры.ИтогоСтоимость 	= ИтогоСумма;
						ВсегоСумма 								= ВсегоСумма + ИтогоСумма;
						ВсегоКоличество 						= ВсегоКоличество + ИтогоКоличество;
						ТабДок.Вывести(СтрокаИтого);						
					КонецЕсли;	
				КонецЦикла;
				КонецЕсли; 				
				// Выводим последний подвал
					//ВсегоКоличество = ВсегоКоличество + ИтогоКоличество;
					//ВсегоСумма = ВсегоСумма + ИтогоСумма;
					СтрокаИтого									= МакетОстальные.ПолучитьОбласть("СтрокаИтого");  
					СтрокаИтого.Параметры.АктКоличество	 		= ВсегоКоличество;
					СтрокаИтого.Параметры.АктСтоимость 			= ВсегоСумма;			
					ТабДок.Вывести(СтрокаИтого);
					Подвал										= МакетОстальные.ПолучитьОбласть("Подвал");
					Если ((НомерПозиции + КоличествоСтрокПодвала)>КоличествоСтрокНаЛисте) Тогда
						ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
						Подвал.Параметры.Страница				= "Страница " + Строка(Страница + 1);
					КонецЕсли;
					СуммаПрописью = ПолучитьСуммуПрописью(ВсегоКоличество,ВсегоСумма, СтруктураШапки.Валюта);
					Подвал.Параметры.Принято					= СуммаПрописью; 
					ТабДок.Вывести(Подвал);
		Иначе
			// Одностраничный вывод 
			Макет 		= ПолучитьМакет("МакетПервойСтраницы");
			МакетВторой = ПолучитьМакет("МакетВторойСтраницы");
			Шапка = Макет.ПолучитьОбласть("Шапка");
			Шапка.Параметры.Организация = СтруктураШапки.Организация;
			Шапка.Параметры.Поклажедатель = СтруктураШапки.Поклажедатель;
			Шапка.Параметры.Номер = СтруктураШапки.Номер;				
			Шапка.Параметры.Дата = СтруктураШапки.Дата;	
			ТабДок.Вывести(Шапка);
			Строка = Макет.ПолучитьОбласть("Строка");
			Номер 			= 1;
			ИтогоКоличество = 0;
			ИтогоСумма 		= 0;
			Пока Выборка.Следующий() Цикл
				Строка.Параметры.Номер 			= 	Номер;
				Строка.Параметры.Наименование 	= 	Выборка.Наименование;
				Строка.Параметры.Код			=	Выборка.Код;
				Строка.Параметры.ЕдНаим			=   Выборка.ЕдиницаИзмерения;
				Строка.Параметры.ЕдКод			= 	Выборка.КодЕдиницы;
				Строка.Параметры.Количество		= 	Выборка.Количество;
				Строка.Параметры.Цена			= 	Выборка.Цена;
				Строка.Параметры.Стоимость		= 	Выборка.Сумма;
				Номер 					= 	Номер 	+ 1;
				ИтогоКоличество = ИтогоКоличество 	+ Выборка.Количество;
				ИтогоСумма 		= ИтогоСумма		+ Выборка.Сумма;
				ТабДок.Вывести(Строка);
			КонецЦикла;
			СтрокаИтого 							= Макет.ПолучитьОбласть("СтрокаИтого"); 
			СтрокаИтого.Параметры.ИтогоКоличество 	= ИтогоКоличество;
			СтрокаИтого.Параметры.ИтогоСтоимость 	= ИтогоСумма;
			ТабДок.Вывести(СтрокаИтого);
			СтрокаИтого 							= МакетВторой.ПолучитьОбласть("СтрокаИтого"); 
			СтрокаИтого.Параметры.АктКоличество		= ИтогоКоличество;
			СтрокаИтого.Параметры.АктСтоимость		= ИтогоСумма;
			ТабДок.Вывести(СтрокаИтого);
			СуммаПрописью = ПолучитьСуммуПрописью(ИтогоКоличество,ИтогоСумма, СтруктураШапки.Валюта);
			Подвал 									= Макет.ПолучитьОбласть("Подвал");  
			Подвал.Параметры.Принято				= СуммаПрописью; 
			ТабДок.Вывести(Подвал);
		КонецЕсли;		
		ТабДок.АвтоМасштаб	=	Истина;
		Возврат ТабДок;
	КонецЕсли;
	
КонецФункции

Функция Печать() Экспорт
	
	//Если СсылкаНаОбъект.ВидОперации=Перечисления.ВидыОперацийПоОтветственномуХранению.Списание  Тогда
		УстановитьЗначенияКоличестваСтрокНаЛисте();
		СтруктураШапки = ЗаполнитьРеквизитыШапки(СсылкаНаОбъект);
		Если СтруктураШапки<>Неопределено Тогда
			Возврат ПечатьДокумента(СтруктураШапки,СсылкаНаОбъект,1,Ложь);
		КонецЕсли;
	//КОнецЕсли;
КонецФункции
