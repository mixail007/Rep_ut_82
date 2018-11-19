﻿
Процедура ДействияФормыДействие6(Кнопка)
	СКДНастроек = ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ТекстЗапроса = СКДНастроек.НаборыДанных.НаборДанных1.Запрос;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
	
	"ВЫБРАТЬ
	|	ДАТАВРЕМЯ(2017, 1, 1) КАК Период,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК Номенклатура,
	|	0 КАК Бонус
	|ПОМЕСТИТЬ втБонусы",
	ПолучитьБонусы(ложь).ТекстЗапросаБонусы);
	
	ЭлементыФормы.Результат.Очистить();
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ЭтотОбъект.СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных,   ЭтотОбъект.КомпоновщикНастроек.Настройки, ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ЭлементыФормы.Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
КонецПроцедуры
