﻿Перем СоответствиеМесяцев;

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Настройки = КомпоновщикНастроек.Настройки;
	//НастройкаПериода = Настройки.ПараметрыДанных.Элементы.Найти("Период");
	//НастройкаПериода.Значение.ДатаНачала = ДатаНачала;
	//НастройкаПериода.Значение.ДатаОкончания = ДатаОкончания;
	ПараметрДанных= КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СтоимостьРынок");
	ПараметрДанных.Значение = СуммаРыночная;
	ПараметрДанных.Использование=Истина;
	
	ВнещнийНабор = Новый Структура("ТаблицаРезультатов",ТаблицаРезультатов(ДатаНачала,ДатаОкончания));
	
	
	////нныеРасшифровки = Неопределено;
	//ДанныеРасшифровки =Новый ДанныеРасшифровкиКомпоновкиДанных;
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	//МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ДанныеРасшифровки);
	//
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	//МакетКомпоновки  = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,Настройки,ДанныеРасшифровки);
	//
	//ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,ВнещнийНабор);
	//
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	//ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	//ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
		//Получаем схему из макета
	//СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");

	//Из схемы возьмем настройки по умолчанию
	//Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);

	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнещнийНабор, ДанныеРасшифровки);

	//Очищаем поле табличного документа
	ДокументРезультат.Очистить();

	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);   
	

КонецПроцедуры

Функция ТаблицаРезультатов(ДатаНачала,ДатаОкончания)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗатратыОбороты.Заказ.Контрагент,
		|	ЗатратыОбороты.Подразделение,
		|	ЗатратыОбороты.СтатьяЗатрат,
		|	ЗатратыОбороты.НоменклатурнаяГруппа,
		|	ЗатратыОбороты.Заказ,
		|	ЗатратыОбороты.СтатьяЗатратУпр,
		|	СУММА(ЗатратыОбороты.СуммаОборот) КАК СуммаОборот,
		|	СРЕДНЕЕ(ЗатратыОбороты.Регистратор.СуммаДокумента) КАК РегистраторСуммаДокумента,
		|	ЗатратыОбороты.Регистратор,
		|	ЗатратыОбороты.Регистратор.Контрагент,
		|	ВЫРАЗИТЬ(ЗатратыОбороты.Регистратор.Комментарий КАК СТРОКА(500)) КАК РегистраторКомментарий
		|ИЗ
		|	РегистрНакопления.Затраты.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ЗатратыОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗатратыОбороты.Регистратор,
		|	ЗатратыОбороты.НоменклатурнаяГруппа,
		|	ЗатратыОбороты.СтатьяЗатрат,
		|	ЗатратыОбороты.Заказ,
		|	ЗатратыОбороты.Подразделение,
		|	ЗатратыОбороты.СтатьяЗатратУпр,
		|	ЗатратыОбороты.Заказ.Контрагент,
		|	ЗатратыОбороты.Регистратор.Контрагент,
		|	ВЫРАЗИТЬ(ЗатратыОбороты.Регистратор.Комментарий КАК СТРОКА(500))";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗРезультатЗапроса = РезультатЗапроса.Выгрузить();
	
	ТЗРезультатЗапроса.Колонки.Добавить("ЗаданиеНаОтгрузку",Новый ОписаниеТипов("ДокументСсылка.ЗаданиеНаОтгрузку"));
	
	Для Каждого СтрТЗРезультатЗапроса Из ТЗРезультатЗапроса Цикл 
		
		СтрТЗРезультатЗапроса.ЗаданиеНаОтгрузку = ПолучитьЗаданиеНаОтгрузку(СтрТЗРезультатЗапроса.РегистраторКомментарий);
		
	КонецЦикла;
	
	Возврат ТЗРезультатЗапроса;
	
КонецФункции

