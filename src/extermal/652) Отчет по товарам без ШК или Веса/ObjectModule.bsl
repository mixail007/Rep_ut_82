﻿Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт

	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
    	ОбщийОтчет.ПостроительОтчета.Отбор.СкладПодразделение.Значение = ДоступноеПодразделение;
		ОбщийОтчет.ПостроительОтчета.Отбор.СкладПодразделение.Использование = Истина;
		ОбщийОтчет.ПостроительОтчета.Отбор.СкладПодразделение.ВидСравнения = ВидСравнения.Равно;
	КонецЕсли;
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням=Истина;
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	
	Текст = "ВЫБРАТЬ
	        |	ЕдиницыИзмерения.Владелец,
	        |	МАКСИМУМ(ЕдиницыИзмерения.Вес) КАК Вес,
	        |	МАКСИМУМ(ЕдиницыИзмерения.Объем) КАК Объем
	        |ПОМЕСТИТЬ Вес1
	        |ИЗ
	        |	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ЕдиницыИзмерения.Владелец
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ТоварыНаСкладахОстатки.Номенклатура КАК Владелец,
	        |	МАКСИМУМ(ЕСТЬNULL(Штрихкоды.Штрихкод, """")) КАК Штрихкод
	        |ПОМЕСТИТЬ ШтрихКод1
	        |ИЗ
	        |	РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаКон, ) КАК ТоварыНаСкладахОстатки
	        |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	        |		ПО ТоварыНаСкладахОстатки.Номенклатура = Штрихкоды.Владелец
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ТоварыНаСкладахОстатки.Номенклатура
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ТаблицаРегистра.Склад КАК Склад,
	        |	ТаблицаРегистра.Номенклатура КАК Номенклатура,
	        |	СУММА(ТаблицаРегистра.КоличествоОстаток) КАК Количество,
	        |	СУММА(ТаблицаРегистра.КоличествоОстаток * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕд,
	        |	СУММА(ТаблицаРегистра.КоличествоОстаток * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ТаблицаРегистра.Номенклатура.ЕдиницаДляОтчетов.Коэффициент) КАК КоличествоЕдиницОтчетов,
	        |	ТаблицаРегистра.Склад.Представление КАК СкладПредставление,
	        |	ТаблицаРегистра.Номенклатура.Представление КАК НоменклатураПредставление,
	        |	ТаблицаРегистра.Номенклатура.Код КАК Код,
	        |	Вес1.Вес КАК Вес,
	        |	Вес1.Объем,
	        |	ШтрихКод1.Штрихкод КАК Штрихкод
	        |{ВЫБРАТЬ
	        |	Склад.* КАК Склад,
	        |	Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков КАК НоменклатураЕдиницаХраненияОстатков,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.СерияНоменклатуры.* КАК СерияНоменклатуры,
	        |	ТаблицаРегистра.Качество.* КАК Качество,
	        |	Вес,
	        |	Объем,
	        |	Штрихкод}
	        |ИЗ
	        |	РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаКон, {(Склад).* КАК Склад, (Номенклатура).* КАК Номенклатура, (ХарактеристикаНоменклатуры).* КАК ХарактеристикаНоменклатуры, (СерияНоменклатуры).* КАК СерияНоменклатуры, (Качество).* КАК Качество}) КАК ТаблицаРегистра
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Вес1 КАК Вес1
	        |		ПО ТаблицаРегистра.Номенклатура = Вес1.Владелец
	        |		ЛЕВОЕ СОЕДИНЕНИЕ ШтрихКод1 КАК ШтрихКод1
	        |		ПО ТаблицаРегистра.Номенклатура = ШтрихКод1.Владелец
	        |{ГДЕ
	        |	(ЛОЖЬ) КАК НеавтоматизированнаяТорговаяТочка,
	        |	Вес1.Вес,
	        |	Вес1.Объем,
	        |	(ЕСТЬNULL(ШтрихКод1.Штрихкод, """")) КАК Поле2,
	        |	ШтрихКод1.Штрихкод}
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ТаблицаРегистра.Номенклатура,
	        |	ТаблицаРегистра.Склад,
	        |	ТаблицаРегистра.Склад.Представление,
	        |	ТаблицаРегистра.Номенклатура.Представление,
	        |	ТаблицаРегистра.Номенклатура.Код,
	        |	Вес1.Объем,
	        |	Вес1.Вес,
	        |	ШтрихКод1.Штрихкод
	        |{УПОРЯДОЧИТЬ ПО
	        |	Склад.* КАК Склад,
	        |	Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.* КАК НоменклатураЕдиницаХраненияОстатков,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.СерияНоменклатуры.* КАК СерияНоменклатуры,
	        |	ТаблицаРегистра.Качество.* КАК Качество,
	        |	Количество,
	        |	КоличествоБазовыхЕд,
	        |	Вес,
	        |	Объем,
	        |	Штрихкод}
	        |ИТОГИ
	        |	СУММА(Количество),
	        |	СУММА(КоличествоБазовыхЕд),
	        |	СУММА(КоличествоЕдиницОтчетов)
	        |ПО
	        |	ОБЩИЕ,
	        |	Склад КАК Склад,
	        |	Номенклатура КАК Номенклатура
	        |{ИТОГИ ПО
	        |	Склад.* КАК Склад,
	        |	Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.* КАК НоменклатураЕдиницаХраненияОстатков,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.СерияНоменклатуры.* КАК СерияНоменклатуры,
	        |	ТаблицаРегистра.Качество.* КАК Качество}";
	
	//ПостроительОтчета.Параметры.Вставить("ДатаОтгрузки",НачалоДня(ТекущаяДата()));
	
	СтруктураПредставлениеПолей = Новый Структура(
	"Склад,
	|Номенклатура,
	|ХарактеристикаНоменклатуры,
	|СерияНоменклатуры,
	|Качество,
	|НоменклатураБазоваяЕдиницаИзмерения,
	|НоменклатураЕдиницаХраненияОстатков",
	"Склад",
	"Номенклатура",
	"Характеристика номенклатуры",
	"Серия номенклатуры",
	"Качество",
	"Базовая единица измерения",
	"Единица хранения остатков");
	
	Если ОбщийОтчет.ИспользоватьСвойстваИКатегории Тогда
		ТекстПоляСвойств= "";
		ТекстПоляКатегорий = "";

		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "Номенклатура";
		СтрокаТаблицы.Представление = "Номенклатура";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "Склад";
		СтрокаТаблицы.Представление = "Склад";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Склады;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры;
		
		ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, 
				ОбщийОтчет.мСоответствиеНазначений, ПостроительОтчета.Параметры
				,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,ОбщийОтчет.мСтруктураДляОтбораПоКатегориям);
				
		ДобавитьВТекстСвойстваОбщие(Текст, ТекстПоляСвойств, "//ОБЩИЕ_СВОЙСТВА");

	КонецЕсли;
		
	ПостроительОтчета.Текст = Текст;
	
	Если ОбщийОтчет.ИспользоватьСвойстваИКатегории = Истина Тогда

		УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, ОбщийОтчет.мСоответствиеНазначений, СтруктураПредставлениеПолей);

	КонецЕсли;
	
	Если ОбщийОтчет.Показатели.Найти("Количество", "Имя") = Неопределено Тогда
		ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в единицах хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	КонецЕсли;
	Если ОбщийОтчет.Показатели.Найти("КоличествоБазовыхЕд", "Имя") = Неопределено Тогда
		ОбщийОтчет.ЗаполнитьПоказатели("КоличествоБазовыхЕд", "Количество в базовых единицах измерения", Ложь, "ЧЦ=15; ЧДЦ=3");
	КонецЕсли;
	Если ОбщийОтчет.Показатели.Найти("КоличествоЕдиницОтчетов", "Имя") = Неопределено Тогда
		ОбщийОтчет.ЗаполнитьПоказатели("КоличествоЕдиницОтчетов", "Количество в ед. отчетов", Ложь, "ЧЦ=15; ЧДЦ=3");
	КонецЕсли;
	
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Склад");
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
		МассивОтбора.Добавить("Склад.Подразделение");
	КонецЕсли;
	
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ПостроительОтчета.Отбор.СкладПодразделение.Значение = ДоступноеПодразделение;
		ПостроительОтчета.Отбор.СкладПодразделение.Использование = Истина;
	КонецЕсли;
		
	ПостроительОтчета.ИзмеренияСтроки.Удалить(ПостроительОтчета.ИзмеренияСтроки.Найти("Склад"));
	//ПостроительОтчета.ИзмеренияКолонки.Добавить("Склад", "Склад", ТипИзмеренияПостроителяОтчета.Элементы);
	
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений = Новый Структура("Количество, КоличествоБазовыхЕд", Новый Структура("НоменклатураЕдиницаХраненияОстатков, Номенклатура"), Новый Структура("НоменклатураБазоваяЕдиницаИзмерения, Номенклатура"), Новый Структура);
	
	//ОбщийОтчет.ВыводитьИтогиПоВсемУровням=Истина;
	//Если не(ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"РазрешитьПросмотрНедоступныхСкладов")) Тогда 
	//	Запрос = новый Запрос;
	//	Запрос.Текст = "
	//	|Выбрать Ссылка из Справочник.Склады
	//	|Где Ссылка.ЗапретитьИспользование = Истина";
	//	Список = Запрос.Выполнить().Выгрузить();
	//	ПостроительОтчета.Параметры.Вставить("СписокСкладов",Список.ВыгрузитьКолонку("Ссылка"));
	//КонецЕсли;
	
