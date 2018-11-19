﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ               

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция формирует дерево реквизитов документов для графы
Функция СформироватьДеревоДокументов(Пустое=Ложь)
	НовоеДеревоГраф=Новый ДеревоЗначений;
	КС = Новый КвалификаторыСтроки(0);
	М=Новый Массив;
	М.Добавить(Тип("Строка"));
	ОписаниеТС = Новый ОписаниеТипов(М, , ,КС);
	М.Очистить();
	М.Добавить(Тип("Булево"));
	ОписаниеТБ = Новый ОписаниеТипов(М);	
	НовоеДеревоГраф.Колонки.Добавить("Имя",ОписаниеТС);		
	НовоеДеревоГраф.Колонки.Добавить("Использовать", ОписаниеТБ);
	НовоеДеревоГраф.Колонки.Добавить("Синоним", ОписаниеТС);
	Если Пустое Тогда
		Возврат НовоеДеревоГраф;
	КонецЕсли;
	Для Каждого Док Из СписокОбрабатываемыхДокументов Цикл
		ЕСли Док.Пометка=Ложь Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока=НовоеДеревоГраф.Строки.Добавить();
		НоваяСтрока.Имя=Док.Значение;
		НоваяСтрока.Синоним=Док.Представление;
		Для Каждого Реквизит Из Метаданные.Документы[Док.Значение].Реквизиты Цикл
			СтрокаРеквизитов=НоваяСтрока.Строки.Добавить();
			СтрокаРеквизитов.Имя=Реквизит.Имя;
			СтрокаРеквизитов.Синоним=Реквизит.Синоним;
		КонецЦикла;
	КонецЦикла;
	Возврат НовоеДеревоГраф;
КонецФункции // СформироватьДеревоДокументов()

// Функция возвращает форматную строку в зависимости от типа значения
Функция ПолучитьСтрокуФормата(ОписаниеТипа)
	Если ОписаниеТипа.СодержитТип(Тип("Число")) Тогда		
		Возврат "ЧЦ="+ОписаниеТипа.КвалификаторыЧисла.Разрядность+
		"; ЧДЦ="+ОписаниеТипа.КвалификаторыЧисла.РазрядностьДробнойЧасти;
	Иначе
		Возврат "";
	КонецЕсли 
КонецФункции // ПолучитьСтрокуФормата()

// Процедура осуществляет формирования строк дерева реквизитов для выбранного документа
//Процедура ПроверитьДеревьяГрафНаВхождениеДока(ИмяДока=Неопределено, Включать=Истина)
//	Для Каждого Графа Из СписокГрафЖурнала Цикл
//		Если Включать Тогда
//			Графа.ДеревоГрафДокументов= СформироватьДеревоДокументов();
//		Иначе
//			Дерево=Графа.ДеревоГрафДокументов;
//			НайдСтрока=Дерево.Строки.Найти(ИмяДока, "Имя", Ложь);
//			Если НайдСтрока<>Неопределено Тогда
//				Дерево.Строки.Удалить(НайдСтрока);
//			КонецЕсли;
//		КонецЕсли;
//	КонецЦикла;
//	СписокГрафЖурналаПриАктивизацииСтроки(ЭлементыФормы.СписокГрафЖурнала)
//КонецПроцедуры // ПроверитьДеревьяГрафНаВхождениеДока()

// Функция формирует список типов реквизитов документов для текущей графы из списка
Функция ИспользуемыеТипы()
	СписокТипов = Новый СписокЗначений;
	СтруктураПоиска = Новый Структура("СсылкаНаГрафу", ЭлементыФормы.СписокГрафЖурнала.ТекущаяСтрока);
	НайдСтроки = ВыводимыеГрафы.НайтиСтроки(СтруктураПоиска);
	Если НайдСтроки.Количество()=0 Тогда
		Возврат СписокТипов;
	КонецЕсли;
	Для Каждого ВидДока Из НайдСтроки Цикл
		МетаданныеДокумента = Метаданные.Документы[ВидДока.ВидДокумента];
		ТипыРеквизита = МетаданныеДокумента.Реквизиты[ВидДока.ИмяРеквизита].Тип.Типы();
		Для Каждого ТипРеквизита Из ТипыРеквизита Цикл
			Если СписокТипов.НайтиПоЗначению(ТипРеквизита)=Неопределено Тогда
				СписокТипов.Добавить(ТипРеквизита);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	Возврат СписокТипов.ВыгрузитьЗначения();
