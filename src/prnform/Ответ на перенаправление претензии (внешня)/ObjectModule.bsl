﻿
Функция Печать() Экспорт
	
	Дата       = СсылкаНаОбъект.Дата;
	Контрагент = СсылкаНаОбъект.Контрагент;
	ВидТовара  = СсылкаНаОбъект.ВидТовара;
	Товары     = СсылкаНаОбъект.Расшифровка;
	
	ТабДок = Новый ТабличныйДокумент;
	Макет  = ЭтотОбъект.ПолучитьМакет("Макет1");
	
	// Шапка
	Обл = Макет.ПолучитьОбласть("Шапка");
	СведенияОКонтрагенте  = СведенияОЮрФизЛице(Контрагент, Дата);
	Обл.Параметры.Контрагент        = ОписаниеОрганизации(СведенияОКонтрагенте, "ПолноеНаименование,");
	Обл.Параметры.КонтрагентЮрАдрес = ОписаниеОрганизации(СведенияОКонтрагенте, "ЮридическийАдрес,");
	ИнженерПоКачеству = ПолучитьИнженераПоКачеству(ВидТовара);
	Обл.Параметры.ИнженерПоКачеству = ИнженерПоКачеству;
	ТабДок.Вывести(Обл);
	
	// ТелоШапка
	Обл = Макет.ПолучитьОбласть("ТелоШапка");
	ТабДок.Вывести(Обл);
	
	// ТелоСтр
	Обл = Макет.ПолучитьОбласть("ТелоСтр");
	ВывестиТоварыПострочно(ТабДок, Обл, Товары);
	
	// ТелоПдвл
	Обл = Макет.ПолучитьОбласть("ТелоПдвл");
	ТабДок.Вывести(Обл);
	
	// Подвал
	Обл = Макет.ПолучитьОбласть("Подвал");
	Обл.Параметры.ДатаОтвета        = Формат(Дата, "ДФ=dd.MM.yyyy");
	Обл.Параметры.ИнженерПоКачеству = ИнженерПоКачеству; 
	ТабДок.Вывести(Обл);
	
	Возврат ТабДок;
	
КонецФункции // Печать()

Функция ПолучитьИнженераПоКачеству(ВидТовара)
	
	Если ВидТовара = Перечисления.ВидыТоваров.АКБ ИЛИ ВидТовара = Перечисления.ВидыТоваров.Шины Тогда
		ИнженерПоКачеству = "Куртов К.Д.";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.Диски Тогда
		ТекПользовательКод = СокрЛП(глТекущийПользователь.Код);
		Если ТекПользовательКод = "Левченко Ф.С." ИЛИ ТекПользовательКод = "Капченко И." Тогда
			ИнженерПоКачеству = глТекущийПользователь;
		Иначе
			ИнженерПоКачеству = "______________________________";
		КонецЕсли;
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.Аксессуары Тогда
		ИнженерПоКачеству = "Уманский В.А.";
	Иначе
		ИнженерПоКачеству = "______________________________";
	КонецЕсли;
	
	Возврат ИнженерПоКачеству;
	
КонецФункции // ПолучитьИнженераПоКачеству()

Функция ПолучитьВидТовараРодитПадеж(ВидТовара)
	
	Если ВидТовара = Перечисления.ВидыТоваров.АвтоЗапчасти Тогда
		ВидТовРодитПадеж = "автозапчастей";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.АКБ Тогда
		ВидТовРодитПадеж = "АКБ";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.Аксессуары Тогда
		ВидТовРодитПадеж = "аксессуаров";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.Диски Тогда
		ВидТовРодитПадеж = "дисков";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.КрышкиНаклейки Тогда
		ВидТовРодитПадеж = "крышек/наклеек";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.РекламнаяПродукция Тогда
		ВидТовРодитПадеж = "рекламной продукции";
	ИначеЕсли ВидТовара = Перечисления.ВидыТоваров.Шины Тогда
		ВидТовРодитПадеж = "шин";
	Иначе
		ВидТовРодитПадеж = "";
	КонецЕсли;
	
	Возврат ВидТовРодитПадеж;
	
