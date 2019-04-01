﻿Перем мВалютаРегламентированногоУчета Экспорт;

//БАЛАНС (04.12.2007)                       
//
Перем мПроведениеИзФормы Экспорт; 


///////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьДокумента()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ссылка.Номер                               КАК Номер,
	|	Ссылка.Дата                                КАК Дата,
	|	Ссылка.Контрагент                          КАК Получатель,
	|	Ссылка.Организация                         КАК Поставщик,
	|	Ссылка.Организация                         КАК Организация,
	|	НомерСтроки,
	|	ДоговорКонтрагента                         КАК ДоговорВзаиморасчетов,
	|	ДоговорКонтрагента.Представление           КАК ПредставлениеДоговора,
	|	ДоговорКонтрагента.ВалютаВзаиморасчетов    КАК Валюта,
	|	Сделка                                     КАК Сделка,
	|	Сделка.Представление                       КАК ПредставлениеСделки,
	|	УвеличениеДолгаКонтрагента                 КАК УвеличениеДолгаКонтрагента,
	|	УменьшениеДолгаКонтрагента                 КАК УменьшениеДолгаКонтрагента
	|ИЗ
	|	Документ.КорректировкаДолга.СуммыДолга КАК КорректировкаДолга
	|
	|ГДЕ
	|	КорректировкаДолга.Ссылка = &ТекущийДокумент
	|
	|ИТОГИ ПО
	|	ДоговорКонтрагента.ВалютаВзаиморасчетов";


	Шапка = Запрос.Выполнить();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КорректировкаДолга_КорректировкаДолга";

	Макет = ПолучитьМакет("КорректировкаДолга");

	// Выводим шапку накладной
	ЗаголовокВыведен = Ложь;
	НомерПП = 0;
	
	ВыборкаВалют       = Шапка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаВалют.Следующий() Цикл
		
		ИтогоВПлюс  = 0;
		ИтогоВМинус = 0;
		ВыборкаСтрокТовары = ВыборкаВалют.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			
			Если НЕ ЗаголовокВыведен Тогда
				
				ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
				ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(ВыборкаСтрокТовары, "Корректировка долга");
				ТабДокумент.Вывести(ОбластьМакета);

				ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьМакета.Параметры.ПредставлениеПоставщика = ОписаниеОрганизации(СведенияОЮрФизЛице(ВыборкаСтрокТовары.Организация, ВыборкаСтрокТовары.Дата), "ПолноеНаименование,");
				ТабДокумент.Вывести(ОбластьМакета);

				ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьМакета.Параметры.ПредставлениеПолучателя = ОписаниеОрганизации(СведенияОЮрФизЛице(ВыборкаСтрокТовары.Получатель, ВыборкаСтрокТовары.Дата), "ПолноеНаименование,");
				ТабДокумент.Вывести(ОбластьМакета);

				ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
				ЗаголовокВыведен = Истина;
				ТабДокумент.Вывести(ОбластьМакета);
				
			КонецЕсли;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			НомерПП = НомерПП + 1;
			ОбластьМакета.Параметры.НомерПП = НомерПП;
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабДокумент.Вывести(ОбластьМакета);

			ИтогоВПлюс  = ИтогоВПлюс  + ВыборкаСтрокТовары.УвеличениеДолгаКонтрагента;
			ИтогоВМИнус = ИтогоВМИнус + ВыборкаСтрокТовары.УменьшениеДолгаКонтрагента;

		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.ИтогоВПлюс  = ИтогоВПлюс;
		ОбластьМакета.Параметры.ИтогоВМИнус = ИтогоВМИнус;
		ОбластьМакета.Параметры.Валюта      = ВыборкаВалют.Валюта;
		ТабДокумент.Вывести(ОбластьМакета);
		
	КонецЦикла;

	
	Возврат ТабДокумент;

КонецФункции // ПечатьДокумента()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяМакета = "КорректировкаДолга" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьДокумента();
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ДополнительныеПечатныеФормы") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
		ОбъектВнешнейФормы = ИмяМакета.ПолучитьОбъект();
		Если ОбъектВнешнейФормы = Неопределено Тогда
			Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяФайла);
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Ссылка;
		ТабДокумент = Обработка.Печать();

	КонецЕсли;

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СписокМакетов = Новый СписокЗначений;

	СписокМакетов.Добавить("КорректировкаДолга", "Корректировка долга");

	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

