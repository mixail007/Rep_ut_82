﻿Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт
    ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("КонДата", НачалоДня(КонецДня(ОбщийОтчет.ДатаКон)+1));
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	
	Текст= "ВЫБРАТЬ 
| 	Сумма 
| {ВЫБРАТЬ
| Вид,
| ДТГ.Номенклатура.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель Производитель,
|Контрагент,
|ДоговорКонтрагента.*,
|Сделка.*
|}
|ИЗ
|(ВЫБРАТЬ
|ВЫБОР КОГДА ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток>0 ТОГДА
|	 ""Дебиторка""
|ИНАЧЕ
|	 ""Кредиторка""
|КОНЕЦ
|Вид,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
|	Заказы.Номенклатура Номенклатура,
|	//ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток,
|   ВЫБОР КОГДА ЕстьNULL(Заказы.СуммаДокумента,0)=0 ТОГДА 0
|   ИНАЧЕ
|   ВЫБОР КОГДА ВзаиморасчетыСКонтрагентамиОстатки.Сделка.СуммаВключаетНДС Тогда
|     ВЫРАЗИТЬ (Заказы.Сумма/Заказы.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   ИНАЧЕ
|      ВЫРАЗИТЬ ((Заказы.Сумма+Заказы.СуммаНДС)/Заказы.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   КОНЕЦ 
|КОНЕЦ Сумма
|	//ВЫРАЗИТЬ (Заказы.Сумма/Заказы.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2)) Сумма
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки( &КонДата
|		, ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам) ВзаиморасчетыСКонтрагентамиОстатки
|ЛЕВОЕ СОЕДИНЕНИЕ		    
|(ВЫБРАТЬ
|	ЗаказПокупателяТовары.Ссылка.ДоговорКонтрагента ДоговорКонтрагента,
|	ЗаказПокупателяТовары.Ссылка Сделка,
|	ЗаказПокупателяТовары.Номенклатура Номенклатура,
|	ЗаказПокупателяТовары.Сумма Сумма,
|	ЗаказПокупателяТовары.СуммаНДС СуммаНДС,
|	ЗаказПокупателяТовары.Ссылка.СуммаДокумента  СуммаДокумента
|ИЗ
|	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
|//ГДЕ
|//	ЗаказПокупателяТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &КонДата
|//	И ЗаказПокупателяТовары.Ссылка.Проведен
|ОБЪЕДИНИТЬ
|ВЫБРАТЬ
|	ЗаказПоставщикуТовары.Ссылка.ДоговорКонтрагента ДоговорКонтрагента,
|	ЗаказПоставщикуТовары.Ссылка ЗаказПокупателя,
|	ЗаказПоставщикуТовары.Номенклатура Номенклатура,
|	ЗаказПоставщикуТовары.Сумма Сумма,
|	ЗаказПоставщикуТовары.СуммаНДС СуммаНДС,
|	ЗаказПоставщикуТовары.Ссылка.СуммаДокумента  СуммаДокумента
|ИЗ
|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
|//ГДЕ
|	//ЗаказПоставщикуТовары.Ссылка.Дата МЕЖДУ &ДатаНач И &КонДата	
|//	И ЗаказПоставщикуТовары.Ссылка.Проведен
|) Заказы
|ПО	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента=Заказы.ДоговорКонтрагента
|И  ВзаиморасчетыСКонтрагентамиОстатки.Сделка= Заказы.Сделка
|ГДЕ Заказы.СуммаДокумента>0 
|ОБЪЕДИНИТЬ
|ВЫБРАТЬ
|""Склад"" Вид,
|"""" Контрагент,	
|"""" ДоговорКонтрагента,
|"""" Сделка,
|Номенклатура,
|СтоимостьОстаток Сумма
|ИЗ РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&КонДата,) ПартииТоваровНаСкладахОстатки 
|) ДТГ
|{ГДЕ 
| Вид,
|ДТГ.Номенклатура.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель Производитель,
|Контрагент,
|ДоговорКонтрагента,
|Сделка,
|ДТГ.Номенклатура
| }
|{ИТОГИ ПО
|Вид,
|ДТГ.Номенклатура.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель Производитель,
|Контрагент,
|ДоговорКонтрагента.*,
|Сделка.*,
|ДТГ.Номенклатура
|}
|ИТОГИ СУММА(Сумма)
|ПО ОБЩИЕ 
|АВТОУПОРЯДОЧИВАНИЕ";

Текст="ВЫБРАТЬ
|Сумма
| {ВЫБРАТЬ
| Вид,
|ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента.*,
|Сделка.*
|}
|ИЗ
|(ВЫБРАТЬ 
|ДТГ.Вид,
|ДТГ.Номенклатура.ВидТовара ВидТовара,
|ДТГ.Номенклатура.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель Производитель,
|Контрагент,
|ДоговорКонтрагента,
|Сделка,
|СУММА(Сумма) Сумма
|ИЗ
|(ВЫБРАТЬ
|ВЫБОР КОГДА ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток>0 ТОГДА
|	 ""Дебиторка""
|ИНАЧЕ
|	 ""Кредиторка""
|КОНЕЦ
|Вид,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
|	Заказы.Номенклатура Номенклатура,
|//ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток,
|   ВЫБОР КОГДА ЕстьNULL(Заказы.СуммаДокумента,0)=0 ТОГДА 0
|   ИНАЧЕ
|   ВЫБОР КОГДА ВзаиморасчетыСКонтрагентамиОстатки.Сделка.СуммаВключаетНДС Тогда
|	 ВЫРАЗИТЬ (Заказы.Сумма/Заказы.Сделка.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   ИНАЧЕ
|	  ВЫРАЗИТЬ ((Заказы.Сумма+Заказы.СуммаНДС)/Заказы.Сделка.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   КОНЕЦ 
|КОНЕЦ Сумма
|	//ВЫРАЗИТЬ (Заказы.Сумма/Заказы.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2)) Сумма
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки( &КонДата , ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам) ВзаиморасчетыСКонтрагентамиОстатки
|ЛЕВОЕ СОЕДИНЕНИЕ		    
|(
| ВЫБРАТЬ ДоговорКОнтрагента, Сделка,Номенклатура, СУММА(Сумма) Сумма, СУММА(СуммаНДС) СуммаНДС, СУММА(СуммаДокумента) СуммаДокумента
| ИЗ
|(ВЫБРАТЬ
|	ЗаказПокупателяТовары.Ссылка.ДоговорКонтрагента ДоговорКонтрагента,
|	ЗаказПокупателяТовары.Ссылка Сделка,
|	ЗаказПокупателяТовары.Номенклатура Номенклатура,
|	ЗаказПокупателяТовары.Сумма Сумма,
|	ЗаказПокупателяТовары.СуммаНДС СуммаНДС,
|	ЗаказПокупателяТовары.Ссылка.СуммаДокумента  СуммаДокумента
|ИЗ
|	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
|ОБЪЕДИНИТЬ ВСЕ
|ВЫБРАТЬ
|	ЗаказПоставщикуТовары.Ссылка.ДоговорКонтрагента ДоговорКонтрагента,
|	ЗаказПоставщикуТовары.Ссылка Сделка,
|	ЗаказПоставщикуТовары.Номенклатура Номенклатура,
|	ЗаказПоставщикуТовары.Сумма Сумма,
|	ЗаказПоставщикуТовары.СуммаНДС СуммаНДС,
|	ЗаказПоставщикуТовары.Ссылка.СуммаДокумента  СуммаДокумента
|ИЗ
|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары 
|  ) А
| СГРУППИРОВАТЬ ПО ДоговорКОнтрагента, Сделка,Номенклатура
|) Заказы
|ПО	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента=Заказы.ДоговорКонтрагента
|И  ВзаиморасчетыСКонтрагентамиОстатки.Сделка= Заказы.Сделка
|//ГДЕ Заказы.СуммаДокумента>0 
|ОБЪЕДИНИТЬ
|ВЫБРАТЬ
|""Склад"" Вид,
|"""" Контрагент,	
|"""" ДоговорКонтрагента,
|"""" Сделка,
|Номенклатура,
|СтоимостьОстаток Сумма
|ИЗ РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&КонДата,) ПартииТоваровНаСкладахОстатки 
|) ДТГ
| СГРУППИРОВАТЬ ПО ДТГ.Вид,
|ДТГ.Номенклатура.ВидТовара,
|ДТГ.Номенклатура.НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель,
|Контрагент,
|ДоговорКонтрагента,
|Сделка
| ОБЪЕДИНИТЬ
| ВЫБРАТЬ 
| ВЫБОР КОГДА Сумма>0 ТОГДА ""Дебиторка"" ИНАЧЕ ""Кредиторка"" КОНЕЦ Вид, ВидТовара,
| НоменклатурнаяГруппа, Производитель, Контрагент, ДоговорКонтрагента, Сделка, Сумма
| ИЗ	
|	(ВЫБРАТЬ 
| //  ""Дебиторка"" Вид,
|"""" ВидТовара,
|ВзаиморасчетыУслуги.ДоговорКонтрагента.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|"""" Производитель,
|ВзаиморасчетыУслуги.ДоговорКонтрагента.Владелец Контрагент,
|ВзаиморасчетыУслуги.ДоговорКонтрагента ДоговорКонтрагента,
|"""" Сделка, 
|   СУММА(ВзаиморасчетыУслуги.СуммаУпрОстаток) Сумма ИЗ
|   РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки( &КонДата
| , ДоговорКонтрагента.ВедениеВзаиморасчетов <> &ПоЗаказам И
|		ДоговорКонтрагента.НоменклатурнаяГруппа<>&ПустаяНГ) ВзаиморасчетыУслуги
|	СГРУППИРОВАТЬ ПО ВзаиморасчетыУслуги.ДоговорКонтрагента.НоменклатурнаяГруппа,	 
|	ВзаиморасчетыУслуги.ДоговорКонтрагента.Владелец,
|   ВзаиморасчетыУслуги.ДоговорКонтрагента ) ВзаиморасчетыУслуги
|
|
|
|) Б
|{ГДЕ 
| Вид,
| ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента,
|Сделка
|}
|{ИТОГИ ПО
|Вид,
|ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента.*,
|Сделка.*}
|ИТОГИ СУММА(Сумма)
|ПО ОБЩИЕ 
|АВТОУПОРЯДОЧИВАНИЕ";

ПостроительОтчета.Параметры.Вставить("ДатаНач", Дата('20070101') );
ПостроительОтчета.Параметры.Вставить("ПоЗаказам", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
ПостроительОтчета.Параметры.Вставить("ПустаяНГ", Справочники.НоменклатурныеГруппы.ПустаяСсылка());


	
	СтруктураПредставлениеПолей = Новый Структура("
	|Вид,
	|ВидТовара,
	|НоменклатурнаяГруппа,
	|Производитель,
	|Контрагент,
	|ДоговорКонтрагента,
	|Сделка,
	|Сумма", 
	"Вид",
	"ВидТовара",
	"Номенклатурная группа",
	"Производитель",	
	"Контрагент",
	"Договор контрагента",
	"Сделка",
	"Сумма");

	
		
	ПостроительОтчета.Текст = Текст;
	МассивОтбора = Новый Массив;
	ОбщийОтчет.ЗаполнитьПоказатели("Сумма", "Стоимость", Истина, "ЧЦ=15; ЧДЦ=2");
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	ОбщийОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить("ВидТовара");
	ОбщийОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить("НоменклатурнаяГруппа");
	ОбщийОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить("Производитель");
	
	ОбщийОтчет.ПостроительОтчета.ИзмеренияКолонки.Добавить("Вид");
	
	ОбщийОтчет.мНазваниеОтчета = "Деньги в товарных группах";

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
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "ВзаиморасчетыСКонтрагентами";
ОбщийОтчет.мНазваниеОтчета = "Деньги в товарных группах";
ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
ОбщийОтчет.мВыбиратьИспользованиеСвойств=Ложь;
ОбщийОтчет.мРежимВводаПериода = 1;
ОбщийОтчет.ВыводитьПоказателиВСтроку=Истина;