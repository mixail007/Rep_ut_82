﻿// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми
Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)
Перем мСтрокаРеквизитыНалУчета Экспорт; // (Регл)

Перем мУчетнаяПолитика;                 // (Общ)

Перем мВалютаРегламентированногоУчета Экспорт;

//БАЛАНС (04.12.2007)                       
//
Перем мПроведениеИзФормы Экспорт; 

#Если Клиент Тогда

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СписокМакетов = Новый СписокЗначений;

	СписокМакетов.Добавить("Накладная", "Требование-накладная");
	СписокМакетов.Добавить("М11", "Форма M-11");

	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

// Функция формирует печатную форму М-11
//
Функция ПечатьМ11()
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	Если ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул Тогда
		ТоварКод = "Артикул";
	Иначе
		ТоварКод = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номер 	КАК НомерДокумента,
	|	Дата	КАК ДатаДокумента,
	|	Дата	КАК ДатаСоставления,
	|	Организация,
	|	Склад,
	|	Подразделение КАК Подразделение
	|ИЗ
	|	Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|
	|ГДЕ
	|	ТребованиеНакладная.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Номенклатура                                  КАК Номенклатура,
	|	ВЫРАЗИТЬ(ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК МатериалНаименование,
	|	ВложенныйЗапрос.Номенклатура." + ТоварКод + "                 КАК НоменклатурныйНомер,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление                КАК ЕдиницаИзмеренияНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.ЕдиницаПоКлассификатору.Код  КАК ЕдиницаИзмеренияКод,
	|	ВложенныйЗапрос.Характеристика       КАК Характеристика,
	|	ВложенныйЗапрос.Серия                КАК Серия,
	|	ВложенныйЗапрос.Количество           КАК Количество,
	|	ВложенныйЗапрос.НомерСтроки          КАК НомерСтроки
	|ИЗ 
	|	(
	|	ВЫБРАТЬ
	|		Номенклатура,
	|		ЕдиницаИзмерения,
	|		ХарактеристикаНоменклатуры	КАК Характеристика,
	|		СерияНоменклатуры           КАК Серия,
	|		СУММА(Количество)           КАК Количество,
	|		МИНИМУМ(НомерСтроки) 		КАК НомерСтроки
	|	ИЗ
	|		Документ.ТребованиеНакладная.Материалы КАК ТребованиеНакладная
	|	ГДЕ
	|		ТребованиеНакладная.Ссылка = &ТекущийДокумент
	|
	|	СГРУППИРОВАТЬ ПО
	|		Номенклатура,
	|		ЕдиницаИзмерения,
	|		ХарактеристикаНоменклатуры,
	|		СерияНоменклатуры
	|
	|	) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО НомерСтроки ВОЗР
	|";

	ЗапросПоНоменклатуре = Запрос.Выполнить();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТребованиеНакладная_М11";
	
	// Вывод заголовка
	Макет = ПолучитьМакет("М11");
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.Заголовок     = "ТРЕБОВАНИЕ-НАКЛАДНАЯ № " + Строка(Шапка.НомерДокумента);
	Область.Параметры.Заполнить(Шапка);
	
	СведенияОбОрганизации = СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);

	Область.Параметры.ПредставлениеОрганизации = ОписаниеОрганизации(СведенияОбОрганизации);
	Область.Параметры.ПредставлениеПодразделения = Шапка.Подразделение;
	
	ТабДокумент.Вывести(Область);
	
	ВыборкаПоСтрокам = ЗапросПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСтрокам.Следующий() Цикл

		Область = Макет.ПолучитьОбласть("Строка");
		Область.Параметры.Заполнить(ВыборкаПоСтрокам);
		Область.Параметры.МатериалНаименование = СокрЛП(ВыборкаПоСтрокам.МатериалНаименование) + ПредставлениеСерий(ВыборкаПоСтрокам);
		
		ТабДокумент.Вывести(Область);

	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("Подвал");
	ТабДокумент.Вывести(Область);
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьМ11()

