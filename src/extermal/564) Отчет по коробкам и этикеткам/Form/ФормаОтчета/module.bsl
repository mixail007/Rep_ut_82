﻿// -------------- Сервисные процедуры формы -----------------------------------------------------------------

Процедура УстановитьПометкиКнопокОсновнойПанели()
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьПараметры.Пометка	= ВидимостьПараметров;
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьОтбор.Пометка		= ВидимостьОтборов;
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьПараметрыОтчета.Пометка		= КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	ЭлементыФормы.ДействияФормы.Кнопки.ПоказатьЗаголовокОтчета.Пометка		= КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
КонецПроцедуры // УстановитьПометкиКнопокОсновнойПанели()

Процедура УстановитьВидимостьПанели(ПризнакРазвернутости,ИмяПанели)
	Если ПризнакРазвернутости Тогда
		ЭлементыФормы[ИмяПанели].Свертка = РежимСверткиЭлементаУправления.Нет;
	Иначе
		ЭлементыФормы[ИмяПанели].Свертка = РежимСверткиЭлементаУправления.Верх;
	КонецЕсли;
КонецПроцедуры // УсановитьВидимостьПараметров()

Процедура УстановитьВидимость()
	УстановитьВидимостьПанели(ВидимостьПараметров, "ПанельПараметров");
	УстановитьВидимостьПанели(ВидимостьОтборов, "ПанельОтборов");
	УстановитьВидимостьЗаголовкаОтчета(ЭлементыФормы.Результат);
	УстановитьВидимостьПараметровОтчета(ЭлементыФормы.Результат);
КонецПроцедуры // УстановитьВидимость()

// ----------------------------------------------------------------------------------------------------------


// -------------- Действия формы ----------------------------------------------------------------------------

Процедура ДействияФормыПоказатьПараметры(Кнопка)
	ВидимостьПараметров = НЕ ВидимостьПараметров;
	Кнопка.Пометка = ВидимостьПараметров;
	УстановитьВидимостьПанели(ВидимостьПараметров, "ПанельПараметров");
КонецПроцедуры

Процедура ДействияФормыПоказатьОтбор(Кнопка)
	ВидимостьОтборов = НЕ ВидимостьОтборов;
	Кнопка.Пометка = ВидимостьОтборов;
	УстановитьВидимостьПанели(ВидимостьОтборов, "ПанельОтборов");
КонецПроцедуры

Процедура ДействияФормыПоказатьЗаголовокОтчета(Кнопка)
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета = НЕ КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	Кнопка.Пометка = КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьЗаголовкаОтчета;
	УстановитьВидимостьЗаголовкаОтчета(ЭлементыФормы.Результат);
КонецПроцедуры

Процедура ДействияФормыПоказатьПараметрыОтчета(Кнопка)
	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета = НЕ КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	Кнопка.Пометка = КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВидимостьПараметровОтчета;
	УстановитьВидимостьПараметровОтчета(ЭлементыФормы.Результат);
КонецПроцедуры

Процедура ДействияФормыОткрытьНовыйОтчет(Кнопка)
	ФормаНовогоОтчета = ПолучитьКопииюОтчета().ПолучитьФорму();
	ФормаНовогоОтчета.ВосстанавливатьЗначенияПриОткрытии = Ложь;
	ФормаНовогоОтчета.Открыть();
	
	//ОтчетОбъект.СкомпоноватьРезультат(ФормаНовогоОтчета.ЭлементыФормы.Результат, ДанныеРасшифровки);
	
	//ФормаНовогоОтчета.СгенерироватьКнопкиУправленияГруппировкой();
	
КонецПроцедуры

// ----------------------------------------------------------------------------------------------------------

Процедура _СменаВариантаНастройки (Элемент)
	Для каждого Настройка Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		Если Элемент.Текст = Настройка.Представление тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(Настройка.Настройки);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ОтчетОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат, ДанныеРасшифровки);
	
	СгенерироватьКнопкиУправленияГруппировкой();
	
	УстановитьПометкиКнопокОсновнойПанели();
	УстановитьВидимость();
	
КонецПроцедуры

