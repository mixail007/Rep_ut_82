﻿Перем ТекстЗапроса;

Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ТабДок = ЭлементыФормы.ПолеТабличногоДокумента;
	Отчет(ТабДок);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура Отчет(ТабДок) Экспорт
	
	ЗапросВыставленоПеней=Новый Запрос;
	
	ЗапросВыставленоПеней.Текст=
	" ВЫБРАТЬ ОтветственноеЛицо, Контрагент, СУММА(СуммаВыставлено) СуммаВыставлено
| ИЗ
| (ВЫБРАТЬ 	ДоговорКонтрагента.Владелец Контрагент, 
|ДоговорКонтрагента,
|ДоговорКонтрагента.ОтветственноеЛицо ОтветственноеЛицо,
|ЕстьNULL(СтоимостьОборот,0) СуммаВыставлено
|	ИЗ
|		РегистрНакопления.Продажи.Обороты(&НачДата, &КонДата, , Номенклатура.Услуга И Номенклатура.Наименование ПОДОБНО ""Пени%"")) А
|СГРУППИРОВАТЬ ПО ОтветственноеЛицо, Контрагент";
	
	//ЗапросВыставленоПеней.УстановитьПараметр("Номенклатура",Справочники.Номенклатура.НайтиПоКоду("9091939"));
	ЗапросВыставленоПеней.УстановитьПараметр("НачДата",НачДата);
	ЗапросВыставленоПеней.УстановитьПараметр("КонДата",КонецДня(КонДата));
	
	ТаблицаВыставленоПеней=ЗапросВыставленоПеней.Выполнить().Выгрузить();
	
	ИтогоСуммаВыставлено=0;
	Если ТаблицаВыставленоПеней.Количество()>0 Тогда
		ИтогоСуммаВыставлено=ТаблицаВыставленоПеней.Итог("СуммаВыставлено");
	КонецЕсли;	
	
	
	//Если Выборка.Следующий() Тогда
	//	ВыставленоПеней=Выборка.СуммаВыставлено;
	//КонецЕсли;	
	
	Макет = ПолучитьМакет("Отчет");
	
	ПостроительОтчетаОтчет.Текст = ТекстЗапроса;

	ПостроительОтчетаОтчет.Параметры.Вставить("СтавкаПеней", СтавкаПеней);

	ТаблицаЗадолженности=Новый ТаблицаЗначений;
	

	
	счДата=НачДата;
	ПостроительОтчетаОтчет.Параметры.Вставить("ТекущаяДата", счДата);
	
	Результат=ПостроительОтчетаОтчет.ПолучитьЗапрос().Выполнить();
	
	ТаблицаЗадолженности=Результат.Выгрузить();
	счДата=счДата+86400;
	
	Пока счДата<=КонДата Цикл
		ПостроительОтчетаОтчет.Параметры.Вставить("ТекущаяДата", счДата);
	
	Результат=ПостроительОтчетаОтчет.ПолучитьЗапрос().Выполнить();
	
	//ТаблицаЗадолженности=Результат.Выгрузить();
	
		Выборка=Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтрокаЗадолженности=ТаблицаЗадолженности.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаЗадолженности,Выборка);
		КонецЦикла;	
		Сообщить("Выполняется расчет за "+ Формат(счДата,"ДФ=dd.MM.yyyy"));
		счДата=счДата+86400;
	КонецЦикла;	
	
	
	ТаблицаЗадолженности.Свернуть("ОтветственноеЛицо,Контрагент,ДоговорКонтрагента,Сделка","СуммаПеней");

	
	//ТаблицаЗадолженности.ВыбратьСтроку();
	
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьЗаголовок.Параметры.ПредставлениеПериода=ПредставлениеПериода(НачДата,КонецДня(КонДата), "ФП=Истина");
		ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
	ОбластьОбщийИтог=Макет.ПолучитьОбласть("ОбщийИтог");
	
	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ЗапросУУ = Новый Запрос;
	ЗапросУУ.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ЗапросУУ.УстановитьПараметр("ТаблицаЗадолженности", ТаблицаЗадолженности);
	
	ЗапросУУ.Текст = "ВЫБРАТЬ ТаблицаЗадолженности.ОтветственноеЛицо ОтветственноеЛицо,ТаблицаЗадолженности.Контрагент Контрагент,ТаблицаЗадолженности.ДоговорКонтрагента ДоговорКонтрагента,
	|ТаблицаЗадолженности.Сделка Сделка,ТаблицаЗадолженности.СуммаПеней СуммаПеней 
	|ПОМЕСТИТЬ ВТ_ТаблицаЗадолженности
	|ИЗ &ТаблицаЗадолженности ТаблицаЗадолженности";
	ЗапросУУ.Выполнить();
	
	ЗапросУУ.Текст="ВЫБРАТЬ ВТ_ТаблицаЗадолженности.ОтветственноеЛицо,ВТ_ТаблицаЗадолженности.Контрагент,ВТ_ТаблицаЗадолженности.ДоговорКонтрагента,
	|ВТ_ТаблицаЗадолженности.Сделка,ВТ_ТаблицаЗадолженности.СуммаПеней  СуммаПеней
	|ИЗ ВТ_ТаблицаЗадолженности
	|ИТОГИ СУММА(СуммаПеней) ПО ОБЩИЕ,
	| ОтветственноеЛицо,Контрагент";

	Результат=ЗапросУУ.Выполнить();
	
	//Результат.Выгрузить().ВыбратьСтроку();
	
	
		ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		ВыборкаОбщийИтог.Следующий();		// Общий итог
		ОбластьОбщийИтог.Параметры.ИтогоСуммаВыставлено=ИтогоСуммаВыставлено;
		ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
		
		
		ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());
		
		
		ВыборкаОтветственноеЛицо = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаОтветственноеЛицо.Следующий() Цикл
			ОбластьОтветственноеЛицо=Макет.ПолучитьОбласть("ОтветственноеЛицо");
			ОбластьОтветственноеЛицо.Параметры.Заполнить(ВыборкаОтветственноеЛицо);
			
			НайдСтроки=ТаблицаВыставленоПеней.НайтиСтроки(Новый Структура("ОтветственноеЛицо",ВыборкаОтветственноеЛицо.ОтветственноеЛицо ) );
			
			СуммаВыставлено=0;
			Если НайдСтроки.Количество()>0 Тогда
				Для каждого НайдСтрока ИЗ НайдСтроки Цикл
					СуммаВыставлено=СуммаВыставлено+НайдСтрока.СуммаВыставлено;
				КонецЦикла;
			КонецЕсли;	
			
			ОбластьОтветственноеЛицо.Параметры.СуммаВыставлено=СуммаВыставлено ;
			ТабДок.Вывести(ОбластьОтветственноеЛицо, ВыборкаОтветственноеЛицо.Уровень());
			
			ВыборкаКонтрагент = ВыборкаОтветственноеЛицо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаКонтрагент.Следующий() Цикл
				ОбластьКонтрагент=Макет.ПолучитьОбласть("КОнтрагент");
				ОбластьКонтрагент.Параметры.Заполнить(ВыборкаКонтрагент);
				
			НайдСтроки=ТаблицаВыставленоПеней.НайтиСтроки(Новый Структура("ОтветственноеЛицо,Контрагент",ВыборкаОтветственноеЛицо.ОтветственноеЛицо,ВыборкаОтветственноеЛицо.Контрагент ) );
			
			СуммаВыставлено=0;
			Если НайдСтроки.Количество()>0 Тогда
				Для каждого НайдСтрока ИЗ НайдСтроки Цикл
					СуммаВыставлено=СуммаВыставлено+НайдСтрока.СуммаВыставлено;
				КонецЦикла;
			КонецЕсли;	
			
			ОбластьКонтрагент.Параметры.СуммаВыставлено=СуммаВыставлено;
				
				ТабДок.Вывести(ОбластьКонтрагент, ВыборкаКонтрагент.Уровень());
				
				ВыборкаДетали = ВыборкаКонтрагент.Выбрать();
						Пока ВыборкаДетали.Следующий() Цикл
                        	ОбластьДетали=Макет.ПолучитьОбласть("Детали");
							ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
							ТабДок.Вывести(ОбластьДетали, ВыборкаДетали.Уровень());

						КонецЦикла;		
			КонецЦикла;	
		КонецЦикла;	

	//ТаблицаЗадолженности.ВыбратьСтроку();	
	//ВыборкаДетали = Результат.Выбрать();

	//Пока ВыборкаДетали.Следующий() Цикл
	//	ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетали);
	//	ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетали.Уровень());
	//КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	//ТабДок.Вывести(ОбластьПодвалТаблицы);
	//ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ
