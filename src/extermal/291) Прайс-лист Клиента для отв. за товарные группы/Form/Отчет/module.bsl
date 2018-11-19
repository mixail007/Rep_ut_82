﻿Перем t; //текущая дата

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ОтчетИнициализация();
	ТипЦен = 1;
	ПоОстаткам = истина;
	ВидТовара  = перечисления.ВидыТоваров.Диски;
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьЗначение("НастройкаВнешниеОтчетыПрайсЛист_ПоПравиламОтчет_b94a1904-9df5-4d1f-9710-2058e82468e5", ПостроительОтчетаОтчет.ПолучитьНастройки());
	
КонецПроцедуры

Процедура ДействияФормыОтчетНастройка(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Форма = ВнешнийОтчетОбъект.ПолучитьФорму("ОтчетНастройка");
	Форма.ПостроительОтчета = ПостроительОтчетаОтчет;
	Настройка = ПостроительОтчетаОтчет.ПолучитьНастройки();
	Если Форма.ОткрытьМодально() = Истина Тогда
		ОтчетВывести();
	Иначе
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;
	
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА
КонецПроцедуры

Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	t=ТекущаяДата();
	ОтчетВывести();
	сообщить("Время выполнения: "+строка(ТекущаяДата()-t)+"сек.");
	
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура ОтчетВывести()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	ЭлементыФормы.ПолеТабличногоДокумента.Очистить();
	
	//ПостроительОтчетаОтчет.Выполнить();
	ПостроительОтчетаОтчет.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Вместе;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВСтроках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВКолонках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.Классика);
	
	
	
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ
	
	
	//===================================================================
	Если ПоОстаткам тогда
		
		запросПоОстаткам = новый запрос;
		
		Если ВидТовара=Перечисления.ВидыТоваров.ПустаяСсылка() тогда
			состояние("Выполняется запрос по остаткам товаров по настройке...");	
			запросПоОстаткам = ПостроительОтчетаОтчет.ПолучитьЗапрос(); //вместе с параметрами
		иначе
			запросПоОстаткам.Текст =
			"ВЫБРАТЬ
			|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура
			|ИЗ
			|	РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура.ВидТовара = &ВидТовара
			|			и (НЕ Склад.Транзитный)
			|				И (НЕ Склад.ЗапретитьИспользование)) КАК ТоварыНаСкладахОстатки";
			запросПоОстаткам.Параметры.Вставить("ВидТовара",ВидТовара);
		КонецЕсли;
		табЗнач = запросПоОстаткам.Выполнить().Выгрузить();
		списНом = новый СписокЗначений;
		списНом.ЗагрузитьЗначения( табЗнач.ВыгрузитьКолонку("Номенклатура") );
		
	Иначе// по всей номенклатуре
		списНом = неопределено;
	КонецЕсли; 
	
	//===================================================================
	//ПолучитьЦеныДляКонтрагента_РегСв(Контрагент,СписокНоменклатуры=неопределено, получитьПравилаИПараметры=ЛОЖЬ, ТекущаяПолитикаПравила=неопределено) 
	
	состояние(" ");	
	
	Если НЕ Контрагент=справочники.Контрагенты.ПустаяСсылка() тогда
		ТипЦен = 1; // скидки персональные + скидки общие
		ТекущаяПолитикаПравила = неопределено;
	Иначе
		//--------------общие правила с макс скидкой---------------
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ПравилаЦенообразованияОбщие.Приоритет,
		|	ПравилаЦенообразованияОбщие.ВидТовара,
		|	ПравилаЦенообразованияОбщие.Производитель,
		|	ПравилаЦенообразованияОбщие.НоменклатурнаяГруппа,
		|	ПравилаЦенообразованияОбщие.ВходитВПапку,
		|	ПравилаЦенообразованияОбщие.Диаметр,
		|	ПравилаЦенообразованияОбщие.Номенклатура,
		|	ПравилаЦенообразованияОбщие.ТипЦен,
		|	ПравилаЦенообразованияОбщие.ПодСтрока,
		|0 //типЦен
		//|	ПравилаЦенообразованияОбщие.СкидкаНаценка КАК СкидкаНаценка
		//|	ПравилаЦенообразованияОбщие.СкидкаНаценкаКрОпт КАК СкидкаНаценка
		//|	ПравилаЦенообразованияОбщие.МаксСкидкаНаценка 
		|КАК СкидкаНаценка
		|ИЗ
		|	РегистрСведений.ПравилаЦенообразованияОбщие КАК ПравилаЦенообразованияОбщие";
		
		Если ТипЦен=1 тогда
			Запрос.Текст = стрЗаменить(Запрос.Текст , "0 //типЦен", "ПравилаЦенообразованияОбщие.СкидкаНаценка");
		ИначеЕсли ТипЦен=2 тогда
			Запрос.Текст = стрЗаменить(Запрос.Текст , "0 //типЦен", "ПравилаЦенообразованияОбщие.СкидкаНаценкаКрОпт");
		ИначеЕсли ТипЦен=3 тогда
			Запрос.Текст = стрЗаменить(Запрос.Текст , "0 //типЦен", "ПравилаЦенообразованияОбщие.МаксСкидкаНаценка");
		КонецЕсли;
		Результат = Запрос.Выполнить();
		ТекущаяПолитикаПравила = Результат.Выгрузить();
	КонецЕсли;
	
	состояние("Получение таблицы цен по выбранным условиям...");
	Если ПолучитьДокПолитикиЦенообразования()= неопределено тогда
		ТабЗнач = ОбменСУТИнтернетМагазин.ПолучитьЦеныДляКонтрагента_РегСв(Контрагент, списНом,,ТекущаяПолитикаПравила); 
	Иначе  //-----------------------------расчет по политике ценообразования----------------------------------------
		Если списНом=неопределено тогда
			запросПоОстаткам = новый запрос;
			запросПоОстаткам.Текст ="ВЫБРАТЬ
			|	Номенклатура.Ссылка как Номенклатура
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	(НЕ Номенклатура.ПометкаУдаления)
			|	И (НЕ Номенклатура.ЭтоГруппа)
			|"+?(ЗначениеЗаполнено(ВидТовара)," И Номенклатура.ВидТовара = &ВидТовара ","");
			запросПоОстаткам.Параметры.Вставить("ВидТовара",ВидТовара);
			списНом = новый СписокЗначений;
			списНом.ЗагрузитьЗначения( запросПоОстаткам.Выполнить().Выгрузить().ВыгрузитьКолонку("Номенклатура"));
		КонецЕсли;	
		ТабЗнач = ОбменСУТИнтернетМагазин.ПолучитьЦеныДляКонтрагента(Контрагент, списНом); 
	КонецЕсли;	
	//--------------------вывод----------------------------
	//ТабЗнач.Сортировать("Номенклатура");
	//табДок = новый ТабличныйДокумент; 	//ЭлементыФормы.ПолеТабличногоДокумента;
	//
	//макет = этотОбъект.ПолучитьМакет("Макет");
	//ОбластьШапка= Макет.ПолучитьОбласть("Шапка");
	//ОбластьШапка.Параметры.ПараметрыОтбора = ?(НЕ Контрагент=справочники.Контрагенты.ПустаяСсылка(),"Цены клиента: "+строка(Контрагент),
	//?(ТипЦен=0, "Общие правила - без скидок;", ?(ТипЦен=1, "Общие правила - скидки;", ?(ТипЦен=2, "Общие правила - скидки Кр.Опт;", 
	//	"Общие правила - скидки Макс.Скидки;"))))
	//+ ?(НЕ ПоОстаткам, " Вся номенклатура.", " По остаткам на складах.");
	//ТабДок.Вывести(ОбластьШапка);
	//ОбластьШапка= Макет.ПолучитьОбласть("ШапкаТаблицы");
	//ТабДок.Вывести(ОбластьШапка);
	//
	//ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	//N = ТабЗнач.Количество(); проц=макс(цел(N/100), 1);
	//состояние(" ");
	
	//для i=0 по N-1 цикл
	//	ОбработкаПрерыванияПользователя();
	//	стр1 = ТабЗнач[i];
	//	ЗаполнитьЗначенияСвойств(ОбластьСтрока.Параметры, стр1);
	//	ОбластьСтрока.Параметры.N = i+1;
	//	ОбластьСтрока.Параметры.Код = стр1.Номенклатура.Код;
	//	ТабДок.Вывести(ОбластьСтрока);
	//	Если i%проц=0 тогда
	//		состояние(строка(окр(i*100/N,0))+"% строк выведено...");
	//	КонецЕсли;	
	//КонецЦикла;   
	
	//--------------быстрый вывод через построитель--------------------------
	ПоВидамТоваров = (ВидТовара=перечисления.ВидыТоваров.ПустаяСсылка());
	Запрос2 = новый Запрос;
	Запрос2.Текст = "
	|ВЫБРАТЬ	Номенклатура, МинимальнаяЦена, Приоритет
	|ПОМЕСТИТЬ ВТ_табЗнач
	|ИЗ &табЗнач КАК табЗнач;
	|////////////////////////////////////////////////////////////////////////////////
	|Выбрать ВЗ.Код, ВЗ.Номенклатура, ВЗ.Цена, ВЗ.Приоритет, ВЗ.Себестоимость, 
	|	ВЫБОР
	|		КОГДА ВЗ.Себестоимость > ВЗ.Цена
	|			ТОГДА ВЫРАЗИТЬ((1-ВЗ.Цена/ВЗ.Себестоимость)*100 КАК ЧИСЛО(10, 2))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Процент,
	|	ВЗ.Остаток
	|ИЗ
	|(ВЫБРАТЬ
	|	НоменклатураСпр.Код,
	|	НоменклатураСпр.Ссылка КАК Номенклатура,
	|	ВТ_табЗнач.МинимальнаяЦена КАК Цена,
	|	ВТ_табЗнач.Приоритет КАК Приоритет,
	|	ВЫБОР
	|		КОГДА ПартииТоваровНаСкладахОстатки.КоличествоОстаток = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫРАЗИТЬ(ПартииТоваровНаСкладахОстатки.СтоимостьОстаток / ПартииТоваровНаСкладахОстатки.КоличествоОстаток КАК ЧИСЛО(10, 0))
	|	КОНЕЦ КАК Себестоимость,
	|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК Остаток
	|ИЗ
	|	ВТ_табЗнач КАК ВТ_табЗнач
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК НоменклатураСпр
	|		ПО ВТ_табЗнач.Номенклатура = НоменклатураСпр.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&ТекДата) КАК ПартииТоваровНаСкладахОстатки
	|		ПО ВТ_табЗнач.Номенклатура = ПартииТоваровНаСкладахОстатки.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&ТекДата) КАК ТоварыНаСкладахОстатки
	|		ПО ВТ_табЗнач.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура) КАК ВЗ 
	|УПОРЯДОЧИТЬ ПО
	|	ВЗ.Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	запрос2.Параметры.Вставить("табЗнач",табЗнач);
	запрос2.Параметры.Вставить("ТекДата",t);
	//Если ПоВидамТоваров тогда
	//	Запрос2.Текст = стрЗаменить(Запрос2.Текст, "//ПоВидамТоваров",""); 
	//КонецЕсли;	   
	табЗнач2 = запрос2.Выполнить().Выгрузить();
	
	//------------еще быстрее---------------------
	//ТабЗнач.Сортировать("Номенклатура");
	//табЗнач2 = табЗнач;
	
	ПострПечать = Новый ПостроительОтчета;
	ПострПечать.ИсточникДанных = Новый ОписаниеИсточникаДанных(табЗнач2);
	
	ПострПечать.Выполнить();
	Для каждого Колонка Из ПострПечать.ВыбранныеПоля Цикл
		Если Колонка.Имя="МинимальнаяЦена" тогда Колонка.Представление ="Цена, руб."
		Иначе Колонка.Представление = табЗнач2.Колонки[Колонка.Имя].Заголовок;
		КонецЕсли;	
	КонецЦикла; 
	
	ПострПечать.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Вместе;
	ПострПечать.РазмещениеРеквизитовИзмеренийВСтроках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПострПечать.РазмещениеРеквизитовИзмеренийВКолонках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПострПечать.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.Классика);
	ПострПечать.Вывести(ЭлементыФормы.ПолеТабличногоДокумента); 
	
	//шапка прайс-листа
	ЭлементыФормы.ПолеТабличногоДокумента.Область(1,3,1,3).Текст = "Прайс-лист ЗАО ТК ""Яршинторг""";
	ЭлементыФормы.ПолеТабличногоДокумента.Область(1,3,1,3).Шрифт = новый Шрифт("ARIAL", 14, Истина);
	
	ЭлементыФормы.ПолеТабличногоДокумента.Область(2,3,2,3).текст = ?(НЕ Контрагент=справочники.Контрагенты.ПустаяСсылка(),"Цены клиента: "+строка(Контрагент),
	?(ТипЦен=0, "Общие правила - без скидок;", ?(ТипЦен=1, "Общие правила - скидки;", ?(ТипЦен=2, "Общие правила - скидки Кр.Опт;", 
	"Общие правила - скидки Макс.Скидки;"))))
	+ ?(НЕ ПоОстаткам, " Вся номенклатура ", " По остаткам на складах ") + строка(ВидТовара) + "
	|"+строка(ПостроительОтчетаОтчет.Отбор);
	ЭлементыФормы.ПолеТабличногоДокумента.Область(2,3,2,3).Шрифт = новый Шрифт("ARIAL", 10);
	
	//ширина колонок в символах
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,2,4+табЗнач2.Количество(),2).ШиринаКолонки = 9; //Код
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,3,4+табЗнач2.Количество(),3).ШиринаКолонки = 50;
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,4,4+табЗнач2.Количество(),4).ШиринаКолонки = 9;
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,5,4+табЗнач2.Количество(),5).ШиринаКолонки = 11;
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,6,4+табЗнач2.Количество(),6).ШиринаКолонки = 15;//Себестоимость
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,7,4+табЗнач2.Количество(),7).ШиринаКолонки = 11;//Процент
	ЭлементыФормы.ПолеТабличногоДокумента.Область(4,7,4+табЗнач2.Количество(),8).ШиринаКолонки = 11;//Остаток
	//автовысота строк
	ЭлементыФормы.ПолеТабличногоДокумента.Область(5,2,5+табЗнач2.Количество(),5).АвтоВысотаСтроки = истина;
	
	Если ПревышениеСебестоимостиКрасным Тогда
		i = 0;
		ЦветФона = Новый Цвет(255, 0, 0); // красный
		
		Пока i < табЗнач2.Количество() Цикл
			Если Число(ЭлементыФормы.ПолеТабличногоДокумента.Область(5+i,4).Текст) < Число(ЭлементыФормы.ПолеТабличногоДокумента.Область(5+i,6).Текст) Тогда 
				ЭлементыФормы.ПолеТабличногоДокумента.Область(5+i,2,5+i,8).ЦветФона = ЦветФона;	
			КонецЕсли;
			i=i+1;
		КонецЦикла;
	КонецЕсли;
	
	состояние(" ");	
