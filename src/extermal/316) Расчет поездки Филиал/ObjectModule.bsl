﻿перем KeyAPIЯндекса, ТарифДоставки;

функция ПолучитьКубатуру(Заказ1) Экспорт
	СуммаКуб = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПокупателяТовары.Номенклатура.Типоразмер КАК Типоразмер,
	               |	ВЫБОР
	               |		КОГДА ЗаказПокупателяТовары.Номенклатура В ИЕРАРХИИ (&Камеры)
	             	//+++ 11.07.2014     1 заменена на Объем!
		           //|				или ЗаказыПокупателей.Номенклатура.ВидТовара = Значение(перечисление.ВидыТоваров.Аксессуары)
				   |			ТОГДА ЕСТЬNULL(ЗаказПокупателяТовары.Количество, 0)
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК КолКамеры,
	               |	ВЫБОР
	               |		КОГДА ЗаказПокупателяТовары.Номенклатура В ИЕРАРХИИ (&Камеры)
	               |				ИЛИ ЗаказПокупателяТовары.Номенклатура В ИЕРАРХИИ (&Крепеж)
	                |			ТОГДА 0
				
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА НормыЗагрузки.НормаЗагрузки = 0
	               |						ИЛИ НормыЗагрузки.НормаЗагрузки = NULL
				//   |				ТОГДА 0  
   				//+++ 11.07.2014 -------------------------------------------------------------------------------------
	               |			ТОГДА ЗаказПокупателяТовары.Номенклатура.ЕдиницаХраненияОстатков.Объем / 0.033
				   
				   |				ИНАЧЕ НормыЗагрузки.НормаЗагрузки
	               |			КОНЕЦ
	               |	КОНЕЦ * ЗаказПокупателяТовары.Количество КАК КолПересчета,
	               |	ВЫБОР
	               |		КОГДА ЗаказПокупателяТовары.Номенклатура В ИЕРАРХИИ (&Камеры)
	               |				ИЛИ ЗаказПокупателяТовары.Номенклатура В ИЕРАРХИИ (&Крепеж)
	               |				ИЛИ НормыЗагрузки.НормаЗагрузки = NULL
	               |			ТОГДА ""нет""
	               |		ИНАЧЕ НормыЗагрузки.НормаЗагрузки
	               |	КОНЕЦ КАК КоэффПересчета,
	               |	ЗаказПокупателяТовары.Номенклатура.НаименованиеПолное КАК Номенклатура
	               |ИЗ
	               |	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыЗагрузки КАК НормыЗагрузки
	               |		ПО ЗаказПокупателяТовары.Номенклатура.Типоразмер = НормыЗагрузки.Типоразмер
	               |			И ЗаказПокупателяТовары.Номенклатура.ВидТовара = НормыЗагрузки.ВидПродукции
	               |ГДЕ
	               |	ЗаказПокупателяТовары.Ссылка = &Ссылка
	               |ИТОГИ
	               |	СУММА(КолКамеры),
	               |	СУММА(КолПересчета)
	               |ПО
	               |	ОБЩИЕ ";
	
	Запрос.УстановитьПараметр("Ссылка", Заказ1);
	Запрос.УстановитьПараметр("Камеры", справочники.Номенклатура.НайтиПоКоду("0001127") );	//+++ 18.04.2012					
    Запрос.УстановитьПараметр("Крепеж", справочники.Номенклатура.НайтиПоКоду("0000701") ); //+++ 19.04.2012 "Диски - Крепежный материал"

	СуммаКуб = Заказ1.Товары.Итог("Количество");
попытка
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Выборка.Следующий();
	СуммаКуб = Выборка.КолПересчета;
	
	ВыборкаТовары = Выборка.Выбрать();
	пока ВыборкаТовары.Следующий() цикл
		если ВыборкаТовары.КоэффПересчета=0 тогда
			сообщить(" В справочнике ""Нормы загрузки"" для ТипоРазмера: "+ВыборкаТовары.Типоразмер+" - не установлен ""Коэффициент Пересчета(R13)""", СтатусСообщения.Внимание);
		КонецЕсли;	
	КонецЦикла;	
исключение
	сообщить("Требуется изменение конфигурации. Требуется добавить в справочнике Нормы Загрузки - реквизит ""КоэффициентПересчетаR13""!");
КонецПопытки;

	возврат СуммаКуб;
		
КонецФункции	

функция ПолучитьТариф(Контр) Экспорт 
	
	рез = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Значение
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|ГДЕ
	|	ЗначенияСвойствОбъектов.Объект = &Объект
	|	И ЗначенияСвойствОбъектов.Свойство = &Свойство";
	
	Запрос.УстановитьПараметр("Объект", Контр);
	св1 = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию(ТарифДоставки);
	Запрос.УстановитьПараметр("Свойство", св1);
	
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() тогда
		
		Если ТипЗнч(Выборка.Значение)=Тип("СправочникСсылка.ЗначенияСвойствОбъектов") тогда
			знач1 = Выборка.Значение.Наименование;
		иначе
			знач1 = Выборка.Значение;
		КонецЕсли;
		
		попытка
		рез = Число(Знач1);
		исключение
		рез = Выборка.Значение;
		КонецПопытки;
			
	КонецЕсли;

	возврат рез;
	
КонецФункции

