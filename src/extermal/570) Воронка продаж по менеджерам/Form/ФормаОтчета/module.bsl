﻿
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	ЭлементРасшифровкиДанных = ДанныеРасшифровки.Элементы[Расшифровка];
	ЭлементРасшифровкиДанныхПоля = ЭлементРасшифровкиДанных.ПолучитьПоля()[0];
	Если  ЭлементРасшифровкиДанныхПоля.Поле = "КоличествоЗвонков"  тогда
		Контрагент = ДанныеРасшифровки.Элементы[Расшифровка-1].ПолучитьПоля()[0].Значение;
		СтандартнаяОбработка = Ложь;
		ТД = ПолучитьТаблицуЗвонков(3, Контрагент,ДобавитьМесяц(ТекущаяДата(),-6),ТекущаяДата());
		ТД.Открыть();
		
	иначе
		Стандартнаяобработка = Истина;
	конецЕсли;	
	
	
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура СформироватьНажатие(Элемент)
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	СхемаКомпоновкиДанных = ПолучитьМакет("Макет");
	ПараметрСКД = СхемаКомпоновкиДанных.Параметры.ДатаНачала;
	ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	ПараметрСКД.Значение  = НачПериода;
	ПараметрСКД = СхемаКомпоновкиДанных.Параметры.ДатаОкончания;
	ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	ПараметрСКД.Значение  = КонецДня(КонПериода);
	ПараметрСКД = СхемаКомпоновкиДанных.Параметры.ПервичныйКонтрагент;
    ПараметрСКД.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
    ПараметрСКД.Значение  = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90230");

	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, СхемаКомпоновкиДанных.НастройкиПоУмолчанию, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки,истина);
	ЭлементыФормы.Динамика.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ЭлементыФормы.Динамика);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

Процедура ПриОткрытии()
	НачПериода = ДобавитьМесяц(ТекущаяДата(),-12);
	конПериода = КонецДня(ТекущаяДата());
	
	НачПериода1 = ДобавитьМесяц(ТекущаяДата(),-6);
	конПериода1 = КонецДня(ТекущаяДата());
	
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = НачПериода1;
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = КонецДня(КонПериода1);


КонецПроцедуры

Процедура ВыбПериодНажатие1(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачПериода1, ?(КонПериода1='0001-01-01', КонПериода1, КонецДня(КонПериода1)));
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода1 = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода1 = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = НачПериода1;
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = КонецДня(КонПериода1);

КонецПроцедуры

Процедура НачПериода1ПриИзменении(Элемент)
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = НачПериода1;

КонецПроцедуры

Процедура КонПериода1ПриИзменении(Элемент)
   ПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = КонецДня(КонПериода1);

КонецПроцедуры
