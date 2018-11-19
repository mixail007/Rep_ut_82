﻿
Перем ПараметрДанныхНачалоПериода, ПараметрДанныхКонецПериода,
		Завод ;

Процедура ДатаНачалаПриИзменении(Элемент)
	
	ПараметрДанныхНачалоПериода.Значение = ДатаНачала;	
	
КонецПроцедуры

Процедура ДатаОкончанияПриИзменении(Элемент)
	
	ПараметрДанныхКонецПериода.Значение = КонецДня(ДатаОкончания);
	
КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)

	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(ДатаНачала, ?(ДатаОкончания='0001-01-01', ДатаОкончания, КонецДня(ДатаОкончания)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		ДатаНачала = НастройкаПериода.ПолучитьДатуНачала();
		ДатаОкончания = НастройкаПериода.ПолучитьДатуОкончания();
		ПараметрДанныхНачалоПериода.Значение = ДатаНачала;	
		ПараметрДанныхКонецПериода.Значение = КонецДня(ДатаОкончания);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВариантОтчетаПриИзменении(Элемент)
	
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек.Найти(Элемент.Значение).Настройки);
	УстановитьДоступность();
	
КонецПроцедуры

//01.10.2018
функция ПолучитьСписокПоСвву()
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
|	ЗначенияСвойствОбъектов.Объект как Контр
|ИЗ
|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
|ГДЕ
|	ЗначенияСвойствОбъектов.Свойство = &Свойство
|	И ЗначенияСвойствОбъектов.Значение = ИСТИНА";
Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90354") );  //Проверка дисков (Литые +1%)
Результат = Запрос.Выполнить();
табл = Результат.Выгрузить();
спис = новый СписокЗначений;
спис.ЗагрузитьЗначения(табл.ВыгрузитьКолонку("Контр") );

//+++ 02.10.2018 - доп.список --- без изменения ценообразования!
масКод = новый Массив;
масКод.Добавить("92226");//Группа Бринэкс, 
масКод.Добавить("00128");//Пауэр
масКод.Добавить("П004535");//АВТОДОК ООО (Горелов)
масКод.Добавить("П000053");//Автобам Сервис ООО
масКод.Добавить("П012322");//ГАЛАКТИКА-ПРОФ ООО (Авто ТО)
масКод.Добавить("П017269");//М-Склад
масКод.Добавить("92498");//Шинсервис (Москва)
//--->масКод.Добавить("92905");//Лантратов Д.А.
масКод.Добавить("93346");//Эксклюзив
масКод.Добавить("П001552");//Мосавтошина 04.10.2018

для ii=0 по масКод.Количество()-1 цикл
спис.Добавить(справочники.Контрагенты.НайтиПоКоду(масКод[ii]));
КонецЦикла;
спис.СортироватьПоЗначению();
возврат спис;
КонецФункции


Процедура ПриОткрытии()
	
	
	Для Каждого ВариантНастроек Из СхемаКомпоновкиДанных.ВариантыНастроек Цикл
		ЭлементыФормы.ВариантОтчета.СписокВыбора.Добавить(ВариантНастроек.Имя, ВариантНастроек.Представление);
	КонецЦикла;
	Если СхемаКомпоновкиДанных.ВариантыНастроек.Количество() > 0 Тогда
		ЭлементыФормы.ВариантОтчета.Значение = СхемаКомпоновкиДанных.ВариантыНастроек[0].Имя;
	КонецЕсли;	
	
	СписокКлиентов = ПолучитьСписокПоСвву();  //01.10.2018
	
	//пред.месяц
	ДатаНачала    = НачалоМесяца(НачалоМесяца(ТекущаяДата())-1);
	ДатаОкончания = НачалоМесяца(ТекущаяДата())-1;
	Цена 	 = 10;
	ЦенаМарк = 10;
	ЦенаУстр = 20;
	ЦенаПоКлиентам = 20;
	ЦенаЗаДиск = 600;
	
    Сумма6 = 60000;//ФИКС!?
	
	УстановитьДоступность();
	
	СхемаКомпоновкиДанных = ЭтотОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	УстановитьНастройки();
	КлючУникальности = 1;
	
//сразу формировать:	ДействияФормыРасчет(неопределено);
	
КонецПроцедуры

Процедура УстановитьДоступность()
		
	//Если ЭлементыФормы.ВариантОтчета.Значение = СхемаКомпоновкиДанных.ВариантыНастроек[0].Имя Тогда
	//	
	//	ЭлементыФормы.ЦенаНадпись.Доступность = Истина;
	//	ЭлементыФормы.Цена.Доступность = Истина;
	//	
	//	ЭлементыФормы.ЦенаМаркНадпись.Доступность = ложь;
	//	ЭлементыФормы.ЦенаМарк.Доступность = ложь;
	//	
	//	ЭлементыФормы.ЦенаУстрНадпись.Доступность = ложь;
	//	ЭлементыФормы.ЦенаУстр.Доступность = ложь;
	////	Предупреждение("Введите Цену за проверку 1 товара.",30);
	//ИначеЕсли ЭлементыФормы.ВариантОтчета.Значение = СхемаКомпоновкиДанных.ВариантыНастроек[1].Имя Тогда
	//	
	//	ЭлементыФормы.ЦенаНадпись.Доступность = ложь;
	//	ЭлементыФормы.Цена.Доступность = ложь;
	//	
	//	ЭлементыФормы.ЦенаМаркНадпись.Доступность = Истина;
	//	ЭлементыФормы.ЦенаМарк.Доступность = Истина;
	//	
	//	ЭлементыФормы.ЦенаУстрНадпись.Доступность = ложь;
	//	ЭлементыФормы.ЦенаУстр.Доступность = ложь;
	//	Предупреждение("Введите Цену за маркировку 1шт.",30);
	//иначе
	//	ЭлементыФормы.ЦенаНадпись.Доступность = ложь;
	//	ЭлементыФормы.Цена.Доступность = ложь;
	//	
	//	ЭлементыФормы.ЦенаМаркНадпись.Доступность = ложь;
	//	ЭлементыФормы.ЦенаМарк.Доступность = ложь;
	//	
	//	ЭлементыФормы.ЦенаУстрНадпись.Доступность = Истина;
	//	ЭлементыФормы.ЦенаУстр.Доступность = истина;
	//	Предупреждение("Введите Цену за устранение 1шт.",30);
	//КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьНастройки()
	
	ПараметрДанныхНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[0];
	ПараметрДанныхНачалоПериода.Значение = ДатаНачала;
	ПараметрДанныхНачалоПериода.Использование = Истина;
	
	ПараметрДанныхКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[1];
	ПараметрДанныхКонецПериода.Значение = КонецДня(ДатаОкончания);
	ПараметрДанныхКонецПериода.Использование = Истина;
	
	
	ПараметрЦена = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[6];
	ПараметрЦена.Значение = Цена;
	ПараметрЦена.Использование = Истина;
	
	ПараметрЦена = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[7];
	ПараметрЦена.Значение = ЦенаМарк;
	ПараметрЦена.Использование = Истина;
	
	ПараметрЦена = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[8];
	ПараметрЦена.Значение = ЦенаУстр;
	ПараметрЦена.Использование = Истина;
	
	ПараметрЦена = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[11];
	ПараметрЦена.Значение = ЦенаПоКлиентам;
	ПараметрЦена.Использование = Истина;

	ПараметрЦена = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы[14];
	ПараметрЦена.Значение = ЦенаЗаДиск;
	ПараметрЦена.Использование = Истина;

	//ОтборДанныхПодразделение = КомпоновщикНастроек.Настройки.Отбор.Элементы[0];
	
	Настройки = КомпоновщикНастроек.Настройки;
		
КонецПроцедуры

Процедура ДействияФормыДействие(Кнопка)
	
	Настройки = КомпоновщикНастроек.Настройки;
	//ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	ПараметрДанныхНачалоПериода = Настройки.ПараметрыДанных.Элементы.Найти("НачалоПериода");
	ПараметрДанныхНачалоПериода.Значение = ДатаНачала;
	ПараметрДанныхНачалоПериода.Использование = Истина;
	
	ПараметрДанныхНачалоПериода = Настройки.ПараметрыДанных.Элементы.Найти("КонецПериода");
	ПараметрДанныхНачалоПериода.Значение = КонецДня(ДатаОкончания);
	ПараметрДанныхНачалоПериода.Использование = Истина;
	
	ПараметрДанныхСвойство = Настройки.ПараметрыДанных.Элементы.Найти("Свойство"); 
	ПараметрДанныхСвойство.Значение = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90255"); //остаток проверен
	ПараметрДанныхСвойство.Использование = Истина;
	
	ПараметрДанныхСклад = Настройки.ПараметрыДанных.Элементы.Найти("Склад");
	ПараметрДанныхСклад.Значение = Справочники.Склады.НайтиПоКоду("02316"); //ангар-ремонт
	ПараметрДанныхСклад.Использование = Истина;
	
	ПараметрДанныхСвойствоЗавод = Настройки.ПараметрыДанных.Элементы.Найти("Завод");
	ПараметрДанныхСвойствоЗавод.Значение = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90185");   //Завод для Терминала
	ПараметрДанныхСвойствоЗавод.Использование = Истина;
	
	СписокСкладовИсключений = Новый СписокЗначений;
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02340")); //Ангар-ремонт Устранение
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02235")); //К-3/53 устранение (Брак)
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02332")); //Ангар-Ремонт Тест
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("00211")); //Литер - 2
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("00278")); //1
	ПараметрДанныхСписокСкладовИсключений = Настройки.ПараметрыДанных.Элементы.Найти("СписокСкладовИсключений");
	ПараметрДанныхСписокСкладовИсключений.Значение = СписокСкладовИсключений;
	ПараметрДанныхСписокСкладовИсключений.Использование = Истина;
	
	//+++( 23.04.2018
	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("Цена");
	ПараметрЦена.Значение = Цена;
	ПараметрЦена.Использование = истина;
	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("ЦенаМарк");
	ПараметрЦена.Значение = ЦенаМарк;
	ПараметрЦена.Использование = истина;
	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("ЦенаУстр");
	ПараметрЦена.Значение = ЦенаУстр;
	ПараметрЦена.Использование = истина;

	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("СкладАнгарРемУстр");
	ПараметрЦена.Значение = Справочники.Склады.НайтиПоКоду("02340");  //Ангар-ремонт Устранение
	ПараметрЦена.Использование = истина;
	
	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("СкладБрак");
	ПараметрЦена.Значение = справочники.Склады.НайтиПоКоду("02235"); //К-3/53 устранение (Брак)
	ПараметрЦена.Использование = истина;
	
 //+++)
 
 
 //+++( 04.05.2018  -----------------------------------------------------------------
   	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("ЦенаПоКлиентам");
    ПараметрЦена.Значение = ЦенаПоКлиентам;
    ПараметрЦена.Использование = истина;
	
	ПараметрЛитые = Настройки.ПараметрыДанных.Элементы.Найти("Литые");
	ПараметрЛитые.Значение = справочники.НоменклатурныеГруппы.НайтиПоКоду("00026"); //литые
	ПараметрЛитые.Использование = истина;
	
 	ПараметрСписокКлиентов = Настройки.ПараметрыДанных.Элементы.Найти("СписокКлиентов");
    ПараметрСписокКлиентов.Значение = СписокКлиентов;
    ПараметрСписокКлиентов.Использование = истина;