КонецФункции  // ПолучитьВидТовараРодитПадеж()

Функция ПолучитьПереченьТоваров(Товары)

    НаименованиеТоваров = "";
	
	Для Каждого ТекСтр Из Товары Цикл
		НаименованиеТоваров = НаименованиеТоваров + ТекСтр.Номенклатура.Наименование + " - " + ТекСтр.Количество + " шт." + ", ";
	КонецЦикла;
	
	НаименованиеТоваров = Лев(НаименованиеТоваров, СтрДлина(НаименованиеТоваров) - 2);
	
	Возврат НаименованиеТоваров;
	
КонецФункции // ПолучитьПереченьТоваров()

Функция ПолучитьПоставщикаТоваров(Товары)
	
	Если Товары.Количество() > 0 Тогда
		Поставщик = Товары[0].Номенклатура.ОсновнойПоставщик.Наименование;
	Иначе
		Поставщик = "";
	КонецЕсли;
	
	Возврат Поставщик;
	
КонецФункции  // ПолучитьПоставщикаТоваров()

Функция ПолучитьВидТовараПоНоменклатуреМнЧисло(Номенклатура)
	
	ВидТовараНоменклатура = Номенклатура.ВидТовара;
	
	Если ВидТовараНоменклатура = Перечисления.ВидыТоваров.АвтоЗапчасти Тогда
		ВидТовМнЧисло = "Автозапчасти";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.АКБ Тогда
		ВидТовМнЧисло = "АКБ";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.Аксессуары Тогда
		ВидТовМнЧисло = "Аксессуары";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.Диски Тогда
		ВидТовМнЧисло = "Диски";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.КрышкиНаклейки Тогда
		ВидТовМнЧисло = "Крышки/наклейки";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.РекламнаяПродукция Тогда
		ВидТовМнЧисло = "Рекламная продукция";
	ИначеЕсли ВидТовараНоменклатура = Перечисления.ВидыТоваров.Шины Тогда
		ВидТовМнЧисло = "Шины";
	Иначе
		ВидТовМнЧисло = "";
	КонецЕсли;
	
	Возврат ВидТовМнЧисло;
	
КонецФункции // ПолучитьВидТовараПоНоменклатуреМнЧисло()

Процедура ВывестиСтрокуТоваров(ТабДок, Обл, ТекСтр, НомерСтроки)
	
	Обл.Параметры.НомерСтроки  = НомерСтроки;
	Обл.Параметры.ВидТовараМнЧ = ПолучитьВидТовараПоНоменклатуреМнЧисло(ТекСтр.Номенклатура) + " ";
	Обл.Параметры.Номенклатура = ТекСтр.Номенклатура.Наименование;
	Обл.Параметры.Количество   = ТекСтр.Количество;
	Обл.Параметры.Поставщик    = ТекСтр.Номенклатура.ОсновнойПоставщик.Наименование;
	ТабДок.Вывести(Обл);
	
КонецПроцедуры // ВывестиСтрокуТоваров()

Процедура ВывестиТоварыПострочно(ТабДок, Обл, Товары)
	
	ТоварыКолич = Товары.Количество();
	Если ТоварыКолич = 0 Тогда
		Возврат;
	ИначеЕсли ТоварыКолич = 1 Тогда
		ТекСтр = Товары[0];
		НомерСтроки = "";
		ВывестиСтрокуТоваров(ТабДок, Обл, ТекСтр, НомерСтроки);
	Иначе
		Для Каждого ТекСтр Из Товары Цикл
			НомерСтроки = "" + ТекСтр.Номерстроки + ") ";
			ВывестиСтрокуТоваров(ТабДок, Обл, ТекСтр, НомерСтроки);
		КонецЦикла;
	КонецЕсли;	
	
КонецПроцедуры // ВывестиТоварыПострочно()