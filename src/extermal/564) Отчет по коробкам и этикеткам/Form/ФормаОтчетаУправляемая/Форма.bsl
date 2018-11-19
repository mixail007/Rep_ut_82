﻿// -------------- Сервисные методы формы (сервер) -----------------------------------------------------------

&НаСервере
Функция фПолучитьСтруктуруНастроекОтчета()
	Возврат РеквизитФормыВЗначение("Отчет").ПолучитьСтруктуруНастроекОтчета();
КонецФункции // ПолучитьФормуКопииОтчета()

// ----------------------------------------------------------------------------------------------------------


// -------------- Обработчики событий формы (сервер) ---------------------------------------------------------

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачПериода = НачалоМесяца(ТекущаяДата());
	НачПериода = НачалоМесяца(ДобавитьМесяц(НачПериода, -1));
	КонПериода = КонецМесяца(НачПериода);
	
	Отчет.НачПериода = НачалоДня(НачПериода);
	Отчет.КонПериода = КонецДня(КонПериода);
	
	НайденныйПараметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	//Заполним параметры отчета
	// Для того, чтобы не отработала загрузка последних использованных настроек отчета
	// при открытии копии отчета - отключим стандартную обработку
	
	Если Параметры.Свойство("НастройкиКомпоновщика") Тогда
		
		Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Параметры.НастройкиКомпоновщика);
		
		СтандартнаяОбработка = Ложь; // если не отключить стандартную обработку, то настройки затрутся
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	ПриИзмененииНастроек();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПриИзмененииНастроек();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	ПриИзмененииНастроек();
КонецПроцедуры

// ----------------------------------------------------------------------------------------------------------


// -------------- Обработчики событий формы (клиент) --------------------------------------------------------

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// для исключения ситуаций восстановления сохраненных настроек отчета
	// без дополнительных настроек отчета
	фкИнициализироватьДополнительныеНастройкиОтчета();
	
	// пометки кнопок и видимость параметров, отбора и заголовка отчета
	фкУстановитьПометкиКнопокОсновнойПанели();
	УстановитьВидимость();
КонецПроцедуры

// ----------------------------------------------------------------------------------------------------------


// -------------- Сервисные методы формы (сервер) -----------------------------------------------------------

&НаСервере
Процедура фсИнициализироватьДополнительныеНастройкиОтчета() 
	// настройка видимости параметров
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ПараметрыРазвернуты") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПараметрыРазвернуты", Ложь);
	КонецЕсли;

	// настройка видимости отбора
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ОтборРазвернут") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтборРазвернут", Ложь);
	КонецЕсли;
	
	// настройка видимости заголовка в отчете
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВидимостьЗаголовкаОтчета") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВидимостьЗаголовкаОтчета", Ложь);
	КонецЕсли;

	// настройка видимости параметров в отчете
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВидимостьПараметровОтчета") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВидимостьПараметровОтчета", Ложь);
	КонецЕсли;

КонецПроцедуры // ИнициализироватьДополнительныеНастройкиОтчета()

