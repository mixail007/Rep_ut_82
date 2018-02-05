﻿// Рассчитывает величину розничной цены по цене поставки и проценту розничной наценки.
// Розничная цена всегда в рублях и со всеми налогами. 
// Получается из цены поставки, увеличенной на процент розничной наценки, 
// пересчитанной в рубли, увеличенной при необходимости на величину налогов, 
// округленной по параметрам округления розничного типа цен.
//
// Параметры: 
//  ЦенаПоставки                   - число, цена поставки, по которой надо рассчитать розничную цену;
//  ВалютаПоставки                 - ссылка на справочник, определяет валюту цены поставки,
//                                   из которой надо рассчитать розничную цену;
//  КурсПоставки                   - число, курс валюты, в которой задана цена поставки;
//  КратностьПоставки              - число, кратность валюты, в которой задана цена поставки;
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//  ПроцентРозничнойНаценки        - число, процент розничной наценки на цену поставки;
//  ЦенаПоставкиВключаетНДС        - булево, признак того, что в цену поставки включен НДС;
//  СтавкаНДС                      - число, определяет ставку НДС в цене поставки;
//  ТипЦенРозничнойТорговли        - ссылка на справочник, определяет тип розничной цены.
//  ЕдиницаЦены                    - ссылка на элемент справочника "Единицы измерения",
//                                   определяет для какой единицы указана цена,
//  ЕдиницаХранения                - ссылка на элемент справочника "Единицы измерения",
//                                   определяет единицу хранения номенклатуры,
// 
// Возвращаемое значение:
//  Рассчитанное значение розничной цены.
//
Функция РассчитатьРозничнуюЦену(ЦенаПоставки, ВалютаПоставки, КурсПоставки,КратностьПоставки,
	                            ВалютаРегламентированногоУчета, ПроцентРозничнойНаценки,
	                            ЦенаПоставкиВключаетНДС, СтавкаНДС,
	                            ТипЦенРозничнойТорговли, ЕдиницаЦены, ЕдиницаХранения) Экспорт

	// Увеличиваем на процент розничной наценки.
	РозничнаяЦена = ЦенаПоставки * (100 + ПроцентРозничнойНаценки) / 100;

	// Пересчитаем цену из единицы цены в единицу хранения остатков.
	РозничнаяЦена = ПересчитатьЦенуПриИзмененииЕдиницы(РозничнаяЦена, ЕдиницаЦены, ЕдиницаХранения);

	// Пересчитываем в рубли.
	РозничнаяЦена = ПересчитатьИзВалютыВВалюту(РозничнаяЦена, ВалютаПоставки,
	                                           ВалютаРегламентированногоУчета, КурсПоставки, 1, КратностьПоставки);

	// Увеличиваем при необходимости на величину налогов (розничная цена всегда с налогами)
	РозничнаяЦена = ПересчитатьЦенуПриИзмененииФлаговНалогов(РозничнаяЦена,
	                Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры,
	                ЦенаПоставкиВключаетНДС, Истина, Истина, СтавкаНДС);

	// Округляем по параметрам округления розничного типа цен.
	Если ЗначениеНеЗаполнено(ТипЦенРозничнойТорговли) Тогда
		ПорядокОкругления        = Перечисления.ПорядкиОкругления.Окр0_01;
		ОкруглятьВБольшуюСторону = Ложь;
	Иначе
		ПорядокОкругления        = ТипЦенРозничнойТорговли.ПорядокОкругления;
		ОкруглятьВБольшуюСторону = ТипЦенРозничнойТорговли.ОкруглятьВБольшуюСторону
	КонецЕсли;
	РозничнаяЦена = ОкруглитьЦену(РозничнаяЦена, ПорядокОкругления, ОкруглятьВБольшуюСторону);

	Возврат РозничнаяЦена;

КонецФункции // РассчитатьРозничнуюЦену()

