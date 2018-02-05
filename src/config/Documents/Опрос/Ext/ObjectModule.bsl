﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

Процедура Печать(НазваниеМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ТиповаяАнкета" , ТиповаяАнкета);
	Запрос.УстановитьПараметр("Опрос" , Ссылка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка,
	               |	ОпросВопросы.Ответ,
	               |	ОпросВопросы.ТиповойОтвет,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос КАК Вопрос,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос.ТипЗначения,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос.ТипВопроса,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос.КоличествоСтрокТаблицы,
	               |	ТиповыеАнкетыВопросыАнкеты.НомерСтроки КАК НомерСтрокиВАнкете,
	               |	ТиповыеАнкетыВопросыАнкеты.Вопрос.Код КАК КодВопроса,
	               |	ОпросСоставнойОтвет.НомерСтрокиВТаблице,
	               |	ОпросСоставнойОтвет.Ответ КАК ОтветВТаблицу,
	               |	ОпросСоставнойОтвет.ТиповойОтвет КАК ТиповойОтветВТаблицу,
	               |	ВопросыДляАнкетированияКолонкиТаблицы.НомерСтроки КАК НомерКолонки,
	               |	ВопросыДляАнкетированияКолонкиТаблицы.КолонкаТаблицы,
	               |	ОпросВопросы.ТиповойОтвет.Код КАК КодВариантаОтвета,
	               |	ОпросСоставнойОтвет.ТиповойОтвет.Код КАК КодВариантаОтветаНесколько,
	               |	ВариантыОтветовОпросов.Код
	               |ИЗ
	               |	Справочник.ТиповыеАнкеты.ВопросыАнкеты КАК ТиповыеАнкетыВопросыАнкеты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.Вопросы КАК ОпросВопросы
	               |		ПО ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросВопросы.Вопрос
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Опрос.СоставнойОтвет КАК ОпросСоставнойОтвет
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовОпросов КАК ВариантыОтветовОпросов
	               |			ПО ОпросСоставнойОтвет.ТиповойОтвет = ВариантыОтветовОпросов.Ссылка И (ОпросСоставнойОтвет.Ссылка = &Опрос)
	               |			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.ВопросыДляАнкетирования.КолонкиТаблицы КАК ВопросыДляАнкетированияКолонкиТаблицы
	               |			ПО ОпросСоставнойОтвет.Вопрос = ВопросыДляАнкетированияКолонкиТаблицы.КолонкаТаблицы И ОпросСоставнойОтвет.ВопросВладелец = ВопросыДляАнкетированияКолонкиТаблицы.Ссылка
	               |		ПО ТиповыеАнкетыВопросыАнкеты.Вопрос = ОпросСоставнойОтвет.ВопросВладелец И (ОпросСоставнойОтвет.Ссылка = &Опрос)
	               |
	               |ГДЕ
	               |	ОпросВопросы.Ссылка = &Опрос И
	               |	ТиповыеАнкетыВопросыАнкеты.Ссылка = &ТиповаяАнкета
	               |
	               |ИТОГИ ПО
	               |	НомерСтрокиВАнкете,
	               |	Вопрос";
				   
	МакетАнкеты = ТиповаяАнкета.МакетАнкеты.Получить();
	Если МакетАнкеты = Неопределено тогда
		МакетАнкеты = Новый ТабличныйДокумент();
		Если ЗначениеНеЗаполнено(ТиповаяАнкета) тогда
			Сообщить("Документ не может быть распечатан. Выберите типовую анкету.");
			Возврат;
		КонецЕсли;
		МакетАнкеты = ТиповаяАнкета.ПолучитьОбъект().СформироватьМакет(МакетАнкеты);
	ИначеЕсли ТипЗнч(МакетАнкеты) = Тип("ТабличныйДокумент") тогда
		Если МакетАнкеты.ВысотаТаблицы = 0 тогда
		МакетАнкеты = Новый ТабличныйДокумент();
		МакетАнкеты = ТиповаяАнкета.ПолучитьОбъект().СформироватьМакет(МакетАнкеты);
		КонецЕсли;
	КонецЕсли;
	ОбластьНомераДокумента 			= МакетАнкеты.Области["ОбластьНомераДокумента"];
	ОбластьНомераДокумента.Текст 	= "Документ Опрос №"+Номер;

	Результат   	= Запрос.Выполнить();
	ВыборкаЗапросаПоНомерамСтрок 	= Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "НомерСтрокиВАнкете");
	Пока ВыборкаЗапросаПоНомерамСтрок.Следующий() Цикл
		ВыборкаЗапросаПоВопросам = ВыборкаЗапросаПоНомерамСтрок.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "Вопрос");
		Пока ВыборкаЗапросаПоВопросам.Следующий() Цикл
			//Если ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.Дата или
			//	ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.Число или
			//	ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.Строка или
			//	ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.Булево тогда
			//	ИмяОбласти = "ТиповойОтвет" + ВыборкаЗапросаПоВопросам.КодВопроса;
			//	МакетАнкеты.Области[ИмяОбласти].Текст = ВыборкаЗапросаПоВопросам.ТиповойОтвет;
			Если ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов или 
				 ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
				ВыборкаЗапросаПоВариантамОтвета = ВыборкаЗапросаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "");
				Пока ВыборкаЗапросаПоВариантамОтвета.Следующий() Цикл
					Если ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.СправочникСсылка_ВариантыОтветов_Несколько тогда
						ИмяОбласти = "Вопрос" + ВыборкаЗапросаПоВариантамОтвета.КодВопроса + "ВариантОтвета" + ВыборкаЗапросаПоВариантамОтвета.КодВариантаОтветаНесколько;
					Иначе
						ИмяОбласти = "Вопрос" + ВыборкаЗапросаПоВариантамОтвета.КодВопроса + "ВариантОтвета" + ВыборкаЗапросаПоВариантамОтвета.КодВариантаОтвета;
					КонецЕсли;
					Попытка
					ОбластьОтвета=МакетАнкеты.Области[ИмяОбласти];
					ОбластьЧекБокса = МакетАнкеты.Область("R"+ОбластьОтвета.Верх+"C"+(ОбластьОтвета.Лево));
					ОбластьЧекБокса.Текст = "R";
					ОбластьРазвернутогоОтвета = МакетАнкеты.Область("R"+ОбластьОтвета.Верх+"C"+(ОбластьОтвета.Право+1));
					ОбластьРазвернутогоОтвета.Текст = ОбластьРазвернутогоОтвета.Текст +"   "+ ВыборкаЗапросаПоВариантамОтвета.Ответ + ВыборкаЗапросаПоВариантамОтвета.ОтветВТаблицу;
					Исключение
				    КонецПопытки;
				КонецЦикла;
			ИначеЕсли ВыборкаЗапросаПоВопросам.ВопросТипВопроса = Перечисления.ТипВопросаАнкеты.Табличный тогда
				ВыборкаЗапросаПоОтветам = ВыборкаЗапросаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "");
				Пока ВыборкаЗапросаПоОтветам.Следующий() Цикл
					Если ВыборкаЗапросаПоОтветам.НомерКолонки = NULL тогда
						Продолжить;
					КонецЕсли;
					ИмяОбласти = "Вопрос" + ВыборкаЗапросаПоОтветам.КодВопроса+"ОтветТаблицы"+ВыборкаЗапросаПоОтветам.НомерКолонки+"Строка"+ВыборкаЗапросаПоОтветам.НомерСтрокиВТаблице;
					Попытка
						//МакетАнкеты.Области[ИмяОбласти].Текст = ВыборкаЗапросаПоОтветам.ТиповойОтветВТаблицу;
						МакетАнкеты.Параметры[ИмяОбласти] = ВыборкаЗапросаПоОтветам.ТиповойОтветВТаблицу;;
					Исключение
						Сообщить("Набор вопросов в анкете и в документе ""Опрос"" различны! Не найден вопрос с кодом " + ВыборкаЗапросаПоОтветам.КодВопроса);
					КонецПопытки;
				КонецЦикла;
			Иначе
				ВыборкаЗапросаПоОтветам = ВыборкаЗапросаПоВопросам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией, "");
				Пока ВыборкаЗапросаПоОтветам.Следующий() Цикл
					ИмяОбласти = "ТиповойОтвет" + ВыборкаЗапросаПоОтветам.КодВопроса;
					Попытка
						//МакетАнкеты.Области[ИмяОбласти].Текст = СтрЗаменить(""+ВыборкаЗапросаПоОтветам.ТиповойОтвет, "¤", ",");
						ТиповойОтвет = ?(ВыборкаЗапросаПоОтветам.ТиповойОтвет = Истина, "Да", ВыборкаЗапросаПоОтветам.ТиповойОтвет);
						ТиповойОтвет = ?(ВыборкаЗапросаПоОтветам.ТиповойОтвет = Ложь, "Нет", ВыборкаЗапросаПоОтветам.ТиповойОтвет);
						МакетАнкеты.Параметры[ИмяОбласти] = СтрЗаменить(""+ТиповойОтвет, "¤", ",");
					Исключение
						Сообщить("Набор вопросов в анкете и в документе ""Опрос"" различны! Не найден вопрос с кодом " + ВыборкаЗапросаПоОтветам.КодВопроса);
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	МакетПечати = Новый ТабличныйДокумент();
	Если МакетАнкеты = Неопределено тогда
		МакетАнкеты = Новый ТабличныйДокумент();
		Если ЗначениеНеЗаполнено(ТиповаяАнкета) тогда
			Сообщить("Документ не может быть распечатан. Выберите типовую анкету.");
			Возврат;
		КонецЕсли;
		МакетАнкеты = ТиповаяАнкета.ПолучитьОбъект().СформироватьМакет(МакетАнкеты);
	КонецЕсли;
	МакетПечати.Вывести(МакетАнкеты);
	НапечататьДокумент(МакетПечати, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект,Метаданные().Синоним));
	