функция ПолучитьВесПоЗаказу(Товары1)
	
	Вес1 = 0;
	
	для каждого стр1 из Товары1 цикл
		Если ЗначениеЗаполнено(стр1.Номенклатура.ЕдиницаХраненияОстатков) тогда
		  Вес1 = Вес1 + стр1.Номенклатура.ЕдиницаХраненияОстатков.Вес * стр1.Количество;
		КонецЕсли;
	КонецЦикла;	
	           	
	возврат Вес1;
	
КонецФункции	

Процедура ЗаполнитьСтроку(стр1, МенятьАдрес=Истина, неОтгружено=ЛОЖЬ) Экспорт
	
//----------------------------------------------------
Если ЗначениеЗаполнено(стр1.Заказ) тогда 
	
	Если Не неОтгружено тогда
		стр1.Количество = стр1.Заказ.Товары.Итог("Количество");
		стр1.Сумма      = стр1.Заказ.Товары.Итог("Сумма"); // тов + услуги
		стр1.Кубатура   = ПолучитьКубатуру(стр1.Заказ);
		стр1.Вес = ПолучитьВесПоЗаказу(стр1.Заказ.Товары);//+++
		стр1.Контрагент = стр1.Заказ.Контрагент;
		стр1.Ответственный = стр1.Заказ.Ответственный;
	КонецЕсли;
	
	тариф1 = ПолучитьТариф(стр1.Контрагент);
	
	если тариф1=0 тогда
		 тариф1 = 0.00; //рублей
	 КонецЕсли;
	 
	стр1.тариф = тариф1;//+++
	
	Если тариф1>0 тогда
		стр1.СуммаДоставки =  тариф1 * стр1.Кубатура;
	иначе 
		стр1.СуммаДоставки = -тариф1 * стр1.Количество;
	КонецЕсли;
	
	
  Если МенятьАдрес тогда
	  
	  //------------------Находим адрес--------------------------------------
	  Если СокрЛП(стр1.Заказ.АдресДоставки)="" тогда
		отбор1 = новый Структура("Объект", стр1.Контрагент );
		отбор1.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
		
		отбор1.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.НайтиПоНаименованию("Адрес доставки") );
		рс = РегистрыСведений.КонтактнаяИнформация.Получить(отбор1);
		если рс<>неопределено и СокрЛП(рс.Представление)<>"" тогда
			  стр1.АдресДоставки = рс.Представление;
			  стр1.Координаты = СокрЛП(рс.Поле10);
		//иначе
		//отбор1.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
		//рс = РегистрыСведений.КонтактнаяИнформация.Получить(отбор1);
		//	если рс<>неопределено и СокрЛП(рс.Представление)<>"" тогда
		//  	стр1.АдресДоставки = "  "+рс.Представление;
		//	стр1.Координаты = СокрЛП(рс.Поле10);
		//	иначе
		//	отбор1.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
		//	рс = РегистрыСведений.КонтактнаяИнформация.Получить(отбор1);
		//		если рс.Представление<>"" и СокрЛП(рс.Представление)<>"" тогда
		//  		стр1.АдресДоставки = "  "+рс.Представление;
		//		стр1.Координаты = СокрЛП(рс.Поле10);
		//		иначе
		//		сообщить("В заказе №"+стр1.Заказ.Номер+" от "+стр1.Заказ.Дата+" у Контрагента: "+стр1.Контрагент+" - нет ни одного из адресов!", СтатусСообщения.Внимание); 
		//		конецЕсли;//Юр
		//	конецЕсли;//Факт
		конецЕсли;//Дост
	 Иначе	//+++ определение Вида адреса
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	КонтактнаяИнформация.Вид
		               |ИЗ
		               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		               |ГДЕ
		               |	КонтактнаяИнформация.Объект = &Объект
		               |	И КонтактнаяИнформация.Тип = &Тип
		               |	И КонтактнаяИнформация.Представление ПОДОБНО &Представление";
		
		Запрос.УстановитьПараметр("Объект", стр1.Контрагент);
		Запрос.УстановитьПараметр("Тип", перечисления.ТипыКонтактнойИнформации.Адрес);
		Запрос.УстановитьПараметр("Представление",  стр1.Заказ.АдресДоставки);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		ВидАдреса = "";
		Если Выборка.Следующий() тогда
			ВидАдреса = ?(Выборка.Вид=Справочники.ВидыКонтактнойИнформации.НайтиПоНаименованию("Адрес доставки"), "",
							?(Выборка.Вид=Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента, "  ",
						  	 ?(Выборка.Вид=Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, "  ",
								Выборка.Вид
						  )  ));
		КонецЕсли;
		стр1.АдресДоставки = Строка(ВидАдреса) + стр1.Заказ.АдресДоставки;
		стр1.Координаты = "";
	КонецЕсли;

  КонецЕсли;
   
КонецЕсли;


//----------координаты и расстояние------------------------------------------
   	попытка

