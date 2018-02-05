﻿Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Добавляет строку в табличную часть "Разделы"
//
// Возвращаемое значение:
//   строка табличной части, которую добавили.
//
Функция ДобавитьРаздел() Экспорт

#Если Клиент Тогда
	СтавкаПошлины = ВосстановитьЗначение("СтавкаТаможеннойПошлины");
#Иначе
	СтавкаПошлины = 0;
#КонецЕсли

	НовыйРаздел = Разделы.Добавить();
	НовыйРаздел.НДСВВалюте     = Ложь;
	НовыйРаздел.ПошлинаВВалюте = Истина;
	НовыйРаздел.СтавкаНДС      = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяСтавкаНДС");
	НовыйРаздел.СтавкаПошлины  = СтавкаПошлины;
	НовыйРаздел.ТаможеннаяСтоимостьВВалютеРеглУчета = (ЗначениеНеЗаполнено(ВалютаДокумента) ИЛИ (ВалютаДокумента = мВалютаРегламентированногоУчета));

	Возврат НовыйРаздел;

КонецФункции // ДобавитьРаздел()

// Вычисляет суммы по данным раздела.
//
// Параметры
//  НомерРаздела   - число, номер раздела по которому надо получить итоги,
//  ВсегоСтоимость - число, в этот параметр будет возвращена сумма фактурной стоимости,
//  ВсегоПошлина   - число, в этот параметр будет возвращена сумма пошлины, 
//  ВсегоНДС       - число, в этот параметр будет возвращена сумма НДС.
//
Процедура ПосчитатьИтогиПоРазделу(НомерРаздела, ВсегоСтоимость, ВсегоПошлина, ВсегоНДС)  Экспорт

	ВсегоСтоимость = 0;
	ВсегоПошлина   = 0;
	ВсегоНДС       = 0;
	МассивСтрок = Товары.НайтиСтроки(Новый Структура("НомерРаздела", НомерРаздела));
	Для каждого ЭлементМассива Из МассивСтрок Цикл
		ВсегоСтоимость = ВсегоСтоимость + ЭлементМассива.ФактурнаяСтоимость;
		ВсегоПошлина   = ВсегоПошлина   + ЭлементМассива.СуммаПошлины;
		ВсегоНДС       = ВсегоНДС       + ЭлементМассива.СуммаНДС;
	КонецЦикла;

КонецПроцедуры // ПосчитатьИтогиПоРазделу()

// <Описание процедуры>
//
// Параметры
//  ДокументПоступления - ссылка на документ ПоступлениеТоваровУслуг, определяет документ поступления, по которому надо заполнить этот документ,
//  НомерРаздела        - число, номер раздела, который надо заполнить.
//
Процедура ЗаполнитьПоПоступлению(ДокументПоступления, НомерРаздела) Экспорт

	Если ТипЗнч(ДокументПоступления) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку")
	   И НЕ ДокументПоступления.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку.ОтПоставщика Тогда
			Возврат;
	КонецЕсли;

	ТаблицаЗначенийТовары = ДокументПоступления.Товары.Выгрузить();

	Для каждого СтрокаТаблицыЗначений Из ТаблицаЗначенийТовары Цикл

		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.НомерРаздела               = НомерРаздела;
		НоваяСтрока.ДокументПартии             = ДокументПоступления;
		НоваяСтрока.ЕдиницаИзмерения           = СтрокаТаблицыЗначений.ЕдиницаИзмерения;
		НоваяСтрока.ЕдиницаИзмеренияМест       = СтрокаТаблицыЗначений.ЕдиницаИзмеренияМест;
		НоваяСтрока.Количество                 = СтрокаТаблицыЗначений.Количество;
		НоваяСтрока.КоличествоМест             = СтрокаТаблицыЗначений.КоличествоМест;
		НоваяСтрока.Коэффициент                = СтрокаТаблицыЗначений.Коэффициент;
		НоваяСтрока.Номенклатура               = СтрокаТаблицыЗначений.Номенклатура;
		НоваяСтрока.СерияНоменклатуры          = СтрокаТаблицыЗначений.СерияНоменклатуры;
		НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаТаблицыЗначений.ХарактеристикаНоменклатуры;
		НоваяСтрока.Проект                     = СтрокаТаблицыЗначений.Проект;
		НоваяСтрока.ЗаказПокупателя            = СтрокаТаблицыЗначений.ЗаказПокупателя;
		НоваяСтрока.ФактурнаяСтоимость         = ПересчитатьИзВалютыВВалюту(СтрокаТаблицыЗначений.Сумма, ДокументПоступления.ВалютаДокумента,
		                                         ВалютаДокумента,
		                                         КурсДокумента(ДокументПоступления, мВалютаРегламентированногоУчета),
		                                         КурсДокумента,
		                                         КратностьДокумента(ДокументПоступления, мВалютаРегламентированногоУчета),
		                                         КратностьДокумента);

	КонецЦикла;