КонецПроцедуры

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СоответствиеМакетов = Новый Соответствие();
	
	СоответствиеМакетов.Вставить("Печать", "Печать");

	Возврат СоответствиеМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

// Назначает тип ответа в зависимости от вопроса.
//
// Параметры: 
//  Вопрос - Собственно, сам вопрос
//
// Возвращаемое значение:
//  нет
//
Процедура НазначитьТипОтвета(Вопрос) Экспорт;
	
	Вопрос.ТиповойОтвет = Вопрос.Вопрос.ТипЗначения.ПривестиЗначение();
	
КонецПроцедуры

// Загружает вопросы по образцу указанной анкеты.
//
// Параметры: 
//  ОбразецЗаполнения - анкета-образец
//
// Возвращаемое значение:
//  нет
//
Процедура ЗаполнитьВопросыАнкеты(ОбразецЗаполнения) Экспорт
	
	Вопросы.Загрузить(ОбразецЗаполнения.ВопросыАнкеты.Выгрузить());
	
	Для каждого Вопрос Из Вопросы Цикл
		
		Если ЗначениеНеЗаполнено(Вопрос.ТиповойОтвет) тогда
			НазначитьТипОтвета(Вопрос);
		Конецесли;
		
	КонецЦикла; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.ТиповыеАнкеты") тогда
		ТиповаяАнкета = Основание;
		ЗаполнитьВопросыАнкеты(Основание);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	| Анкета.ОпрашиваемоеЛицо,
	| Анкета.Дата,
	| Анкета.ТиповаяАнкета,
	| Анкета.Ссылка
	|ИЗ
	| Документ.Опрос КАК Анкета
	|
	|ГДЕ
	| Анкета.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// Формирует запрос по вопросам анкеты
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоАнкеты(Режим)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	| ВопросыИзОпроса.Вопрос,
	| ВЫБОР КОГДА ВопросыИзОпроса.ВсегоОтветов > 0 И НЕ(ВопросыИзОпроса.Вопрос.Предопределенный) ТОГДА ВопросыИзОпроса.ТиповойОтвет КОГДА ВопросыИзОпроса.Вопрос.Предопределенный И ВопросыИзОпроса.Ответ = """" ТОГДА ВопросыИзОпроса.ТиповойОтвет ИНАЧЕ ВопросыИзОпроса.Ответ КОНЕЦ КАК ТиповойОтвет,
	| ВЫБОР КОГДА НЕ(ВопросыИзОпроса.ВсегоОтветов > 0 И НЕ(ВопросыИзОпроса.Вопрос.Предопределенный)) ТОГДА ВопросыИзОпроса.Ответ КОГДА НЕ (ВопросыИзОпроса.Вопрос.Предопределенный И ВопросыИзОпроса.Ответ = """") ТОГДА ВопросыИзОпроса.Ответ ИНАЧЕ ВопросыИзОпроса.ТиповойОтвет КОНЕЦ КАК Ответ,
	| ВопросыИзОпроса.НомерСтроки,
	| ВопросыИзОпроса.ВсегоОтветов
	|ИЗ
	| (ВЫБРАТЬ
	|  ВопросыАнкеты.Вопрос КАК Вопрос,
	|  ВопросыАнкеты.Ответ КАК Ответ,
	|  ВопросыАнкеты.ТиповойОтвет КАК ТиповойОтвет,
	|  ВопросыАнкеты.НомерСтроки КАК НомерСтроки,
	|  КОЛИЧЕСТВО(ВопросыДляАнкетированияВариантыОтветов.Ссылка) КАК ВсегоОтветов
	| ИЗ
	|  Документ.Опрос.Вопросы КАК ВопросыАнкеты
	|   ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовОпросов КАК ВопросыДляАнкетированияВариантыОтветов
	|   ПО ВопросыАнкеты.Вопрос = ВопросыДляАнкетированияВариантыОтветов.Владелец
	| 
	| ГДЕ
	|  ВопросыАнкеты.Ссылка = &Ссылка) КАК ВопросыИзОпроса";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

