﻿////////////////////////////////////////////////////////////////////////////////
//  Методы, связанные с записью на сервере результатов замеров времени выполнения 
//  ключевых операций и их дальнейшем экспортом.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС


// Процедура записи массива замеров 
//
// Параметры:
//  Замеры - Массив элементов типа Структура
//
// Возвращаемое значение:
// Число - текущее значение периода записи замеров на сервере в секундах.
Функция ЗафиксироватьДлительностьКлючевыхОпераций(Замеры) Экспорт
	
	Для Каждого КлючеваяОперацияЗамер Из Замеры Цикл
		КлючеваяОперацияСсылка = КлючеваяОперацияЗамер.Ключ;
		Буфер = КлючеваяОперацияЗамер.Значение;
		Для Каждого ДатаДанные Из Буфер Цикл
			Данные = ДатаДанные.Значение;
			Длительность = Данные.Получить("Длительность");
			Если Длительность = Неопределено Тогда
				// Неоконченный замер, писать его пока рано
				Продолжить;
			КонецЕсли;
			ЗафиксироватьДлительностьКлючевойОперации(
				КлючеваяОперацияСсылка, 
			    Длительность, 
				ДатаДанные.Ключ, 
				Данные["ДатаОкончания"]);
		КонецЦикла;
	КонецЦикла;
	Возврат ПериодЗаписи();
КонецФункции

// Текущее значение периода записи результатов замеров на сервере
//
// Возвращаемое значение:
// Число - значение в секундах. 
Функция ПериодЗаписи() Экспорт
	ТекущийПериод = Константы.ОценкаПроизводительностиПериодЗаписи.Получить();
	Возврат ?(ТекущийПериод >= 1, ТекущийПериод, 60);
КонецФункции

// Процедура обработки регламентного задания по выгрузке данных
//
// Параметры:
//  КаталогиЭкспорта - Структура со значением типа Массив.
//
Процедура ЭкспортОценкиПроизводительности(КаталогиЭкспорта) Экспорт
	// Если система отключена, то выгрузку данных делать не будем.
	Если Не ОценкаПроизводительностиПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
	    Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Замеры.ДатаЗаписи) КАК ДатаЗамера
	|ИЗ 
	|	РегистрСведений.ЗамерыВремени КАК Замеры";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.ДатаЗамера <> Null Тогда
		ВерхняяГраньДатыЗамеров = Выборка.ДатаЗамера;
	Иначе 
		Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаЗамера", ВерхняяГраньДатыЗамеров);
	СформироватьЗапросРасчетаAPDEX(Запрос);	
	ВыборкаАпдекс = Запрос.Выполнить().Выбрать();
	
	МассивыЗамеров = ЗамерыСРазделениемПоКлючевымОперациям(ВерхняяГраньДатыЗамеров);
	ВыгрузитьРезультаты(КаталогиЭкспорта, ВыборкаАпдекс, МассивыЗамеров);
	
КонецПроцедуры

// Текущая дата на сервере
//
// Возвращаемое значение:
// Дата - Дата и время на сервере.
Функция ДатаИВремяНаСервере() Экспорт
	Возврат ТекущаяДата();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция УстановитьАвтоматическоеОбновлениеКлючевыхОперацийВРИБ() Экспорт
	//Если СтандартныеПодсистемыПовтИсп.ЭтоПлатформа83БезРежимаСовместимости() Тогда
	//	Выполнить("Справочники.КлючевыеОперации.УстановитьОбновлениеПредопределенныхДанных(ОбновлениеПредопределенныхДанных.ОбновлятьАвтоматически)");
	//КонецЕсли;
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Запись результатов замеров времени выполнения ключевых операций