#КонецЕсли

// Заполняет документ остатками взаиморасчетов по контрагенту
//
Процедура ЗаполнитьОстаткамиВзаиморасчетовУпр() Экспорт

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Контрагент",  Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	
	Запрос.Текст = 
	 // сумма -  на текущую дату, а курс на дату документа... из самого документа!
	  "ВЫБРАТЬ
	  |	ВзаиморасчетыСКонтрагентами.ДоговорКонтрагента,
	  |	ВзаиморасчетыСКонтрагентами.Сделка,
	  |	ВзаиморасчетыСКонтрагентами.СуммаВзаиморасчетовОстаток,
	  |	ВзаиморасчетыСКонтрагентами.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	  |	ВзаиморасчетыСКонтрагентами.Сделка.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
	  |	ВзаиморасчетыСКонтрагентами.Сделка.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов
	  |ИЗ
	  |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	  |			,
	  |			ДоговорКонтрагента.Владелец = &Контрагент
	  |				И ДоговорКонтрагента.Организация = &Организация) КАК ВзаиморасчетыСКонтрагентами";
      //+++)

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СуммыДолга.Добавить();
		НоваяСтрока.ДоговорКонтрагента = Выборка.ДоговорКонтрагента;
		НоваяСтрока.Сделка = Выборка.Сделка;
		НоваяСтрока.КурсВзаиморасчетов = Выборка.КурсВзаиморасчетов;
		НоваяСтрока.КратностьВзаиморасчетов = Выборка.КратностьВзаиморасчетов;
		Если Выборка.СуммаВзаиморасчетовОстаток > 0 Тогда
			НоваяСтрока.УменьшениеДолгаКонтрагента = Выборка.СуммаВзаиморасчетовОстаток;
		Иначе
			НоваяСтрока.УвеличениеДолгаКонтрагента = - Выборка.СуммаВзаиморасчетовОстаток;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьКурсовымиРазницами() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВзаиморасчетыСКонтрагентами.ДоговорКонтрагента,
	               |	ВзаиморасчетыСКонтрагентами.Сделка,
	               |	ВзаиморасчетыСКонтрагентами.СуммаВзаиморасчетовОстаток,
	               |	ВзаиморасчетыСКонтрагентами.ДоговорКонтрагента.ВалютаВзаиморасчетов,
	               |	ВзаиморасчетыСКонтрагентами.СуммаУпрОстаток
	               |ИЗ
	               |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	               |			,
	               |			ДоговорКонтрагента.Владелец = &Контрагент
	               |				И ДоговорКонтрагента.Организация = &Организация) КАК ВзаиморасчетыСКонтрагентами
	               |ГДЕ
	               |	ВзаиморасчетыСКонтрагентами.СуммаВзаиморасчетовОстаток = 0";
				   
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		НоваяСтрока							 = СуммыДолга.Добавить();
		НоваяСтрока.ДоговорКонтрагента		 = Результат.ДоговорКонтрагента;
		НоваяСтрока.Сделка					 = Результат.Сделка;
		НоваяСтрока.КурсВзаиморасчетов		 = 1;
		НоваяСтрока.КратностьВзаиморасчетов	 = 1;
		Если Результат.СуммаУпрОстаток > 0 Тогда
			НоваяСтрока.УменьшениеДолгаКонтрагентаУпр = Результат.СуммаУпрОстаток;
		Иначе
			НоваяСтрока.УвеличениеДолгаКонтрагентаУпр = - Результат.СуммаУпрОстаток;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуСуммДолга(РезультатЗапросаПоСуммамДолга, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоСуммамДолга.Выгрузить();

	ПодготовитьТаблицуСуммДолгаУпр(ТаблицаТоваров, СтруктураШапкиДокумента);

	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

Процедура ПодготовитьТаблицуСуммДолгаУпр(ТаблицаТоваров, СтруктураШапкиДокумента)

	// Переименуем колонку "Сумма" в "Стоимость" (как в регистрах).
	ТаблицаТоваров.Колонки.Добавить("УвеличениеДолгаУпр", ПолучитьОписаниеТиповЧисла(15,2));
	ТаблицаТоваров.Колонки.Добавить("УменьшениеДолгаУпр", ПолучитьОписаниеТиповЧисла(15,2));

	// Надо расчитать стоимость без НДС.
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		
		Если СтрокаТаблицы.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом Тогда
			СтрокаТаблицы.СделкаВзаиморасчеты = Неопределено;
		ИначеЕсли СтрокаТаблицы.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам 
			И ЗначениеНеЗаполнено(СтрокаТаблицы.СделкаВзаиморасчеты) Тогда
			СтрокаТаблицы.СделкаВзаиморасчеты = Ссылка;
			СтрокаТаблицы.СделкаРасчеты       = Ссылка;
		КонецЕсли;
		
		Если СтрокаТаблицы.ВалютаВзаиморасчетов = Справочники.Валюты.НайтиПоКоду("643") Тогда
			//стандартная процедура
			// Суммы пересчитаем в валюту упр. учета
			СтрокаТаблицы.УвеличениеДолгаУпр = ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.УвеличениеДолгаКонтрагента, 
															СтрокаТаблицы.ВалютаВзаиморасчетов,
															СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
															СтрокаТаблицы.КурсВзаиморасчетов,
															СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
															СтрокаТаблицы.КратностьВзаиморасчетов,
															СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);
			
			СтрокаТаблицы.УменьшениеДолгаУпр = ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.УменьшениеДолгаКонтрагента, 
															СтрокаТаблицы.ВалютаВзаиморасчетов,
															СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
															СтрокаТаблицы.КурсВзаиморасчетов,
															СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
															СтрокаТаблицы.КратностьВзаиморасчетов,
															СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);
		Иначе
			//сумма упр устанавливается вручную
			СтрокаТаблицы.УвеличениеДолгаУпр = СтрокаТаблицы.УвеличениеДолгаКонтрагентаУпр; 
			СтрокаТаблицы.УменьшениеДолгаУпр = СтрокаТаблицы.УменьшениеДолгаКонтрагентаУпр; 
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "СуммыДолга".
//
// Параметры:
// Параметры: 
//  ТаблицаПоСуммамДолга    - таблица значений, содержащая данные для проведения и проверки ТЧ СуммыДолга
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиСуммыДолга(ТаблицаПоСуммамДолга, СтруктураШапкиДокумента, Отказ, Заголовок)

	ИмяТабличнойЧасти = "СуммыДолга";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ДоговорКонтрагента, КурсВзаиморасчетов, КратностьВзаиморасчетов");

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договорах взаиморасчетов.
	ПроверитьОрганизациюДоговораВзаиморасчетовВТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, ТаблицаПоСуммамДолга, Отказ, Заголовок);

	//Для каждого СтрокаТаблицы Из ТаблицаПоСуммамДолга Цикл

	//	Если СтрокаТаблицы.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам
	//	 ИЛИ СтрокаТаблицы.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда

	//		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
	//										 """ табличной части ""Суммы долга"": ";

	//		//Если ЗначениеНеЗаполнено(СтрокаТаблицы.СделкаВзаиморасчеты) Тогда
	//		//	ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + " выбран договор, взаиморасчеты по которому ведутся по заказам.
	//		//						|Необходимо заполнить сделку!", Отказ, Заголовок);
	//		//КонецЕсли;

	//	КонецЕсли;

	//КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиСуммыДолга()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения          - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента  - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  ТаблицаПоСуммамДолга     - таблица значений, содержащая данные для проведения и проверки ТЧ СуммыДолга,
