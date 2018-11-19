﻿Перем ТЗПросрочка;
Перем ТЗKPI;

Процедура ДействияФормыОтчетСформировать(Кнопка)

	Если НачДата>КонДата тогда
		Предупреждение("Начальная дата больше конечной!");
		Возврат;
	КонецЕсли;
	
	ТабДок = ЭлементыФормы.ПолеТабличногоДокумента;
	Отчет(ТабДок);


КонецПроцедуры

Процедура Отчет(ТабДок) Экспорт
	
	ЗаполнитьСреднююПросроченнуюЗадолженность();
	
	//ЗаполнитьKPI();
	
	ОтбиратьПоМенеджеру = Ложь;
	Если НЕ Менеджер = Справочники.Пользователи.ПустаяСсылка() Тогда
		ОтбиратьПоМенеджеру = Истина;
	КонецЕсли;
	
	Макет = ПолучитьМакет("Отчет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗакупкиОбороты.Номенклатура,
	|	СУММА(ЗакупкиОбороты.КоличествоОборот) КАК КоличествоОборот,
	|	ВЫРАЗИТЬ(ЗаявкаНаВозвратТоваровТовары.Реализация.Сделка КАК Документ.ЗаказПокупателя) КАК Заказ
	|ПОМЕСТИТЬ ОбратныеПродажи
	|ИЗ
	|	РегистрНакопления.Закупки.Обороты(&НачДата, &КонДата, , ЗаказПоставщику.Основание ССЫЛКА Документ.ЗаявкаНаВозвратТоваров) КАК ЗакупкиОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаВозвратТоваров.Товары КАК ЗаявкаНаВозвратТоваровТовары
	|		ПО ЗакупкиОбороты.ЗаказПоставщику.Основание = ЗаявкаНаВозвратТоваровТовары.Ссылка
	|			И ЗакупкиОбороты.Номенклатура = ЗаявкаНаВозвратТоваровТовары.Номенклатура
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗакупкиОбороты.Номенклатура,
	|	ВЫРАЗИТЬ(ЗаявкаНаВозвратТоваровТовары.Реализация.Сделка КАК Документ.ЗаказПокупателя)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПродажиОбороты.Номенклатура,
	|	ПродажиОбороты.ЗаказПокупателя,
	|	СУММА(ПродажиОбороты.КоличествоОборот) КАК КоличествоОборот,
	|	СУММА(ПродажиОбороты.СтоимостьОборот) КАК Стоимость,
	|	СУММА(ПродажиСебестоимостьОбороты.СтоимостьОборот) КАК Себестоимость,
	|	СУММА(ЕСТЬNULL(ПродажиОбороты.СтоимостьОборот, 0) - ЕСТЬNULL(ПродажиСебестоимостьОбороты.СтоимостьОборот, 0)) КАК Наценка
	|ПОМЕСТИТЬ ПродажиПодОбратки
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(
	|			,
	|			,
	|			Регистратор,
	|			ЗаказПокупателя В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ОбратныеПродажи.Заказ
	|				ИЗ
	|					ОбратныеПродажи КАК ОбратныеПродажи)) КАК ПродажиОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажиСебестоимость.Обороты(
	|				,
	|				,
	|				Регистратор,
	|				ЗаказПокупателя В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ОбратныеПродажи.Заказ
	|					ИЗ
	|						ОбратныеПродажи КАК ОбратныеПродажи)) КАК ПродажиСебестоимостьОбороты
	|		ПО ПродажиОбороты.Регистратор = ПродажиСебестоимостьОбороты.Регистратор
	|			И ПродажиОбороты.Номенклатура = ПродажиСебестоимостьОбороты.Номенклатура
	|			И ПродажиОбороты.ЗаказПокупателя = ПродажиСебестоимостьОбороты.ЗаказПокупателя
	|			И ПродажиОбороты.Подразделение = ПродажиСебестоимостьОбороты.Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ПродажиОбороты.Номенклатура,
	|	ПродажиОбороты.ЗаказПокупателя
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбратныеПродажи.Заказ,
	|	ОбратныеПродажи.Номенклатура,
	|	ВЫБОР
	|		КОГДА ПродажиПодОбратки.КоличествоОборот = 0
	|			ТОГДА 0
	|		ИНАЧЕ -(ПродажиПодОбратки.Стоимость / ПродажиПодОбратки.КоличествоОборот) * ОбратныеПродажи.КоличествоОборот
	|	КОНЕЦ КАК Стоимость,
	|	ВЫБОР
	|		КОГДА ПродажиПодОбратки.КоличествоОборот = 0
	|			ТОГДА 0
	|		ИНАЧЕ -(ПродажиПодОбратки.Себестоимость / ПродажиПодОбратки.КоличествоОборот) * ОбратныеПродажи.КоличествоОборот
	|	КОНЕЦ КАК Себестоимость,
	|	ВЫБОР
	|		КОГДА ПродажиПодОбратки.КоличествоОборот = 0
	|			ТОГДА 0
	|		ИНАЧЕ -(ПродажиПодОбратки.Стоимость / ПродажиПодОбратки.КоличествоОборот) * ОбратныеПродажи.КоличествоОборот
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ПродажиПодОбратки.КоличествоОборот = 0
	|			ТОГДА 0
	|		ИНАЧЕ ПродажиПодОбратки.Себестоимость / ПродажиПодОбратки.КоличествоОборот * ОбратныеПродажи.КоличествоОборот
	|	КОНЕЦ КАК Наценка
	|ПОМЕСТИТЬ ВаловкаПоОбраткам
	|ИЗ
	|	ОбратныеПродажи КАК ОбратныеПродажи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПродажиПодОбратки КАК ПродажиПодОбратки
	|		ПО ОбратныеПродажи.Заказ = ПродажиПодОбратки.ЗаказПокупателя
	|			И ОбратныеПродажи.Номенклатура = ПродажиПодОбратки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Б.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	Б.Контрагент КАК Контрагент,
	|	Б.ДоговорКонтрагента,
	|	Б.Сделка,
	|	Б.СуммаОплаты КАК СуммаОплаты,
	|	0 КАК ПремияИтого,
	|	Б.СуммаПродажи КАК СуммаПродажи,
	|	Б.КоэффициентОплаты,
	|	ВЫБОР
	|		КОГДА Б.Контрагент = &Старк
	|			ТОГДА 0
	|		ИНАЧЕ Б.ПремияЗаНаценку * Б.КоэффициентОплаты * Б.Квалификация
	|	КОНЕЦ КАК БонусЗаНаценку,
	|	ВЫБОР
	|		КОГДА Б.Контрагент = &Старк
	|			ТОГДА Б.СуммаОплаты * &КоэффициентЗаПродажиФФ * Б.Квалификация
	|		ИНАЧЕ Б.СуммаОплаты * &КоэффициентЗаПродажи * Б.Квалификация
	|	КОНЕЦ КАК ПремияЗаПродажи
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОплатыОтПокупателей.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|		ОплатыОтПокупателей.Контрагент КАК Контрагент,
	|		ОплатыОтПокупателей.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|		ОплатыОтПокупателей.Сделка КАК Сделка,
	|		ОплатыОтПокупателей.СуммаОплаты КАК СуммаОплаты,
	|		ВЫБОР
	|			КОГДА &ФлагКвалификация_1
	|				ТОГДА 1
	|			КОГДА ОплатыОтПокупателей.ОтветственноеЛицо.Квалификация = 0
	|				ТОГДА 1
	|			ИНАЧЕ ОплатыОтПокупателей.ОтветственноеЛицо.Квалификация
	|		КОНЕЦ КАК Квалификация,
	|		ЕСТЬNULL(ПродажиПоЗаказам.СуммаПродажи, 0) КАК СуммаПродажи,
	|		ЕСТЬNULL(ПродажиПоЗаказам.ПремияЗаНаценку, 0) КАК ПремияЗаНаценку,
	|		ВЫБОР
	|			КОГДА ЕСТЬNULL(ПродажиПоЗаказам.СуммаПродажи, 0) > 0
	|				ТОГДА ОплатыОтПокупателей.СуммаОплатыДляРасчетаПремии / ЕСТЬNULL(ПродажиПоЗаказам.СуммаПродажи, 0)
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК КоэффициентОплаты
	|	ИЗ
	|		(ВЫБРАТЬ
	|			А.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|			А.Контрагент КАК Контрагент,
	|			А.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|			А.Сделка КАК Сделка,
	|			СУММА(А.СуммаОплаты) КАК СуммаОплаты,
	|			СУММА(А.СуммаОплаты) КАК СуммаОплатыДляРасчетаПремии
	|		ИЗ
	|			(ВЫБРАТЬ
	|				ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|				ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.Владелец КАК Контрагент,
	|				ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|				ВзаиморасчетыСКонтрагентамиОбороты.Сделка КАК Сделка,
	|				ВЫБОР
	|					КОГДА ВзаиморасчетыСКонтрагентамиОбороты.Сделка ССЫЛКА Документ.ЗаказПоставщику
	|						ТОГДА -ВзаиморасчетыСКонтрагентамиОбороты.СуммаВзаиморасчетовПриход
	|					ИНАЧЕ ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрРасход
	|				КОНЕЦ КАК СуммаОплаты
	|			ИЗ
	|				РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(
	|						&НачДата,
	|						&КонДата,
	|						Регистратор,
	|						(ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам
	|							ИЛИ ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|							И (НЕ ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ = &КонтрРезерваИМ
	|								ИЛИ ДоговорКонтрагента.Владелец В (&КтргИсключения))
	|							И (ДоговорКонтрагента.ОтветственноеЛицо В (&СписокМенеджер)
	|								ИЛИ НЕ &ОтбиратьПоМенеджеру)) КАК ВзаиморасчетыСКонтрагентамиОбороты
	|			ГДЕ
	|				(ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
	|							И ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.ВидОперации = &ОплатаОтПокупателяБезНал
	|						ИЛИ ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
	|							И ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.ВидОперации = &ОплатаОтПокупателяНал
	|						ИЛИ ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеИсходящее
	|							И ВЫРАЗИТЬ(ВзаиморасчетыСКонтрагентамиОбороты.Сделка КАК Документ.ЗаказПоставщику).Основание ССЫЛКА Документ.ЗаявкаНаВозвратТоваров)) КАК А
	|		
	|		СГРУППИРОВАТЬ ПО
	|			А.ОтветственноеЛицо,
	|			А.Контрагент,
	|			А.ДоговорКонтрагента,
	|			А.Сделка
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.ОтветственноеЛицо,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.Владелец,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента,
	|			ВзаиморасчетыСКонтрагентамиОбороты.Сделка,
	|			СУММА(ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрРасход),
	|			СУММА(ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрРасход)
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(
	|					&НачДата,
	|					&КонДата,
	|					Регистратор,
	|					(ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам
	|						ИЛИ ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|						И (НЕ ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ = &КонтрРезерваИМ
	|							ИЛИ ДоговорКонтрагента.Владелец В (&КтргИсключения))
	|						И (ДоговорКонтрагента.ОтветственноеЛицо В (&СписокМенеджер)
	|							ИЛИ НЕ &ОтбиратьПоМенеджеру)) КАК ВзаиморасчетыСКонтрагентамиОбороты
	|		ГДЕ
	|			ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.Взаимозачет
	|			И ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.УчитыватьДляРасчетаПремии
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.ОтветственноеЛицо,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента,
	|			ВзаиморасчетыСКонтрагентамиОбороты.Сделка,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.Владелец
	|		
	|		ОБЪЕДИНИТЬ
	|		
	|		ВЫБРАТЬ
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.ОтветственноеЛицо,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.Владелец,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента,
	|			ВзаиморасчетыСКонтрагентамиОбороты.Сделка,
	|			-СУММА(ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрПриход),
	|			0
	|		ИЗ
	|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(
	|					&НачДата,
	|					&КонДата,
	|					Регистратор,
	|					(ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам
	|						ИЛИ ДоговорКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером))
	|						И (НЕ ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ = &КонтрРезерваИМ
	|							ИЛИ ДоговорКонтрагента.Владелец В (&КтргИсключения))
	|						И (ДоговорКонтрагента.ОтветственноеЛицо В (&СписокМенеджер)
	|							ИЛИ НЕ &ОтбиратьПоМенеджеру)) КАК ВзаиморасчетыСКонтрагентамиОбороты
	|		ГДЕ
	|			ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.Взаимозачет
	|			И ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.УчитыватьДляРасчетаПремии
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.ОтветственноеЛицо,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента,
	|			ВзаиморасчетыСКонтрагентамиОбороты.Сделка,
	|			ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента.Владелец) КАК ОплатыОтПокупателей
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				Б.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|				Б.Сделка КАК Сделка,
	|				СУММА(Б.СуммаПродажи) КАК СуммаПродажи,
	|				СУММА(Б.ПремияЗаНаценку) КАК ПремияЗаНаценку
	|			ИЗ
	|				(ВЫБРАТЬ
	|					А.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|					А.Сделка КАК Сделка,
	|					А.Номенклатура КАК Номенклатура,
	|					СУММА(А.СуммаПродажи) КАК СуммаПродажи,
	|					СУММА(А.Себестоимость) КАК Себестоимость,
	|					СУММА(А.Наценка) КАК Наценка,
	|					СУММА(ВЫБОР
	|							КОГДА А.Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Шины)
	|									И А.Наценка > 0
	|									И А.СуммаПродажи > А.Себестоимость * (1 + &КоэффициентОтсеченияШ)
	|								ТОГДА (А.СуммаПродажи - А.Себестоимость * (1 + &КоэффициентОтсеченияШ)) * &КоэффициентЗаНаценку
	|							КОГДА А.Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Диски)
	|									И А.Наценка > 0
	|									И А.СуммаПродажи > А.Себестоимость * (1 + &КоэффициентОтсеченияД)
	|								ТОГДА (А.СуммаПродажи - А.Себестоимость * (1 + &КоэффициентОтсеченияД)) * &КоэффициентЗаНаценкуДиски
	|							КОГДА А.Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.АКБ)
	|									И А.Наценка > 0
	|									И А.СуммаПродажи > А.Себестоимость * (1 + &КоэффициентОтсеченияАКБ)
	|								ТОГДА (А.СуммаПродажи - А.Себестоимость * (1 + &КоэффициентОтсеченияАКБ)) * &КоэффициентЗаНаценкуАКБ
	|							КОГДА А.Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Аксессуары)
	|									И А.Наценка > 0
	|									И А.СуммаПродажи > А.Себестоимость
	|								ТОГДА (А.СуммаПродажи - А.Себестоимость) * &КоэффициентЗаНаценкуАксессуары
	|							ИНАЧЕ 0
	|						КОНЕЦ) КАК ПремияЗаНаценку
	|				ИЗ
	|					(ВЫБРАТЬ
	|						ПродажиОбороты.ЗаказПокупателя.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|						ПродажиОбороты.ЗаказПокупателя КАК Сделка,
	|						ПродажиОбороты.Номенклатура КАК Номенклатура,
	|						ПродажиОбороты.СтоимостьОборот КАК СуммаПродажи,
	|						ПродажиСебестоимостьОбороты.СтоимостьОборот КАК Себестоимость,
	|						ПродажиОбороты.СтоимостьОборот - ЕСТЬNULL(ПродажиСебестоимостьОбороты.СтоимостьОборот, 0) КАК Наценка
	|					ИЗ
	|						РегистрНакопления.Продажи.Обороты(
	|								&НачалоПериода,
	|								,
	|								Регистратор,
	|								ДоговорКонтрагента.ОтветственноеЛицо В (&СписокМенеджер)
	|									ИЛИ НЕ &ОтбиратьПоМенеджеру
	|										И (НЕ ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ = &КонтрРезерваИМ
	|											ИЛИ ДоговорКонтрагента.Владелец В (&КтргИсключения))) КАК ПродажиОбороты
	|							ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПродажиСебестоимость.Обороты(
	|									&НачалоПериода,
	|									,
	|									Регистратор,
	|									НЕ ЗаказПокупателя.Контрагент.КонтрагентДляРезерваИМ = &КонтрРезерваИМ
	|										ИЛИ ЗаказПокупателя.Контрагент В (&КтргИсключения)) КАК ПродажиСебестоимостьОбороты
	|							ПО ПродажиОбороты.ЗаказПокупателя = ПродажиСебестоимостьОбороты.ЗаказПокупателя
	|								И ПродажиОбороты.Номенклатура = ПродажиСебестоимостьОбороты.Номенклатура
	|								И ПродажиОбороты.Регистратор = ПродажиСебестоимостьОбороты.Регистратор
	|								И ПродажиОбороты.Подразделение = ПродажиСебестоимостьОбороты.Подразделение
	|					ГДЕ
	|						ПродажиОбороты.ЗаказПокупателя ССЫЛКА Документ.ЗаказПокупателя
	|					
	|					ОБЪЕДИНИТЬ ВСЕ
	|					
	|					ВЫБРАТЬ
	|						ВаловкаПоОбраткам.Заказ.ДоговорКонтрагента,
	|						ВаловкаПоОбраткам.Заказ,
	|						ВаловкаПоОбраткам.Номенклатура,
	|						ВаловкаПоОбраткам.Стоимость,
	|						ВаловкаПоОбраткам.Себестоимость,
	|						ВаловкаПоОбраткам.Наценка
	|					ИЗ
	|						ВаловкаПоОбраткам КАК ВаловкаПоОбраткам) КАК А
	|				
	|				СГРУППИРОВАТЬ ПО
	|					А.ДоговорКонтрагента,
	|					А.Сделка,
	|					А.Номенклатура) КАК Б
	|			
	|			СГРУППИРОВАТЬ ПО
	|				Б.ДоговорКонтрагента,
	|				Б.Сделка) КАК ПродажиПоЗаказам
	|			ПО ОплатыОтПокупателей.Сделка = ПродажиПоЗаказам.Сделка
	|				И ОплатыОтПокупателей.ДоговорКонтрагента = ПродажиПоЗаказам.ДоговорКонтрагента) КАК Б
	|
	|УПОРЯДОЧИТЬ ПО
	|	Б.ОтветственноеЛицо.Наименование,
	|	Б.Контрагент.Наименование
	|ИТОГИ
	|	СУММА(СуммаОплаты),
	|	СУММА(БонусЗаНаценку) + СУММА(ПремияЗаПродажи) КАК ПремияИтого,
	|	СУММА(СуммаПродажи),
	|	СУММА(БонусЗаНаценку),
	|	СУММА(ПремияЗаПродажи)
	|ПО
	|	ОБЩИЕ,
	|	ОтветственноеЛицо,
	|	Контрагент";

	Запрос.УстановитьПараметр("НачалоПериода", Дата('20070101'));
	
	Запрос.УстановитьПараметр("КонтрРезерваИМ", справочники.Контрагенты.НайтиПоКоду("П004703") ); //16.03.2016 - Резерв для ИМ
	КтргИсключения = Новый Массив();
	КтргИсключения.Добавить(Справочники.Контрагенты.НайтиПоКоду("П001549"));
	КтргИсключения.Добавить(Справочники.Контрагенты.НайтиПоКоду("93980"));
	Запрос.УстановитьПараметр("КтргИсключения", КтргИсключения); // Контрагенты, которые пользуются резервами ИМ, но клиентами ИМ не являются
	
	Запрос.УстановитьПараметр("НачДата", НачДата);
	Запрос.УстановитьПараметр("КонДата", КонецДня(КонДата));
	Запрос.УстановитьПараметр("ОплатаОтПокупателяБезнал", Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя);
	Запрос.УстановитьПараметр("ОплатаОтПокупателяНал", Перечисления.ВидыОперацийПКО.ОплатаПокупателя);
	Запрос.УстановитьПараметр("ПоЗаказам", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
	Запрос.УстановитьПараметр("ОперацияПроведениеВзаимозачета", Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета);
	Запрос.УстановитьПараметр("Дебиторская", Перечисления.ВидыЗадолженности.Дебиторская);
	Запрос.УстановитьПараметр("Кредиторская", Перечисления.ВидыЗадолженности.Кредиторская);
	
	// проценты и коэффициенты
	Запрос.УстановитьПараметр("КоэффициентЗаПродажи", ПроцентЗаПродажи/100);
	Запрос.УстановитьПараметр("КоэффициентЗаПродажиФФ", ПроцентЗаПродажиФФ/100);
	Запрос.УстановитьПараметр("КоэффициентЗаНаценку", ПроцентЗаНаценку/100);
	Запрос.УстановитьПараметр("КоэффициентЗаНаценкуДиски", ПроцентЗаНаценкуДиски/100);
	Запрос.УстановитьПараметр("КоэффициентЗаНаценкуАксессуары", ПроцентЗаНаценкуАксессуары/100);
	Запрос.УстановитьПараметр("КоэффициентЗаНаценкуАКБ", ПроцентЗаНаценкуАКБ/100);

	//+++( 18.07.2013 замена ПроцентОтсечения на 2 параметра: ПроцентОтсеченияШ и ПроцентОтсеченияД
	//Запрос.УстановитьПараметр("КоэффициентОтсечения", ПроцентОтсечения/100);
	Запрос.УстановитьПараметр("КоэффициентОтсеченияШ", ПроцентОтсеченияШ/100);
	Запрос.УстановитьПараметр("КоэффициентОтсеченияД", ПроцентОтсеченияД/100);
	Запрос.УстановитьПараметр("КоэффициентОтсеченияАКБ", ПроцентОтсеченияАКБ/100);
	
	Запрос.УстановитьПараметр("ФлагКвалификация_1", ФлагКвалификацияРавно1);

	//+++)
	
	Запрос.УстановитьПараметр("Старк", Справочники.Контрагенты.НайтиПоКоду("00004"));
	
//+++(
	ОтбиратьПоМенеджеру = истина;
	СписокМенеджер=Новый СписокЗначений;
	ГруппаПользователей=ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ГруппаПользователейДляРаспределенияЗаказов");
	 Для каждого строка ИЗ ГруппаПользователей.ПользователиГруппы Цикл
		 СписокМенеджер.Добавить(строка.Пользователь);
     КонецЦикла;

  Если ЗначениеЗаполнено(ГруппаПользователей) И глТекущийПользователь=ГруппаПользователей.АдминистраторГруппы Тогда
		 
	 Если типЗнч(ЭлементыФормы.ПолеВвода1.Значение)=Тип("СписокЗначений") тогда // проверим чего там выбрал менеджер
		 
		 Для каждого строка1 ИЗ ЭлементыФормы.ПолеВвода1.Значение цикл
			 Если СписокМенеджер.НайтиПоЗначению(строка1.Значение) = неопределено тогда
			Предупреждение("Сотрудник: "+строка(строка1)+" - не входит в вашу группу!
						   |Уберите его из списка и сформируйте заново!");
			Возврат;	 
			КонецЕсли;				 
		КонецЦикла;
	 Иначе
		 ОтбиратьПоМенеджеру=Истина;
		 Если СписокМенеджер.НайтиПоЗначению(ЭлементыФормы.ПолеВвода1.Значение)=неопределено 
			 и НЕ (РольДоступна("ПолныеПрава") ИЛИ РольДоступна ("яштФинДиректор") ) тогда
			Предупреждение("Сотрудник: "+строка(ЭлементыФормы.ПолеВвода1.Значение)+" - не входит в вашу группу!
						   |Уберите его из списка и сформируйте заново!");
			Возврат;	 
	     КонецЕсли;
		 СписокМенеджер = ЭлементыФормы.ПолеВвода1.Значение;
	 КонецЕсли;	 
		 
  ИначеЕсли РольДоступна("ПолныеПрава") ИЛИ РольДоступна ("яштФинДиректор") Тогда
	 ОтбиратьПоМенеджеру = ЗначениеЗаполнено(ЭлементыФормы.ПолеВвода1.Значение);
	 СписокМенеджер = ЭлементыФормы.ПолеВвода1.Значение;
  Иначе
	 ОтбиратьПоМенеджеру = Истина;
	 СписокМенеджер = ЭлементыФормы.ПолеВвода1.Значение;
  КонецЕсли;	 
	 
	 Если ЗначениеЗаполнено(СписокМенеджер) тогда
	 	Запрос.УстановитьПараметр("СписокМенеджер", СписокМенеджер);
 	 КонецЕсли; //+++)
	 
	 Запрос.УстановитьПараметр("ОтбиратьПоМенеджеру", ОтбиратьПоМенеджеру);

	
    Состояние("Выполняется запрос. Пожалуйста подождите...");
	Результат = Запрос.Выполнить();
	
	Состояние("Выполняется вывод результатов...");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.ПредставлениеПериода= ПредставлениеПериода(НачДата,КонецДня(КонДата),"ФП=Истина");
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьОтветственноеЛицо = Макет.ПолучитьОбласть("ОтветственноеЛицо");
	ОбластьКонтрагент = Макет.ПолучитьОбласть("Контрагент");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаОтветственноеЛицо = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	БонусЗаНаценкуИтог=0;
	Пока ВыборкаОтветственноеЛицо.Следующий() Цикл
		ОбластьОтветственноеЛицо.Параметры.Заполнить(ВыборкаОтветственноеЛицо);
		строкаПросрочка= ТЗПросрочка.Найти(ВыборкаОтветственноеЛицо.ОтветственноеЛицо,"ОтветственноеЛицо");
		Если строкаПросрочка<>Неопределено Тогда
		ОбластьОтветственноеЛицо.Параметры.СуммаПросрочки =строкаПросрочка.СуммаПросрочки;
		ОбластьОтветственноеЛицо.Параметры.СуммаУпрОстаток =строкаПросрочка.СуммаУпрОстаток;
		ОбластьОтветственноеЛицо.Параметры.ПроцентПросрочки=100*строкаПросрочка.СуммаПросрочки/строкаПросрочка.СуммаУпрОстаток;
		КонецЕсли;
	
		CтрокаKPI = ТЗKPI.Найти(ВыборкаОтветственноеЛицо.ОтветственноеЛицо, "ОтветственноеЛицо");
		Если CтрокаKPI <> Неопределено Тогда
			ОбластьОтветственноеЛицо.Параметры.KPI = CтрокаKPI.КоэффициентЭффективности;
		Иначе
			ОбластьОтветственноеЛицо.Параметры.KPI = 0;
		КонецЕсли;
		
		БонусЗаНаценкуИтог=БонусЗаНаценкуИтог+ВыборкаОтветственноеЛицо.БонусЗаНаценку;
		ТабДок.Вывести(ОбластьОтветственноеЛицо, ВыборкаОтветственноеЛицо.Уровень());

		ВыборкаКонтрагент = ВыборкаОтветственноеЛицо.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаКонтрагент.Следующий() Цикл
			ОбластьКонтрагент.Параметры.Заполнить(ВыборкаКонтрагент);
			ТабДок.Вывести(ОбластьКонтрагент, ВыборкаКонтрагент.Уровень());

			ВыборкаДетали = ВыборкаКонтрагент.Выбрать();

			Пока ВыборкаДетали.Следующий() Цикл
				ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетали);
				ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетали.Уровень());
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);
    Состояние(" ");
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ
КонецПроцедуры

