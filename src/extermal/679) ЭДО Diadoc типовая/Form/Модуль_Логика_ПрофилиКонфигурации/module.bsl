﻿//////////////////////////////////////////
// Общие функции работы с профилем
//////////////////////////////////////////

Функция СформироватьПрофильКонфигурации() Экспорт
	стПрофильКонфигурации = Новый Структура;
	
	Если Метаданные.Справочники.Найти("НоменклатураПоставщиков") <> Неопределено Тогда
		стПрофильКонфигурации.Вставить("ХранениеНоменклатурыПоставщиков", Новый Структура("Вариант", "Справочник_НоменклатураПоставщиков"));
	ИначеЕсли Метаданные.РегистрыСведений.Найти("НоменклатураКонтрагентов") <> Неопределено Тогда
		стПрофильКонфигурации.Вставить("ХранениеНоменклатурыПоставщиков", Новый Структура("Вариант", "РегистрСведений_НоменклатураКонтрагентов"));
	ИначеЕсли Метаданные.РегистрыСведений.Найти("НоменклатураПоставщика") <> Неопределено Тогда 
		стПрофильКонфигурации.Вставить("ХранениеНоменклатурыПоставщиков", Новый Структура("Вариант", "РегистрСведений_НоменклатураПоставщика"));
	ИначеЕсли Метаданные.РегистрыСведений.Найти("ЗначенияСвойствОбъектов") <> Неопределено Тогда 
		стПрофильКонфигурации.Вставить("ХранениеНоменклатурыПоставщиков", Новый Структура("Вариант", "СвойстваОбъектов_Номенклатура"));
	Иначе
		стПрофильКонфигурации.Вставить("ХранениеНоменклатурыПоставщиков", Новый Структура("Вариант", Неопределено));
	КонецЕсли;
	
	Если Метаданные.Справочники.Номенклатура.Реквизиты.Найти("Услуга") <> Неопределено Тогда
		стПрофильКонфигурации.Вставить("Услуги", Новый Структура("Вариант, Реквизит, ЗначениеРеквизита", "ПоРеквизиту", "Услуга", Истина));
	ИначеЕсли Метаданные.Справочники.Номенклатура.Реквизиты.Найти("ВидТовара") <> Неопределено Тогда
		стПрофильКонфигурации.Вставить("Услуги", Новый Структура("Вариант, Реквизит, ЗначениеРеквизита", "ПоРеквизиту", "ВидТовара", Перечисления.ВидыТоваров.Услуга));
	Иначе
		стПрофильКонфигурации.Вставить("Услуги", Новый Структура("Вариант", "ПоТипуНоменклатуры"));
	КонецЕсли;
	
	Если Метаданные.Справочники.Номенклатура.Реквизиты.Найти("Артикул") <> Неопределено Тогда
		стПрофильКонфигурации.Вставить("ЕстьАртикул", Истина);
	Иначе
		стПрофильКонфигурации.Вставить("ЕстьАртикул", Ложь);
	КонецЕсли;
	
	Если ПолучитьФорму("Модуль_1САдаптер").ОпределитьПрофиль_НастройкиТекущегоПользователя() = "Модуль_1САдаптерНастройкиТекущегоПользователя_Рарус" Тогда
		стПрофильКонфигурации.Вставить("ХранениеНастроекПользователей", Новый Структура("Вариант", "Рарус"));
	Иначе
		стПрофильКонфигурации.Вставить("ХранениеНастроекПользователей", Новый Структура("Вариант", "1С"));
	КонецЕсли;
	
	//определим доступные операции по поступлению
	стОперацииПоступления = Новый Структура;
	стОперацииПоступления.Вставить("ПоступлениеОборудования",  метаданные.Справочники.Найти("ОБъектыСтроительства")<>Неопределено);
	стОперацииПоступления.Вставить("ВозвратОтПокупателя",   найти(  метаданные.синоним, "Альфа-Авто") = 0   );
	стОперацииПоступления.Вставить("ПоступлениеНМА", Метаданные.Документы.Найти("ПоступлениеНМА") <> Неопределено);
	стПрофильКонфигурации.Вставить("НастройкиПоступления",  стОперацииПоступления);
	
	//определим справочник, в котором хранится список подразделений
	МассивПрикладныхРешенийИсключений = Новый Массив;
	МассивПрикладныхРешенийИсключений.Добавить("Модуль_ИнтеграцияАльфаАвто41");
	МассивПрикладныхРешенийИсключений.Добавить("Модуль_ИнтеграцияБух");
	МассивПрикладныхРешенийИсключений.Добавить("Модуль_ИнтеграцияТКПТ");
	МассивПрикладныхРешенийИсключений.Добавить("Модуль_ИнтеграцияДалионУМ");
	
	ИндексЭлементаМассива = МассивПрикладныхРешенийИсключений.Найти(ИмяФормыПрикладногорешенияДляИнтеграцииДиадок());
	стПрофильКонфигурации.Вставить("ИспользоватьСопоставлениеПодразделений", ?(ИндексЭлементаМассива=Неопределено, Истина, Ложь)) ;
	
	Если НЕ Метаданные.Справочники.Найти("ПодразделенияОрганизаций") = Неопределено Тогда
		стПрофильКонфигурации.Вставить("НаименованиеСправочникаПодразделений", "ПодразделенияОрганизаций");
	ИначеЕсли НЕ Метаданные.Справочники.Найти("ПодразделенияКомпании") = Неопределено Тогда 
		стПрофильКонфигурации.Вставить("НаименованиеСправочникаПодразделений", "ПодразделенияКомпании");
	Иначе
		стПрофильКонфигурации.Вставить("НаименованиеСправочникаПодразделений", "Подразделения");
	КонецЕсли;
	
	стПрофильКонфигурации.Вставить("НаименованиеСправочникаСкладов", ?(метаданные.справочники.найти("СкладыКомпании")<>Неопределено, "СкладыКомпании", "Склады"));
	стПрофильКонфигурации.Вставить("НаименованиеСправочникаДоговоров", ?(метаданные.справочники.найти("ДоговорыКонтрагентов")<>Неопределено, "ДоговорыКонтрагентов", ?(Метаданные.Справочники.Найти("ДоговорыВзаиморасчетов")<> Неопределено, "ДоговорыВзаиморасчетов", "Договоры")));
	стПрофильКонфигурации.Вставить("НаименованиеСправочникаОрганизации", ?(метаданные.справочники.найти("Организации")<>Неопределено, "Организации", "Фирмы"));
	
	
	стПрофильКонфигурации.Вставить("АнализироватьВидОперацииРТУ", (ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияУПП13") или (ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияКА") );
	
	Возврат стПрофильКонфигурации;