// Функция формирует печатную форму документа
//
Функция ПечатьТребованиеНакладная()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);
	Запрос.Текст ="
	|ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	Организация,
	|	Склад,
	|	Контрагент,
	|	Подразделение КАК Подразделение
	|ИЗ
	|	Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|
	|ГДЕ
	|	ТребованиеНакладная.Ссылка = &ТекущийДокумент";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НомерСтроки КАК НомПП,
	|	Номенклатура.Код КАК Код,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК Строка(1000)) КАК Имя,
	|	ХарактеристикаНоменклатуры       	 КАК Характеристика,
	|	СерияНоменклатуры                	 КАК Серия,
	|	Номенклатура.ЕдиницаХраненияОстатков КАК ЕдИзмМест,
	|	ЕдиницаИзмерения КАК ЕдИзм,
	|	Количество КАК Количество,
	|	КоличествоМест КАК КоличествоМест
	|
	|ИЗ
	|	Документ.ТребованиеНакладная.Материалы КАК ТребованиеНакладная
	|
	|ГДЕ
	|	ТребованиеНакладная.Ссылка = &ТекущийДокумент
	|";

	ЗапросПоНоменклатуре = Запрос.Выполнить();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТребованиеНакладная_ТН";
	
	// Вывод заголовка
	Макет = ПолучитьМакет("ТребованиеНакладная");
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(Ссылка, "Требование-накладная");
	Область.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(Область);

	ФлагПечатиМест = (Материалы.Итог("КоличествоМест") > 0);
	Область        = Макет.ПолучитьОбласть("ШапкаТаблицы" + ?(ФлагПечатиМест, "Мест", ""));
	ТабДокумент.Вывести(Область);

	Область          = Макет.ПолучитьОбласть("Строка" + ?(ФлагПечатиМест, "Мест", ""));
	ВыборкаПоСтрокам = ЗапросПоНоменклатуре.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСтрокам.Следующий() Цикл

		Область.Параметры.Заполнить(ВыборкаПоСтрокам);
		Область.Параметры.Имя = СокрЛП(ВыборкаПоСтрокам.Имя) + ПредставлениеСерий(ВыборкаПоСтрокам);
		ТабДокумент.Вывести(Область);

	КонецЦикла;

	// Вывод подвала
	Область = Макет.ПолучитьОбласть("Подписи");
	ТабДокумент.Вывести(Область);

	Возврат ТабДокумент;

КонецФункции // ПечатьТребованиеНакладная()

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

	// Получить экземпляр документа на печать
	Если      ИмяМакета = "Накладная" Тогда
		ТабДокумент = ПечатьТребованиеНакладная();
	ИначеЕсли ИмяМакета = "М11" Тогда
		ТабДокумент = ПечатьМ11();
		
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
	
	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер,
		СформироватьЗаголовокДокумента(Ссылка));
	
КонецПроцедуры // Печать()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Функция возращает качество для номенклатуры. Для услуг возвращается пустое значение
//
//		Параметры: Номенклатура - элемент номенклатуры
//
//		Возврат: качество для элемента номенклатуры
//
Функция ПолучитьКачество(Номенклатура) Экспорт

	Если ЗначениеНеЗаполнено(Номенклатура) ИЛИ Номенклатура.Услуга Тогда
		Возврат Справочники.Качество.ПустаяСсылка();

	Иначе
		Возврат Справочники.Качество.Новый;

	КонецЕсли;

КонецФункции // ПолучитьКачество()

Процедура ЗаполнитьНоменклатурнуюГруппуИСтатьюЗатратВСтрокеТабличногоПоля(СтрокаТабличнойЧасти) Экспорт

	Если НЕ ЗначениеНеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) Тогда

		СтрокаТабличнойЧасти.СтатьяЗатрат         = СтрокаТабличнойЧасти.Номенклатура.СтатьяЗатрат;
		СтрокаТабличнойЧасти.НоменклатурнаяГруппа = СтрокаТабличнойЧасти.Номенклатура.НоменклатурнаяГруппаЗатрат;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьНоменклатурнуюГруппуИСтатьюЗатратВСтрокеТабличногоПоля()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для определенного вида учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета() Экспорт

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр();

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для управленческого учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()
	
	мСтрокаРеквизитыУпрУчета = "Подразделение, НадписьПодразделение";
	
КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

// Дополняет список обязательных параметров шапки
// упр. параметрами
Процедура ДополнитьОбязательныеРеквизитыШапкиУпр(Реквизиты)
	Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты), "", ", ")
			  + "Подразделение";
КонецПроцедуры