// Позволяет получить остатки и цены Товаров в рознице
//
// Параметры: 
//  Номенклатура               - ссылка на элемент справочника "Номенклатура", для которого надо получить цены и остаток,
//  ХарактеристикаНоменклатуры - ссылка на элемент справочника "ХарактеристикиНоменклатуры", для которого надо получить цены и остаток,
//  Склад                      - ссылка на элемент справочника "СкладыКомпании", для которого надо получить цены и остаток,
//  ЗаказПокупателя            - ссылка на документ, Заказ покупателя, из резерва по которому надо
//                               определить розничную цену, если не задан, то розничная цена
//                               берется для сводного остатка;
//  Дата                       - дата, на которую надо получить цены и остаток.
//
// Возвращаемое значение:
//  Таблица значений, содержащая найденные цены и остатки.
//
Функция ПолучитьОстаткиИЦеныВРознице(Номенклатура, ХарактеристикаНоменклатуры, Склад = Неопределено, 
	                                   ЗаказПокупателя = Неопределено, Дата = Неопределено) Экспорт

	// В качетве оперативных остатков берем текущие.
	ДатаОстатков = Дата;
	Если Дата <> Неопределено Тогда
		ДатаОстатков = ?(НачалоДня(Дата) = НачалоДня(ТекущаяДата()), Неопределено, Дата)
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата",         ДатаОстатков);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ЗаказПокупателя",ЗаказПокупателя);
	Запрос.УстановитьПараметр("Склад",               		Склад);
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", ?(ХарактеристикаНоменклатуры = Неопределено, 
	                           Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка(), ХарактеристикаНоменклатуры));
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОстаткиТоваровКомпанииОстатки.КоличествоОстаток,
	|	ОстаткиТоваровКомпанииОстатки.ЦенаВРознице
	|ИЗ
	|	РегистрНакопления.ТоварыВНеавтоматизированныхТорговыхТочках.Остатки(&Дата, 
	|		  Номенклатура               = &Номенклатура " + 
	?(ЗначениеНеЗаполнено(Склад),"",
	       "И Склад                      = &Склад") + "
	|		И ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры 
	|		И (ЦенаВРознице > 0)) КАК ОстаткиТоваровКомпанииОстатки";

	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьОстаткиИЦеныВРознице()

// Формирует список розничных цен для заданных позиций номенклатуры и характеристики на выбранном складе
// на заданную дату.
//
// Параметры:
//  Номенклатура               - ссылка на справочник, позиция номенклатуры, 
//                               для которой надо получить розничну цену;
//  Единица                    - ссылка на справочник, единица измерения в которую надо 
//                               пересчитать цену и количество остатка;
//  ХарактеристикаНоменклатуры - ссылка на справочник, характеристика номенклатуры, 
//                               для которой надо получить розничну цену;
//  СкладКомпании              - ссылка на справочник, розничный склад компании на котором надо получить
//                               розничную цену и остаток;
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//  ЗаказПокупателя            - ссылка на документ, Заказ покупателя, из резерва по которому надо
//                               определить список розничных цен, если не задан, то розничная цена
//                               берется для сводного остатка;
//  Дата                       - дата, на которую нужна цена в рознице;
//	Валюта                     - валюта, в которую необходимо пересчитать цены;
//  Курс                       - курс валюты для пересчета цен;
//  Кратность                  - кратность валюты для пересчета цен.
//
// Возвращаемое значение:
// Число, выбраное значение розничной цены.
//
Функция СформироватьСписокРозничныхЦен(Номенклатура, Единица, ХарактеристикаНоменклатуры, СкладКомпании,
	                             ВалютаРегламентированногоУчета, ЗаказПокупателя = Неопределено, Дата = Неопределено,
								 Валюта = Неопределено, Курс = Неопределено, Кратность = Неопределено,
								 УчитыватьНДС = Ложь, СуммаВключаетНДС = Ложь, СтавкаНДС = 0) Экспорт

	СписокЦен = Новый СписокЗначений();
	ТаблицаРозничныхЦен = ПолучитьОстаткиИЦеныВРознице(Номенклатура, ХарактеристикаНоменклатуры, 
	                                                     СкладКомпании, ЗаказПокупателя, Дата);

	Для каждого СтрокаТаблицы Из ТаблицаРозничныхЦен Цикл
		Цена = ПересчитатьЦенуПриИзмененииЕдиницы(СтрокаТаблицы.ЦенаВРознице, 
		                                      Номенклатура.ЕдиницаХраненияОстатков, Единица);

		// Надо как-то предупредить о нулевом коэффициенте
		Если Единица.Коэффициент = 0 Тогда
			СтрокаОстатка = "Нулевой коэффициент единицы";
		Иначе
			СтрокаОстатка = СокрЛП(СтрокаТаблицы.КоличествоОстаток / Единица.Коэффициент); 
		КонецЕсли; 

		Если Валюта <> Неопределено И Валюта <> ВалютаРегламентированногоУчета Тогда
			Цена = ПересчитатьИзВалютыВВалюту(Цена, ВалютаРегламентированногоУчета, Валюта, 1, Курс, 1, Кратность);
		КонецЕсли;

		Если УчитыватьНДС = Истина Тогда
			СпособЗаполненияЦен = Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры;
			Цена = ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, СпособЗаполненияЦен, Истина,
									 УчитыватьНДС, СуммаВключаетНДС, СтавкаНДС);
		КонецЕсли;
		
		СписокЦен.Добавить(Цена, ФорматСумм(Цена) + " (" + СтрокаОстатка + " " + СокрЛП(Единица) + ")");
	КонецЦикла; 

	Возврат СписокЦен;
	
КонецФункции // СформироватьСписокРозничныхЦен()

