﻿ перем Уровень;
Процедура КнопкаВыполнитьНажатие(Кнопка)
текСхема = ПолучитьМакет("СКД");
КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
//КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;

   //Настройки = текСхема.НастройкиПоУмолчанию;
   
   Настройки = КомпоновщикНастроек.Настройки;

   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("Период");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = Дата;
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ДатаНач;
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ДатаКон;
   Если Склад = справочники.Подразделения.НайтиПоКоду("00138")  Тогда
   ПодразделенияЕкат = Новый СписокЗначений;
   ПодразделенияЕкат.Добавить(Справочники.Подразделения.НайтиПоКоду("00138"));
   ПодразделенияЕкат.Добавить(Справочники.Подразделения.НайтиПоКоду("00122"));
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеФилиала");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ПодразделенияЕкат;
   иначе
   подразделенияФилиал = Новый СписокЗначений;
   подразделенияФилиал.Добавить(Склад);
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеФилиала");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = подразделенияФилиал;
   конецЕсли;
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеЦентр");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = СкладОтправитель;
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ТипЦен");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ТипЦены;
   
   Если склад = Справочники.Подразделения.НайтиПоКоду("00106")       Тогда  //Ростов
	   ПодразделениеКонтрагент = Справочники.Контрагенты.НайтиПоКоду("93187");
	иначеЕсли склад = Справочники.Подразделения.НайтиПоКоду("00138")      Тогда   //Екат
	   ПодразделениеКонтрагент = Справочники.Контрагенты.НайтиПоКоду("93801");
	иначеЕсли склад = Справочники.Подразделения.НайтиПоКоду("00133")      Тогда  //Москва
	   ПодразделениеКонтрагент = Справочники.Контрагенты.НайтиПоКоду("92903");
	иначеЕсли склад = Справочники.Подразделения.НайтиПоКоду("00112")      Тогда //Питер
	   ПодразделениеКонтрагент = Справочники.Контрагенты.НайтиПоКоду("П000835");
  Конецесли;	   
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеКонтрагент");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ПодразделениеКонтрагент;
	   

КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);

МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(текСхема, КомпоновщикНастроек.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));

ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
//ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, Новый Структура("ТЧБП", БП.СогласованиеПлатежа));// Здесь передается внешний набор данных. ТЧ бизнес-процесса 
ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
Дерево.Строки.Очистить();
Дерево.Колонки.Очистить();
ПроцессорВывода.УстановитьОбъект(Дерево);// ДеревоРезультата - дерево значений 
ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Ложь);
ЭлементыФормы.ДеревоД.СоздатьКолонки();
Для Каждого колонка из ЭлементыФормы.ДеревоД.колонки Цикл
	Если Колонка.Ширина> 10 Тогда
		Колонка.Ширина = 1;
	конецесли;	
конецЦикла;	
Для каждого Строка Из ЭлементыФормы.ДеревоД.Значение.Строки Цикл 
ЭлементыФормы.ДеревоД.Развернуть(Строка,Истина); 
КонецЦикла;
ЭтаФорма.Обновить();
УстановитьВидимость();
КонецПроцедуры


Процедура ПриОткрытии()
Дата = ТекущаяДата();
СкладОтправитель = Справочники.Подразделения.НайтиПоКоду("00005");
склад = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение; 
Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя")Тогда
	ЭлементыФормы.Склад.Доступность = Ложь;
	ЭлементыФормы.СкладОтправитель.Доступность = Ложь;
конецЕсли;	

текСхема = ПолучитьМакет("СКД");
Настройки = текСхема.НастройкиПоУмолчанию;
КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(текСхема));
КомпоновщикНастроек.ЗагрузитьНастройки(текСхема.НастройкиПоУмолчанию);

 Цена = Истина;	
Продано = Истина;	
ОстатокФилиал = Истина;
СвободныйОстатокФилиал = Истина;
ОстатокФилиал = Истина;
ОстатокСклад = Истина;
СвободныйОстатокСклад = Истина;
РезервФилиала = Истина;
ВПути = Истина;
ОстатокИМ = Истина;
КонецПроцедуры