// Проверяет правильность заполнения упр. реквизитов шапки
Процедура ПроверитьЗаполнениеШапкиУпр(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если СтруктураШапкиДокумента.ВидСклада = Перечисления.ВидыСкладов.НеавтоматизированнаяТорговаяТочка Тогда
		ОшибкаПриПроведении("Документ нельзя оформлять на неавтоматизированную торговую точку!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация, Склад";
	ДополнитьОбязательныеРеквизитыШапкиУпр(ОбязательныеРеквизитыШапки);

	СтруктураОбязательныхПолей = 
	Новый Структура(ОбязательныеРеквизитыШапки);

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	ПроверитьЗаполнениеШапкиУпр(СтруктураШапкиДокумента, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитовТЧ(Отказ, Заголовок) Экспорт

	РеквизитыТабМат = "Номенклатура, ЕдиницаИзмерения, Количество, СтатьяЗатрат, Качество, СпособСписанияОстаткаТоваров";

	// Здесь услуг быть не должно.
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Номенклатура", "Номенклатура");
	СтруктураПолей.Вставить("Услуга",     	"Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор",     	"Номенклатура.Набор");
	ТаблицаМатериалов = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Материалы", СтруктураПолей).Выгрузить();

	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Материалы", Новый Структура(РеквизитыТабМат), Отказ, Заголовок);

	// Проверим что нет услуг
	ПроверитьЧтоНетУслуг(ЭтотОбъект, "Материалы", ТаблицаМатериалов, Отказ, Заголовок);
	
	// Здесь наборов быть не должно.
	ПроверитьЧтоНетНаборов(ЭтотОбъект, "Материалы", ТаблицаМатериалов, Отказ, Заголовок);

КонецПроцедуры // ПроверкаРеквизитов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблиица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ДВИЖЕНИЙ ПО РЕГИСТРАМ

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	
	// Проводить по партиям сразу нужно если установлен параметр
	// учетной политики СписыватьПартииПриПроведенииДокументов.
	УчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата);
	
	Если УчетнаяПолитика.СписыватьПартииПриПроведенииДокументов Тогда
		
		//Адиянов<<< Начало СтатьяЗатратУпр
		//{{ДвижениеПартийТоваров(Ссылка, Движения.СписанныеТовары.Выгрузить());}} Оригинальная строка код
		ТаблицаДвижений = Движения.СписанныеТовары.Выгрузить();
		ДополнитьТаблицуДвижений(ТаблицаДвижений);
		ДвижениеПартийТоваров(Ссылка, ТаблицаДвижений);
		//Адиянов>>> Конец СтатьяЗатратУпр
		
		Если ОтражатьВУправленческомУчете Тогда
			ЗаписьРегистрации = ПринадлежностьПоследовательностям.ПартионныйУчет.Добавить();
			ЗаписьРегистрации.Период = Дата;
			ЗаписьРегистрации.Регистратор = Ссылка;
		КонецЕсли;
		
	Иначе
		
		// В неоперативном режиме границы последовательностей сдвигаются назад, если они позже документа.
		Если РежимПроведения = РежимПроведенияДокумента.Неоперативный Тогда
			СдвигГраницыПоследовательностиПартионногоУчетаНазад(Дата, Ссылка, Организация, ОтражатьВУправленческомУчете, ОтражатьВБухгалтерскомУчете, ОтражатьВНалоговомУчете)
		КонецЕсли;
		
	КонецЕсли;


КонецПроцедуры // ДвиженияПоРегистрам()


//Дополним таблицу для движений колонкой "СтатьяЗатратУПР" для движения по регистру "Затраты"
Процедура ДополнитьТаблицуДвижений(ТаблицаДвижений)
	
	ТаблицаДвижений.Колонки.Добавить("СтатьяЗатратУпр");
	СтатьиЗатратУПРПустаяСсылка = Справочники.СтатьиЗатратУПР.ПустаяСсылка();
	Для Каждого Стр Из ТаблицаДвижений Цикл
		ПараметрыОтбора = Новый Структура("Номенклатура,Качество,Количество,СтатьяЗатрат", Стр.Номенклатура,Стр.Качество,Стр.Количество,Стр.СтатьяЗатрат);
		
		НайденныеСтроки = Материалы.НайтиСтроки(ПараметрыОтбора); 
		Если НайденныеСтроки.Количество() > 1 
			Или НайденныеСтроки.Количество() = 0  тогда
			//Найдено больше одной строки или не найдено ни одной строки в документе.
			//Так быть не должно.Пропускаем строку.
			Стр.СтатьяЗатратУпр = СтатьиЗатратУПРПустаяСсылка;
			Продолжить;
		ИначеЕсли НайденныеСтроки.Количество() = 1 Тогда 
			Стр.СтатьяЗатратУпр = НайденныеСтроки[0].СтатьяЗатратУПР;
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры


// Формирование движений по регистрам по управленческому учету.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)
	
	Если Не СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		Возврат;
	КонецЕсли;
	
	// ТОВАРЫ ПО РЕГИСТРУ ТоварыНаСкладах.
	НаборДвижений = Движения.ТоварыНаСкладах;

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	// Заполним таблицу движений.
	ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

	// Недостающие поля (качество заполнили в "ПередЗаписью" документа).
	//
	
	//Плотников 02.03.2017 
	для каждого стр из ТаблицаДвижений Цикл
		Если ЗначениеНеЗаполнено(стр.склад) Тогда
			стр.склад = Склад;
		КонецЕсли;
	КонецЦикла;
	//ТаблицаДвижений.ЗаполнитьЗначения(Склад,						"Склад");   //Было
	
	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

	// Проверка осатков при оперативном проведении.
	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Материалы", СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
		
	Если Не Отказ Тогда
		Движения.ТоварыНаСкладах.ВыполнитьРасход();
	КонецЕсли;
	
	// Если есть списание из резерва, то надо списать резерв
	ТаблицаПоТоварамИзРезерва = ТаблицаПоТоварам.Скопировать();
	Сч = 0;
	Пока Сч < ТаблицаПоТоварамИзРезерва.Количество() Цикл
		СтрокаТаблицы = ТаблицаПоТоварамИзРезерва.Получить(Сч);
		Если СтрокаТаблицы.СпособСписанияОстаткаТоваров <> Перечисления.СпособыСписанияОстаткаТоваров.ИзРезерва Тогда
			 ТаблицаПоТоварамИзРезерва.Удалить(СтрокаТаблицы);
		Иначе 
			Сч = Сч + 1;
		КонецЕсли; 
	КонецЦикла;

	Если ТаблицаПоТоварамИзРезерва.Количество() > 0 Тогда
		
		НаборДвижений = Движения.ТоварыВРезервеНаСкладах;

		// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
		ТаблицаДвижений = НаборДвижений.Выгрузить();

		// Заполним таблицу движений.
		ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварамИзРезерва, ТаблицаДвижений);

		// Недостающие поля.
		
		//Плотников 02.03.2017 
		для каждого стр из ТаблицаДвижений Цикл
			Если ЗначениеНеЗаполнено(стр.склад) Тогда
				стр.склад = Склад;
			КонецЕсли;
		КонецЦикла;
		//ТаблицаДвижений.ЗаполнитьЗначения(Склад, "Склад");

		НаборДвижений.мПериод            = Дата;
		НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

		// Проверка осатков при оперативном проведении.
		Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
			НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Материалы", СтруктураШапкиДокумента, Отказ, Заголовок);
		КонецЕсли;
		
		Если Не Отказ Тогда
			Движения.ТоварыВРезервеНаСкладах.ВыполнитьРасход();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТоварыАдресноеХранение.Количество() > 0 Тогда //+++ вот так просто...
		яштАдресноеХранение.ДвиженияПоРегиструТоварыАдресноеХранение(Движения.ТоварыАдресноеХранение, ЭтотОбъект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Заказ) и СписаниеНаЗатраты Тогда    //Плотников, 02.03.2017
		
		Запрос = Новый Запрос;		
		Запрос.Текст = "ВЫБРАТЬ
		               |	Перемещение.Номенклатура,
		               |	Перемещение.Количество,
		               |	ЕСТЬNULL(ЗаказПокупателя.Цена, 0) КАК Цена,
		               |	0 КАК Сумма,
		               |	0 КАК ПроцентСкидкиНаценки,
		               |	0 КАК ПроцентАвтоматическихСкидок,
		               |	0 КАК ЕдиницаИзмерения
		               |ИЗ
		               |	(ВЫБРАТЬ
		               |		ТребованиеНакладнаяМатериалы.Номенклатура КАК Номенклатура,
		               |		СУММА(ТребованиеНакладнаяМатериалы.Количество) КАК Количество
		               |	ИЗ
		               |		Документ.ТребованиеНакладная.Материалы КАК ТребованиеНакладнаяМатериалы
		               |	ГДЕ
		               |		ТребованиеНакладнаяМатериалы.Ссылка = &Ссылка
		               |	
		               |	СГРУППИРОВАТЬ ПО
		               |		ТребованиеНакладнаяМатериалы.Номенклатура) КАК Перемещение
		               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		               |			ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
		               |			ЗаказПокупателяТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		               |			ЗаказПокупателяТовары.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
		               |			ЗаказПокупателяТовары.Количество КАК Количество,
		               |			ЗаказПокупателяТовары.Цена КАК Цена,
		               |			ЗаказПокупателяТовары.Сумма КАК Сумма,
		               |			ЗаказПокупателяТовары.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
		               |			ЗаказПокупателяТовары.УсловиеАвтоматическойСкидки КАК УсловиеАвтоматическойСкидки,
		               |			ЗаказПокупателяТовары.ЗначениеУсловияАвтоматическойСкидки КАК ЗначениеУсловияАвтоматическойСкидки
		               |		ИЗ
		               |			Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
		               |		ГДЕ
		               |			ЗаказПокупателяТовары.Ссылка = &Заказ) КАК ЗаказПокупателя
		               |		ПО Перемещение.Номенклатура = ЗаказПокупателя.Номенклатура" ;
		
		Запрос.УстановитьПараметр("Ссылка",Ссылка );
		Запрос.УстановитьПараметр("Заказ",Заказ );
		Результат=Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Выборка =Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				Движ = Движения.ЗаказыПокупателей.Добавить();
				Движ.ВидДвижения= ВидДвиженияНакопления.Расход;
				Движ.Период= Ссылка.Дата;
				Движ.Регистратор= Ссылка;
				Движ.ДоговорКонтрагента= Заказ.ДоговорКонтрагента;
				Движ.ЗаказПокупателя= Заказ;
				Движ.ЕдиницаИзмерения= Выборка.Номенклатура.ЕдиницаХраненияОстатков;
				Движ.СтатусПартии	=  Перечисления.СтатусыПартийТоваров.Купленный;
				Движ.Номенклатура	=  Выборка.Номенклатура;
				Движ.ХарактеристикаНоменклатуры	=  Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
				Движ.Цена = Выборка.Цена;
				// -------------------				
				Движ.Количество = Выборка.Количество;
				Движ.СуммаВзаиморасчетов = Выборка.Сумма;
				Движ.СуммаУпр = Выборка.Сумма;
			КонецЦикла;	
			
		КонецЕсли;
		
		
	КонецЕсли;


	ДвиженияПоРегиструТоварыОрганизаций(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	
	ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ИмяТабЧасти",     "Материалы");
	ДопПараметры.Вставить("СтатусПартии",    Перечисления.СтатусыПартийТоваров.Купленный);
	ДопПараметры.Вставить("РежимПроведения", РежимПроведения);
	ДопПараметры.Вставить("ИмяРеквизитаЗаказ", "Заказ");
	ДопПараметры.Вставить("ЗаказВШапке",       Ложь);
	
	ДвижениеПоВнутреннимЗаказам( ЭтотОбъект, ТаблицаПоТоварам, ДопПараметры, Отказ, Заголовок);

КонецПроцедуры // ДвиженияПоРегистрамУпр()

// Формирование движений по регистру "Товары организаций".
//
Процедура ДвиженияПоРегиструТоварыОрганизаций(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	// ТОВАРЫ ПО РЕГИСТРУ ТоварыОрганизаций.
	НаборДвижений = Движения.ТоварыОрганизаций;

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	// Заполним таблицу движений.
	ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

	// Недостающие поля (качество заполнили в "ПередЗаписью" документа).
	ТаблицаДвижений.ЗаполнитьЗначения(Организация, "Организация");
	ТаблицаДвижений.ЗаполнитьЗначения(Неопределено,"Комиссионер");

	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

	// Проверка осатков при оперативном проведении.
	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Материалы", СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;

	Если Не Отказ Тогда
		Движения.ТоварыОрганизаций.ВыполнитьРасход();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегиструТоварыОрганизаций()

// Заполнение реквизитов управленческого учета регистра СписанныеТовары.
//
Процедура ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоТоварам)

	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.Купленный, "ДопустимыйСтатус1");
	ТаблицаДвижений.ЗаполнитьЗначения(ОтражатьВУправленческомУчете,"ОтражатьВУправленческомУчете");

