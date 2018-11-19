﻿перем масРеквизиты, масСвойства, масСумм; // разбор свойства на подстроки

Процедура ДействияФормыОтчетСформировать(Кнопка)
	
	ОтчетВывести();
	
КонецПроцедуры

Процедура ОтчетВывести()
	
	ЭлементыФормы.ПолеТабличногоДокумента.Очистить();
	
	ТабДокумент = ЭлементыФормы.ПолеТабличногоДокумента;//Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВнешнийОтчет_ОтчетПоКаме_223";

	Макет = ПолучитьМакет("Макет");

	// Выводим шапку накладной

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ТекстЗаголовка = "Отчет по продажам за период с "+Формат(начДата,"ДЛФ=D")+" по "+Формат(КонДата,"ДЛФ=D");
	Если ЭлементыФормы.Флажок1.Значение тогда
	ТекстЗаголовка = ТекстЗаголовка+"
	|отбор по регионам: "+ строка(СписокРегионов);
	 КонецЕсли;
	ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
	ТабДокумент.Вывести(ОбластьМакета);

    ОснТабл = ОтчетИнициализация(); // основные значения из базы данных
	ОснТабл.колонки.Добавить("N");
  	ОснТабл.колонки.Добавить("Процент"); //вычисляется
    ДобавитьДопКолонки(ОснТабл);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	масИтоги = новый массив;
	для i=0 по 14 цикл
		масИтоги.Добавить(0);
	КонецЦикла;
	
	реалN = 0;
	для N=0 по ОснТабл.Количество()-1 цикл
		стр1 = ОснТабл[N];
    //    стр1.N = N+1;
	
		Если стр1.ПроданоВСЕГОШт<>0 тогда
			кол=0;
			для i=0 по 14 цикл
			масИтоги[i] = масИтоги[i] + стр1[масСумм[i]];
				Если (i%3=0) тогда //все количества: 1,4,7,10,13
					кол = кол+стр1[масСумм[i]];
				КонецЕсли;
			КонецЦикла;	
			
			//Если кол>0 тогда
			
			//------------------------параметры строки:---------------------------------
			//N; - порядковый номер покупателя
			 	 реалN = реалN + 1;
		        стр1.N = реалN;
			ПолучитьРеквизитыКонтрагента( стр1 );
			РазобратьЗначениеВКолонки( стр1 );
			
			//-------------Заполнение 36 свойств макета--------------------------
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, стр1 );
			
			
			ОбластьМакета.Параметры.Процент = Окр( 100* кол / стр1.ПроданоВСЕГОШт, 1);
			
			//------стр1.КатРозницы=сумме, но не правильно считает---------------
			стрКатРозницы = "---";
			Если стр1.ПроданоЛегкШт>0 тогда
				стрКатРозницы = "1";
			КонецЕсли;	
			Если стр1.ПроданоЛегкГрузШт>0 тогда
				стрКатРозницы = "2";
			КонецЕсли;	
			Если (стр1.ПроданоГрузШт>0 или стр1.ПроданоЦМКШт>0) и стрКатРозницы="" тогда  //груз
				стрКатРозницы = "3";
			ИначеЕсли (стр1.ПроданоГрузШт>0 или стр1.ПроданоЦМКШт>0)>0 и (стрКатРозницы = "1") тогда // 1 + 3 = 2
				стрКатРозницы = "2"
			КонецЕсли;	
			ОбластьМакета.Параметры.КатРозницы = стрКатРозницы;
			//--------------------------------------------------------------------
			//Если СокрЛП(стр1.ЭлАдрес)<>"" тогда
			//ОбластьМакета.Параметры.ЭлАдрес = "mailto:"+ СокрЛП(стр1.ЭлАдрес);
			//КонецЕсли;
			
			ТабДокумент.Вывести(ОбластьМакета);
			//КонецЕсли;
		
		КонецЕсли;	
		
	КонецЦикла;	
	
	//---------------------------Итоги-------------------------------
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	для i=0 по 14 цикл
		ОбластьМакета.Параметры[масСумм[i]] = масИтоги[i];
	КонецЦикла;
	ТабДокумент.Вывести(ОбластьМакета);

КонецПроцедуры