Функция ПолучитьЗаданиеНаОтгрузку(Комментарий)
	
	ДатаНомерЗадания = ПолучитьДатаНомерЗаданияНаОтгрузку(Комментарий);
	
	Если ДатаНомерЗадания = Неопределено Тогда 
		Возврат Неопределено;	
	КонецЕсли;
	
	Если ДатаНомерЗадания.Дата = Дата('00010101') Тогда 
		Возврат Неопределено;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданиеНаОтгрузку.Ссылка
		|ИЗ
		|	Документ.ЗаданиеНаОтгрузку КАК ЗаданиеНаОтгрузку
		|ГДЕ
		|	ЗаданиеНаОтгрузку.Номер = &Номер
		|	И НАЧАЛОПЕРИОДА(ЗаданиеНаОтгрузку.Дата, ДЕНЬ) = &Дата";
	
	Запрос.УстановитьПараметр("Дата", ДатаНомерЗадания.Дата);
	Запрос.УстановитьПараметр("Номер", ДатаНомерЗадания.Номер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
КонецФункции	

Функция ПолучитьДатаНомерЗаданияНаОтгрузку(Комментарий)
	
	СтрокаПоиска = "# Задание";
	Для НомСтр = 1 По СтрЧислоСтрок(Комментарий) Цикл 
		
		СтрокаКомментария = СтрПолучитьСтроку(Комментарий,НомСтр);
		НайденнаяПозицияСтроки = Найти(СтрокаКомментария, СтрокаПоиска);
		Если НайденнаяПозицияСтроки <> 0 Тогда 
			
			Структура = Новый Структура;
			Структура.Вставить("Номер",ПолучитьНомерЗадания(СтрокаКомментария,НайденнаяПозицияСтроки));
			Структура.Вставить("Дата",ПолучитьДатуЗадания(СтрокаКомментария));
			//Выходим из цикла при первом удачном поиске строки.
			Возврат Структура;
			
		КонецЕсли;	
				
	КонецЦикла;	
	
КонецФункции	

Функция ПолучитьНомерЗадания(Комментарий,НайденнаяПозицияСтроки)
	
	ПерваяПозиция = НайденнаяПозицияСтроки + 10; //10 - Длина "# Задание"
	ВтораяПозиция = 8; //8 - Длина номера задания на отгрузку  
	НомерЗадания = Сред(Комментарий , ПерваяПозиция,ВтораяПозиция);
	
	Возврат НомерЗадания;
	
КонецФункции

Функция ТолькоЦифры(СтрокаПроверки)
	
	Стр = "";
	Для а = 1 По СтрДлина(СтрокаПроверки) Цикл
		КодСимвола = КодСимвола(Сред(СтрокаПроверки, а, 1));
		Цифра = Сред(СтрокаПроверки, а, 1);
		Если (КодСимвола >= 48 И КодСимвола <= 57) Тогда
			Стр = Стр + Цифра;
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Стр;
	
КонецФункции

Функция ПолучитьДатуЗадания(Комментарий)
	  Попытка
	  ПерваяПозиция = Найти(Комментарий, "от ");
	  ВтораяПозиция = Найти(Комментарий, "г.");
	  
	  НачальнаяПозиция = ПерваяПозиция + 3; //3 - Длина "от " 
	  ДлинаСтроки = ВтораяПозиция - НачальнаяПозиция;
	  
	  СтрокаДата = Сред(Комментарий,НачальнаяПозиция,ДлинаСтроки);
	  СтрокаДата = СтрЗаменить(СтрокаДата," ",Символы.ПС);
	  
	  СтрокаДень  = СтрПолучитьСтроку(СтрокаДата,1);
	  СтрокаМесяц = СтрПолучитьСтроку(СтрокаДата,2);
	  СтрокаГод   = СтрПолучитьСтроку(СтрокаДата,3);
	  
	  Если СтрДлина(СокрЛП(СтрокаДень)) > 2 Тогда 
		  
		   СтрокаДень = Лев(ТолькоЦифры(СтрокаДень),2);
		  
	  КонецЕсли;
	  
	  День  = Формат(Число(СтрокаДень),"ЧЦ=2; ЧДЦ=; ЧВН=");
	  Месяц = СоответствиеМесяцев.Получить(СтрокаМесяц);
	  Год   = СокрЛп(СтрокаГод);
	  
	  //Создаем попытку.
	  //Необходимо,чтобы исключить возможные ошибки получения даты
	  //Попытка
		  ДатаЗадания = Дата(Год + Месяц + День);
	  //Исключение
		  //ДатаЗадания = Дата('00010101');
	  //КонецПопытки;
	  
	  Возврат ДатаЗадания;
  Исключение
	  Возврат Дата('00010101');
	 КонецПопытки;
КонецФункции
  

СоответствиеМесяцев  = Новый Соответствие;
СоответствиеМесяцев.Вставить("января",  "01");
СоответствиеМесяцев.Вставить("февраля", "02");
СоответствиеМесяцев.Вставить("марта",   "03");
СоответствиеМесяцев.Вставить("апреля",  "04");
СоответствиеМесяцев.Вставить("мая",     "05");
СоответствиеМесяцев.Вставить("июня",    "06");
СоответствиеМесяцев.Вставить("июля",    "07");
СоответствиеМесяцев.Вставить("августа", "08");
СоответствиеМесяцев.Вставить("сентября","09");
СоответствиеМесяцев.Вставить("октября", "10");
СоответствиеМесяцев.Вставить("ноября",  "11");
СоответствиеМесяцев.Вставить("декабря", "12");