КонецПроцедуры // ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр()

// Формирование движений по регистру СписанныеТовары.
//
Процедура ДвиженияПоРегиструСписанныеТовары(СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.
	НаборДвижений = Движения.СписанныеТовары;

	// Получим таблицу значений, совпадающую со струкутрой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();

	// Заполним таблицу движений.

	ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;

	// Если ПУ по складам
	Если СтруктураШапкиДокумента.ВестиПартионныйУчетПоСкладам Тогда 	
		//Плотников 02.03.2017 
		для каждого стр из ТаблицаДвижений Цикл
			Если ЗначениеНеЗаполнено(стр.склад) Тогда
				стр.склад = Склад;
			КонецЕсли;
		КонецЦикла;
		//ТаблицаДвижений.ЗаполнитьЗначения(Склад, "Склад");
	КонецЕсли;

	ТаблицаДвижений.ЗаполнитьЗначения(Дата,   "Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка, "Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииТоваров.СписаниеНаЗатраты, "КодОперацииПартииТоваров");
	//ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Подразделение, "Подразделение");

	ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоТоварам);

	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегиструСписанныеТовары()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаПроведения"
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета();
	
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = СформироватьДеревоПолейЗапросаПоШапке();
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Склад", 			"ВидСклада", 					"ВидСклада");
	ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика", 	"ВестиПартионныйУчетПоСкладам", "ВестиПартионныйУчетПоСкладам");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	яштАдресноеХранение.ПроверитьЗаполнениеТабЧастиТоварыАдресноеХранение(ЭтотОбъект.Ссылка,Отказ);       //плотников 02.03.2017

	ПроверкаРеквизитовТЧ(Отказ, Заголовок);
	
	мУчетнаяПолитика = ПолучитьПараметрыУчетнойПолитики(КонецМесяца(Дата), Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Получим необходимые данные для проведения и проверки заполнения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"              , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Количество"                , "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("НомерСтроки"               , "НомерСтроки");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"         , "СерияНоменклатуры");
	СтруктураПолей.Вставить("СпособСписанияОстаткаТоваров", "СпособСписанияОстаткаТоваров");
	СтруктураПолей.Вставить("СтатьяЗатрат"				, "СтатьяЗатрат");
	СтруктураПолей.Вставить("НоменклатурнаяГруппа"		, "НоменклатурнаяГруппа");
	СтруктураПолей.Вставить("Заказ"						, "Заказ");
	СтруктураПолей.Вставить("ДокументРезерва"			, "Заказ");
	СтруктураПолей.Вставить("ЗаказСписания"				, "Заказ");
	СтруктураПолей.Вставить("Качество"					, "Качество");
	//Плотников 01.03.2017
	СтруктураПолей.Вставить("Склад"					    , "Склад");
	//Плотников 01.03.2017
	//Адиянов<<< Начало СтатьяЗатратУпр
	СтруктураПолей.Вставить("СтатьяЗатратУпр"			, "СтатьяЗатратУпр");
	СтруктураПолей.Вставить("Подразделение"				, "Подразделение");
	//Адиянов>>> Конец СтатьяЗатратУпр
	
	РезультатЗапросаПоТоварам = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Материалы", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);
	
	// Движения по документу.
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры	// ОбработкаПроведения()

