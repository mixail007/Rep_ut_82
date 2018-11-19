﻿Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	//ЗаполнитьНачальныеНастройкиПоМакету(ПолучитьМакет("ПараметрыОтчетовПродажиКомпании"), СтруктураПредставлениеПолей, МассивОтбора, ОбщийОтчет, "СписокКроссТаблица");
	Текст = "
	|ВЫБРАТЬ //РАЗЛИЧНЫЕ
	|	СУММА(ТаблицаРегистра.КоличествоОборот) КАК Количество,
	|	СУММА(ТаблицаРегистра.КоличествоОборот*ТаблицаРегистра.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК КоличествоБазовыхЕд,
	|	СУММА(ТаблицаРегистра.СтоимостьОборот) КАК Стоимость,
	|	СУММА(ТаблицаРегистраСебестоимость.СтоимостьОборот) КАК Себестоимость,
	|	(ВЫБОР КОГДА Сумма(ТаблицаРегистра.СтоимостьОборот) ЕСТЬ NULL ТОГДА 0 ИНАЧЕ Сумма(ТаблицаРегистра.СтоимостьОборот) КОНЕЦ) - (ВЫБОР КОГДА Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот) ЕСТЬ NULL ТОГДА 0 ИНАЧЕ Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот) КОНЕЦ) КАК ВаловаяПрибыль,
	|	ВЫРАЗИТЬ(ВЫБОР 
	|			КОГДА Сумма(ТаблицаРегистра.СтоимостьОборот)<>0 
	|				ТОГДА 100*(Сумма(ТаблицаРегистра.СтоимостьОборот)-Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот))/Сумма(ТаблицаРегистра.СтоимостьОборот)
	|				ИНАЧЕ 0 КОНЕЦ КАК ЧИСЛО (15,2)) КАК РентабельностьПродаж,
	|	ВЫРАЗИТЬ(ВЫБОР 
	|			КОГДА Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот)<>0 
	|				ТОГДА 100*(Сумма(ТаблицаРегистра.СтоимостьОборот)-Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот))/Сумма(ТаблицаРегистраСебестоимость.СтоимостьОборот)
	|				ИНАЧЕ 0 КОНЕЦ КАК ЧИСЛО (15,2)) КАК ПроцентНаценки,
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец КАК Покупатель,
	|	ТаблицаРегистра.Номенклатура КАК Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения КАК НоменклатураБазоваяЕдиницаИзмерения
	|{ВЫБРАТЬ 
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	|	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	|	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	|	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	|	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	|	ТаблицаРегистра.Период ,
	|	ТаблицаРегистра.Регистратор.* КАК Регистратор
	|	//СВОЙСТВА
	|,
	|	НачалоПериода(ТаблицаРегистра.Период, День) КАК ПериодДень ,
	|	НачалоПериода(ТаблицаРегистра.Период, Неделя) КАК ПериодНеделя ,
	|	НачалоПериода(ТаблицаРегистра.Период, Месяц) КАК ПериодМесяц ,
	|	НачалоПериода(ТаблицаРегистра.Период, Квартал) КАК ПериодКвартал ,
	|	НачалоПериода(ТаблицаРегистра.Период, Год) КАК ПериодГод}
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(&ДатаНач, &ДатаКон, Регистратор) КАК ТаблицаРегистра
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПродажиСебестоимость.Обороты(&ДатаНач, &ДатаКон, Регистратор) КАК ТаблицаРегистраСебестоимость
	|	//СОЕДИНЕНИЯ
	|	ПО
	|		ТаблицаРегистра.Номенклатура = ТаблицаРегистраСебестоимость.Номенклатура
	|		И ТаблицаРегистра.ХарактеристикаНоменклатуры = ТаблицаРегистраСебестоимость.ХарактеристикаНоменклатуры
	|		И ТаблицаРегистра.ЗаказПокупателя = ТаблицаРегистраСебестоимость.ЗаказПокупателя
	|		И ТаблицаРегистра.Подразделение = ТаблицаРегистраСебестоимость.Подразделение
	|		И ТаблицаРегистра.Регистратор = ТаблицаРегистраСебестоимость.Регистратор
	|СГРУППИРОВАТЬ ПО 
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец,
	|	ТаблицаРегистра.Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения
	|//СГРУППИРОВАТЬПО
	|{ГДЕ 
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	|	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	|	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	|	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	|	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	|	ТаблицаРегистра.Период ,
	|	ТаблицаРегистра.Регистратор.* КАК Регистратор
	|//СВОЙСТВА
	|//КАТЕГОРИИ
	|}
	|{УПОРЯДОЧИТЬ ПО 
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	|	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	|	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	|	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	|	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	|	ТаблицаРегистра.Период ,
	|	ТаблицаРегистра.Регистратор.* КАК Регистратор
	|//СВОЙСТВА
	|}
	|{ИТОГИ ПО 
	|	ТаблицаРегистра.ДоговорКонтрагента.Владелец.* КАК Покупатель,
	|	ТаблицаРегистра.ДоговорКонтрагента.* КАК ДоговорКонтрагента,
	|	ТаблицаРегистра.ЗаказПокупателя.* КАК ЗаказПокупателя,
	|	ТаблицаРегистра.Номенклатура.* КАК Номенклатура,
	|	ТаблицаРегистра.Номенклатура.БазоваяЕдиницаИзмерения.* КАК НоменклатураБазоваяЕдиницаИзмерения,
	|	ТаблицаРегистра.ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
	|	ТаблицаРегистра.ДокументПродажи.* КАК ДокументПродажи,
	|	ТаблицаРегистра.Подразделение.* КАК Подразделение,
	|	НачалоПериода(ТаблицаРегистра.Период, День) КАК ПериодДень ,
	|	НачалоПериода(ТаблицаРегистра.Период, Неделя) КАК ПериодНеделя ,
	|	НачалоПериода(ТаблицаРегистра.Период, Месяц) КАК ПериодМесяц ,
	|	НачалоПериода(ТаблицаРегистра.Период, Квартал) КАК ПериодКвартал ,
	|	НачалоПериода(ТаблицаРегистра.Период, Год) КАК ПериодГод
	|//СВОЙСТВА
	|}
	|ИТОГИ  
	|	СУММА(Количество),
	|	СУММА(КоличествоБазовыхЕд),
	|	СУММА(Стоимость),
	|	СУММА(Себестоимость) ,
	|	СУММА(ВаловаяПрибыль),
	|	ВЫРАЗИТЬ(ВЫБОР 
	|			КОГДА Сумма(Стоимость)<>0 
	|				ТОГДА 100*(Сумма(Стоимость)-Сумма(Себестоимость))/Сумма(Стоимость)
	|				ИНАЧЕ 0 КОНЕЦ КАК ЧИСЛО (15,2)) Как РентабельностьПродаж,
	|	ВЫРАЗИТЬ(ВЫБОР 
	|			КОГДА Сумма(Себестоимость)<>0 
	|				ТОГДА 100*(Сумма(Стоимость)-Сумма(Себестоимость))/Сумма(Себестоимость)
	|				ИНАЧЕ 0 КОНЕЦ КАК ЧИСЛО (15,2)) как ПроцентНаценки
	|ПО ОБЩИЕ 
	|	//,
	|	//ТаблицаРегистра.ДоговорКонтрагента.Владелец КАК Покупатель,
	|	//ТаблицаРегистра.Номенклатура ИЕРАРХИЯ  КАК Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	СтруктураПредставлениеПолей = Новый Структура("
	|Количество,
	|КоличествоБазовыхЕд,
	|Стоимость,
	|Себестоимость,
	|ВаловаяПрибыль,
	|РентабельностьПродаж,
	|ПроцентНаценки,
	|Покупатель,
	|ДоговорКонтрагента,
	|ЗаказПокупателя,
	|НоменклатураБазоваяЕдиницаИзмерения,
	|ХарактеристикаНоменклатуры,
	|Подразделение,
	|ПериодДень,
	|ПериодНеделя,
	|ПериодМесяц,
	|ПериодКвартал,
	|ПериодГод", 
	"Количество товара в единицах хранения остатков",
	"Количество товара в базовых единицах",
	"Продажная стоимость",
	"Себестоимость",
	"Валовая прибыль",
	"Рентабельность продаж, %",
	"Процент наценки",
	"Покупатель",
	"Договор контрагента",
	"Заказ покупателя",
	"Базовая единица измерения",
	"Характеристика номенклатуры",
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
		
		ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, Текст, СтруктураПредставлениеПолей, 
				ОбщийОтчет.мСоответствиеНазначений, ПостроительОтчета.Параметры
				,, ТекстПоляКатегорий, ТекстПоляСвойств,,,,,,ОбщийОтчет.мСтруктураДляОтбораПоКатегориям);
				
		ДобавитьВТекстСвойстваОбщие(Текст, ТекстПоляСвойств, "//ОБЩИЕ_СВОЙСТВА");
      // для избежания двойственности поля Номенклатура в запросе
	    Текст=СтрЗаменить(Текст,"ИНАЧЕ Номенклатура","ИНАЧЕ ТаблицаРегистраСебестоимость.Номенклатура");
	//	УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, ОбщийОтчет.мСоответствиеНазначений, СтруктураПредставлениеПолей);
	КонецЕсли;
	
	ПостроительОтчета.Текст = Текст;
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить("Покупатель");
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Подразделение");
	
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
	ОбщийОтчет.ВыводитьПоказателиВСтроку = Истина;
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Истина;
	
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в единицах хранения", Ложь, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("Количество", "Количество в базовых единицах", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("Стоимость", "Продажная стоимость в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("Себестоимость", "Себестоимость в валюте упр. учета", Ложь, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("ВаловаяПрибыль", "Валовая прибыть в валюте упр. учета", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("РентабельностьПродаж", "Рентабельность продаж, %", Истина, "ЧЦ=15; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("ПроцентНаценки", "Процент наценки", Истина, "ЧЦ=15; ЧДЦ=2");

	ОбщийОтчет.мНазваниеОтчета = "Отчет по валовой прибыли";
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Ложь;
	ОбщийОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Установим дату начала отчета
	Если Не ЗначениеНеЗаполнено(глТекущийПользователь) Тогда
		ОбщийОтчет.ДатаНач = ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ОсновнаяДатаНачалаОтчетов");
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("РентабельностьПродаж", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("ПроцентНаценки", Новый Структура("ТакогоИзмеренияНетВОтчете")); // Рентабельность не выводится в итогах по группировкам, только в детальных записях
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
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "Продажи";