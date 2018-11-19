﻿
Процедура ДействияФормыДействие(Кнопка)
	
//Цены РРЦ для не шин...
запрос1 = новый Запрос;	
запрос1.текст = "ВЫБРАТЬ
                |	остатки.Номенклатура
                |ИЗ
                |	РегистрНакопления.ТоварыНаСкладах.Остатки(
                |			&КонПериода,
                |			Склад.ЗапретитьИспользование = ЛОЖЬ
                |				И Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Диски)) КАК остатки
                |ГДЕ
                |	остатки.КоличествоОстаток > 0";
запрос1.УстановитьПараметр("КонПериода", КонПериода);

состояние("Идет поиск дисков на складах за дату...");
табл1 = запрос1.Выполнить().Выгрузить();	

контрРРЦ = справочники.Контрагенты.НайтиПоКоду("11011");
СписТов  = табл1.ВыгрузитьКолонку("Номенклатура");
состояние("Идет поиск цен "+строка(контрРРЦ)+" для "+строка( СписТов.Количество() )+" дисков...");
ТабЦен = ОбменСУТИнтернетМагазин.ПолучитьЦеныДляКонтрагента_РегСв(контрРРЦ, СписТов);

//=================Основной Запрос!========================
запрос = новый Запрос;
запрос.УстановитьПараметр("ТипЦенРРЦ", справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00025")); //МРИЦ

запрос.УстановитьПараметр("КонецПериода", КонПериода);

запрос.УстановитьПараметр("ТабЦен", ТабЦен); // пред.цены!

запрос.Текст = "ВЫБРАТЬ
               |	ррц.Номенклатура,
               |	ррц.МинимальнаяЦена КАК Цена
               |ПОМЕСТИТЬ ВТ_РРЦ
               |ИЗ
               |	&ТабЦен КАК ррц
               |;
               |
               |////////////////////////////////////////////////////////////////////////////////
               |ВЫБРАТЬ
               |	ВТРРЦ.Номенклатура,
               |	Среднее(ЕСТЬNULL(ВТРРЦ.Цена, 0)) КАК ЦенаМРИЦ,
               |	Среднее(ВЫБОР
               |			КОГДА ЕСТЬNULL(ПартииСебестоимость.КоличествоОстаток, 0) = 0
               |				ТОГДА ЕСТЬNULL(ПартииСебестоимость.СтоимостьОстаток, 0)
               |			ИНАЧЕ ВЫРАЗИТЬ(ПартииСебестоимость.СтоимостьОстаток / ПартииСебестоимость.КоличествоОстаток КАК ЧИСЛО(15, 2))
               |		КОНЕЦ) КАК ЦенаСебестоимость,
               |	Среднее(ЕСТЬNULL(ВТРРЦ.Цена, 0) - ВЫБОР
               |			КОГДА ПартииСебестоимость.КоличествоОстаток = 0
               |				ТОГДА ПартииСебестоимость.СтоимостьОстаток
               |			ИНАЧЕ ВЫРАЗИТЬ(ПартииСебестоимость.СтоимостьОстаток / ПартииСебестоимость.КоличествоОстаток КАК ЧИСЛО(15, 2))
               |		КОНЕЦ) КАК РазностьСебестМРИЦ
               |ИЗ
               |	ВТ_РРЦ КАК ВТРРЦ
               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровНаСкладах.Остатки(, Номенклатура в (выбрать ВТ_РРЦ.Номенклатура из ВТ_РРЦ) ) КАК ПартииСебестоимость
               |		ПО ВТРРЦ.Номенклатура = ПартииСебестоимость.Номенклатура
               |
               |СГРУППИРОВАТЬ ПО
               |	ВТРРЦ.Номенклатура";
ТабРРЦ = запрос.Выполнить().Выгрузить();

ВнешниеНаборыДанных = Новый Структура;
ВнешниеНаборыДанных.Вставить("ТабРРЦ",ТабРРЦ);

//====================изменение запроса================================================ 
состояние("Идет формирование запроса с учетом отборов для "+строка( ТабРРЦ.Количество() )+" товаров...");
 	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных"), ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных 
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата 
	ДокументРезультат=ЭлементыФормы.Результат;
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	Состояние(" ");	
	

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	КонПериода = КонецДня( ТекущаяДата() );
    
КонецПроцедуры
 