Если МенятьАдрес тогда
	
	МенятьКоординаты(стр1); 
					
	//----------изменение расстояния 0,1,2----------------
	нашиКоординаты = "57.656500,39.838000"; //так же как в Модуле!
		Если стр1.НомерСтроки>1 тогда 
			стр0 = Заказы[стр1.НомерСтроки-2];
			
			Если стр1.НомерСтроки>2 тогда 
			к0 = Заказы[стр1.НомерСтроки-3].Координаты;
			иначе
			к0 = нашиКоординаты;
			КонецЕсли;
		    стр0.Расстояние = получитьРасстояние(к0, стр0.Координаты);
			
			к1 = стр0.Координаты;
			иначе
			к1 = нашиКоординаты;
			КонецЕсли;
		
		стр1.Расстояние = получитьРасстояние(к1, стр1.Координаты);
		//Если стр1.Расстояние>500 тогда
		//	Сообщить("Возможно неверное определение координат по адресу: "+стр1.АдресДоставки+" - Координаты: "+стр1.Координаты, СтатусСообщения.Внимание);
		//КонецЕсли;
		
		Если стр1.НомерСтроки<Заказы.Количество() тогда 
		стр2 = Заказы[стр1.НомерСтроки];//последняя строка
		стр2.Расстояние = получитьРасстояние(стр1.Координаты, стр2.Координаты);
		
			Если стр1.НомерСтроки+1=Заказы.Количество() тогда
			стр2.Расстояние = стр2.Расстояние + получитьРасстояние(стр2.Координаты, нашиКоординаты); 
			КонецЕсли;	
		
		КонецЕсли;
		
		Если стр1.НомерСтроки=Заказы.Количество() тогда
			стр1.Расстояние = стр1.Расстояние + получитьРасстояние(стр1.Координаты, нашиКоординаты); 
		КонецЕсли;	
		
		
		//----------изменение расстояния 0,1,2----------------
КонецЕсли;

	исключение
		стр1.Координаты = "";
		стр1.Расстояние = 0;
	Сообщить("Ошибка при определении координат в строке № "+Строка(стр1.НомерСтроки)+" : "+ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;

КонецПроцедуры

////поиск ВСЕХ Не Отгруженных Заказов!
Функция ПроверитьОтгрузкуПоЗаказу(СсылкаЗаказ, Дата1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	              	|	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК Заказ,
	              	|	СУММА(ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0)) КАК Количество
	              	|ИЗ
	              	|	РегистрНакопления.ЗаказыПокупателей.Остатки(
	              	|			,
	              	|			ЗаказПокупателя В (&СсылкаЗаказ)
	              	|				И ЗаказПокупателя.ДатаОтгрузки <= &Дата
	              	|				И ЗаказПокупателя.Дата <= &Дата) КАК ЗаказыПокупателейОстатки
	              	|
	              	|СГРУППИРОВАТЬ ПО
	              	|	ЗаказыПокупателейОстатки.ЗаказПокупателя
	              	|
	              	|ИМЕЮЩИЕ
	              	|	СУММА(ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0)) <> 0
	              	|
	              	|УПОРЯДОЧИТЬ ПО
	              	|	Заказ
	              	|АВТОУПОРЯДОЧИВАНИЕ";
					
	Запрос.УстановитьПараметр("СсылкаЗаказ",СсылкаЗаказ);
	Запрос.УстановитьПараметр("Дата",КонецДня(Дата1));
	
	Массив = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Заказ"); //Выгрузить();//
	
	возврат Массив;
	
КонецФункции

//+++ только реализации 
Функция ПеречитатьСписокОтгрузок(массивЗаказов, минДатаЗаказов, максДата=неопределено) экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	РеализацияТоваровУслуг.ЗаказПокупателя КАК ЗаказПокупателя
	               |ИЗ
	               |	РегистрНакопления.Продажи.Обороты(
	               |			&НачалоПериода, &максДата
	               |			,
	               |			,
	               |			ЗаказПокупателя В (&МассивЗаказов)
	            //   |				И ДокументПродажи <> NULL
	           //    |				И ДокументПродажи.Проведен
			   		|) КАК РеализацияТоваровУслуг
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ЗаказПокупателя
	               |АВТОУПОРЯДОЧИВАНИЕ";
				   
	//только если реализация проведена - !
	Запрос.УстановитьПараметр("МассивЗаказов",массивЗаказов);
	Запрос.УстановитьПараметр("НачалоПериода", минДатаЗаказов);
	Запрос.УстановитьПараметр("максДата", ?(максДата=неопределено, КонецДня(ТекущаяДата()), КонецДня(максДата) ) );
	//#Если Сервер тогда
	результат = Запрос.Выполнить();
	рез = результат.Выгрузить().ВыгрузитьКолонку("ЗаказПокупателя");
	
	возврат рез;
	//#КонецЕсли
КонецФункции



//------Распознование адреса------------------
// начиная   с n до 6 поля, 7=7
	//стр2.Колонки.Добавить("Поле1");//индекс 
	//стр2.Колонки.Добавить("Поле2");//Область
	//стр2.Колонки.Добавить("Поле3");//Район
	//стр2.Колонки.Добавить("Поле4");//город
	//стр2.Колонки.Добавить("Поле5");//село
	//стр2.Колонки.Добавить("Поле6");//улица
	//стр2.Колонки.Добавить("Поле7");//дом
