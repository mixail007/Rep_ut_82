﻿
Процедура ПриОткрытии()
Поставщик     = справочники.Контрагенты.НайтиПоНаименованию("AquateX");
Если ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение.ОбособленноеПодразделение тогда
	Подразделение = ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение;
	//Склад  = справочники.Склады.НайтиПоКоду("01480"); // Ц-Рекламация
	Номенклатура  = справочники.Номенклатура.НайтиПоКоду("9271286");
Иначе 
	Подразделение = справочники.Подразделения.НайтиПоКоду("00005");
	Номенклатура  = справочники.Номенклатура.НайтиПоКоду("9271290");
КонецЕсли;

ЗаполнитьСкладыПоПодразделению(Подразделение); //09.10.2018

//Склад = ПолучитьСклад( Поставщик, Подразделение);
Статус = перечисления.СтатусыЗаказов.ВОбработке;

ЗаполнитьТоварыПоПоставщику();

 Ост1 = ПолучитьОстатокНаСкладе(Склад);
 Ост2 = ПолучитьОстатокНаСкладе(Склад2);
 ОстСв = ПолучитьСвОст();
 ЭлементыФормы.Надпись4.Заголовок = "Номенклатура "+Номенклатура.Код;

 КоманднаяПанель1Обновить(неопределено);
КонецПроцедуры

процедура ЗаполнитьСкладыПоПодразделению(Подразделение)
	Если Подразделение.Код = "00005" тогда
		Склад  = справочники.Склады.НайтиПоКоду("01480"); // Ц-Рекламация  - Запрещенный
		Склад2 = справочники.Склады.НайтиПоКоду("00821"); // ЦЦЛ-3
	ИначеЕсли Подразделение.Код = "00112" тогда //Задача № 56189
		Склад  = справочники.Склады.НайтиПоКоду("12246"); // СПБ Перемещения  - Запрещенный
		Склад2 = справочники.Склады.НайтиПоКоду("12160"); // СПС-1
	иначе
		Склад  = справочники.Склады.ПустаяСсылка();
		Склад2 = справочники.Склады.ПустаяСсылка();
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьТоварыПоПоставщику()

ЭлементыФормы.Номенклатура.СписокВыбора.Очистить();

//	 В ярославле на склад стороннего поставщика приходуются
если (Подразделение.Код = "00005") тогда
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271288") );
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271290") );
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271285") );
иначе //На склад СПб в эту обработку нужно добавить
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271287") );
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271286") );
ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( справочники.Номенклатура.НайтиПоКоду("9271289") );
КонецЕсли;

	запрос = новый Запрос;
	запрос.текст = "ВЫБРАТЬ
	               |	ОстаткиНоменклатурыКонтрагентов.Номенклатура,
	               |	выбор когда ОстаткиНоменклатурыКонтрагентов.Остаток>0 тогда Истина иначе ЛОЖЬ Конец как Пометка
	               |ИЗ
	               |	РегистрСведений.ОстаткиНоменклатурыКонтрагентов КАК ОстаткиНоменклатурыКонтрагентов
	               |ГДЕ
	               |	ОстаткиНоменклатурыКонтрагентов.Подразделение = &Подразделение
	               |	И ОстаткиНоменклатурыКонтрагентов.Контрагент = &Поставщик
				//   |    И НЕ ОстаткиНоменклатурыКонтрагентов.Номенклатура в (&ФиксСписок)
	               |	";
	 запрос.УстановитьПараметр("Поставщик", Поставщик);
	 запрос.УстановитьПараметр("Подразделение", ?(Подразделение.ОбособленноеПодразделение, Подразделение, справочники.Подразделения.ПустаяСсылка() ) );
	// запрос.УстановитьПараметр("ФиксСписок", ЭлементыФормы.Номенклатура.СписокВыбора.ВыгрузитьЗначения() ); //09.10.2018
	 выборка = запрос.Выполнить().Выбрать();
	 
	 пока выборка.Следующий() цикл
		 эл1 = ЭлементыФормы.Номенклатура.СписокВыбора.НайтиПоЗначению(выборка.Номенклатура);
		 если эл1=неопределено тогда
		 	ЭлементыФормы.Номенклатура.СписокВыбора.Добавить( выборка.Номенклатура ,, выборка.пометка);
		 иначе
			эл1.Пометка = выборка.пометка;
		 КонецЕсли;	
	 КонецЦикла;