//+++)

	ПараметрЦена = Настройки.ПараметрыДанных.Элементы.Найти("ЦенаЗаДиск");
	ПараметрЦена.Значение = ЦенаЗаДиск;
	ПараметрЦена.Использование = истина;

	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	//МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, ,ДанныеРасшифровки);	
	
	ЭлементыФормы.Результат.Очистить();
	ДокументРезультат = ЭлементыФормы.Результат;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
			
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(2);	
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(1);
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(0);
	
КонецПроцедуры

//=====================================================
функция получитьСумма1()
   Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	                 |	ПровереннаяНагрузкаДисков.Номенклатура.Код КАК КодПроверка,
	                 |	ПровереннаяНагрузкаДисков.Номенклатура КАК НоменклатураПроверка,
	                 |	МАКСИМУМ(ПровереннаяНагрузкаДисков.Дата) КАК ДатаПроверка,
	                 |	МАКСИМУМ(ПровереннаяНагрузкаДисков.ТестПройден) КАК ТестПройденПроверка,
	                 |	МАКСИМУМ(ПровереннаяНагрузкаДисков.ПрошедшаяНагрузка) КАК ПрошедшаяНагрузкаПроверка,
	                 |	МАКСИМУМ(ПровереннаяНагрузкаДисков.НомерПартии) КАК НомерПартии,
	                 |	МАКСИМУМ(ПровереннаяНагрузкаДисков.НомерКонтейнера) КАК НомерКонтейнера,
	                 |	МАКСИМУМ(ЗначенияСвойствОбъектов.Значение) КАК Завод,
	                 |	МАКСИМУМ(&Цена) КАК Сумма1
	                 |ИЗ
	                 |	РегистрСведений.ПровереннаяНагрузкаДисков КАК ПровереннаяНагрузкаДисков
	                 |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                 |		ПО ПровереннаяНагрузкаДисков.Номенклатура = ЗначенияСвойствОбъектов.Объект
	                 |			И (ЗначенияСвойствОбъектов.Свойство = &Завод)
	                 |ГДЕ
	                 |	ПровереннаяНагрузкаДисков.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	                 |
	                 |СГРУППИРОВАТЬ ПО
	                 |	ПровереннаяНагрузкаДисков.Номенклатура.Код,
	                 |	ПровереннаяНагрузкаДисков.Номенклатура
	                 |ИТОГИ
	                 |	СУММА(Сумма1)
	                 |ПО
	                 |	ОБЩИЕ";
	Запрос.УстановитьПараметр("НачалоПериода",ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
		
	  Запрос.УстановитьПараметр("Цена", Цена);
	  Запрос.УстановитьПараметр("Завод", Завод);   //Завод для Терминала
	  
	  Результат = Запрос.Выполнить();
	  выборкаСумма1=0;
	Если не Результат.Пустой() тогда
	  Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	  Выборка.Следующий();
	  выборкаСумма1 = Выборка.Сумма1;
	КонецЕсли;  
	возврат выборкаСумма1;
КонецФункции	

функция получитьСумма2()
		 Запрос2 = Новый Запрос;
	  Запрос2.Текст = "ВЫБРАТЬ различные
	                  |	А.Код,
	                  |	А.Номенклатура,
	                  |	А.Диаметр,
	                  |	А.КоличествоПеремаркировано,
	                  |	ЗначенияСвойствОбъектов.Значение КАК ОстатокПроверен,
	                  |	ЕСТЬNULL(ПроверкаНагрузки.ТестПройден, ""Не проводился"") КАК ТестПройден,
	                  |	ЕСТЬNULL(ПроверкаНагрузки.ПрошедшаяНагрузка, 0) КАК ПрошедшаяНагрузка,
	                  |	А.КоличествоПеремаркировано * &ЦенаМарк КАК СуммаМарк
	                  |ИЗ
	                  |	(ВЫБРАТЬ
	                  |		ТоварыНаСкладахОбороты.Номенклатура.Код КАК Код,
	                  |		ТоварыНаСкладахОбороты.Номенклатура КАК Номенклатура,
	                  |		ТоварыНаСкладахОбороты.Номенклатура.Типоразмер.Диаметр КАК Диаметр,
	                  |		СУММА(ТоварыНаСкладахОбороты.КоличествоРасход) КАК КоличествоПеремаркировано
	                  |	ИЗ
	                  |		РегистрНакопления.ТоварыНаСкладах.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Склад = &Склад) КАК ТоварыНаСкладахОбороты
	                  |	ГДЕ
	                  |		ТоварыНаСкладахОбороты.Регистратор ССЫЛКА Документ.ПеремещениеТоваров
	                  |		И НЕ ТоварыНаСкладахОбороты.Регистратор.СкладПолучатель В (&СписокСкладовИсключений)
	                  |	
	                  |	СГРУППИРОВАТЬ ПО
	                  |		ТоварыНаСкладахОбороты.Номенклатура,
	                  |		ТоварыНаСкладахОбороты.Номенклатура.Код,
	                  |		ТоварыНаСкладахОбороты.Номенклатура.Типоразмер.Диаметр) КАК А
	                  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                  |		ПО А.Номенклатура = ЗначенияСвойствОбъектов.Объект
	                  |			И (ЗначенияСвойствОбъектов.Свойство = &Свойство)
	                  |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                  |			ПровереннаяНагрузкаДисков.Номенклатура КАК Номенклатура,
	                  |			ПровереннаяНагрузкаДисков.ТестПройден КАК ТестПройден,
	                  |			ПровереннаяНагрузкаДисков.Дата КАК ДатаТеста,
	                  |			ПровереннаяНагрузкаДисков.ПрошедшаяНагрузка КАК ПрошедшаяНагрузка,
	                  |			ПровереннаяНагрузкаДисков.Номенклатура.Код КАК НоменклатураКод
	                  |		ИЗ
	                  |			РегистрСведений.ПровереннаяНагрузкаДисков КАК ПровереннаяНагрузкаДисков
	                  |				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	                  |					МАКСИМУМ(ПровереннаяНагрузкаДисков.Дата) КАК ДатаТеста,
	                  |					ПровереннаяНагрузкаДисков.Номенклатура КАК Номенклатура
	                  |				ИЗ
	                  |					РегистрСведений.ПровереннаяНагрузкаДисков КАК ПровереннаяНагрузкаДисков
	                  |				
	                  |				СГРУППИРОВАТЬ ПО
	                  |					ПровереннаяНагрузкаДисков.Номенклатура) КАК ПоследняяПроверка
	                  |				ПО ПровереннаяНагрузкаДисков.Номенклатура = ПоследняяПроверка.Номенклатура
	                  |					И ПровереннаяНагрузкаДисков.Дата = ПоследняяПроверка.ДатаТеста) КАК ПроверкаНагрузки
	                  |		ПО А.Номенклатура = ПроверкаНагрузки.Номенклатура
	                  |ГДЕ
	                  |	ЗначенияСвойствОбъектов.Значение = ИСТИНА
	                  |ИТОГИ
	                  |	СУММА(СуммаМарк)
	                  |ПО
	                  |	ОБЩИЕ";
	Запрос2.УстановитьПараметр("ЦенаМарк", ЦенаМарк);
	Запрос2.УстановитьПараметр("НачалоПериода",ДатаНачала);
	Запрос2.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
	Запрос2.УстановитьПараметр("Склад", Справочники.Склады.НайтиПоКоду("02316") ); //ангар-ремонт
	Запрос2.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90255") ); //остаток проверен
	
	СписокСкладовИсключений = Новый СписокЗначений;
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02340")); //Ангар-ремонт Устранение
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02235")); //К-3/53 устранение (Брак)
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("02332")); //Ангар-Ремонт Тест
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("00211")); //Литер - 2
	СписокСкладовИсключений.Добавить(Справочники.Склады.НайтиПоКоду("00278")); //1
	Запрос2.УстановитьПараметр("СписокСкладовИсключений", СписокСкладовИсключений);
	
	  Результат = Запрос2.Выполнить();
	  сумма2= 0;
	Если НЕ Результат.Пустой() тогда
	    Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Выборка.Следующий();
	    сумма2 = выборка.СуммаМарк;
	КонецЕсли;
	возврат сумма2;