Процедура ЗаполнитьСреднююПросроченнуюЗадолженность()
Запрос=Новый Запрос;	
счДата=НачДата;
счНедель=0;
Пока счДата< КонДата Цикл
счНедель=счНедель+1;
счДата=счДата+86400*7;
Запрос.Текст="ВЫБРАТЬ Менеджер ОтветственноеЛицо, //Контрагент, ДоговорКонтрагента, 
		|СУММА(СуммаПросрочки) СуммаПросрочки,
		|СУММА(СуммаУпрОстаток) СуммаУпрОстаток
		|ИЗ 
		|(ВЫБРАТЬ
		| ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ОтветственноеЛицо Менеджер,
		|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
		|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
		|	ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток,0) КАК СуммаУпр,
		|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка Сделка,
		|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты ДатаОплаты,
		|	ВЫБОР КОГДА ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.Сделка.ДатаОплаты,ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))< &ДатаКон ТОГДА
		|	 ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток
		|	 ИНАЧЕ 
		|	 0
		|	КОНЕЦ  СуммаПросрочки,
		|   ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток
		|			
		|ИЗ
		|(ВЫБРАТЬ ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,ЗачетВзаимныхОбязательств.ДоговорКонтрагента) ДоговорКонтрагента,
		|	 ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.Сделка,ЗачетВзаимныхОбязательств.Сделка) Сделка,
		|	 ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток,0)-ЕстьNULL(ЗачетВзаимныхОбязательств.СуммаУпрЗачетов,0) СуммаУпрОстаток
		|	ИЗ
		|	 РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&ДатаКон,
		//|	  НЕ ДоговорКонтрагента.Владелец.ВходитВХолдинг И
		|     НЕ ДоговорКонтрагента.Владелец =&Старк
		|	   ) КАК ВзаиморасчетыСКонтрагентамиОстатки
		|				ПОЛНОЕ СОЕДИНЕНИЕ 
		|				(ВЫБРАТЬ
		|				ДоговорКонтрагента,Сделка,
		|			СУММА(Сумма) СуммаУпрЗачетов
		|		ИЗ  Документ.УправленческийЗачетВзаимныхОбязательств.СуммыДолга 
		|		ГДЕ Ссылка.Проведен И ВидЗадолженности = &Дебиторская И Ссылка.Дата<=&ДатаКон  //И ДоговорКонтрагента.ОтветственноеЛицо.ОсновноеПодразделение=&ОтделПродаж
		|		СГРУППИРОВАТЬ ПО ДоговорКонтрагента,Сделка) ЗачетВзаимныхОбязательств
		|		ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента=ЗачетВзаимныхОбязательств.ДоговорКонтрагента
		|		И ВзаиморасчетыСКонтрагентамиОстатки.Сделка=ЗачетВзаимныхОбязательств.Сделка
		|	ГДЕ ЕстьNULL(ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток,0)-ЕстьNULL(ЗачетВзаимныхОбязательств.СуммаУпрЗачетов,0) <>0) КАК ВзаиморасчетыСКонтрагентамиОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВзаиморасчетовОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|			СУММА(ВзаиморасчетовОстатки.СуммаУпрОстаток) КАК СуммаУпрОстаток
		|		ИЗ
		|			РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&ДатаКон, 
	//	|			НЕ ДоговорКонтрагента.Владелец.ВходитВХолдинг И
		|           НЕ ДоговорКонтрагента.Владелец =&Старк
		|			) КАК ВзаиморасчетовОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВзаиморасчетовОстатки.ДоговорКонтрагента) КАК ВзаиморасчетыСКонтрагентамиОстаткиНужногоТипа
		|		ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = ВзаиморасчетыСКонтрагентамиОстаткиНужногоТипа.ДоговорКонтрагента
		|			И (ВзаиморасчетыСКонтрагентамиОстаткиНужногоТипа.СуммаУпрОстаток > 0))А
		|СГРУППИРОВАТЬ ПО  Менеджер 			
		|УПОРЯДОЧИТЬ ПО Менеджер.Наименование";