//
процедура Распознать(знач1, n)
	нКон = 0;	
	знач1 = СокрЛП(знач1);
	
		Если стрДлина(СокрЛП(знач1))=6 тогда
		знач2 = "";
			попытка 
				знач2 = Формат(Число(знач1),"ЧГ=0");
			исключение 
			конецПопытки;
			
			Если СокрЛП(знач2)=СокрЛП(знач1) тогда //индекс только из цифр
			нКон = 1;
			КонецЕсли;
		КонецЕсли;
		
		Если (Найти(знач1," обл")>0) или (Найти(нрег(знач1),"обл.")>0) или (Найти(нрег(знач1),"область")>0) 
			или (Найти(нрег(знач1),"республика")>0) или (Найти(нрег(знач1),"респ.")>0) тогда 
			нКон = 2; 
			Если ( Найти( нрег(знач1),"московская обл")>0 ) тогда
				знач1 = "Московская обл";
			КонецЕсли;	
			
		ИначеЕсли (Найти(нрег(знач1),"ярославль")>0) тогда
			нКон = 4;
			знач1 = "Ярославль"; // регион, но для нас - это Город!
		ИначеЕсли (Найти(нрег(знач1),"москва")>0) и (n<=2) тогда  //+++ 12.10.2011
			нКон = 4;
			знач1 = "Москва"; // регион, но для нас - это Город!
		ИначеЕсли (Найти(знач1,"МКАД")>0) тогда
			нКон = 4;
		иначеЕсли (знач1="МО") тогда
			нКон = 2;
			знач1 = "Московская обл"; // регион!
			
		ИначеЕсли (Найти(нрег(знач1)," р-н")>0) или (Найти(нрег(знач1)," р-он")>0) или (Найти(нрег(знач1)," район")>0) тогда
			нКон = 3;
		иначеЕсли (Найти(нрег(знач1),"г.")>0)   или (Найти(нрег(знач1),"город ")>0) или (Найти(нрег(знач1)," г")=СтрДлина(знач1)-1) тогда
			нКон = 4;
		иначеЕсли (Найти(нрег(знач1),"пос.")>0) или (Найти(нрег(знач1),"п.")=1) или (Найти(нрег(знач1),"поселок ")>0) или ( Найти(нрег(знач1)," п")=СтрДлина(знач1)-1)
			  ИЛИ (Найти(нрег(знач1),"сел.")>0) или (Найти(нрег(знач1),"с.")=1) или (Найти(нрег(знач1),"село ")>0) или ( Найти(нрег(знач1)," с")=СтрДлина(знач1)-1)
			  или (Найти(нрег(знач1),"ст.")>0)  или (Найти(нрег(знач1),"станция")>0)
			  ИЛИ (Найти(нрег(знач1),"дер.")>0) или (Найти(нрег(знач1),"деревня ")>0) тогда
			нКон = 4;
		иначеЕсли (Найти(нрег(знач1),"ул")>0)   или (Найти(нрег(знач1),"улица")>0) 
			  или (Найти(нрег(знач1),"пр-т")>0)  или (Найти(нрег(знач1),"проспект")>0)
			  или (Найти(нрег(знач1),"тр-т")>0)  или (Найти(нрег(знач1),"тракт")>0)
			  или (Найти(нрег(знач1),"пр-д")>0)  или (Найти(нрег(знач1),"проезд")>0) или (Найти(нрег(знач1),"пр.")>0)
			  или (Найти(нрег(знач1),"км.")>0)   или  (Найти(нрег(знач1),"километр")>0) 
			  или (Найти(нрег(знач1),"дор.")>0)  или  (Найти(нрег(знач1),"дорога")>0) 
			  или (Найти(нрег(знач1),"пл-дь")>0) или (Найти(нрег(знач1),"площадь")>0)
			  или (Найти(нрег(знач1),"пер.")>0)  или (Найти(нрег(знач1),"переулок")>0)
			  или (Найти(нрег(знач1),"ш.")>0)    или (Найти(нрег(знач1),"шоссе")>0) тогда
			нКон = 6;
// город, улица, дом  / или Обл., Район, деревня, дом
		иначеЕсли (Найти(нрег(знач1),"д.")>0) или (Найти(нрег(знач1),"дом")>0)
			 или  (Найти(нрег(знач1),"стр.")>0) или (Найти(нрег(знач1),"строение ")>0)или (n=7) тогда
			нКон = 7;
		КонецЕсли;	
		
	Знач1 = СокрЛП(знач1);
	Если Знач1="" тогда
		n=0;
	КонецЕсли;	
	
	n = нКон;//+++
	
Конецпроцедуры		

процедура РазбитьСтрокуНаПоля(стр0, ТаблЗнач1)
	
ТаблЗнач1 = неопределено;
ТаблЗнач1 =новый ТаблицаЗначений;
ТаблЗнач1.Колонки.Добавить("n");
ТаблЗнач1.Колонки.Добавить("Значение");

стр1 = стр0;// иначе значение меняется!

строка1 = СокрЛП(стр1);
Если строка1<>"" тогда 
		
		i=найти(строка1,","); L = стрДлина(строка1);
		n=1;
		пока i>0 и n<=7 цикл
		знач1 = СокрЛП(Лев(Строка1, i-1));
		
		//!!! распознавание - что это такое
		Распознать(знач1, n); 
		// переделывает значения n!
		
		Если n>0 тогда
			строка111 = ТаблЗнач1.Добавить();
			строка111.n = n;
			строка111.Значение = знач1; // запишем 
		иначе 
			//сообщить("Не распознано поле №"+n+" = '"+знач1+"' (для адреса: "+стр1+")");
			КонецЕсли;	
		n=n+1;
		Строка1 = Прав(Строка1, L-i);
		i=найти(строка1,","); L = стрДлина(строка1);
		КонецЦикла;	