КонецФункции

функция ПолучитьСумма3()
		 Запрос3 = Новый Запрос;
	  Запрос3.Текст = "ВЫБРАТЬ
	                  |	ТоварыНаСкладахОбороты.Склад,
	                  |	ТоварыНаСкладахОбороты.Номенклатура.Код КАК КодУстранения,
	                  |	ТоварыНаСкладахОбороты.Номенклатура КАК НоменклатураУстранения,
	                  |	ТоварыНаСкладахОбороты.Регистратор.СкладОтправитель КАК СкладОтправитель,
	                  |	ТоварыНаСкладахОбороты.Регистратор.СкладПолучатель КАК СкладПолучатель,
	                  |	-ТоварыНаСкладахОбороты.КоличествоОборот КАК КоличествоУстр,
	                  |	-ТоварыНаСкладахОбороты.КоличествоОборот * &ЦенаУстр КАК СуммаУстр
	                  |ИЗ
	                  |	РегистрНакопления.ТоварыНаСкладах.Обороты(&НачалоПериода, &КонецПериода, Регистратор, Склад = &СкладАнгарРемУстр) КАК ТоварыНаСкладахОбороты
	                  |ГДЕ
	                  |	ТоварыНаСкладахОбороты.Регистратор.СкладОтправитель = &СкладАнгарРемУстр
	                  |	И ТоварыНаСкладахОбороты.Регистратор.СкладПолучатель <> &СкладБрак
	                  |ИТОГИ
	                  |	СУММА(СуммаУстр)
	                  |ПО
	                  |	ОБЩИЕ";
	Запрос3.УстановитьПараметр("ЦенаУстр", ЦенаУстр);
	Запрос3.УстановитьПараметр("НачалоПериода",ДатаНачала);
	Запрос3.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
	
	СкладАнгарРемУстр = Справочники.Склады.НайтиПоКоду("02340");//Ангар-ремонт Устранение
	Запрос3.УстановитьПараметр("СкладАнгарРемУстр", СкладАнгарРемУстр);  
	Запрос3.УстановитьПараметр("СкладБрак", справочники.Склады.НайтиПоКоду("02235") ); //К-3/53 устранение (Брак)
	
	  Результат = Запрос3.Выполнить();
	  выборкаСуммаУстр = 0;
	Если НЕ Результат.Пустой() тогда
	     Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Выборка.Следующий();
	    выборкаСуммаУстр= выборка.СуммаУстр;
	КонецЕсли;
	возврат выборкаСуммаУстр;  