// Функция возвращает розничную цену для требуемой номенклатуры, 
// на заданную дату, за заданную единицу измерения, пересчитанную в требуемую валюту по заданному курсу.
//
// Параметры: 
//  Номенклатура                   - ссылка на элемент справочника "Номенклатура", для которого надо получить цену,
//  ХарактеристикаНоменклатуры     - ссылка на элемент справочника "ХарактеристикиНоменклатуры", для которого надо получить цену,
//  Склад                          - ссылка на элемент справочника "Склады компании", определяет склад
//                                   для которого надо получить цену,
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
// ЗаказПокупателя                 - ссылка на документ, Заказ покупателя, из резерва по которому надо
//                                   определить розничную цену, если не задан, то розничная цена
//                                   берется для сводного остатка;
//  Дата                           - дата, на которую надо получить цену, если не заполнено, то берется рабочая дата
//  ЕдиницаИзмерения               - ссылка на элемент справочника "Единицы измерения", определяет для какой единицы надо получить 
//                                   цену, если не заполнен, то заполняется единицей цены
//  Валюта                         - ссылка на элемент справочника "Валюты", определяет валюту. в которой надо вернуть цену,
//                                   если заполнен, то заполняется валютой цены
//  Курс                           - число, курс требуемой валюты, если не заполнен, берется курс из регистра 
//                                   сведений "Курсы валют".
//  Кратность                      - число, кратность требуемой валюты, если не заполнена, берется курс из регистра 
//                                   сведений "Курсы валют".
//
// Возвращаемое значение:
//  Число, рассчитанное значение цены.
//
Функция ПолучитьРозничнуюЦену(Номенклатура, ХарактеристикаНоменклатуры = Неопределено, Склад, ВалютаРегламентированногоУчета,
	                            ЗаказПокупателя = Неопределено, Дата = Неопределено, ЕдиницаИзмерения = Неопределено, Валюта = Неопределено, Курс = 0, Кратность = 1) Экспорт

	ПолученнаяЦена = 0;

	// Если дата не заполнена, возьмем рабочую дату
	Если ЗначениеНеЗаполнено(Дата) Тогда
		Дата = ПолучитьРабочуюДату();
	КонецЕсли; 

	// Для услуг в качестве розничной цены используется цена компании по заданному в настройках типу цен
	Если Номенклатура.Услуга
	 Или Склад.ВидСклада <> Перечисления.ВидыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		ПолученнаяЦена = ПолучитьЦенуНоменклатуры(Номенклатура, , Склад.ТипЦенРозничнойТорговли, Дата, ЕдиницаИзмерения, Валюта, Курс, Кратность);
		ЕдиницаЦены    = ЕдиницаИзмерения; // или ПолученнаяЦена приведена к нужной ЕдиницаИзмерения, или ЕдиницаИзмерения приведена к единице цены
		ВалютаЦены     = Валюта; 
	Иначе //Для Товаров розничная цена достается из регистра остатков Товаров по значению измерения "ЦенаВРознице"

		ТаблицаРозничныхЦен = ПолучитьОстаткиИЦеныВРознице(Номенклатура, ХарактеристикаНоменклатуры, Склад, 
		                                                     ЗаказПокупателя, Дата);
		Если ТаблицаРозничныхЦен.Количество() = 0 Тогда // Нет розничных цен
			ПолученнаяЦена = 0;
		Иначе
			ПолученнаяЦена = ТаблицаРозничныхЦен[0].ЦенаВРознице; // Берем первую розничную цену
		КонецЕсли; 
		
		ЕдиницаЦены = Номенклатура.ЕдиницаХраненияОстатков;  // розничные цены задаются в базовых единицах
		ВалютаЦены  = ВалютаРегламентированногоУчета;
		
	КонецЕсли; 

	// Пересчитаем цену по коэффициенту ЕдиницаИзмерения, если ЕдиницаИзмерения не заполнено, то она устанавливается равной ЕдиницаЦены
	ПолученнаяЦена = ПересчитатьЦенуПриИзмененииЕдиницы(ПолученнаяЦена, ЕдиницаЦены, ЕдиницаИзмерения);

	// Пересчитаем цену в валюту Валюта, если она не заполнена, то установим ее в ВалютыЦены
	ПолученнаяЦена = ПересчитатьЦенуПриИзмененииВалюты(ПолученнаяЦена, ВалютаЦены, Валюта, Курс, Кратность, Дата);

	Возврат ПолученнаяЦена;

КонецФункции // ПолучитьРозничнуюЦену()