КонецЕсли;

КонецПроцедуры


функция ОбработатьАдрес(Адрес1, НомерПоля1=2, НомерПоля2=6) Экспорт
	
	Табзнач1 = Неопределено;
	РазбитьСтрокуНаПоля(Адрес1, Табзнач1);
	рез = "";
	
	для i=0 по Табзнач1.количество()-1 цикл
		стр1 = Табзнач1[i];
	     //регион     //город
		Если (стр1.n>=НомерПоля1) и (стр1.n<=НомерПоля2) тогда
			рез = рез +СокрЛП(стр1.Значение)+", ";
		КонецЕсли;
	КонецЦикла;
	рез = Лев(рез, стрДлина(рез)-2);
	возврат рез;
	
КонецФункции	

функция ПолучитьКоординатыПоАдресуИзИнтернета(адрес1) Экспорт
	
		ОбработанныйАдрес = "";
		ОбработанныйАдрес = ОбработатьАдрес(адрес1);
	
		Широта=""; Долгота=""; Представление="";
		
		попытка
		ГеокодироватьАдрес(ОбработанныйАдрес, Широта, Долгота, Представление);
		исключение
		    Широта = 0;
			АдресИзИнтернета = ложь; //чтоб дальше - не из интернета
		КонецПопытки;
		
		Если (Широта=0) или (Долгота=0) тогда
			сообщить("Невозможно найти Координаты по адресу: "+ОбработанныйАдрес, СтатусСообщения.Внимание);
			//стр1.Координаты = стр1.Координаты; // не меняются!	
			возврат "";
		иначе	
			рез = строка(Широта)+","+строка(Долгота);
		конецЕсли;
		
	Возврат рез;
	
КонецФункции

процедура МенятьКоординаты(стр1) Экспорт
	
	Если АдресИзИнтернета тогда
		
		стр1.Координаты = ПолучитьКоординатыПоАдресуИзИнтернета(стр1.АдресДоставки);
		
// для Контрагента -> по адресу доставки, фактич. или юридич.адресу - в рс.КонтактнаяИнформация -> поле10
	 ИначеЕсли ЗначениеЗаполнено(стр1.Контрагент) тогда
	    Отбор1 = новый Структура("Объект", стр1.Контрагент);
		Отбор1.Вставить("Тип", перечисления.ТипыКонтактнойИнформации.Адрес);
		
		адрес1 = стр1.АдресДоставки;
		вид1 = Лев(адрес1, Найти(адрес1,":") - 1);
		Если вид1 ="Факт.адрес" тогда
			Отбор1.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента);
		иначеЕсли вид1 ="Юр.адрес" тогда
			Отбор1.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента);
		иначе// какой-то другой адрес доставки - только 1 раз - точный адрес!
			Если Вид1<>"" тогда 
				Вид2 = Справочники.ВидыКонтактнойИнформации.НайтиПоНаименованию(Вид1);
				Если Вид2 <> Справочники.ВидыКонтактнойИнформации.ПустаяСсылка() тогда
					Отбор1.Вставить("Вид", Вид2 ); 	
				КонецЕсли;	
			//иначе //найдет первый попавшийся адрес
			КонецЕсли;
		КонецЕсли;
		
		//------------------------------------------------------------	
	  Попытка
			рс = регистрыСведений.КонтактнаяИнформация.Получить(Отбор1);
			
		если рс<>Неопределено тогда 
			стр1.Координаты =  СокрЛП(рс.Поле10);
		иначе
			стр1.Координаты = "";
			Сообщить("В стр."+строка(стр1.НомерСтроки)+"  - не заполнено поле ""Координаты"" в адресе - "+адрес1, СтатусСообщения.Внимание);
		КонецЕсли;
	  исключение
	  КонецПопытки;
	Иначе
		Сообщить("В стр."+строка(стр1.НомерСтроки)+"  - не заполнено поле ""Контрагент"" !", СтатусСообщения.Внимание);
	КонецЕсли;	
	
КонецПроцедуры	
	
//-------------------------------------------------------------------------------
Функция YandexGeoCodeGetFile(Адрес, Ключ, ПроксиСервер, АдресOutput)

	
	Попытка 
		HTTPСервис = Новый HTTPСоединение("geocode-maps.yandex.ru",,,,ПроксиСервер,Ложь); 
		HTTPСервис.Получить("1.x/?geocode=" + EncodeURL(Адрес) + "&key=" + Ключ, АдресOutput); 
	Исключение 
		Сообщить("Ошибка подключения к интернет-картам: http://maps.yandex.ru", СтатусСообщения.Внимание); 
		Возврат Ложь;
	КонецПопытки; 

	Возврат Истина;
	
КонецФункции // YandexGeoCodeGetFile()

