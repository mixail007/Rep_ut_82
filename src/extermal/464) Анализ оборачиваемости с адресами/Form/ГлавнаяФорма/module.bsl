﻿Перем ВысотаЗаголовка;
Перем ВосстановилиЗначение;
Перем СтруктураСвязиЭлементовСДанными;
Перем ФормаНастройка;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура УправлениеПометкамиКнопокКоманднойПанели()

	Если ПоказыватьЗаголовок Тогда
		ЭлементыФормы.КоманднаяПанель.Кнопки.Заголовок.Пометка                = Истина;
		ЭлементыФормы.КоманднаяПанель.Кнопки.Подменю.Кнопки.Заголовок.Пометка = Истина;
	Иначе
		ЭлементыФормы.КоманднаяПанель.Кнопки.Заголовок.Пометка                = Ложь;
		ЭлементыФормы.КоманднаяПанель.Кнопки.Подменю.Кнопки.Заголовок.Пометка = Ложь;
	КонецЕсли;

	Если ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх Тогда
		ЭлементыФормы.КоманднаяПанель.Кнопки.Отбор.Пометка                = Ложь;
		ЭлементыФормы.КоманднаяПанель.Кнопки.Подменю.Кнопки.Отбор.Пометка = Ложь;
	Иначе
		ЭлементыФормы.КоманднаяПанель.Кнопки.Отбор.Пометка                = Истина;
		ЭлементыФормы.КоманднаяПанель.Кнопки.Подменю.Кнопки.Отбор.Пометка = Истина;
	КонецЕсли;

КонецПроцедуры // УправлениеПометкамиКнопокКоманднойПанели()

Процедура ОбновитьОтчет() Экспорт
	 //   А.А. 01.10.15 Доступ только к своему подразделению
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя")
	Тогда
	  Если ПостроительОтчета.Отбор.Найти("СкладПодразделение")= Неопределено Тогда
	  ПостроительОтчета.Отбор.Добавить("Склад.Подразделение");
	  конецЕсли;
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
		Если ДоступноеПодразделение = Справочники.Подразделения.НайтиПоКоду("00138") Тогда //для Екатеринбурга 2 подразделения
			список = новый СписокЗначений();
			Список.Добавить(Справочники.Подразделения.НайтиПоКоду("00138"));
			Список.Добавить(Справочники.Подразделения.НайтиПоКоду("00122"));
			ПостроительОтчета.Отбор.СкладПодразделение.ВидСравнения = ВидСравнения.ВСписке;
			ПостроительОтчета.Отбор.СкладПодразделение.Значение = Список;
			ПостроительОтчета.Отбор.СкладПодразделение.Использование = Истина;
		Иначе
			ПостроительОтчета.Отбор.СкладПодразделение.Значение = ДоступноеПодразделение;
			ПостроительОтчета.Отбор.СкладПодразделение.Использование = Истина;
			ПостроительОтчета.Отбор.СкладПодразделение.ВидСравнения = ВидСравнения.Равно;
		КонецЕсли;
		
	КонецЕсли;	
	
	//
	
	СформироватьОтчет(ЭлементыФормы.ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка);

	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДокументРезультат;

КонецПроцедуры