// По строке выборки результата запроса по документу, которая соответствует 
// строке ТЧ документа, формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа
//  ВыборкаПоАнкеты         - спозиционированная на определеной строке выборка 
//                            из результата запроса по вопросам документа
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаШапкиДокумента, ВыборкаПоАнкеты)
	
	Движение = Движения.РезультатыАнкетирования.Добавить();
	
	// Свойства
	Движение.Период        = ВыборкаШапкиДокумента.Дата;
	
	
	// Измерения
	Движение.ФизЛицо       = ВыборкаШапкиДокумента.ОпрашиваемоеЛицо;
	Движение.Вопрос        = ВыборкаПоАнкеты.Вопрос;
	Движение.ТиповаяАнкета = ВыборкаШапкиДокумента.ТиповаяАнкета;
	
	// Ресурсы
	Движение.ТиповойОтвет  = ВыборкаПоАнкеты.ТиповойОтвет;
	Движение.Ответ         = ВыборкаПоАнкеты.Ответ;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

// Процедура осуществляет проверку реквизитов шапки документа
//
// Параметры: 
// ВыборкаПоШапкеДокумента - выборка реквизитов шапки документа
// Отказ     - Истина - отказ проведения операции, Ложь - продолжение
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ)
	Если НЕ ТиповаяАнкета.ЗагружатьОбъекты тогда 
		// если загружать объекты не надо, то опрашиваемое лицо должно быть указано обязательно
		// Опрашиваемое лицо
		Если ЗначениеНеЗаполнено(ВыборкаПоШапкеДокумента.ОпрашиваемоеЛицо) Тогда
			ОшибкаПриПроведении("Не указано опрашиваемое лицо!", Отказ);
		КонецЕсли;
	КонецЕсли;
	Если ТиповаяАнкета.Пустая() Тогда
		ОшибкаПриПроведении("Не выбрана анкета - опрос не заполнен!", Отказ);
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеШапки

// Процедура осуществляет проверку строк табличной части
//
// Параметры: 
// ВыборкаПоАнкеты  - выборка реквизитов ТЧ документа
// Отказ    - Истина - отказ проведения операции, Ложь - продолжение
//
Процедура ПроверитьЗаполнениеСтрокиАнкеты(ВыборкаПоАнкеты, Отказ)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоАнкеты.НомерСтроки) +
	""" табл. части ""Вопросы и ответы"": ";
	
	// Вопрос
	Если ЗначениеНеЗаполнено(ВыборкаПоАнкеты.Вопрос) Тогда
		ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + " не указан вопрос!", Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиАнкеты

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