//----------------добавляем все доп.поля-------------------------------------
процедура ДобавитьДопКолонки(табл)
	
	//Наименование;Руководитель;Регион;Город;АдресТелефон;ЭлАдрес;КонтЛицо;
	для каждого стр1 из масРеквизиты цикл
		табл.колонки.Добавить(стр1);
	КонецЦикла;
	
	//Категория;НаименованиеРТТ;
	//КатРозницы;
	//Процент;Бренды;НаличиеViatti;
	//НаличиеШиномонтажа;КолПостов;СерсисныеУслуги;Комментарии;
	//ПланМероприятия;ОтветственныйМероприятия;ДатаМероприятия;
	для каждого стр1 из масСвойства цикл
		табл.колонки.Добавить(стр1);
	КонецЦикла;
	
КонецПроцедуры

//масРеквизиты
//Наименование;Руководитель;Регион;Город;АдресТелефон;ЭлАдрес;КонтЛицо;
процедура ПолучитьРеквизитыКонтрагента( текСтр )
	
текСтр.Наименование = текСтр.Контрагент.НаименованиеПолное;

//---------------------Руководитель;---------------------------------------
Если Лев(текСтр.Наименование,3)="ИП " тогда //директор ИП - сам он и есть
	текСтр.Руководитель = Прав(текСтр.Наименование, стрДлина(текСтр.Наименование)-3);
иначе	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	КонтактныеЛица.Наименование
	               |ИЗ
	               |	Справочник.КонтактныеЛица КАК КонтактныеЛица
	               |ГДЕ
	               |	КонтактныеЛица.ОбъектВладелец = &ОбъектВладелец
				   |	И (КонтактныеЛица.Роль = &Роль1
				   |			ИЛИ КонтактныеЛица.Роль = &Роль2
				   |			ИЛИ КонтактныеЛица.Должность ПОДОБНО ""%директор"")
	               |
	               |УПОРЯДОЧИТЬ ПО
				   // Руководитель, Директор, Генеральный Директор
	               |	КонтактныеЛица.Роль УБЫВ,
				   // Генеральный директор, Директор, Коммерческий, Управляющий, Финансовый
	               |	КонтактныеЛица.Должность
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("ОбъектВладелец", текСтр.Контрагент);
	Запрос.УстановитьПараметр("Роль1",Справочники.РолиКонтактныхЛиц.Директор);
	Запрос.УстановитьПараметр("Роль2",Справочники.РолиКонтактныхЛиц.Руководитель);
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();

	Если выборка.Следующий() тогда
		текСтр.Руководитель = выборка.Наименование;
	КонецЕсли;
КонецЕсли;


//--------------Регион;Город;Адрес = улица, дом, корп, кв---------
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	КонтактнаяИнформация.Тип,
               |	КонтактнаяИнформация.Вид,
			   // поле1 - индекс
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле2, """") КАК Регион,
			   // поле3 - это район
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле4, ЕСТЬNULL(КонтактнаяИнформация.Поле5, """")) КАК Город,
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле6, """") КАК улица,
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле7, """") КАК дом,
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле8, """") КАК корп,
               |	ЕСТЬNULL(КонтактнаяИнформация.Поле9, """") КАК кв
               |ИЗ
               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
               |ГДЕ
               |	КонтактнаяИнформация.Объект = &Объект
               |	И КонтактнаяИнформация.Тип = &Тип
               |	И КонтактнаяИнформация.Вид = &Вид";