Процедура ВыводЗаголовка()

	// Перезаполнять заголовок можно только у "чистого" отчета
	Если ЭлементыФормы.ДокументРезультат.ВысотаТаблицы = 0 Тогда
		СформироватьОтчет(ЭлементыФормы.ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, Истина);
	КонецЕсли;

	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ЭлементыФормы.ДокументРезультат.Область(1,,ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;

	УправлениеПометкамиКнопокКоманднойПанели();

КонецПроцедуры // ВыводЗаголовка()

Процедура СформироватьЗаголовокФормы()

	Если ДатаНачала = '00010101000000' И ДатаКонца = '00010101000000' Тогда

		ОписаниеПериода     = "Период не установлен";

	Иначе

		Если ДатаНачала = '00010101000000' ИЛИ ДатаКонца = '00010101000000' Тогда

			ОписаниеПериода = ""    + Формат(ДатаНачала, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") 
			                + " - " + Формат(ДатаКонца , "ДФ = ""дд.ММ.гггг""; ДП = ""...""");

		Иначе

			Если ДатаНачала <= ДатаКонца Тогда
				ОписаниеПериода = "" + ПредставлениеПериода(НачалоДня(ДатаНачала), КонецДня(ДатаКонца), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Заголовок=мНазваниеОтчета+" (" + ОписаниеПериода + ")";

КонецПроцедуры // СформироватьЗаголовокФормы()

Процедура ПодготовитьСохраняемыеНастройки()

	СохраненныеНастройки = Новый Структура;
	СохраненныеНастройки.Вставить("НастройкиПостроителя", ПостроительОтчета.ПолучитьНастройки());
	СохраненныеНастройки.Вставить("Показатели"          , Показатели.Выгрузить());
	СохраненныеНастройки.Вставить("СтатусТоваров"       , СтатусТоваров);

	// Остальные реквизиты отчета сохраняются стандартно

КонецПроцедуры

Процедура ПрочитатьСохраняемыеНастройки()

	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда

		ПостроительОтчета.УстановитьНастройки(СохраненныеНастройки.НастройкиПостроителя);
		Показатели.Загрузить(СохраненныеНастройки.Показатели);
		НовыйСтатусТоваров = СохраненныеНастройки.СтатусТоваров;
		Если (СтатусТоваров <> НовыйСтатусТоваров) И (ЗначениеЗаполнено(НовыйСтатусТоваров))  Тогда
			СтатусТоваров = НовыйСтатусТоваров;
			УстановитьТекстЗапросаПостроителяОтчетаССохранениемНастроек();
		КонецЕсли;

		// Остальные реквизиты отчета восстанавливаются стандартно
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьТекстЗапросаПостроителяОтчетаССохранениемНастроек()
	
	// Запоминаем текущую настройку
	Настройки = ПостроительОтчета.ПолучитьНастройки();

	// Перезаполнение текста запроса
	УстановитьТекстЗапросаПостроителяОтчета();

	// Восстанавливаем запомненную настройку
	ПостроительОтчета.УстановитьНастройки(Настройки);		
	
КонецПроцедуры

Процедура УстановитьДоступностьПоляОтбора(ИмяПоля, Доступность)

	Если ЭлементыФормы["ФлажокНастройки" + ИмяПоля].Доступность <> Доступность Тогда
		ЭлементыФормы["ПолеВидаСравнения" + ИмяПоля].Доступность  = Доступность;
		ЭлементыФормы["ФлажокНастройки" + ИмяПоля].Доступность   = Доступность;
		ЭлементыФормы["ПолеНастройки" + ИмяПоля].Доступность     = Доступность;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьДоступностьПолейОтбора()

	// Установим доступность полей.
	Если СтатусТоваров = "ТоварыНаСкладах" Тогда

		УстановитьДоступностьПоляОтбора("Склад", Истина);
		УстановитьДоступностьПоляОтбора("Комиссионер", Ложь);

		ЭлементыФормы.ФлажокНастройкиКомиссионер.Значение = Ложь;

	ИначеЕсли СтатусТоваров = "ТоварыУКомиссионеров" Тогда 

		УстановитьДоступностьПоляОтбора("Склад", Ложь);
		УстановитьДоступностьПоляОтбора("Комиссионер", Истина);
		
		ЭлементыФормы.ФлажокНастройкиСклад.Значение = Ложь;
	Иначе

		УстановитьДоступностьПоляОтбора("Склад", Истина);
		УстановитьДоступностьПоляОтбора("Комиссионер", Истина);

	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события "ПередОткрытием" формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	//   А.А. 01.10.15 Доступ только к своему подразделению
		Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя")
		и не ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "СтаршийМенеджерПодразделения")
		Тогда
		Сообщить("У вас недостаточно прав для просмотра отчета!");
		возврат;
	   КонецЕсли;
//
	
	//Если ЗначениеЗаполнено("глТекущийПользователь) Тогда
	//	ДатаНачала = ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяДатаНачалаОтчетов");
	//КонецЕсли;
	ДатаКонца = РабочаяДата;

	РаскрашиватьИзмерения = ИСТИНА;
	ПоказыватьЗаголовок   = Ложь;
	ИспользоватьСвойстваИКатегории = ЛОЖЬ;

	//НастройкаПолейВыбора("Номенклатура");
	//НастройкаПолейВыбора("Склад");

	СформироватьЗаголовокФормы();
	ЗаполнитьНачальныеНастройки();
	
//	ОбновитьОтборНаФорме();

КонецПроцедуры

// Процедура - обработчик события "ПриОткрытии" формы.
//
Процедура ПриОткрытии()

	Если НЕ ВосстановилиЗначение Тогда
		ВыводЗаголовка();
	КонецЕсли;

	УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, СтруктураСвязиЭлементовСДанными, "ОтчетОбъект.ПостроительОтчета.Отбор");
	УстановитьДоступностьПолейОтбора();

	ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх ;
КонецПроцедуры

// Процедура - обработчик события "ОбновлениеОтображения" формы.
//
Процедура ОбновлениеОтображения()

	СформироватьЗаголовокФормы();

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ

// Процедура - обработчик нажатия на кнопку "Сформировать".
//
Процедура КоманднаяПанельСформировать(Элемент)

	ОбновитьОтчет();

КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Отбор".
//
Процедура КоманднаяПанельОтбор(Кнопка)

	Если НЕ ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх Тогда
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх;
	Иначе
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Нет;
	КонецЕсли;

	УправлениеПометкамиКнопокКоманднойПанели();

КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Заголовок".
//
Процедура КоманднаяПанельЗаголовок(Кнопка)

	ПоказыватьЗаголовок = Не ПоказыватьЗаголовок;
	ВыводЗаголовка();

КонецПроцедуры

// Процедура - обработчик нажатия на кнопку "Настройка".
//
Процедура КоманднаяПанельНастройка(Кнопка)

	ФормаНастройка = ПолучитьФорму("ФормаНастройки", ЭтаФорма);

	Если ФормаНастройка.ОткрытьМодально() = ИСТИНА Тогда

		ОбновитьОтчет();

	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ, ВЫЗЫВАЕМЫЕ ИЗ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПолеВидаСравненияНоменклатураПриИзменении(Элемент)

	ПолеВидаСравненияПриИзменении(Элемент, ЭлементыФормы);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля "ПолеНастройкиНоменклатура".
//
Процедура ПолеНастройкиНоменклатураПриИзменении(Элемент)

	ПолеНастройкиПриИзменении(Элемент, ПостроительОтчета.Отбор);

КонецПроцедуры

Процедура ПолеВидаСравненияСкладКомпанииПриИзменении(Элемент)

	ПолеВидаСравненияПриИзменении(Элемент, ЭлементыФормы);
	
КонецПроцедуры

Процедура ПолеНастройкиСкладКомпанииПриИзменении(Элемент)

	ПолеНастройкиПриИзменении(Элемент, ПостроительОтчета.Отбор);

КонецПроцедуры

Процедура ПолеВидаСравненияКомиссионерПриИзменении(Элемент)

	ПолеВидаСравненияПриИзменении(Элемент, ЭлементыФормы);
	
КонецПроцедуры

Процедура ПолеНастройкиКомиссионерПриИзменении(Элемент)

	ПолеНастройкиПриИзменении(Элемент, ПостроительОтчета.Отбор);

КонецПроцедуры
// Процедура - обработчик события "Нажатие" кнопки "КнопкаНастройкаПериода".
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)

	НП = Новый НастройкаПериода;
	НП.УстановитьПериод(ДатаНачала, ДатаКонца);
	Если НП.Редактировать() Тогда
		ДатаНачала = НП.ПолучитьДатуНачала();
		ДатаКонца  = НП.ПолучитьДатуОкончания();
	КонецЕсли;