КонецФункции



//////////////////////////////////////////
// Работа с номенклатурой поставщика
//////////////////////////////////////////

Функция ПолучитьНоменклатуруПоставщика(Контрагент, НаименованиеНоменклатуры, КодНоменклатуры, АртикулНоменклатуры) Экспорт
	
	КодНоменклатуры = ?(ПустаяСтрока(КодНоменклатуры), Неопределено, КодНоменклатуры);
	АртикулНоменклатуры = ?(ПустаяСтрока(АртикулНоменклатуры), Неопределено, АртикулНоменклатуры);
	НаименованиеНоменклатуры=	?(ПустаяСтрока(НаименованиеНоменклатуры), Неопределено, НаименованиеНоменклатуры);
	Номенклатура = Неопределено;    
	Выборка = Неопределено;
	стПрофильКонфигурации = ПолучитьПрофильКонфигурации();
		
	Если стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "Справочник_НоменклатураПоставщиков" Тогда
		Выборка = ПолучитьВыборкуПоСпрНомПост(Контрагент, "Идентификатор", КодНоменклатуры);
		Если Выборка.Количество() = 0 Тогда
			Выборка = ПолучитьВыборкуПоСпрНомПост(Контрагент, "Артикул", АртикулНоменклатуры);
			Если Выборка.Количество() = 0 Тогда
				Если (Выборка.Количество() = 0) и (ЗначениеЗаполнено(КодНоменклатуры)=Ложь) и (ЗначениеЗаполнено(АртикулНоменклатуры)=Ложь) Тогда
					Выборка = ПолучитьВыборкуПоСпрНомПост(Контрагент, "Наименование", НаименованиеНоменклатуры);
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "РегистрСведений_НоменклатураКонтрагентов" Тогда
		Выборка = ПолучитьВыборкуПоРегСведНомПост(Контрагент, "КодНоменклатурыКонтрагента", КодНоменклатуры);
		Если Выборка=Неопределено ИЛИ Выборка.Количество()=0 Тогда
			Выборка = ПолучитьВыборкуПоРегСведНомПост(Контрагент, "ШтрихКодНоменклатурыКонтрагента", КодНоменклатуры);
			Если Выборка=Неопределено ИЛИ Выборка.Количество()=0 Тогда
				Выборка = ПолучитьВыборкуПоРегСведНомПост(Контрагент, "АртикулНоменклатурыКонтрагента", АртикулНоменклатуры);
				Если Выборка=Неопределено ИЛИ (Выборка.Количество()=0) И (ЗначениеЗаполнено(КодНоменклатуры)=Ложь) И (ЗначениеЗаполнено(АртикулНоменклатуры)=Ложь) Тогда
					Выборка = ПолучитьВыборкуПоРегСведНомПост(Контрагент, "НаименованиеНоменклатурыКонтрагента", НаименованиеНоменклатуры, "ПОДОБНО");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "РегистрСведений_НоменклатураПоставщика" Тогда
		
		РезультатЗапроса= Неопределено;
		
		Если ЗначениеЗаполнено(КодНоменклатуры) Тогда
			РезультатЗапроса= ПолучитьРезультатЗапросаПоРегиструНоменклатураПоставщика(Контрагент, "Код", КодНоменклатуры);
		КонецЕсли;
		
		Если (РезультатЗапроса = Неопределено ИЛИ РезультатЗапроса.Пустой()) И ЗначениеЗаполнено(АртикулНоменклатуры) Тогда
			РезультатЗапроса= ПолучитьРезультатЗапросаПоРегиструНоменклатураПоставщика(Контрагент, "Артикул", АртикулНоменклатуры);
		КонецЕсли;
		
		// Поиск по наименованию выполняется только в том случае, если попыток получить номенклатуру выше небыло: РезультатЗапроса = Неопределено.
		Если РезультатЗапроса = Неопределено И ЗначениеЗаполнено(НаименованиеНоменклатуры) Тогда
			РезультатЗапроса= ПолучитьРезультатЗапросаПоРегиструНоменклатураПоставщика(Контрагент, "Наименование", НаименованиеНоменклатуры, "ПОДОБНО");
		КонецЕсли;
		
		Если РезультатЗапроса <> Неопределено И НЕ РезультатЗапроса.Пустой() Тогда
			Выборка= РезультатЗапроса.Выбрать(); 
			Выборка.Следующий();
			Возврат Выборка.Номенклатура;
		КонецЕсли;
		
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "СвойстваОбъектов_Номенклатура" Тогда
		НаименованиеСвойства =  ИдентификаторСвойстваНоменклатураКонтрагента_Код(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
		Номенклатура = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, КодНоменклатуры);
		Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
			НаименованиеСвойства =  ИдентификаторСвойстваНоменклатураКонтрагента_Артикул(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
			Номенклатура = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, АртикулНоменклатуры);
			Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
				НаименованиеСвойства =  ИдентификаторСвойстваНоменклатураКонтрагента_Наименование(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
				Номенклатура = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, НаименованиеНоменклатуры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Номенклатура;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Выборка) И Выборка.Количество() > 0 Тогда
   		Выборка.Следующий();
		Возврат Выборка.Номенклатура;
	Иначе 
		Возврат Неопределено;	  
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВыборкуПоСпрНомПост(Контрагент, НаименованиеРеквизита, ЗначениеРеквизита)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
	Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Ном.Номенклатура
		|ИЗ
		|	Справочник.НоменклатураПоставщиков КАК Ном
		|ГДЕ
		|	Ном.Владелец = &Контрагент
		|	И Ном."+ НаименованиеРеквизита+ " = &ЗначениеРеквизита";
	
	Возврат	Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ПолучитьВыборкуПоРегСведНомПост(Контрагент, НаименованиеРеквизита, ЗначениеРеквизита, Оператор = "=")
	
	Попытка
		
		Запрос = Новый Запрос;
	
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
		Запрос.Текст = "
			|ВЫБРАТЬ
			|	Ном.Номенклатура
			|ИЗ
			|	РегистрСведений.НоменклатураКонтрагентов КАК Ном
			|ГДЕ
			|	Ном.Контрагент = &Контрагент
			|	И Ном."+ НаименованиеРеквизита + " " + Оператор + " (&ЗначениеРеквизита)";
	
			
		ВыборкаИзЗапроса = Запрос.Выполнить().Выбрать();
		
		Возврат ВыборкаИзЗапроса;	
			
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ПолучитьРезультатЗапросаПоРегиструНоменклатураПоставщика(Контрагент, НаименованиеРеквизита, ЗначениеРеквизита, Оператор = "=")
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Номенклатура
	|ИЗ
	|	РегистрСведений.НоменклатураПоставщика КАК Т
	|ГДЕ
	|	Поставщик = &Контрагент
	|	И "+ НаименованиеРеквизита + " " + Оператор + " (&ЗначениеРеквизита)");
	
	Запрос.УстановитьПараметр("Контрагент"		 , Контрагент);
	Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
	
	Возврат Запрос.Выполнить();	
	