Процедура ОсновныеДействияФормыСформироватьЗаказ(Кнопка)
	Док = Документы.ЗаказПокупателя.СоздатьДокумент();
	Док.контрагент = Справочники.Контрагенты.НайтиПоКоду("36092");
	// Создаем дополнительный заказ для товара, с запрещенным типоразмером
	ДокЗапрещенный = Документы.ЗаказПокупателя.СоздатьДокумент();
	ДокЗапрещенный.контрагент = Справочники.Контрагенты.НайтиПоКоду("36092");

	//Док.ДоговорКонтрагента = Док.Контрагент.ОсновнойДоговорКонтрагента;
	//Док.Проверен = истина;
    Док.Дата = ТекущаяДата();
	Для каждого Строка Из ЭлементыФормы.ДеревоД.Значение.Строки Цикл 
		ЗаполнитьПоЗначениюСтрокиДерева(Строка,Док.Товары,ДокЗапрещенный.Товары);
	КонецЦикла;
	Док.Организация = Справочники.Организации.НайтиПоКоду("00001");
	Док.Транзит = Истина;
	Док.Подразделение = Склад;
	Док.Склад = Склад.Склад;
	
	//Сакулина
	ДокЗапрещенный.Организация = Справочники.Организации.НайтиПоКоду("00001");
	ДокЗапрещенный.Транзит = Истина;
	ДокЗапрещенный.Подразделение = Склад;
	ДокЗапрещенный.Склад = Склад.Склад;
    ДокЗапрещенный.ТипЗаказа = 13;
	ДокЗапрещенный.Комментарий = " Заказ на запрещенный типоразмер, нужно согласование Доколина";
	//Док.Записать();

	Док.ПолучитьФорму().Открыть();	
	//Сакулина
	Если ДокЗапрещенный.Товары.Количество() > 0 Тогда
		ДокЗапрещенный.ПолучитьФорму().Открыть();
	КонецЕсли;
	
КонецПроцедуры