КонецФункции

функция ПолучитьСумма4()
	 Запрос4 = Новый Запрос;
	 Запрос4.Текст = "ВЫБРАТЬ
	                 |	Продажи.Номенклатура.Код КАК КодПоКлиентам,
	                 |	Продажи.Номенклатура КАК НоменклатураПоКлиентам,
	                 |	СУММА(Продажи.КоличествоОборот) КАК КоличествоПоКлиентам,
	                 |	СУММА(Продажи.КоличествоОборот * &ЦенаПоКлиентам) КАК СуммаПоКлиентам
	                 |ИЗ
	                 |	РегистрНакопления.Продажи.Обороты(&НачалоПериода,&КонецПериода, Регистратор,
	                 |			Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Диски)
	                 |				И Номенклатура.НоменклатурнаяГруппа = &Литые
					 
	                 |				И ДоговорКонтрагента.Владелец В (&СписокКлиентов)
					 
	                 |				И Подразделение.ОбособленноеПодразделение = ЛОЖЬ
	                 |				И ДокументПродажи ССЫЛКА Документ.РеализацияТоваровУслуг
	                 |				И ДоговорКонтрагента.ОтветственноеЛицо = ДоговорКонтрагента.Владелец.ОсновнойМенеджерКонтрагента
					 |) КАК Продажи
	                 |ГДЕ
	                 |	Продажи.Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
	                 |
	                 |СГРУППИРОВАТЬ ПО
	                 |	Продажи.Номенклатура.Код,
	                 |	Продажи.Номенклатура
	                 |ИТОГИ
	                 |	СУММА(СуммаПоКлиентам)
	                 |ПО
	                 |	ОБЩИЕ";
	Запрос4.УстановитьПараметр("НачалоПериода",ДатаНачала);
	Запрос4.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
  	Запрос4.УстановитьПараметр("Литые", справочники.НоменклатурныеГруппы.НайтиПоКоду("00026") ); //литые
  	Запрос4.УстановитьПараметр("ЦенаПоКлиентам",ЦенаПоКлиентам);
    Запрос4.УстановитьПараметр("СписокКлиентов",СписокКлиентов);
	
	Результат = Запрос4.Выполнить();
	сумма4 = 0;
	Если не Результат.Пустой() тогда
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Выборка.Следующий();
	  	сумма4 = выборка.СуммаПоКлиентам;
    КонецЕсли;
  возврат сумма4;