КонецПроцедуры

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура Настроить(Параметры) Экспорт

	ОбщийОтчет.Настроить(Параметры, ЭтотОбъект);

КонецПроцедуры

// Возвращает основную форму отчета, связанную с данным экземпляром отчета
//
// Параметры
//	Нет
//
Функция ПолучитьОсновнуюФорму() Экспорт
	
	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;
	
КонецФункции // ПолучитьОсновнуюФорму()

// Возвращает форму настройки 
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	
//
Функция ПолучитьФормуНастройки() Экспорт
	
	ФормаНастройки = ОбщийОтчет.ПолучитьФорму("ФормаНастройка");
	Возврат ФормаНастройки;
	
КонецФункции // ПолучитьФормуНастройки()

// Процедура обработки расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровки(РасшифровкаСтроки, ПолеТД, ВысотаЗаголовка, СтандартнаяОбработка) Экспорт
	
	// Добавление расшифровки из колонки
	Если ТипЗнч(РасшифровкаСтроки) = Тип("Структура") Тогда
		
		// Расшифровка колонки находится в заголовке колонки
		РасшифровкаКолонки = ПолеТД.Область(ВысотаЗаголовка+2, ПолеТД.ТекущаяОбласть.Лево).Расшифровка;

		Расшифровка = Новый Структура;

		Для каждого Элемент Из РасшифровкаСтроки Цикл
			Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;

		Если ТипЗнч(РасшифровкаКолонки) = Тип("Структура") Тогда

			Для каждого Элемент Из РасшифровкаКолонки Цикл
				Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;

		КонецЕсли; 

		ОбщийОтчет.ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОбъект);

	КонецЕсли;
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру, в которую складываются настройки
//
Функция СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	ОбщийОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураНастроек, ПоказыватьЗаголовок);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Заполняет настройки из структуры - кроме состояния панели "Отбор"
//
Процедура ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет=Неопределено) Экспорт
	
	// Если отчет, вызвавший порцедуру, не передан, то считаем, что ее вызвал этот отчет
	Если Отчет = Неопределено Тогда
		Отчет = ЭтотОбъект;
	КонецЕсли;

	ОбщийОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет);
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
		ОбщийОтчет.ПостроительОтчета.Отбор.СкладПодразделение.Значение = ДоступноеПодразделение;
		ОбщийОтчет.ПостроительОтчета.Отбор.СкладПодразделение.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "ТоварыНаСкладах";
ОбщийОтчет.мНазваниеОтчета = "Остатки товаров на складах";
ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
ОбщийОтчет.мРежимВводаПериода = 1;