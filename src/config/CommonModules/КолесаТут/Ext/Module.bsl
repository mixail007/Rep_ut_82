﻿
Процедура ВыгрузкаНоменклатурыKOLESATYT() Экспорт
	//попытка
		ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоКоду("545");//РЗ_Выгрузка номенклатуры на КОЛЕСАТУТ
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ВыгрузитьТовары(истина);
	//исключение
	//	ЗаписьЖурналаРегистрации("Выгрузка номенклатуры на КОЛЕСАТУТ",
	//	УровеньЖурналаРегистрации.Информация,
	//	,
	//	,
	//	ОписаниеОшибки(),
	//	);
	//КонецПопытки;
	
	//попытка
		ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоКоду("532");//РЗ_Выгрузить цены KOLESATYT.RU
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ВыгрузитьЦены(истина);
	//исключение
	//	ЗаписьЖурналаРегистрации("Выгрузить цены KOLESATYT.RU",
	//	УровеньЖурналаРегистрации.Информация,
	//	,
	//	,
	//	ОписаниеОшибки(),
	//	);
	//КонецПопытки;
КонецПроцедуры

Процедура ОтправитьЗаказыИМвТК() Экспорт
	//попытка
		ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоКоду("537");//РЗ_Отправить заказы ИМ в ТК
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ОтправитьЗаказы(ДобавитьМесяц(НачалоДня(ТекущаяДата()),-1),КонецДня(ТекущаяДата()));
	//исключение
	//	ЗаписьЖурналаРегистрации("Отправить заказы ИМ в ТК",
	//	УровеньЖурналаРегистрации.Информация,
	//	,
	//	,
	//	ОписаниеОшибки(),
	//	);
	//КонецПопытки;
КонецПроцедуры

Процедура МаркетологИМДействие() Экспорт
	ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоКоду("486");
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ПолучитьФорму("ФормаОтчета").Открыть();
КонецПроцедуры


Функция ПолучитьДатуОтгрузкиЗаказа(мДата, Заказ) экспорт
	ЕКБ = Справочники.Подразделения.НайтиПоКоду("00138");
	РНД = Справочники.Подразделения.НайтиПоКоду("00106");
	Спб = Справочники.Подразделения.НайтиПоКоду("00112");
	ЯШТ = Справочники.Подразделения.НайтиПоКоду("00005");
	Мск = Справочники.Подразделения.НайтиПоКоду("00133");
	
	ТранспортнаяКомпанияПодорожник = Справочники.Контрагенты.НайтиПоКоду("94346"); //Подорожник Транспортное Агентство
	ТранспортнаяКомпанияДПД = Справочники.Контрагенты.НайтиПоКоду("94121"); 	   //Армадилло Бизнес Посылка
	КонтрагентШинтрейд = Справочники.Контрагенты.НайтиПоКоду("П001549");           //ШинТрейд (вместо ШинТрейд СПб)
	КонтрагентРозница = Справочники.Контрагенты.НайтиПоКоду("94143"); 			   // Покупатель
	
	//ВремяОтсечки = ТекущаяДата();
	ВремяОтсечки = НачалоДня(мДата)+17*60*60;
	ДатаОтправки = ТекущаяДата();
	
	Если Заказ.ТранспортнаяКомпания = ТранспортнаяКомпанияПодорожник  тогда 
		//ВремяОтсечки = НачалоДня(мДата)+17*60*60 - 15*60;
		ВремяОтсечки = НачалоДня(мДата)+17*60*60;
		Если мДата<ВремяОтсечки тогда //отправляем сегодня
			ДатаОтправки = НачалоДня(мДата);
		Иначе
			ДатаОтправки = НачалоДня(мДата)+1*24*60*60;
		КонецЕсли;

	ИначеЕсли Заказ.ТранспортнаяКомпания = ТранспортнаяКомпанияДПД 
		или Заказ.Контрагент = КонтрагентШинтрейд тогда //ДПД или шинтрейд
		
		ДатаОтправки=Дата(1,1,1);
		
		Если  Заказ.Подразделение=ЕКБ тогда 
			ВремяОтсечки=НачалоДня(мДата)+12*60*60 + 30*60;
			//ВремяОтсечки=НачалоДня(мДата)+12*60*60;
		ИначеЕсли  Заказ.Подразделение=РНД тогда	 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;
		ИначеЕсли  Заказ.Подразделение=Спб тогда	 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;
		Иначе	 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60;	 //задача №19182 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;
		КонецЕсли;
		
		Если мДата<ВремяОтсечки тогда
			мДатаОтправки=НачалоДня(мДата);
		Иначе
			мДатаОтправки=КонецДня(мДата)+2;  //Переносим на след день
		КонецЕсли;
		
		мДатаОтправки=ПроверитьНаПраздники(мДатаОтправки);
		
		мДатаОтправки=КонецДня(мДатаОтправки);
		ДатаОтправки=?(ДатаОтправки<мДатаОтправки,мДатаОтправки,ДатаОтправки);
		
	ИначеЕсли Заказ.Контрагент = КонтрагентРозница тогда //Розница	
		
		ДатаОтправки=Дата(1,1,1);
		
		Если  Заказ.Подразделение=ЕКБ тогда 
			ВремяОтсечки=НачалоДня(мДата)+13*60*60;
			//ВремяОтсечки=НачалоДня(мДата)+12*60*60;
			
		ИначеЕсли  Заказ.Подразделение=РНД тогда	 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;
		ИначеЕсли  Заказ.Подразделение=Спб тогда	 
			//ВремяОтсечки=НачалоДня(мДата)+14*30*60 - 15*60;
			ВремяОтсечки=НачалоДня(мДата)+14*30*60;
			//ВремяОтсечки=НачалоДня(мДата)+16*30*60;
		ИначеЕсли  Заказ.Подразделение=Мск тогда	 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;	
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;	
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;	
		Иначе	 
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60+50*60;	//задача №19182 
			//ВремяОтсечки=НачалоДня(мДата)+17*60*60 - 15*60;	 
			ВремяОтсечки=НачалоДня(мДата)+17*60*60;	 
			//ВремяОтсечки=НачалоДня(мДата)+16*60*60;	 
		КонецЕсли;
		
		Если мДата<ВремяОтсечки тогда
			мДатаОтправки=НачалоДня(мДата);
		Иначе
			мДатаОтправки=КонецДня(мДата)+2;  //Переносим на след день
		КонецЕсли;
		
		мДатаОтправки=ПроверитьНаПраздники(мДатаОтправки);
		
		мДатаОтправки=КонецДня(мДатаОтправки);
		ДатаОтправки=?(ДатаОтправки<мДатаОтправки,мДатаОтправки,ДатаОтправки);
	КонецЕсли;
	
	ДатаОтправки=ПроверитьНаПраздники(ДатаОтправки);
	СтруктураОтправки = новый структура("ДатаОтправки,ВремяОтсечки",ДатаОтправки,ВремяОтсечки);
	Возврат СтруктураОтправки;
	