// Определяет есть ли в данном документе склад - неавтоматизированная торговая точка,
// для которого надо указывать цену в рознице.
//
// Параметры: 
//  ДокументОбъект     - объект редактируемого документа.
//
// Возвращаемое значение:
//  Ссылка на розничный склад, если нет розничного склада, то Неопределено.
//
Функция ЕстьНеавтоматизированныйРозничныйСкладДокумента(ДокументОбъект) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();

	Если ЕстьРеквизитДокумента("СкладПолучатель", МетаданныеДокумента) Тогда
		Склад = ДокументОбъект.СкладПолучатель;

	ИначеЕсли ЕстьРеквизитДокумента("Склад", МетаданныеДокумента) Тогда
		Склад = ДокументОбъект.Склад;

	Иначе
		Возврат Неопределено; // Нет склада, будем считать, что не розничный.

	КонецЕсли;

	Если Склад.ВидСклада = Перечисления.ВидыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		Возврат Склад;
	Иначе
		Возврат Неопределено; // Нет розничного склада.

	КонецЕсли;

КонецФункции // ЕстьНеавтоматизированныйРозничныйСкладДокумента()

// Процедура проверяет уникальность кода магнитной карты
//
// Параметры:
//  Форма                       - форма документа, в которую пришло событие от ридера магнитных карт
//  ДокументОбъект              - объект документа, в форму которого пришло событие от ридера магнитных карт
//  СтруктураИсходныхПараметров - структура параметров, переданных из формы
//  Данные                      - данные ридера магнитных карт
//
Функция ПроверитьУникальностьМагнитногоКода(Данные, Карта) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодКарты", Данные);
	Запрос.УстановитьПараметр("Карта", Карта);
	Запрос.Текст = "ВЫБРАТЬ
	|	ИнформационныеКарты.КодКарты,
	|	ИнформационныеКарты.Ссылка КАК Карта,
	|	Ложь КАК ЭтоПрефиксКода
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|
	|ГДЕ
	|	ИнформационныеКарты.Ссылка <> &Карта И (ИнформационныеКарты.КодКарты  = &КодКарты)
	|	И НЕ ИнформационныеКарты.ЭтоПрефиксКода";

	Карты = Запрос.Выполнить().Выгрузить();

	Запрос.Текст = "ВЫБРАТЬ
	|	ИнформационныеКарты.КодКарты,
	|	ИнформационныеКарты.Ссылка КАК Карта,
	|	Истина КАК ЭтоПрефиксКода
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|
	|ГДЕ
	|	ИнформационныеКарты.Ссылка <> &Карта И ИнформационныеКарты.ЭтоПрефиксКода";

	КартыСПрефиксом = Запрос.Выполнить().Выгрузить();

	Для Каждого ТекущаяКарта Из КартыСПрефиксом Цикл
		Если Лев(Данные, СтрДлина(ТекущаяКарта.КодКарты)) = ТекущаяКарта.КодКарты Тогда
			СтрокаКарт = Карты.Добавить();
			СтрокаКарт.КодКарты = ТекущаяКарта.КодКарты;
			СтрокаКарт.Карта = ТекущаяКарта.Карта;
			СтрокаКарт.ЭтоПрефиксКода = ТекущаяКарта.ЭтоПрефиксКода;
		КонецЕсли;
	КонецЦикла;

	Возврат Карты;

КонецФункции

// Проверка наличия в передаваемот штрих-коде только цифр
//
// Параметры:
//  ШтрихКод     - проверяемый штрих-код
//
// Возвращаемое значение:
//  Истина если штрих код только из цифр, иначе Ложь
//
Функция ТолькоЦифры(Штрихкод)

	Для Сч = 1 По СтрДлина(Штрихкод) Цикл
		Символ = Сред(Штрихкод, Сч, 1);
		Если НЕ(Найти("0123456789", Символ)) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;

	Возврат Истина;

КонецФункции // ТолькоЦифры()

// Функция вычисляет контрольный символ кода EAN
//
// Параметры:
//  ШтрихКод     - штрих-код (без контрольной цифры)
//  Тип          - тип штрих-кода: 13 - EAN13, 8 - EAN8
//
// Возвращаемое значение:
//  Контрольный символ штрих-кода
//
Функция КонтрольныйСимволEAN(ШтрихКод, Тип) Экспорт

	Четн   = 0;
	Нечетн = 0;

	КоличествоИтераций = ?(Тип = 13, 6, 4);

	Для Индекс = 1 По КоличествоИтераций Цикл
		Если (Тип = 8) и (Индекс = КоличествоИтераций) Тогда
		Иначе
			Четн   = Четн   + Сред(ШтрихКод, 2 * Индекс, 1);
		КонецЕсли;
		Нечетн = Нечетн + Сред(ШтрихКод, 2 * Индекс - 1, 1);
	КонецЦикла;

	Если Тип = 13 Тогда
		Четн = Четн * 3;
	Иначе
		Нечетн = Нечетн * 3;
	КонецЕсли;

	КонтЦифра = 10 - (Четн + Нечетн) % 10;

	Возврат ?(КонтЦифра = 10, "0", Строка(КонтЦифра));

КонецФункции // КонтрольныйСимволEAN()