Запрос.УстановитьПараметр("ДатаКон",счДата);		
Запрос.УстановитьПараметр("Дебиторская",Перечисления.ВидыЗадолженности.Дебиторская);
Запрос.УстановитьПараметр("Старк",Справочники.Контрагенты.НайтиПоКоду("00004"));
		
Выборка=Запрос.Выполнить().Выбрать();		

Пока Выборка.Следующий() Цикл
	СтрокаОтветственный=ТЗПросрочка.Найти(Выборка.ОтветственноеЛицо,"ОтветственноеЛицо");
	Если  СтрокаОтветственный=Неопределено Тогда // не найден, добавляем
		СтрокаОтветственный=ТЗПросрочка.Добавить();	
		ЗаполнитьЗначенияСвойств(СтрокаОтветственный,Выборка);
	Иначе
		СтрокаОтветственный.СуммаПросрочки= Выборка.СуммаПросрочки+ СтрокаОтветственный.СуммаПросрочки;
		СтрокаОтветственный.СуммаУпрОстаток= Выборка.СуммаУпрОстаток+ СтрокаОтветственный.СуммаУпрОстаток;
	КонецЕсли;
КонецЦикла;	
	
КонецЦикла;	

Для каждого СтрокаОтветственный ИЗ ТЗПросрочка Цикл
	СтрокаОтветственный.СуммаПросрочки= СтрокаОтветственный.СуммаПросрочки/счНедель ;
	СтрокаОтветственный.СуммаУпрОстаток= СтрокаОтветственный.СуммаУпрОстаток/счНедель ;