КонецПроцедуры // ЗаполнитьПоПоступлению()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиРазделы(ТаблицаПоРазделам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ТаможеннаяСтоимость, СтавкаПошлины, СуммаПошлины, СтавкаНДС, СуммаНДС");
	
	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Разделы", СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Суммы пошлины и НДС в каждом разделе должны совпадать с итогами по разделу в ТЧ Товары.
	Для каждого Раздел Из ТаблицаПоРазделам Цикл
	
		ВсегоСтоимость = 0;
		ВсегоПошлина   = 0;
		ВсегоНДС       = 0;
		НомерРаздела = ТаблицаПоРазделам.Индекс(Раздел) + 1;
		ПосчитатьИтогиПоРазделу(НомерРаздела, ВсегоСтоимость, ВсегоПошлина, ВсегоНДС);
		
		Если ВсегоПошлина <> Раздел.СуммаПошлины Тогда
			СообщитьОбОшибке("По разделу """ + СокрЛП(НомерРаздела) + """ сумма пошлины не совпадает с итогом по товарам раздела", Отказ, Заголовок);
		КонецЕсли;
	
		Если ВсегоНДС <> Раздел.СуммаНДС Тогда
			СообщитьОбОшибке("По разделу """ + СокрЛП(НомерРаздела) + """ сумма НДС не совпадает с итогом по товарам раздела", Отказ, Заголовок);
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество, ФактурнаяСтоимость");

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Проверка номера ГТД.
	ПредставлениеТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти["Товары"].Представление();
	СтрокаСообщения             = "Номер ГТД в серии не совпадает с номером ГТД документа!";
	Для каждого СтрокаТаблицы Из ТаблицаПоТоварам Цикл

		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
		                                """ табличной части """ + ПредставлениеТабличнойЧасти + """: ";

		Если НЕ ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура)
		   И СтрокаТаблицы.Номенклатура.ВестиУчетПоСериям
		   И СтрокаТаблицы.НомерГТД <> НомерГТД  Тогда

			СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения);

		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Дополнительная обработка строк табличной части "Товары".
