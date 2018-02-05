﻿//+++ 07.06.2012 - добавлены свойства и категории
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	//ЗаполнитьНачальныеНастройкиПоМакету(ПолучитьМакет("ПараметрыОтчетовПродажиКомпании"), СтруктураПредставлениеПолей, МассивОтбора, ОбщийОтчет, "СписокКроссТаблица");
	Текст = "ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Группа
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90230""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Важность
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90184""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ЗначенияСвойствОбъектов.Объект,
	        |	ЗначенияСвойствОбъектов.Значение
	        |ПОМЕСТИТЬ Статус
	        |ИЗ
	        |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	        |ГДЕ
	        |	ЗначенияСвойствОбъектов.Свойство.Код = ""90218""
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	СУММА(ТаблицаРегистра.КоличествоОборот) КАК Количество,
	        |	СУММА(ТаблицаРегистра.КоличествоОборот * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕд,
	        |	ВЫБОР
	        |		КОГДА СУММА(ТаблицаРегистра.КоличествоОборот) <> 0
	        |			ТОГДА СУММА(ТаблицаРегистра.СтоимостьОборот) / СУММА(ТаблицаРегистра.КоличествоОборот)
	        |		ИНАЧЕ 0
	        |	КОНЕЦ КАК Цена,
	        |	СУММА(ТаблицаРегистра.СтоимостьОборот) КАК Стоимость,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец КАК Покупатель,
	        |	ТаблицаРегистра.Номенклатура КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	Статус.Значение КАК Статус,
	        |	Важность.Значение КАК Важность,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет КАК Интернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал КАК Терминал,
	        |	Группа.Значение КАК РабочаяГруппа
	        |{ВЫБРАТЬ
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	ТаблицаРегистра.Период,
	        |	(ПОДСТРОКА(ТаблицаРегистра.ДоговорКонтрагента.Владелец.Комментарий, 1, 100)) КАК КомментарийПокупателя,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ГОД)) КАК ПериодГод,
	        |	Статус.*,
	        |	Важность.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |ИЗ
	        |	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК ТаблицаРегистра
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Важность КАК Важность
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Важность.Объект
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Статус КАК Статус
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Статус.Объект
	        |		ЛЕВОЕ СОЕДИНЕНИЕ Группа КАК Группа
	        |		ПО ТаблицаРегистра.ДоговорКонтрагента.Владелец = Группа.Объект
	        |{ГДЕ
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	ТаблицаРегистра.Период,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	(ТаблицаРегистра.КоличествоОборот * ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Количество,
	        |	Статус.Значение.* КАК Статус,
	        |	Важность.Значение.* КАК Важность,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет КАК Интернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал КАК Терминал,
	        |	Группа.Значение.* КАК РабочаяГруппа}
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец,
	        |	ТаблицаРегистра.Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения,
	        |	Статус.Значение,
	        |	Важность.Значение,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТИнтернет,
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.ЯШТТерминал,
	        |	Группа.Значение
	        |{УПОРЯДОЧИТЬ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ГОД)) КАК ПериодГод,
	        |	ТаблицаРегистра.Регистратор.* КАК Регистратор,
	        |	Статус.*,
	        |	Важность.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |ИТОГИ
	        |	СУММА(Количество),
	        |	СУММА(КоличествоБазовыхЕд),
	        |	ВЫБОР
	        |		КОГДА СУММА(Количество) <> 0
	        |			ТОГДА СУММА(Стоимость) / СУММА(Количество)
	        |		ИНАЧЕ 0
	        |	КОНЕЦ КАК Цена,
	        |	СУММА(Стоимость)
	        |ПО
	        |	ОБЩИЕ
	        |{ИТОГИ ПО
	        |	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	        |	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	        |	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	        |	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	        |	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	        |	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	        |	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	        |	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ДЕНЬ)) КАК ПериодДень,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, МЕСЯЦ)) КАК ПериодМесяц,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, КВАРТАЛ)) КАК ПериодКвартал,
	        |	(НАЧАЛОПЕРИОДА(ТаблицаРегистра.Период, ГОД)) КАК ПериодГод,
	        |	Статус.*,
	        |	Важность.*,
	        |	Интернет,
	        |	Терминал,
	        |	РабочаяГруппа.*}
	        |АВТОУПОРЯДОЧИВАНИЕ";
	СтруктураПредставлениеПолей = Новый Структура("
	|Количество,
	|КоличествоБазовыхЕд,
	|Стоимость,
	|Покупатель,
	|ДоговорКонтрагента,
	|ЗаказПокупателя,
	|НоменклатураБазоваяЕдиницаИзмерения,
	|ХарактеристикаНоменклатуры,
	|КомментарийПокупателя,
	|Подразделение,
	|ПериодДень,
	|ПериодНеделя,
	|ПериодМесяц,
	|ПериодКвартал,
	|ПериодГод", 
	"Количество товара в единицах хранения остатков",
	"Количество товара в базовых единицах",
	"Продажная стоимость",
	"Покупатель",
	"Договор контрагента",
	"Заказ покупателя",
	"Базовая единица измерения",
	"Характеристика номенклатуры",
	"Комментарий покупателя",
	"Подразделение",
	"По дням",
	"По неделям",
	"По месяцам",
	"По кварталам",
	"По годам");
	
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
		СтрокаТаблицы.ПутьКДанным = "ДоговорКонтрагента.Владелец";
		СтрокаТаблицы.Представление = "Покупатель";
		СтрокаТаблицы.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;
		
		
		ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, 
				ОбщийОтчет.мСоответствиеНазначений, ПостроительОтчета.Параметры
				,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,ОбщийОтчет.мСтруктураДляОтбораПоКатегориям);
				
		ДобавитьВТекстСвойстваОбщие(Текст, ТекстПоляСвойств, "//ОБЩИЕ_СВОЙСТВА");
      // для избежания двойственности поля Номенклатура в запросе
	    
	//	УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, ОбщийОтчет.мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;
	
	ПостроительОтчета.Текст = Текст;
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Покупатель");
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Подразделение");
	
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
		ПостроительОтчета.Отбор.Подразделение.Значение = ДоступноеПодразделение;
		ПостроительОтчета.Отбор.Подразделение.Использование = Истина;
	КонецЕсли;
	
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
	ОбщийОтчет.ВыводитьПоказателиВСтроку = Истина;
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Истина;
	
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в единицах хранения", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("Цена", "Цена продажи", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("Стоимость", "Продажная стоимость в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	

	ОбщийОтчет.мНазваниеОтчета = "Продажи";
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Ложь;
	ОбщийОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Установим дату начала отчета
	Если ЗначениеНеЗаполнено(ОбщийОтчет.ДатаНач) Тогда
		Если Не ЗначениеНеЗаполнено(глТекущийПользователь) Тогда
			ОбщийОтчет.ДатаНач = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ОсновнаяДатаНачалаОтчетов");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	//ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("РентабельностьПродаж", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
	//ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("ПроцентНаценки", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") Тогда
		ДоступноеПодразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
    	ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Значение = ДоступноеПодразделение;
		ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Использование = Истина;
		ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.ВидСравнения = ВидСравнения.Равно;
	КонецЕсли;
	
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПРоцедуры

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
		ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Значение = ДоступноеПодразделение;
		ОбщийОтчет.ПостроительОтчета.Отбор.Подразделение.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "Продажи";