КонецПроцедуры

//-------------вспомогательные функции-----------------------
функция ПолучитьОстатокНаСкладе(скл)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки( ,
	|			Номенклатура = &Номенклатура
	|				И Склад = &Склад) КАК ТоварыНаСкладахОстатки";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Склад", скл);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() тогда
	рез = выборка.КоличествоОстаток;
	иначе рез = 0;
	КонецЕсли;

	возврат рез;
	
КонецФункции	

функция ПолучитьСвОст()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТоварыНаСкладахОстатки.Номенклатура,
	               |	ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК Остаток,
	               |	ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) КАК Заказано,
	               |	ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) - ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) КАК ОстСв
	               |ИЗ
	               |	РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура = &Номенклатура
	               |				И склад.ЗапретитьИспользование = ЛОЖЬ
				   |			//Склад!
	               |				И склад.Транзитный = ЛОЖЬ) КАК ТоварыНаСкладахОстатки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки( ,Номенклатура = &Номенклатура
	               |					И ЗаказПокупателя.Проверен
	               |					И ЗаказПокупателя.Подразделение = &Подразделение) КАК ЗаказыПокупателейОстатки
	               |		ПО ТоварыНаСкладахОстатки.Номенклатура = ЗаказыПокупателейОстатки.Номенклатура";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Если Подразделение.ОбособленноеПодразделение тогда
		запрос.Текст = стрЗаменить(запрос.Текст, "//Склад!"," И Склад.Транзитный = Истина и Склад.Подразделение = &ПодразделениеСк ");
		Запрос.УстановитьПараметр("ПодразделениеСк", Подразделение)
	Иначе
		запрос.Текст = стрЗаменить(запрос.Текст, "//Склад!"," И Склад.Транзитный = ЛОЖЬ");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() тогда
		рез = выборка.ОстСв;
	иначе
		рез = 0;
	КонецЕсли;
	
	возврат рез;
КонецФункции

функция Переместить12(ск1, ск2, кол, Коммент="" )

	докПеремещения = документы.ПеремещениеТоваров.СоздатьДокумент();
	докПеремещения.Дата = ТекущаяДата();
	докПеремещения.ВидОперации = Перечисления.ВидыОперацийПеремещениеТоваров.ТоварыПродукция;
	докПеремещения.СкладОтправитель = ск1;
	докПеремещения.СкладПолучатель  = ск2;
	докПеремещения.Подразделение    = Подразделение;
	докПеремещения.Организация   = справочники.Организации.НайтиПоКоду("00001");
	докПеремещения.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	докПеремещения.ОтражатьВУправленческомУчете = истина;
	докПеремещения.Комментарий = Коммент;
	
	тов = докПеремещения.Товары.Добавить();
	тов.Номенклатура = Номенклатура;
	тов.ЕдиницаИзмерения = Номенклатура.ЕдиницаХраненияОстатков;
	тов.Коэффициент = 1;
	тов.Качество = справочники.Качество.Новый;
	тов.Количество = кол;
	тов.Склад = ск2;
	попытка
		докПеремещения.Записать( РежимЗаписиДокумента.Проведение );
		Сообщить("Создан документ перемещения № "+строка(докПеремещения.Номер)+" на "+строка(Кол)+" шт. со склада "+строка(Ск1)+" >> "+строка(Ск2), СтатусСообщения.Информация);
		рез = докПеремещения.Ссылка;
	исключение	
		Сообщить("Ошибка при проведении документа перемещения! "+ОписаниеОшибки(), СтатусСообщения.Внимание);
		рез = документы.ПеремещениеТоваров.ПустаяСсылка();
	КонецПопытки;
	возврат рез;
	
КонецФункции

//===========ОСНОВНЫЕ ФУНКЦИИ===========================