КонецФункции

Процедура УстановитьНоменклатруПоставщика(Номенклатура, Контрагент, Код, Артикул, Наименование) Экспорт
	
	Если типЗнч(Номенклатура) <> тип("СправочникСсылка.Номенклатура") Тогда
		Возврат
	КонецЕсли;	
	стПрофильКонфигурации = ПолучитьПрофильКонфигурации();
	Если стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "Справочник_НоменклатураПоставщиков" Тогда
		Выборка = Вычислить("Справочники.НоменклатураПоставщиков.Выбрать(, Контрагент, Новый Структура(""Идентификатор"", Код))");
		
		ЕстьСоответствие = Ложь;
		Если Выборка.Следующий() Тогда
			ЕстьСоответствие = Истина;
		Иначе
			Выборка = Вычислить("Справочники.НоменклатураПоставщиков.Выбрать(, Контрагент, Новый Структура(""Артикул"", Артикул))");
			Если Выборка.Следующий() Тогда
				ЕстьСоответствие = Истина;
			ИначеЕсли (ЗначениеЗаполнено(Код)=Ложь) и (ЗначениеЗаполнено(Наименование)=Ложь) Тогда 
				Выборка = Вычислить("Справочники.НоменклатураПоставщиков.Выбрать(, Контрагент, Новый Структура(""Наименование"", Наименование))");
				Если Выборка.Следующий() Тогда
					ЕстьСоответствие = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЕстьСоответствие Тогда
			Если Выборка.номенклатура <> Номенклатура Тогда
				элементОбъект = Выборка.ПолучитьОбъект();
				элементОбъект.Номенклатура = Номенклатура;
				элементОбъект.Записать();
			КонецЕсли;
		Иначе
			элементОбъект = Вычислить("Справочники.НоменклатураПоставщиков.СоздатьЭлемент()");
			элементОбъект.Владелец = Контрагент;
			элементОбъект.Наименование = Наименование; 
			элементОбъект.Номенклатура = Номенклатура;
			элементОбъект.Идентификатор = Код;
			элементОбъект.Артикул = Артикул;
			элементОбъект.Записать();
		КонецЕсли;
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "РегистрСведений_НоменклатураКонтрагентов" Тогда
		
		СуществующаяНоменклатура = ПолучитьНоменклатуруПоставщика(Контрагент, Наименование, Код, Артикул);
		
		Если СуществующаяНоменклатура = Номенклатура Тогда
			Возврат;
		КонецЕсли;
		
		Если СуществующаяНоменклатура <> Неопределено Тогда
			мз = РегистрыСведений.НоменклатураКонтрагентов.СоздатьМенеджерЗаписи();
			мз.Контрагент = Контрагент;
			мз.Номенклатура = СуществующаяНоменклатура;
			мз.Прочитать();
			мз.Номенклатура = Номенклатура;
			мз.НаименованиеНоменклатурыКонтрагента=	Наименование;
			мз.КодНоменклатурыКонтрагента = Код;
			мз.АртикулНоменклатурыКонтрагента = Артикул;
		Иначе
			мз = РегистрыСведений.НоменклатураКонтрагентов.СоздатьМенеджерЗаписи();
			мз.Контрагент = Контрагент;
			мз.Номенклатура = Номенклатура;
			мз.НаименованиеНоменклатурыКонтрагента=	Наименование;
			мз.КодНоменклатурыКонтрагента = Код;
			мз.АртикулНоменклатурыКонтрагента = Артикул;
		КонецЕсли;
		
		Попытка
			мз.Записать();
		Исключение
			Получитьформу("Модуль_СообщенияДляПользователей_Форма_ВыводОшибки").ПоказатьОшибку(
			"Внимание!",
			"Не удалось сохранить установить соответствие номенклатуры к номенклатуре контрагента.",
			ОписаниеОшибки());	
		КонецПопытки;
		
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "РегистрСведений_НоменклатураПоставщика" Тогда
	
		СуществующаяНоменклатура= ПолучитьНоменклатуруПоставщика(Контрагент, Наименование, Код, Артикул);
		
		Если СуществующаяНоменклатура <> Номенклатура Тогда
			
			Попытка
				
				Если СуществующаяНоменклатура <> Неопределено Тогда
					Запись= РегистрыСведений.НоменклатураПоставщика.СоздатьМенеджерЗаписи();
					Запись.Номенклатура= СуществующаяНоменклатура;
					Запись.Поставщик= 	 Контрагент;
					Запись.КодНоменклатурыПоставщика= 1;
					Запись.Удалить();
				КонецЕсли;
				
				Запись= РегистрыСведений.НоменклатураПоставщика.СоздатьМенеджерЗаписи();
				Запись.Номенклатура= Номенклатура;
				Запись.Поставщик= 	 Контрагент;
				Запись.КодНоменклатурыПоставщика= 1;
				
				Запись.Наименование= Наименование;
				Запись.Код= 		 Код;
				Запись.Артикул= 	 Артикул;
				
				Запись.Записать();
				
			Исключение
				Получитьформу("Модуль_СообщенияДляПользователей_Форма_ВыводОшибки").ПоказатьОшибку(
				"Внимание!",
				"Не удалось запомнить соответствие номенклатуры поставщика.",
				ОписаниеОшибки());	
			КонецПопытки;
			
		КонецЕсли;
		
	ИначеЕсли стПрофильКонфигурации.ХранениеНоменклатурыПоставщиков.Вариант = "СвойстваОбъектов_Номенклатура" Тогда
		
		НаименованиеСвойства =  ИдентификаторСвойстваНоменклатураКонтрагента_Код(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
		НоменклатураСтарая = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, Код);
		Если НЕ ЗначениеЗаполнено(НоменклатураСтарая) Тогда
			НаименованиеСвойства =  ИдентификаторСвойстваНоменклатураКонтрагента_Артикул(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
			НоменклатураСтарая = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, Артикул);
			Если НЕ ЗначениеЗаполнено(НоменклатураСтарая) Тогда
				НаименованиеСвойства = ИдентификаторСвойстваНоменклатураКонтрагента_Наименование(?(Контрагент = Неопределено, "", Контрагент.УникальныйИдентификатор()));
				НоменклатураСтарая = ОдинСАдаптер_СвойстваОбъектов_НайтиОбъект(НаименованиеСвойства, Наименование);
			КонецЕсли;
		КонецЕсли;
		
		Если НоменклатураСтарая <> Номенклатура И ЗначениеЗаполнено(НоменклатураСтарая) Тогда
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(НоменклатураСтарая, ИдентификаторСвойстваНоменклатураКонтрагента_Код(Контрагент.УникальныйИдентификатор()), "");
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(НоменклатураСтарая, ИдентификаторСвойстваНоменклатураКонтрагента_Артикул(Контрагент.УникальныйИдентификатор()), "");
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(НоменклатураСтарая, ИдентификаторСвойстваНоменклатураКонтрагента_Наименование(Контрагент.УникальныйИдентификатор()), "");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Код) Тогда
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(Номенклатура, ИдентификаторСвойстваНоменклатураКонтрагента_Код(Контрагент.УникальныйИдентификатор()), Код);
		КонецЕсли;
		Если ЗначениеЗаполнено(Артикул) Тогда
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(Номенклатура, ИдентификаторСвойстваНоменклатураКонтрагента_Артикул(Контрагент.УникальныйИдентификатор()), Артикул);
		КонецЕсли;
		Если ЗначениеЗаполнено(Наименование) Тогда
			ОдинСАдаптер_СвойстваОбъектов_УстановитьЗначениеСвойства(Номенклатура, ИдентификаторСвойстваНоменклатураКонтрагента_Наименование(Контрагент.УникальныйИдентификатор()), Наименование);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НоменклатураЯвляетсяУслугой(Номенклатура) Экспорт
	стПрофильКонфигурации = ПолучитьПрофильКонфигурации();
	Если стПрофильКонфигурации.Услуги.Вариант = "ПоРеквизиту" Тогда
		Возврат Номенклатура[стПрофильКонфигурации.Услуги.Реквизит] = стПрофильКонфигурации.Услуги.ЗначениеРеквизита;
	Иначе
		Если ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияТКПТ" Тогда
			ТипНоменклатурыУслуга = Справочники.ТипыНоменклатуры.НайтиПоНаименованию("Услуга");
			Если НЕ ТипНоменклатурыУслуга = Справочники.ТипыНоменклатуры.ПустаяСсылка() Тогда
				Возврат ?(Номенклатура.ТипНоменклатуры = ТипНоменклатурыУслуга, Истина, Ложь);	
			Иначе
				Возврат Ложь;	
			КонецЕсли;
		Иначе
			Возврат ?(Номенклатура.ТипНоменклатуры = Справочники.ТипыНоменклатуры.Услуга, Истина, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция ПолучитьНоменклатуруПоАртикулу(АртикулНоменклатуры) Экспорт
	стПрофильКонфигурации = ПолучитьПрофильКонфигурации();
	Если стПрофильКонфигурации.ЕстьАртикул Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Номенклатура.Ссылка
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Артикул = &АртикулНоменклатуры";
		
		Запрос.УстановитьПараметр("АртикулНоменклатуры",АртикулНоменклатуры );
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() = 1 Тогда
			Выборка.Следующий();
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
КонецФункции




//////////////////////////////////////////
// Общего назначения
//////////////////////////////////////////

Функция ИННВалидный(Контрагент) Экспорт
	стПрофильКонфигурации = ПолучитьПрофильКонфигурации();
	
	Если стПрофильКонфигурации.ХранениеНастроекПользователей.Вариант = "1С" Тогда
		
		Если ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияДалионУМ"
			ИЛИ ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияАсторТД" Тогда
			Возврат Истина;
		КонецЕсли;
		
		Попытка
			Возврат Вычислить("РегламентированнаяОтчетность.ИННСоответствуетТребованиям(Контрагент.ИНН, Контрагент.ЮрФизЛицо)");
		исключение 
			Возврат Вычислить("ИННСоответствуетТребованиям(Контрагент.ИНН, Контрагент.ЮрФизЛицо)");
		КонецПопытки;	
		
	ИначеЕсли стПрофильКонфигурации.ХранениеНастроекПользователей.Вариант = "Рарус" Тогда
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ПолучитьНомерНаПечатьДиадок(ДокументСсылка) Экспорт
	Возврат Модуль_ИнтеграцияОбщий.ПолучитьНомерНаПечатьДиадок(ДокументСсылка);
КонецФункции


//////////////////////////////////////////
// Идентификаторы
//////////////////////////////////////////

Функция ИдентификаторСвойстваНоменклатураКонтрагента_Код(ИдентификаторКонтрагента) Экспорт
	 Возврат "ДДНомКонтр_Код" + ИдентификаторКонтрагента;
КонецФункции	 
                            
Функция ИдентификаторСвойстваНоменклатураКонтрагента_Артикул(ИдентификаторКонтрагента) Экспорт
	 Возврат "ДДНомКонтр_Арт" + ИдентификаторКонтрагента;
 КонецФункции
 
Функция ИдентификаторСвойстваНоменклатураКонтрагента_Наименование(ИдентификаторКонтрагента) Экспорт
	 Возврат "ДДНомКонтр_Наи" + ИдентификаторКонтрагента;
КонецФункции	 