КонецФункции 

функция ПолучитьСумма5()
	
	//(должны подцепляться "оприходованные" кованные диски за установленный период)	
	Запрос5 = новый Запрос;
	запрос5.текст = "ВЫБРАТЬ
	                |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Номенклатура КАК Номенклатура,
	                |	СУММА(ОтчетПроизводстваЗаСменуГотоваяПродукция.Количество * &ЦенаЗаДиск) КАК СуммаЗаДиски
	                |ИЗ
	                |	Документ.ОтчетПроизводстваЗаСмену.ГотоваяПродукция КАК ОтчетПроизводстваЗаСменуГотоваяПродукция
	                |ГДЕ
	                |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Ссылка.Проведен
	                |	И ОтчетПроизводстваЗаСменуГотоваяПродукция.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	                |
	                |СГРУППИРОВАТЬ ПО
	                |	ОтчетПроизводстваЗаСменуГотоваяПродукция.Номенклатура
	                |ИТОГИ
	                |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Номенклатура),
	                |	СУММА(СуммаЗаДиски)
	                |ПО
	                |	ОБЩИЕ";
	Запрос5.УстановитьПараметр("НачалоПериода",ДатаНачала);
	Запрос5.УстановитьПараметр("КонецПериода", КонецДня(ДатаОкончания));
	