КонецПроцедуры

Процедура ОтчетИнициализация()
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	ПостроительОтчетаОтчет.Текст =
	"ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(,(НЕ Склад.Транзитный) И (НЕ Склад.ЗапретитьИспользование)
	|		) КАК ТоварыНаСкладахОстатки
	|ГДЕ
	|	ТоварыНаСкладахОстатки.КоличествоОстаток > 0";
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет";
	Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыПрайсЛист_ПоПравиламОтчет_b94a1904-9df5-4d1f-9710-2058e82468e5");
	Если Настройка <> Неопределено Тогда
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;
	
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры

Процедура ВидТовараПриИзменении(Элемент)
	ЭлементыФормы.ДействияФормы.Кнопки.Настройка.доступность = (ВидТовара = перечисления.ВидыТоваров.ПустаяСсылка());
КонецПроцедуры

Процедура КонтрагентПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Контрагент) тогда
		политика = ПолучитьДокПолитикиЦенообразования();
		Если политика <> неопределено тогда
			ЭтаФорма.Заголовок = "Отчет - Прайс-Лист по документу: "+строка(Политика);
		иначе
			ЭтаФорма.Заголовок = "Отчет - Прайс-Лист по Правилам ценообразования";
		КонецЕсли;	
		ТипЦен = 1; 
		ЭлементыФормы.ТипЦен.Доступность = ложь;ЭлементыФормы.Переключатель1.Доступность = ложь;ЭлементыФормы.Переключатель3.Доступность = ложь;
	Иначе
		ЭтаФорма.Заголовок = "Отчет - Прайс-Лист по Правилам ценообразования";
		ЭлементыФормы.ТипЦен.Доступность = истина;ЭлементыФормы.Переключатель1.Доступность = истина;ЭлементыФормы.Переключатель3.Доступность = истина;
	КонецЕсли;	
	
	
КонецПроцедуры

функция ПолучитьДокПолитикиЦенообразования()
	Если Контрагент.Пустая() тогда
		возврат Неопределено;
	КонецЕсли;	
	
	ЗапросПоискПолитики=Новый Запрос;	
	
	ЗапросПоискПолитики.Текст ="ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПолитикаЦенообразования.Ссылка
	|ИЗ
	|	Документ.ПолитикаЦенообразования КАК ПолитикаЦенообразования
	|ГДЕ
	|	ПолитикаЦенообразования.Контрагент = &Контрагент
	|	И ПолитикаЦенообразования.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПолитикаЦенообразования.Дата УБЫВ";
	
	ЗапросПоискПолитики.УстановитьПараметр("Контрагент",Контрагент);
	
	РезультатПолитика= ЗапросПоискПолитики.Выполнить();
	
	Если РезультатПолитика.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		ВыборкаПолитика=РезультатПолитика.Выбрать();
		ВыборкаПолитика.Следующий();
		ТекущаяПолитика=ВыборкаПолитика.Ссылка;
		возврат ТекущаяПолитика;
	КонецЕсли;	     // для контрагента нет политики ценообразования
	
	
КонецФункции



