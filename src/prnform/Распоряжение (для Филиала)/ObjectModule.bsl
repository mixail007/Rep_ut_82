﻿
функция Печать() экспорт
	
	ТабДокумент = новый ТабличныйДокумент;
	
	//10.04.2012 - для договора с * -> макетН, цена и сумма,  номер с Н
	флагН = ( Найти(СсылкаНаОбъект.ДоговорКонтрагента.Наименование, "*")>0 );
	
	
	Макет = ?(флагН, ПолучитьМакет("МакетН"), ПолучитьМакет("Макет") );
	ОбластьЗаголовок= Макет.ПолучитьОбласть("Заголовок");
	ОбластьСтрока 	= Макет.ПолучитьОбласть("Строка");
	ОбластьИтог		= Макет.ПолучитьОбласть("ИтогоСумма");
	ОбластьПодвал   = Макет.ПолучитьОбласть("Подвал");
	
	префикс = "";  //префик + 5 "цифр"
	Если ЗначениеЗаполнено(СсылкаНаОбъект.Склад) тогда
		Если ЗначениеЗаполнено(СсылкаНаОбъект.Склад.Подразделение) тогда
			префикс = СокрЛП(СсылкаНаОбъект.Склад.Подразделение.ПрефиксИБ); // сначала из Склада.Подраздение 
			Если префикс = "" тогда
				префикс = СокрЛП(СсылкаНаОбъект.Подразделение.ПрефиксИБ); // затем из Подраздения документа
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	//если номер вх.док - пустой - берем номер Заказа		
	ОбластьЗаголовок.Параметры.НомерРаспоряжения = ?(сокрлп(СсылкаНаОбъект.НомерВходящегоДокумента)="", СсылкаНаОбъект.Номер, префикс + СокрЛП(СсылкаНаОбъект.НомерВходящегоДокумента) + ?(флагН,"Н","")  );
	//если дата вх.док - пустая  - берем дату отгрузки, если и она пустая - дату документа	
	ОбластьЗаголовок.Параметры.ДатаРаспоряжения  = Формат(?(СсылкаНаОбъект.ДатаВходящегоДокумента = дата(1,1,1), ?(СсылкаНаОбъект.ДатаОтгрузки= дата(1,1,1),СсылкаНаОбъект.Дата,СсылкаНаОбъект.ДатаОтгрузки) , СсылкаНаОбъект.ДатаВходящегоДокумента),"ДЛФ=Д");
	
	//название филиала - это подразделение
	Если ЗначениеЗаполнено(СсылкаНаОбъект.Склад) тогда
		
		филиал = СсылкаНаОбъект.Склад.Подразделение;
		Если ЗначениеЗаполнено(филиал) тогда 
			
			//=======================Здесь надо для КАЖДОГО ФИЛИАЛА - прописывать руками!==============================
			
			Если филиал.Код = "00106" тогда // Отдел сбыта Ростов
				//Орлов++
				//было:
				//ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""Спутник"" ";
				//ОбластьЗаголовок.Параметры.ФИОДиректору = "Щукину А.В.";
				//стало:
				ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""Кама-Юг"" ";
				ОбластьЗаголовок.Параметры.ФИОДиректору = "Алтухову В.А.";
				
				
				Если СсылкаНаОбъект.Склад = справочники.Склады.НайтиПоКоду("00677") тогда //+++ 29.04.2013 ШинВалом (ответ. хранение) Ростов-Дон
					ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""ШинВалом"" ";
					ОбластьЗаголовок.Параметры.ФИОДиректору = "Катренко А.В.";
				КонецЕсли;
				
			иначеЕсли филиал.Код = "00107" тогда // Отдел сбыта Москва Виктория
				ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""Виктория"" ";
				ОбластьЗаголовок.Параметры.ФИОДиректору = "Войновской Н.Р.";
				
			иначеЕсли филиал.Код = "00111" тогда // Краснодар
				ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""Шин-Лайн"" ";
				ОбластьЗаголовок.Параметры.ФИОДиректору = "Туровой Е.С.";
				
				//иначеЕсли филиал.Код = "00112" тогда // Петербург
				//	ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору ООО ""ШинТрейд СПб"" ";
				//	ОбластьЗаголовок.Параметры.ФИОДиректору = "Пановицину Е.В.";
				
			иначе // заполняется вручную
				ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору _________________";
				ОбластьЗаголовок.Параметры.ФИОДиректору = "_________________";
			КонецЕсли;
			
			//==========================================================================================================
			
		иначе // не заполнен филиал
			сообщить("Не заполнено Подразделение отправления Распоряжения для склада "+строка(СсылкаНаОбъект.Склад)+"!");
		КонецЕсли;
		
	иначе // заполняется вручную... непонятно для какого филиала!
		сообщить("Не выбран склад отправления Распоряжения!");
		ОбластьЗаголовок.Параметры.ДиректоруСпутник = "Директору _________________";
		ОбластьЗаголовок.Параметры.ФИОДиректору = "_________________";
	КонецЕсли;	
	
	СведенияОКонтрагенте	  = СведенияОЮрФизЛице(СсылкаНаОбъект.Контрагент,  СсылкаНаОбъект.Дата);
	ОбластьЗаголовок.Параметры.ПредставлениеКонтрагента = ОписаниеОрганизации(СведенияОКонтрагенте, "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
	
	
	табДокумент.Вывести(ОбластьЗаголовок);
	
	
	
	
	
	//-----------------Строки--только те что есть в рег.нак. Заказы (еще не отгруженные) --------------------
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ЗаказПокупателяТовары.НомерСтроки, 1000) КАК НомерСтроки,
	|	ЗаказыПокупателейОстатки.Номенклатура.Код КАК Код,
	|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПокупателейОстатки.КоличествоОстаток КАК Количество,
	|	ЗаказыПокупателейОстатки.ЕдиницаИзмерения,
	|	ЗаказПокупателяТовары.Цена,
	|	ЗаказПокупателяТовары.Сумма
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(, ЗаказПокупателя = &ЗаказПокупателя) КАК ЗаказыПокупателейОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	|		ПО ЗаказыПокупателейОстатки.Номенклатура = ЗаказПокупателяТовары.Номенклатура
	|			И ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры = ЗаказПокупателяТовары.ХарактеристикаНоменклатуры
	|ГДЕ
	|	ЗаказыПокупателейОстатки.КоличествоОстаток > 0
	|	И ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Номенклатура";
	
	Запрос.УстановитьПараметр("ЗаказПокупателя", СсылкаНаОбъект.Ссылка );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	итогоКол = 0;  итогоСумма=0;
	Пока Выборка.Следующий() Цикл
		
		ОбластьСтрока.Параметры.НомерСтроки  = Выборка.НомерСтроки;
		ОбластьСтрока.Параметры.Код  = Выборка.Код;
		ОбластьСтрока.Параметры.Номенклатура = Выборка.Номенклатура;
		ОбластьСтрока.Параметры.Количество   = Выборка.Количество;
		ОбластьСтрока.Параметры.ЕдИзм = Выборка.ЕдиницаИзмерения;
		
		Если флагН тогда
			ОбластьСтрока.Параметры.Цена  = Выборка.Цена;
			ОбластьСтрока.Параметры.Сумма = Выборка.Сумма;
			итогоСумма = итогоСумма + выборка.Сумма;
		КонецЕсли;
		
		итогоКол = итогоКол + выборка.Количество;
		
		табДокумент.Вывести(ОбластьСтрока);
		
	КонецЦикла;
	
	ОбластьИтог.Параметры.итогоКол = итогоКол;
	Если флагН тогда
		ОбластьИтог.Параметры.итогоСумма = итогоСумма;
	КонецЕсли;
	табДокумент.Вывести(ОбластьИтог);
	
	
	
	
	//-----------------------Подвал-----------------------------
	СведенияОГрузополучателе  = СведенияОЮрФизЛице(?(ЗначениеЗаполнено(СсылкаНаОбъект.Грузополучатель), СсылкаНаОбъект.Грузополучатель, СсылкаНаОбъект.Контрагент),  СсылкаНаОбъект.Дата);
	Если СокрЛП(СсылкаНаОбъект.АдресДоставки) <> "" Тогда
		ПредставлениеГрузополучателяДоАдреса    = ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование,ИНН,");
		ПредставлениеГрузополучателяПослеАдреса = ОписаниеОрганизации(СведенияОГрузополучателе, "Телефоны,НомерСчета,Банк,БИК,КоррСчет,");
		ОбластьПодвал.Параметры.ПредставлениеГрузополучателя = ?(СокрЛП(ПредставлениеГрузополучателяДоАдреса) = "", "", ПредставлениеГрузополучателяДоАдреса+", ") + СсылкаНаОбъект.АдресДоставки+?(СокрЛП(ПредставлениеГрузополучателяПослеАдреса)="", "", ", "+ПредставлениеГрузополучателяПослеАдреса);
	Иначе
		ОбластьПодвал.Параметры.ПредставлениеГрузополучателя = ОписаниеОрганизации(СведенияОГрузополучателе, "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
	КонецЕсли;
	
	
	//СсылкаНаОбъект.КонтактноеЛицо - это и есть водитель?
	водитель = справочники.ФизическиеЛица.ПустаяСсылка();
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") тогда //+++ 01.08.2013 - не могут делать распоряжений!
		
		паспорт = "Водитель: <ФИО> паспорт: <серия> <номер>, выдан: <КемВыдан> <КогдаВыдан>";
		ВвестиСтроку(паспорт,"Введите Фамилию и паспортные данные водителя");
		водитель = неопределено;
		
	Иначе	
		Предупреждение("Выберите или введите нового Водителя из списка физических лиц",10);
		
		Если ВвестиЗначение(водитель, "Выберите водителя из справочника Физ.лиц
			|ИЛИ введите данные по водителю одной строкой...", ТипЗнч(водитель))  тогда
			
			паспортныеДанные = регистрыСведений.ПаспортныеДанныеФизЛиц.ПолучитьПоследнее(СсылкаНаОбъект.Дата, новый структура("ФизЛицо",водитель));
			если паспортныеДанные <> неопределено тогда
				паспорт = ?(Найти(нрег(строка(паспортныеДанные.ДокументВид)),"паспорт")>0, "паспорт", строка(ПаспортныеДанные.ДокументВид) ) 
				+ " : "+СокрЛП(паспортныеДанные.ДокументСерия)+" "+СокрЛП(паспортныеДанные.ДокументНомер)
				+", выдан: "+СокрЛП(паспортныеДанные.ДокументКемВыдан)+" "+формат(паспортныеДанные.ДокументДатаВыдачи,"ДЛФ=D");
			иначе
				паспорт = "паспорт: <серия> <номер>, выдан: <КемВыдан> <КогдаВыдан>";
				ВвестиСтроку(паспорт,"Введите паспортные данные водителя");
			КонецЕсли;
		иначе
			паспорт = "Водитель: <ФИО> паспорт: <серия> <номер>, выдан: <КемВыдан> <КогдаВыдан>";
			ВвестиСтроку(паспорт,"Введите Фамилию и паспортные данные водителя");
			водитель = неопределено;
		КонецЕсли;
	КонецЕсли;	
	
	//+++ 10.04.2012 добавлены данные автомобиля
	авто =  СокрЛП(СсылкаНаОбъект.МаркаАвтомобиля)+" "+СокрЛП(СсылкаНаОбъект.ГосНомерАвтомобиля);
	
	ОбластьПодвал.Параметры.ВодительПредставление = ?(водитель=неопределено,"", СокрЛП(Водитель.Наименование)) +" "+СокрЛП(паспорт)+?(СокрЛП(авто)="", "", " Автомобиль: "+СокрЛП(авто) );
	
	
	
	табДокумент.Вывести(ОбластьПодвал);
	
	возврат табДокумент;
	
конецФункции