// Процедура записи единичного замера
//
// Параметры:
//  КлючеваяОперацияСсылка - СправочникСсылка.КлючевыеОперации
//  Длительность - Число
//  ДатаНачалаКлючевойОперации - Дата
Процедура ЗафиксироватьДлительностьКлючевойОперации(
	КлючеваяОперацияСсылка, 
	Длительность, 
	ДатаНачалаКлючевойОперации,
	ДатаОкончанияКлючевойОперации = Неопределено,
	ДокументСсылка = неопределено
) Экспорт

	Запись = РегистрыСведений.ЗамерыВремени.СоздатьМенеджерЗаписи();
	Запись.КлючеваяОперация = КлючеваяОперацияСсылка;
	Запись.ДатаНачалаЗамера = УниверсальноеВремя(ДатаНачалаКлючевойОперации);
	Запись.НомерСеанса = НомерСеансаИнформационнойБазы();
	
	Запись.ВремяВыполнения = ?(Длительность = 0, 0.001, Длительность); // Длительность меньше разрешения таймера
	
	Запись.ДатаЗаписи = УниверсальноеВремя(ТекущаяДата());
	Если ДатаОкончанияКлючевойОперации <> Неопределено Тогда
		Запись.ДатаОкончания = УниверсальноеВремя(ДатаОкончанияКлючевойОперации);
	КонецЕсли;
	Запись.Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь(); 
	Запись.ДатаЗаписиЛокальная = ТекущаяДатаСеанса();
	
	Если ДокументСсылка <> Неопределено Тогда //12.04.2016
    	Запись.Документ = ДокументСсылка;
	КонецЕсли;
	
	Запись.Записать();
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Регламентное задание экспорта

Функция ЗамерыСРазделениемПоКлючевымОперациям(ВерхняяГраньДатыЗамеров)
	Запрос = Новый Запрос;
	
	ДатаПоследнейВыгрузки = Константы.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC.Получить();
	Константы.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC.Установить(ВерхняяГраньДатыЗамеров);
	
	Запрос.УстановитьПараметр("ДатаПоследнейВыгрузки", ДатаПоследнейВыгрузки);	
	Запрос.УстановитьПараметр("ВерхняяГраньДатыЗамеров", ВерхняяГраньДатыЗамеров);	
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Замеры.КлючеваяОперация,
	|	Замеры.ДатаНачалаЗамера,
	|	Замеры.ВремяВыполнения,
	|	Замеры.Пользователь,
	|	Замеры.ДатаЗаписи,
	|   Замеры.НомерСеанса 
	|	ИЗ
	|		РегистрСведений.ЗамерыВремени КАК Замеры
	|	ГДЕ
	|		Замеры.ДатаЗаписи >= &ДатаПоследнейВыгрузки И
	|       Замеры.ДатаЗаписи <= &ВерхняяГраньДатыЗамеров
	|	УПОРЯДОЧИТЬ ПО
	|		Замеры.ДатаНачалаЗамера";	
	ВыборкаРезультатов = Запрос.Выполнить().Выгрузить(); // Выбрать();
	Колонки = ВыборкаРезультатов.Колонки;	
	ЗамерыСРазделением = Новый Соответствие;
	КлючеваяОперацияИмяКолонки = "КлючеваяОперация";
	Для Каждого СтрокаРезультатов Из ВыборкаРезультатов Цикл
		
		КлючеваяОперацияСтрока = Строка(СтрокаРезультатов[КлючеваяОперацияИмяКолонки]);
		МассивЗамеровПоКлючевойОперации = ЗамерыСРазделением.Получить(КлючеваяОперацияСтрока);
		Если МассивЗамеровПоКлючевойОперации = Неопределено Тогда
			МассивЗамеровПоКлючевойОперации = Новый Массив;
			ЗамерыСРазделением.Вставить(КлючеваяОперацияСтрока, МассивЗамеровПоКлючевойОперации);	
		КонецЕсли;
		Замер = Новый Структура;
		Для Каждого Колонка Из Колонки Цикл							
			Замер.Вставить(Колонка.Имя, СтрокаРезультатов[Колонка.Имя]);	
		КонецЦикла;	
		
		МассивЗамеровПоКлючевойОперации.Добавить(Замер);
	КонецЦикла;
	Возврат ЗамерыСРазделением;
КонецФункции	