Функция YandexGeoCode(Адрес, Ключ, ПроксиСервер, Рез)
	
	Рез = Новый Структура("lat, lng, Представление", 0, 0, "");

	АдресOutput = КаталогВременныхФайлов() + "geores.xml";
	
	Если Не YandexGeoCodeGetFile(Адрес, Ключ, ПроксиСервер, АдресOutput) Тогда
		
		Возврат Ложь;	
	
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(АдресOutput);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументДОМ = ПостроительDOM.Прочитать(ЧтениеXML);
	СписокText = ДокументДОМ.ПолучитьЭлементыПоИмени("text");
	СписокPos = ДокументДОМ.ПолучитьЭлементыПоИмени("pos");
	
	Если (СписокText.Количество() = 0) ИЛИ (СписокPos.Количество() = 0) Тогда
		
		Возврат Ложь;	
		
	КонецЕсли;
	
	Рез.Представление = СписокText[0].ТекстовоеСодержимое;
	Рез.lng = СписокPos[0].ТекстовоеСодержимое;
	ПОз1 = Найти(Рез.lng," ");
	Рез.lat = Сред(Рез.lng, Поз1 + 1);
	Рез.lng = Лев(Рез.lng, Поз1 -1);
    Возврат Истина;
	
КонецФункции // GeoCode()

Функция ГеокодироватьАдрес(Адрес,Широта,Долгота,Представление="")Экспорт
	//Сообщить("Ищем адрес "+Адрес);
	Рез = Неопределено;
	Успешно=YandexGeoCode(Адрес, KeyAPIЯндекса, Неопределено, Рез);
	Широта = Рез.lat;
	Долгота = Рез.lng;
	Представление = Рез.Представление;
	Возврат Успешно;
КонецФункции

Функция hex(Знач Значение) 
	Значение=Число(Значение);
	Если Значение<=0 Тогда 
		Результат="0";
	Иначе
		Значение=Цел(Значение);
		Результат="";
		Пока Значение>0 Цикл
			Результат=Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Значение%16 + 1, 1) + Результат;
			Значение=Цел(Значение/16) ;
		КонецЦикла;
	КонецЕсли;
	Если СтрДлина(Результат) < 2 Тогда
	
		Результат = "0" + Результат;
	
	КонецЕсли; 
	Возврат "%" + Результат;
КонецФункции

Функция EncodeURL(URL)
	
	// отсюда: http://www.w3.org/International/URLUTF8Encoder.java
	
	Рез = "";
	
	Для Сч = 1 По СтрДлина(URL) Цикл
		
		ch = Сред(URL,Сч,1);
		vch = КодСимвола(ch);
		
		Если ("A" <= ch ) И ( ch <= "Z") Тогда		// "A".."Z"
			Рез = Рез + ch;
		ИначеЕсли ("a" <= ch ) И ( ch <= "z") Тогда	// "a".."z"
			Рез = Рез + ch;
		ИначеЕсли ("0" <= ch ) И ( ch <= "9") Тогда	// "0".."9"
			Рез = Рез + ch;
		ИначеЕсли (ch = " ") ИЛИ ( ch = "+") Тогда			// space
			Рез = Рез + "+";
		ИначеЕсли (ch = "-" ) ИЛИ ( ch = "_") Тогда		// unreserved
			// ch == '.' || ch == '!'
			// ch == '~' || ch == '*'
			// ch == '\'' || ch == '('
			// ch == ')') Тогда
			Рез = Рез + ch;
		ИначеЕсли (vch <= 127) Тогда		// other ASCII
			Рез = Рез + hex(vch);
		ИначеЕсли (vch <= 2047) Тогда		// non-ASCII <= 0x7FF
			Рез = Рез + hex(192 + Цел(vch / 64));
			Рез = Рез + hex(128 + (vch % 64));
		Иначе					// 0x7FF < ch <= 0xFFFF
			Рез = Рез + hex(224 + Цел(vch / 4096));
			Рез = Рез + hex(128 + (Цел(vch / 64) % 64));
			Рез = Рез + hex(128 + (vch % 64));
		КонецЕсли;
	     
	КонецЦикла; 
	
	Возврат Рез;

КонецФункции // ()

//---------------------------------------------------------------------- 
функция ПолучитьПредставление(Широта,Долгота) Экспорт//+++
		ШиротаЧ  = Число(Широта); 
	ДолготаЧ = Число(Долгота);
	Если ШиротаЧ>=0 тогда
		надписьШ = "с.ш. ";
	иначе 
		ШиротаЧ = -ШиротаЧ;
		надписьШ = "ю.ш. ";
	КонецЕсли;	
	Широта  = СокрЛП(Строка(Цел(ШиротаЧ)))+"°"+СокрЛП(Строка( Цел((ШиротаЧ - Цел(ШиротаЧ))*60) ))+"'"+СокрЛП(Строка(  Окр( (ШиротаЧ - Цел(ШиротаЧ) - Цел((ШиротаЧ - Цел(ШиротаЧ))*60)/60)*3600,0)  ))+""""; // 1' = 1 сухопутн. миля = 1 600 м >> 1" = 26,7 м
    	
	Если ДолготаЧ>=0 тогда
		надписьД = "в.д.";
	иначе 
		ДолготаЧ = - ДолготаЧ;
		надписьД = "з.д.";
	конецЕсли;	                  
	Долгота = СокрЛП(Строка(Цел(ДолготаЧ)))+"°"+СокрЛП(Строка( Цел((ДолготаЧ - Цел(ДолготаЧ))*60) ))+"'"+СокрЛП(Строка(  Окр( (ДолготаЧ - Цел(ДолготаЧ) - Цел((ДолготаЧ - Цел(ДолготаЧ))*60)/60)*3600,0)  ))+""""; // 1' = 1 морск. миля = 1 825 м >> 1"=30,5 м 
	
    возврат Широта+надписьШ+", "+Долгота+надписьД;
	