//за каждый кованый диск премия 600 руб. - фикс!
  	Запрос5.УстановитьПараметр("ЦенаЗаДиск",ЦенаЗаДиск);
	
	Результат = запрос5.Выполнить();
	
	Сумма5 = 0;
	Если не Результат.Пустой() тогда
	 	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Выборка.Следующий();
	 	Сумма5 = Выборка.СуммаЗаДиски;
	КонецЕсли;
	
	возврат Сумма5;
КонецФункции	

процедура ВывестиВМакет(NстШаг, стСум, Название1="", выборкаСумма1=0, флСообщить=ЛОЖЬ)
     ЭлементыФормы.Результат.Область(NстШаг,2).Текст = Название1;
	 ЭлементыФормы.Результат.Область(NстШаг,стСум).Текст = строка(выборкаСумма1);
	 ЭлементыФормы.Результат.Область(NстШаг,стСум+1).Текст = "р.";
	 Если флСообщить тогда
  		 Сообщить(Название1 + строка(выборкаСумма1)+"р.");
	 КонецЕсли;
КонецПроцедуры	

Процедура ДействияФормыРасчет(Кнопка)
	
	ЭлементыФормы.Результат.Очистить();
	стШаг = 2;
	стСум = 5;
	
	сумма3 = 0; 
	номШаг = 0;
