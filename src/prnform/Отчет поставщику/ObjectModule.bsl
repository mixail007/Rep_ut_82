﻿Функция Печать() Экспорт
	
	ТабДокумент = ПечатьПоЗаказуПокупателя();
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт; 
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;
			
КонецФункции // Печать

Функция ПечатьПоЗаказуПокупателя()
	ТабДокумент = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("Макет");
	Если СсылкаНаОбъект.поставщик = Справочники.Контрагенты.НайтиПоКоду("91735") тогда 
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Областьстроки = Макет.ПолучитьОбласть("Строка");
    иначе
	Шапка = Макет.ПолучитьОбласть("Шапка1");
	Областьстроки = Макет.ПолучитьОбласть("Строка1");
    КонецЕсли;	
	
	Шапка.Параметры.Поставщик = СсылкаНаОбъект.Поставщик;
	Шапка.Параметры.НомерКонтейнера = СсылкаНаобъект.Контейнер;
		ТабДокумент.Вывести(Шапка);
	
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроверкаНагрузкиДисковТовары.Номенклатура.Код КАК Код,
		|	ПроверкаНагрузкиДисковТовары.Номенклатура КАК Номенклатура,
		|	ПроверкаНагрузкиДисковТовары.Количество КАК Количество,
		|	ПроверкаНагрузкиДисковТовары.Дата1,
		|	ПроверкаНагрузкиДисковТовары.Результат1,
		|	ПроверкаНагрузкиДисковТовары.ТестПройден1,
		|	ПроверкаНагрузкиДисковТовары.Дата2,
		|	ПроверкаНагрузкиДисковТовары.Результат2,
		|	ПроверкаНагрузкиДисковТовары.ТестПройден2,
		|	ПроверкаНагрузкиДисковТовары.Дата3,
		|	ПроверкаНагрузкиДисковТовары.Результат3,
		|	ПроверкаНагрузкиДисковТовары.ТестПройден3,
		|	ПроверкаНагрузкиДисковТовары.Комментарий,
		|	ПроверкаНагрузкиДисковТовары.Цена,
		|	ПроверкаНагрузкиДисковТовары.СуммаКомпенсации
		|ИЗ
		|	Документ.ПроверкаНагрузкиДисков.Товары КАК ПроверкаНагрузкиДисковТовары
		|ГДЕ
		|	ПроверкаНагрузкиДисковТовары.Ссылка = &Ссылка
		|	И ПроверкаНагрузкиДисковТовары.СуммаКомпенсации > 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПроверкаНагрузкиДисковТовары.НомерСтроки";
		
	Запрос.УстановитьПараметр("Дата", СсылкаНаОбъект.ДокументОснование.Сделка.Дата);                                  
    Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);                                  
	Результат = Запрос.Выполнить();                                                                        

	ВыборкаДетальныеЗаписи = Результат.Выгрузить();
		
	Для каждого стр из ВыборкаДетальныеЗаписи Цикл
			//ЗаполнитьЗначенияСвойств(Областьстроки, ВыборкаДетальныеЗаписи); 
			Областьстроки.Параметры.Заполнить(стр);			
			Областьстроки.Параметры.Код = стр.Код;
			Областьстроки.Параметры.ЦенаФОБ8 =0;
			Областьстроки.Параметры.Штраф =0;
				
				Если стр.ТестПройден1 = Истина и ЗначениеЗаполнено(стр.Результат1) Тогда
				Областьстроки.Параметры.ТестПройден1 ="passed";
			иначеЕсли ЗначениеЗаполнено(стр.Результат1) Тогда
				Областьстроки.Параметры.ТестПройден1 ="no passed";
			иначе	
				Областьстроки.Параметры.ТестПройден1 ="";
			конецесли;
			
            Если стр.ТестПройден2 = Истина и ЗначениеЗаполнено(стр.Результат2) Тогда
				Областьстроки.Параметры.ТестПройден2 ="passed";
			иначеЕсли ЗначениеЗаполнено(стр.Результат2) Тогда
				Областьстроки.Параметры.ТестПройден2 ="no passed";
			иначе	
				Областьстроки.Параметры.ТестПройден2 ="";
			конецесли;
			Если стр.ТестПройден3 = Истина и ЗначениеЗаполнено(стр.Результат3) Тогда
				Областьстроки.Параметры.ТестПройден3 ="passed";
			иначеЕсли	ЗначениеЗаполнено(стр.Результат3) Тогда
				Областьстроки.Параметры.ТестПройден3 ="no passed";
			иначе	
				Областьстроки.Параметры.ТестПройден3 ="";
			конецесли;
               Если (?(ЗначениеЗаполнено(стр.Результат1),стр.ТестПройден1,1)+?(ЗначениеЗаполнено(стр.Результат2),стр.ТестПройден2,1)+?(ЗначениеЗаполнено(стр.Результат3),стр.ТестПройден3,1)=2 или ?(ЗначениеЗаполнено(стр.Результат1),стр.ТестПройден1,1)+?(ЗначениеЗаполнено(стр.Результат2),стр.ТестПройден2,1)+?(ЗначениеЗаполнено(стр.Результат3),стр.ТестПройден3,1)=1)и СсылкаНаОбъект.поставщик = Справочники.Контрагенты.НайтиПоКоду("91735") тогда
				Если стр.количество>8 тогда   
				Областьстроки.Параметры.ЦенаФОБ8 =8*стр.цена;
				Областьстроки.Параметры.Штраф =(стр.количество-8)*5;
			иначе
				Областьстроки.Параметры.ЦенаФОБ8 =стр.количество*стр.цена;
				Областьстроки.Параметры.Штраф =0;
				конецЕсли;
			   конецЕсли;
			
			
			ТабДокумент.Вывести(Областьстроки);
		
		
	КонецЦикла;

Возврат ТабДокумент;	
	
КонецФункции