// Проверка штрих-кода на корректность
//
// Параметры:
//  ШтрихКод     - проверяемый штрих-код;
//  ТипШтрихкода - элемент плана видов характеристик "ТипыШтрихкодов", содержит тип
//                 проверяемого штрих-кода.
//
// Возвращаемое значение:
//  Истина если штрих код корректен, иначе Ложь
//
Функция ПроверитьШтрихКод(ШтрихКод, ТипШтрихкода) Экспорт

	ДлинаКода = СтрДлина(Штрихкод);

	Если ДлинаКода = 0 Тогда
		Возврат Ложь;
	Иначе
		Если ТипШтрихкода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13 Тогда
			Если (ДлинаКода <> 13)
			 Или НЕ(ТолькоЦифры(Штрихкод)) // штрих-код должен состоять из цифр
			 Или КонтрольныйСимволEAN(Лев(Штрихкод,12), 13) <> Прав(Штрихкод, 1) Тогда
				Возврат Ложь;
			КонецЕсли;
		ИначеЕсли ТипШтрихкода = ПланыВидовХарактеристик.ТипыШтрихкодов.EAN8 Тогда
			Если (ДлинаКода <> 8)
			 Или НЕ(ТолькоЦифры(Штрихкод)) // штрих-код должен состоять из цифр
			 Или КонтрольныйСимволEAN(Лев(Штрихкод, 7), 8 ) <> Прав(Штрихкод, 1) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Истина;

КонецФункции // ПроверитьШтрихКод()