Запрос.УстановитьПараметр("Объект", текСтр.Контрагент);
Запрос.УстановитьПараметр("Тип", перечисления.ТипыКонтактнойИнформации.Адрес);
Запрос.УстановитьПараметр("Вид", справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();

//--------------Регион;Город;АдресТелефон---------
	Если Выборка.Следующий() тогда
		текСтр.Регион = Выборка.регион;
		текСтр.Город = СокрЛП( стрЗаменить(Выборка.Город,"г","")); // без г
		текСтр.АдресТелефон = Выборка.Улица +?(Выборка.дом="","",", д."+Выборка.дом)+?(Выборка.корп="","",", корп."+Выборка.корп)+?(Выборка.кв="","",", кв."+Выборка.кв);
	иначе
		текСтр.Регион = "";
		текСтр.Город = "";
		текСтр.АдресТелефон = "";
	КонецЕсли;
//----------АдресТелефон;-----------------
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	КонтактнаяИнформация.Тип,
               |	КонтактнаяИнформация.Вид,
               |	ЕстьNull(КонтактнаяИнформация.Представление, """") как Представление
			   |ИЗ
               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
               |ГДЕ
               |	КонтактнаяИнформация.Объект = &Объект
               |	И КонтактнаяИнформация.Тип = &Тип
               |	И КонтактнаяИнформация.Вид = &Вид";
Запрос.УстановитьПараметр("Объект", текСтр.Контрагент);
Запрос.УстановитьПараметр("Тип", перечисления.ТипыКонтактнойИнформации.Телефон);
Запрос.УстановитьПараметр("Вид", справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента);
Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();
	Если Выборка.Следующий() тогда
	текСтр.АдресТелефон = текСтр.АдресТелефон +?(СокрЛП(выборка.представление)="", "", ", тел."+СокрЛП(выборка.представление));
	КонецЕсли;
//----------ЭлАдрес--------------------------	
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	КонтактнаяИнформация.Тип,
               |	КонтактнаяИнформация.Вид,
               |	ЕстьNull(КонтактнаяИнформация.Представление, """") как Представление
			   |ИЗ
               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
               |ГДЕ
               |	КонтактнаяИнформация.Объект = &Объект
               |	И КонтактнаяИнформация.Тип = &Тип
               |	И КонтактнаяИнформация.Вид = &Вид";
Запрос.УстановитьПараметр("Объект", текСтр.Контрагент);
Запрос.УстановитьПараметр("Тип", перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
Запрос.УстановитьПараметр("Вид", справочники.ВидыКонтактнойИнформации.АдресЭлектроннойПочтыДляОбменаДокументами);
Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();
	Если Выборка.Следующий() тогда
	текСтр.ЭлАдрес =СокрЛП(выборка.представление);
	КонецЕсли;
	
//---------------------Основное контактное лицо Контрагента-----------------------
текСтр.КонтЛицо     = СокрЛП( Строка(текСтр.Контрагент.ОсновноеКонтактноеЛицо) );
//телефон контактного лица
Если текСтр.КонтЛицо<>"" тогда
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	КонтактнаяИнформация.Тип,
               |	КонтактнаяИнформация.Вид,
               |	ЕстьNull(КонтактнаяИнформация.Представление, """") как Представление
			   |ИЗ
               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
               |ГДЕ
               |	КонтактнаяИнформация.Объект = &Объект
               |	И КонтактнаяИнформация.Тип = &Тип
               |	И КонтактнаяИнформация.Вид = &Вид";
Запрос.УстановитьПараметр("Объект", текСтр.Контрагент.ОсновноеКонтактноеЛицо);
Запрос.УстановитьПараметр("Тип", перечисления.ТипыКонтактнойИнформации.Телефон);
Запрос.УстановитьПараметр("Вид", справочники.ВидыКонтактнойИнформации.ТелефонФизЛица);
Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();
	Если Выборка.Следующий() тогда
		текСтр.КонтЛицо = текСтр.КонтЛицо +" "+выборка.Представление;
	КонецЕсли;
КонецЕсли;
	текСтр.ОтветственныйМероприятия = текСтр.Контрагент.ОсновнойМенеджерКонтрагента;//+++ 09.08.2012
КонецПроцедуры

//масСвойства
//разбирает строку в порядке масСвоства в поля текСтр
процедура РазобратьЗначениеВКолонки(текСтр)
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
|	ЗначенияСвойствОбъектов.Значение
|ИЗ
|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
|ГДЕ
|	ЗначенияСвойствОбъектов.Объект = &Объект
|	И ЗначенияСвойствОбъектов.Свойство = &Свойство";

Запрос.УстановитьПараметр("Объект", текСтр.Контрагент);
Запрос.Параметры.Вставить("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90162"));//НайтиПоНаименованию("Аналитика контрагентов КАМА") );

Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();

Если  Выборка.Следующий() тогда
 строкаСвойства = выборка.Значение;
 для k=0 по масСвойства.Количество()-1 цикл
	 стр1=масСвойства[k];
	 i = Найти(строкаСвойства,";"); L = стрДлина(строкаСвойства);
	 Если i>0 тогда
		 знач1 = лев(строкаСвойства,i-1);
		 строкаСвойства = прав(строкаСвойства, L-i);
		 текСтр[стр1] = знач1;
	 иначе
	    сообщить("Для контрагента: "+строка(текСтр.Контрагент)+" - не заполнено поле №"+строка(k)+"("+стр1+") в свойстве: 'Аналитика контрагентов КАМА'", СтатусСообщения.Внимание);	 
	 	текСтр[стр1] = "";
	 КонецЕсли;
 КонецЦикла;	 
 
иначе
 	текСтр.Категория = 1;   текСтр.НаличиеШиномонтажа = ЛОЖЬ;
	сообщить("Для контрагента: "+строка(текСтр.Контрагент)+" - не заполнено свойство: 'Аналитика контрагентов КАМА'", СтатусСообщения.Внимание);
КонецЕсли;

		
КонецПроцедуры		

//+++ ОСНОВНАЯ ФУНКЦИЯ - ЗАПРОС и обработка!
//получает общие сведения
//
//Контрагент
//Наличие Viatti
//масСумм[i]
//
Функция ОтчетИнициализация()
	
	
	//1) получает 1 раз все продажи по номенклатурным группам и контрагентам
	ЗапросВсе = новый Запрос;
	ЗапросВсе.МенеджерВременныхТаблиц = новый МенеджерВременныхТаблиц;
	ЗапросВсе.Текст = "ВЫБРАТЬ
	                  |	ПродажиОбороты.ДоговорКонтрагента.Владелец КАК Контрагент,
	                  |	ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа.Наименование КАК НоменклатурнаяГруппа,
	                  |	СУММА(ЕСТЬNULL(ПродажиОбороты.КоличествоОборот, 0)) КАК ПроданоВСЕГОШт,
	                  |	СУММА(0) КАК ПроданоЗаменаШт,
	                  |	СУММА(ВЫБОР
	                  |			КОГДА ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа В (&ВсеГруппы)
	                  |				ТОГДА ЕСТЬNULL(ПродажиОбороты.СтоимостьОборот, 0)
	                  |			ИНАЧЕ 0
	                  |		КОНЕЦ) КАК ПроданоСуммаСНДС,
	                  |	МАКСИМУМ(ВЫБОР
	                  |			КОГДА ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа В (&ViattiГруппа)
	                  |					И (ЕСТЬNULL(ПродажиОбороты.СтоимостьОборот, 0) <> 0
	                  |						ИЛИ ЕСТЬNULL(ПродажиОбороты.КоличествоОборот, 0) <> 0)
	                  |				ТОГДА ИСТИНА
	                  |			ИНАЧЕ ЛОЖЬ
	                  |		КОНЕЦ) КАК НаличиеViatti,
	                  |	СУММА(ВЫБОР
	                  |			КОГДА ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа В (&ВсеГруппы)
	                  |				ТОГДА ЕСТЬNULL(ПродажиОбороты.КоличествоОборот, 0)
	                  |			ИНАЧЕ 0
	                  |		КОНЕЦ) КАК ПроданоШт
	                  |ПОМЕСТИТЬ ВсеГруппы
	                  |ИЗ
	                  |	РегистрНакопления.Продажи.Обороты(&НачДата, &КонДата, Период, ДоговорКонтрагента.Владелец В (&СписокКонтр)) КАК ПродажиОбороты
	                  |
	                  |СГРУППИРОВАТЬ ПО
	                  |	ПродажиОбороты.ДоговорКонтрагента.Владелец,
	                  |	ПродажиОбороты.Номенклатура.НоменклатурнаяГруппа.Наименование";
	ЗапросВсе.Параметры.Вставить("НачДата", НачДата);
	ЗапросВсе.Параметры.Вставить("КонДата", КонецДня(КонДата) );
	
	//------------------------получаем реквизиты------------------------------
    ВсеГруппы = новый Списокзначений;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	НоменклатурныеГруппы.Ссылка
	               |ИЗ
	               |	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
	               |ГДЕ
	               |	(НоменклатурныеГруппы.Наименование ПОДОБНО ""%КАМА%""
	               |			ИЛИ НоменклатурныеГруппы.Наименование ПОДОБНО ""%Viatti%"")
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НоменклатурныеГруппы.Наименование
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();	
	ВсеГруппы.ЗагрузитьЗначения( Выборка.ВыгрузитьКолонку("Ссылка") );
	//---------------------Viatti----------------------------
   ViattiГруппы = новый Списокзначений;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	НоменклатурныеГруппы.Ссылка
	               |ИЗ
	               |	Справочник.НоменклатурныеГруппы КАК НоменклатурныеГруппы
	               |ГДЕ
	               |	НоменклатурныеГруппы.Наименование ПОДОБНО ""%Viatti%""
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НоменклатурныеГруппы.Наименование
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выгрузить();	
	ViattiГруппы.ЗагрузитьЗначения( Выборка.ВыгрузитьКолонку("Ссылка") );

	//-------------------------------------------------------------
	СписокКонтр = новый СписокЗначений;
	//0) для получения процента продаж по Каме
	ЗапросКонтр = новый Запрос;
	ЗапросКонтр.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	                    |	ПродажиОбороты.ДоговорКонтрагента.Владелец КАК Контрагент,
	                    |	ЕСТЬNULL(КонтактнаяИнформация.Поле2, """") КАК Регион,
	                    |	ЗначенияСвойствОбъектов.Значение
	                    |ИЗ
	                    |	РегистрНакопления.Продажи.Обороты(&НачДата, &КонДата, , Номенклатура.НоменклатурнаяГруппа В (&ВсеГруппы)) КАК ПродажиОбороты
	                    |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                    |		ПО (ЗначенияСвойствОбъектов.Объект = ПродажиОбороты.ДоговорКонтрагента.Владелец)
	                    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	                    |		ПО ПродажиОбороты.ДоговорКонтрагента.Владелец = КонтактнаяИнформация.Объект
	                    |ГДЕ
	                    |	ЗначенияСвойствОбъектов.Значение   = &КатегорияПокупателей
	                    |	И ЗначенияСвойствОбъектов.Свойство = &Свойство
						|   //УсловиеНаРегион
	                    |	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес)
	                    |	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ЮрАдресКонтрагента)
	                    |
	                    |УПОРЯДОЧИТЬ ПО Контрагент
	                    |АВТОУПОРЯДОЧИВАНИЕ";
						
	ЗапросКонтр.Параметры.Вставить("Свойство",  ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("00119") ); // Категория покупателей
	Если ЭлементыФормы.КатегорияПокупателей.Значение=0 тогда
		ЭлементыФормы.КатегорияПокупателей.Значение = 3;
	КонецЕсли;	
	ЗапросКонтр.Параметры.Вставить("КатегорияПокупателей", ЭлементыФормы.КатегорияПокупателей.Значение); // число от 1 до 5
	ЗапросКонтр.Параметры.Вставить("НачДата",   НачДата);
	ЗапросКонтр.Параметры.Вставить("КонДата",   КонецДня(КонДата) );
	ЗапросКонтр.Параметры.Вставить("ВсеГруппы", ВсеГруппы);
	
	Если ЭлементыФормы.Флажок1.Значение тогда
		стрУсл ="  И (";
		Если СписокРегионов.Количество()=0 тогда
			стрУсл = стрУсл + "ЕСТЬNULL(КонтактнаяИнформация.Поле2, """") = """" ";
		иначе
			стрУсл = стрУсл + "ЕСТЬNULL(КонтактнаяИнформация.Поле2, """") ПОДОБНО ""%"+СписокРегионов[0]+"%"""; 
			Для i=1 по СписокРегионов.Количество()-1 цикл
			стрУсл = стрУсл + "
			|        ИЛИ ЕСТЬNULL(КонтактнаяИнформация.Поле2, """") ПОДОБНО ""%"+СписокРегионов[i]+"%"""; 
			КонецЦикла;	
		КонецЕсли;
		стрУсл = стрУсл + ")";
		ЗапросКонтр.Текст = стрЗаменить(ЗапросКонтр.Текст,"//УсловиеНаРегион",стрУсл);
		ЗапросКонтр.Текст = стрЗаменить(ЗапросКонтр.Текст,"ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация");
		ЗапросКонтр.Текст = стрЗаменить(ЗапросКонтр.Текст,"УПОРЯДОЧИТЬ ПО Контрагент", "УПОРЯДОЧИТЬ ПО	Регион");
	КонецЕсли;

	Результат = ЗапросКонтр.Выполнить();
	Выборка = Результат.Выгрузить();	
	СписокКонтр.ЗагрузитьЗначения( Выборка.ВыгрузитьКолонку("Контрагент") );


	//==========================================================================
	ЗапросВсе.Параметры.Вставить("СписокКонтр", СписокКонтр);
	ЗапросВсе.Параметры.Вставить("ВсеГруппы", ВсеГруппы);
	ЗапросВсе.Параметры.Вставить("ViattiГруппа", ViattiГруппы);
	Состояние("идет анализ продаж по номенклатурным группам КАМА и Viatti...");
	таблВсе = ЗапросВсе.Выполнить(); // для виртуальной таблицы нужен!
	Состояние(" ");
	
//========Получаем ПОЛНЫЙ ЗАПРОС ==========================================================================================
ЗапросПолный =  новый запрос;
ЗапросПолный.МенеджерВременныхТаблиц = ЗапросВсе.МенеджерВременныхТаблиц ;  // передаем все результаты в полный запрос
    ЗапросПолный.Текст = "ВЫБРАТЬ
                         |	ПродажиОбороты.Контрагент КАК Контрагент,
                         |	МАКСИМУМ(ПродажиОбороты.НаличиеViatti) КАК НаличиеViatti,
                         |	МАКСИМУМ(1) КАК КатРозницы,
                         |	СУММА(ПродажиОбороты.ПроданоВСЕГОШт) КАК ПроданоВСЕГОШт,
                         |	СУММА(ПродажиОбороты.ПроданоШт) КАК ПроданоЛегкШт,
                         |	СУММА(ПродажиОбороты.ПроданоЗаменаШт) КАК ПроданоЛегкЗаменаШт,
                         |	СУММА(ПродажиОбороты.ПроданоСуммаСНДС) КАК ПроданоЛегкСуммаСНДС,
                         |	СУММА(0) КАК ПроданоЛегкГрузШт,
                         |	СУММА(0) КАК ПроданоЛегкГрузЗаменаШт,
                         |	СУММА(0) КАК ПроданоЛегкГрузСуммаСНДС,
                         |	СУММА(0) КАК ПроданоГрузШт,
                         |	СУММА(0) КАК ПроданоГрузЗаменаШт,
                         |	СУММА(0) КАК ПроданоГрузСуммаСНДС,
                         |	СУММА(0) КАК ПроданоЦМКШт,
                         |	СУММА(0) КАК ПроданоЦМКЗаменаШт,
                         |	СУММА(0) КАК ПроданоЦМКСуммаСНДС,
                         |	СУММА(0) КАК ПроданоПрочШт,
                         |	СУММА(0) КАК ПроданоПрочЗаменаШт,
                         |	СУММА(0) КАК ПроданоПрочСуммаСНДС
                         |ИЗ
                         |	ВсеГруппы КАК ПродажиОбороты
                         |ГДЕ
                         |	ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%Легковые%""
                         |
                         |СГРУППИРОВАТЬ ПО
                         |	ПродажиОбороты.Контрагент
                         |
                         |ОБЪЕДИНИТЬ ВСЕ
                         |
                         |ВЫБРАТЬ
                         |	ПродажиОбороты.Контрагент,
                         |	МАКСИМУМ(ПродажиОбороты.НаличиеViatti),
                         |	МАКСИМУМ(2),
                         |	СУММА(ПродажиОбороты.ПроданоВСЕГОШт),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(ПродажиОбороты.ПроданоШт),
                         |	СУММА(ПродажиОбороты.ПроданоЗаменаШт),
                         |	СУММА(ПродажиОбороты.ПроданоСуммаСНДС),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0)
                         |ИЗ
                         |	ВсеГруппы КАК ПродажиОбороты
                         |ГДЕ
                         |	ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%Легкогрузовые%""
                         |
                         |СГРУППИРОВАТЬ ПО
                         |	ПродажиОбороты.Контрагент
                         |
                         |ОБЪЕДИНИТЬ ВСЕ
                         |
                         |ВЫБРАТЬ
                         |	ПродажиОбороты.Контрагент,
                         |	МАКСИМУМ(ПродажиОбороты.НаличиеViatti),
                         |	МАКСИМУМ(4),
                         |	СУММА(ПродажиОбороты.ПроданоВСЕГОШт),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(ПродажиОбороты.ПроданоШт),
                         |	СУММА(ПродажиОбороты.ПроданоЗаменаШт),
                         |	СУММА(ПродажиОбороты.ПроданоСуммаСНДС),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0)
                         |ИЗ
                         |	ВсеГруппы КАК ПродажиОбороты
                         |ГДЕ
                         |	ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""Грузовые%""
                         |
                         |СГРУППИРОВАТЬ ПО
                         |	ПродажиОбороты.Контрагент
                         |
                         |ОБЪЕДИНИТЬ ВСЕ
                         |
                         |ВЫБРАТЬ
                         |	ПродажиОбороты.Контрагент,
                         |	МАКСИМУМ(ПродажиОбороты.НаличиеViatti),
                         |	МАКСИМУМ(8),
                         |	СУММА(ПродажиОбороты.ПроданоВСЕГОШт),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(ПродажиОбороты.ПроданоШт),
                         |	СУММА(ПродажиОбороты.ПроданоЗаменаШт),
                         |	СУММА(ПродажиОбороты.ПроданоСуммаСНДС),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0)
                         |ИЗ
                         |	ВсеГруппы КАК ПродажиОбороты
                         |ГДЕ
                         |	ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%ЦМК%""
                         |
                         |СГРУППИРОВАТЬ ПО
                         |	ПродажиОбороты.Контрагент
                         |
                         |ОБЪЕДИНИТЬ ВСЕ
                         |
                         |ВЫБРАТЬ
                         |	ПродажиОбороты.Контрагент,
                         |	МАКСИМУМ(ПродажиОбороты.НаличиеViatti),
                         |	МАКСИМУМ(16),
                         |	СУММА(ПродажиОбороты.ПроданоВСЕГОШт),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(0),
                         |	СУММА(ПродажиОбороты.ПроданоШт),
                         |	СУММА(ПродажиОбороты.ПроданоЗаменаШт),
                         |	СУММА(ПродажиОбороты.ПроданоСуммаСНДС)
                         |ИЗ
                         |	ВсеГруппы КАК ПродажиОбороты
                         |ГДЕ
                         |	(НЕ(ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%ЦМК%""
                         |				ИЛИ ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""Грузовые%""
                         |				ИЛИ ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%Легкогрузовые%""
                         |				ИЛИ ПродажиОбороты.НоменклатурнаяГруппа ПОДОБНО ""%Легковые%""))
                         |
                         |СГРУППИРОВАТЬ ПО
                         |	ПродажиОбороты.Контрагент
                         |
                         |УПОРЯДОЧИТЬ ПО
                         |	Контрагент
                         |ИТОГИ
                         |	МАКСИМУМ(НаличиеViatti),
                         |	СУММА(КатРозницы),
                         |	СУММА(ПроданоВСЕГОШт),
                         |	СУММА(ПроданоЛегкШт),
                         |	СУММА(ПроданоЛегкЗаменаШт),
                         |	СУММА(ПроданоЛегкСуммаСНДС),
                         |	СУММА(ПроданоЛегкГрузШт),
                         |	СУММА(ПроданоЛегкГрузЗаменаШт),
                         |	СУММА(ПроданоЛегкГрузСуммаСНДС),
                         |	СУММА(ПроданоГрузШт),
                         |	СУММА(ПроданоГрузЗаменаШт),
                         |	СУММА(ПроданоГрузСуммаСНДС),
                         |	СУММА(ПроданоЦМКШт),
                         |	СУММА(ПроданоЦМКЗаменаШт),
                         |	СУММА(ПроданоЦМКСуммаСНДС),
                         |	СУММА(ПроданоПрочШт),
                         |	СУММА(ПроданоПрочЗаменаШт),
                         |	СУММА(ПроданоПрочСуммаСНДС)
                         |ПО
                         |	Контрагент
                         |АВТОУПОРЯДОЧИВАНИЕ";
						 