// Формирует запрос для расчета индекса APDEX и устанавливает значения необходимых параметров
//
// Параметры:
//  Запрос - Запрос, процедура заполняет текст и параметры переданного запроса
//
Процедура СформироватьЗапросРасчетаAPDEX(Запрос)
	
	ПолучениеЗамеров = 
	"ВЫБРАТЬ
	|	&КлючеваяОперация%НомерКлючевойОперации% КАК КлючеваяОперация,
	|	Замеры.ВремяВыполнения КАК ВремяВыполнения
	|%ИмяВременнойТаблицы%
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 100
	|		Замеры.КлючеваяОперация КАК КлючеваяОперация,
	|		Замеры.ВремяВыполнения КАК ВремяВыполнения
	|	ИЗ
	|		РегистрСведений.ЗамерыВремени КАК Замеры
	|	ГДЕ
	|		Замеры.ДатаНачалаЗамера < &ДатаЗамера
	|		И Замеры.КлючеваяОперация = &КлючеваяОперация%НомерКлючевойОперации%
	|       И Замеры.ВремяВыполнения > 0
	|       И Замеры.ВремяВыполнения < &КлючеваяОперация%НомерКлючевойОперации%_МаксВремя
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		Замеры.ДатаНачалаЗамера УБЫВ) КАК Замеры";
	
	ОбъединитьВсе =
	"
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|";
	
	ИндексироватьПо = 
	"
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючеваяОперация";
	
	РазделительВременныхТаблиц = 
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
	ПустаяВыборка = 
	"ВЫБРАТЬ	
	|	ЗНАЧЕНИЕ(Справочник.КлючевыеОперации.ПустаяСсылка),
	|	0";
	
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлючевыеОперации.Ссылка КАК КлючеваяОперация,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
	|	КлючевыеОперации.МинимальноДопустимыйУровень КАК ДопустимыйУровень
	|ПОМЕСТИТЬ ВТ_КлючевыеОперации
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.ПометкаУдаления = ЛОЖЬ
	|	И КлючевыеОперации.Ссылка <> ЗНАЧЕНИЕ(Справочник.КлючевыеОперации.ОбщаяПроизводительностьСистемы)";
	
	ТекстЗапроса = ТекстЗапроса + ИндексироватьПо + РазделительВременныхТаблиц;
	
	Выборка = Справочники.КлючевыеОперации.Выбрать();
	
	НетКлючевыхОпераций = Истина;
	НомерКлючевойОперации = 1;
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ПометкаУдаления Или Выборка.Ссылка = Справочники.КлючевыеОперации.ОбщаяПроизводительностьСистемы Тогда
			Продолжить;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("КлючеваяОперация" + НомерКлючевойОперации, Выборка.Ссылка);
		Запрос.УстановитьПараметр("КлючеваяОперация" + НомерКлючевойОперации + "_МаксВремя", 1000 * Выборка.Ссылка.ЦелевоеВремя);
		Врем = СтрЗаменить(ПолучениеЗамеров, "%НомерКлючевойОперации%", Строка(НомерКлючевойОперации));
		Врем = СтрЗаменить(Врем, "%ИмяВременнойТаблицы%", ?(НомерКлючевойОперации = 1, "ПОМЕСТИТЬ ВТ_Замеры", ""));
		ТекстЗапроса = ТекстЗапроса + Врем + ОбъединитьВсе;
		
		НомерКлючевойОперации = НомерКлючевойОперации + 1;
		НетКлючевыхОпераций = Ложь;
	КонецЦикла;
	// Если нет ключевых операций, то возвращаем пустую выборку.
	Если НетКлючевыхОпераций Тогда
		Запрос.Текст = "Выбрать 1 ГДЕ 1 < 0;";
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + ПустаяВыборка + ИндексироватьПо + РазделительВременныхТаблиц;
	
	ТекстЗапроса = ТекстЗапроса + 
	"ВЫБРАТЬ
	|	ВТ_КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	ВЫБОР
	|		КОГДА СУММА(ЕСТЬNULL(ВТ_Замеры.ВремяВыполнения, 0)) = 0
	|			ТОГДА -1
	|		ИНАЧЕ ВЫРАЗИТЬ((СУММА(ВЫБОР
	|						КОГДА ВТ_Замеры.ВремяВыполнения <= ВТ_КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ) + СУММА(ВЫБОР
	|						КОГДА ВТ_Замеры.ВремяВыполнения > ВТ_КлючевыеОперации.ЦелевоеВремя
	|								И ВТ_Замеры.ВремяВыполнения <= ВТ_КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ) / 2) / СУММА(1) КАК ЧИСЛО(6, 3))
	|	КОНЕЦ КАК ТекущийAPDEX,
	|	ВЫБОР
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Идеально)
	|			ТОГДА 1
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Отлично)
	|			ТОГДА 0.94
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Хорошо)
	|			ТОГДА 0.85
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Удовлетворительно)
	|			ТОГДА 0.7
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Плохо)
	|			ТОГДА 0.5
	|	КОНЕЦ КАК МинимальныйAPDEX
	|ИЗ
	|	ВТ_КлючевыеОперации КАК ВТ_КлючевыеОперации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Замеры КАК ВТ_Замеры
	|		ПО ВТ_КлючевыеОперации.КлючеваяОперация = ВТ_Замеры.КлючеваяОперация
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_КлючевыеОперации.КлючеваяОперация,
	|	ВЫБОР
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Идеально)
	|			ТОГДА 1
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Отлично)
	|			ТОГДА 0.94
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Хорошо)
	|			ТОГДА 0.85
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Удовлетворительно)
	|			ТОГДА 0.7
	|		КОГДА ВТ_КлючевыеОперации.ДопустимыйУровень = ЗНАЧЕНИЕ(Перечисление.УровниПроизводительности.Плохо)
	|			ТОГДА 0.5
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	ВЫБОР
	|		КОГДА СУММА(ЕСТЬNULL(ВТ_Замеры.ВремяВыполнения, 0)) = 0
	|			ТОГДА -1
	|		ИНАЧЕ ВЫРАЗИТЬ((СУММА(ВЫБОР
	|						КОГДА ВТ_Замеры.ВремяВыполнения <= ВТ_КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ) + СУММА(ВЫБОР
	|						КОГДА ВТ_Замеры.ВремяВыполнения > ВТ_КлючевыеОперации.ЦелевоеВремя
	|								И ВТ_Замеры.ВремяВыполнения <= ВТ_КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ) / 2) / СУММА(1) КАК ЧИСЛО(6, 3))
	|	КОНЕЦ >= 0";
	
	Запрос.Текст = ТекстЗапроса;
	