Процедура ВыбПериодНажатие1(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(ДатаНач, ?(ДатаКон='0001-01-01', ДатаКон, КонецДня(ДатаКон)));
	Если НастройкаПериода.Редактировать() Тогда
		ДатаНач = НастройкаПериода.ПолучитьДатуНачала();
		ДатаКон = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры


Процедура ДеревоДПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
ОбновитьИтоговуюНадпись();	
КонецПроцедуры

Процедура ОбновитьИтоговуюНадпись()
Вес=0;
Объем=0;
Стоимость=0;
Для каждого Строка Из ЭлементыФормы.ДеревоД.Значение.Строки Цикл 
ПрочитатьЗначениеСтрокиДерева(Строка,Вес,Объем,Стоимость) 
КонецЦикла;
ЭлементыФормы.Итого.Заголовок = "Итого: Вес "+ Вес+" кг. Объем "+Объем+" м3. Стоимость "+Стоимость+" руб.";

конецПроцедуры
 Функция ПрочитатьЗначениеСтрокиДерева(СтрокаДерева,Вес,Объем,Стоимость)
   Для Каждого Строка Из СтрокаДерева.Строки Цикл
	   Если строка.Заказать<>Null и строка.Заказать<>Неопределено Тогда
		   Если  строка.Заказать>0 Тогда
			Вес = Вес + Строка.Номенклатура.ЕдиницаХраненияОстатков.Вес*строка.Заказать;
			Объем = Объем + Строка.Номенклатура.ЕдиницаХраненияОстатков.Объем*строка.Заказать;
			Стоимость = Стоимость+?(строка.Цена=Null,0,строка.Цена)*строка.Заказать;
	      конецЕсли;
	  конецЕсли;	
      ПрочитатьЗначениеСтрокиДерева(Строка,Вес,Объем,Стоимость);

   КонецЦикла;
КонецФункции

Функция ЗаполнитьПоЗначениюСтрокиДерева(СтрокаДерева,Таблица,ТаблицаЗапрещенный);
   Для Каждого Строка Из СтрокаДерева.Строки Цикл
	   Если строка.Заказать<>Null и строка.Заказать<>Неопределено Тогда
		   Если  строка.Заказать>0 Тогда
			   Типоразмер = Строка.Номенклатура.Типоразмер;
			   НоменклатурнаяГруппа = Строка.Номенклатура.НоменклатурнаяГруппа;
			   Запрещенный = ПроверитьЗапрещенныйТипоразмер(Типоразмер,НоменклатурнаяГруппа);
			   Если Запрещенный = Истина Тогда
				   НовСтр = ТаблицаЗапрещенный.Добавить();
			   Иначе
				   НовСтр = Таблица.Добавить();
			   КонецЕсли;
			   НовСтр.номенклатура = строка.номенклатура;
			   НовСтр.ЕдиницаИзмерения = строка.номенклатура.ЕдиницаХраненияОстатков;
			   НовСтр.Количество = строка.заказать;
			   НовСтр.Вес = Строка.Номенклатура.ЕдиницаХраненияОстатков.Вес*строка.Заказать;
			   НовСтр.Коэффициент = 1;
			   НовСтр.СтавкаНдс = Перечисления.СтавкиНДС.НДС18;
			   НовСтр.Сумма = ?(строка.цена=null,0,строка.цена)*строка.заказать;
			   НовСтр.СуммаНДС = Окр(НовСтр.Сумма/118*18,2);
			   НовСтр.цена = строка.цена;   
		   конецЕсли;
	  конецЕсли;	
      ЗаполнитьПоЗначениюСтрокиДерева(Строка,Таблица,ТаблицаЗапрещенный);
   КонецЦикла;
КонецФункции

Процедура СкладПриИзменении(Элемент)
	   Настройки = КомпоновщикНастроек.Настройки;

   Если Склад = справочники.Подразделения.НайтиПоКоду("00138")  Тогда
   ПодразделенияЕкат = Новый СписокЗначений;
   ПодразделенияЕкат.Добавить(Справочники.Подразделения.НайтиПоКоду("00138"));
   ПодразделенияЕкат.Добавить(Справочники.Подразделения.НайтиПоКоду("00122"));
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеФилиала");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = ПодразделенияЕкат;
   иначе
   подразделенияФилиал = Новый СписокЗначений;
   подразделенияФилиал.Добавить(Склад);
   ПараметрСКД = Настройки.ПараметрыДанных.Элементы.Найти("ПодразделениеФилиала");
   ПараметрСКД.Использование = Истина;
   ПараметрСКД.Значение  = подразделенияФилиал;
   конецЕсли;
КонецПроцедуры

Процедура УровеньГруппировкиПриИзменении(Элемент)
	Для каждого Строка Из ЭлементыФормы.ДеревоД.Значение.Строки Цикл 
		ЭлементыФормы.ДеревоД.Свернуть(Строка); 
	КонецЦикла;
	Если Уровеньгруппировки>1 Тогда
		Для каждого Строка Из ЭлементыФормы.ДеревоД.Значение.Строки Цикл 
			Уровень=1;
			РазвернутьДерево(Строка,Уровень); 
		КонецЦикла;
	конецЕсли;
КонецПроцедуры
функция РазвернутьДерево(СтрокаДерева,Уровень)
	    ЭлементыФормы.ДеревоД.Развернуть(СтрокаДерева,Ложь); 
        уровень=Уровень+1;
	пока Уровень < Уровеньгруппировки Цикл
				Для каждого строка из строкаДерева.Строки Цикл
			РазвернутьДерево(Строка,Уровень);
		КонецЦикла;
	конецЦикла;
конецФункции

Процедура ЦенаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура ПроданоПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура ОстатокФилиалПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура СвободныйОстатокФилиалПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура ОстатокСкладПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура СвободныйОстатокСкладПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура РезервФилиалаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

Процедура ВПутиПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

процедура УстановитьВидимость()
Если ЭлементыФормы.ДеревоД.Колонки.Количество()>0 Тогда	
ЭлементыФормы.ДеревоД.Колонки.Цена.видимость = Цена;	
ЭлементыФормы.ДеревоД.Колонки.Продано.видимость = Продано;	
ЭлементыФормы.ДеревоД.Колонки.ОстатокФилиал.видимость = ОстатокФилиал;
ЭлементыФормы.ДеревоД.Колонки.СвободныйОстатокФилиал.видимость = СвободныйОстатокФилиал;
ЭлементыФормы.ДеревоД.Колонки.ОстатокФилиал.видимость = ОстатокФилиал;
ЭлементыФормы.ДеревоД.Колонки.ОстатокЦентр.видимость = ОстатокСклад;
ЭлементыФормы.ДеревоД.Колонки.СвободныйОстатокЦентр.видимость = СвободныйОстатокСклад;
ЭлементыФормы.ДеревоД.Колонки.РезервФилиала.видимость = РезервФилиала;
ЭлементыФормы.ДеревоД.Колонки.ВПути.видимость = ВПути;
ЭлементыФормы.ДеревоД.Колонки.ОстатокИМ.видимость = ОстатокИМ;

конецЕсли;
конецПроцедуры	

Процедура ОстатокИМПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

// + Сакулина
Функция ПроверитьЗапрещенныйТипоразмер(Типоразмер,НоменклатурнаяГруппа)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗапрещенныеТипоРазмеры.Типоразмер,
	|	ЗапрещенныеТипоРазмеры.ПроцентПродаж,
	|	ЗапрещенныеТипоРазмеры.НоменклатурнаяГруппа
	|ИЗ
	|	РегистрСведений.ЗапрещенныеТипоразмеры КАК ЗапрещенныеТипоРазмеры
	|ГДЕ
	|	ЗапрещенныеТипоРазмеры.Типоразмер = &Типоразмер
	|	И ЗапрещенныеТипоРазмеры.НоменклатурнаяГруппа = &НоменклатурнаяГруппа";
	Запрос.УстановитьПараметр("Типоразмер",Типоразмер);
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа",НоменклатурнаяГруппа);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат  Истина;
	Иначе
		Возврат  Ложь;
	КонецЕсли;
КонецФункции