ЗапросПолныйТаблДерево = ЗапросПолный.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);


//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//ПостроительОтчетаОтчет.Текст = ЗапросПолный.Текст;
	//ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	//ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	//ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет по Каме";
	//Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыОтчетПоКамеОтчет_9d21a169-b38a-4b4a-95ff-1700b364d910");
	//Если Настройка <> Неопределено Тогда
	//	ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	//КонецЕсли;

//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ



//возвращать надо таблицу, а не дерево!
табЗнач = новый ТаблицаЗначений;
для каждого кол1 из ЗапросПолныйТаблДерево.Колонки цикл
табЗнач.Колонки.Добавить(кол1.Имя);
КонецЦикла;

для каждого стрДерово из ЗапросПолныйТаблДерево.Строки цикл
	табЗначСтр = табЗнач.Добавить();
	ЗаполнитьЗначенияСвойств(табЗначСтр, стрДерово);
КонецЦикла;	

возврат табЗнач;
	
КонецФункции

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.УстановитьПериод(НачДата, ?(КонДата='0001-01-01', КонДата, КонецДня(КонДата)));
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	Если НастройкаПериода.Редактировать() Тогда
		НачДата = НастройкаПериода.ПолучитьДатуНачала();
		КонДата = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры
 

//--------------ОБЯЗАТЕЛЬНЫЕ реквизиты Контрагента для отчета-------------------------------
масРеквизиты = новый массив;
масРеквизиты.Добавить("Наименование");
масРеквизиты.Добавить("Руководитель");
масРеквизиты.Добавить("Регион");
масРеквизиты.Добавить("Город");
масРеквизиты.Добавить("АдресТелефон"); // улица телефон
масРеквизиты.Добавить("ЭлАдрес");
масРеквизиты.Добавить("КонтЛицо");
масРеквизиты.Добавить("ОтветственныйМероприятия");//+++ 09.08.2012
	