//  Отказ                    - флаг отказа в проведении,
//  Заголовок                - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок);

	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок);
	ДвиженияПоРегистрамВзаиморасчетовДляНДС(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок);

КонецПроцедуры // ДвиженияПоРегистрам()

// Добавляет строку в таблицу значений, соответствующую структуре набора записей регистра.
//
// Параметры:
//  СуммаДолга              - число, сумма долга в валюте взаиморасчетов,
//  ТаблицаДвижений         - таблица значений, в которую надо добавить запись,
//  СтрокаТаблицыДолгов     - строка таблицы значений, содержащая информацию о валюте взаиморасчетов,
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа.
//
Процедура ДобавитьСтрокуВТаблицуДвижений(СуммаДолга, ТаблицаДвижений, СтрокаТаблицыДолгов, СтруктураШапкиДокумента);

	СтрокаТаблицыДвижений = ТаблицаДвижений.Добавить();

	СтрокаТаблицыДвижений.Организация        = СтруктураШапкиДокумента.Организация;
	СтрокаТаблицыДвижений.ДоговорКонтрагента = СтрокаТаблицыДолгов.ДоговорКонтрагента;
	СтрокаТаблицыДвижений.Сделка             = СтрокаТаблицыДолгов.СделкаВзаиморасчеты;

	СтрокаТаблицыДвижений.Сумма = ПересчитатьИзВалютыВВалюту(СуммаДолга,
	                                                         СтрокаТаблицыДолгов.ВалютаВзаиморасчетов,
	                                                         мВалютаРегламентированногоУчета,
	                                                         СтрокаТаблицыДолгов.КурсВзаиморасчетов,
	                                                         1,
	                                                         СтрокаТаблицыДолгов.КратностьВзаиморасчетов,
	                                                         1);