КонецФункции // ИспользуемыеТипы()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик "ПриОткрытии" формы
Процедура ПриОткрытии()	
	//Если СписокГрафЖурнала.Найти(Истина, "ИспользоватьОтбор")<>Неопределено Тогда
	//	ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.Видимость = Истина;
	//Иначе
	//	ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.Видимость = Ложь;
	//КонецЕсли;		
	СохраненныеНастройки=ВосстановитьЗначение("НастройкиОбработкиУниверсальногоЖурнала");
	Если СохраненныеНастройки<>Неопределено Тогда
		ВосстСписокНастроек=СохраненныеНастройки;
		Если ВосстСписокНастроек.Количество()<>0 Тогда
			ЭлементыФормы.СписокНастроек.СписокВыбора = ВосстСписокНастроек;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик "ПриЗакрытии" формы
Процедура ПриЗакрытии()
	СохранитьЗначение("НастройкиОбработкиУниверсальногоЖурнала", ЭлементыФормы.СписокНастроек.СписокВыбора);
КонецПроцедуры // ПриЗакрытии()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура вызывается при нажатии кнопки "ОК" командной панели формы
Процедура ОКНажатие(Кнопка)
	Закрыть(Истина);
КонецПроцедуры // ОКНажатие()

// Процедура вызывается при нажатии кнопок "Установить флаги", "Сбросить флаги"
Процедура ФлагиНажатие(Элемент)
	СписокОбрабатываемыхДокументов.ЗаполнитьПометки(Элемент.Имя="ВсеФлаги");
	//Для Каждого Графа Из СписокГрафЖурнала Цикл
	//	Графа.ДеревоГрафДокументов= СформироватьДеревоДокументов();
	//КонецЦикла;	
	//СписокГрафЖурналаПриАктивизацииСтроки(ЭлементыФормы.СписокГрафЖурнала)	
КонецПроцедуры // ФлагиНажатие()
  