//-----------массив Свойства "Аналитика контрагентов КАМА"----------------------------------
//------возможны изменения------------------------------------------------------------------ 
//------главное сохранять такую же последовательность в свойстве через ; -------------------
масСвойства = новый массив;
масСвойства.Добавить("Категория");         // 2
масСвойства.Добавить("НаименованиеРТТ");   // 3

//масСвойства.Добавить("КатРозницы");        //11
//масСвойства.Добавить("Процент");           //12
масСвойства.Добавить("Бренды");              //13
//масСвойства.Добавить("НаличиеViatti");     //14
масСвойства.Добавить("НаличиеШиномонтажа");//15
масСвойства.Добавить("КолПостов");         //16
масСвойства.Добавить("СерсисныеУслуги");   //17
масСвойства.Добавить("Комментарии");       //18

масСвойства.Добавить("ПланМероприятия");   //19
//масСвойства.Добавить("ОтветственныйМероприятия");//20
масСвойства.Добавить("ДатаМероприятия");   //21 

//----------------массив Сумм для строки ИТОГО в макете------------------------------------------------
масСумм = новый массив;
масСумм.Добавить("ПроданоЛегкШт");масСумм.Добавить("ПроданоЛегкЗаменаШт");масСумм.Добавить("ПроданоЛегкСуммаСНДС");
масСумм.Добавить("ПроданоЛегкГрузШт");масСумм.Добавить("ПроданоЛегкГрузЗаменаШт");масСумм.Добавить("ПроданоЛегкГрузСуммаСНДС");
масСумм.Добавить("ПроданоГрузШт");масСумм.Добавить("ПроданоГрузЗаменаШт");масСумм.Добавить("ПроданоГрузСуммаСНДС");
масСумм.Добавить("ПроданоЦМКШт");масСумм.Добавить("ПроданоЦМКЗаменаШт");масСумм.Добавить("ПроданоЦМКСуммаСНДС");
масСумм.Добавить("ПроданоПрочШт");масСумм.Добавить("ПроданоПрочЗаменаШт");масСумм.Добавить("ПроданоПрочСуммаСНДС");