КонецПроцедуры

// Сохраняет результаты вычисления APDEX в файл
//
// Параметры:
//  КаталогиЭкспорта - Структура со значением типа Массив.
//  ВыборкаАпдекс - Результат запроса
//  МассивыЗамеров - Структура со значением типа Массив.
Процедура ВыгрузитьРезультаты(КаталогиЭкспорта, ВыборкаАпдекс, МассивыЗамеров)
	
	ДатаФормированияФайла = УниверсальноеВремя(ТекущаяДатаСеанса());
	ПространствоИмен = "www.v8.1c.ru/ssl/performace-assessment/apdexExport";
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xml");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Performance", ПространствоИмен);
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("prf", ПространствоИмен);
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xs", "http://www.w3.org/2001/XMLSchema");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	
	ЗаписьXML.ЗаписатьАтрибут("version", ПространствоИмен, "1.0.0.0");
	ЗаписьXML.ЗаписатьАтрибут("period", ПространствоИмен, Строка(ДатаФормированияФайла));
	
	ТипКлючеваяОперация = ФабрикаXDTO.Тип(ПространствоИмен, "KeyOperation");
	ТипИзмерение = ФабрикаXDTO.Тип(ПространствоИмен, "Measurement");
		    
	Пока ВыборкаАпдекс.Следующий() Цикл
		КлючеваяОперация = ФабрикаXDTO.Создать(ТипКлючеваяОперация);
		КлючеваяОперацияСтрока = Строка(ВыборкаАпдекс.КлючеваяОперация);
		
		КлючеваяОперация.name = КлючеваяОперацияСтрока;
		КлючеваяОперация.currentApdexValue = ВыборкаАпдекс.ТекущийAPDEX;
		КлючеваяОперация.minimalApdexValue = ВыборкаАпдекс.МинимальныйAPDEX;
		
		КлючеваяОперация.priority = ВыборкаАпдекс.КлючеваяОперация.Приоритет;
		КлючеваяОперация.targetValue = ВыборкаАпдекс.КлючеваяОперация.ЦелевоеВремя;
		КлючеваяОперация.uid = Строка(ВыборкаАпдекс.КлючеваяОперация.Ссылка.УникальныйИдентификатор());
		
		Замеры = МассивыЗамеров.Получить(КлючеваяОперацияСтрока);
		Если Замеры <> Неопределено Тогда
			Для Каждого Замер Из Замеры Цикл
				ЗамерXML = ФабрикаXDTO.Создать(ТипИзмерение);					
				ЗамерXML.value = Замер.ВремяВыполнения;
				Если ТипЗнч(Замер.ДатаНачалаЗамера) = Тип("Число") Тогда
					ДатаЗамера = Дата("00010101") + Замер.ДатаНачалаЗамера / 1000;
				Иначе
					ДатаЗамера = Замер.ДатаНачалаЗамера;
				КонецЕсли;	
				ЗамерXML.tUTC = ДатаЗамера;
				ЗамерXML.userName = Замер.Пользователь;
				ЗамерXML.tSaveUTC = Замер.ДатаЗаписи;
				ЗамерXML.sessionNumber = Замер.НомерСеанса;
				КлючеваяОперация.measurement.Добавить(ЗамерXML);
			КонецЦикла;	
		КонецЕсли;
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, КлючеваяОперация);
		
	КонецЦикла;	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();
	
	Для Каждого КлючВыполнятьКаталог Из КаталогиЭкспорта Цикл		
		ВыполнятьКаталог = КлючВыполнятьКаталог.Значение;
		Выполнять = ВыполнятьКаталог[0];
		Если НЕ Выполнять Тогда
			Продолжить;
		КонецЕсли;
		
		КаталогЭкспорта = ВыполнятьКаталог[1];		
		Ключ = КлючВыполнятьКаталог.Ключ;
		Если Ключ = ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания() Тогда
			СоздатьКаталог(КаталогЭкспорта);
		КонецЕсли;
		
				
		КопироватьФайл(ИмяВременногоФайла, ПолноеИмяФайлаЭкспорта(КаталогЭкспорта, ДатаФормированияФайла, ".xml"));				
	КонецЦикла;
	УдалитьФайлы(ИмяВременногоФайла);	