// Процедура - обработчик события "ОбработкаВыбора" поля ввода "СписокНастроек"
Процедура СписокНастроекОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Элемент.Значение = Элемент.СписокВыбора.НайтиПоЗначению(ВыбранноеЗначение).Представление;
	ВыводимыеГрафы.Очистить();	
	//СписокГрафЖурнала.Очистить();
	СписокОбрабатываемыхДокументов.ЗаполнитьПометки(Ложь);		
	ВосстЗнач=ВыбранноеЗначение.Скопировать();	
	Если Строка(ТипЗнч(ВосстЗнач))="Дерево значений" Тогда		
		// восстановление списка граф и реквизитов
		ДеревоГраф=ВосстЗнач;
		//Для Каждого Графа Из ДеревоГраф.Строки Цикл
		//	НовСтрГраф=СписокГрафЖурнала.Добавить();
		//	НовСтрГраф.ГрафаЖурнала=Графа.Имя;
		//	НовСтрГраф.ДеревоГрафДокументов=СформироватьДеревоДокументов(Истина);
		//	Если Графа.Отбор<>Неопределено Тогда
		//		НовСтрГраф.ИспользоватьОтбор = Истина;
		//		НовСтрГраф.ЗначениеОтбора = Графа.Отбор;
		//	КонецЕсли;
		//	Для Каждого Док Из Графа.Строки Цикл
		//		НовСтрДок=НовСтрГраф.ДеревоГрафДокументов.Строки.Добавить();			
		//		НовСтрДок.Имя=Док.Имя;
		//		НовСтрДок.Синоним=Док.Синоним;
		//		НайдЭлем=СписокОбрабатываемыхДокументов.НайтиПоЗначению(НовСтрДок.Имя);
		//		Если НайдЭлем<>Неопределено Тогда
		//			НайдЭлем.Пометка=Истина;
		//		КонецЕсли;			
		//		Для Каждого Рекв Из Док.Строки Цикл
		//			НовСтрРекв=НовСтрДок.Строки.Добавить();
		//			НовСтрРекв.Имя=Рекв.Имя;
		//			НовСтрРекв.Синоним=Рекв.Синоним;
		//			Если Рекв.Использовать Тогда
		//				СтрВыводГраф=ВыводимыеГрафы.Добавить();
		//				СтрВыводГраф.СсылкаНаГрафу=НовСтрГраф;
		//				СтрВыводГраф.ВидДокумента=НовСтрДок.Имя;
		//				СтрВыводГраф.ИмяРеквизита=НовСтрРекв.Имя;
		//				
		//				ОписаниеТипа = Метаданные.Документы[СтрВыводГраф.ВидДокумента].Реквизиты[СтрВыводГраф.ИмяРеквизита].Тип;
		//				СтрВыводГраф.Формат = ПолучитьСтрокуФормата(ОписаниеТипа );
		//				Если ОписаниеТипа.СодержитТип(Тип("Строка")) Тогда
		//					Если ОписаниеТипа.КвалификаторыСтроки.Длина = 0 Тогда
		//						СтрВыводГраф.НеограниченнаяСтрока = Истина;
		//					Иначе
		//						СтрВыводГраф.НеограниченнаяСтрока = Ложь;
		//					КонецЕсли;
		//				Иначе
		//					СтрВыводГраф.НеограниченнаяСтрока = Ложь;
		//				КонецЕсли;
		//				
		//			КонецЕсли;
		//		КонецЦикла;			
		//	КонецЦикла;
		//КонецЦикла;	
		//ЭлементыФормы.СписокГрафЖурнала.ТекущаяСтрока=СписокГрафЖурнала[0];		
	ИначеЕсли Строка(ТипЗнч(ВосстЗнач))="Список значений" Тогда 
		//РеквизитыДокументов.Строки.Очистить();
		ВыводимыеГрафы.Очистить();
		СписокОбрабатываемыхДокументов=ВосстЗнач;
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	//Если СписокГрафЖурнала.Найти(Истина, "ИспользоватьОтбор")<>Неопределено Тогда
	//	ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.Видимость = Истина;
	//КонецЕсли;	
КонецПроцедуры // СписокНастроекОбработкаВыбора()