КонецПроцедуры // ДобавитьСтрокуВТаблицуДвижений()

// Формирует движения по регистрам взаиморасчетов для НДС
//
// Параметры:
//  РежимПроведения         - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  ТаблицаПоСуммамДолга    - таблица значений, содержащая данные для проведения и проверки ТЧ СуммыДолга,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрамВзаиморасчетовДляНДС(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок)

	Если НЕ ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;

	НаборДвиженийСПокупателями = Движения.ВзаиморасчетыСПокупателямиДляНДС;

	// Получим таблицы значений, совпадающие со струкутрой набора записей регистра.
	ТаблицаДвиженийСПокупателямиПриход = НаборДвиженийСПокупателями.Выгрузить();
	ТаблицаДвиженийСПокупателямиРасход = ТаблицаДвиженийСПокупателямиПриход.Скопировать();
	
	НаборДвиженийСПоставщиками         = Движения.ВзаиморасчетыСПоставщикамиДляНДС;

	// Получим таблицы значений, совпадающие со струкутрой набора записей регистра.
	ТаблицаДвиженийСПоставщикамиПриход = НаборДвиженийСПоставщиками.Выгрузить();
	ТаблицаДвиженийСПоставщикамиРасход = ТаблицаДвиженийСПоставщикамиПриход.Скопировать();
	
	// Разобьем на таблицы по договорам с покупателями и поставщиками,
	// договора типа "Прочее" по взаиморасчетам для целей НДС не проводим.
	// Корректировки долга с комитентами и комиссионерами тоже не отражаем,
	// потому что в документе недостаточно информации о причине корректировки.
	Для каждого СтрокаТаблицыДолгов Из ТаблицаПоСуммамДолга Цикл
	
		Если СтрокаТаблицыДолгов.ДоговорВид = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда

			Если СтрокаТаблицыДолгов.УвеличениеДолгаКонтрагента <> 0 Тогда

				ДобавитьСтрокуВТаблицуДвижений(СтрокаТаблицыДолгов.УвеличениеДолгаКонтрагента, 
				                               ТаблицаДвиженийСПокупателямиПриход, СтрокаТаблицыДолгов, СтруктураШапкиДокумента);

			КонецЕсли;

			Если СтрокаТаблицыДолгов.УменьшениеДолгаКонтрагента <> 0 Тогда

				ДобавитьСтрокуВТаблицуДвижений(СтрокаТаблицыДолгов.УменьшениеДолгаКонтрагента, 
				                               ТаблицаДвиженийСПокупателямиРасход, СтрокаТаблицыДолгов, СтруктураШапкиДокумента);

			КонецЕсли;

		ИначеЕсли СтрокаТаблицыДолгов.ДоговорВид = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком Тогда

			Если СтрокаТаблицыДолгов.УвеличениеДолгаКонтрагента <> 0 Тогда

				ДобавитьСтрокуВТаблицуДвижений(СтрокаТаблицыДолгов.УвеличениеДолгаКонтрагента, 
				                               ТаблицаДвиженийСПоставщикамиПриход, СтрокаТаблицыДолгов, СтруктураШапкиДокумента);

			КонецЕсли;

			Если СтрокаТаблицыДолгов.УменьшениеДолгаКонтрагента <> 0 Тогда

				ДобавитьСтрокуВТаблицуДвижений(СтрокаТаблицыДолгов.УменьшениеДолгаКонтрагента, 
				                               ТаблицаДвиженийСПоставщикамиРасход, СтрокаТаблицыДолгов, СтруктураШапкиДокумента);

			КонецЕсли;

		КонецЕсли;
	
	КонецЦикла;

	// По регистру ВзаиморасчетыСПокупателямиДляНДС.
	НаборДвиженийСПокупателями.мПериод            = Дата;
	НаборДвиженийСПокупателями.мТаблицаДвижений   = ТаблицаДвиженийСПокупателямиПриход;

	Если Не Отказ Тогда
		Движения.ВзаиморасчетыСПокупателямиДляНДС.ВыполнитьПриход();
	КонецЕсли;

	НаборДвиженийСПокупателями.мТаблицаДвижений   = ТаблицаДвиженийСПокупателямиРасход;

	Если Не Отказ Тогда
		Движения.ВзаиморасчетыСПокупателямиДляНДС.ВыполнитьРасход();
	КонецЕсли;


	// По регистру ВзаиморасчетыСПоставщикамиДляНДС.
	НаборДвиженийСПоставщиками.мПериод            = Дата;
	НаборДвиженийСПоставщиками.мТаблицаДвижений   = ТаблицаДвиженийСПоставщикамиПриход;

	Если Не Отказ Тогда
		Движения.ВзаиморасчетыСПоставщикамиДляНДС.ВыполнитьРасход();
	КонецЕсли;

	НаборДвиженийСПоставщиками.мТаблицаДвижений   = ТаблицаДвиженийСПоставщикамиРасход;

	Если Не Отказ Тогда
		Движения.ВзаиморасчетыСПоставщикамиДляНДС.ВыполнитьПриход();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамВзаиморасчетовДляНДС()

