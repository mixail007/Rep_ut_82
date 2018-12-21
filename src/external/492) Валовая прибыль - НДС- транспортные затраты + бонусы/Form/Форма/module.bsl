﻿Перем ВысотаЗаголовка;
Перем ИдентификаторОкнаРасшифровки;
Перем СтруктураРеквизитов;
Перем НеЗаполнятьНастройкиПриОткрытии;
Перем СтруктураСвязиЭлементовСДанными;
Перем ОтборРазвернут;
Перем ФормаНастройка;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Управляет пометками кнопок ком. панели
//
// Параметры:
//	Нет.
//
Процедура УправлениеПараметрамиОтображенияЭлементовФормы()
	
	Если ПоказыватьЗаголовок Тогда
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Заголовок.Пометка = Истина;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Заголовок.Пометка = Истина;

	Иначе
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Заголовок.Пометка = Ложь;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Заголовок.Пометка = Ложь;

	КонецЕсли;

	// Отображение заголовка отчета
	Если НЕ ЗначениеНеЗаполнено(ВысотаЗаголовка) Тогда
		ЭлементыФормы.ДокументРезультат.Область(1,,ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;

	Если ОтборРазвернут Тогда
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Отбор.Пометка = Истина;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка = Истина;
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Нет;
	Иначе
		ЭлементыФормы.ПанельОтбор.Свертка = РежимСверткиЭлементаУправления.Верх;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Отбор.Пометка = Ложь;
		ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Подменю.Кнопки.Отбор.Пометка = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УправлениеПараметрамиОтображенияЭлементовФормы()

// Обновляет таблицу отчета
//
// Параметры:
//	Нет.
//
Процедура ОбновитьОтчет() Экспорт
	
	НеЗаполнятьНастройкиПриОткрытии = Не Открыта();

	ЭтотОтчет.СформироватьОтчет(ЭлементыФормы.ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ложь, ?(флМинПроцНаценки,ПроцентНаценкиМин,0) );

	Если НЕ ЗначениеНеЗаполнено(ВысотаЗаголовка) Тогда
		ЭлементыФормы.ДокументРезультат.Область(1,,ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;

	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДокументРезультат;

	УправлениеПараметрамиОтображенияЭлементовФормы();
	
КонецПроцедуры // ОбновитьОтчет()

//  Управляет выводом заголовка
//
// Параметры:
//	Нет.
//
Процедура ВыводЗаголовка()

	// Перезаполнять заголовок можно только у "чистого" отчета
	Если ЭлементыФормы.ДокументРезультат.ВысотаТаблицы = 0 Тогда

		ЭтотОтчет.СформироватьОтчет(ЭлементыФормы.ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, Истина);
		
	КонецЕсли;

	УправлениеПараметрамиОтображенияЭлементовФормы();
	
КонецПроцедуры // ВыводЗаголовка()

// Формирует текст заголовка
//
// Параметры:
//	Нет.
//
Процедура СформироватьЗаголовокФормы()

	Заголовок = СформироватьЗаголовокОсновнойФормы(ДатаНач, ДатаКон, мНазваниеОтчета, Ложь);

КонецПроцедуры // СформироватьЗаголовокФормы()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ НАЖАТИЯ КНОПОК КОМАНДНОЙ ПАНЕЛИ

// Процедура - обработчик нажатия кнопки "Настройка".
//
Процедура КоманднаяПанельФормыНастройка(Кнопка)
	
	ФормаНастройка = ЭтотОтчет.ПолучитьФормуНастройки();
	ФормаНастройка.ВладелецФормы = ЭтаФорма;

	СтруктураСНастройками = ЭтотОтчет.СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок);

	СтараяДатаКон = ДатаКон;
	СтараяДатаНач = ДатаНач;

	РезультатОткрытия = ФормаНастройка.ОткрытьМодально();

	Если РезультатОткрытия = Истина Тогда

		ОбновитьОтчет();

	Иначе
		
		// Форму закрыли эскейпом или по "Закрыть" - восстановим настройки, отчет формировать не будем!
		// Восстанавливаем сохраненные значения
		
		ЭтотОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок);
		
		ДатаКон = СтараяДатаКон;
		ДатаНач = СтараяДатаНач;
		
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик нажатия кнопки настройки периода
//
Процедура КнопкаНастройкаПериодаНажатие(Элемент)

	Если НП.Редактировать() Тогда
		
		ДатаНач = НП.ПолучитьДатуНачала();
		ДатаКон = НП.ПолучитьДатуОкончания();

	КонецЕсли;
	