// Процедура вызываетя при нажатии кнопки "Сохранить",
// добавляет текущую настройку в список настроек
Процедура КнопкаСохрНастроекНажатие(Элемент)
	ИмяНастройки = ЭлементыФормы.СписокНастроек.Значение;
	Если ПустаяСтрока(ИмяНастройки) Тогда
		ИмяНастройки = "<...>";
	КонецЕсли;
	
	СуществующаяНастройка = Неопределено;
	
	Для Каждого Настройка Из ЭлементыФормы.СписокНастроек.СписокВыбора Цикл
		Если Настройка.Представление = ИмяНастройки Тогда
			Если Вопрос("Настройка с таким именем уже существет. Перезаписать ее?", 
				РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да Тогда
				СуществующаяНастройка = Настройка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//Спс=Новый СписокЗначений;
	//Если СписокГрафЖурнала.Количество()=0 Тогда
		ПараметрыНастройки = СписокОбрабатываемыхДокументов.Скопировать();
	//Иначе			
	//	ДеревоГраф = Новый ДеревоЗначений;
	//	ДеревоГраф.Колонки.Добавить("Имя");
	//	ДеревоГраф.Колонки.Добавить("Отбор");
	//	ДеревоГраф.Колонки.Добавить("Синоним");
	//	ДеревоГраф.Колонки.Добавить("Использовать");		
	//	Для Каждого Графа Из СписокГрафЖурнала Цикл
	//		НовСтрГраф=ДеревоГраф.Строки.Добавить();
	//		НовСтрГраф.Имя=Графа.ГрафаЖурнала;
	//		Если Графа.ИспользоватьОтбор<>Неопределено И Графа.ИспользоватьОтбор Тогда
	//			НовСтрГраф.Отбор = Графа.ЗначениеОтбора;				
	//		КонецЕсли;
	//		Для Каждого ДокГрафы Из Графа.ДеревоГрафДокументов.Строки Цикл
	//			НовСтрДоков=НовСтрГраф.Строки.Добавить();
	//			НовСтрДоков.Имя=ДокГрафы.Имя;
	//			НовСтрДоков.Синоним=ДокГрафы.Синоним;
	//			Для Каждого ДокРекв Из ДокГрафы.Строки Цикл
	//				НовСтрРекв=НовСтрДоков.Строки.Добавить();
	//				НовСтрРекв.Имя=ДокРекв.Имя;
	//				НовСтрРекв.Синоним=ДокРекв.Синоним;
	//				Отбор=Новый Структура("СсылкаНаГрафу, ВидДокумента, ИмяРеквизита", Графа, ДокГрафы.Имя, ДокРекв.Имя);
	//				НайдСтроки=ВыводимыеГрафы.НайтиСтроки(Отбор);
	//				НовСтрРекв.Использовать=(НайдСтроки.Количество()>0);
	//			КонецЦикла;
	//		КонецЦикла;
	//	КонецЦикла;
	//	ПараметрыНастройки=ДеревоГраф;
	//КонецЕсли;
	Если СуществующаяНастройка=Неопределено Тогда
		ЭлементыФормы.СписокНастроек.СписокВыбора.Добавить(ПараметрыНастройки, ИмяНастройки);
	Иначе
		СуществующаяНастройка.Значение = ПараметрыНастройки;
	КонецЕсли;
КонецПроцедуры // КнопкаСохрНастроекНажатие()

// Процедура - обработчик события "Очитска" поля ввода "СписокНастроек",
// удаляет выбранную настройку из списка
Процедура СписокНастроекОчистка(Элемент, СтандартнаяОбработка)
	Для Каждого Настройка Из Элемент.СписокВыбора Цикл
		Если Настройка.Представление = Элемент.Значение Тогда
			Элемент.СписокВыбора.Удалить(Настройка);
			Прервать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // СписокНастроекОчистка()

// Процедура - обработчик события "НачалоВыбора" поля ввода "ЗачениеОтбора" табличного поля "СписокГраф"
Процедура СписокГрафЖурналаЗначениеОтбораНачалоВыбора(Элемент, СтандартнаяОбработка)
	МассивТипов = ИспользуемыеТипы();
	Если МассивТипов.Количество()=0 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;	
	Если ТипЗнч(ЭлементыФормы.СписокГрафЖурнала.ТекущиеДанные.ЗначениеОтбора)=Тип("СписокЗначений") Тогда
		ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);
		ЭлементыФормы.СписокГрафЖурнала.ТекущиеДанные.ЗначениеОтбора.ТипЗначения = ОписаниеТипов;
	Иначе		
		МассивТипов.Вставить(0, Тип("СписокЗначений"));
		ОписаниеТипов = Новый ОписаниеТипов(МассивТипов);
		ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.ЭлементУправления.ОграничениеТипа = ОписаниеТипов;		
	КонецЕсли;
КонецПроцедуры // СписокГрафЖурналаЗначениеОтбораНачалоВыбора()

// Процедура - обработчик события "ПриИзмененииФлажка" табличного поля "СписокГраф"
Процедура СписокГрафЖурналаПриИзмененииФлажка(Элемент, Колонка)
	
	Если Элемент.ТекущаяСтрока.ИспользоватьОтбор Тогда
		
		Если ВыводимыеГрафы.Найти(ЭлементыФормы.СписокГрафЖурнала.ТекущаяСтрока, "СсылкаНаГрафу")=Неопределено Тогда
			Элемент.ТекущаяСтрока.ИспользоватьОтбор = Ложь;
		КонецЕсли;   
		
		Отбор = Новый Структура("СсылкаНаГрафу, НеограниченнаяСтрока", Элемент.ТекущаяСтрока, Истина);
		НайдГрафы=ВыводимыеГрафы.НайтиСтроки(Отбор);
		
		Если НайдГрафы.Количество() > 0 Тогда
			Предупреждение("Для реквизитов, имеющих тип ""Строка неограниченной длины"", установка отбора запрещена.");
			Элемент.ТекущаяСтрока.ИспользоватьОтбор = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ВидимостьКолонок = Элемент.ТекущиеДанные.ИспользоватьОтбор;
	//Если Не ВидимостьКолонок Тогда
	//	Если СписокГрафЖурнала.Найти(Истина, "ИспользоватьОтбор")<>Неопределено Тогда
	//		Возврат;
	//	КонецЕсли;		
	//	ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.Видимость = ВидимостьКолонок;	
	//Иначе
	//	ЭлементыФормы.СписокГрафЖурнала.Колонки.ЗначениеОтбора.Видимость = ВидимостьКолонок;	
	//КонецЕсли;			