Процедура УстановитьВариантыНастроек()
	
	КП = ЭлементыФормы.ДействияФормы; 
	
	//КП = ЭлементыФормы.КоманднаяПанель;
	НовоеДействие = Новый Действие("_СменаВариантаНастройки");
	ТипКнопки = ТипКнопкиКоманднойПанели.Подменю;
	НоваяКнопка = КП.Кнопки.Вставить(11, "_ВариантыОтчетов", ТипКнопки, "Варианты отчетов", НовоеДействие);
	
	ч = 1;
	Для каждого Настройка Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		НоваяКнопка = КП.Кнопки._ВариантыОтчетов.Кнопки.Добавить("Вариант"+Строка(ч), ТипКнопкиКоманднойПанели.Действие, Настройка.Представление, НовоеДействие);
		ч = ч + 1;
	КонецЦикла;
	
КонецПроцедуры


// -------------- Обработчики событий формы -----------------------------------------------------------------

Процедура ПриОткрытии()
	
	УстановитьВариантыНастроек();
	
	НачПериода = НачалоМесяца(ТекущаяДата());
	НачПериода = НачалоМесяца(ДобавитьМесяц(НачПериода, -1));
	КонПериода = КонецМесяца(НачПериода);
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	
	ИмяОтчета  = Строка(ЭтаФорма.ОтчетОбъект);
	//СтруктураНастройки = Новый Структура;
	//СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	//СтруктураНастройки.Вставить("ИмяОбъекта", ИмяОтчета);
	//СтруктураНастройки.Вставить("НаименованиеНастройки", Неопределено);
	
	//Результат = УниверсальныеМеханизмы.ПолучитьНастройкуИспользоватьПриОткрытии(СтруктураНастройки);
	//
	//Если Результат Тогда
	//	мТекущаяНастройка = СтруктураНастройки;
	//	ИмяНастройки = СтруктураНастройки.НаименованиеНастройки;
	//	КомпоновщикНастроек.ЗагрузитьНастройки(ПолучитьНастройкиИзXML (СтруктураНастройки.СохраненнаяНастройка.НастройкиXML));
	//	Заголовок = ПолучитьТекстЗаголовкаОтчета()+", настройка = "+ИмяНастройки;
	//	НачПериода = СтруктураНастройки.СохраненнаяНастройка.НачПериода;
	//	КонПериода = СтруктураНастройки.СохраненнаяНастройка.КонПериода;
	//	Попытка
	//		ВидимостьОтборов = СтруктураНастройки.СохраненнаяНастройка.ВидимостьОтборов;
	//	Исключение
	//	КонецПопытки; 
	//	Попытка
	//		ВидимостьПараметров = СтруктураНастройки.СохраненнаяНастройка.ВидимостьПараметров;
	//	Исключение
	//	КонецПопытки; 
	//КонецЕсли;
	
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("спТовары"));
	НайденныйПараметр.Использование = Истина;
	СписокКоробокЗаполнить(спТовары); 
	НайденныйПараметр.Значение = спТовары;
	
	//ОтчетОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат, ДанныеРасшифровки);
	//
	//СгенерироватьКнопкиУправленияГруппировкой();
	//
	// пометки кнопок и видимость параметров, отбора и заголовка отчета
	УстановитьПометкиКнопокОсновнойПанели();
	УстановитьВидимость();
	
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	// для исключения ситуаций восстановления сохраненных настроек отчета
	// без дополнительных настроек отчета
	ИнициализироватьДополнительныеНастройкиОтчета();
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	
	//ОтчетОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат, ДанныеРасшифровки);
	//
	//СгенерироватьКнопкиУправленияГруппировкой();
	//
	//УстановитьПометкиКнопокОсновнойПанели();
	//УстановитьВидимость();
	
КонецПроцедуры

// ----------------------------------------------------------------------------------------------------------

// Процедура для кнопки "Сформировать"
// Формирует и выводит на экран отчет.
// 
Процедура кнСформировать_Нажатие(Кнопка)
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	
	// Инициализация начала замера времени
	ВремяНачалаФормированияОтчета = ТекущаяДата();
	
	ОтчетОбъект.СкомпоноватьРезультат(ЭлементыФормы.Результат, ДанныеРасшифровки);
	
	СгенерироватьКнопкиУправленияГруппировкой();
	
	УстановитьПометкиКнопокОсновнойПанели();
	УстановитьВидимость();
	
