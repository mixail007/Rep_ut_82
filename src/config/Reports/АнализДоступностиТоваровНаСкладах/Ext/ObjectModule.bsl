﻿Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт

	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ОбщийОтчет.ИмяРегистра = "ТоварыНаСкладах";
	ОбщийОтчет.мНазваниеОтчета = "Анализ доступности товаров на складах";
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	//ЗаполнитьНачальныеНастройкиПоМакету(ПолучитьМакет("ПараметрыОтчетовОстаткиТоваровКомпании"), СтруктураПредставлениеПолей, МассивОтбора, ОбщийОтчет, "СписокКроссТаблица");
	ПостроительОтчета.Текст = 
	"
	|ВЫБРАТЬ
	|	Номенклатура,
//	|	ХарактеристикаНоменклатуры,
	|	КоличествоОстаток,
	|	КоличествоВРезерве,
	|	КоличествоКПолучению,
	|	КоличествоКПередаче,
	|	КоличествоОстаток - КоличествоВРезерве - КоличествоКПередаче КАК СвободныйОстаток,
	|	Склад
//	|	,ДокументОснование
	|{ВЫБРАТЬ
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*,
	|	Склад.*,
	|	ДокументОснование.*
//	|,	(ВЫБОР Когда СвободныеОстатки.СвободныйОстаток ЕСТЬ NULL Тогда Ложь Когда СвободныеОстатки.СвободныйОстаток>0 Тогда Истина Иначе Ложь КОНЕЦ) КАК НаличиеСвободногоОстатка
	|} ИЗ
	|(
	|ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|	ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	0 КАК КоличествоВРезерве,
	|	0 КАК КоличествоКПолучению,
	|	0 КАК КоличествоКПередаче,
	|	ТоварыНаСкладахОстатки.Склад КАК Склад,
	|	NULL КАК ДокументОснование
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаКон
	//, {Номенклатура.*, Склад.*}
	|) КАК ТоварыНаСкладахОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыВРезервеНаСкладахОстатки.Номенклатура,
	|	ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры,
	|	0,
	|	ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток,
	|	0,
	|	0,
	|	ТоварыВРезервеНаСкладахОстатки.Склад,
	|	ТоварыВРезервеНаСкладахОстатки.ДокументРезерва
	|ИЗ
	|	РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаКОн
	//, {Номенклатура.*, Склад.*}
	|) КАК ТоварыВРезервеНаСкладахОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыКПолучениюНаСкладыОстатки.Номенклатура,
	|	ТоварыКПолучениюНаСкладыОстатки.ХарактеристикаНоменклатуры,
	|	0,
	|	0,
	|	ТоварыКПолучениюНаСкладыОстатки.КоличествоОстаток,
	|	0,
	|	ТоварыКПолучениюНаСкладыОстатки.ДокументПолучения.Склад,
	|	ТоварыКПолучениюНаСкладыОстатки.ДокументПолучения
	|ИЗ
	|	РегистрНакопления.ТоварыКПолучениюНаСклады.Остатки(&ДатаКон
	//, {Номенклатура.*, Склад.*}
	|) КАК ТоварыКПолучениюНаСкладыОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыКПередачеСоСкладовОстатки.Номенклатура,
	|	ТоварыКПередачеСоСкладовОстатки.ХарактеристикаНоменклатуры,
	|	0,
	|	0,
	|	0,
	|	ТоварыКПередачеСоСкладовОстатки.КоличествоОстаток,
	|	ТоварыКПередачеСоСкладовОстатки.Склад,
	|	ТоварыКПередачеСоСкладовОстатки.ДокументПередачи
	|ИЗ
	|	РегистрНакопления.ТоварыКПередачеСоСкладов.Остатки(&ДатаКон
	//, {ТоварыКПередачеСоСкладовОстатки.Номенклатура.*, ТоварыКПередачеСоСкладовОстатки.Склад.*}
	|) КАК ТоварыКПередачеСоСкладовОстатки) КАК ВнутреннийЗапрос
	|{ЛЕВОЕ СОЕДИНЕНИЕ (
	|	ВЫБРАТЬ
	|		ТоварыНаСкладахОстатки.Номенклатура КАК НоменклатураСО, 
	|		ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатурыСО, 
	|		ТоварыНаСкладахОстатки.Склад КАК СкладСО, 
	|		СУММА(ТоварыНаСкладахОстатки.КоличествоОстаток - ВЫБОР КОГДА ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток ЕСТЬ NULL ТОГДА 0 ИНАЧЕ ТоварыВРезервеНаСкладахОстатки.КоличествоОстаток КОНЕЦ) КАК СвободныйОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыНаСкладах.Остатки(&ДатаКон
	//, {Номенклатура.*, Склад.*}
	|)КАК ТоварыНаСкладахОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыВРезервеНаСкладах.Остатки(&ДатаКОн
	//, {Номенклатура.*, Склад.*}
	|) КАК ТоварыВРезервеНаСкладахОстатки
	|				ПО ТоварыНаСкладахОстатки.Номенклатура = ТоварыВРезервеНаСкладахОстатки.Номенклатура
	|				И ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры = ТоварыВРезервеНаСкладахОстатки.ХарактеристикаНоменклатуры
	|				И ТоварыНаСкладахОстатки.Склад = ТоварыВРезервеНаСкладахОстатки.Склад
	|
	|	СГРУППИРОВАТЬ ПО ТоварыНаСкладахОстатки.Номенклатура, ТоварыНаСкладахОстатки.ХарактеристикаНоменклатуры, ТоварыНаСкладахОстатки.Склад) КАК СвободныеОстатки
	|		ПО СвободныеОстатки.НоменклатураСО = ВнутреннийЗапрос.Номенклатура
	|		И СвободныеОстатки.ХарактеристикаНоменклатурыСО = ВнутреннийЗапрос.ХарактеристикаНоменклатуры
	|		И СвободныеОстатки.СкладСО = ВнутреннийЗапрос.Склад
	|
	|}
	|{
	|ГДЕ 
	|	Номенклатура.*, 
	|	Склад.*, 
	|	ХарактеристикаНоменклатуры
	|,	(ВЫБОР Когда СвободныеОстатки.СвободныйОстаток ЕСТЬ NULL Тогда Ложь Когда СвободныеОстатки.СвободныйОстаток>0 Тогда Истина Иначе Ложь КОНЕЦ) КАК НаличиеСвободногоОстатка
	|
	|}
	|ИТОГИ
	|	СУММА(КоличествоОстаток),
	|	СУММА(КоличествоВРезерве),
	|	СУММА(КоличествоКПолучению),
	|	СУММА(КоличествоКПередаче),
	|	СУММА(СвободныйОстаток)
	|ПО ОБЩИЕ, Склад, Номенклатура
	|{
	|ИТОГИ ПО
	|	Номенклатура.*,
	|	ХарактеристикаНоменклатуры.*,
	|	Склад.*,
	|	ДокументОснование.*
	|}
	|";
	//УниверсальныйОтчет.ЗаполнитьНачальныеНастройкиПоМетаданнымрегистра(СтруктураПредставлениеПолей, МассивОтбора);
	МассивОтбора.Добавить("Номенклатура");
	МассивОтбора.Добавить("Склад");
	
	ОбщийОтчет.ЗаполнитьПоказатели("КоличествоОстаток", "Остаток в ед. хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("КоличествоВРезерве", "Зарезервировано в ед. хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("КоличествоКПолучению", "Количество неотфактурованного товара в ед. хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("КоличествоКПередаче", "Количество товара, к передаче в ед. хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	ОбщийОтчет.ЗаполнитьПоказатели("СвободныйОстаток", "Свободный остаток в ед. хранения остатков", Истина, "ЧЦ=15; ЧДЦ=3");
	
	ОбщийОтчет.ВыводитьИтогиПоВсемУровням = Истина;
	
	СтруктураПредставлениеПолей.Вставить("ХарактеристикаНоменклатуры", "Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("ДокументОснование", "Документ-основание");
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	ПустаяСтруктура = Новый Структура;
	
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("КоличествоОстаток", ПустаяСтруктура);
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("КоличествоВРезерве", ПустаяСтруктура);
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("КоличествоКПолучению", ПустаяСтруктура);
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("КоличествоКПередаче", ПустаяСтруктура);
	ОбщийОтчет.мСтруктураСвязиПоказателейИИзмерений.Вставить("СвободныйОстаток", ПустаяСтруктура);
	
	ОбщийОтчет.ВыводитьПоказателиВСтроку = Истина;
	
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

ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
ОбщийОтчет.мРежимВводаПериода = 1;