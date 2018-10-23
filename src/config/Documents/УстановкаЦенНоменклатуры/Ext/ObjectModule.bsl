﻿Перем мВалютаРегламентированногоУчета Экспорт;
Перем мИспользоватьХарактеристики Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ 

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
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Ответственный.Представление КАК ОтветственныйПредставление
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры КАК УстановкаЦенНоменклатуры
	|
	|ГДЕ
	|	УстановкаЦенНоменклатуры.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	(УстановкаЦенНоменклатуры.ИндексСтрокиТаблицыЦен + 1)    КАК НомерСтроки,
	|	УстановкаЦенНоменклатуры.Номенклатура,
	|	УстановкаЦенНоменклатуры.Номенклатура.НаименованиеПолное КАК Товар,
	|	УстановкаЦенНоменклатуры.ХарактеристикаНоменклатуры      КАК Характеристика,
	|	NULL                                                     КАК Серия,
	|	УстановкаЦенНоменклатуры.ТипЦен                          КАК ТипЦен,
	|	УстановкаЦенНоменклатуры.Цена,
	|	УстановкаЦенНоменклатуры.ЕдиницаИзмерения.Представление  КАК ЕдиницаИзмеренияПредставление,
	|	УстановкаЦенНоменклатуры.Валюта,
	|	УстановкаЦенНоменклатуры.Валюта.Представление            КАК ВалютаПредставление,
	|	УстановкаЦенНоменклатуры.ПроцентСкидкиНаценки
	|
	|ИЗ
	|	Документ.УстановкаЦенНоменклатуры.Товары КАК УстановкаЦенНоменклатуры
	|
	|ГДЕ
	|	УстановкаЦенНоменклатуры.Ссылка = &ТекущийДокумент
	|
	|УПОРЯДОЧИТЬ ПО
	|	УстановкаЦенНоменклатуры.ИндексСтрокиТаблицыЦен,
	|	УстановкаЦенНоменклатуры.ТипЦен
	|
	|ИТОГИ
	|ПО УстановкаЦенНоменклатуры.ИндексСтрокиТаблицыЦен
	|";

	ЗапросПоТоварам = Запрос.Выполнить();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УстановкаЦенНоменклатуры_ИзменениеЦен";

	Макет = ПолучитьМакет("ИзменениеЦен");

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(ЭтотОбъект, "Изменение цен номенклатуры");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьШапкаНоменклатура   = Макет.ПолучитьОбласть("ШапкаТаблицы|Номенклатура");
	ОбластьШапкаТипЦен         = Макет.ПолучитьОбласть("ШапкаТаблицы|Цена");
	ОбластьСтрокаНоменклатура  = Макет.ПолучитьОбласть("Строка|Номенклатура");
	ОбластьСтрокаТипЦен        = Макет.ПолучитьОбласть("Строка|Цена");
	ОбластьПодвалНоменклатура  = Макет.ПолучитьОбласть("Подписи|Номенклатура");
	ОбластьПодвалТипЦен        = Макет.ПолучитьОбласть("Подписи|Цена");

	// Выведем шапку
	ТабДокумент.Вывести(ОбластьШапкаНоменклатура);
	ВыборкаПоСтрокам = ЗапросПоТоварам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаПоСтрокам.Следующий() Тогда
		Выборка = ВыборкаПоСтрокам.Выбрать();
		Пока Выборка.Следующий() Цикл
			ОбластьШапкаТипЦен.Параметры.Заполнить(Выборка);
			ТабДокумент.Присоединить(ОбластьШапкаТипЦен);
		КонецЦикла;
	КонецЕсли;

	// Выведем таблицу
	ВыборкаПоСтрокам = ЗапросПоТоварам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСтрокам.Следующий() Цикл
		НоменклатураВыведена = Ложь;
		Выборка = ВыборкаПоСтрокам.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если НЕ НоменклатураВыведена Тогда
				ОбластьСтрокаНоменклатура.Параметры.Заполнить(Выборка);
				ОбластьСтрокаНоменклатура.Параметры.Товар = Выборка.Товар + ПредставлениеСерий(Выборка);
				ТабДокумент.Вывести(ОбластьСтрокаНоменклатура);
				НоменклатураВыведена = Истина;
			КонецЕсли;
			ОбластьСтрокаТипЦен.Параметры.Заполнить(Выборка);
			ТабДокумент.Присоединить(ОбластьСтрокаТипЦен);
		КонецЦикла;
	КонецЦикла;

	// Выведем подвал
	ОбластьПодвалНоменклатура.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьПодвалНоменклатура);
	ВыборкаПоСтрокам = ЗапросПоТоварам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Если ВыборкаПоСтрокам.Следующий() Тогда
		Выборка = ВыборкаПоСтрокам.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТабДокумент.Присоединить(ОбластьПодвалТипЦен);
		КонецЦикла;
	КонецЕсли;

	ТекОбласть = ТабДокумент.Области.ОтветственныйПредставление;

	ОбластьОтветственного = ТабДокумент.Область(ТекОбласть.Низ, 14, ТекОбласть.Низ, Мин(ТабДокумент.ШиринаТаблицы, 29));
	ОбластьОтветственного.Объединить();
	ОбластьОтветственного.ГраницаСнизу            = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная);
	ОбластьОтветственного.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Право;

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
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь, Форма = Неопределено) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Форма <> Неопределено Тогда
		Если Не ПроверитьМодифицированностьВФорме(ЭтотОбъект, Форма) Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если ИмяМакета = "ПереченьЦен" Тогда
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

	СписокМакетов.Добавить("ПереченьЦен", "Перечень цен");

	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура();

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

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

	// Общую процедуру проверки в этом документе звать нельзя, потому что номер строки в форме документа
	// отличается от системного.
	Для каждого СтрокаТаблицы Из ТаблицаПоТоварам Цикл

		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.ИндексСтрокиТаблицыЦен + 1) +
			                    """ табличной части для типа цен """ 
			                   + СокрЛП(СтрокаТаблицы.ТипЦен) + """ ";

		// Номенклатура.
		Если ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
		
			ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не заполнена Номенклатура.", Отказ, Заголовок);;
		
		КонецЕсли;

		// Валюта.
		Если ЗначениеНеЗаполнено(СтрокаТаблицы.Валюта) Тогда
		
			ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не заполнена Валюта.", Отказ, Заголовок);;
		
		КонецЕсли;

		// Единица для товаров.
		Если (Не ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура))
		   И (Не СтрокаТаблицы.Услуга)
		   И ЗначениеНеЗаполнено(СтрокаТаблицы.ЕдиницаИзмерения) Тогда
		
			ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "не заполнена единица измерения.", Отказ, Заголовок);;

		
		КонецЕсли;

		// Наборов здесь быть не должно.
		Если Не ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура) 
		   И  СтрокаТаблицы.Набор Тогда

				ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "содержится набор. " +
				                   "Наборов здесь быть не должно!", Отказ, Заголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	НаборДвижений   = Движения.ЦеныНоменклатуры;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	
	// Заполним таблицу движений.
	ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		
	//+++ 02.11.2016 упр.блокировка с отбором по номенклатуре и типу цен
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЦеныНоменклатуры");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ЭтотОбъект.Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТипЦен", "ТипЦен");
	//во время выполнения движения - получение цен этих товаров (по выбранным типам цен) 
	//будет НЕДОСТУПНО в заказах покупателей и на web-сервисах
	Блокировка.Заблокировать();
    //--Баланс
		
	Движения.ЦеныНоменклатуры.ВыполнитьДвижения();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрам

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда

		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
    ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОприходованиеТоваров") Тогда
		ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если НЕ РольДоступна("ПолныеПрава") Тогда
		//можно проводить документы только с текущей датой
		Если День(Дата) <> День(ТекущаяДата()) Тогда
			#Если Клиент тогда
				Предупреждение("Вы можете проводить документы ценообразования только с текущей датой!");
			#КонецЕсли
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, "");

	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура",               "Номенклатура");
	СтруктураПолей.Вставить("ИндексСтрокиТаблицыЦен"    , "ИндексСтрокиТаблицыЦен");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("Цена",                       "Цена");
	СтруктураПолей.Вставить("Валюта",                     "Валюта");
	СтруктураПолей.Вставить("ЕдиницаИзмерения",           "ЕдиницаИзмерения");
	СтруктураПолей.Вставить("ТипЦен",                     "ТипЦен");
	СтруктураПолей.Вставить("ПроцентСкидкиНаценки",       "ПроцентСкидкиНаценки");

	РезультатЗапросаПоТоварам = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);
	ТаблицаПоТоварам          = РезультатЗапросаПоТоварам.Выгрузить();

	Если СтруктураШапкиДокумента.НеПроводитьНулевыеЗначения Тогда
		Сч = 0;
		Пока Сч < ТаблицаПоТоварам.Количество() Цикл
			СтрокаТаблицы = ТаблицаПоТоварам.Получить(Сч);
			Если (СтрокаТаблицы.ТипЦен.Рассчитывается
			   И СтрокаТаблицы.ПроцентСкидкиНаценки = 0)
			 Или (НЕ СтрокаТаблицы.ТипЦен.Рассчитывается
			   И СтрокаТаблицы.Цена = 0) Тогда
				ТаблицаПоТоварам.Удалить(СтрокаТаблицы);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры	// ОбработкаПроведения

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	#Если Клиент тогда
	яштДокументОбъектПередЗаписью(ЭтотОбъект, Отказ);
	
	Если НЕ ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "РазрешитьЦенообразование") Тогда   //глТекущийПользователь
		
			Предупреждение("Операции ценообразования запрещены!");	
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;
    #КонецЕсли
	
		//+++ 07.09.2017 - пока как рекоментация с 17-00 до 2х ночи можно менять цены...
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение тогда
		ТекущаяДата1 = ОценкаПроизводительностиВызовСервераПолныеПрава.ДатаИВремяНаСервере(); 
		ТекущееВремя1 = ТекущаяДата1 - НачалоДня(ТекущаяДата1);
		//до 8-00 можно проводить!!! в автомате!
		Если (  (ТекущееВремя1>8*3600 и ТекущееВремя1<16.5*3600) или ТекущееВремя1>18.34*3600 ) тогда
			#Если Клиент тогда
			Сообщить("Проводить новые цены разрешено ТОЛЬКО с 16:30 до 18:20 !!! Расхождения цен у клиентов в 1С и на сайте Terminal.YST.ru требуют установку цен только в вечернее время!", СтатусСообщения.Важное);
		    #КонецЕсли
            Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;	

	
	Информация = "";
	Для Каждого ТекущийТип Из ТипыЦен Цикл
		Если Информация <> "" Тогда
			Информация = Информация + ", ";
		КонецЕсли;
		Информация = Информация + ТекущийТип.ТипЦен.Наименование;
	КонецЦикла;
	
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

Процедура ЗаполнитьЦеныНоменклатурыПоОснованию(Объект,Основание)	
	
	
	стр = Объект.ТипыЦен.добавить();
	ТипЦен = ?(Основание.ТипЦен=Справочники.ТипыЦенНоменклатуры.ПустаяСсылка(),Основание.Склад.ТипЦенРозничнойТорговли,Основание.ТипЦен);
	стр.типцен = ТипЦен;
	Для Каждого ст из Основание.Товары Цикл
		стр = Объект.Товары.Добавить();
		стр.Номенклатура = ст.Номенклатура;
		стр.ХарактеристикаНоменклатуры = ст.ХарактеристикаНоменклатуры;
		стр.Цена = ст.Цена;
		стр.ТипЦен = ТипЦен;
		стр.Валюта = Основание.Организация.ОсновнойБанковскийСчет.ВалютаДенежныхСредств;
		стр.ЕдиницаИзмерения = ст.ЕдиницаИзмерения;
	КонецЦикла;	
	Объект.Дата = Основание.Дата;
	
	//Объект.Записать();
	
КонецПроцедуры 

Процедура ОбработкаУдаленияПроведения(Отказ)
	Если НЕ ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "РазрешитьЦенообразование") Тогда //глТекущийПользователь
		#Если Клиент тогда
			Предупреждение("Операции ценообразования запрещены!");	
		#КонецЕсли
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	
КонецПроцедуры


//Функция ПроверитьГруппыНоменклатуры(КолонкаНоменклатуры, СписокТиповЦен)
//	
//	// Сформируем список групп доступности номенклатуры
//	ЗапросГрупп = новый Запрос("Выбрать Различные ГруппаНоменклатуры из РегистрСведений.ГруппыНоменклатурыДляЦенообразования где Пользователь=&Пользователь И &Дата Между НачалоПериода и КонецПериода и ТипЦены в (&Список)");
//	ЗапросГрупп.УстановитьПараметр("Пользователь",ПараметрыСеанса.ТекущийПользователь); //глТекущийПользователь
//	ЗапросГрупп.УстановитьПараметр("Дата",Дата);
//	ЗапросГрупп.УстановитьПараметр("Список",СписокТиповЦен);
//	КолонкаГрупп = ЗапросГрупп.Выполнить().Выгрузить().ВыгрузитьКолонку("ГруппаНоменклатуры");
//	
//	Если (КолонкаГрупп.Количество()=0) Тогда
//		Возврат КолонкаНоменклатуры;
//	КонецЕсли;
//	
//	Запрос = Новый Запрос;	
//	Запрос.УстановитьПараметр("СписокГрупп",КолонкаГрупп);
//	Запрос.УстановитьПараметр("Номенклатура",КолонкаНоменклатуры);
//	Запрос.Текст = "
//	|	Выбрать 
//	|		Ссылка как Номенклатура
//	|	Из
//	|	Справочник.Номенклатура как Ном
//	|
//	|	Где 
//	|		не (Ном.Ссылка в иерархии (&СписокГрупп))
//	|	И
//	|		Ном.ссылка в (&Номенклатура)";
//	
//	КолонкаВыхода = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура");
//	
//	Если (КолонкаВыхода.Количество()=0) Тогда 
//		Возврат Неопределено;
//	КонецЕсли;	
//	
//	Возврат КолонкаВыхода;
//КонецФункции

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
мИспользоватьХарактеристики     = Константы.ИспользоватьХарактеристикиНоменклатуры.Получить();