//---------------------------------------------------------
Процедура КоманднаяПанель1Обновить(Кнопка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛОЖЬ КАК Флаг,
	               |	ЗаказыПокупателейОстатки.ЗаказПокупателя.Проверен КАК Проверен,
	               |	ЗаказыПокупателейОстатки.ЗаказПокупателя.Статус КАК Статус,
	               |	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	               |	ВЫБОР
	               |		КОГДА ЗаказыПокупателейОстатки.ДоговорКонтрагента.Наименование ПОДОБНО ""%*%""
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК БезНал,
	               |	ЗаказыПокупателейОстатки.ДоговорКонтрагента.ОтветственноеЛицо КАК Менеджер,
	               |	ЗаказыПокупателейОстатки.КоличествоОстаток КАК Количество,
	               |	ЗаказыПокупателейОстатки.ДоговорКонтрагента,
	               |	ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец КАК Клиент
	               |ИЗ
	               |	РегистрНакопления.ЗаказыПокупателей.Остатки( ,
	               |			ЗаказПокупателя.Подразделение = &Подразделение
	               |				И (ЗаказПокупателя.Поставщик = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	               |					ИЛИ (ЗаказПокупателя.Поставщик = &Поставщик
	               |						 И ЗаказПокупателя.Статус = &Статус)
				   |                   ) 
	               |				И Номенклатура = &Номенклатура) КАК ЗаказыПокупателейОстатки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	БезНал,
	               |	Проверен УБЫВ,
	               |	ЗаказПокупателя";
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Статус", Статус);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить();
	ТабличноеПоле1 = Результат.Выгрузить();
	
КонецПроцедуры

//---------------------------------------------------------
Процедура КнопкаПодтвердить(Кнопка)
	Если ОстСв<>0 тогда
		Предупреждение("Свободный остаток не равен нулю!", 10);
	КонецЕсли;
	
	Статус = перечисления.СтатусыЗаказов.Получен; //все товары есть на складе
	КолСписания = 0; СписЗак="";
	
	Для каждого стр1 из ТабличноеПоле1 цикл
		Если не стр1.флаг тогда 
			Продолжить; 
		КонецЕсли;
		
		Если стр1.ЗаказПокупателя.Проверен тогда
			Если стр1.Статус=перечисления.СтатусыЗаказов.Подтвержден тогда
				сообщить("Заказ № "+строка(стр1.ЗаказПокупателя.Номер)+" уже проделен и в статусе: "+ строка(стр1.Статус) );
			иначе
				ЗакОб = стр1.ЗаказПокупателя.ПолучитьОбъект();
				ЗакОб.Поставщик = Поставщик;
				ЗакОб.Статус = Статус;
				попытка 
					ЗакОб.Записать();   // только статус и поставщика
					стр1.Статус = Статус;
					сообщить("Заказ № "+строка(стр1.ЗаказПокупателя.Номер)+" изменен статус на: "+ строка(стр1.Статус) );
				исключение
					сообщить("Заказ № "+строка(стр1.ЗаказПокупателя.Номер)+" не удалось изменеть статус: "+ ОписаниеОшибки(), СтатусСообщения.Внимание );
				КонецПопытки;
			КонецЕсли;	
		Иначе
			КолСписания = КолСписания + стр1.Количество;
			СписЗак = СписЗак+ стр1.ЗаказПокупателя.Номер+",";
		КонецЕсли;

	КонецЦикла;	
	
	Если КолСписания=0 тогда
		Предупреждение("Не выбрано ни одного заказа!", 10);
		Возврат;
	КонецЕсли;	
		
	
	регСв = РегистрыСведений.ОстаткиНоменклатурыКонтрагентов.СоздатьМенеджерЗаписи();
	регСв.Контрагент    = Поставщик;
	регСв.Подразделение = Подразделение;
	регСв.Номенклатура  = Номенклатура;
	регСв.Прочитать();
	кол0 = регСв.Остаток;
	
	колОст = ПолучитьОстатокНаСкладе(Склад);
	
	Если КолСписания>колОст тогда 
		Предупреждение("На складе "+строка(Склад)+" не хватает "+строка(КолСписания-колОст)+" шт.!", 10);
		возврат;
	Иначе
		сообщить("На складе "+строка(Склад)+" количество "+строка(кол0)+" шт., списывается "+строка(КолСписания)+" на склад "+строка(Склад2), СтатусСообщения.Информация);
	КонецЕсли;
	
//--------------------делаем перемещение-----------------------	
докПерем = Переместить12( Склад, Склад2, КолСписания,"Подтверждение заказов "+СписЗак+" по товару "+Номенклатура.Код);
Если докПерем.Пустая() тогда 
	возврат; 
КонецЕсли;

//==============Меняем количество стороннего поставщика=========================	
КолСписания2 = 0; СписЗак="";
  Для каждого стр1 из ТабличноеПоле1 цикл
		Если не стр1.флаг тогда продолжить; 
		КонецЕсли;
		закОб = стр1.ЗаказПокупателя.ПолучитьОбъект();
		закОб.Поставщик = Поставщик;
		закОб.Статус = Статус;
		закОб.проверен = истина;
	   Попытка
		закОб.Записать(РежимЗаписиДокумента.Проведение); // без перепроведения?!
		стр1.Статус   = Статус;	
		стр1.Проверен = ЛОЖЬ;
		Сообщить("Проведен и проделен заказ № "+строка(стр1.ЗаказПокупателя.Номер), СтатусСообщения.Информация);
	   Исключение
		КолСписания2 = КолСписания2 + стр1.Количество; // НЕ ПРОВЕЛОСЬ - надо обратно вернуть!
		Сообщить("Ошибка при проведении заказа № "+строка(стр1.ЗаказПокупателя.Номер)+" : "+ОписаниеОшибки(), СтатусСообщения.Внимание);
	   КонецПопытки;
КонецЦикла;

Если КолСписания2>0 тогда
	докОб = докПерем.ПолучитьОбъект();
	докОб.Товары[0].Количество = докОб.Товары[0].Количество -  КолСписания2; //уменьшаем число перемещений на КолСписания2
	докОб.Комментарий= докОб.Комментарий+" - "+строка(КолСписания2)+"шт. не подтвердились заказы: "+СписЗак;
	попытка
		докОб.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить("ОШИБКА в перемещении "+строка(КолСписания2)+"шт. не подтвердились заказы!", СтатусСообщения.Внимание);
	КонецПопытки;		
КонецЕсли;

	Ост1 = ПолучитьОстатокНаСкладе(Склад);
	Ост2 = ПолучитьОстатокНаСкладе(Склад2);
	
	регСв = РегистрыСведений.ОстаткиНоменклатурыКонтрагентов.СоздатьМенеджерЗаписи();
	регСв.Контрагент    = Поставщик;
	регСв.Подразделение = ?(Подразделение.ОбособленноеПодразделение, Подразделение, справочники.Подразделения.ПустаяСсылка() ); // для Ярославля не надо!
	регСв.Номенклатура  = Номенклатура;
	регСв.Остаток =  Ост1;
	регСв.Записать(Истина);
	сообщить("На складе "+строка(Склад)+" количество стало "+строка(Ост1)+" шт.", СтатусСообщения.Информация);

 ОстСв = ПолучитьСвОст();
 сообщить("------------------Подтверждение заказов завершено!------------------");	
	
КонецПроцедуры

//---------------------------------------------------------
Процедура КнопкаОтказать(Кнопка)
	Если ОстСв<>0 тогда
		Предупреждение("Свободный остаток не равен нулю!", 10);
	КонецЕсли;
	
	КолСписания  = 0;  списЗак="";
	Статус = перечисления.СтатусыЗаказов.Отменен;
	
	Для каждого стр1 из ТабличноеПоле1 цикл
		Если не стр1.флаг тогда 
			Продолжить; 
		КонецЕсли;
		
		Если НЕ стр1.ЗаказПокупателя.Проверен тогда //ничего делать не надо
			сообщить("Заказ № "+строка(стр1.ЗаказПокупателя.Номер)+" будет переведен в статус ""Отменен поставщиком""!");
			закОб = стр1.ЗаказПокупателя.ПолучитьОбъект();
			закОб.Поставщик = Поставщик;
			закОб.Статус = Статус;
			попытка 
				закОб.Записать();
				стр1.Статус = Статус;	
			исключение
				сообщить("Не удалось изменить заказ № "+строка(стр1.ЗаказПокупателя.Номер)+": "+ОписаниеОшибки(), СтатусСообщения.Важное);
			КонецПопытки;	
		Иначе //---------------------------------------------------
			сообщить("Заказ № "+строка(стр1.ЗаказПокупателя.Номер)+" будет снят с резерва!");
			закОб = стр1.ЗаказПокупателя.ПолучитьОбъект();
			закОб.Статус = Статус;
			закОб.Поставщик = Поставщик;
			закОб.Проверен = ЛОЖЬ;
			попытка  // появится св.остаток! который сразу надо переместить ОБРАТНО! на Ц-Рекламацию
				закОб.Записать();
			стр1.Статус   = Статус;	
			стр1.Проверен = ЛОЖЬ;
			КолСписания = КолСписания + стр1.Количество;
			списЗак = списЗак+закОб.Номер+",";
			исключение
				сообщить("Не удалось изменить заказ № "+строка(стр1.ЗаказПокупателя.Номер)+": "+ОписаниеОшибки(), СтатусСообщения.Важное);
			КонецПопытки;	
		КонецЕсли;
	КонецЦикла;	
	
	Если КолСписания>0 тогда
		
		//---------------делаем перемещение назад-----------------------	
		Если КолСписания>Ост2 тогда 
			Предупреждение("На складе "+строка(Склад2)+" остаток "+строка(ост2)+"шт. не хватает "+строка(КолСписания-Ост2)+" шт.!", 10);
			сообщить("---Перещение не сделано! На складе "+строка(Склад2)+" остаток: "+строка(ост2)+"шт. не хватает "+строка(КолСписания-Ост2)+" шт.!---------", СтатусСообщения.Внимание);
			возврат;
			
		Иначе
			сообщить("На складе "+строка(Склад2)+" количество "+строка(Ост2)+" шт., списывается "+строка(КолСписания)+" на склад "+строка(Склад), СтатусСообщения.Информация);
		КонецЕсли;

		докПерем = Переместить12( Склад2, Склад, КолСписания, "Отказ заказов: "+списЗак+" по товару "+Номенклатура.Код);
		Если докПерем.Пустая() тогда 
			возврат; 
		КонецЕсли;
		
	Ост1 = ПолучитьОстатокНаСкладе(Склад);
	Ост2 = ПолучитьОстатокНаСкладе(Склад2);
	
	регСв = РегистрыСведений.ОстаткиНоменклатурыКонтрагентов.СоздатьМенеджерЗаписи();
	регСв.Контрагент    = Поставщик;
	регСв.Подразделение = ?(Подразделение.ОбособленноеПодразделение, Подразделение, справочники.Подразделения.ПустаяСсылка() ); // для Ярославля не надо!
	регСв.Номенклатура  = Номенклатура;
	регСв.Остаток =  Ост1;
	регСв.Записать(Истина);
	сообщить("На складе "+строка(Склад)+" количество стало "+строка(Ост1)+" шт.", СтатусСообщения.Информация);
	КонецЕсли;

	ОстСв = ПолучитьСвОст();
 	сообщить("------------------Отказ заказов завершен!------------------");	
	
КонецПроцедуры

Процедура ОстСвОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	
ОстСв = ПолучитьСвОст();

	Если ОстСв=0 тогда
		Возврат;
	КонецЕсли;
	
	Если ОстСв>0 тогда
		Коммент = "# Автоматическое устранение + св.остатка "+строка(ОстСв)+"шт. по товару "+Номенклатура.Код;
		рез = Переместить12(Склад2, Склад, +ОстСв, Коммент );
	ИначеЕсли ОстСв<0 тогда
		Коммент = "# Автоматическое устранение - св.остатка "+строка(-ОстСв)+"шт. по товару "+Номенклатура.Код;
		рез = Переместить12(Склад, Склад2,-ОстСв, Коммент );
	КонецЕсли;
	
ОстСв = ПолучитьСвОст();

КонецПроцедуры

//===================Интерфейсные=======================
процедура флаги(Вариант=0)
	для Каждого стр1 из ТабличноеПоле1 цикл
		стр1.флаг = ?(Вариант=1, Истина,
						?(Вариант=0, ЛОЖЬ, не стр1.флаг));
	КонецЦикла;	
КонецПроцедуры	

Процедура КоманднаяПанель2Флаг0(Кнопка)
	флаги(0);
КонецПроцедуры

Процедура КоманднаяПанель2Флаг1(Кнопка)
	флаги(1);
КонецПроцедуры

Процедура КоманднаяПанель2Флаг2(Кнопка)
	флаги(2);
КонецПроцедуры


Процедура СкладПриИзменении(Элемент)
	Если не Склад.ЗапретитьИспользование тогда
		Предупреждение("Склад должен быть запрещенным!",10);
		Склад = справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	Если Склад.Подразделение <> ?(Подразделение.ОбособленноеПодразделение, Подразделение, справочники.Подразделения.ПустаяСсылка() ) тогда
		Предупреждение("Склад должен принадлежать Подразделению!",10);
		Склад = справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	Ост1 = ПолучитьОстатокНаСкладе(Склад);
КонецПроцедуры

Процедура Склад2ПриИзменении(Элемент)
	Если Склад2.ЗапретитьИспользование тогда
		Предупреждение("Склад поступления НЕ может быть запрещенным!",10);
		Склад2 = справочники.Склады.ПустаяСсылка();
	КонецЕсли;	
	Если Склад2.Подразделение <> ?(Подразделение.ОбособленноеПодразделение, Подразделение, справочники.Подразделения.ПустаяСсылка() ) тогда
		Предупреждение("Склад должен принадлежать Подразделению!",10);
		Склад2 = справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	Ост2 = ПолучитьОстатокНаСкладе(Склад2);
КонецПроцедуры


Процедура ТабличноеПоле1ПриПолученииДанных(Элемент, ОформленияСтрок)
	для каждого стр1 из ОформленияСтрок цикл
		Если стр1.данныеСтроки.БезНал тогда
			стр1.ЦветФона = webЦвета.СветлоРозовый;
		КонецЕсли;	
		Если НЕ стр1.данныеСтроки.Проверен тогда
			стр1.Шрифт = новый Шрифт(стр1.Шрифт,,,Истина);//жирный
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

Процедура НоменклатураПриИзменении(Элемент)
	
	ЭлементыФормы.Надпись4.Заголовок = "Номенклатура "+Номенклатура.Код;
	
	Ост1 = ПолучитьОстатокНаСкладе(Склад);
	Ост2 = ПолучитьОстатокНаСкладе(Склад2);
	ОстСв = ПолучитьСвОст();
 	КоманднаяПанель1Обновить(неопределено);

КонецПроцедуры


Процедура ПоставщикПриИзменении(Элемент)
	
	ЗаполнитьТоварыПоПоставщику();
	Если ЭлементыФормы.Номенклатура.СписокВыбора.Количество()>0 тогда
	 Номенклатура = ЭлементыФормы.Номенклатура.СписокВыбора[0].Значение;
    КонецЕсли;
	
	НоменклатураПриИзменении(неопределено);

КонецПроцедуры


Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьСкладыПоПодразделению(Подразделение);
    ЗаполнитьТоварыПоПоставщику();
    
	Если ЭлементыФормы.Номенклатура.СписокВыбора.Количество()>0 тогда
	 Эл1 = ЭлементыФормы.Номенклатура.СписокВыбора[0];
	 Номенклатура = Эл1.Значение;
	 // эл1.Пометка = есть у стор.поставщика!
	иначе
	 Номенклатура = справочники.Номенклатура.ПустаяСсылка();
	 Предупреждение("Для "+строка(Подразделение)+" нет товаров стороннего поставщика "+строка(Поставщик), 30);
 	КонецЕсли;
	
	НоменклатураПриИзменении(неопределено);
	
КонецПроцедуры