КонецЦикла;	
	
КонецПроцедуры	

Процедура ЗаполнитьKPI()
	
	//Сделан новый механизм
	//Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("НачДата", НачДата);
	//Запрос.УстановитьПараметр("КонДата", КонДата);
	//Запрос.Текст = "ВЫБРАТЬ
	//			   |	ЗначенияПоказателейЭффективности.ОтветственноеЛицо,
	//			   |	СУММА(ЗначенияПоказателейЭффективности.КоэффициентЭффективности) КАК КоэффициентЭффективности
	//			   |ИЗ
	//			   |	РегистрСведений.ЗначенияПоказателейЭффективности КАК ЗначенияПоказателейЭффективности
	//			   |ГДЕ
	//			   |	ЗначенияПоказателейЭффективности.Период МЕЖДУ &НачДата И &КонДата
	//			   |
	//			   |СГРУППИРОВАТЬ ПО
	//			   |	ЗначенияПоказателейЭффективности.ОтветственноеЛицо";
	//			   
	//Выборка = Запрос.Выполнить().Выбрать();		
	//   
	//Пока Выборка.Следующий() Цикл
	//	СтрокаОтветственный = ТЗKPI.Найти(Выборка.ОтветственноеЛицо,"ОтветственноеЛицо");
	//	Если СтрокаОтветственный = Неопределено Тогда // не найден, добавляем
	//		СтрокаОтветственный = ТЗKPI.Добавить();	
	//		ЗаполнитьЗначенияСвойств(СтрокаОтветственный,Выборка);
	//	Иначе
	//		СтрокаОтветственный.КоэффициентЭффективности = Выборка.КоэффициентЭффективности;
	//	КонецЕсли;
	//КонецЦикла;	
	   
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