КонецПроцедуры // СписокГрафЖурналаПриИзмененииФлажка()

// Процедура - обработчик события "ПередУдалением" табличного поля "СписокГраф"
Процедура СписокГрафЖурналаПередУдалением(Элемент, Отказ)
//	ЭлементыФормы.РеквизитыДокументов.Строки.Очистить();
	Отбор=Новый Структура("СсылкаНаГрафу",Элемент.ТекущаяСтрока);
	НайдСтроки=ВыводимыеГрафы.НайтиСтроки(Отбор);
	Для Каждого Удалить Из НайдСтроки Цикл
		ВыводимыеГрафы.Удалить(Удалить);
	КонецЦикла;		
КонецПроцедуры // СписокГрафЖурналаПередУдалением()
 
// Процедура - обработчик события "ПриОкончанииРедактирования" табличного поля "СписокГраф"
Процедура СписокГрафЖурналаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если (Элемент.ТекущиеДанные=Неопределено)Тогда
		ОтменаРедактирования=Истина;
		Возврат;
	КонецЕсли;
	Если НоваяСтрока Тогда
		НовоеДерево=СформироватьДеревоДокументов();
		Элемент.ТекущиеДанные.ДеревоГрафДокументов=НовоеДерево;		
		ЭлементыФормы.РеквизитыДокументов.Значение=НовоеДерево;
		ЭлементыФормы.РеквизитыДокументов.Колонки[0].ТолькоПросмотр=Истина;
	КонецЕсли;
КонецПроцедуры // СписокГрафЖурналаПриОкончанииРедактирования()

// Процедура - обработчик события "ПриАктивизацииСтроки" табличного поля "СписокГраф"
Процедура СписокГрафЖурналаПриАктивизацииСтроки(Элемент)	
	Если Элемент.ТекущиеДанные=Неопределено Тогда
		//РеквизитыДокументов.Строки.Очистить();
	Иначе
		Если Элемент.ТекущиеДанные.ДеревоГрафДокументов<>Неопределено Тогда
			ЭлементыФормы.РеквизитыДокументов.Значение=Элемент.ТекущиеДанные.ДеревоГрафДокументов;			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // СписокГрафЖурналаПриАктивизацииСтроки()


// Процедура - обработчик события "ПриВыводеСтроки" табличного поля "РеквизитыДокументов"
Процедура РеквизитыДокументовПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОформлениеСтроки.Ячейки.Количество() Тогда
		Возврат;
	КонецЕсли;
		
	ОформлениеСтроки.Ячейки.Имя.ТолькоПросмотр=Истина;
	Если ДанныеСтроки.Родитель=Неопределено Тогда
		ОформлениеСтроки.Ячейки.Имя.ОтображатьФлажок = Ложь;
		ОформлениеСтроки.Ячейки.Имя.Картинка = БиблиотекаКартинок.ДокументОбъект;
		ОформлениеСтроки.Шрифт = Новый Шрифт(,,Истина);		
		
	Иначе
		ОформлениеСтроки.Ячейки.Имя.ОтображатьФлажок = Истина;
		ОформлениеСтроки.Ячейки.Имя.Картинка = ЭлементыФормы.КартинкаРеквизита.Картинка;
		Отбор = Новый Структура("СсылкаНаГрафу, ВидДокумента, ИмяРеквизита", ЭлементыФормы.СписокГрафЖурнала.ТекущаяСтрока, ДанныеСтроки.Родитель.Имя ,ДанныеСтроки.Имя);
		НайдГрафы=ВыводимыеГрафы.НайтиСтроки(Отбор);
		Если НайдГрафы.Количество()<>0 Тогда
			ОформлениеСтроки.Ячейки.Имя.Флажок=Истина;
		Иначе
			ОформлениеСтроки.Ячейки.Имя.Флажок=Ложь;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры // РеквизитыДокументовПриВыводеСтроки()