//
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  Разделы                 - таблица разделов
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДополнительнаяОбработкаТабличнойЧастиТоварыДляЦелейНДС(ТаблицаПоТоварам, Разделы, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Добавляем недостающие поля.
	ТаблицаПоТоварам.Колонки.Добавить("ВидЦенности");
	ТаблицаПоТоварам.Колонки.Добавить("Ценность");
	ТаблицаПоТоварам.Колонки.Добавить("СуммаБезНДС");

	// Пересчет сумм в валюту регл учета.
	ОпределениеДополнительныхПараметровТаблицыПартийДляПодсистемыУчетаНДС(СтруктураШапкиДокумента, ТаблицаПоТоварам);

	Для каждого СтрокаТаблицы Из ТаблицаПоТоварам Цикл
		ТекРаздел = Разделы.Получить(СтрокаТаблицы.НомерРаздела - 1);

		Если Число(СтруктураШапкиДокумента.КурсВзаиморасчетов) = 0 или Число(СтруктураШапкиДокумента.КратностьВзаиморасчетов)=0 Тогда
			КоэффициентПересчета=1;
		Иначе
			КоэффициентПересчета = СтруктураШапкиДокумента.КурсВзаиморасчетов/СтруктураШапкиДокумента.КратностьВзаиморасчетов;
		КонецЕсли;

		СтрокаТаблицы.СуммаБезНДС = СтрокаТаблицы.Пошлина;
		Если ТекРаздел.ПошлинаВВалюте Тогда
			Если СтруктураШапкиДокумента.ВалютаВзаиморасчетов <> СтруктураШапкиДокумента.ВалютаРегламентированногоУчета Тогда

				// Необходим пересчет суммы пошлины в валюту регламентированного учета
				СтрокаТаблицы.СуммаБезНДС = СтрокаТаблицы.СуммаБезНДС * КоэффициентПересчета;
			КонецЕсли;
		КонецЕсли;

		Если ТекРаздел.НДСВВалюте Тогда
			Если СтруктураШапкиДокумента.ВалютаВзаиморасчетов <> СтруктураШапкиДокумента.ВалютаРегламентированногоУчета Тогда

				// Необходим пересчет суммы НДС в валюту регламентированного учета
				СтрокаТаблицы.НДС = СтрокаТаблицы.НДС * КоэффициентПересчета;
			КонецЕсли;
		КонецЕсли;

		СтрокаТаблицы.Сумма = СтрокаТаблицы.СуммаБезНДС + СтрокаТаблицы.НДС;

	КонецЦикла;

КонецПроцедуры // ДополнительнаяОбработкаТабличнойЧастиТоварыДляЦелейНДС()

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
	СтруктураОбязательныхПолей = Новый Структура("Организация, НомерГТД,
	                             |ВалютаДокумента, КурсДокумента, КратностьДокумента, Контрагент, ДоговорКонтрагента, ДоговорКонтрагентаРегл,
	                             |КурсВзаиморасчетов,КратностьВзаиморасчетов");

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, СтруктураШапкиДокумента.ДоговорОрганизация, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагентаРегл, СтруктураШапкиДокумента.ДоговорОрганизацияРегл, Отказ, Заголовок);

	// С таможней Оба договора должны иметь вид "Прочее" и ведение взаиморасчетов "по договору в целом".
	Если СтруктураШапкиДокумента.ВидДоговора<> Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда
		СообщитьОбОшибке("Договор с таможней должен иметь вид ""Прочее"".", Отказ, Заголовок);
	КонецЕсли;

	Если СтруктураШапкиДокумента.ВедениеВзаиморасчетов <> Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом Тогда
		СообщитьОбОшибке("Договор с таможней должен иметь вид ""Прочее"".", Отказ, Заголовок);
	КонецЕсли;

	Если СтруктураШапкиДокумента.ВидДоговораРегл <> Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда
		СообщитьОбОшибке("Договор с таможней должен иметь вид ""Прочее"".", Отказ, Заголовок);
	КонецЕсли;

	Если СтруктураШапкиДокумента.ВедениеВзаиморасчетовРегл <> Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом Тогда
		СообщитьОбОшибке("Договор с таможней должен иметь вид ""Прочее"".", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

Процедура ОбработатьТабличнуюЧастьРазделы(СтруктураШапкиДокумента)

	// Для проведения по взаиморасчетам посчитаем долг таможне по валютному и рублевому договору.
	СуммаВзаиморасчетовВал = ТаможенныйСборВал + ТаможенныйШтрафВал;
	СуммаВзаиморасчетов    = ТаможенныйСбор    + ТаможенныйШтраф;
	Для каждого СтрокаТабличнойЧасти Из Разделы Цикл
	
		Если СтрокаТабличнойЧасти.ПошлинаВВалюте Тогда
			СуммаВзаиморасчетовВал = СуммаВзаиморасчетовВал + СтрокаТабличнойЧасти.СуммаПошлины;
		Иначе
			СуммаВзаиморасчетов = СуммаВзаиморасчетов + СтрокаТабличнойЧасти.СуммаПошлины;
		КонецЕсли;
	
		Если СтрокаТабличнойЧасти.НДСВВалюте Тогда
			СуммаВзаиморасчетовВал = СуммаВзаиморасчетовВал + СтрокаТабличнойЧасти.СуммаНДС;
		Иначе
			СуммаВзаиморасчетов = СуммаВзаиморасчетов + СтрокаТабличнойЧасти.СуммаНДС;
		КонецЕсли;
	КонецЦикла;

	СтруктураШапкиДокумента.Вставить("СуммаВзаиморасчетовВал", СуммаВзаиморасчетовВал);
	СтруктураШапкиДокумента.Вставить("СуммаВзаиморасчетов",    СуммаВзаиморасчетов);

КонецПроцедуры //ОбработатьТабличнуюЧастьРазделы()

Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	ТаблицаТоваров.Колонки.Добавить("Сумма");
	ТаблицаТоваров.ЗагрузитьКолонку(ТаблицаТоваров.ВыгрузитьКолонку("ФактурнаяСтоимость"), "Сумма");
	
	ТаблицаТоваров.Колонки.Добавить("НДСВал");
	ТаблицаТоваров.ЗагрузитьКолонку(ТаблицаТоваров.ВыгрузитьКолонку("НДС"), "НДСВал");
	
	ТаблицаТоваров.Колонки.Добавить("Качество");
	ТаблицаТоваров.ЗаполнитьЗначения(Справочники.Качество.Новый, "Качество");

	ТаблицаТоваров.Колонки.Добавить("СтавкаНДС");
	
	Для Каждого Товар Из ТаблицаТоваров Цикл
		ТекРаздел = Разделы.Получить(Товар.НомерРаздела - 1);
		Товар.СтавкаНДС = ТекРаздел.СтавкаНДС;
	КонецЦикла;
	
	ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента);

	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

Процедура ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента)

	ТаблицаТоваров.Колонки.Добавить("Стоимость",     ПолучитьОписаниеТиповЧисла(15,3));
	ТаблицаТоваров.Колонки.Добавить("СтоимостьРегл", ПолучитьОписаниеТиповЧисла(15,3));

	// Недостающие поля.
	ТаблицаТоваров.Колонки.Добавить("СтатусПартии");
	
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		
		ПошлинаВВалюте = Разделы[СтрокаТаблицы.НомерРаздела - 1].ПошлинаВВалюте;
		НДСВВалюте     = Разделы[СтрокаТаблицы.НомерРаздела - 1].НДСВВалюте;
		
		Если ПошлинаВВалюте Тогда
		
			СтрокаТаблицы.Стоимость = ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Пошлина, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
			                                 СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
			                                 СтруктураШапкиДокумента.КурсВзаиморасчетов,
			                                 СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
			                                 СтруктураШапкиДокумента.КратностьВзаиморасчетов,
			                                 СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

			СтрокаТаблицы.СтоимостьРегл = ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Пошлина, СтруктураШапкиДокумента.ВалютаВзаиморасчетовРегл,
			                                 мВалютаРегламентированногоУчета, 
			                                 СтруктураШапкиДокумента.КурсВзаиморасчетов,      1,
			                                 СтруктураШапкиДокумента.КратностьВзаиморасчетов, 1);
		Иначе
			СтрокаТаблицы.Стоимость = ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Пошлина, мВалютаРегламентированногоУчета,
			                                 СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
			                                 1, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
			                                 1,СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

			СтрокаТаблицы.СтоимостьРегл = СтрокаТаблицы.Пошлина;
		КонецЕсли;

		Если НДСВВалюте Тогда

			СтрокаТаблицы.Стоимость = СтрокаТаблицы.Стоимость + ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.НДС, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
			                                 СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
			                                 СтруктураШапкиДокумента.КурсВзаиморасчетов,
			                                 СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
			                                 СтруктураШапкиДокумента.КратностьВзаиморасчетов,
			                                 СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

			СтрокаТаблицы.СтоимостьРегл = СтрокаТаблицы.СтоимостьРегл + ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.НДС, СтруктураШапкиДокумента.ВалютаРегламентированногоУчета,
			                                 мВалютаРегламентированногоУчета, 
			                                 СтруктураШапкиДокумента.КурсВзаиморасчетов,      1,
			                                 СтруктураШапкиДокумента.КратностьВзаиморасчетов, 1);
		Иначе
			СтрокаТаблицы.Стоимость = СтрокаТаблицы.Стоимость + ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.НДС, мВалютаРегламентированногоУчета,
			                                 СтруктураШапкиДокумента.ВалютаУправленческогоУчета, 
			                                 1, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета, 
			                                 1, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

			СтрокаТаблицы.СтоимостьРегл =  СтрокаТаблицы.СтоимостьРегл + СтрокаТаблицы.НДС;
		КонецЕсли;

		Если СтрокаТаблицы.ОбособленныйУчетТоваровПоЗаказамПокупателей = Ложь Тогда
			СтрокаТаблицы.Заказ = Неопределено;
		КонецЕсли;

		Если СтрокаТаблицы.ВидДоговораПартии = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
			СтрокаТаблицы.СтатусПартии = Перечисления.СтатусыПартийТоваров.НаКомиссию; 
		Иначе
			СтрокаТаблицы.СтатусПартии = Перечисления.СтатусыПартийТоваров.Купленный; 
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПодготовитьТаблицуТоваровУпр()	

Процедура ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке)

	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "ВалютаУправленческогоУчета"     , "ВалютаУправленческогоУчета");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы", "КурсВалютыУправленческогоУчета" , "КурсВалютыУправленческогоУчета");

КонецПроцедуры // ДополнитьДеревоПолейЗапросаПоШапкеУпр()	

// Формируем движения по регистрам.
//
// Параметры: 
//  СтруктураШапкиДокумента   - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  Отказ                     - флаг отказа в проведении
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ,Заголовок)

	ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ);
	ДвиженияПоРегистрамПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ);

КонецПроцедуры

Процедура ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ)

	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда

		// ТОВАРЫ ПО РЕГИСТРУ ВзаиморасчетыСКонтрагентами

		НаборДвижений = Движения.ВзаиморасчетыСКонтрагентами;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		// Заполним таблицу движений.
		СтрокаДвижений = ТаблицаДвижений.Добавить();

		СтрокаДвижений.ДоговорКонтрагента  = ДоговорКонтрагента;
		СтрокаДвижений.Сделка              = Неопределено;
		СтрокаДвижений.СуммаВзаиморасчетов = СтруктураШапкиДокумента.СуммаВзаиморасчетовВал;
		СтрокаДвижений.СуммаУпр   = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаВзаиморасчетовВал, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
												СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
												СтруктураШапкиДокумента.КурсВзаиморасчетов, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
												СтруктураШапкиДокумента.КратностьВзаиморасчетов, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.ДоговорКонтрагента = ДоговорКонтрагентаРегл;
		СтрокаДвижений.Сделка                = Неопределено;
		СтрокаДвижений.СуммаВзаиморасчетов   = СтруктураШапкиДокумента.СуммаВзаиморасчетов;
		СтрокаДвижений.СуммаУпр   = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаВзаиморасчетов, СтруктураШапкиДокумента.ВалютаВзаиморасчетовРегл,
												СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
												1, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
												1, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

		Если Не Отказ Тогда
			Движения.ВзаиморасчетыСКонтрагентами.ВыполнитьРасход();
		КонецЕсли;


		// ПО РЕГИСТРУ РасчетыСКонтрагентами
		НаборДвижений = Движения.РасчетыСКонтрагентами;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		// Заполним таблицу движений.
		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.РасчетыВозврат        = Перечисления.РасчетыВозврат.Расчеты;
		СтрокаДвижений.ДоговорКонтрагента = ДоговорКонтрагента;
		СтрокаДвижений.Сделка                = Неопределено;
		СтрокаДвижений.СуммаВзаиморасчетов   = СтруктураШапкиДокумента.СуммаВзаиморасчетовВал;
		СтрокаДвижений.СуммаУпр   = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаВзаиморасчетовВал, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
		                            СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
		                            СтруктураШапкиДокумента.КурсВзаиморасчетов, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
		                            СтруктураШапкиДокумента.КратностьВзаиморасчетов, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.РасчетыВозврат        = Перечисления.РасчетыВозврат.Расчеты;
		СтрокаДвижений.ДоговорКонтрагента = ДоговорКонтрагентаРегл;
		СтрокаДвижений.Сделка                = Неопределено;
		СтрокаДвижений.СуммаВзаиморасчетов   = СтруктураШапкиДокумента.СуммаВзаиморасчетов;
		СтрокаДвижений.СуммаУпр   = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаВзаиморасчетов, СтруктураШапкиДокумента.ВалютаВзаиморасчетовРегл,
		                            СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
		                            1, СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
		                            1, СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

		Если Не Отказ Тогда
			Движения.РасчетыСКонтрагентами.ВыполнитьРасход();
		КонецЕсли;


		// ПО РЕГИСТРУ Партии товаров на складах
		НаборДвижений = Движения.ПартииТоваровНаСкладах;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		ТабПартий = ТаблицаПоТоварам.Скопировать();
		
		// Из таблицы по товарам выделим строки, для которых заполнен документ оприходования
		Инд=0;
		Пока Инд<ТабПартий.Количество() Цикл
			
			Если ЗначениеНеЗаполнено(ТабПартий[Инд].ДокументОприходования) Тогда
				ТабПартий.Удалить(Инд);
			Иначе
				Инд=Инд+1;
			КонецЕсли;
			
		КонецЦикла;

		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ТабПартий, ТаблицаДвижений);

		ТаблицаДвижений.ЗаполнитьЗначения(0, "Количество");
		ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииТоваров.ПоступлениеДопРасходов, "КодОперации");

		// Если суммовой 
		Если НЕ СтруктураШапкиДокумента.ВестиПартионныйУчетПоСкладам Тогда
			ТаблицаДвижений.ЗаполнитьЗначения(Неопределено, "Склад");
		Иначе
			
			// Добавочные строки
			ДопСтроки = НаборДвижений.Выгрузить();
			ДопСтроки.Очистить();
			
			Для Каждого Строка Из ТаблицаДвижений Цикл
				
				ЗапросСкладыВТЧ = Новый Запрос(
				"ВЫБРАТЬ
				|	ПоступлениеТовары.Количество,
				|	ПоступлениеТовары.Склад
				|ИЗ
				|	РегистрНакопления.ПартииТоваровНаСкладах КАК ПоступлениеТовары
				|
				|ГДЕ
				|	ПоступлениеТовары.Регистратор = &Ссылка И
				|	ПоступлениеТовары.Номенклатура = &Номенклатура И
				|	ПоступлениеТовары.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры И
				|	ПоступлениеТовары.СерияНоменклатуры = &СерияНоменклатуры И
				|	ПоступлениеТовары.Количество > 0 // Необходимо исключить сторнирующие записи по ордерам");
				
				ЗапросСкладыВТЧ.УстановитьПараметр("Ссылка", Строка.ДокументОприходования);
				ЗапросСкладыВТЧ.УстановитьПараметр("Номенклатура", Строка.Номенклатура);
				ЗапросСкладыВТЧ.УстановитьПараметр("ХарактеристикаНоменклатуры", Строка.ХарактеристикаНоменклатуры);
				ЗапросСкладыВТЧ.УстановитьПараметр("СерияНоменклатуры", Строка.СерияНоменклатуры);
				
				ТабВыборка = ЗапросСкладыВТЧ.Выполнить().Выгрузить();
				
				ИтогоКоличество = ТабВыборка.Итог("Количество");
				
				РаспределяемаяСумма = Строка.Стоимость;
				
				Для Каждого Выборка Из ТабВыборка Цикл
					
					Если ИтогоКоличество<=0 Тогда
						Прервать;
					КонецЕсли;
					
					Если Выборка.Количество=0 Тогда
						Продолжить;
					КонецЕсли;
					
					ДопСтрока = ДопСтроки.Добавить();
					Для Каждого Кол Из ТаблицаДвижений.Колонки Цикл
						ИндКол = ТаблицаДвижений.Колонки.Индекс(Кол);
						ДопСтрока[ИндКол] = Строка[ИндКол];
					КонецЦикла;
					
					ДопСтрока.Склад = Выборка.Склад;
					
					Если Выборка.Количество<ИтогоКоличество Тогда
						КоэффРаспред = Выборка.Количество/ИтогоКоличество;
					Иначе
						КоэффРаспред = 1;
					КонецЕсли;
					
					ДопСтрока.Стоимость = РаспределяемаяСумма * КоэффРаспред;
					
					РаспределяемаяСумма = РаспределяемаяСумма - ДопСтрока.Стоимость;
					ИтогоКоличество = ИтогоКоличество - Выборка.Количество;
					
					// Исходная строка будет с 0 суммой
					Строка.Стоимость = 0;
					
				КонецЦикла;
				
			КонецЦикла;
			
			// Теперь доп строки добавим в таблицу движений
			Для Каждого ДопСтрока Из ДопСтроки Цикл
				НоваяСтрока = ТаблицаДвижений.Добавить();
				Для Каждого Кол Из ТаблицаДвижений.Колонки Цикл
					ИндКол = ТаблицаДвижений.Колонки.Индекс(Кол);
					НоваяСтрока[ИндКол] = ДопСтрока[ИндКол];
				КонецЦикла;
			КонецЦикла;
			
			// После обработки удалим строки с нулевыми суммами
			Инд=0;
			Пока Инд<ТаблицаДвижений.Количество() Цикл
				Если ТаблицаДвижений[Инд].Стоимость=0 Тогда
					ТаблицаДвижений.Удалить(Инд);
				Иначе
					Инд = Инд+1;
				КонецЕсли;
					
			КонецЦикла;
			
		КонецЕсли;

		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Если Не Отказ Тогда
			Движения.ПартииТоваровНаСкладах.ВыполнитьПриход();
		КонецЕсли;
		
		// ПО РЕГИСТРУ доп.расходов для последующего распределения
		
		НаборДвижений = Движения.ДопРасходыНаПриобретениеТоваров;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();
		
		ТабЗатрат = ТаблицаПоТоварам.Скопировать();
		
		// Из таблицы по товарам выделим строки, для которых НЕ заполнен документ оприходования
		Инд=0;
		Пока Инд<ТабЗатрат.Количество() Цикл
			
			Если НЕ ЗначениеНеЗаполнено(ТабЗатрат[Инд].ДокументОприходования) Тогда
				ТабЗатрат.Удалить(Инд);
			Иначе
				Инд=Инд+1;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТабЗатрат.Колонки.Найти("Сумма")<>Неопределено Тогда
			ТабЗатрат.Колонки.Удалить("Сумма");
		КонецЕсли;
		ТабЗатрат.Колонки.Стоимость.Имя = "Сумма";
		
		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ТабЗатрат, ТаблицаДвижений);
		
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Если Не Отказ Тогда
			Движения.ДопРасходыНаПриобретениеТоваров.ВыполнитьПриход();
		КонецЕсли;
		
		// ПО РЕГИСТРУ Закупки
		НаборДвижений = Движения.Закупки;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

		ТаблицаДвижений.ЗаполнитьЗначения(0,                  "Количество");
		ТаблицаДвижений.ЗаполнитьЗначения(Подразделение,      "Подразделение");
		ТаблицаДвижений.ЗаполнитьЗначения(ДоговорКонтрагента, "ДоговорКонтрагента");
		ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,             "ДокументЗакупки");

		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Если Не Отказ Тогда
			Движения.Закупки.ВыполнитьДвижения();
		КонецЕсли;

	КонецЕсли; // ОтражатьВУправленческомУчете

