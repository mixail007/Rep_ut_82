﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщегние.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, Отказ, Заголовок, ИмяСуммы = "СуммаПлатежа") Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	
	ИмяТаблицы          = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	
	Если ЗначениеНеЗаполнено(ИмяТабличнойЧасти) Тогда
		ЕстьДоговорКонтрагента = ЕстьРеквизитДокумента("ДоговорКонтрагента", МетаданныеДокумента);
		ЕстьДоговорСделка         = ЕстьРеквизитДокумента("Сделка", МетаданныеДокумента);
		
		Если ЕстьДоговорКонтрагента Тогда
			
			ДоговорКонтрагента = СтруктураШапкиДокумента.ДоговорКонтрагента;
			
			Если СтруктураШапкиДокумента.КонтролироватьСуммуЗадолженности Тогда
				
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
				
				Запрос.Текст = "
				|ВЫБРАТЬ // Для контроля суммы задолженности по расчетному документу (ведение взаиморасчетов - по расчетным документам)
				|    ВзаиморасчетыПоДоговору.СуммаВзаиморасчетовОстаток
				|ИЗ
				|	 РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(,
				|	 ДоговорКонтрагента = &ДоговорКонтрагента
				|	 ) КАК ВзаиморасчетыПоДоговору
				|";
				
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					СуммаВзаиморасчетовОстаток = ?(Выборка.СуммаВзаиморасчетовОстаток= NULL, 0, Выборка.СуммаВзаиморасчетовОстаток);
					
					СуммаВзаиморасчетовПоДокументу = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаДокумента, СтруктураШапкиДокумента.ВалютаДокумента,
																СтруктураШапкиДокумента.ВалютаВзаиморасчетов, КурсДокумента(ДокументОбъект,СтруктураШапкиДокумента.ВалютаРегламентированногоУчета),
																СтруктураШапкиДокумента.КурсВзаиморасчетов, КратностьДокумента(ДокументОбъект, СтруктураШапкиДокумента.ВалютаРегламентированногоУчета),
																СтруктураШапкиДокумента.КратностьВзаиморасчетов);
																
					Валюта = ?(СтруктураШапкиДокумента.ВалютаВзаиморасчетов = NULL, "", СтруктураШапкиДокумента.ВалютаВзаиморасчетов);
					Если (СуммаВзаиморасчетовОстаток + СуммаВзаиморасчетовПоДокументу) > СтруктураШапкиДокумента.ДопустимаяСуммаЗадолженности Тогда
						ОшибкаПриПроведении("Сумма задолженности по договору " + ДоговорКонтрагента + 
						" с учетом документа превышает допустимую сумму задолженности." + Символы.ПС +
						Символы.Таб + "Сумма задолженности с учетом документа: " + (СуммаВзаиморасчетовОстаток + СуммаВзаиморасчетовПоДокументу) +
						" " + Валюта + ", допустимая сумма задолженности: " + СтруктураШапкиДокумента.ДопустимаяСуммаЗадолженности + " " + Валюта + 
						", превышение: " + (ФорматСумм(СуммаВзаиморасчетовОстаток + СуммаВзаиморасчетовПоДокументу - 
						СтруктураШапкиДокумента.ДопустимаяСуммаЗадолженности)) + " " + Валюта, Отказ, Заголовок);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Сделка = СтруктураШапкиДокумента.Сделка;
			
			Если СтруктураШапкиДокумента.ПроцентПредоплаты > 0 Тогда
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
				
				Если ЗначениеНеЗаполнено(Сделка) Тогда
					Запрос.УстановитьПараметр("Сделка",                Неопределено);
				Иначе
					Запрос.УстановитьПараметр("Сделка",                Сделка);
				КонецЕсли;
				
				Запрос.Текст = "
				|ВЫБРАТЬ // Для контроля суммы задолженности по расчетному документу (ведение взаиморасчетов - по расчетным документам)
				|    ВзаиморасчетыПоДоговору.СуммаВзаиморасчетовПриход   КАК СуммаЗаказа,
				|    ВзаиморасчетыПоДоговору.СуммаВзаиморасчетовРасход   КАК СуммаОплаты
				|ИЗ
				|	 РегистрНакопления.РасчетыСКонтрагентами.Обороты(,,,
				|	 ДоговорКонтрагента = &ДоговорКонтрагента
				|	 И Сделка              = &Сделка
				|	 ) КАК ВзаиморасчетыПоДоговору
				|";
				
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					СуммаЗаказа = ?(Выборка.СуммаЗаказа = NULL, 0, Выборка.СуммаЗаказа);
					СуммаОплаты = ?(Выборка.СуммаОплаты = NULL, 0, Выборка.СуммаОплаты);
					ПроцентПредоплаты = СтруктураШапкиДокумента.ПроцентПредоплаты;
					ПроцентСовершеннойПредоплаты = ?(СуммаЗаказа = 0, 100, СуммаОплаты / СуммаЗаказа * 100);
					
					Если ПроцентСовершеннойПредоплаты < ПроцентПредоплаты Тогда
					ОшибкаПриПроведении("Недостаточна предоплата по заказу " + Сделка + 
					Символы.ПС + Символы.Таб + " По договору """ + ДоговорКонтрагента + 
					""" требуется предоплата в размере " + ПроцентПредоплаты + "% ; Поступила предоплата  в размере " 
					+ Окр(ПроцентСовершеннойПредоплаты, 2, 1) + "%", Отказ, Заголовок);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

			// Контроль числа дней задолженности
		 	Если СтруктураШапкиДокумента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам Тогда

				Если Не ЗначениеНеЗаполнено(СтруктураШапкиДокумента.Сделка)
					И (ТипЗнч(СтруктураШапкиДокумента.Сделка) <> Тип("ДокументСсылка.НачислениеПени")) Тогда
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
					
					Запрос.УстановитьПараметр("Сделка", СтруктураШапкиДокумента.Сделка);
					
					Запрос.Текст = "
					|ВЫБРАТЬ // Для контроля суммы задолженности по расчетному документу (ведение взаиморасчетов - по расчетным документам)
					|    ВзаиморасчетыПоДоговору.СуммаВзаиморасчетовОстаток
					|ИЗ
					|	 РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(,
					|	 ДоговорКонтрагента = &ДоговорКонтрагента
					|	 И Сделка = &Сделка
					|	 ) КАК ВзаиморасчетыПоДоговору
					|";
					
					Выборка = Запрос.Выполнить().Выбрать();
					Если Выборка.Следующий() Тогда
						СуммаВзаиморасчетовОстаток = ?(Выборка.СуммаВзаиморасчетовОстаток= NULL, 0, ?(Выборка.СуммаВзаиморасчетовОстаток > 0, 1, -1) * Выборка.СуммаВзаиморасчетовОстаток);
						
						СуммаВзаиморасчетовПоДокументу = ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаДокумента, СтруктураШапкиДокумента.ВалютаДокумента,
																	СтруктураШапкиДокумента.ВалютаВзаиморасчетов, КурсДокумента(ДокументОбъект,СтруктураШапкиДокумента.ВалютаРегламентированногоУчета),
																	СтруктураШапкиДокумента.КурсВзаиморасчетов, КратностьДокумента(ДокументОбъект, СтруктураШапкиДокумента.ВалютаРегламентированногоУчета),
																	СтруктураШапкиДокумента.КратностьВзаиморасчетов);
																	
						Валюта = ?(СтруктураШапкиДокумента.ВалютаВзаиморасчетов = NULL, "", СтруктураШапкиДокумента.ВалютаВзаиморасчетов);
						Если СуммаВзаиморасчетовОстаток < СуммаВзаиморасчетовПоДокументу Тогда
							ОшибкаНетОстатка("Сумма по документу превышает текущую задолженность по расчетному документу " + СтруктураШапкиДокумента.Сделка + ".",
							СуммаВзаиморасчетовОстаток, СуммаВзаиморасчетовПоДокументу, Валюта, Отказ, Заголовок);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;

				Если СтруктураШапкиДокумента.КонтролироватьЧислоДнейЗадолженности Тогда
					
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
					Запрос.УстановитьПараметр("ПоРасчетнымДокументам", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам);

					Запрос.Текст =
					"ВЫБРАТЬ	// Выбирает даты самых ранних сделок по договорам, указанным в т.ч. 
					|		МИНИМУМ(Сделка.Дата) КАК ДатаПервойСделки,
					|		ДоговорКонтрагента
					|	ИЗ	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(, 
					|		ДоговорКонтрагента = &ДоговорКонтрагента)
					|	ГДЕ СуммаВзаиморасчетовОстаток > 0	// Дебиторская задолженность больше 0
					|		И ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоРасчетнымДокументам
					|		И ДоговорКонтрагента.КонтролироватьЧислоДнейЗадолженности
					|	СГРУППИРОВАТЬ ПО ДоговорКонтрагента";
					
					Выборка = Запрос.Выполнить().Выбрать();
					
					Если Выборка.Следующий() Тогда
						ДопустимоеЧислоДнейЗадолженности = СтруктураШапкиДокумента.ДопустимоеЧислоДнейЗадолженности;
						РазницаДатВСекундах = (СтруктураШапкиДокумента.Дата - Выборка.ДатаПервойСделки);

						РазницаДней = Цел(РазницаДатВСекундах/(24 * 60 * 60));
						Если РазницаДней > ДопустимоеЧислоДнейЗадолженности Тогда

							ОшибкаПриПроведении("Превышено допустимое число дней задолженности по договору " + ДоговорКонтрагента + 
							Символы.ПС + Символы.Таб +
							" Допустимое число дней задолженности: " + ДопустимоеЧислоДнейЗадолженности + 
							", дата самой старой задолженности: " + Выборка.ДатаПервойСделки + 
							", превышение: " + 
							РазницаДней + " дней",
							Отказ, Заголовок);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДокументСсылка",        ДокументОбъект.Ссылка);
		Запрос.УстановитьПараметр("ПоРасчетнымДокументам", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам);
		
		Запрос.Текст = "
		|ВЫБРАТЬ // Для контроля суммы задолженности по расчетному документу (ведение взаиморасчетов - по расчетным документам)
		|   Док.ДоговорКонтрагента,
		|   Док.ДоговорКонтрагента.ВалютаВзаиморасчетов,
		|   Док.Сделка,
		|   Док.КурсВзаиморасчетов,
		|   Док.КратностьВзаиморасчетов,
		|   Док."+ ИмяСуммы + " КАК СуммаДокумента,
		|   Док.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
		|   Взаиморасчеты.СуммаВзаиморасчетовОстаток
		|ИЗ
		|	Документ." + ИмяТаблицы + " КАК Док
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	 РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(,
		|	 ДоговорКонтрагента В (ВЫБРАТЬ РАЗЛИЧНЫЕ ДоговорКонтрагента ИЗ Документ." + ИмяТаблицы +"
		|							ГДЕ Документ." + ИмяТаблицы + ".Ссылка = &ДокументСсылка)
		|	 ) КАК Взаиморасчеты
		|ПО
		|	Док.ДоговорКонтрагента = Взаиморасчеты.ДоговорКонтрагента
		|	И Док.Сделка             = Взаиморасчеты.Сделка
		|ГДЕ
		|	Док.Ссылка = &ДокументСсылка
		|	И Док.ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоРасчетнымДокументам
		|	И Док.Сделка <> Неопределено
		|";

		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СуммаВзаиморасчетовОстаток = ?(Выборка.СуммаВзаиморасчетовОстаток= NULL, 0, ?(Выборка.СуммаВзаиморасчетовОстаток > 0, 1, -1) * Выборка.СуммаВзаиморасчетовОстаток);
			
			СуммаВзаиморасчетовПоДокументу = Выборка.СуммаДокумента;

			Валюта = Выборка.ВалютаВзаиморасчетов;
			Если СуммаВзаиморасчетовОстаток < СуммаВзаиморасчетовПоДокументу Тогда
				ОшибкаНетОстатка("Сумма по документу превышает текущую задолженность по расчетному документу " + Выборка.Сделка + ".",
				СуммаВзаиморасчетовОстаток, СуммаВзаиморасчетовПоДокументу, Валюта, Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
   КонецЕсли;
	
КонецПроцедуры // КонтрольОстатков()

Процедура ПередЗаписью(Отказ, Замещение)
		
	ПроверкаПериодаЗаписей(ЭтотОбъект, Отказ);
	
КонецПроцедуры