// Процедура - обработчик события "ПриИзмененииФлажка" табличного поля "РеквизитыДокументов"
Процедура РеквизитыДокументовПриИзмененииФлажка(Элемент, Колонка)
	Отбор = Новый Структура("СсылкаНаГрафу, ВидДокумента", ЭлементыФормы.СписокГрафЖурнала.ТекущаяСтрока, Элемент.ТекущиеДанные.Родитель.Имя);
	НайдГрафы=ВыводимыеГрафы.НайтиСтроки(Отбор);
	Если НайдГрафы.Количество()=0 Тогда
		НоваяСтрока=ВыводимыеГрафы.Добавить();
		НоваяСтрока.СсылкаНаГрафу=Отбор.СсылкаНаГрафу;
		НоваяСтрока.ВидДокумента=Отбор.ВидДокумента;
		НоваяСтрока.ИмяРеквизита=Элемент.ТекущиеДанные.Имя;
		Элемент.ТекущаяСтрока.Использовать=Истина;
		ОписаниеТипа = Метаданные.Документы[НоваяСтрока.ВидДокумента].Реквизиты[НоваяСтрока.ИмяРеквизита].Тип;
		НоваяСтрока.Формат = ПолучитьСтрокуФормата(ОписаниеТипа );
		Если ОписаниеТипа.СодержитТип(Тип("Строка")) Тогда
			Если ОписаниеТипа.КвалификаторыСтроки.Длина = 0 Тогда
				// строка не ограниченной длины
				НоваяСтрока.НеограниченнаяСтрока = Истина;
			Иначе
				НоваяСтрока.НеограниченнаяСтрока = Ложь;
			КонецЕсли;			
		Иначе
			НоваяСтрока.НеограниченнаяСтрока = Ложь;
		КонецЕсли;
		
	Иначе
		НайдГрафы[0].ИмяРеквизита=Элемент.ТекущиеДанные.Имя;
		Элемент.ТекущаяСтрока.Использовать=Истина;
		ОписаниеТипа = Метаданные.Документы[НайдГрафы[0].ВидДокумента].Реквизиты[НайдГрафы[0].ИмяРеквизита].Тип;
		НайдГрафы[0].Формат = ПолучитьСтрокуФормата(ОписаниеТипа );		
		Если ОписаниеТипа.СодержитТип(Тип("Строка")) Тогда
			Если ОписаниеТипа.КвалификаторыСтроки.Длина = 0 Тогда
				// строка не ограниченной длины
				НайдГрафы[0].НеограниченнаяСтрока = Истина;
			Иначе
				НайдГрафы[0].НеограниченнаяСтрока = Ложь;
			КонецЕсли;
		Иначе
			НайдГрафы[0].НеограниченнаяСтрока = Ложь;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры // РеквизитыДокументовПриИзмененииФлажка()


// Процедура - обработчик события "ПриИзмененииФлажка" поля списка "СписокОбрабатываемыхДокументов"
Процедура СписокОбрабатываемыхДокументовПриИзмененииФлажка(Элемент)
	//ПроверитьДеревьяГрафНаВхождениеДока(Элемент.ТекущаяСтрока.Значение, Элемент.ТекущаяСтрока.Пометка );
	Если Не Элемент.ТекущаяСтрока.Пометка Тогда
		Отбор=Новый Структура("ВидДокумента", Элемент.ТекущаяСтрока.Значение );
		//НайдСтроки=ВыводимыеГрафы.НайтиСтроки(Отбор);
		//Для Каждого Стр из НайдСтроки Цикл
		//	ВыводимыеГрафы.Удалить(Стр);
		//КонецЦикла;
	КонецЕсли;
КонецПроцедуры // СписокОбрабатываемыхДокументовПриИзмененииФлажка()





////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 