// Формирует движения по регистрам для целей упр. учета
//
// Параметры:
//  РежимПроведения         - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  ТаблицаПоСуммамДолга    - таблица значений, содержащая данные для проведения и проверки ТЧ СуммыДолга,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок)

	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда

		ТаблицаУвеличениеДолга = ТаблицаПоСуммамДолга.Скопировать();
		ТаблицаУменьшениеДолга = ТаблицаПоСуммамДолга.Скопировать();

		Счетчик = 0;
		Пока Счетчик < ТаблицаУвеличениеДолга.Количество() Цикл

			СтрокаТаблицы = ТаблицаУвеличениеДолга.Получить(Счетчик);
			Если СтрокаТаблицы.УвеличениеДолгаКонтрагента = 0 И СтрокаТаблицы.УвеличениеДолгаКонтрагентаУпр = 0 Тогда
				 ТаблицаУвеличениеДолга.Удалить(СтрокаТаблицы);
			Иначе
				Счетчик = Счетчик + 1;
			КонецЕсли;

		КонецЦикла;

		Счетчик = 0;
		Пока Счетчик < ТаблицаУменьшениеДолга.Количество() Цикл

			СтрокаТаблицы = ТаблицаУменьшениеДолга.Получить(Счетчик);

			Если СтрокаТаблицы.УменьшениеДолгаКонтрагента = 0 И СтрокаТаблицы.УменьшениеДолгаКонтрагентаУпр = 0 Тогда
				 ТаблицаУменьшениеДолга.Удалить(СтрокаТаблицы);
			Иначе 
				Счетчик= Счетчик + 1;
			КонецЕсли;

		КонецЦикла;

		Если ТаблицаУвеличениеДолга.Количество() > 0 Тогда

			ТаблицаУвеличениеДолга.Колонки.УвеличениеДолгаКонтрагента.Имя = "СуммаВзаиморасчетов";
			ТаблицаУвеличениеДолга.Колонки.УвеличениеДолгаУпр.Имя         = "СуммаУпр";
			ТаблицаУвеличениеДолга.Колонки.СделкаВзаиморасчеты.Имя        = "Сделка";

			// ПО РЕГИСТРУ ВзаиморасчетыСКонтрагентами.
			НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;

			// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
			ТаблицаДвижений = НаборДвижений.Выгрузить();
			ТаблицаДвижений.Очистить();

			// Заполним таблицу движений.
			ЗагрузитьВТаблицуЗначений(ТаблицаУвеличениеДолга, ТаблицаДвижений);

			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

			Если Не Отказ Тогда
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьПриход();
			КонецЕсли;

			//01.04.2019 ПО РЕГИСТРУ РасчетыСКонтрагентами.
			//НаборДвижений = Движения.РасчетыСКонтрагентами;
			ТаблицаУвеличениеДолга.Колонки.Сделка.Имя = "СделкаВзаиморасчеты";
			ТаблицаУвеличениеДолгаРасчеты = ТаблицаУвеличениеДолга.Скопировать();
			ТаблицаУвеличениеДолгаРасчеты.Колонки.СделкаРасчеты.Имя = "Сделка";

			// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
			//ТаблицаДвижений = НаборДвижений.Выгрузить();
			//ТаблицаДвижений.Очистить();

			// Заполним таблицу движений.
			//ЗагрузитьВТаблицуЗначений(ТаблицаУвеличениеДолгаРасчеты, ТаблицаДвижений);
			
			// Недостающие поля.
			//ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.РасчетыВозврат.Расчеты,"РасчетыВозврат");

			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

			//Если Не Отказ Тогда
			//	Движения.РасчетыСКонтрагентами.ВыполнитьПриход();
			//КонецЕсли;

			ТаблицаКомитентов = ТаблицаУвеличениеДолга.Скопировать();
			Счетчик = 0;
			Пока Счетчик < ТаблицаКомитентов.Количество() Цикл

				СтрокаТаблицы = ТаблицаКомитентов.Получить(Счетчик);

				Если НЕ СтрокаТаблицы.ДоговорВид = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом
				 ИЛИ НЕ СтрокаТаблицы.КонтролироватьДенежныеСредстваКомитента Тогда
					ТаблицаКомитентов.Удалить(СтрокаТаблицы);
				Иначе 
					Счетчик= Счетчик + 1;
				КонецЕсли;

			КонецЦикла;

			Если ТаблицаКомитентов.Количество() > 0 Тогда

				НаборДвижений = Движения.ДенежныеСредстваКомитента;
				ТаблицаДвижений = НаборДвижений.Выгрузить();

				// Заполним таблицу движений.
				ЗагрузитьВТаблицуЗначений(ТаблицаУвеличениеДолгаРасчеты, ТаблицаДвижений);

				НаборДвижений.мПериод          = Дата;
				НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
				Движения.ДенежныеСредстваКомитента.ВыполнитьРасход();

			КонецЕсли;

		КонецЕсли;

		Если ТаблицаУменьшениеДолга.Количество() > 0 Тогда

			ТаблицаУменьшениеДолга.Колонки.УменьшениеДолгаКонтрагента.Имя = "СуммаВзаиморасчетов";
			ТаблицаУменьшениеДолга.Колонки.УменьшениеДолгаУпр.Имя = "СуммаУпр";
			ТаблицаУменьшениеДолга.Колонки.СделкаВзаиморасчеты.Имя = "Сделка";

			// ПО РЕГИСТРУ ВзаиморасчетыСКонтрагентами.
			НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;

			// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
			ТаблицаДвижений = НаборДвижений.Выгрузить();
			ТаблицаДвижений.Очистить();

			// Заполним таблицу движений.
			ЗагрузитьВТаблицуЗначений(ТаблицаУменьшениеДолга, ТаблицаДвижений);

			НаборДвижений.мПериод          = Дата;
			НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

			Если Не Отказ Тогда
				Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
			КонецЕсли;

			//НаборДвижений = Движения.РасчетыСКонтрагентами;
			ТаблицаУменьшениеДолга.Колонки.Сделка.Имя = "СделкаВзаиморасчеты";
			ТаблицаУменьшениеДолгаРасчеты = ТаблицаУменьшениеДолга.Скопировать();
			ТаблицаУменьшениеДолгаРасчеты.Колонки.СделкаРасчеты.Имя = "Сделка";

			// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
			//ТаблицаДвижений = НаборДвижений.Выгрузить();
			//ТаблицаДвижений.Очистить();

			// Заполним таблицу движений.
			//ЗагрузитьВТаблицуЗначений(ТаблицаУменьшениеДолгаРасчеты, ТаблицаДвижений);

			// Недостающие поля.
			//ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.РасчетыВозврат.Расчеты,"РасчетыВозврат");
			
			НаборДвижений.мПериод            = Дата;
			НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

			//Если Не Отказ Тогда
			//	Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
			//КонецЕсли;

			
			ТаблицаКомиссионеров = ТаблицаУменьшениеДолга.Скопировать();
			Счетчик = 0;
			Пока Счетчик < ТаблицаКомиссионеров.Количество() Цикл

				СтрокаТаблицы = ТаблицаКомиссионеров.Получить(Счетчик);

				Если НЕ СтрокаТаблицы.ДоговорВид = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером
				 ИЛИ НЕ СтрокаТаблицы.КонтролироватьДенежныеСредстваКомитента Тогда
					ТаблицаКомиссионеров.Удалить(СтрокаТаблицы);
				Иначе 
					Счетчик= Счетчик + 1;
				КонецЕсли;

			КонецЦикла;

			Если ТаблицаКомиссионеров.Количество() > 0 Тогда

				НаборДвижений = Движения.ДенежныеСредстваКомиссионера;
				ТаблицаДвижений = НаборДвижений.Выгрузить();

				// Заполним таблицу движений.
				ЗагрузитьВТаблицуЗначений(ТаблицаУменьшениеДолга, ТаблицаДвижений);
				
				НаборДвижений.мПериод          = Дата;
				НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

				Движения.ДенежныеСредстваКомиссионера.ВыполнитьРасход();

			КонецЕсли;

		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
  		
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	//+++ 22.07.2011
	Если НЕ рольДоступна("МенеджерПоВзаимозачетам") тогда
		Отказ = Истина;
		Предупреждение("Вы не имеете право проводить документ!",30);
	КонецЕсли;	
	
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "ВалютаУправленческогоУчета", "ВалютаУправленческогоУчета");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "КурсВалютыУправленческогоУчета"    , "КурсВалютыУправленческогоУчета");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика"       , "СписыватьПартииПриПроведенииДокументов" , "СписыватьПартииПриПроведенииДокументов");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполенения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура;
	
	СтруктураПолей.Вставить("ДоговорКонтрагента"                      , "ДоговорКонтрагента");
	СтруктураПолей.Вставить("ВалютаВзаиморасчетов"                    , "ДоговорКонтрагента.ВалютаВзаиморасчетов");
	СтруктураПолей.Вставить("ВедениеВзаиморасчетов"                   , "ДоговорКонтрагента.ВедениеВзаиморасчетов");
	СтруктураПолей.Вставить("ДоговорОрганизация"                      , "ДоговорКонтрагента.Организация");
	СтруктураПолей.Вставить("ДоговорВид"                              , "ДоговорКонтрагента.ВидДоговора");
	СтруктураПолей.Вставить("КонтролироватьДенежныеСредстваКомитента" , "ДоговорКонтрагента.КонтролироватьДенежныеСредстваКомитента");
	СтруктураПолей.Вставить("СделкаВзаиморасчеты"                     , "Сделка");
	СтруктураПолей.Вставить("СделкаРасчеты"                           , "Сделка");
	СтруктураПолей.Вставить("УвеличениеДолгаКонтрагента"              , "УвеличениеДолгаКонтрагента");
	СтруктураПолей.Вставить("УменьшениеДолгаКонтрагента"              , "УменьшениеДолгаКонтрагента");
	СтруктураПолей.Вставить("УвеличениеДолгаКонтрагентаУпр"           , "УвеличениеДолгаКонтрагентаУпр");
	СтруктураПолей.Вставить("УменьшениеДолгаКонтрагентаУпр"           , "УменьшениеДолгаКонтрагентаУпр");
	СтруктураПолей.Вставить("КурсВзаиморасчетов"                      , "КурсВзаиморасчетов");
	СтруктураПолей.Вставить("КратностьВзаиморасчетов"                 , "КратностьВзаиморасчетов");

	РезультатЗапросаПоСуммамДолга = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "СуммыДолга", СтруктураПолей);

	// Подготовим таблицы товаров для проведения.
	ТаблицаПоСуммамДолга = ПодготовитьТаблицуСуммДолга(РезультатЗапросаПоСуммамДолга, СтруктураШапкиДокумента);

	// Проверить заполнение ТЧ 
	ПроверитьЗаполнениеТабличнойЧастиСуммыДолга(ТаблицаПоСуммамДолга, СтруктураШапкиДокумента, Отказ, Заголовок);

	// Проверить заполнение подразделения, если нужно. 
	Если (Константы.ОбязательнаяУстановкаПодразделений.Получить() = Истина) Тогда 
		Если (Подразделение = Справочники.Подразделения.ПустаяСсылка()) Тогда 
			Отказ = Истина;
			Сообщить("Перед проведением, установите подразделение.", СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;

	// Движения по документу
	Если Не Отказ Тогда

		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок);

	КонецЕсли; 

КонецПроцедуры	// ОбработкаПроведения()

Процедура ПриЗаписи(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

//БАЛАНС (04.12.2007)                       
//
мПроведениеИзФормы = Ложь; 