КонецПроцедуры // ДвиженияПоРегистрамУпр()

// Вызывается из тела процедуры "ДвиженияПоРегистрам" в процедуре формируются движения, отражающие
// поступление доп. расходов в подсистеме учета НДС
Процедура ДвиженияПоРегистрамПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ)

	ТаблицаДокумента = ТаблицаПоТоварам.Скопировать();
	ТаблицаДокумента.Свернуть("ВидЦенности, Ценность, ДокументОприходования, СтавкаНДС", "СуммаБезНДС, НДС");
	
	ТаблицаДвиженийПокупки = Движения.НДСПокупки.Выгрузить();
	ТаблицаДвиженийПокупки.Очистить();

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра НДСПартииТоваров.
	ТаблицаДвиженийПартии = Движения.НДСПартииТоваров.Выгрузить();
	ТаблицаДвиженийПартии.Очистить();
	
	Для Каждого Товар из ТаблицаПоТоварам Цикл
		
		ТекРаздел = Разделы.Найти(Товар.НомерРаздела, "НомерСтроки");
		
		Если (Товар.СуммаБезНДС + Товар.НДС) <>0 Тогда
			СтрокаДвижения = ТаблицаДвиженийПокупки.Добавить();
			СтрокаДвижения.Организация = СтруктураШапкиДокумента.Организация;
			СтрокаДвижения.ВидЦенности = Перечисления.ВидыЦенностей.ТаможенныеПлатежи;
			СтрокаДвижения.Поставщик   = СтруктураШапкиДокумента.Контрагент;
			СтрокаДвижения.СчетФактура = СтруктураШапкиДокумента.Ссылка;
			СтрокаДвижения.Событие     = Перечисления.СобытияПоНДСПокупки.УплаченНДСНаТаможне;
			СтрокаДвижения.СтавкаНДС   = Товар.СтавкаНДС;
			СтрокаДвижения.СуммаБезНДС = Товар.СуммаБезНДС;
			СтрокаДвижения.НДС         = Товар.НДС;
			
			СтрокаДвижения.ДокументОплаты = СтруктураШапкиДокумента.Ссылка;
			
		КонецЕсли;

	КонецЦикла;
	
	СформироватьДвиженияПоступленияПоРегиструНДСПартииТоваров(СтруктураШапкиДокумента, ТаблицаПоТоварам, "ТаблицаПоТоварам", ТаблицаДвиженийПартии);

	Если ТаблицаДвиженийПартии.Количество() > 0 Тогда
		Движения.НДСПартииТоваров.мПериод            = Дата;
		Движения.НДСПартииТоваров.мТаблицаДвижений   = ТаблицаДвиженийПартии;
		Движения.НДСПартииТоваров.ВыполнитьПриход();
		Движения.НДСПартииТоваров.Записать();
	КонецЕсли;
	
	Если ТаблицаДвиженийПокупки.Количество() > 0 Тогда
		Движения.НДСПокупки.мПериод = Дата;
		Движения.НДСПокупки.мТаблицаДвижений = ТаблицаДвиженийПокупки;
		Движения.НДСПокупки.ДобавитьДвижение();
		Движения.НДСПокупки.Записать();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамПодсистемыНДС()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	ПоступлениеТоваров    = (ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг"));
	ПоступлениеТоваровНТТ = (ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку"));

	Если ПоступлениеТоваров
	 ИЛИ ПоступлениеТоваровНТТ Тогда

		Если ПоступлениеТоваровНТТ
		   И Не Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслугВНеавтоматизированнуюТорговуюТочку.ОтПоставщика Тогда
				Возврат;
		КонецЕсли;

		ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		// Контрагент у нас другой
		Контрагент         = Неопределено;
		ДоговорКонтрагента = Неопределено;
		Сделка             = Неопределено;

		// Заполним Табличную часть
		Раздел = ДобавитьРаздел();
		ЗаполнитьПоПоступлению(Основание, 1);

		ВсегоСтоимость = 0;
		ВсегоПошлина   = 0;
		ВсегоНДС       = 0;
	
		ПосчитатьИтогиПоРазделу(1, ВсегоСтоимость, ВсегоПошлина, ВсегоНДС);

		Раздел.ТаможеннаяСтоимость = ВсегоСтоимость;

	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов",     "ВалютаВзаиморасчетов"          , "ВалютаВзаиморасчетов");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов",     "ВедениеВзаиморасчетов"         , "ВедениеВзаиморасчетов");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов",     "ВидДоговора"                   , "ВидДоговора");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентовРегл", "ВидДоговора"                   , "ВидДоговораРегл");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентовРегл", "ВалютаВзаиморасчетов"          , "ВалютаВзаиморасчетовРегл");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентовРегл", "ВедениеВзаиморасчетов"         , "ВедениеВзаиморасчетовРегл");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентовРегл", "Организация"                   , "ДоговорОрганизацияРегл");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорыКонтрагентов",     "Организация"                   , "ДоговорОрганизация");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика"       ,   "ВестиПартионныйУчетПоСкладам"  , "ВестиПартионныйУчетПоСкладам");

	ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке);

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Получим необходимые данные для проверки и проведения по табличной части "Товары".
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НомерРаздела"                , "НомерРаздела");
	СтруктураПолей.Вставить("Номенклатура"                , "Номенклатура");
	СтруктураПолей.Вставить("Количество"                  , "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("ФактурнаяСтоимость"          , "ФактурнаяСтоимость");
	СтруктураПолей.Вставить("НДС"                         , "СуммаНДС");
	СтруктураПолей.Вставить("Пошлина"                     , "СуммаПошлины");
	СтруктураПолей.Вставить("Проект"                      , "Проект");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры"  , "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"           , "СерияНоменклатуры");
	СтруктураПолей.Вставить("НомерГТД"                    , "СерияНоменклатуры.НомерГТД");

	СтруктураПолей.Вставить("Услуга"                      , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                       , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Заказ"                       , "ЗаказПокупателя");
	СтруктураПолей.Вставить("ДокументОприходования"       , "ДокументПартии");
	СтруктураПолей.Вставить("ДокументПартииВидОперации"   , "ДокументПартии.ВидОперации");
	СтруктураПолей.Вставить("ДокументПартииВидПоступления", "ДокументПартии.ВидПоступления");
	СтруктураПолей.Вставить("ВидДоговораПартии"           , "ДокументПартии.ДоговорКонтрагента.ВидДоговора");
	СтруктураПолей.Вставить("ОбособленныйУчетТоваровПоЗаказамПокупателей", 
							"ЗаказПокупателя.ДоговорКонтрагента.ОбособленныйУчетТоваровПоЗаказамПокупателей");

	РезультатЗапросаПоТоварам = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);

	ОбработатьТабличнуюЧастьРазделы(СтруктураШапкиДокумента);

	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);

	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиРазделы(Разделы, СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);

	ДополнительнаяОбработкаТабличнойЧастиТоварыДляЦелейНДС(ТаблицаПоТоварам, Разделы, СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ,Заголовок);
	КонецЕсли;

КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	// Проверка заполнения единицы измерения мест и количества мест
	ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры // ПередЗаписью

Процедура ПриЗаписи(Отказ)

	СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный");

КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