//1)======================================================================	
	 выборкаСумма1 = ПолучитьСумма1();
	 сумма3= сумма3+ выборкаСумма1;
	 номШаг = номШаг +1;
	 ВывестиВМакет(номШаг*стШаг, стСум, "Сумма Проверки: ", выборкаСумма1);
	 
 //2)=============================================================
	 выборкаСуммаМарк = ПолучитьСумма2();
	 сумма3 = сумма3 + выборкаСуммаМарк;
	 номШаг = номШаг +1;
	 ВывестиВМакет(номШаг*стШаг, стСум, "Сумма Маркировки: ", выборкаСуммаМарк);
 
 //3)=============================================================
     выборкаСуммаУстр = ПолучитьСумма3();
  	 сумма3 = сумма3 + выборкаСуммаУстр;
     номШаг = номШаг +1;
	 ВывестиВМакет(номШаг*стШаг, стСум, "Сумма Устранения: ", выборкаСуммаУстр);
  	                           								
//4)===========Задача № 46601 ====================================
     выборкаСуммаПоКлиентам = ПолучитьСумма4();
	 сумма3 = сумма3 + выборкаСуммаПоКлиентам;
     номШаг = номШаг +1;
	 ВывестиВМакет(номШаг*стШаг, стСум,  "Сумма по Клиентам: ", выборкаСуммаПоКлиентам);
	 