конецФункции	

функция получитьРасстояние12(город1, город2) Экспорт
	рез=0;
	
	Если СокрЛП(город1)="" или СокрЛП(город2)="" тогда
		возврат 0;
	КонецЕсли;
	город1 =СокрЛП(город1);
	город2 =СокрЛП(город2);
	
	если нрег(город1)=нрег(город2) тогда
		Возврат 0;
	КонецЕсли;	
	
	//--------удаление домов без д.  ,7 -------------
	//i=найти(город1,",");
	//пока i>0 цикл
	//город1 = лев(город1, i-1);
	//i=найти(город1,",");
	//КонецЦикла;
	//
	//i=найти(город2,",");
	//пока i>0 цикл
	//город2 = лев(город2, i-1);
	//i=найти(город2,",");
	//КонецЦикла;
	
		
//--------обработка удаления префиксов-------------------------
	табЗамены = новый ТаблицаЗначений;
	табЗамены.Колонки.Добавить("Значение");
	табЗамены.Колонки.Добавить("Размещение");
	стр1 = табЗамены.Добавить();
	стр1.Значение = "г."; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "пос."; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "п."; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	//стр1.Значение = "д."; стр1.Размещение="нач";
	//стр1 = табЗамены.Добавить();
	стр1.Значение = "дер."; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "г "; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "п "; стр1.Размещение="нач";
	стр1 = табЗамены.Добавить();
	стр1.Значение = " г"; стр1.Размещение="кон";
	стр1 = табЗамены.Добавить();
	стр1.Значение = " п"; стр1.Размещение="кон";
	стр1 = табЗамены.Добавить();
	стр1.Значение = " д"; стр1.Размещение="кон";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "город"; стр1.Размещение="везде";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "поселок"; стр1.Размещение="везде";
	стр1 = табЗамены.Добавить();
	стр1.Значение = "деревня"; стр1.Размещение="везде";
	
для k=0 по табЗамены.Количество()-1 цикл
стр1 = табЗамены[k];		
	i=Найти(нрег(город1),стр1.Значение); L=стрДлина(город1);  j = стрДлина(стр1.Значение);
	Если стр1.размещение="нач" тогда
		Если i=1 тогда
		город1 = Прав(город1, L - i - j + 1);
		прервать; // как только нашли - все, больше проверять не надо!
		КонецЕсли;
	иначеЕсли стр1.размещение="кон" тогда
		Если i=(L-j+1) тогда
		город1 = Лев(город1, i-1);
		прервать;
		КонецЕсли;
	иначе //Если стр1.размещение="везде" тогда
		Если i>0 тогда
		город1 = Лев(город1, i-1) + Прав(город1, L - i - j + 1);
		прервать;
		КонецЕсли;
	КонецЕсли;
//------------------------------
	i=Найти(нрег(город2),стр1.Значение); L=стрДлина(город2);  j = стрДлина(стр1.Значение);
	Если стр1.размещение="нач" тогда
		Если i=1 тогда
		город2 = Прав(город2, L - i - j + 1);
		прервать;
		КонецЕсли;
	иначеЕсли стр1.размещение="кон" тогда
		Если i=(L-j+1) тогда
		город2 = Лев(город2, i-1);
		прервать;
		КонецЕсли;
	иначе //Если стр1.размещение="везде" тогда
		Если i>0 тогда
		город2 = Лев(город2, i-1) + Прав(город2, L - i - j + 1);
		прервать;
		КонецЕсли;
	КонецЕсли;
 КонецЦикла;   	
//--------------------------------------------------------	
	город1 =СокрЛП(город1);
	город2 =СокрЛП(город2);
	
	
Запрос = Новый Запрос;
Запрос.Текст = "ВЫБРАТЬ
               |	Расстояния.Расстояние
               |ИЗ
               |	РегистрСведений.Расстояния КАК Расстояния
               |ГДЕ
               |	Расстояния.Город1 = &Город1
               |	И Расстояния.Город2 = &Город2";

Запрос.УстановитьПараметр("Город1", город1 );
Запрос.УстановитьПараметр("Город2", город2 );

Результат = Запрос.Выполнить();
Выборка = Результат.Выбрать();

Если Выборка.Следующий() тогда
	рез = выборка.расстояние;
КонецЕсли;	
	
	возврат рез;
	
КонецФункции