КонецПроцедуры

// Генерирует имя файла для экспорта
//
// Параметры:
//  Каталог - Строка, 
//  ДатаФормированияФайла - Дата, дата и время выполнения замера
//  РасширениеСТочкой - Строка, задающая расширение файла, в виде ".xxx". 
// Возвращаемое значение:
//  Строка - полный путь к файлу экспорта
//
Функция ПолноеИмяФайлаЭкспорта(Каталог, ДатаФормированияФайла, РасширениеСТочкой)
	
	Разделитель = ?(ВРег(Лев(Каталог, 3)) = "FTP", "/", "/");
	Возврат УбратьРазделителиНаКонцеИмениФайла(Каталог, Разделитель) + Разделитель + Формат(ДатаФормированияФайла, "ДФ=""гггг-ММ-дд ЧЧ-мм-сс""") + РасширениеСТочкой;

КонецФункции

// Проверить путь на наличие завершающего слеша и если он есть, удалить его
//
// Параметры:
//  ИмяФайла - Строка
//  Разделитель - Строка
Функция УбратьРазделителиНаКонцеИмениФайла(Знач ИмяФайла, Разделитель)
	
	ДлинаПути = СтрДлина(ИмяФайла);	
	Если ДлинаПути = 0 Тогда
		Возврат ИмяФайла;
	КонецЕсли;
	
	Пока ДлинаПути > 0 И Прав(ИмяФайла, 1) = Разделитель Цикл
		ИмяФайла = Лев(ИмяФайла, ДлинаПути - 1);
		ДлинаПути = СтрДлина(ИмяФайла);
	КонецЦикла;
	
	Возврат ИмяФайла;
	
КонецФункции


