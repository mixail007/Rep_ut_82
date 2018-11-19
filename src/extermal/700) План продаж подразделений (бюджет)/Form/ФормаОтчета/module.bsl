﻿
Процедура ДействияФормысформировать1(Кнопка)
    перем ДанныеРасшифровки1;
	Результат3 = ПолучитьБонусы(Истина, ПериодПланирования.ДатаНачала, КонецДня(ПериодПланирования.ДатаКонца));
	Таб = Результат3.ТаблицаБонусов;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таб.НоменклатурнаяГруппа,
		|	Таб.Производитель,
		|	Таб.Бонус,
		|	Таб.Период
		|ПОМЕСТИТЬ Бонусы
		|ИЗ
		|	&Таб КАК Таб
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Бонусы.НоменклатурнаяГруппа,
		|	Бонусы.Производитель,
		|	СРЕДНЕЕ(Бонусы.Бонус) КАК Бонус,
		|	Бонусы.Период
		|ПОМЕСТИТЬ Бонусы1
		|ИЗ
		|	Бонусы КАК Бонусы
		|
		|СГРУППИРОВАТЬ ПО
		|	Бонусы.НоменклатурнаяГруппа,
		|	Бонусы.Производитель,
		|	Бонусы.Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ) КАК Период
		|ПОМЕСТИТЬ НачалоМесяцев
		|ИЗ
		|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
		|ГДЕ
		|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &Начпериода И &конпериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(Бонусы1.Период) КАК Период,
		|	НачалоМесяцев.Период КАК НачалоМесяца,
		|	Бонусы1.НоменклатурнаяГруппа,
		|	Бонусы1.Производитель
		|ПОМЕСТИТЬ ПодборкаДата
		|ИЗ
		|	НачалоМесяцев КАК НачалоМесяцев
		|		ЛЕВОЕ СОЕДИНЕНИЕ Бонусы1 КАК Бонусы1
		|		ПО НачалоМесяцев.Период >= Бонусы1.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	НачалоМесяцев.Период,
		|	Бонусы1.Производитель,
		|	Бонусы1.НоменклатурнаяГруппа
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ  различные
		|	Бонусы1.НоменклатурнаяГруппа,
		|	Бонусы1.Производитель,
		|	Бонусы1.Бонус,
		|	Бонусы1.Период,
		|	ПодборкаДата.НачалоМесяца
		|ИЗ
		|	Бонусы1 КАК Бонусы1
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПодборкаДата КАК ПодборкаДата
		|		ПО Бонусы1.Период = ПодборкаДата.Период
		|			И Бонусы1.НоменклатурнаяГруппа = ПодборкаДата.НоменклатурнаяГруппа
		|			И Бонусы1.Производитель = ПодборкаДата.Производитель";

	Запрос.УстановитьПараметр("Начпериода", ПериодПланирования.ДатаНачала);
	Запрос.УстановитьПараметр("конпериода", КонецДня(ПериодПланирования.ДатаКонца));
	Запрос.УстановитьПараметр("Таб", Таб);

	Результат2 = Запрос.Выполнить().Выгрузить();



	Запрос = Новый Запрос;
	Запрос.Текст = 
	 	"ВЫБРАТЬ
	 	|	Таб.Бонус,
	 	|	Таб.НачалоМесяца,
	 	|	Таб.НоменклатурнаяГруппа,
	 	|	Таб.Производитель
	 	|ПОМЕСТИТЬ Бонусы
	 	|ИЗ
	 	|	&Таб КАК Таб
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	СРЕДНЕЕ(Бонусы.Бонус) КАК Бонус,
	 	|	Бонусы.НачалоМесяца,
	 	|	Бонусы.НоменклатурнаяГруппа
	 	|ПОМЕСТИТЬ БонусыПоНГ
	 	|ИЗ
	 	|	Бонусы КАК Бонусы
	 	|ГДЕ
	 	|	НЕ Бонусы.НоменклатурнаяГруппа В (&НоменклатурнаяГруппа)
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	Бонусы.НачалоМесяца,
	 	|	Бонусы.НоменклатурнаяГруппа
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	Бонусы.Бонус,
	 	|	Бонусы.НачалоМесяца,
	 	|	Бонусы.НоменклатурнаяГруппа,
	 	|	Бонусы.Производитель
	 	|ПОМЕСТИТЬ БонусыПоНГиПроизводителю
	 	|ИЗ
	 	|	Бонусы КАК Бонусы
	 	|ГДЕ
	 	|	Бонусы.НоменклатурнаяГруппа В(&НоменклатурнаяГруппа)
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	ХозрасчетныйОборотыДтКт.Менеджер,
	 	|	ХозрасчетныйОборотыДтКт.СубконтоДт1,
	 	|	ХозрасчетныйОборотыДтКт.СубконтоДт2,
	 	|	СУММА(ХозрасчетныйОборотыДтКт.СуммаОборот) КАК СуммаОборот,
	 	|	СУММА(ВЫБОР
	 	|			КОГДА ХозрасчетныйОборотыДтКт.СчетКт = &счет42
	 	|				ТОГДА ХозрасчетныйОборотыДтКт.СуммаОборот
	 	|			ИНАЧЕ 0
	 	|		КОНЕЦ) КАК СуммаНаценка,
	 	|	СУММА(ХозрасчетныйОборотыДтКт.КоличествоОборотКт) КАК КоличествоОборотДт
	 	|ПОМЕСТИТЬ ПланРТГ
	 	|ИЗ
	 	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(, , , СчетДт = &Сч, , СчетКт В (&Счета), , ПериодПланирования = &ПериодПланирования) КАК ХозрасчетныйОборотыДтКт
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	ХозрасчетныйОборотыДтКт.СубконтоДт2,
	 	|	ХозрасчетныйОборотыДтКт.Менеджер,
	 	|	ХозрасчетныйОборотыДтКт.СубконтоДт1
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	ПланРТГ.Менеджер,
	 	|	ПланРТГ.СубконтоДт1,
	 	|	СУММА(ПланРТГ.СуммаОборот) КАК СуммаОборот,
	 	|	СУММА(ПланРТГ.СуммаНаценка) КАК СуммаНаценка,
	 	|	СУММА(ПланРТГ.КоличествоОборотДт) КАК КоличествоОборотДт
	 	|ПОМЕСТИТЬ ПланРТГпоНГ
	 	|ИЗ
	 	|	ПланРТГ КАК ПланРТГ
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	ПланРТГ.СубконтоДт1,
	 	|	ПланРТГ.Менеджер
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа,
	 	|	ПолугодовойПланДепертаментаПродаж.НаправлениеПродаж.Подразделение,
	 	|	СУММА(ПолугодовойПланДепертаментаПродаж.КоличествоПлан) КАК КоличествоПлан,
	 	|	СУММА(ПолугодовойПланДепертаментаПродаж.СуммаПлан) КАК СуммаПлан,
	 	|	СУММА(ПолугодовойПланДепертаментаПродаж.Количество) КАК Количество,
	 	|	СУММА(ПолугодовойПланДепертаментаПродаж.СуммаНаценкиПлан) КАК СуммаНаценкиПлан,
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа.Родитель,
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа.Ответственный,
	 	|	ПолугодовойПланДепертаментаПродаж.НаправлениеПродаж
	 	|ПОМЕСТИТЬ ПланПодразделений
	 	|ИЗ
	 	|	РегистрСведений.ПолугодовойПланДепертаментаПродаж КАК ПолугодовойПланДепертаментаПродаж
	 	|ГДЕ
	 	|	ПолугодовойПланДепертаментаПродаж.ПериодПланирования = &ПериодПланирования
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа,
	 	|	ПолугодовойПланДепертаментаПродаж.НаправлениеПродаж.Подразделение,
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа.Родитель,
	 	|	ПолугодовойПланДепертаментаПродаж.НоменклатурнаяГруппа.Ответственный,
	 	|	ПолугодовойПланДепертаментаПродаж.НаправлениеПродаж
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	СУММА(ПродажиОбороты.КоличествоОборот) КАК КоличествоОборот,
	 	|	ДОБАВИТЬКДАТЕ(ПродажиОбороты.Период, ГОД, 1) КАК период,
	 	|	ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа
	 	|ПОМЕСТИТЬ ПродажиПоМесяцам
	 	|ИЗ
	 	|	РегистрНакопления.Продажи.Обороты(&НачПериода, &КонПериода, Месяц, ) КАК ПродажиОбороты
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	ПродажиОбороты.Период,
	 	|	ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	СУММА(ПродажиПоМесяцам.КоличествоОборот) КАК КоличествоОборот,
	 	|	ПродажиПоМесяцам.НоменклатураНоменклатурнаяГруппа
	 	|ПОМЕСТИТЬ ПродажиПериода
	 	|ИЗ
	 	|	ПродажиПоМесяцам КАК ПродажиПоМесяцам
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	ПродажиПоМесяцам.НоменклатураНоменклатурнаяГруппа
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	ПланПодразделений.НоменклатурнаяГруппа,
	 	|	ПланПодразделений.НаправлениеПродажПодразделение,
	 	|	ПланПодразделений.КоличествоПлан * (ПродажиПоМесяцам.КоличествоОборот / ПродажиПериода.КоличествоОборот) КАК КоличествоПлан,
	 	|	ПланПодразделений.СуммаПлан * (ПродажиПоМесяцам.КоличествоОборот / ПродажиПериода.КоличествоОборот) КАК СуммаПлан,
	 	|	ПланПодразделений.СуммаНаценкиПлан * (ПродажиПоМесяцам.КоличествоОборот / ПродажиПериода.КоличествоОборот) КАК НаценкаПлан,
	 	|	ПланПодразделений.НоменклатурнаяГруппаРодитель,
	 	|	ПланПодразделений.НоменклатурнаяГруппаОтветственный,
	 	|	ПланПодразделений.НаправлениеПродаж,
	 	|	ПродажиПоМесяцам.период,
	 	|	(ПланПодразделений.СуммаПлан * (ПродажиПоМесяцам.КоличествоОборот / ПродажиПериода.КоличествоОборот) - ПланПодразделений.СуммаНаценкиПлан * (ПродажиПоМесяцам.КоличествоОборот / ПродажиПериода.КоличествоОборот)) * ЕСТЬNULL(БонусыПоНГ.Бонус, 0) / 100 КАК СуммаБонуса
	 	|ПОМЕСТИТЬ План
	 	|ИЗ
	 	|	ПланПодразделений КАК ПланПодразделений
	 	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиПоМесяцам КАК ПродажиПоМесяцам
	 	|			ЛЕВОЕ СОЕДИНЕНИЕ БонусыПоНГ КАК БонусыПоНГ
	 	|			ПО ПродажиПоМесяцам.период = БонусыПоНГ.НачалоМесяца
	 	|				И ПродажиПоМесяцам.НоменклатураНоменклатурнаяГруппа = БонусыПоНГ.НоменклатурнаяГруппа
	 	|		ПО ПланПодразделений.НоменклатурнаяГруппа = ПродажиПоМесяцам.НоменклатураНоменклатурнаяГруппа
	 	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиПериода КАК ПродажиПериода
	 	|		ПО ПланПодразделений.НоменклатурнаяГруппа = ПродажиПериода.НоменклатураНоменклатурнаяГруппа
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	План.НаправлениеПродажПодразделение,
	 	|	СУММА(План.КоличествоПлан * (ПланРТГ.КоличествоОборотДт / ПланРТГпоНГ.КоличествоОборотДт)) КАК Количество,
	 	|	СУММА(План.СуммаПлан * (ПланРТГ.КоличествоОборотДт / ПланРТГпоНГ.КоличествоОборотДт)) КАК Сумма,
	 	|	СУММА(План.НаценкаПлан * (ПланРТГ.КоличествоОборотДт / ПланРТГпоНГ.КоличествоОборотДт)) КАК Наценка,
	 	|	План.НоменклатурнаяГруппаОтветственный,
	 	|	План.НаправлениеПродаж,
	 	|	План.период,
	 	|	ПланРТГ.СубконтоДт1,
	 	|	ПланРТГ.СубконтоДт2,
	 	|	План.СуммаБонуса
	 	|ПОМЕСТИТЬ Итого
	 	|ИЗ
	 	|	ПланРТГ КАК ПланРТГ
	 	|		ЛЕВОЕ СОЕДИНЕНИЕ План КАК План
	 	|		ПО (ВЫБОР
	 	|				КОГДА ПланРТГ.СубконтоДт1.ЭтоГруппа
	 	|					ТОГДА ПланРТГ.СубконтоДт1 = План.НоменклатурнаяГруппаРодитель
	 	|				ИНАЧЕ ПланРТГ.СубконтоДт1 = План.НоменклатурнаяГруппа
	 	|			КОНЕЦ)
	 	|			И (План.НоменклатурнаяГруппаОтветственный = ПланРТГ.Менеджер)
	 	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланРТГпоНГ КАК ПланРТГпоНГ
	 	|		ПО ПланРТГ.Менеджер = ПланРТГпоНГ.Менеджер
	 	|			И ПланРТГ.СубконтоДт1 = ПланРТГпоНГ.СубконтоДт1
	 	|
	 	|СГРУППИРОВАТЬ ПО
	 	|	План.НоменклатурнаяГруппаОтветственный,
	 	|	ПланРТГ.СубконтоДт1,
	 	|	План.НаправлениеПродаж,
	 	|	План.НаправлениеПродажПодразделение,
	 	|	План.период,
	 	|	ПланРТГ.СубконтоДт2,
	 	|	План.СуммаБонуса
	 	|;
	 	|
	 	|////////////////////////////////////////////////////////////////////////////////
	 	|ВЫБРАТЬ
	 	|	Итого.НаправлениеПродажПодразделение КАК Подразделение,
	 	|	Итого.Количество,
	 	|	Итого.Сумма,
	 	|	Итого.Наценка,
	 	|	Итого.НоменклатурнаяГруппаОтветственный КАК Менеджер,
	 	|	Итого.НаправлениеПродаж,
	 	|	Итого.период,
	 	|	Итого.СубконтоДт1 КАК НоменклатурнаяГруппа,
	 	|	Итого.СубконтоДт2 КАК Производитель,
	 	|	ВЫБОР
	 	|		КОГДА Итого.СубконтоДт1 В (&НоменклатурнаяГруппа)
	 	|			ТОГДА (Итого.Сумма - Итого.Наценка) * ЕСТЬNULL(БонусыПоНГиПроизводителю.Бонус, 0) / 100
	 	|		ИНАЧЕ Итого.СуммаБонуса
	 	|	КОНЕЦ КАК СуммаБонуса
	 	|ИЗ
	 	|	Итого КАК Итого
	 	|		ЛЕВОЕ СОЕДИНЕНИЕ БонусыПоНГиПроизводителю КАК БонусыПоНГиПроизводителю
	 	|		ПО Итого.СубконтоДт1 = БонусыПоНГиПроизводителю.НоменклатурнаяГруппа
	 	|			И Итого.СубконтоДт2 = БонусыПоНГиПроизводителю.Производитель
	 	|			И Итого.период = БонусыПоНГиПроизводителю.НачалоМесяца";			
	
	
	
	Запрос.УстановитьПараметр("Начпериода", ДобавитьМесяц(ПериодПланирования.ДатаНачала,-12));
	Запрос.УстановитьПараметр("конпериода", КонецДня(ДобавитьМесяц(ПериодПланирования.ДатаКонца,-12)));
	Запрос.УстановитьПараметр("Таб", Результат2);
	Запрос.УстановитьПараметр("счет42", планысчетов.Хозрасчетный.ТорговаяНаценка);
	Запрос.УстановитьПараметр("сч", планысчетов.Хозрасчетный.РасчетыСПокупателями);
	Запрос.УстановитьПараметр("ПериодПланирования", ПериодПланирования);
	список = новый списокЗначений;
	список.Добавить(планысчетов.Хозрасчетный.ТорговаяНаценка);
	список.Добавить(планысчетов.Хозрасчетный.ТоварыНаСкладах);
		Запрос.УстановитьПараметр("счета", список);
	списокН = новый списокЗначений;
	списокН.Добавить(справочники.НоменклатурныеГруппы.НайтиПоКоду("00016"));
	списокН.Добавить(справочники.НоменклатурныеГруппы.НайтиПоКоду("00017"));
		Запрос.УстановитьПараметр("номенклатурнаяГруппа", списокН);
		Результат1 = Запрос.Выполнить().Выгрузить();
	
		
	ЭлементыФормы.Результат.Очистить();	
	СхемаКомпоновкиДанных = ПолучитьМакет("макет");
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
 //  МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,СхемаКомпоновкиДанных.НастройкиПоУмолчанию, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,СхемаКомпоновкиДанных.НастройкиПоУмолчанию, ДанныеРасшифровки1);
	ВнешнийНаборДанных = Новый Структура("Результат1", Результат1);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;

	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ВнешнийНаборДанных, ,истина);
	ПроцессорВывода.УстановитьДокумент(ЭлементыФормы.Результат);
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
//	Результат.ПоказатьУровеньГруппировокСтрок(0);

	

КонецПроцедуры