КонецПроцедуры //кнСформировать_Нажатие()

// Процедура для кнопки "Открыть в Excel"
// Открывает отчет в Microsoft Office Excel или Open Office Calc,
// т.е. в программе, которая ассоциирована для файлов с расширением .xls
// 
Процедура кнОткрытьВЭксель_Нажатие(Кнопка)
	
	ИмяФайла = "1C_XPORT.XLS";
	ЭлементыФормы.Результат.Записать(КаталогВременныхФайлов() + ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
	ЗапуститьПриложение(КаталогВременныхФайлов() + ИмяФайла);
	
КонецПроцедуры //кнОткрытьВЭксель_Нажатие()

// Процедура для кнопки "Зафиксировать таблицу"
// Фиксирет/расфиксирует строки и колонки таблицы.
// 
Процедура кнЗафиксироватьТаблицу_Нажатие(Кнопка)
	
	ТабДок = ЭлементыФормы.Результат;
	Если Кнопка.Пометка Тогда
		ТабДок.ФиксацияСверху = 0;
		ТабДок.ФиксацияСлева  = 0;
		Кнопка.Пометка = Ложь;
	Иначе
		ТабДок.ФиксацияСверху = ТабДок.ТекущаяОбласть.Верх - 1;
		ТабДок.ФиксацияСлева  = ТабДок.ТекущаяОбласть.Лево - 1;
		Кнопка.Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры //кнЗафиксироватьТаблицу_Нажатие()

// Процедура для кнопки "кнВыбораПериода"
// Открывает форму "БыстрыйВыборСтандартногоПериода"
// и устанавливает даты "НачПериода" и "КонПериода".
// 
Процедура кнВыбораПериода_Нажатие(Элемент)
	
	Период = ПолучитьФорму("БыстрыйВыборСтандартногоПериода", ЭтаФорма).ОткрытьМодально();
	
	Если Период <> Неопределено Тогда
		НачПериода = Период.НачалоПериода;
		КонПериода = Период.КонецПериода;
	КонецЕсли;
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	
КонецПроцедуры //кнВыбораПериода_Нажатие()

// Процедура для кнопок "кнМесяцНазад", "кнМесяцТекущий", "кнМесяцВперед"
// В замисимости то нажатой кнопки, устанавливат Период
// на Предыдущий месяц / Текущий месяц / Следующий месяц.
// 
Процедура кнМесяцНазадВперед_Нажатие(Элемент)
	
	Если Элемент.Имя = "кнМесяцТекущий" Тогда
		НачПериода = НачалоМесяца(ТекущаяДата());
		КонПериода = КонецМесяца(НачПериода);
	Иначе
		ЧислоМесяцев = ?(Элемент.Имя = "кнМесяцНазад", -1, 1);
		НачПериода = НачалоМесяца(ДобавитьМесяц(НачПериода, ЧислоМесяцев));
		КонПериода = КонецМесяца(НачПериода);
	КонецЕсли;
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
	
КонецПроцедуры //кнМесяцНазадВперед_Нажатие()


Процедура ПериодПриИзменении(Элемент)
	
	КонПериода = КонецДня(КонПериода);
	
	Если НачалоДня(НачПериода) > КонецДня(КонПериода) Тогда
		НачПериода = НачалоДня(КонПериода);
	КонецЕсли;	
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = НачалоДня(НачПериода);
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = КонецДня(КонПериода);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Генерирует кнопки управления группировкой
Процедура СгенерироватьКнопкиУправленияГруппировкой() экспорт;

	УстановитьВидимостьПанели(Истина, "ПанельПараметров");
	УстановитьВидимостьПанели(Истина, "ПанельОтборов");
	
	ТабДокумент = ЭтаФорма.ЭлементыФормы.Результат;
	
	НачалоВерх     = ТабДокумент.Верх + 3; // Привязка к верхнему левому углу ПоляТабличногоДокумента
	НачалоЛево     = ТабДокумент.Лево + 3; // Привязка к верхнему левому углу ПоляТабличногоДокумента
	ШагКнопок      = 13;
	ПрефиксИмениКн = "КнГр_";
	
	// Удалить старые кнопки
	Сч = 0;
	Пока Сч < ЭтаФорма.ЭлементыФормы.Количество() Цикл
		ТекЭлемент = ЭтаФорма.ЭлементыФормы.Получить(Сч);
		Если Найти(ТекЭлемент.Имя, ПрефиксИмениКн) > 0 Тогда
			ЭтаФорма.ЭлементыФормы.Удалить(ТекЭлемент);
		Иначе
			Сч = Сч + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Добавть новые кнопки по количеству группировок
	КоличествоГруппировок = ТабДокумент.КоличествоУровнейГруппировокСтрок();
	Для Сч = 1 По КоличествоГруппировок Цикл
		НоваяКнопка = ЭтаФорма.ЭлементыФормы.Добавить(Тип("Кнопка"), ПрефиксИмениКн + Сч); //если ПолеТабличногоДокумента расположено на Форме
		//НоваяКнопка = ЭлементыФормы.Добавить(Тип("Кнопка"), ПрефиксИмениКн + Сч, Истина, ЭлементыФормы.Панель1); //если ПолеТабличногоДокумента расположено на Панели "Панель1"
		НоваяКнопка.Верх      = НачалоВерх;
		НоваяКнопка.Лево      = НачалоЛево + (ШагКнопок * (Сч - 1));
		НоваяКнопка.Высота    = 11;
		НоваяКнопка.Ширина    = 11;
		НоваяКнопка.Шрифт     = Новый Шрифт("Шрифт диалогов и меню", 6);
		НоваяКнопка.Заголовок = "" + Сч;
		НоваяКнопка.СочетаниеКлавиш = Новый СочетаниеКлавиш(Клавиша["_"+сч], Истина, Ложь, Ложь);
		НоваяКнопка.УстановитьДействие("Нажатие", Новый Действие("СвернутьДоУровня"));
		НоваяКнопка.УстановитьПривязку(ГраницаЭлементаУправления.Верх, ЭлементыФормы.ПанельОтборов, ГраницаЭлементаУправления.Низ);
		НоваяКнопка.УстановитьПривязку(ГраницаЭлементаУправления.Низ, ЭлементыФормы.ПанельОтборов, ГраницаЭлементаУправления.Низ);
		
	КонецЦикла;
	
КонецПроцедуры //СгенерироватьКнопкиУправленияГруппировкой()


// Вызывется при нажатии кнопочек "1", "2" и т.д. (для сворачивания группировок)
Процедура СвернутьДоУровня(Элемент)
	
	Уровень = Число(Элемент.Заголовок); // здесь записан нужный уровень
	ЭлементыФормы.Результат.ПоказатьУровеньГруппировокСтрок(Уровень - 1);
	
КонецПроцедуры //СвернутьДоУровня()


Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	//ГлФорма = ЭтаФорма;
	
КонецПроцедуры


Процедура ОбновлениеОтображения()
	
	//ГлФорма = ЭтаФорма;
	
КонецПроцедуры


Процедура ДействияФормыВосстановитьЗначения(Кнопка)
	
	ИмяОтчета  = Строка(ЭтаФорма.ОтчетОбъект);
	//СтруктураНастройки = Новый Структура;
	//СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	//СтруктураНастройки.Вставить("ИмяОбъекта", ИмяОтчета);
	//СтруктураНастройки.Вставить("НаименованиеНастройки", Неопределено);
	//
	//Результат = УниверсальныеМеханизмы.ВосстановлениеНастроек(СтруктураНастройки);
	//
	//Если Результат <> Неопределено Тогда
	//	ИмяНастройки = Результат.НаименованиеНастройки;
	//	КомпоновщикНастроек.ЗагрузитьНастройки(ПолучитьНастройкиИзXML (Результат.СохраненнаяНастройка.НастройкиXML));
	//	НачПериода = Результат.СохраненнаяНастройка.НачПериода;
	//	КонПериода = Результат.СохраненнаяНастройка.КонПериода;
	//	ВидимостьОтборов = Результат.СохраненнаяНастройка.ВидимостьОтборов;
	//	ВидимостьПараметров = Результат.СохраненнаяНастройка.ВидимостьПараметров;
	//	мТекущаяНастройка = Результат.СохраненнаяНастройка;
	//	Заголовок = ПолучитьТекстЗаголовкаОтчета()+", настройка = "+ИмяНастройки;
	//КонецЕсли;
КонецПроцедуры


Процедура ДействияФормыСохранитьЗначения(Кнопка)
	
	Перем СохраненнаяНастройка;
	
	ИмяОтчета  = Строка(ЭтаФорма.ОтчетОбъект);
	СформироватьСтруктуруДляСохраненияНастроек(СохраненнаяНастройка);
	
	//СтруктураНастройки = Новый Структура;
	//СтруктураНастройки.Вставить("Пользователь", глЗначениеПеременной("глТекущийПользователь"));
	//СтруктураНастройки.Вставить("ИмяОбъекта", ИмяОтчета);
	//СтруктураНастройки.Вставить("НаименованиеНастройки", ?(мТекущаяНастройка = Неопределено, Неопределено, мТекущаяНастройка.НаименованиеНастройки));
	//СтруктураНастройки.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);
	//СтруктураНастройки.Вставить("ИспользоватьПриОткрытии", Ложь);
	//СтруктураНастройки.Вставить("СохранятьАвтоматически", Ложь);
	//
	//Результат = УниверсальныеМеханизмы.СохранениеНастроек(СтруктураНастройки);
	//
	//Если Результат <> Неопределено Тогда
	//		
	//	мТекущаяНастройка = Результат;
	//		
	//Иначе
	//	
	//	мТекущаяНастройка = СтруктураНастройки;
	//	
	//КонецЕсли;
КонецПроцедуры

Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	Если ТипЗнч(СтруктураСНастройками) <> Тип("Структура") Тогда
		
		СтруктураСНастройками = Новый Структура;
		
	КонецЕсли;
	
	НачПериода = НачалоДня(НачПериода);
	КонПериода = КонецДня(КонПериода);
	НастройкиXML = ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки());
	
	СтруктураСНастройками.Вставить("НачПериода", НачПериода);
	СтруктураСНастройками.Вставить("КонПериода", КонПериода);
	СтруктураСНастройками.Вставить("НаименованиеНастройки",  ?(мТекущаяНастройка = Неопределено, Неопределено, мТекущаяНастройка.НаименованиеНастройки));
	СтруктураСНастройками.Вставить("ВидимостьОтборов", ВидимостьОтборов);
	СтруктураСНастройками.Вставить("ВидимостьПараметров", ВидимостьПараметров);
	СтруктураСНастройками.Вставить("НастройкиXML", НастройкиXML);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()