КонецФункции

Функция ПроверитьНаПраздники(Дат,СубботаРабочийДень=ложь, ВоскресеньеРабочийДень=ложь) Экспорт
	ДатаОтгрузки=Дат;
	
	МенеджерЗаписи = РегистрыСведений.РегламентированныйПроизводственныйКалендарь.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Год = Год(ДатаОтгрузки);
	МенеджерЗаписи.ДатаКалендаря = ДатаОтгрузки;
	МенеджерЗаписи.Прочитать();
	Если МенеджерЗаписи.Выбран() тогда
		Если (МенеджерЗаписи.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота и не СубботаРабочийДень) или
			(МенеджерЗаписи.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье и не ВоскресеньеРабочийДень) или 
			МенеджерЗаписи.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник тогда
			возврат ПроверитьНаПраздники(КонецДня(Дат)+1,СубботаРабочийДень,ВоскресеньеРабочийДень);
		иначе
			возврат ДатаОтгрузки;
		КонецЕсли;	
	КонецЕсли;
КонецФункции

Функция ПолучитьСебестоимостьЗаказов(СписокЗаказов) экспорт
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("СписокЗаказов", СписокЗаказов);
	ТексЗапросаБонусы =  ПолучитьБонусы(ложь).ТекстЗапросаБонусы;
	Запрос.Текст = ТексЗапросаБонусы+ "
	|;"+	"ВЫБРАТЬ
	    	|	ЗаказПокупателя.Ссылка
	    	|ПОМЕСТИТЬ втИсходныеЗаказы
	    	|ИЗ
	    	|	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	    	|ГДЕ
	    	|	ЗаказПокупателя.Ссылка В(&СписокЗаказов)
	    	|;
	    	|
	    	|////////////////////////////////////////////////////////////////////////////////
	    	|ВЫБРАТЬ
	    	|	А.ЗаказОбъединенный,
	    	|	А.ЗаказИсходный
	    	|ПОМЕСТИТЬ втОбъединенныеЗаказы
	    	|ИЗ
	    	|	(ВЫБРАТЬ
	    	|		ЗаказПокупателяЗаказы.Ссылка КАК ЗаказОбъединенный,
	    	|		ЗаказПокупателяЗаказы.ЗаказПокупателя КАК ЗаказИсходный
	    	|	ИЗ
	    	|		втИсходныеЗаказы КАК втИсходныеЗаказы
	    	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.Заказы КАК ЗаказПокупателяЗаказы
	    	|			ПО втИсходныеЗаказы.Ссылка = ЗаказПокупателяЗаказы.ЗаказПокупателя
	    	|	ГДЕ
	    	|		ЗаказПокупателяЗаказы.Ссылка.Проведен
	    	|	
	    	|	ОБЪЕДИНИТЬ ВСЕ
	    	|	
	    	|	ВЫБРАТЬ
	    	|		втИсходныеЗаказы.Ссылка,
	    	|		втИсходныеЗаказы.Ссылка
	    	|	ИЗ
	    	|		втИсходныеЗаказы КАК втИсходныеЗаказы) КАК А
	    	|ГДЕ
	    	|	А.ЗаказОбъединенный.Проведен
	    	|;
	    	|
	    	|////////////////////////////////////////////////////////////////////////////////
	    	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	    	|	ПродажиСебестоимостьОбороты.ЗаказПокупателя,
	    	|	ПродажиСебестоимостьОбороты.Номенклатура КАК Номенклатура,
	    	|	СУММА(ПродажиСебестоимостьОбороты.КоличествоОборот) КАК КоличествоОборот,
	    	|	СУММА(ПродажиСебестоимостьОбороты.СтоимостьОборот) КАК СтоимостьОборот,
	    	|	ПродажиСебестоимостьОбороты.Период
	    	|ПОМЕСТИТЬ вт
	    	|ИЗ
	    	|	РегистрНакопления.ПродажиСебестоимость.Обороты(
	    	|			,
	    	|			,
	    	|			Регистратор,
	    	|			ЗаказПокупателя В
	    	|				(ВЫБРАТЬ
	    	|					втОбъединенныеЗаказы.ЗаказОбъединенный
	    	|				ИЗ
	    	|					втОбъединенныеЗаказы)) КАК ПродажиСебестоимостьОбороты
	    	|ГДЕ
	    	|	ПродажиСебестоимостьОбороты.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	    	|
	    	|СГРУППИРОВАТЬ ПО
	    	|	ПродажиСебестоимостьОбороты.ЗаказПокупателя,
	    	|	ПродажиСебестоимостьОбороты.Номенклатура,
	    	|	ПродажиСебестоимостьОбороты.Период
	    	|;
	    	|
	    	|////////////////////////////////////////////////////////////////////////////////
	    	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	    	|	вт.Номенклатура,
	    	|	вт.Период
	    	|ПОМЕСТИТЬ втПродажи
	    	|ИЗ
	    	|	вт КАК вт
	    	|;
	    	|
	    	|////////////////////////////////////////////////////////////////////////////////
	    	|ВЫБРАТЬ
	    	|	А.Номенклатура,
	    	|	МИНИМУМ(втБонусы.Бонус) КАК Бонус,
	    	|	А.ПериодРеализации
	    	|ПОМЕСТИТЬ втБонусыПоНоменклатуре
	    	|ИЗ
	    	|	(ВЫБРАТЬ
	    	|		втПродажи.Период КАК ПериодРеализации,
	    	|		втПродажи.Номенклатура КАК Номенклатура,
	    	|		МАКСИМУМ(втБонусы.Период) КАК ПериодБонуса
	    	|	ИЗ
	    	|		втПродажи КАК втПродажи
	    	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ втБонусы КАК втБонусы
	    	|			ПО втПродажи.Номенклатура = втБонусы.Номенклатура
	    	|				И втПродажи.Период >= втБонусы.Период
	    	|	
	    	|	СГРУППИРОВАТЬ ПО
	    	|		втПродажи.Период,
	    	|		втПродажи.Номенклатура) КАК А
	    	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втБонусы КАК втБонусы
	    	|		ПО А.Номенклатура = втБонусы.Номенклатура
	    	|			И А.ПериодБонуса = втБонусы.Период
	    	|
	    	|СГРУППИРОВАТЬ ПО
	    	|	А.Номенклатура,
	    	|	А.ПериодРеализации
	    	|;
	    	|
	    	|////////////////////////////////////////////////////////////////////////////////
	    	|ВЫБРАТЬ
	    	|	ВЫБОР
	    	|		КОГДА вт.Номенклатура ЕСТЬ NULL 
	    	|			ТОГДА 0
	    	|		ИНАЧЕ ВЫРАЗИТЬ(ВЫБОР
	    	|					КОГДА вт.КоличествоОборот <> 0
	    	|						ТОГДА вт.СтоимостьОборот / вт.КоличествоОборот
	    	|					ИНАЧЕ 0
	    	|				КОНЕЦ КАК ЧИСЛО(15, 0))
	    	|	КОНЕЦ КАК Себестоимость,
	    	|	взТоварыИсходногоЗаказа.ЗаказИсходный КАК ЗаказПокупателя,
	    	|	взТоварыИсходногоЗаказа.Номенклатура.Код КАК НоменклатураКод,
	    	|	ВЫБОР
	    	|		КОГДА вт.Номенклатура ЕСТЬ NULL 
	    	|			ТОГДА 0
	    	|		ИНАЧЕ ВЫРАЗИТЬ(ВЫБОР
	    	|					КОГДА вт.КоличествоОборот <> 0
	    	|						ТОГДА вт.СтоимостьОборот / вт.КоличествоОборот
	    	|					ИНАЧЕ 0
	    	|				КОНЕЦ - ВЫБОР
	    	|					КОГДА вт.КоличествоОборот <> 0
	    	|						ТОГДА вт.СтоимостьОборот / вт.КоличествоОборот
	    	|					ИНАЧЕ 0
	    	|				КОНЕЦ / 1.18 * ЕСТЬNULL(втБонусыПоНоменклатуре.Бонус, 0) / 100 КАК ЧИСЛО(15, 0))
	    	|	КОНЕЦ КАК СебестоимостьСУчетомБонуса,
	    	|	взТоварыИсходногоЗаказа.Цена
	    	|ИЗ
	    	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	    	|		ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
	    	|		втОбъединенныеЗаказы.ЗаказОбъединенный КАК ЗаказОбъединенный,
	    	|		втОбъединенныеЗаказы.ЗаказИсходный КАК ЗаказИсходный,
	    	|		МАКСИМУМ(ЗаказПокупателяТовары.Цена) КАК Цена
	    	|	ИЗ
	    	|		втОбъединенныеЗаказы КАК втОбъединенныеЗаказы
	    	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	    	|			ПО втОбъединенныеЗаказы.ЗаказИсходный = ЗаказПокупателяТовары.Ссылка
	    	|	
	    	|	СГРУППИРОВАТЬ ПО
	    	|		ЗаказПокупателяТовары.Номенклатура,
	    	|		втОбъединенныеЗаказы.ЗаказОбъединенный,
	    	|		втОбъединенныеЗаказы.ЗаказИсходный) КАК взТоварыИсходногоЗаказа
	    	|		ЛЕВОЕ СОЕДИНЕНИЕ вт КАК вт
	    	|			ЛЕВОЕ СОЕДИНЕНИЕ втБонусыПоНоменклатуре КАК втБонусыПоНоменклатуре
	    	|			ПО вт.Номенклатура = втБонусыПоНоменклатуре.Номенклатура
	    	|				И вт.Период = втБонусыПоНоменклатуре.ПериодРеализации
	    	|		ПО взТоварыИсходногоЗаказа.ЗаказОбъединенный = вт.ЗаказПокупателя
	    	|			И взТоварыИсходногоЗаказа.Номенклатура = вт.Номенклатура";
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