&НаСервере
Функция фсНайтиОбластьПараметровТабличногоДокумента(ТабличныйДокумент)
	НайденнаяОбласть = Неопределено;
	ТекстПараметров = "Параметры";
	Для  А=1  по ТабличныйДокумент.ФиксацияСверху Цикл
		Область = ТабличныйДокумент.Область(А,1);
		Если Найти(Область.Текст, ТекстПараметров) <> 0 Тогда
			НайденнаяОбласть = ТабличныйДокумент.Область( Макс((А-1),1) ,,А+1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденнаяОбласть;
КонецФункции // НайтиОбластьПараметровТабличногоДокумента()

&НаСервере
Функция фсНайтиОбластьОтбораТабличногоДокумента(ТабличныйДокумент)
	НайденнаяОбласть = Неопределено;
	ТекстПараметров = "Отбор";
	Для  А=1  по ТабличныйДокумент.ФиксацияСверху Цикл
		Область = ТабличныйДокумент.Область(А,1);
		Если Найти(Область.Текст, ТекстПараметров) <> 0 Тогда
			НайденнаяОбласть = ТабличныйДокумент.Область( Макс((А-1),1) ,,А+1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденнаяОбласть;
КонецФункции // НайтиОбластьПараметровТабличногоДокумента()

&НаСервере
Процедура фсУстановитьВидимостьЗаголовкаОтчета()
	// получим область заголовка отчета
	ОбластьЗаголовка = Результат.Области.Найти("Заголовок");
	Если ТипЗнч(ОбластьЗаголовка) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьЗаголовка.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	КонецЕсли;
КонецПроцедуры // УстановитьВидимостьЗаголовкаОтчета()

&НаСервере
Процедура фсУстановитьВидимостьПараметровОтчета()
	// получим область параметров
	ОбластьПараметров = фсНайтиОбластьПараметровТабличногоДокумента(Результат);
	Если ТипЗнч(ОбластьПараметров) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьПараметров.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	КонецЕсли;
	// получим область отбора
	ОбластьПараметров = фсНайтиОбластьОтбораТабличногоДокумента(Результат);
	Если ТипЗнч(ОбластьПараметров) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьПараметров.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	КонецЕсли;
КонецПроцедуры // УстановитьВидимостьЗаголовкаОтчета()

&НаСервере
Процедура фсУстановитьПометкиКнопокОсновнойПанели()
	
	Элементы.ПоказатьПараметрыКнопка.Пометка		= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты;
	Элементы.ПоказатьОтборКнопка.Пометка			= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут;
	Элементы.ПоказатьПараметрыОтчетаКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	Элементы.ПоказатьЗаголовокОтчетаКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;

КонецПроцедуры // УстановитьПометкиКнопокОсновнойПанели()

&НаСервере
Процедура фсУстановитьВидимостьПанели(ПризнакРазвернутости,ИмяПанели)
	Элементы[ИмяПанели].Видимость = ПризнакРазвернутости;
КонецПроцедуры // УсановитьВидимостьПараметров()

&НаСервере
Процедура ПриИзмененииНастроек()
	// для исключения ситуаций восстановления сохраненных настроек отчета
	// без дополнительных настроек отчета
	фсИнициализироватьДополнительныеНастройкиОтчета();
	
	// пометки кнопок и видимость параметров, отбора и заголовка отчета
	фсУстановитьПометкиКнопокОсновнойПанели();
	фсУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты, "ПанельПараметров");
	фсУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут, "ПанельОтборов");
	фсУстановитьВидимостьЗаголовкаОтчета();
	фсУстановитьВидимостьПараметровОтчета();
КонецПроцедуры // ПриИзмененииНастроек()

// -------------- Сервисные методы формы (клиент) -----------------------------------------------------------

&НаКлиенте
Процедура фкИнициализироватьДополнительныеНастройкиОтчета() 
	// настройка видимости параметров
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ПараметрыРазвернуты") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПараметрыРазвернуты", Ложь);
	КонецЕсли;

	// настройка видимости отбора
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ОтборРазвернут") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтборРазвернут", Ложь);
	КонецЕсли;
	
	// настройка видимости заголовка в отчете
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВидимостьЗаголовкаОтчета") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВидимостьЗаголовкаОтчета", Ложь);
	КонецЕсли;

	// настройка видимости параметров в отчете
	Если НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВидимостьПараметровОтчета") Тогда
		Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВидимостьПараметровОтчета", Ложь);
	КонецЕсли;

КонецПроцедуры // ИнициализироватьДополнительныеНастройкиОтчета()