КонецПроцедуры // КнопкаНастройкаПериодаНажатие()

// Процедура - обработчик нажатия кнопки "Отбор".
//
Процедура КоманднаяПанельФормыОтбор(Кнопка)

	ОтборРазвернут = НЕ ОтборРазвернут;

	УправлениеПараметрамиОтображенияЭлементовФормы();
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки "Обновить".
//
Процедура КоманднаяПанельФормыОбновить(Кнопка)

//+++   18.05.2012
	началоВр = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ОбновитьОтчет();

	КонецВр = ТекущаяУниверсальнаяДатаВМиллисекундах();
	ВремяВыполнения = Число(КонецВр - началоВр)/1000;
	
 	парамЗапроса = "";
	Если ВремяВыполнения>0 тогда
		//общий модуль:  яштПрочее.ЗаписатьВЖурналИзмененийВремяВыполненияВнешнейОбработки(
		ЗаписатьВЖурналИзмененийВремяВыполненияВнешнейОбработки( 492,Цел(ВремяВыполнения), "Кнопка [Сформировать] - "+парамЗапроса+" ("+строка(ВремяВыполнения)+" Сек.)" ); //!!!!
	КонецЕсли;	
	//+++)   18.05.2012

КонецПроцедуры // ВыполнитьНажатие()

// Процедура - обработчик нажатия кнопки "Заголовок".
//
Процедура КоманднаяПанельФормыЗаголовок(Кнопка)
	
	ПоказыватьЗаголовок = Не ПоказыватьЗаголовок;
	
	ВыводЗаголовка();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик обновления данных формы
//
Процедура ОбновлениеОтображения()

	СформироватьЗаголовокФормы();
	
КонецПроцедуры // ОбновлениеОтображения()

// Процедура - обработчик события перед открытием формы
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	//+++ 26.06.2013 - ограничение по подразделению
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя")
		И НЕ ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "СтаршийМенеджерПодразделения") Тогда
           СообщитьОбОшибке("У вас недостаточно прав для просмотра данного отчета!");
		   Отказ = истина;
		   Возврат;
	КонецЕсли;
	   
//03.10.2018	 
	ДатаНач = НачалоМесяца( НачалоМесяца( ТекущаяДата() )	-1);
    ДатаКон = КонецМесяца(ДатаНач);
	 
	Если НЕ (НеЗаполнятьНастройкиПриОткрытии = Истина) Тогда

		ЭтотОтчет.ОбщийОтчет = ЭтотОбъект;

		ЭтотОтчет.ЗаполнитьНачальныеНастройки();

		ВысотаЗаголовка = 0;

		СформироватьЗаголовокФормы();
		
		// Вспоминим параметры для данной формы
		ИмяОтчета=ЭтотОтчет.Метаданные().Имя;
		ОтборРазвернут=?(ВосстановитьЗначение(ИмяОтчета + "_ОтборПомечен") = Истина, Истина, Ложь); // отбор в первый раз не показывать
		ПоказыватьЗаголовок = ?(ВосстановитьЗначение(ИмяОтчета + "_ЗаголовокПомечен") = Ложь, Ложь, Истина); // заголовок в первый раз наоборот, показывать
		
		ВыводЗаголовка();
		
	КонецЕсли;
		
	УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, СтруктураСвязиЭлементовСДанными, "ОбщийОтчет.ПостроительОтчета.Отбор");
	
КонецПроцедуры // ПередОткрытием()     ЭтотОбъект

// Процедура - обработчик события при открытии формы
//
Процедура ПриОткрытии()
	
	НеЗаполнятьНастройкиПриОткрытии = Ложь;
    мВыбиратьИспользованиеСвойств = истина; //+++ 11.09.2013
	УправлениеПараметрамиОтображенияЭлементовФормы();
	
КонецПроцедуры

// Процедура - обработчик события перед сохранением значений формы
//
Процедура ПередСохранениемЗначений(Отказ)

	СохраненныеНастройки = ЭтотОтчет.СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок);

КонецПроцедуры // ПередСохранениемЗначений()