Процедура ОбнулитьЛимитОтгрузкиИМ() Экспорт
	//попытка
		ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоНаименованию("РЗ_Обнулить лимит отгрузки ИМ");
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ОбнулитьЛимитИМ();
	//исключение
	//	ЗаписьЖурналаРегистрации("Обнулить лимит отгрузки ИМ",
	//	УровеньЖурналаРегистрации.Информация,
	//	,
	//	,
	//	ОписаниеОшибки(),
	//	);
	//КонецПопытки;
КонецПроцедуры


Процедура ОтправитьКомпенсацииВПИТСТОП() Экспорт
	//попытка
		ТекСсылка=Справочники.ВнешниеОбработки.НайтиПоНаименованию("РЗ_Отправить компенсации в ПИТСТОП");
		ИмяФайла = ПолучитьИмяВременногоФайла(); 
		ДвоичныеДанные = ТекСсылка.ХранилищеВнешнейОбработки.Получить(); 
		ДвоичныеДанные.Записать(ИмяФайла); 
		Если ТекСсылка.ВидОбработки = Перечисления.ВидыДополнительныхВнешнихОбработок.Отчет Тогда 
			Обработка = ВнешниеОтчеты.Создать(ИмяФайла,ложь); 
		Иначе 
			Обработка = ВнешниеОбработки.Создать(ИмяФайла,Ложь); 
		КонецЕсли;
		Обработка.ОформитьКомпенсации();
		Обработка.ОформитьВозвраты();
	//исключение
	//	ЗаписьЖурналаРегистрации("Обнулить лимит отгрузки ИМ",
	//	УровеньЖурналаРегистрации.Информация,
	//	,
	//	,
	//	ОписаниеОшибки(),
	//	);
	//КонецПопытки;
КонецПроцедуры