&НаКлиенте
Функция фкНайтиОбластьПараметровТабличногоДокумента(ТабличныйДокумент)
	НайденнаяОбласть = Неопределено;
	ТекстПараметров = "Параметры";
	Для  А=1  по ТабличныйДокумент.ФиксацияСверху Цикл
		Область = ТабличныйДокумент.Область(А,1);
		Если Найти(Область.Текст, ТекстПараметров) <> 0 Тогда
			НайденнаяОбласть = ТабличныйДокумент.Область( Макс((А-1),1) ,,А+1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденнаяОбласть;
КонецФункции // НайтиОбластьПараметровТабличногоДокумента()

&НаКлиенте
Функция фкНайтиОбластьОтбораТабличногоДокумента(ТабличныйДокумент)
	НайденнаяОбласть = Неопределено;
	ТекстПараметров = "Отбор";
	Для  А=1  по ТабличныйДокумент.ФиксацияСверху Цикл
		Область = ТабличныйДокумент.Область(А,1);
		Если Найти(Область.Текст, ТекстПараметров) <> 0 Тогда
			НайденнаяОбласть = ТабличныйДокумент.Область( Макс((А-1),1) ,,А+1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат НайденнаяОбласть;
КонецФункции // НайтиОбластьПараметровТабличногоДокумента()

&НаКлиенте
Процедура фкУстановитьВидимостьЗаголовкаОтчета()
	// получим область заголовка отчета
	ОбластьЗаголовка = Результат.Области.Найти("Заголовок");
	Если ТипЗнч(ОбластьЗаголовка) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьЗаголовка.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	КонецЕсли;
КонецПроцедуры // УстановитьВидимостьЗаголовкаОтчета()

&НаКлиенте
Процедура фкУстановитьВидимостьПараметровОтчета()
	// получим область параметров
	ОбластьПараметров = фкНайтиОбластьПараметровТабличногоДокумента(Результат);
	Если ТипЗнч(ОбластьПараметров) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьПараметров.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	КонецЕсли;
	// получим область отбора
	ОбластьПараметров = фкНайтиОбластьОтбораТабличногоДокумента(Результат);
	Если ТипЗнч(ОбластьПараметров) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
		ОбластьПараметров.Видимость = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	КонецЕсли;
КонецПроцедуры // УстановитьВидимостьЗаголовкаОтчета()

&НаКлиенте
Процедура фкУстановитьПометкиКнопокОсновнойПанели()
	
	Элементы.ПоказатьПараметрыКнопка.Пометка		= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты;
	Элементы.ПоказатьОтборКнопка.Пометка			= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут;
	Элементы.ПоказатьПараметрыОтчетаКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	Элементы.ПоказатьЗаголовокОтчетаКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;

КонецПроцедуры // УстановитьПометкиКнопокОсновнойПанели()

&НаКлиенте
Процедура фкУстановитьВидимостьПанели(ПризнакРазвернутости,ИмяПанели)
	Элементы[ИмяПанели].Видимость = ПризнакРазвернутости;
КонецПроцедуры // УсановитьВидимостьПараметров()

&НаКлиенте
Процедура УстановитьВидимость()
	фкУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты, "ПанельПараметров");
	фкУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут, "ПанельОтборов");
	фкУстановитьВидимостьЗаголовкаОтчета();
	фкУстановитьВидимостьПараметровОтчета();
КонецПроцедуры // УстановитьВидимость()

// ----------------------------------------------------------------------------------------------------------


// -------------- Действия формы (клиент) -------------------------------------------------------------------

&НаКлиенте
Процедура ОткрытьНовыйОтчет(Команда)
	ПараметрыОтчета = фПолучитьСтруктуруНастроекОтчета();
	ОткрытьФорму(ПараметрыОтчета.ИмяФормыОтчета, ПараметрыОтчета,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПараметры(Команда)
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты = НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты;
	Элементы.ПоказатьПараметрыКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты;
	фкУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ПараметрыРазвернуты, "ПанельПараметров");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтбор(Команда)
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут = НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут;
	Элементы.ПоказатьОтборКнопка.Пометка	= Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут;
	фкУстановитьВидимостьПанели(Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ОтборРазвернут, "ПанельОтборов");
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаголовокОтчета(Команда)
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета = НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	Элементы.ПоказатьЗаголовокОтчетаКнопка.Пометка = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	фкУстановитьВидимостьЗаголовкаОтчета();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПараметрыОтчета(Команда)
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета = НЕ Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	Элементы.ПоказатьПараметрыОтчетаКнопка.Пометка = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	фкУстановитьВидимостьПараметровОтчета();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВЭксель(Команда)
	ИмяФайла = "1C_XPORT.XLS";
	Результат.Записать(КаталогВременныхФайлов() + ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	ЗапуститьПриложение(КаталогВременныхФайлов() + ИмяФайла);
КонецПроцедуры


// ----------------------------------------------------------------------------------------------------------