//5)==Задача № 53319 =======================================================================
	 выборкаСуммаКованныхДисков = ПолучитьСумма5();
	 сумма3 = сумма3 + выборкаСуммаКованныхДисков;
	 номШаг = номШаг +1;
	 ВывестиВМакет(номШаг*стШаг, стСум, "Производство кованных дисков: ", выборкаСуммаКованныхДисков);
	 
	 
//следующий шаг - Итого =====================================================================
	 номШаг = номШаг +1;
	 стрИтого=номШаг*стШаг;

	 ЭлементыФормы.Результат.Область(стрИтого,2).Текст = "Итого:";
	 ЭлементыФормы.Результат.Область(стрИтого,стСум).текст = строка(Сумма3);
	 ЭлементыФормы.Результат.Область(стрИтого,стСум+1).Текст = "р.";
	 ЭлементыФормы.Результат.Область(стрИтого,2).Шрифт  = новый Шрифт( ,,Истина); 
	 ЭлементыФормы.Результат.Область(стрИтого,стСум).Шрифт = новый Шрифт( ,,Истина); 
	 ЭлементыФормы.Результат.Область(стрИтого,стСум+1).Шрифт = новый Шрифт( ,,Истина); 
	 
//---------------------------------------------------	
	 ЧислоРаботниковАнгарТест  = 5;
	 фикc5=5000;
	 Сумма1 = Окр( Сумма3/ЧислоРаботниковАнгарТест - 25000,2);
	 
	 стрНом0 = стрИтого+стШаг; 
	 для ii=1 по ЧислоРаботниковАнгарТест цикл
		 ЭлементыФормы.Результат.Область(стрНом0+ii-1,2).текст = "Премия "+строка(ii);
		 
		 Если ii=ЧислоРаботниковАнгарТест тогда
			 ЭлементыФормы.Результат.Область(стрНом0+ii-1,стСум).текст = строка(Сумма1 + фикc5);
		 иначе	 
	 	 	ЭлементыФормы.Результат.Область(стрНом0+ii-1,стСум).текст = строка(Сумма1);
		 КонецЕсли;
		
	 	ЭлементыФормы.Результат.Область(стрНом0+ii-1,стСум+1).Текст = "р.";
	КонецЦикла;	 
	
	 ii=ЧислоРаботниковАнгарТест+1;
	 ЭлементыФормы.Результат.Область(стрНом0+ii-1,2).текст = "Итого 2";//"Премия "+строка(ii);
	 ЭлементыФормы.Результат.Область(стрНом0+ii-1,стСум).текст = строка(Сумма6);
	 ЭлементыФормы.Результат.Область(стрНом0+ii-1,стСум+1).Текст = "р.";
	  
КонецПроцедуры

Завод = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90185");