// Процедура - обработчик события после восстановления значений формы
//
Процедура ПослеВосстановленияЗначений()

	// Если настройка восстанавливается, когда открывается форма сформровенного отчета, игнорируем
	Если НеЗаполнятьНастройкиПриОткрытии Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(СохраненныеНастройки) = Тип("Структура") Тогда
		
		ЭтотОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок);
		
		// Очистим результат - он более не соответствует настройке
		ЭлементыФормы.ДокументРезультат.Очистить();
		ВысотаЗаголовка=0;
		
		ВыводЗаголовка();
		
		СформироватьЗаголовокФормы();
		
	КонецЕсли;

КонецПроцедуры // ПослеВосстановленияЗначений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик изменения данных в поле значения отбора
//
Процедура ПолеНастройки1ПриИзменении(Элемент)

	ПолеНастройкиПриИзменении(Элемент, ПостроительОтчета.Отбор);
	
КонецПроцедуры // ПолеНастройки1ПриИзменении()

// Процедура - обработчик изменения данных в поле значения отбора С
//
Процедура ПолеНастройкиС1ПриИзменении(Элемент)

	ПолеНастройкиСПриИзменении(Элемент, ПостроительОтчета.Отбор);
	
КонецПроцедуры // ПолеНастройкиС1ПриИзменении()

// Процедура - обработчик изменения данных в поле значения отбора ПО
//
Процедура ПолеНастройкиПо1ПриИзменении(Элемент)

	ПолеНастройкиПоПриИзменении(Элемент, ПостроительОтчета.Отбор);

КонецПроцедуры // ПолеНастройкиПо1ПриИзменении()

// Процедура - обработчик изменения данных в поле выбора вида сравнения
//
Процедура ПолеВидаСравнения1ПриИзменении(Элемент)

	ПолеВидаСравненияПриИзменении(Элемент, ПостроительОтчета.Отбор);
	
КонецПроцедуры // ПолеВидаСравнения1ПриИзменении()

// Процедура - обработчик события "Обработка расшифровки" поля табличного документа ДокументРезультат
//
Процедура ДокументРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ЭтотОтчет.ОбработкаРасшифровки(Расшифровка, Элемент, ВысотаЗаголовка, СтандартнаяОбработка);

КонецПроцедуры // ДокументРезультатОбработкаРасшифровки()

// Процедура - обработчик изменения даты начала периода
//
Процедура ДатаНачПриИзменении(Элемент)
	
	НП.УстановитьПериод(ДатаНач, КонецДня(ДатаКон), Истина);
	
КонецПроцедуры

// Процедура - обработчик изменения даты конца периода
//
Процедура ДатаКонПриИзменении(Элемент)
	
	НП.УстановитьПериод(ДатаНач, КонецДня(ДатаКон), Истина);
	
КонецПроцедуры

// Процедура - орбаротчик события при закрытии
//
Процедура ПриЗакрытии()
	
	ИмяОтчета = ЭтотОтчет.Метаданные().Имя;
	
	// Запомним параметры для данной формы
	СохранитьЗначение( ИмяОтчета+ "_ОтборПомечен", ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Отбор.Пометка);
	
	// Запомним параметры для данной формы
	СохранитьЗначение( ИмяОтчета+ "_ЗаголовокПомечен", ЭлементыФормы.КоманднаяПанельФормы.Кнопки.Заголовок.Пометка);
	
КонецПроцедуры

// Процедура - обработчик сообщений
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзмененТекстЗапроса" И Источник = ФормаНастройка Тогда
		
		УстановитьСвязьПолейБыстрогоОтбораНаФорме(ЭлементыФормы, ПостроительОтчета.Отбор, СтруктураСвязиЭлементовСДанными, "ОбщийОтчет.ПостроительОтчета.Отбор");

	КонецЕсли; 
	
КонецПроцедуры // ОбработкаОповещения()

Процедура флМинПроцНаценкиПриИзменении(Элемент)
	ЭлементыФормы.ПроцентНаценкиМин.Видимость = флМинПроцНаценки;
КонецПроцедуры

Процедура ПроцентНаценкиМинРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	Элемент.Значение = Элемент.Значение +Направление*0.1;
	Если Элемент.Значение<0 тогда 
		Элемент.Значение=0;
	КонецЕсли;
КонецПроцедуры


// При инициализации формы необходимо заполнить реквизиты и поля основного реквизита формы 
ЗаполнитьПоляОсновногоРеквизита(ЭтотОтчет.ОбщийОтчет);

НеЗаполнятьНастройкиПриОткрытии = Ложь;
ОтборРазвернут = Ложь;