//прямой расчет по координатам по "средней широте"
функция получитьРасстояние(к1,к2) Экспорт
	
	Если (к1="") или (к2="") тогда
		возврат 0;
	КонецЕсли;	
	
	ГрВРад = 3.1415926535897932384626433832795/180;
	ГрадусДолготы0 = 111.195; //км = 60 миль = 1853.25 м * 60; (морская миля = 1852м)
	ГрадусШироты0  = 63.942;  //на 55 широте = 1065.7 м
	результат = 0;
   попытка
	ш1 = Число(Лев(к1, Найти(к1, ",")-1)); д1 = Число( Прав(к1, стрДлина(к1) - Найти(к1, ",")) );
	ш2 = Число(Лев(к2, Найти(к2, ",")-1)); д2 = Число( Прав(к2, стрДлина(к2) - Найти(к2, ",")) );
	
	если ш1=0 или ш2=0 тогда
	Ш = ГрВРад*(ш1+ш2);
	КонецЕсли;
	Ш = ГрВРад*(ш1+ш2)/2;
	
	ГрадусШироты   = 111.321*cos(Ш) - 0.094 * cos(3*Ш);
	ГрадусДолготы  = 111.143 - 0.562 * cos(2*ш2);  
	
	//----округляем до 2 км. (+-1 км) ------------
	Точн = 2;
	результат = Окр(  SQRT(pow( (д2-д1)*ГрадусДолготы,2) + pow((ш2-ш1)*ГрадусШироты,2) )/Точн, 0) * Точн;
	
	исключение
	конецПопытки;
	
	возврат результат;
	
КонецФункции



//---------------------------------------------
// август 2011
// поиск расстояний между всеми городами!
процедура  РассчитатьРасстояние() Экспорт
	
	i=1; город1 = "Ярославль";
	//для каждого стр0 из ЭлементыФормы.Заказы цикл  
	//стр1 = ЭлементыФормы.Заказы.ДанныеСтроки(стр0);//для порядка
   	 для каждого стр1 из Заказы цикл
		 
		город20 = ОбработатьАдрес(стр1.АдресДоставки, 4,4); //город
		Если Найти(город20,",")>0 тогда   //+++ 12.10.2011
			город20 = Лев(город20, Найти(город20,",")-1);
		КонецЕсли;
		
		город21 = город20;
		р12=0; флагМосква=Истина;
		
		Если город20="Москва" тогда//21.09.2011
			город2 = город20+", "+ОбработатьАдрес(стр1.АдресДоставки, 6, 7); // ул, дом.
			город21 = город2;
			р12 = получитьРасстояние12(город1, город2);
	 		Если р12<>0 тогда
		    стр1.Расстояние = р12;// км.
			иначе // наоборот
			р12 = получитьРасстояние12(город2, город1);
		    стр1.Расстояние = р12;// км.
			КонецЕсли;
		КонецЕсли;
		
		Если р12=0 тогда// если не нашли с улицей, ищем по городу
			город2 = город20;
			р12 = получитьРасстояние12(город1, город2);
	 		Если р12<>0 тогда
		    стр1.Расстояние = р12;// км.
			иначе // наоборот
			р12 = получитьРасстояние12(город2, город1);
		    стр1.Расстояние = р12;// км.
			КонецЕсли;
		КонецЕсли;	

		Если р12=0 и Найти(город1,",")>0 тогда// если не нашли с улицей 1го города, ищем по городу
			город11 = Лев(город1, Найти(город1,",")-1);
			р12 = получитьРасстояние12(город11, город2);
	 		Если р12<>0 тогда
		    стр1.Расстояние = р12;// км.
			иначе // наоборот
			р12 = получитьРасстояние12(город2, город11);
		    стр1.Расстояние = р12;// км.
			КонецЕсли;
		КонецЕсли;	

		Если город20="Москва" тогда//29.09.2011 сохраним для следующего шага
			город2 = город21; // ул, дом.
		КонецЕсли;

	Город1 = Город2; // для последующего хода...		
	КонецЦикла;
	
	
	//++++++++++ в последнюю строку - прибавим расстояние до Ярославля
	Город2 = "Ярославль";
	р12 = получитьРасстояние12(город1, город2);
	 Если р12<>0 тогда
		стр1 = Заказы[Заказы.Количество()-1];
	    стр1.Расстояние = стр1.Расстояние + р12;// км.
    иначе 
		р12 = получитьРасстояние12(город2, город1);
	 	Если р12<>0 тогда
		стр1 = Заказы[Заказы.Количество()-1];
	    стр1.Расстояние = стр1.Расстояние + р12;// км.
    	иначе 
		//Сообщить("Не найдено расстояние от: "+Город1+" до "+Город2, СтатусСообщения.Внимание);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

процедура  РассчитатьРасстояниеПоКоординатам(нашиКоординаты) Экспорт
	
	к1=нашиКоординаты;
	
	 для каждого стр1 из Заказы цикл

	
	к2 = стр1.Координаты;
	
	Если к2="" тогда
	   МенятьКоординаты(стр1);
	   к2=стр1.Координаты;
	КонецЕсли;	
	
	//-----------разделение на ш/д --------------
	стр1.Расстояние = получитьРасстояние(к1,к2);
	
	Если Стр1.НомерСтроки = Заказы.Количество() тогда
	к1 = к2;
	к2 = нашиКоординаты;
	стр1.Расстояние = стр1.Расстояние + получитьРасстояние(к1,к2);
	КонецЕсли;

 к1=к2;
КонецЦикла;

		
КонецПроцедуры	


ТарифДоставки = "Тариф доставки";

KeyAPIЯндекса = "ANpUFEkBAAAAf7jmJwMAHGZHrcKNDsbEqEVjEUtCmufxQMwAAAAAAAAAAAAvVrubVT4btztbduoIgTLAeFILaQ==";
мВерсияОбработки="v.003";
