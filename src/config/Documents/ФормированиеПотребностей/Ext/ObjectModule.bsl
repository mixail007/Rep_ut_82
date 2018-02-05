﻿Процедура ПроверкаРеквизитов(Отказ, Заголовок)
	
	РеквизитыТабПланыПродаж       = "Сценарий, ДатаНач, ДатаКон";
	РеквизитыТабПланыЗакупок      = "Сценарий, ДатаНач, ДатаКон";
	РеквизитыТабЗаказыПокупателей = "ДатаПотребности";
	РеквизитыТабПотребности       = "ДатаПотребности, Номенклатура, Количество";
	
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ПланыПродаж", Новый Структура(РеквизитыТабПланыПродаж), Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ПланыЗакупок", Новый Структура(РеквизитыТабПланыЗакупок), Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ЗаказыПокупателей", Новый Структура(РеквизитыТабЗаказыПокупателей), Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Потребности", Новый Структура(РеквизитыТабПотребности), Отказ, Заголовок);

КонецПроцедуры // ПроверкаРеквизитов()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Функция ВыполнитьВыборкуДанных() Экспорт
	
	Перем НовыеПотребности, ТекущиеПотребности;
	
	//Новые потребности
	ЗапросНовыеПотребности = Новый Запрос;
	ЗапросНовыеПотребности.УстановитьПараметр("ДатаДокумента",  Дата);
	ЗапросНовыеПотребности.УстановитьПараметр("ПустойЗаказ",    Документы.ЗаказПокупателя.ПустаяСсылка());
	ЗапросНовыеПотребности.УстановитьПараметр("ПустойПроект",   Справочники.Проекты.ПустаяСсылка());
	ЗапросНовыеПотребности.УстановитьПараметр("ПустаяДата",     Дата('00010101000000'));
	ЗапросНовыеПотребности.УстановитьПараметр("Товар",          Перечисления.ТоварТара.Товар);
	ЗапросНовыеПотребности.УстановитьПараметр("Тара",           Перечисления.ТоварТара.Тара);
	ЗапросНовыеПотребности.УстановитьПараметр("ВозвратнаяТара", Перечисления.СтатусыПартийТоваров.ВозвратнаяТара);
	
	//Планы продаж
	Индекс = 0;
	
	Для каждого Строка из ПланыПродаж Цикл
		
		Если ЗначениеНеЗаполнено(Строка.Сценарий.Периодичность) Тогда
			
			СообщитьОбОшибке("Для сценария """ + СокрЛП(Строка(Строка.Сценарий.Наименование)) + """ не указана периодичность.");
			Продолжить;
			
		КонецЕсли;
		
		ДатаНач = Строка.ДатаНач;
		ДатаКон = Строка.ДатаКон;
		
		ВыровнятьПериод(ДатаНач, ДатаКон, Строка.Сценарий.Периодичность);
		
		ЗапросНовыеПотребности.УстановитьПараметр("ПланыПродажДатаНач" + Индекс, ДатаНач);
		ЗапросНовыеПотребности.УстановитьПараметр("ПланыПродажДатаКон" + Индекс, ДатаКон);
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ПланыПродажОбороты.Номенклатура КАК Номенклатура,
		|	ПланыПродажОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	&Товар КАК ТоварТара,
		|	Ложь КАК Тара,
		|	НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ПланыПродажОбороты.Период, ДЕНЬ, -1), ДЕНЬ) КАК ДатаПотребности,
		|	&ПустойЗаказ КАК Заказ,
		|	ПланыПродажОбороты.Проект КАК Проект,
		|	ПланыПродажОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.ПланыПродаж.Обороты(&ПланыПродажДатаНач" + Индекс + ", &ПланыПродажДатаКон" + Индекс + ", " + Строка(Строка.Сценарий.Периодичность) + ", ";
		
		ЗапросНовыеПотребности.УстановитьПараметр("Сценарий" + Индекс, Строка.Сценарий);
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "Сценарий = &Сценарий" + Индекс + " И ВЫБОР КОГДА Номенклатура ССЫЛКА Справочник.Номенклатура ТОГДА Номенклатура.Услуга = Ложь ИНАЧЕ Истина КОНЕЦ";
		
		Если НЕ ЗначениеНеЗаполнено(Строка.Проект) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("Проект" + Индекс, Строка.Проект);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И Проект = &Проект" + Индекс;
			
		КонецЕсли;
		
		Если НЕ ЗначениеНеЗаполнено(Строка.Подразделение) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("Подразделение" + Индекс, Строка.Подразделение);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И Подразделение = &Подразделение" + Индекс;
			
		КонецЕсли;
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст +
		") КАК ПланыПродажОбороты
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
			
	//Заказы покупателей
	Индекс = 0;
	
	Для каждого Строка из ЗаказыПокупателей Цикл
		
		ЗапросНовыеПотребности.УстановитьПараметр("ЗаказДатаПотребности" + Индекс, НачалоДня(Строка.ДатаПотребности));
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
		|	ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ВЫБОР КОГДА	СтатусПартии = &ВозвратнаяТара ТОГДА
		|		&Тара
		|	ИНАЧЕ
		|		&Товар
		|	КОНЕЦ КАК ТоварТара,
		|	ВЫБОР КОГДА	СтатусПартии = &ВозвратнаяТара ТОГДА
		|		Истина
		|	ИНАЧЕ
		|		Ложь
		|	КОНЕЦ КАК Тара,
		|	&ЗаказДатаПотребности" + Индекс + " КАК ДатаПотребности,
		|	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК Заказ,
		|	&ПустойПроект КАК Проект,
		|	ЗаказыПокупателейОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.ЗаказыПокупателей.Остатки(КОНЕЦПЕРИОДА(&ДатаДокумента, ДЕНЬ), Номенклатура.Услуга = Ложь";
		
		Если НЕ ЗначениеНеЗаполнено(Строка.Заказ) Тогда
			
			ЗапросНовыеПотребности.УстановитьПараметр("ЗаказПокупателя" + Индекс, Строка.Заказ);
			ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст + " И ЗаказПокупателя = &ЗаказПокупателя" + Индекс;
			
		КонецЕсли;
		
		ЗапросНовыеПотребности.Текст = ЗапросНовыеПотребности.Текст +
		") КАК ЗаказыПокупателейОстатки
		|
		|ГДЕ ЗаказыПокупателейОстатки.КоличествоОстаток > 0
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если ЗапросНовыеПотребности.Текст <> "" Тогда
		
		ЗапросНовыеПотребности.Текст = Сред(ЗапросНовыеПотребности.Текст, 12);
		Результат = ЗапросНовыеПотребности.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
		РаспределитьПоНоменклатуре(НовыеПотребности, Результат);
		
	КонецЕсли;
	
	//Текущие потребности
	ЗапросТекущиеПотребности = Новый Запрос;
	ЗапросТекущиеПотребности.УстановитьПараметр("ДатаДокумента", Дата);
	ЗапросТекущиеПотребности.УстановитьПараметр("ПустойЗаказ",   Документы.ЗаказПокупателя.ПустаяСсылка());
	ЗапросТекущиеПотребности.УстановитьПараметр("Товар",         Перечисления.ТоварТара.Товар);
	
	//Планы закупок
	Индекс = 0;
	
	Для каждого Строка из ПланыЗакупок Цикл
		
		Если ЗначениеНеЗаполнено(Строка.Сценарий.Периодичность) Тогда
			
			СообщитьОбОшибке("Для сценария """ + СокрЛП(Строка(Строка.Сценарий.Наименование)) + """ не указана периодичность.");
			Продолжить;
			
		КонецЕсли;
		
		ДатаНач = Строка.ДатаНач;
		ДатаКон = Строка.ДатаКон;
		
		ВыровнятьПериод(ДатаНач, ДатаКон, Строка.Сценарий.Периодичность);
		
		ЗапросТекущиеПотребности.УстановитьПараметр("ПланыЗакупокДатаНач" + Индекс, ДатаНач);
		ЗапросТекущиеПотребности.УстановитьПараметр("ПланыЗакупокДатаКон" + Индекс, ДатаКон);
		
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	&ДатаДокумента КАК Период,
		|	ПланыЗакупокОбороты.Номенклатура КАК Номенклатура,
		|	ПланыЗакупокОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ПланыЗакупокОбороты.Сценарий КАК Сценарий,
		|	&Товар КАК ТоварТара,
		|	Ложь КАК Тара,
		|	НАЧАЛОПЕРИОДА(ПланыЗакупокОбороты.Период, ДЕНЬ) КАК ДатаПотребности,
		|	&ПустойЗаказ КАК Заказ,
		|	ПланыЗакупокОбороты.Проект КАК Проект,
		|	ПланыЗакупокОбороты.КоличествоОборот КАК Количество
		|ИЗ
		|	РегистрНакопления.ПланыЗакупок.Обороты(&ПланыЗакупокДатаНач" + Индекс + ", &ПланыЗакупокДатаКон" + Индекс + ", " + Строка(Строка.Сценарий.Периодичность) + ", ";
		
		ЗапросТекущиеПотребности.УстановитьПараметр("Сценарий" + Индекс, Строка.Сценарий);
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + "Сценарий = &Сценарий" + Индекс + " И ВЫБОР КОГДА Номенклатура ССЫЛКА Справочник.Номенклатура ТОГДА Номенклатура.Услуга = Ложь ИНАЧЕ Истина КОНЕЦ";
		
		Если НЕ ЗначениеНеЗаполнено(Строка.Проект) Тогда
			
			ЗапросТекущиеПотребности.УстановитьПараметр("Проект" + Индекс, Строка.Проект);
			ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + " И Проект = &Проект" + Индекс;
			
		КонецЕсли;
		
		Если НЕ ЗначениеНеЗаполнено(Строка.Подразделение) Тогда
			
			ЗапросТекущиеПотребности.УстановитьПараметр("Подразделение" + Индекс, Строка.Подразделение);
			ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст + " И Подразделение = &Подразделение" + Индекс;
			
		КонецЕсли;
		
		ЗапросТекущиеПотребности.Текст = ЗапросТекущиеПотребности.Текст +
		") КАК ПланыЗакупокОбороты
		|";
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Если ЗапросТекущиеПотребности.Текст <> "" Тогда
	
		ЗапросТекущиеПотребности.Текст = Сред(ЗапросТекущиеПотребности.Текст, 12);
		Результат = ЗапросТекущиеПотребности.Выполнить().Выгрузить(ОбходРезультатаЗапроса.Прямой);
		РаспределитьПоНоменклатуре(ТекущиеПотребности, Результат);
		
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		Для каждого Строка из ТекущиеПотребности Цикл
			
			Если Строка.Сценарий.Периодичность = Перечисления.Периодичность.День Тогда
				
				Строка.ДатаПотребности = НачалоДня(Строка.ДатаПотребности);
				
			ИначеЕсли Строка.Сценарий.Периодичность = Перечисления.Периодичность.Неделя Тогда
				
				Строка.ДатаПотребности = НачалоДня(КонецНедели(Строка.ДатаПотребности));
				
			ИначеЕсли Строка.Сценарий.Периодичность = Перечисления.Периодичность.Месяц Тогда
				
				Строка.ДатаПотребности = НачалоДня(КонецМесяца(Строка.ДатаПотребности));
				
			ИначеЕсли Строка.Сценарий.Периодичность = Перечисления.Периодичность.Квартал Тогда
				
				Строка.ДатаПотребности = НачалоДня(КонецКвартала(Строка.ДатаПотребности));
				
			ИначеЕсли Строка.Сценарий.Периодичность = Перечисления.Периодичность.Год Тогда
				
				Строка.ДатаПотребности = НачалоДня(КонецГода(Строка.ДатаПотребности));
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ТипЗнч(НовыеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		СкорректироватьПотребности(НовыеПотребности);
		
		Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
			
			СложениеОбъединениеИсточников(ТекущиеПотребности, ОбъединениеИсточников);
			
		КонецЕсли;
		
		ДополнитьТаблицу(ТекущиеПотребности, НовыеПотребности);
		
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеПотребности) = Тип("ТаблицаЗначений") Тогда
		
		Для каждого Строка из ТекущиеПотребности Цикл
			
			Строка.ДатаПотребности = НачалоДня(Строка.ДатаПотребности);
			
		КонецЦикла;
		
		ТекущиеПотребности.Свернуть("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, ДатаПотребности, Заказ, Проект", "Количество");
		
		Возврат ТекущиеПотребности;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции // ВыполнитьВыборкуДанных()

Процедура СложениеОбъединениеИсточников(ТаблицаИсточник, Объединение)
	
	Если Объединение = Ложь Тогда
		
		ТаблицаИсточник.Свернуть("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, Тара, ДатаПотребности, Заказ, Проект", "Количество");
		
	Иначе
		
		ТаблицаИсточник.Сортировать("Период, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара, Тара, ДатаПотребности, Заказ, Проект, Количество Убыв");
		
		Индекс = 1;
		
		Пока Индекс < ТаблицаИсточник.Количество() Цикл
			
			Если  ТаблицаИсточник[Индекс].Номенклатура               = ТаблицаИсточник[Индекс-1].Номенклатура
				И ТаблицаИсточник[Индекс].ХарактеристикаНоменклатуры = ТаблицаИсточник[Индекс-1].ХарактеристикаНоменклатуры
				И ТаблицаИсточник[Индекс].ТоварТара                  = ТаблицаИсточник[Индекс-1].ТоварТара
				И ТаблицаИсточник[Индекс].ДатаПотребности            = ТаблицаИсточник[Индекс-1].ДатаПотребности
				И ТаблицаИсточник[Индекс].Заказ                      = ТаблицаИсточник[Индекс-1].Заказ
				И ТаблицаИсточник[Индекс].Проект                     = ТаблицаИсточник[Индекс-1].Проект Тогда
				ТаблицаИсточник.Удалить(Индекс);
				
			Иначе
				
				Индекс = Индекс + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры // СложениеОбъединениеИсточников()

Функция СкорректироватьПотребности(ТаблицаПотребности)

	// Текст запроса для отбора по составу группы доступности складов
	ТекстФильтраПоСкладам = "
	|(
	|	ВЫБРАТЬ
	|		ГруппыДоступности.Склад
	|	ИЗ
	|		РегистрСведений.СоставГруппДоступностиСкладов КАК ГруппыДоступности
	|	ГДЕ ГруппыДоступности.ГруппаДоступности = &ГруппаДоступностиСкладов)";
	
	ГруппаДоступностиСкладов = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ГруппаДоступностиСкладов");
	
	// Потребность в номенкатуре
	Запрос = Новый Запрос;
	
	// Резервы по заказам покупателей
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	Запрос.УстановитьПараметр("ГруппаДоступностиСкладов", ГруппаДоступностиСкладов);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТоварыВРезервеНаСкладахОстатки.Номенклатура               КАК Номенклатура,
	|	ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыВРезервеНаСкладахОстатки.ДокументРезерва            КАК ДокументРезерва,
	|	СУММА(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток)   КАК ОстатокРезерва
	|
	|ИЗ
	|	РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаДокумента, Склад В" + ТекстФильтраПоСкладам + " И ДокументРезерва ССЫЛКА Документ.ЗаказПокупателя) КАК ТоварыВРезервеНаСкладахОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыВРезервеНаСкладахОстатки.Номенклатура,
	|	ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры,
	|	ТоварыВРезервеНаСкладахОстатки.ДокументРезерва
	|";
	
	ТаблицаРезервовПоЗаказамПокупателей = Запрос.Выполнить().Выгрузить();
	
	// Скорректируем план потребности с учетом резервов по заказам покупателей
	ТаблицаПотребности.Сортировать("ДатаПотребности ВОЗР");
	Для каждого СтрокаРезерваПоЗаказуПокупателя Из ТаблицаРезервовПоЗаказамПокупателей Цикл
		ОстатокРезерваПоЗаказу = СтрокаРезерваПоЗаказуПокупателя.ОстатокРезерва;
		// Скорректируем товары
		СтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Заказ, Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаРезерваПоЗаказуПокупателя.ДокументРезерва, СтрокаРезерваПоЗаказуПокупателя.Номенклатура, СтрокаРезерваПоЗаказуПокупателя.ХарактеристикаНоменклатуры, Ложь));
		Для каждого СтрокаПотребности Из СтрокиПотребности Цикл
			Если ОстатокРезерваПоЗаказу = 0 Тогда
				Прервать;
			КонецЕсли; 
			Если СтрокаПотребности.Количество > ОстатокРезерваПоЗаказу Тогда
				СтрокаПотребности.Количество = СтрокаПотребности.Количество - ОстатокРезерваПоЗаказу;
				ОстатокРезерваПоЗаказу = 0;
			Иначе
				ОстатокРезерваПоЗаказу = ОстатокРезерваПоЗаказу - СтрокаПотребности.Количество;
				ТаблицаПотребности.Удалить(СтрокаПотребности);
			КонецЕсли; 
		КонецЦикла;
		
		Если ОстатокРезерваПоЗаказу > 0 Тогда
			// Скорректируем тару
			СтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Заказ, Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаРезерваПоЗаказуПокупателя.ДокументРезерва, СтрокаРезерваПоЗаказуПокупателя.Номенклатура, СтрокаРезерваПоЗаказуПокупателя.ХарактеристикаНоменклатуры, Истина));
			Для каждого СтрокаПотребности Из СтрокиПотребности Цикл
				Если ОстатокРезерваПоЗаказу = 0 Тогда
					Прервать;
				КонецЕсли; 
				Если СтрокаПотребности.Количество > ОстатокРезерваПоЗаказу Тогда
					СтрокаПотребности.Количество = СтрокаПотребности.Количество - ОстатокРезерваПоЗаказу;
					ОстатокРезерваПоЗаказу = 0;
				Иначе
					ОстатокРезерваПоЗаказу = ОстатокРезерваПоЗаказу - СтрокаПотребности.Количество;
					ТаблицаПотребности.Удалить(СтрокаПотребности);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла; 
	
	// Остатки без резервов
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаДокумента" , Дата);
	Запрос.УстановитьПараметр("ГруппаДоступностиСкладов", ГруппаДоступностиСкладов);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|
	|	ВЫБОР КОГДА РезервыНеЗаказов.КоличествоОстатокРезерва ЕСТЬ NULL ТОГДА
	|		ОстаткиНоменклатуры.ОстатокНоменклатуры
	|	ИНАЧЕ
	|		ОстаткиНоменклатуры.ОстатокНоменклатуры - РезервыНеЗаказов.КоличествоОстатокРезерва
	|	КОНЕЦ КАК ОстатокНоменклатуры,
	|	ОстаткиНоменклатуры.Номенклатура               КАК Номенклатура,
	|	ОстаткиНоменклатуры.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
	|
	|ИЗ
	|	(
	|	ВЫБРАТЬ
	|		РегистрНакопленияОстаткиТоваров.Номенклатура               КАК Номенклатура,
	|		РегистрНакопленияОстаткиТоваров.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		СУММА(РегистрНакопленияОстаткиТоваров.КоличествоОстаток)   КАК ОстатокНоменклатуры
	|	
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаДокумента, Склад В" + ТекстФильтраПоСкладам + ") КАК РегистрНакопленияОстаткиТоваров
	|
	|	СГРУППИРОВАТЬ ПО
	|		РегистрНакопленияОстаткиТоваров.Номенклатура,
	|		РегистрНакопленияОстаткиТоваров.ХарактеристикаНоменклатуры
	|
	|	) КАК ОстаткиНоменклатуры
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	(
	|	ВЫБРАТЬ
	|		ТоварыВРезервеНаСкладахОстатки.Номенклатура               КАК Номенклатура,
	|		ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		СУММА(ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток)   КАК КоличествоОстатокРезерва
	|
	|	ИЗ
	|		РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаДокумента) КАК ТоварыВРезервеНаСкладахОстатки
	|
	|	СГРУППИРОВАТЬ ПО
	|		ТоварыВРезервеНаСкладахОстатки.Номенклатура,
	|		ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры
	|
	|	) КАК РезервыНеЗаказов
	|
	|	ПО
	|		ОстаткиНоменклатуры.Номенклатура = РезервыНеЗаказов.Номенклатура
	|		И
	|		ОстаткиНоменклатуры.ХарактеристикаНоменклатуры = РезервыНеЗаказов.ХарактеристикаНоменклатуры
	|
	|";
	
	ТаблицаОстатковБезРезервов = Запрос.Выполнить().Выгрузить();
	
	// Разделим остатки на товары и тару
	ЗапросОстаткиТара = Новый Запрос;
	
	ЗапросОстаткиТара.УстановитьПараметр("ДатаДокумента", Дата);
	ЗапросОстаткиТара.УстановитьПараметр("Тара", Перечисления.СтатусыПолученияПередачиТоваров.ВозвратнаяТара);
	ЗапросОстаткиТара.УстановитьПараметр("ПустойЗаказПокупателя", Документы.ЗаказПокупателя.ПустаяСсылка());
	ЗапросОстаткиТара.УстановитьПараметр("ПустойЗаказПоставщику", Документы.ЗаказПоставщику.ПустаяСсылка());
	
	ЗапросОстаткиТара.Текст = "
	|
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА НЕ ТоварыПолученныеОстатки.Номенклатура ЕСТЬ NULL ТОГДА ТоварыПолученныеОстатки.Номенклатура ИНАЧЕ ТоварыПереданныеОстатки.Номенклатура КОНЕЦ КАК Номенклатура,
	|	ВЫБОР КОГДА НЕ ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры ЕСТЬ NULL ТОГДА ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры ИНАЧЕ ТоварыПереданныеОстатки.ХарактеристикаНоменклатуры КОНЕЦ КАК ХарактеристикаНоменклатуры,
	|	СУММА(ВЫБОР КОГДА (НЕ ТоварыПолученныеОстатки.Номенклатура ЕСТЬ NULL И НЕ ТоварыПереданныеОстатки.Номенклатура ЕСТЬ NULL) ТОГДА (ТоварыПолученныеОстатки.КоличествоОстаток - ТоварыПереданныеОстатки.КоличествоОстаток)
	|				КОГДА ТоварыПолученныеОстатки.Номенклатура ЕСТЬ NULL ТОГДА (-1 * ТоварыПереданныеОстатки.КоличествоОстаток)
	|				ИНАЧЕ ТоварыПолученныеОстатки.КоличествоОстаток КОНЕЦ) КАК Количество
	|
	|ИЗ
	|	РегистрНакопления.ТоварыПолученные.Остатки(&ДатаДокумента, СтатусПолучения = &Тара) КАК ТоварыПолученныеОстатки
	|
	|ПОЛНОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПереданные.Остатки(&ДатаДокумента, СтатусПередачи = &Тара) КАК ТоварыПереданныеОстатки
	|
	|ПО
	|	ТоварыПереданныеОстатки.Номенклатура = ТоварыПолученныеОстатки.Номенклатура
	|	И
	|	ТоварыПереданныеОстатки.ХарактеристикаНоменклатуры = ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА НЕ ТоварыПолученныеОстатки.Номенклатура ЕСТЬ NULL ТОГДА ТоварыПолученныеОстатки.Номенклатура ИНАЧЕ ТоварыПереданныеОстатки.Номенклатура КОНЕЦ,
	|	ВЫБОР КОГДА НЕ ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры ЕСТЬ NULL ТОГДА ТоварыПолученныеОстатки.ХарактеристикаНоменклатуры ИНАЧЕ ТоварыПереданныеОстатки.ХарактеристикаНоменклатуры КОНЕЦ
	|
	|";
	
	ОстаткиТарыДополнительные = ЗапросОстаткиТара.Выполнить().Выгрузить();
	ТаблицаОстатковБезРезервовКонечная = Новый ТаблицаЗначений;
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("ХарактеристикаНоменклатуры", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("ОстатокНоменклатуры", ПолучитьОписаниеТиповЧисла(15,3));
	ТаблицаОстатковБезРезервовКонечная.Колонки.Добавить("Тара", Новый ОписаниеТипов("Булево"));
	
	Для каждого СтрокаОстатковБезРезервов Из ТаблицаОстатковБезРезервов Цикл
	
		СтрокиТары = ОстаткиТарыДополнительные.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры", СтрокаОстатковБезРезервов.Номенклатура, СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры));
		Если СтрокиТары.Количество() = 0 Тогда
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Ложь;
			Продолжить;
		КонецЕсли;
		
		СтрокаТары = СтрокиТары[0];
		
		Если СтрокаТары.Количество <= 0 Тогда
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Ложь;
		ИначеЕсли СтрокаТары.Количество >= СтрокаОстатковБезРезервов.ОстатокНоменклатуры Тогда
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры;
			НоваяСтрока.Тара = Истина;
		ИначеЕсли СтрокаТары.Количество < СтрокаОстатковБезРезервов.ОстатокНоменклатуры Тогда
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаТары.Количество;
			НоваяСтрока.Тара = Истина;
			НоваяСтрока = ТаблицаОстатковБезРезервовКонечная.Добавить();
			НоваяСтрока.Номенклатура = СтрокаОстатковБезРезервов.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаОстатковБезРезервов.ХарактеристикаНоменклатуры;
			НоваяСтрока.ОстатокНоменклатуры = СтрокаОстатковБезРезервов.ОстатокНоменклатуры - СтрокаТары.Количество;
			НоваяСтрока.Тара = Ложь;
		КонецЕсли; 
	
	КонецЦикла; 
	
	// Теперь скорректируем остатки товарами к передаче со складов
	
	ЗапросТоварыКПередаче = Новый Запрос;
	
	ЗапросТоварыКПередаче.УстановитьПараметр("ДатаДокумента" , Дата);
	ЗапросТоварыКПередаче.УстановитьПараметр("ГруппаДоступностиСкладов", ГруппаДоступностиСкладов);
	
	ЗапросТоварыКПередаче.Текст = "
	|ВЫБРАТЬ
	|	ТоварыКПередачеСоСкладовОстатки.Номенклатура               КАК Номенклатура,
	|	ТоварыКПередачеСоСкладовОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СУММА(ТоварыКПередачеСоСкладовОстатки.КоличествоОстаток)   КАК КоличествоОстатокРезерва
	|
	|ИЗ
	|	РегистрНакопления.ТоварыКПередачеСоСкладов.Остатки(&ДатаДокумента, Склад В" + ТекстФильтраПоСкладам + ") КАК ТоварыКПередачеСоСкладовОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыКПередачеСоСкладовОстатки.Номенклатура,
	|	ТоварыКПередачеСоСкладовОстатки.ХарактеристикаНоменклатуры
	|
	|";
	
	ТаблицаТоваровКПередаче = ЗапросТоварыКПередаче.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаТоваровКПередаче Цикл
		
		ОстатокКПередаче = СтрокаТаблицы.КоличествоОстатокРезерва;
		
		СтрокиОстатков = ТаблицаОстатковБезРезервовКонечная.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицы.Номенклатура, СтрокаТаблицы.ХарактеристикаНоменклатуры, Истина));
		Для каждого СтрокаОстатков Из СтрокиОстатков Цикл
			Если ОстатокКПередаче = 0 Тогда
				Прервать;
			КонецЕсли; 
			Если СтрокаОстатков.ОстатокНоменклатуры >= ОстатокКПередаче Тогда
				СтрокаОстатков.ОстатокНоменклатуры = СтрокаОстатков.ОстатокНоменклатуры - ОстатокКПередаче;
				ОстатокКПередаче = 0;
			Иначе
				ОстатокКПередаче = ОстатокКПередаче - СтрокаОстатков.ОстатокНоменклатуры;
				ТаблицаОстатковБезРезервовКонечная.Удалить(СтрокаОстатков);
			КонецЕсли; 
		КонецЦикла;
		
		Если ОстатокКПередаче > 0 Тогда
			СтрокиОстатков = ТаблицаОстатковБезРезервовКонечная.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицы.Номенклатура, СтрокаТаблицы.ХарактеристикаНоменклатуры, Ложь));
			Для каждого СтрокаОстатков Из СтрокиОстатков Цикл
				Если ОстатокКПередаче = 0 Тогда
					Прервать;
				КонецЕсли; 
				Если СтрокаОстатков.ОстатокНоменклатуры >= ОстатокКПередаче Тогда
					СтрокаОстатков.ОстатокНоменклатуры = СтрокаОстатков.ОстатокНоменклатуры - ОстатокКПередаче;
					ОстатокКПередаче = 0;
				Иначе
					ОстатокКПередаче = ОстатокКПередаче - СтрокаОстатков.ОстатокНоменклатуры;
					ТаблицаОстатковБезРезервовКонечная.Удалить(СтрокаОстатков);
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли; 
	
	КонецЦикла; 
	
	// Скорректируем план потребности с учетом остатков на складе
	ТаблицаПотребности.Сортировать("ДатаПотребности ВОЗР, Заказ ВОЗР");
	Для каждого СтрокаТаблицыОстатков Из ТаблицаОстатковБезРезервовКонечная Цикл
		ОстатокТовара = СтрокаТаблицыОстатков.ОстатокНоменклатуры;
		СтрокиПотребности = ТаблицаПотребности.НайтиСтроки(Новый Структура("Номенклатура, ХарактеристикаНоменклатуры, Тара", СтрокаТаблицыОстатков.Номенклатура, СтрокаТаблицыОстатков.ХарактеристикаНоменклатуры, СтрокаТаблицыОстатков.Тара));
		Если СтрокиПотребности.Количество() > 0 И ЗначениеНеЗаполнено(СтрокиПотребности[0].Заказ) Тогда
			СтрокиПотребности.Добавить(СтрокиПотребности[0]);
			СтрокиПотребности.Удалить(0);
		КонецЕсли; 
		Для каждого СтрокаПотребности Из СтрокиПотребности Цикл
			Если ОстатокТовара = 0 Тогда
				Прервать;
			КонецЕсли; 
			Если СтрокаПотребности.Количество > ОстатокТовара Тогда
				СтрокаПотребности.Количество = СтрокаПотребности.Количество - ОстатокТовара;
				ОстатокТовара = 0;
			Иначе
				ОстатокТовара = ОстатокТовара - СтрокаПотребности.Количество;
				ТаблицаПотребности.Удалить(СтрокаПотребности);
			КонецЕсли; 
		КонецЦикла; 
	КонецЦикла;
	
	// Уберем отрицательные количества потребности
	
	Индекс = 0;
	Пока 1 = 1 Цикл
	
		Если Индекс > ТаблицаПотребности.Количество() - 1 Тогда
			Прервать;
		КонецЕсли;
		
		СтрокаПотребности = ТаблицаПотребности[Индекс];
		
		Если СтрокаПотребности.Количество <= 0 Тогда
			ТаблицаПотребности.Удалить(СтрокаПотребности);
			Продолжить;
		КонецЕсли;
		
		Индекс = Индекс + 1;
	
	КонецЦикла; 
	
	Возврат ТаблицаПотребности;
	
КонецФункции // СкорректироватьПотребностиВНоменклутуре()

Процедура РаспределитьПоНоменклатуре(ТаблицаПриемник, ТаблицаИсточник)

	ИндексСтроки = 0;

	Пока ИндексСтроки < ТаблицаИсточник.Количество() Цикл
		Если ТипЗнч(ТаблицаИсточник[ИндексСтроки].Номенклатура) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда

			ТаблицаРезультатРаспределения = 0;

			Коэффициенты = Новый Массив();
			Значения     = Новый Соответствие();

			Значения.Вставить("Количество", ТаблицаИсточник[ИндексСтроки].Количество);

			Отбор = Новый Структура("НоменклатурнаяГруппа", ТаблицаИсточник[ИндексСтроки].Номенклатура);
			Номенклатура = Справочники.Номенклатура.Выбрать(,, Отбор);
			Пока Номенклатура.Следующий() Цикл
				Если Номенклатура.ВесовойКоэффициентВхождения > 0 Тогда
					ДополнитьТаблицу(ТаблицаРезультатРаспределения, ТаблицаИсточник, , ИндексСтроки);
	                ТаблицаРезультатРаспределения[ТаблицаРезультатРаспределения.Количество() - 1].Номенклатура = Номенклатура.Ссылка;
					Коэффициенты.Добавить(Номенклатура.ВесовойКоэффициентВхождения);
				КонецЕсли;
			КонецЦикла;

			ТаблицаИсточник.Удалить(ТаблицаИсточник[ИндексСтроки]);
			
			Строки = Новый Массив();
			Для каждого Строка из ТаблицаРезультатРаспределения Цикл
				Строки.Добавить(Строка);
			КонецЦикла;
			
			Распределить(Строки, Коэффициенты, Значения);
			
			Индекс = 0;
			
			Пока Индекс < ТаблицаРезультатРаспределения.Количество() Цикл
				Если ТаблицаРезультатРаспределения[Индекс].Количество <= 0 ИЛИ ТаблицаРезультатРаспределения[Индекс].Номенклатура.Услуга Тогда
					ТаблицаРезультатРаспределения.Удалить(Индекс);
				Иначе
					Индекс = Индекс + 1;
				КонецЕсли;
			КонецЦикла;
			
			ДополнитьТаблицу(ТаблицаПриемник, ТаблицаРезультатРаспределения);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли;
	КонецЦикла;

	ДополнитьТаблицу(ТаблицаПриемник, ТаблицаИсточник);
	
КонецПроцедуры // РаспределитьПоНоменклатуре()

Процедура Распределить(Строки, Коэффициенты, Значения, ДополнятьЗначения = Ложь)

	СуммаКоэффициентов = 0;
	Для каждого Коэффициент из Коэффициенты Цикл
		СуммаКоэффициентов = СуммаКоэффициентов + Коэффициент;
	КонецЦикла;
	
	Для Индекс = 0 по Строки.Количество() - 1 Цикл
		Для каждого Значение из Значения Цикл
			Если СуммаКоэффициентов = 0 Тогда
				Строки[Индекс][Значение.Ключ] = 0;
			Иначе
				Если Индекс = Строки.Количество() - 1 Тогда
					Строки[Индекс][Значение.Ключ] = ?(ДополнятьЗначения, Строки[Индекс][Значение.Ключ], 0) + Значение.Значение;
					Значения.Вставить(Значение.Ключ, 0);
				Иначе
					Строки[Индекс][Значение.Ключ] = ?(ДополнятьЗначения, Строки[Индекс][Значение.Ключ], 0) + Окр(Значение.Значение * Коэффициенты[Индекс] / СуммаКоэффициентов, 2);
					Если Значение.Значение > 0 Тогда
						Значения.Вставить(Значение.Ключ, Значение.Значение - Строки[Индекс][Значение.Ключ]);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		СуммаКоэффициентов = СуммаКоэффициентов - Коэффициенты[Индекс];
	КонецЦикла;

КонецПроцедуры // Распределить()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	ПроверкаРеквизитов(Отказ, Заголовок);
	
	Если Отказ Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Результат = Потребности.Выгрузить();
	
	СрезПоследних = РегистрыСведений.КалендарныеПотребностиВНоменклатуре.СрезПоследних(Дата);
	
	СрезПоследних.Колонки.Удалить(СрезПоследних.Колонки["Регистратор"]);
	СрезПоследних.Колонки.Удалить(СрезПоследних.Колонки["НомерСтроки"]);
	СрезПоследних.Колонки.Удалить(СрезПоследних.Колонки["Активность"]);
	
	Индекс = 0;
	Пока Индекс < СрезПоследних.Количество() Цикл
		
		Если СрезПоследних[Индекс].Период < Дата И СрезПоследних[Индекс].Количество = 0 Тогда
			
			СрезПоследних.Удалить(Индекс);
			
		Иначе
			
			Индекс = Индекс + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СрезПоследних.ЗаполнитьЗначения(0, "Количество");
	
	Результат.Колонки.Добавить("Период");
	
	ДополнитьТаблицу(Результат, СрезПоследних);

	Если ТипЗнч(Результат) = Тип("ТаблицаЗначений") Тогда
		
		Результат.ЗаполнитьЗначения(Дата, "Период");
		Результат.Свернуть("Период, ДатаПотребности, Проект, Заказ, Номенклатура, ХарактеристикаНоменклатуры, ТоварТара", "Количество");
		
		Движения.КалендарныеПотребностиВНоменклатуре.Загрузить(Результат);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 
	
КонецПроцедуры