//+++ 23.01.2018 добавлен Отправитель, а не реальный адрес
//ТекстСписокФайловВложений - должен содержать пути относительно Сервера! 
//
функция ПослатьПисьмоСервер(АдресПолучателя="", ТекстСписокФайловВложений="", ТекстСообщения = "", Тема = "", Отправитель="", Копии = "", Уведомления = Ложь) Экспорт
	рез = "";
	УЗ  = справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоНаименованию("1c@yst.ru");  //ФИКС!
	
	ИПП=Новый ИнтернетПочтовыйПрофиль;
	ИПП.АдресСервераSMTP=УЗ.SMTPСервер;
	ИПП.ПортSMTP=УЗ.ПортSMTP;
	Если УЗ.ТребуетсяSMTPАутентификация Тогда
		ИПП.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
		ИПП.ПарольSMTP         = УЗ.ПарольSMTP;
		ИПП.ПользовательSMTP   = УЗ.ЛогинSMTP;
	Иначе
		ИПП.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		ИПП.ПарольSMTP         = "";
		ИПП.ПользовательSMTP   = "";
	КонецЕсли;
	Письмо=Новый ИнтернетПочтовоеСообщение;
	Письмо.Отправитель.Адрес 		   = УЗ.АдресЭлектроннойПочты;
	Письмо.Отправитель.ОтображаемоеИмя = ?(Отправитель="", УЗ.Наименование, Отправитель);
	Если  Копии<>"" тогда
		Письмо.Копии.Добавить(Копии);
	КонецЕсли;
	
	Если УЗ.АдресЭлектроннойПочты="1c@yst.ru" тогда //+++ 13.09.2017 скрытая копия самому себе!
		Письмо.СлепыеКопии.Добавить("1c@yst.ru");
	КонецЕсли;

	// Сакулина
	 Если Уведомления = Истина Тогда
		 Письмо.УведомитьОДоставке  = Истина;
		 Письмо.УведомитьОПрочтении = Истина;
		 Письмо.АдресаУведомленияОДоставке.Добавить(УЗ.АдресЭлектроннойПочты);
		 Письмо.АдресаУведомленияОПрочтении.Добавить(УЗ.АдресЭлектроннойПочты);
	 КонецЕсли;
	 //Сакулина
	 
	 //23.01.2018 - обратная расшифровка списка файлов
	СписокФайловВложений = новый СписокЗначений;
	i=Найти(ТекстСписокФайловВложений,";"); L = стрДлина(ТекстСписокФайловВложений);
	пока i>0 и L>1 цикл
		текст1 = лев(ТекстСписокФайловВложений, i-1);   ТекстСписокФайловВложений = прав(ТекстСписокФайловВложений, L-i);
		СписокФайловВложений.Добавить(текст1);
		i=Найти(ТекстСписокФайловВложений,";"); L = стрДлина(ТекстСписокФайловВложений);
	КонецЦикла;	
	 
	 
	 
	 
	//+++( 19.12.2011 - разбор адреса на несколько адресов
	i = Найти(АдресПолучателя,";"); j=Найти(АдресПолучателя, ",");
	k=?(i>0 и i>j,  i, ?(j>0 и j>i, j, 0) );
	
	Если i=0 и j=0 тогда
		Письмо.Получатели.Добавить(АдресПолучателя);
	иначе
		АдрОстаток = СокрЛП(АдресПолучателя);
		пока (k>0) цикл
			Адр1 = Лев(АдрОстаток, k-1);
			Если СокрЛП(Адр1)<>"" и Найти(Адр1,"@")>0 и Найти(Адр1,".")>0 тогда
				Письмо.Получатели.Добавить(Адр1);
			КонецЕсли;
			АдрОстаток = Прав(АдрОстаток, стрДлина(АдрОстаток)-k);
			i = Найти(АдрОстаток,";"); j=Найти(АдрОстаток, ",");
			k=?(i>0 и i>j,  i, ?(j>0 и j>i, j, 0) );
		КонецЦикла;
		Если СокрЛП(АдрОстаток)<>"" и Найти(АдрОстаток,"@")>0 и Найти(АдрОстаток,".")>0 тогда
			Письмо.Получатели.Добавить(сокрЛП(АдрОстаток)); //31.01.2018 !!! не понимает лишних пробелов!
		КонецЕсли;
		
	КонецЕсли; //+++ )
	
	Если ЗначениеЗаполнено(СписокФайловВложений) И СписокФайловВложений.Количество()>0 Тогда
		Для Каждого ТекАдр Из СписокФайловВложений Цикл
			Письмо.Вложения.Добавить(ТекАдр.Значение);
		КонецЦикла;
	КонецЕсли;
	//Письмо.АдресаУведомленияОДоставке.Добавить(УЗ.АдресЭлектроннойПочты);
	//Письмо.АдресаУведомленияОПрочтении.Добавить(УЗ.АдресЭлектроннойПочты);

	
	Письмо.Тема= Тема;
	Если УЗ.АдресЭлектроннойПочты = "formula.auto.plus@yandex.ru" Тогда
		Письмо.ИмяОтправителя ="ООО ""Формула Авто Плюс"", г.Ярославль";
		Письмо.Организация ="ООО ""Формула Авто Плюс"", г.Ярославль";
	Иначе
		
		Письмо.ИмяОтправителя ="ЗАО ТК ""Яршинторг""";
		Письмо.Организация ="ЗАО ТК ""Яршинторг""";
	КонецЕсли;
	
	Письмо.Тексты.Добавить(СокрЛП(ТекстСообщения),ТипТекстаПочтовогоСообщения.простойТекст);
	
	Почта=Новый ИнтернетПочта;
	Попытка
		Почта.Подключиться(ИПП);
		Почта.Послать(Письмо);
		Почта.Отключиться();
		рез = " >>>  Письмо отправлено на эл.адрес: "+АдресПолучателя+". "+строка(СписокФайловВложений.Количество())+" вложенных файлов..."
	Исключение
		Почта.Отключиться();
		рез = "xxxxx Ошибка при отправке письма на эл.адрес: "+АдресПолучателя+" - "+ОписаниеОшибки();
	КонецПопытки;
	
	возврат рез;
КонецФункции