// Заполнение на основании ПоступлениеТоваровУслуг, реквизиты шапки, упр.
//
Процедура ОбработкаЗаполненияПоПоступлениюТоваровУслугШапкаУпр(Основание)
	Подразделение = Основание.Подразделение;
КонецПроцедуры

// Процедура - обработчик события "ОбработкаЗаполнения"
//
Процедура ОбработкаЗаполнения(Основание)
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			
		// Заполнение шапки
		Организация                  = Основание.Организация;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		ОтражатьВНалоговомУчете      = Основание.ОтражатьВНалоговомУчете;
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		Склад                        = Основание.СкладОрдер;
		ОбработкаЗаполненияПоПоступлениюТоваровУслугШапкаУпр(Основание);
		
		Для Каждого ТекСтрокаТовары Из Основание.Товары Цикл
			
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.Количество                 = ТекСтрокаТовары.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаТовары.КоличествоМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.Номенклатура               = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.СерияНоменклатуры          = ТекСтрокаТовары.СерияНоменклатуры;
			НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаТовары.ХарактеристикаНоменклатуры;
			НоваяСтрока.СтатьяЗатрат               = ТекСтрокаТовары.Номенклатура.СтатьяЗатрат;
			НоваяСтрока.Качество                   = Справочники.Качество.Новый;
			
			Если Не ЗначениеНеЗаполнено(Основание.Сделка)
		   	   И Не Основание.Сделка.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
				НоваяСтрока.Заказ = Основание.Сделка;
			КонецЕсли;
			
			ЗаполнитьСпособСписанияОстаткаТоваровТабЧасти(НоваяСтрока, ЭтотОбъект);
			ЗаполнитьНоменклатурнуюГруппуИСтатьюЗатратВСтрокеТабличногоПоля(НоваяСтрока);

		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
	
		// Заполнение шапки
		Организация                  = Основание.Организация;
		ОтражатьВБухгалтерскомУчете  = Истина;
		ОтражатьВНалоговомУчете      = Истина;
		ОтражатьВУправленческомУчете = Истина;
		Заказ                        = Основание;
		СписаниеМПЗ                  = Истина;
		
		Подразделение = Основание.Подразделение;
		
		Для Каждого ТекСтрокаТовары Из Основание.Товары Цикл
			
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаТовары.ЕдиницаИзмерения;
			НоваяСтрока.Количество                 = ТекСтрокаТовары.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаТовары.КоличествоМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаТовары.Коэффициент;
			НоваяСтрока.Номенклатура               = ТекСтрокаТовары.Номенклатура;
			НоваяСтрока.НоменклатурнаяГруппа       = ТекСтрокаТовары.Номенклатура.НоменклатурнаяГруппа;
			НоваяСтрока.СпособСписанияОстаткаТоваров          = Перечисления.СпособыСписанияОстаткаТоваров.СоСклада;
			//НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаТовары.ХарактеристикаНоменклатуры;
			НоваяСтрока.СтатьяЗатрат               = Справочники.СтатьиЗатрат.НайтиПоКоду("А0187");
			НоваяСтрока.Качество                   = Справочники.Качество.Новый;
			
			//Если Не ЗначениеНеЗаполнено(Основание.Сделка)
			//	 И Не Основание.Сделка.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
			//НоваяСтрока.Заказ = Основание;
			//КонецЕсли;
			
			//ЗаполнитьСпособСписанияОстаткаТоваровТабЧасти(НоваяСтрока, ЭтотОбъект);
			//ЗаполнитьНоменклатурнуюГруппуИСтатьюЗатратВСтрокеТабличногоПоля(НоваяСтрока);

		КонецЦикла;

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		
		Если Не ИспользоватьВнутренниеЗаказы() Тогда
			Возврат;
		КонецЕсли;
		
		// Заполнение шапки
		ОтражатьВУправленческомУчете = Истина;
		ОтражатьВБухгалтерскомУчете  = Ложь;
		ОтражатьВНалоговомУчете      = Ложь;
		Подразделение = Основание.Заказчик;
		Организация   = Основание.Организация;
		Ответственный = Основание.Ответственный;
		Заказ         = Основание.Ссылка;
		Комментарий   = Основание.Комментарий;
		Склад         = ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнойСклад");
		
		ЗаполнитьОстаткамиТоваровСРезервомПоВнутреннемуЗаказу( ЭтотОбъект, Основание, Материалы, Склад, Дата);
		
		Для Каждого Строка Из Материалы Цикл
			Строка.Заказ = Основание;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	
	// Удаление записей регистрации из всех последовательностей
	Для Каждого НаборЗаписейРегистрацииВПоследовательности Из ПринадлежностьПоследовательностям Цикл
		НаборЗаписейРегистрацииВПоследовательности.Очистить();
	КонецЦикла;
		
КонецПроцедуры // ПриЗаписи()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	//Адиянов<<<
	Если НЕ Отказ И мПроведениеИзФормы Тогда
		ПроверкаЗаполненияСтатьиЗатратУпр(ЭтотОбъект,Отказ);
	КонецЕсли; 		
	//Адиянов>>>

	
	//БАЛАНС (04.12.2007)                       
	//
	ЗарегистрироватьОбъект(ЭтотОбъект,Отказ,мПроведениеИзФормы);
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

	
КонецПроцедуры

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();

//БАЛАНС (04.12.2007)                       
//
мПроведениеИзФормы = Ложь; 