КонецПроцедуры

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


функция  ТекстНачальногоЗапроса();

	Текст= "
|ВЫБРАТЬ ДоговорКонтрагента.Владелец Контрагент, ДоговорКонтрагента.ОтветственноеЛицо ОтветственноеЛицо,
|	СуммаУпрОстаток 	
|ИЗ 	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(, {ДоговорКонтрагента.*} 
| )";				
		
 Возврат Текст;
 
 КонецФункции


 Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	 ПостроительОтчетаОтчет.Текст = ТекстЗапроса;
	
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();

 КонецПроцедуры

 Процедура ПриОткрытии()
	 СписокКонтрагентовФ_Ф=Новый СписокЗначений ;
	 СписокКонтрагентовФ_Ф.Добавить(Справочники.Контрагенты.НайтиПоКоду("00405")); // ФОрмула
	 СписокКонтрагентовФ_Ф.Добавить(Справочники.Контрагенты.НайтиПоКоду("91639")); // Поволжье
	 СписокКонтрагентовФ_Ф.Добавить(Справочники.Контрагенты.НайтиПоКоду("00461")); // Питер
	 СписокКонтрагентовФ_Ф.Добавить(Справочники.Контрагенты.НайтиПоКоду("90038")); // Ставрополь
	 
	ПостроительОтчетаОтчет.Отбор.Добавить("Контрагент"); 
	 ПостроительОтчетаОтчет.Отбор.Контрагент.ВидСравнения=ВидСравнения.НеВСписке;
	 ПостроительОтчетаОтчет.Отбор.Контрагент.Значение=СписокКонтрагентовФ_Ф;
	 ПостроительОтчетаОтчет.Отбор.Контрагент.Использование=Истина;
	 
 КонецПроцедуры


 ТекстЗапроса="ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток
	|ПОМЕСТИТЬ ВТ_Договоры
	|ИЗ
	|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	|			,
	|			ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|				И ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам)) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|ГДЕ
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
	|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка,
	|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты,
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток,
	|	УправленческийЗачетВзаимныхОбязательств.Сумма КАК СуммаЗачета,
	|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток - ЕСТЬNULL(УправленческийЗачетВзаимныхОбязательств.Сумма, 0) КАК СуммаДолга,
	|	(ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток - ЕСТЬNULL(УправленческийЗачетВзаимныхОбязательств.Сумма, 0)) * &СтавкаПеней /35600 КАК СуммаПеней
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	|		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
	|		ВзаиморасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты КАК СделкаДатаОплаты,
	|		ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток
	|	ИЗ
	|		РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	|				&ТекущаяДата,  {ДоговорКонтрагента.*}
	|				ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	|					И ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам)
	|					И Сделка ССЫЛКА Документ.ЗаказПокупателя
	|					И Сделка.ДатаОплаты < &ТекущаяДата
	|					И ДоговорКонтрагента В
	|						(ВЫБРАТЬ
	|							ВТ_Договоры.ДоговорКонтрагента
	|						ИЗ
	|							ВТ_Договоры)) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|	ГДЕ
	|		ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток > 0) КАК ВзаиморасчетыСКонтрагентамиОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			УправленческийЗачетВзаимныхОбязательствСуммыДолга.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|			УправленческийЗачетВзаимныхОбязательствСуммыДолга.Сделка КАК Сделка,
	|			УправленческийЗачетВзаимныхОбязательствСуммыДолга.Сумма КАК Сумма
	|		ИЗ
	|			Документ.УправленческийЗачетВзаимныхОбязательств.СуммыДолга КАК УправленческийЗачетВзаимныхОбязательствСуммыДолга
	|		ГДЕ
	|			УправленческийЗачетВзаимныхОбязательствСуммыДолга.Ссылка.Проведен
	|			И УправленческийЗачетВзаимныхОбязательствСуммыДолга.ВидЗадолженности = ЗНАЧЕНИЕ(Перечисление.ВидыЗадолженности.Дебиторская)) КАК УправленческийЗачетВзаимныхОбязательств
	|		ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = УправленческийЗачетВзаимныхОбязательств.ДоговорКонтрагента
	|			И ВзаиморасчетыСКонтрагентамиОстатки.Сделка = УправленческийЗачетВзаимныхОбязательств.Сделка
	| {ГДЕ Контрагент.*}
	|УПОРЯДОЧИТЬ ПО
	|	ВзаиморасчетыСКонтрагентамиОстатки.ОтветственноеЛицо.Наименование,
	|	ВзаиморасчетыСКонтрагентамиОстатки.Контрагент.Наименование";