КонецПроцедуры

// Обработчик события ПриИзменении элемента формы СтатусТоваров.
//
Процедура СтатусТоваровПриИзменении(Элемент)

	УстановитьТекстЗапросаПостроителяОтчетаССохранениемНастроек();
	ЗаполнитьНачальныеНастройки();
	УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, СтруктураСвязиЭлементовСДанными, "ОтчетОбъект.ПостроительОтчета.Отбор");

	УстановитьДоступностьПолейОтбора();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СОХРАНЕНИЕ И ВОСТАНОВЛЕНИЕ НАСТРОЕК

// Процедура - обработчик события перед сохранением значений формы
//
Процедура ПередСохранениемЗначений(Отказ)

	ПодготовитьСохраняемыеНастройки();

КонецПроцедуры

// Процедура - обработчик события после восстановления значений формы
//
Процедура ПослеВосстановленияЗначений()

	ЗаполнитьНачальныеНастройки();
	ПрочитатьСохраняемыеНастройки();
	ВыводЗаголовка();

	ВосстановилиЗначение = Истина;

КонецПроцедуры

// Процедура - обработчик сообщений
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененТекстЗапроса" И Источник = ФормаНастройка Тогда
		
		УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, СтруктураСвязиЭлементовСДанными, "ОтчетОбъект.ПостроительОтчета.Отбор");

	КонецЕсли; 
	
КонецПроцедуры // ОбработкаОповещения()


////////////////////////////////////////////////////////////////////////////////

ВосстановилиЗначение = Ложь;

// Заполним список выбора для элемента формы СтатусТоваров
ЭлементыФормы.СтатусТоваров.СписокВыбора = мСписокСтатусовТоваров;