Функция ПолучитьXML (Настройки) Экспорт
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Настройки, "settingsComposition", "http://v8.1c.ru/8.1/data-composition-system/settings");
	
	Возврат  ЗаписьXML.Закрыть();
	
КонецФункции

Процедура ПередСохранениемЗначений(Отказ)
	
	НастройкиXML = ПолучитьXML(КомпоновщикНастроек.ПолучитьНастройки());
	
КонецПроцедуры

Функция ПолучитьНастройкиИзXML (ТекстXML) Экспорт
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстXML);
	Возврат СериализаторXDTO.ПрочитатьXML(ЧтениеXML, Тип("НастройкиКомпоновкиДанных"));
	
КонецФункции

Процедура СписокКоробокЗаполнить(СписокКоробок)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Наименование ПОДОБНО ""Гофроящик%""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Результат = Запрос.Выполнить();
	Выгрузка  = Результат.Выгрузить();
	
	МасНоменкл = Выгрузка.ВыгрузитьКолонку("Ссылка");
	СписокКоробок.ЗагрузитьЗначения(МасНоменкл);
	
КонецПроцедуры // СписокКоробокЗаполнить()

Процедура спТоварыПриИзменении(Элемент)
	
	НайденныйПараметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("спТовары"));
	НайденныйПараметр.Использование = Истина;
	НайденныйПараметр.Значение = спТовары;
	
КонецПроцедуры