Процедура ПриОткрытии()
	//Если ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ИспользоватьОтбор") Тогда
	//	 ЭлементыФормы.ПолеВвода1.Значение=глТекущийПользователь;
	//	 ЭлементыФормы.ПолеВвода1.ТолькоПросмотр=Истина;
	//КонецЕсли;
	
	//***2015.02.24
	ПроцентОтсеченияШ = 7;
	ПроцентОтсеченияД = 15;
	ПроцентОтсеченияАКБ = 12;
	ПроцентЗаНаценкуАКБ = 1;
	
	//+++
	СписокМенеджер=Новый СписокЗначений;
	 ГруппаПользователей=ПолучитьЗначениеПоУмолчанию(глТекущийПользователь,"ГруппаПользователейДляРаспределенияЗаказов") ;
	 Если ЗначениеЗаполнено(ГруппаПользователей) И глТекущийПользователь=ГруппаПользователей.АдминистраторГруппы и не РольДоступна("ПолныеПрава") Тогда
		ОтбиратьПоМенеджеру=Ложь; // администратор группы может выбирать... но только из своей группы
		 Для каждого строка ИЗ ГруппаПользователей.ПользователиГруппы Цикл
			 СписокМенеджер.Добавить(строка.Пользователь);
		 КонецЦикла;	 
	 ИначеЕсли РольДоступна("ПолныеПрава") ИЛИ РольДоступна("яштФинДиректор") Тогда
		 ОтбиратьПоМенеджеру=Ложь;
		 СписокМенеджер.Добавить(глТекущийПользователь);
		 		 
	 Иначе
		 ОтбиратьПоМенеджеру=Истина;
		 СписокМенеджер.Добавить(глТекущийПользователь);
		 
		 //+++ 07.04.2014
		 Если глТекущийПользователь = справочники.Пользователи.НайтиПоКоду("Бондаренко") тогда
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Бондаренко"));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Бондаренко Е.Д. (Ростов на Дону)"));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Горохов Д.В."));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Гуров М. В."));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Решотка")); //+++ 25.04.2014
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Чистякова А.И."));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Фончинкова О.А."));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Федунов"));
		
		ИначеЕсли глТекущийПользователь = справочники.Пользователи.НайтиПоКоду("Марешева И.Г.") тогда
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Челышева Т.А."));
			//СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Шагина Е.Н."));
			//СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Филатова С.В."));
			//СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Леонтьева И.В."));//+++ 16.10.2014
			//СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Панфилов М.А."));//+++ 16.10.2014
			
		ИначеЕсли глТекущийПользователь = справочники.Пользователи.НайтиПоКоду("Хачатурян Л.К.") тогда
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Хачатурян Л.К. - ЕКБ"));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Хачатурян Л.К. - РНД"));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Хачатурян Л.К. - СПБ"));
			
		ИначеЕсли глТекущийПользователь = справочники.Пользователи.НайтиПоКоду("Чистякова А.И.") тогда
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Чистякова А.И."));
			СписокМенеджер.Добавить(справочники.Пользователи.НайтиПоКоду("Фончинкова О.А."));
		КонецЕсли;

	 КонецЕсли;	 
     ЭлементыФормы.ПолеВвода1.Значение = СписокМенеджер;
	 
	 Если ОтбиратьПоМенеджеру тогда
		 ЭлементыФормы.ПолеВвода1.ТолькоПросмотр = Истина;
 	 КонецЕсли; //+++)
 
