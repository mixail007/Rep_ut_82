﻿
// Количество строк заголовка поля табличного документа
Перем мКоличествоВыведенныхСтрокЗаголовка Экспорт;

// Настройка периода
Перем НП Экспорт;

// Структура - соответствие имен полей и их представления для построителя отчетов
Перем мСтруктураСоответствияИмен Экспорт;

// Список значений, имена отборов построителя отчета, которые существуют постоянно
Перем мСписокОтбора Экспорт;

// Макет отчета
Перем мМакет;

// Описание типов, заказы
Перем мТипыЗаказов;

// Таблица с данными для диаграммы
Перем мДеревоДиаграммы Экспорт;

// Структура, ключи которой - имена отборов Построителя, значения - параметры Построителя
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция формирует строку представления периода отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьСтрокуПериода() Экспорт

	ОписаниеПериода = "";
	
	// Вывод заголовка, описателя периода и фильтров и заголовка
	Если ДатаНачала = '00010101000000' И ДатаОкончания = '00010101000000' Тогда

		ОписаниеПериода     = "Период не установлен";

	Иначе

		Если ДатаНачала = '00010101000000' ИЛИ ДатаОкончания = '00010101000000' Тогда

			ОписаниеПериода = "Период: " + Формат(ДатаНачала, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") 
							+ " - "      + Формат(ДатаОкончания, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");

		Иначе

			Если ДатаНачала <= ДатаОкончания Тогда
				ОписаниеПериода = "Период: " + ПредставлениеПериода(НачалоДня(ДатаНачала), КонецДня(ДатаОкончания), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат ОписаниеПериода;
	
КонецФункции // ()

// Процедура меняет видимость заголовка поля табличного документа
// 
// Параметры
//  Таб - табличный документ
//
// Возвращаемые значения
//  НЕТ
Процедура ИзменитьВидимостьЗаголовка(Таб) Экспорт

	ОбластьВидимости = Таб.Область(1,,мКоличествоВыведенныхСтрокЗаголовка,);
	ОбластьВидимости.Видимость = ПоказыватьЗаголовок;

КонецПроцедуры

// Процедура передает построителю отчета запрос
//
// Параметры
//  НЕТ
//
// Возвращаемое значение
//  НЕТ
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт

	ТекстЗапроса = "
	|
	|ВЫБРАТЬ //РАЗЛИЧНЫЕ
	|
	|	СУММА(ВЫБОР КОГДА ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПокупателя ТОГДА
	|			ПричиныЗакрытияЗаказов.СуммаВзаиморасчетов
	|		  ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК СуммаВзаиморасчетовЗаказПокупателя,
	|
	|	СУММА(ВЫБОР КОГДА ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПокупателя ТОГДА
	|			ПричиныЗакрытияЗаказов.СуммаУпрУчета
	|		  ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК СуммаУпрУчетаЗаказПокупателя,
	|
	|	СУММА(ВЫБОР КОГДА ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПоставщику ТОГДА
	|			-1*ПричиныЗакрытияЗаказов.СуммаВзаиморасчетов
	|		  ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК СуммаВзаиморасчетовЗаказПоставщику,
	|
	|	СУММА(ВЫБОР КОГДА ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПоставщику ТОГДА
	|			-1*ПричиныЗакрытияЗаказов.СуммаУпрУчета
	|		  ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК СуммаУпрУчетаЗаказПоставщику,
	|
	|	ПричиныЗакрытияЗаказов.Заказ.КурсВзаиморасчетов                                       КАК КурсВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.Заказ.СуммаДокумента                                           КАК СуммаЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.ВалютаДокумента                                          КАК ВалютаДокумента,
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа                                          КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ                                                          КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Заказ.ДоговорКонтрагента.ВалютаВзаиморасчетов.Представление    КАК ВалютаВзаиморасчетов,
	|	ПричиныЗакрытияЗаказов.Заказ.ДоговорКонтрагента.ВалютаВзаиморасчетов                  КАК ВалютаВзаиморасчетовСсылка
	|{ВЫБРАТЬ
	|	ПричиныЗакрытияЗаказов.Заказ.* КАК Заказ,
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.Контрагент.* КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный.* КАК ОтветственныйЗаЗаказ,
	|	ПричиныЗакрытияЗаказов.Регистратор.Ответственный.* КАК ОтветственныйЗаЗакрытиеЗаказа
	|//СВОЙСТВА
	|}
	|
	|ИЗ
	|	РегистрСведений.ПричиныЗакрытияЗаказов КАК ПричиныЗакрытияЗаказов
	|//СОЕДИНЕНИЯ
	|
	|ГДЕ
	|	((&ДатаОкончания = &ПустаяДата И &ДатаНачала = &ПустаяДата)
	|	ИЛИ
	|	((&ДатаОкончания = &ПустаяДата И &ДатаНачала <> &ПустаяДата) И ПричиныЗакрытияЗаказов.Регистратор.Дата >= &ДатаНачала)
	|	ИЛИ
	|	((&ДатаОкончания <> &ПустаяДата И &ДатаНачала = &ПустаяДата) И ПричиныЗакрытияЗаказов.Регистратор.Дата <= &ДатаОкончания)
	|	ИЛИ
	|	((&ДатаОкончания <> &ПустаяДата И &ДатаНачала <> &ПустаяДата) И (ПричиныЗакрытияЗаказов.Регистратор.Дата <= &ДатаОкончания И ПричиныЗакрытияЗаказов.Регистратор.Дата >= &ДатаНачала)))";
	
	Если ПризнакАнализаЗаказов = 1 Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПокупателя
		|";
	ИначеЕсли ПризнакАнализаЗаказов = 2 Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И
		|	ПричиныЗакрытияЗаказов.Заказ ССЫЛКА Документ.ЗаказПоставщику
		|";
	КонецЕсли; 
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|{ГДЕ
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.* КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Заказ.Контрагент.* КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный.* КАК ОтветственныйЗаЗаказ,
	|	ПричиныЗакрытияЗаказов.Регистратор.Ответственный.* КАК ОтветственныйЗаЗакрытиеЗаказа
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|	}
	|
	|СГРУППИРОВАТЬ ПО
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ,
	|	ПричиныЗакрытияЗаказов.СуммаУпрУчета
	|
	|{УПОРЯДОЧИТЬ ПО
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.* КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Заказ.Контрагент.* КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный.* КАК ОтветственныйЗаЗаказ,
	|	ПричиныЗакрытияЗаказов.Регистратор.Ответственный.* КАК ОтветственныйЗаЗакрытиеЗаказа,
	|	ПричиныЗакрытияЗаказов.СуммаУпрУчета КАК СуммаУпрУчета
	|	//СВОЙСТВА
	|	}
	|
	|ИТОГИ СУММА(СуммаВзаиморасчетовЗаказПокупателя),
	|	   СУММА(СуммаУпрУчетаЗаказПокупателя),
	|	   СУММА(СуммаВзаиморасчетовЗаказПоставщику),
	|	   СУММА(СуммаУпрУчетаЗаказПоставщику),
	|	   СУММА(СуммаЗаказа) ПО
	|	ПричинаЗакрытияЗаказа,
	|	Заказ
	|{ИТОГИ ПО
	|	ПричиныЗакрытияЗаказов.ПричинаЗакрытияЗаказа КАК ПричинаЗакрытияЗаказа,
	|	ПричиныЗакрытияЗаказов.Заказ.* КАК Заказ,
	|	ПричиныЗакрытияЗаказов.Заказ.Контрагент.* КАК Контрагент,
	|	ПричиныЗакрытияЗаказов.Заказ.Ответственный.* КАК ОтветственныйЗаЗаказ,
	|	ПричиныЗакрытияЗаказов.Регистратор.Ответственный.* КАК ОтветственныйЗаЗакрытиеЗаказа
	|	//СВОЙСТВА
	|	}
	|";
	
	мСтруктураСоответствияИмен.Очистить();
	мСтруктураСоответствияИмен = Новый Структура("ПричинаЗакрытияЗаказа, ОтветственныйЗаЗаказ, ОтветственныйЗаЗакрытиеЗаказа, СуммаУпрУчета", "Причина закрытия заказа", "Ответственный за заказ", "Ответственный за закрытие заказа", "Сумма в валюте упр.учета");
	
	мСоответствиеНазначений = Новый Соответствие;

	Если ИспользоватьСвойстваИКатегории Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "ПричиныЗакрытияЗаказов.Заказ.Контрагент";
		НоваяСтрока.Представление = "Контрагент";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;

		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";

		// Добавим строки запроса, необходимые для использования свойств и категорий
		ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, мСтруктураСоответствияИмен, мСоответствиеНазначений, ПостроительОтчета.Параметры, , ТекстПоляКатегорий, ТекстПоляСвойств, , , , , , мСтруктураДляОтбораПоКатегориям);

	КонецЕсли;
	
	ПостроительОтчета.Текст = ТекстЗапроса;
	
	Если ИспользоватьСвойстваИКатегории Тогда
		УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, мСтруктураСоответствияИмен);
	КонецЕсли;
	
	ЗаполнитьПредставленияПолей(мСтруктураСоответствияИмен, ПостроительОтчета);
	
	Для каждого ЭлементСписка Из мСписокОтбора Цикл
		Если ПостроительОтчета.Отбор.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			ПостроительОтчета.Отбор.Добавить(ЭлементСписка.Значение);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ ОТЧЕТА

// Процедура заполняет ПолеТабличногоДокумента
//
// Параметры - Таб - ПолеТабличногоДокумента
Процедура СформироватьОтчет(Таб) Экспорт

	ПостроительОтчета.Параметры.Вставить("ПустаяДата", '00010101000000');
	ПостроительОтчета.Параметры.Вставить("ДатаНачала", НачалоДня(ДатаНачала));
	ПостроительОтчета.Параметры.Вставить("ДатаОкончания", ?(ДатаОкончания = '00010101000000', ДатаОкончания, КонецДня(ДатаОкончания)));

	Если НЕ ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		Возврат;
	КонецЕсли;

	ПостроительОтчета.Выполнить();
	
	Если ПризнакАнализаЗаказов = 0 Тогда
		КонечнаяКолонкаОбластиПоВыделеннымКолонкам = 8;
	Иначе
		КонечнаяКолонкаОбластиПоВыделеннымКолонкам = 5;
	КонецЕсли; 

	Таб.Очистить();
	
	Секция = мМакет.ПолучитьОбласть("ШапкаВерх");
	Таб.Вывести(Секция);
	Таб.Область(2, 2, 2, КонечнаяКолонкаОбластиПоВыделеннымКолонкам).ПоВыделеннымКолонкам = Истина;
	
	Секция = мМакет.ПолучитьОбласть("ШапкаИнтервал");
	Секция.Параметры.СтрокаИнтервал = СформироватьСтрокуПериода();
	Таб.Вывести(Секция);
	Таб.Область(4, 2, 4, КонечнаяКолонкаОбластиПоВыделеннымКолонкам).ПоВыделеннымКолонкам = Истина;
	мКоличествоВыведенныхСтрокЗаголовка = 4;
	
	СтрокаГруппировок = СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	Если НЕ ПустаяСтрока(СтрокаГруппировок) Тогда
		СтрокаГруппировок = "Группировки строк: " + СтрокаГруппировок;
		Секция = мМакет.ПолучитьОбласть("ШапкаГруппировки");
		Секция.Параметры.СтрокаГруппировок = СтрокаГруппировок;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
		Таб.Область(мКоличествоВыведенныхСтрокЗаголовка, 2, мКоличествоВыведенныхСтрокЗаголовка, КонечнаяКолонкаОбластиПоВыделеннымКолонкам).ПоВыделеннымКолонкам = Истина;
	КонецЕсли; 

	СтрокаОтборов = СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	Если НЕ ПустаяСтрока(СтрокаОтборов) Тогда
		СтрокаОтборов = "Отбор: " + СтрокаОтборов;
		Секция = мМакет.ПолучитьОбласть("ШапкаОтбор");
		Секция.Параметры.СтрокаОтборов = СтрокаОтборов;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
		Таб.Область(мКоличествоВыведенныхСтрокЗаголовка, 2, мКоличествоВыведенныхСтрокЗаголовка, КонечнаяКолонкаОбластиПоВыделеннымКолонкам).ПоВыделеннымКолонкам = Истина;
	КонецЕсли; 
	
	СтрокаПорядка = СформироватьСтрокуПорядка(ПостроительОтчета.Порядок);
	Если НЕ ПустаяСтрока(СтрокаПорядка) Тогда
		СтрокаПорядка = "Сортировка: " + СтрокаПорядка;
		Секция = мМакет.ПолучитьОбласть("ШапкаПорядок");
		Секция.Параметры.СтрокаПорядка = СтрокаПорядка;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
		Таб.Область(мКоличествоВыведенныхСтрокЗаголовка, 2, мКоличествоВыведенныхСтрокЗаголовка, КонечнаяКолонкаОбластиПоВыделеннымКолонкам).ПоВыделеннымКолонкам = Истина;
	КонецЕсли;
	
	ПредставлениеВалютыУпрУчета = Константы.ВалютаУправленческогоУчета.Получить().Наименование;
	
	Секция = мМакет.ПолучитьОбласть("ШапкаТаблицы|КолонкаОбщая");
	Таб.Вывести(Секция);
	
	Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 1 Тогда
		Секция = мМакет.ПолучитьОбласть("ШапкаТаблицы|КолонкаПокупатели");
		Секция.Параметры.ПредставлениеВалютыУпрУчета = "в " + ПредставлениеВалютыУпрУчета;
		Таб.Присоединить(Секция);
	КонецЕсли; 
	
	Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 2 Тогда
		Секция = мМакет.ПолучитьОбласть("ШапкаТаблицы|КолонкаПоставщики");
		Секция.Параметры.ПредставлениеВалютыУпрУчета = "в " + ПредставлениеВалютыУпрУчета;
		Таб.Присоединить(Секция);
	КонецЕсли; 
	
	Таб.НачатьАвтогруппировкуСтрок();
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	// Заполним данные для возможной диаграммы, дерево значений
	ДеревоДиаграммы = Новый ДеревоЗначений;
	ДеревоДиаграммы.Колонки.Добавить("Группировка");
	ДеревоДиаграммы.Колонки.Добавить("ИмяГруппировки");
	Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 1 Тогда
		ДеревоДиаграммы.Колонки.Добавить("ПоЗаказуПокупателя", Новый ОписаниеТипов("Число"));
	КонецЕсли;
	Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 2 Тогда
		ДеревоДиаграммы.Колонки.Добавить("ПоЗаказуПоставщику", Новый ОписаниеТипов("Число"));
	КонецЕсли; 
	
	ВывестиСтроки(Таб, мМакет, РезультатЗапроса, 0, ДеревоДиаграммы.Строки);

	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	мДеревоДиаграммы = ДеревоДиаграммы;
	
	ИзменитьВидимостьЗаголовка(Таб);
	
	Таб.ТолькоПросмотр = Истина;
	
	Таб.Показать();
	
КонецПроцедуры

// Процедура выводит строки в ПолеТабличногоДокумента
// 
// Параметры
//  Таб - ПолеТабличногоДокумента
//  Макет - макет отчета
//  ТекущаяВыборка - выборка запроса, из которой выводить строки
//  МассивГруппировок - массив с именами группировок
//  ИндексТекущейГруппировки - число, индекс выводимой группировки
// 
// Возвращаемое значение
//  НЕТ
Процедура ВывестиСтроки(Таб, Макет, ТекущаяВыборка, ИндексТекущейГруппировки, СтрокиДереваДиаграммы)

	Если ИндексТекущейГруппировки > ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеГруппировки = ПостроительОтчета.ИзмеренияСтроки[ИндексТекущейГруппировки].Имя;
	
	// Если добавить в группировки строк одинаковые значения, то в именах групировок
	// добавляется цифра 1,2,3..., а поля таблицы запроса естественно не добавляются с такими именами
	// поэтому из имени группировки удилим последние цифры в имени
	
	а = СтрДлина(НаименованиеГруппировки);
	Пока а > 0 Цикл
		Если КодСимвола(Сред(НаименованиеГруппировки, а, 1)) >= 49 И КодСимвола(Сред(НаименованиеГруппировки, а, 1)) <= 57 Тогда
			а = а - 1;
			Продолжить;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	НаименованиеГруппировки = Лев(НаименованиеГруппировки, а);

	Выборка = ТекущаяВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, НаименованиеГруппировки);
	
	Пока Выборка.Следующий() Цикл

		СтрокаДереваДиаграммы = СтрокиДереваДиаграммы.Добавить();
		СтрокаДереваДиаграммы.Группировка    = Выборка[НаименованиеГруппировки];
		СтрокаДереваДиаграммы.ИмяГруппировки = НаименованиеГруппировки;

		ТекущийЦвет = Новый Цвет;
		Если РаскрашиватьГруппировки Тогда
			Если ИндексТекущейГруппировки <> ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
				ИндексЦвета = ИндексТекущейГруппировки;
				Если ИндексЦвета >= 10 Тогда
					ИндексЦвета = (ИндексТекущейГруппировки/10 - Цел(ИндексТекущейГруппировки/10))*10;
				КонецЕсли; 
				ТекущийЦвет = Макет.Области["Цвет"+СокрЛП(Строка(ИндексЦвета))].ЦветФона;
			Иначе
				ТекущийЦвет = Новый Цвет;
			КонецЕсли; 
		КонецЕсли;
			
		СтрокаВывода = СокрЛП(Строка(Выборка[НаименованиеГруппировки]));
		Если ПустаяСтрока(СтрокаВывода) Тогда
			СтрокаВывода = "<...>";
		КонецЕсли;

		Секция = Макет.ПолучитьОбласть("СтрокаГруппировки|КолонкаОбщая");
		
		Секция.Параметры.ПредставлениеГруппировки = СтрокаВывода;
		Секция.Области.ПредставлениеГруппировки.Расшифровка = Выборка[НаименованиеГруппировки];
		Секция.Области.ПредставлениеГруппировки.Отступ = ИндексТекущейГруппировки;
		Секция.Области.ПредставлениеГруппировки.ЦветФона = ТекущийЦвет;
		Таб.Вывести(Секция, ИндексТекущейГруппировки);
		
		// Заказ покупателя
		Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 1 Тогда
			Секция = Макет.ПолучитьОбласть("СтрокаГруппировки|КолонкаПокупатели");
			Секция.Области.ПредставлениеЗаказаПокупателя.ЦветФона = ТекущийЦвет;
			Если НЕ ЗначениеНеЗаполнено(Выборка.СуммаУпрУчетаЗаказПокупателя) Тогда
				Секция.Параметры.СуммаЗаказПокупателяУпрУчет = Формат(Выборка.СуммаУпрУчетаЗаказПокупателя,"ЧЦ=15; ЧДЦ=2");
				СтрокаДереваДиаграммы.ПоЗаказуПокупателя = Выборка.СуммаУпрУчетаЗаказПокупателя;
			КонецЕсли; 
			Если мТипыЗаказов.СодержитТип(ТипЗнч(Выборка[НаименованиеГруппировки])) Тогда
				Если НЕ ЗначениеНеЗаполнено(Выборка.СуммаВзаиморасчетовЗаказПокупателя) Тогда
					Секция.Параметры.СуммаЗаказПокупателяВзаиморасчеты = Формат(Выборка.СуммаВзаиморасчетовЗаказПокупателя,"ЧЦ=15; ЧДЦ=2") + ", " + Выборка.ВалютаВзаиморасчетов;
				КонецЕсли; 
				Если ТипЗнч(Выборка[НаименованиеГруппировки]) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
					Если Выборка.ВалютаДокумента = Выборка.ВалютаВзаиморасчетовСсылка Тогда
						СуммаЗаказа = Выборка.СуммаЗаказа;
					Иначе
						СуммаЗаказа = ?(Выборка.КурсВзаиморасчетов = 0, 0, Окр((Выборка.СуммаЗаказа/Выборка.КурсВзаиморасчетов), 2));
					КонецЕсли; 
					Секция.Параметры.СуммаЗаказПокупателя = Формат(СуммаЗаказа,"ЧЦ=15; ЧДЦ=2") + ", " + Выборка.ВалютаВзаиморасчетов;
				КонецЕсли; 
			КонецЕсли; 
			Таб.Присоединить(Секция);
		КонецЕсли; 
		
		// Заказ поставщику
		Если ПризнакАнализаЗаказов = 0 ИЛИ ПризнакАнализаЗаказов = 2 Тогда
			Секция = Макет.ПолучитьОбласть("СтрокаГруппировки|КолонкаПоставщики");
			Секция.Области.ПредставлениеЗаказаПоставщику.ЦветФона = ТекущийЦвет;
			Если НЕ ЗначениеНеЗаполнено(Выборка.СуммаУпрУчетаЗаказПоставщику) Тогда
				Секция.Параметры.СуммаЗаказПоставщикуУпрУчет = Формат(Выборка.СуммаУпрУчетаЗаказПоставщику,"ЧЦ=15; ЧДЦ=2");
				СтрокаДереваДиаграммы.ПоЗаказуПоставщику = Выборка.СуммаУпрУчетаЗаказПоставщику;
			КонецЕсли; 
			Если мТипыЗаказов.СодержитТип(ТипЗнч(Выборка[НаименованиеГруппировки])) Тогда
				Если НЕ ЗначениеНеЗаполнено(Выборка.СуммаВзаиморасчетовЗаказПоставщику) Тогда
					Секция.Параметры.СуммаЗаказПоставщикуВзаиморасчеты = Формат(Выборка.СуммаВзаиморасчетовЗаказПоставщику,"ЧЦ=15; ЧДЦ=2") + ", " + Выборка.ВалютаВзаиморасчетов;;
				КонецЕсли; 
				Если ТипЗнч(Выборка[НаименованиеГруппировки]) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
					Если Выборка.ВалютаДокумента = Выборка.ВалютаВзаиморасчетовСсылка Тогда
						СуммаЗаказа = Выборка.СуммаЗаказа;
					Иначе
						СуммаЗаказа = ?(Выборка.КурсВзаиморасчетов = 0, 0, Окр((Выборка.СуммаЗаказа/Выборка.КурсВзаиморасчетов), 2));
					КонецЕсли; 
					Секция.Параметры.СуммаЗаказПоставщику = Формат(СуммаЗаказа,"ЧЦ=15; ЧДЦ=2") + ", " + Выборка.ВалютаВзаиморасчетов;
				КонецЕсли; 
			КонецЕсли; 
			Таб.Присоединить(Секция);
		КонецЕсли; 
		
		ВывестиСтроки(Таб, Макет, Выборка, ИндексТекущейГруппировки + 1, СтрокаДереваДиаграммы.Строки);
	
	КонецЦикла; 
	
КонецПроцедуры

НП = Новый НастройкаПериода;

мМакет = ПолучитьМакет("Макет");

мКоличествоВыведенныхСтрокЗаголовка = 0;

// Установим имены быстрых отборов
мСписокОтбора = Новый СписокЗначений;
мСписокОтбора.Добавить("Контрагент");

мСтруктураСоответствияИмен = Новый Структура;

мТипыЗаказов = Новый ОписаниеТипов("ДокументСсылка.ЗаказПокупателя,ДокументСсылка.ЗаказПоставщику");