// Проверка штрих-кода на уникальность
//
// Параметры:
//  ШтрихКод      - проверяемый штрих-код;
//
// Возвращаемое значение:
//  НайденныеШтрихкоды - Таблица, содержащая данные о найденых штрихкодах
//
Функция ПроверитьУникальностьШтрихКода(ШтрихКод, Код) Экспорт

	Если ЗначениеНеЗаполнено(ШтрихКод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ШтрихКод", ШтрихКод);
	Запрос.УстановитьПараметр("Код", Код);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Штрихкоды.Код,
	|	Штрихкоды.ТипШтрихкода,
	|	Штрихкоды.ШтрихКод,
	|	Штрихкоды.Владелец,
	|	Штрихкоды.ЕдиницаИзмерения,
	|	Штрихкоды.ХарактеристикаНоменклатуры,
	|	Штрихкоды.СерияНоменклатуры,
	|	Штрихкоды.Качество
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды
	|
	|ГДЕ
	|	Штрихкоды.Код <> &Код
	|	И Штрихкоды.ШтрихКод = &ШтрихКод
	|
	|УПОРЯДОЧИТЬ ПО
	|	Владелец
	|";

	Результат = Запрос.Выполнить();
	НайденныеШтрихкоды = Новый ТаблицаЗначений;
	НайденныеШтрихкоды = Результат.Выгрузить();

	Возврат НайденныеШтрихкоды;

КонецФункции // ПроверитьУникальностьШтрихКода()

// Формирование внутреннего штрих-кода
//
// Параметры:
//  ШтрихКод      - проверяемый штрих-код;
//  Код           - код текущих данных штрихкода;
//
// Возвращаемое значение:
//  НайденныеШтрихкоды - Таблица, содержащая данные о найденых штрихкодах
//
Функция СформироватьШтрихКод(Код, Весовой = Ложь) Экспорт

	НеНашлиУникальный = Истина;
	Сч = 0;
	ТекКод = Код;
	Пока НеНашлиУникальный Цикл
		ТекКод = Число(ТекКод)+Сч;
		ТекКод = СтрЗаменить(ТекКод,Символы.НПП,"");
		Если Весовой Тогда
			Префикс = СокрЛП(ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13.ПрефиксВесовогоТовара);
			Если Префикс = "" Тогда
				Сообщить("Не указан префикс весового товара в настройках учета!!");
				Возврат "";
			КонецЕсли;
			ТекКод = ""+ТекКод;
			Если СтрДлина(ТекКод) <5 Тогда
				Пока СтрДлина(ТекКод) < 5 Цикл
					ТекКод = "0"+ТекКод;
				КонецЦикла;
			ИначеЕсли СтрДлина(ТекКод) > 5 Тогда //Ищем первый свободный.
				ТекКод = "00001";
			КонецЕсли;
			Штрихкод = "2"+Префикс+ТекКод+"00000";
			Штрихкод = Штрихкод + КонтрольныйСимволEAN(ШтрихКод, 13);
		Иначе
			Префикс = СокрЛП(ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13.ПрефиксШтучногоТовара);
			Если ЗначениеНеЗаполнено(Префикс) Тогда
				ТекКод = ""+ТекКод;
				Пока СтрДлина(ТекКод)<11 Цикл
					ТекКод = "0"+ТекКод;
				КонецЦикла;
				Штрихкод = "2"+ТекКод;
			Иначе
				ТекКод = ""+ТекКод;
				Пока СтрДлина(ТекКод)<10 Цикл
					ТекКод = "0"+ТекКод;
				КонецЦикла;
				Штрихкод = "2"+Префикс+ТекКод;
			КонецЕсли;
			Штрихкод = Штрихкод + КонтрольныйСимволEAN(ШтрихКод, 13);
		КонецЕсли;
		НайденныеЗаписи = ПроверитьУникальностьШтрихКода(ШтрихКод, Код);
		Если НайденныеЗаписи <> Неопределено И НайденныеЗаписи.Количество()<>0 Тогда //Найдены неуникальные записи.
		Иначе
			НеНашлиУникальный = Ложь;
		КонецЕсли;
		Сч = Сч+1;
	КонецЦикла;

	Возврат Штрихкод;

КонецФункции // СформироватьШтрихКод()

// Получение нового кода штрих-кода для регистра сведений "Штрихкоды"
//
// Возвращаемое значение:
//  Код           - новый код для штрих-кода;
//
Функция ПолучитьНовыйКодДляШтрихКода() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МАКСИМУМ(Штрихкоды.Код) КАК Код
	|ИЗ
	|	РегистрСведений.Штрихкоды КАК Штрихкоды";
	Выборка = Запрос.Выполнить().Выбрать();

	Код = 1;
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Если НЕ ЗначениеНеЗаполнено(Выборка.Код) Тогда
			Код = Выборка.Код+1;
		КонецЕсли;
	КонецЕсли;

	Возврат Код;

КонецФункции // ПолучитьНовыйКодДляШтрихКода()

// Функция возвращает штрих-код для требуемой номенклатуры, 
// на заданную дату, за заданную единицу измерения, пересчитанную в требуемую валюту по заданному курсу.
//
// Параметры: 
//  ТипШтрихкода                   - ссылка на элемент плана видов характеристик "ТипыШтрихкодов",
//  Владелец                       - ссылка на элемент справочника "Номенклатура",
//  ЕдиницаИзмерения               - ссылка на элемент справочника "Единицы измерения", определяет
//                                   для какой единицы надо получить штрихкод,
//  ХарактеристикаНоменклатуры     - ссылка на элемент справочника "Характеристики номенклатуры", определяет
//                                   для какой характеристики надо получить штрихкод,
//  СерияНоменклатуры              - ссылка на элемент справочника "Характеристики номенклатуры", определяет
//                                   для какой характеристики надо получить штрихкод,
//  КачествоНоменклатуры           - ссылка на элемент справочника "Характеристики номенклатуры", определяет
//                                   для какой характеристики надо получить штрихкод.
//
// Возвращаемое значение:
//  Строка таблицы значений - результата запроса.
//
Функция ПолучитьШтрихКод(Владелец, ЕдиницаИзмерения = Неопределено, ХарактеристикаНоменклатуры = Неопределено,
	                     СерияНоменклатуры = Неопределено, Качество = Неопределено) Экспорт

	ПолученныйШтрихкод = Неопределено;
	Запрос = Новый Запрос;
	
	Если ТипЗнч(ЕдиницаИзмерения) = Тип ("Неопределено") Тогда
		ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка();
	КонецЕсли;
	
	Если ТипЗнч(ХарактеристикаНоменклатуры) = Тип ("Неопределено") Тогда
		ХарактеристикаНоменклатуры = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	Если ТипЗнч(СерияНоменклатуры) = Тип ("Неопределено") Тогда
		СерияНоменклатуры = Справочники.СерииНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	Если ТипЗнч(Качество) = Тип ("Неопределено") Тогда
		Качество = Справочники.Качество.ПустаяСсылка();
	КонецЕсли;
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ЕдиницаИзмерения", ЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	Запрос.УстановитьПараметр("СерияНоменклатуры", СерияНоменклатуры);
	Запрос.УстановитьПараметр("Качество", Качество);
	Запрос.Текст = "
	|ВЫБРАТЬ //ПЕРВЫЕ 1
	|	РегШтрихкоды.ТипШтрихкода,
	|	РегШтрихкоды.Штрихкод,
	|	РегШтрихкоды.Код
	|	ИЗ РегистрСведений.Штрихкоды КАК РегШтрихкоды
	|
	|ГДЕ
	|	НЕ РегШтрихкоды.Штрихкод Есть NULL И
	|	РегШтрихкоды.Владелец = &Владелец И
	|	РегШтрихкоды.ЕдиницаИзмерения = &ЕдиницаИзмерения И
	|	РегШтрихкоды.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры И
	|	РегШтрихкоды.СерияНоменклатуры = &СерияНоменклатуры И
	|	РегШтрихкоды.Качество = &Качество
	|";

	Выборка = Запрос.Выполнить().Выгрузить();
	
	Если Выборка.Количество() > 0 Тогда
		ПолученныйШтрихкод = Выборка[0];
	КонецЕсли;

	Возврат ПолученныйШтрихкод;

КонецФункции // ПолучитьШтрихКод()

#Если Клиент Тогда
// Печать этикеток со штрих-кодом
//
Процедура ПечатьЭтикеток(Товары = Неопределено) Экспорт

	Попытка
		КомпонентШК = Новый COMОбъект("V8.Barcod.1");
	Исключение
		Сообщить("Компонента '1С:Печать штрихкодов' не установлена на данном компьютере!", СтатусСообщения.Важное);
		Возврат;
	КонецПопытки;

	Если ТипЗнч(Товары) = Тип ("ТаблицаЗначений") Тогда
		ФормаОбработкиЭтикеток = Обработки.ПечатьЭтикеток.Создать().ПолучитьФорму();
		ФормаОбработкиЭтикеток.мВнешняяТаблицаТоваров = Товары;
		ФормаОбработкиЭтикеток.Открыть();
		
	//+++ 24.10.2017 открываем 290 обработку и печатаем этикетку 100х150
	ИначеЕсли ТипЗнч(Товары) = Тип ("СправочникСсылка.Номенклатура") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"ВнешнийОтчет290.epf";
		файл = новый файл(ИмяФайла);
		
		Если НЕ Файл.Существует() тогда
			обр = справочники.ВнешниеОбработки.НайтиПоКоду(290); // печать штрихкодов
			ДвоичныеДанные = обр.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
		КонецЕсли;
  
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Товары;
		Если Товары.ВидТовара = перечисления.ВидыТоваров.Диски тогда
			табДок = Обработка.Печать(); //сразу печатаем
			табДок.Показать();
		Иначе
			 форма1 = Обработка.ПолучитьФорму();
			 форма1.Открыть();
			 форма1.НоменклатураСписок = Товары;
		КонецЕсли;
		
	КонецЕсли;


КонецПроцедуры // ПечатьЭтикеток()

// Проверяет необходимость открытия формы "РегистрацияПродаж" документа "ЧекККМ.
//
Процедура ЗапускИнтерфейсаКассира(глТекущийПользователь, глТорговоеОборудование, ВключенИнтерфейсКассира) Экспорт
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();

	Если ПользовательИБ <> Неопределено
	   И ПользовательИБ.ОсновнойИнтерфейс <> Неопределено
	   И ПользовательИБ.ОсновнойИнтерфейс.Имя = "ИнтерфейсКассира" Тогда //Задействуем интерфейс кассира

		ВключенИнтерфейсКассира = Истина;
		Администратор = Ложь;
		Кассир = Ложь;

		Для каждого ТекИнтерфейс Из ГлавныйИнтерфейс Цикл
			ТекИнтерфейс.Переключаемый = Ложь;
			ТекИнтерфейс.Видимость     = Ложь;
		КонецЦикла;
		ИнтерфейсКассира = ГлавныйИнтерфейс.ИнтерфейсКассира;
		ИнтерфейсКассира.Переключаемый = Истина;
		ИнтерфейсКассира.Видимость     = Истина;

		Если РольДоступна("АдминистраторККМ")
		 Или РольДоступна("АдминистраторККМСОграничениемПравДоступа")Тогда //Администратор

			Администратор = Истина;

		ИначеЕсли РольДоступна("ОператорККМ")
		      Или РольДоступна("ОператорККМСОграничениемПравДоступа") Тогда //Кассир

			Кассир = Истина;

		КонецЕсли;

		Отказ = Ложь;
		Причина = "";
		КассаККМ = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяКассаККМ");
		Если КассаККМ = Справочники.КассыККМ.ПустаяСсылка() Тогда
			Предупреждение("Для пользователя """+ глТекущийПользователь +""" не выбрана касса по умолчанию!");
			//Отказ = Истина;
			Причина = "Не выбрана касса по умолчанию";
		КонецЕсли;

		Склад = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнойСклад");
		Если Склад = Неопределено
		 Или Склад = Справочники.Склады.ПустаяСсылка() Тогда
			Предупреждение("Для пользователя """+ глТекущийПользователь +""" не выбран склад по умолчанию!");
			//Отказ = Истина;
			Причина = "Не выбран склад по умолчанию";
		КонецЕсли;
		ФР = Неопределено;

		Если Не Отказ Тогда
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("КассаККМ" , КассаККМ);
			Запрос.УстановитьПараметр("Компьютер", Врег(ИмяКомпьютера()));
			Запрос.УстановитьПараметр("Вид"      , Перечисления.ВидыТорговогоОборудования.ККТсПередачейДанных);

			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТорговоеОборудование.МодельТорговогоОборудования КАК Модель,
			|	ТорговоеОборудование.НомерЛогическогоУстройства КАК НомерЛУ,
			|	ТорговоеОборудование.Подключено КАК Подключено
			|ИЗ
			|	РегистрСведений.ТорговоеОборудование КАК ТорговоеОборудование
			|
			|ГДЕ
			|	ТорговоеОборудование.КассаККМ = &КассаККМ
			|	И ТорговоеОборудование.Компьютер = &Компьютер
			|	И ТорговоеОборудование.МодельТорговогоОборудования.ВидТорговогоОборудования = &Вид";

			Выборка = Запрос.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				Если Не(Выборка.Подключено) Тогда

					Предупреждение("Фискальный регистратор """+ Выборка.Модель +""" не подключен!");
					//Отказ = Истина;
					Причина = "ФР не подключен";

				ИначеЕсли глТорговоеОборудование = Неопределено Тогда

					Предупреждение("Торговое оборудование не подключено!");
					//Отказ = Истина;
					Причина = "ТО не подключено";

				ИначеЕсли Склад.НомерСекции = 0 Тогда

				//	Предупреждение("У склада: """ + Склад + """не указан номер секции!");
					//Отказ = Истина;
				//	Причина = "У склада не указан номер секции";

				Иначе 

				КонецЕсли;
					
			Иначе
				Предупреждение("У кассы: """ + КассаККМ + """, для компьютера: """ + ИмяКомпьютера() + """, фискальный регистратор не установлен!");
				//Отказ = Истина;
				Причина = "У кассы не установлен ФР";
			КонецЕсли;
		КонецЕсли;

		Если Не Отказ Тогда
			мСтрокаФР = глТорговоеОборудование.млФР.Найти(КассаККМ, "КассаККМ");
			Если мСтрокаФР <> Неопределено Тогда
				Объект = мСтрокаФР.Объект;

				Если Объект = Неопределено Тогда
					Предупреждение("Торговое оборудование не подключено!");
					//Отказ = Истина;
					Причина = "ТО не подключено";
				КонецЕсли;

				Ответ = "";
				глТорговоеОборудование.АннулироватьЧек(мСтрокаФР, Ответ, Ложь); // Если чек не закрыт - аннулируем.

				Параметры = Новый Структура;
				Ответ = "";
				глТорговоеОборудование.ПолучитьНомерЧекаСмены(мСтрокаФР, Параметры, Ответ);
				Если НЕ ПустаяСтрока(Ответ) Тогда
					Отказ = Истина;
					ТекстПредупреждения = Ответ;
					Если Ответ = "Неверный пароль" Тогда
						ТекстПредупреждения = "В настройках пользователя нужно установить верный пароль кассира"
						                      + Символы.ПС +  "или администратора, совпадающий с паролем в фискальном регистраторе.";
					КонецЕсли;
					Предупреждение(ТекстПредупреждения,,"Ошибка при подключении к фискальному регистратору!");
					Причина = "Ошибка при Подключении к ФР";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		Если Не Отказ Тогда
			Если ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "РаботникТСЦ") Тогда
				Если яштПроверкаСоответствияСкладовОрганизацийКасс(глТекущийПользователь) Тогда	
					ФормаДокумента = Документы.ЧекККМ.СоздатьДокумент().ПолучитьФорму("ФормаРегистрацииПродажТСЦ",);
				Иначе ЗавершитьРаботуСистемы();
				КонецЕсли;
			ИначеЕсли ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ПродажаАвтозапчастей") Тогда
				ФормаДокумента=Документы.ЧекККМАвтозапчасти.ПолучитьФормуСписка("ФормаСписка");
				ФормаДокумента.Открыть();
				Возврат;
			Иначе
				ФормаДокумента = Документы.ЧекККМ.СоздатьДокумент().ПолучитьФорму("ФормаРегистрацииПродаж",);
			КонецЕсли;
			
			ФормаДокумента.ОткрытьМодально();
			ЗавершитьРаботуСистемы(Ложь);

			
		ИначеЕсли Администратор Тогда

			Предупреждение("Зайдите с правами администратора кассы.");
			Если Причина = "ФР не подключен" 
			 Или Причина = "ТО не подключено" 
			 Или Причина = "У кассы не установлен ФР" Тогда
				ФормаПодключенияОборудования = Обработки.ТорговоеОборудование.ПолучитьФорму();
				ФормаПодключенияОборудования.Открыть();
			КонецЕсли;
			ЗавершитьРаботуСистемы();

		ИначеЕсли Кассир Тогда

			Если Причина = "ФР не подключен" 
			 Или Причина = "ТО не подключено" 
			 Или Причина = "У кассы не установлен ФР" Тогда
				Предупреждение("Зайдите с правами администратора кассы.");
			КонецЕсли;

			ЗавершитьРаботуСистемы();

		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
#КонецЕсли