КонецПроцедуры

Процедура ПроцентЗаПродажиРегулирование(Элемент, Направление, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	Элемент.Значение = Элемент.Значение  + Направление * 0.001;
КонецПроцедуры

Процедура ПолеВвода1ПриИзменении(Элемент)

Если ПолеВвода1 = справочники.Пользователи.НайтиПоКоду("Бондаренко") тогда
	Список1 = новый СписокЗначений;
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Бондаренко"));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Бондаренко Е.Д. (Ростов на Дону)"));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Горохов Д.В."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Гуров М. В."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Решотка")); //+++ 25.04.2014
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Чистякова А.И."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Фончинкова О.А."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Федунов"));
	ПолеВвода1 = Список1;
	
ИначеЕсли ПолеВвода1 = справочники.Пользователи.НайтиПоКоду("Марешева И.Г.") тогда
	Список1 = новый СписокЗначений;
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Марешева И.Г."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Шагина Е.Н."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Филатова С.В."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Леонтьева И.В."));//+++ 16.10.2014
    Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Панфилов М.А."));//+++ 16.10.2014
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Трошин Д.О."));//+++ 30.06.2016

	ПолеВвода1 = Список1;
	
ИначеЕсли ПолеВвода1 = справочники.Пользователи.НайтиПоКоду("Чистякова А.И.") тогда
	Список1 = новый СписокЗначений;
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Чистякова А.И."));
	Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Фончинкова О.А."));
	//Список1.Добавить(справочники.Пользователи.НайтиПоКоду("Вельчинская"));
	ПолеВвода1 = Список1;
КонецЕсли;

КонецПроцедуры

ТЗПросрочка=Новый ТаблицаЗначений;
ТЗПросрочка.Колонки.Добавить("ОтветственноеЛицо");
ТЗПросрочка.Колонки.Добавить("СуммаПросрочки");    // просроченная дебеторская задолженность
ТЗПросрочка.Колонки.Добавить("СуммаУпрОстаток");   // дебеторская задолженность

ТЗKPI = Новый ТаблицаЗначений;
ТЗKPI.Колонки.Добавить("ОтветственноеЛицо");
ТЗKPI.Колонки.Добавить("КоэффициентЭффективности");
