﻿

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	Если ЗначениеНеЗаполнено(Подразделение) Тогда // Сакулина
		Сообщить("Необходимо заполнить подразделение",СтатусСообщения.Внимание);
		Отказ =Истина;
	КонецЕсли; // Сакулина
	

	ПроверитьЗаполнениеТабличнойЧастиТовары(Товары.Выгрузить(), Отказ, Заголовок);
	
	Если Не Отказ Тогда 
		Отказ = ПроверитьОстаткиПоРегистрам();
	КонецЕсли;
	
	Если Не Отказ Тогда 
		ДвижениеПоРегистрам(РежимПроведения,Отказ);
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьОстаткиПоРегистрам()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсвобождениеРезерваДляИМТовары.Номенклатура
	|ПОМЕСТИТЬ ТЧДокумента
	|ИЗ
	|	Документ.ОсвобождениеРезерваДляИМ.Товары КАК ОсвобождениеРезерваДляИМТовары
	|ГДЕ
	|	ОсвобождениеРезерваДляИМТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсвобождениеРезерваДляИМТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыПокупателейОстатки.Номенклатура,
	|	СУММА(ЗаказыПокупателейОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ОстаткиПоЗаказамИМ
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(
	|			&ДатаОстатков,
	|			ЗаказПокупателя.Контрагент = &КлиентИМ
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ТЧДокумента.Номенклатура
	|					ИЗ
	|						ТЧДокумента КАК ТЧДокумента)
	|				И ЗаказПокупателя.Проверен
	|				И ВЫБОР
	|					КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЗаказПокупателя.Подразделение = &Подразделение
	|				КОНЕЦ) КАК ЗаказыПокупателейОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыПокупателейОстатки.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РезервДляИМОстатки.Номенклатура КАК Номенклатура,
	|	СУММА(РезервДляИМОстатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ОстаткиПоРезервамИМ
	|ИЗ
	|	РегистрНакопления.РезервДляИМ.Остатки(
	|			&ДатаОстатков,
	|			КонтрагентДляРезерваИМ = &КлиентИМ
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ТЧДокумента.Номенклатура
	|					ИЗ
	|						ТЧДокумента КАК ТЧДокумента)
	|				И ВЫБОР
	|					КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ Подразделение = &Подразделение
	|				КОНЕЦ) КАК РезервДляИМОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РезервДляИМОстатки.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	КоличествоОстаток
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ОстаткиПоРезервамИМ.Номенклатура, ОстаткиПоЗаказамИМ.Номенклатура) КАК Номенклатура,
	|	ЕСТЬNULL(ОстаткиПоРезервамИМ.КоличествоОстаток, 0) КАК КоличествоОстатокРезерв,
	|	ЕСТЬNULL(ОстаткиПоЗаказамИМ.КоличествоОстаток, 0) КАК КоличествоОстатокЗаказ
	|ИЗ
	|	ОстаткиПоЗаказамИМ КАК ОстаткиПоЗаказамИМ
	|		ПОЛНОЕ СОЕДИНЕНИЕ ОстаткиПоРезервамИМ КАК ОстаткиПоРезервамИМ
	|		ПО ОстаткиПоЗаказамИМ.Номенклатура = ОстаткиПоРезервамИМ.Номенклатура
	|ГДЕ
	|	ЕСТЬNULL(ОстаткиПоРезервамИМ.КоличествоОстаток, 0) <> ЕСТЬNULL(ОстаткиПоЗаказамИМ.КоличествоОстаток, 0)";
	
	Запрос.УстановитьПараметр("ДатаОстатков", МоментВремени());
	Запрос.УстановитьПараметр("КлиентИМ", Контрагент);   //23.01.2017
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЕстьОшибки = не РезультатЗапроса.Пустой();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить ("Различаются данные по резерву. " + 	"Товар "+ВыборкаДетальныеЗаписи.Номенклатура+ Символы.ПС +
		          "    По данным заказов покупателей: "+ ВыборкаДетальныеЗаписи.КоличествоОстатокЗаказ+ Символы.ПС+
					"    По данным резерва для ИМ: "+ ВыборкаДетальныеЗаписи.КоличествоОстатокРезерв);
	КонецЦикла;
	
	Возврат ЕстьОшибки;
	
КонецФункции

Процедура ДвижениеПоРегистрам(РежимПроведения,Отказ)
	
	Если Отказ Тогда  
		Возврат;
	КонецЕсли;
	
	ДвижениеПоЗаказамПокупателей(РежимПроведения,Отказ);
	
	ДвижениеПоРезервДляИМ(РежимПроведения,Отказ);
	
КонецПроцедуры

Процедура ДвижениеПоЗаказамПокупателей(РежимПроведения,Отказ)
	
	//Блокировки #УТОЧНИТЬ а Анны нужна ли она
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ЗаказыПокупателей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();
	
	Движения.ЗаказыПокупателей.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсвобождениеРезерваДляИМТовары.Номенклатура КАК Номенклатура,
	|	СУММА(ОсвобождениеРезерваДляИМТовары.Количество) КАК Количество
	|ПОМЕСТИТЬ ДокТЧ
	|ИЗ
	|	Документ.ОсвобождениеРезерваДляИМ.Товары КАК ОсвобождениеРезерваДляИМТовары
	|ГДЕ
	|	ОсвобождениеРезерваДляИМТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ОсвобождениеРезерваДляИМТовары.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокТЧ.Номенклатура КАК Номенклатура,
	|	ЗаказыПокупателейОстатки.ЗаказПокупателя КАК ЗаказПокупателя,
	|	ЗаказыПокупателейОстатки.ЗаказПокупателя.МоментВремени КАК МоментВремени,
	|	ЕСТЬNULL(ЗаказыПокупателейОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	|	ДокТЧ.Количество КАК Количество,
	|	ЗаказыПокупателейОстатки.ДоговорКонтрагента,
	|	ЗаказыПокупателейОстатки.СтатусПартии,
	|	ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры,
	|	ЗаказыПокупателейОстатки.Цена КАК Цена,
	|	ЗаказыПокупателейОстатки.ЕдиницаИзмерения,
	|	ЗаказыПокупателейОстатки.ПроцентСкидкиНаценки КАК ПроцентСкидкиНаценки,
	|	ЗаказыПокупателейОстатки.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
	|	ЗаказыПокупателейОстатки.УсловиеАвтоматическойСкидки,
	|	ЗаказыПокупателейОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетовОстаток,
	|	ЗаказыПокупателейОстатки.СуммаУпрОстаток КАК СуммаУпрОстаток,
	|	ДокТЧ.Номенклатура.Представление
	|ИЗ
	|	ДокТЧ КАК ДокТЧ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПокупателей.Остатки(
	|				&ДатаОстатков,
	|				Номенклатура В
	|						(ВЫБРАТЬ
	|							ДокТЧ.Номенклатура
	|						ИЗ
	|							ДокТЧ КАК ДокТЧ)
	|					И ЗаказПокупателя.Контрагент = &КлиентИМ
	|					И ЗаказПокупателя.Проверен
	|					И ВЫБОР
	|						КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	|							ТОГДА ИСТИНА
	|						ИНАЧЕ ЗаказПокупателя.Подразделение = &Подразделение
	|					КОНЕЦ) КАК ЗаказыПокупателейОстатки
	|		ПО (ЗаказыПокупателейОстатки.Номенклатура = ДокТЧ.Номенклатура)
	|ГДЕ
	|	ЗаказыПокупателейОстатки.ЗаказПокупателя.Проверен
	|	И ЗаказыПокупателейОстатки.КоличествоОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗаказыПокупателейОстатки.ЗаказПокупателя.МоментВремени
	|ИТОГИ
	|	СУММА(КоличествоОстаток),
	|	МАКСИМУМ(Количество)
	|ПО
	|	Номенклатура";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаОстатков", МоментВремени());
	
	Запрос.УстановитьПараметр("КлиентИМ", Контрагент);    //23.01.2017
	Запрос.УстановитьПараметр("Подразделение", Подразделение);

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаНоменклатура = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаНоменклатура.Следующий() Цикл
		
		Если ВыборкаНоменклатура.Количество > ВыборкаНоменклатура.КоличествоОстаток Тогда 
			Сообщить("Товара """ + ВыборкаНоменклатура.НоменклатураПредставление+ """  недостаточно " + (ВыборкаНоменклатура.Количество - ВыборкаНоменклатура.КоличествоОстаток) + " "+ВыборкаНоменклатура.Номенклатура.БазоваяЕдиницаИзмерения);
			Отказ = Истина;
			Продолжить;
		КонецЕсли;	
		
		ОсталосьСписать = МИН(ВыборкаНоменклатура.Количество, ВыборкаНоменклатура.КоличествоОстаток);
		
		ВыборкаДетальныеЗаписи = ВыборкаНоменклатура.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() И ОсталосьСписать <> 0 Цикл
			
			Списать = МИН(ОсталосьСписать, ВыборкаДетальныеЗаписи.КоличествоОстаток);
			
			Движение = Движения.ЗаказыПокупателей.Добавить();
			ЗаполнитьЗначенияСвойств(Движение,ВыборкаДетальныеЗаписи);
			
			Если ВыборкаДетальныеЗаписи.СуммаВзаиморасчетовОстаток = 0 Тогда 
				СуммаВзаиморасчетовОстаток = 0;
			Иначе
				СуммаВзаиморасчетовОстаток = Списать / ВыборкаДетальныеЗаписи.КоличествоОстаток * ВыборкаДетальныеЗаписи.СуммаВзаиморасчетовОстаток;
			КонецЕсли;
			
			Если ВыборкаДетальныеЗаписи.СуммаУпрОстаток = 0 Тогда 
				СуммаУпрОстаток = 0;
			Иначе
				СуммаУпрОстаток = Списать / ВыборкаДетальныеЗаписи.КоличествоОстаток * ВыборкаДетальныеЗаписи.СуммаУпрОстаток;
			КонецЕсли;
			
			Движение.СуммаВзаиморасчетов = СуммаВзаиморасчетовОстаток;
			Движение.СуммаУпр = СуммаУпрОстаток;
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Количество = Списать;
			Движение.Регистратор = Ссылка;
			
			ОсталосьСписать = ОсталосьСписать - Списать;
			
		КонецЦикла;
	КонецЦикла;
	
	Движения.ЗаказыПокупателей.Записать();
	
КонецПроцедуры	

Процедура ДвижениеПоРезервДляИМ(РежимПроведения,Отказ)
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	//Блокировки #УТОЧНИТЬ а Анны нужна ли она
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.РезервДляИМ");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();
	
	Движения.РезервДляИМ.Записывать = Истина;
	
	//Основа запроса взята из процедуры ПодготовитьТаблицуПоРезервамИМ документа ЗакрытиеОдногоЗаказаПокупателя
	//Изменена только первая ВТ,берем движения по текущему регистратору где указаны заказы списания и передаем в запрос
	Запрос = Новый Запрос;
	Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ЗаказыПокупателей.Номенклатура,
	//|	ЗаказыПокупателей.ЗаказПокупателя,
	//|	ЗаказыПокупателей.Количество,
	//|	ЗаказыПокупателей.Регистратор,
	//|	ЗаказыПокупателей.ЗаказПокупателя.Подразделение,
	//|	ЗаказыПокупателей.ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ
	//|ПОМЕСТИТЬ ДвижениеПоЗаказам
	//|ИЗ
	//|	РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
	//|ГДЕ
	//|	ЗаказыПокупателей.Регистратор = &Ссылка
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	РезервДляИМ.Номенклатура,
	//|	ВЫБОР
	//|		КОГДА РезервДляИМ.Количество > ДвижениеПоЗаказам.Количество
	//|			ТОГДА ДвижениеПоЗаказам.Количество
	//|		ИНАЧЕ РезервДляИМ.Количество
	//|	КОНЕЦ КАК Количество,
	//|	ДвижениеПоЗаказам.Регистратор,
	//|	ВЫБОР
	//|		КОГДА РезервДляИМ.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	//|			ТОГДА ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	//|		ИНАЧЕ ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	//|	КОНЕЦ КАК ВидДвижения,
	//|	РезервДляИМ.Подразделение,
	//|	РезервДляИМ.КонтрагентДляРезерваИМ,
	//|	РезервДляИМ.Активность
	//|ИЗ
	//|	ДвижениеПоЗаказам КАК ДвижениеПоЗаказам
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РезервДляИМ КАК РезервДляИМ
	//|		ПО ДвижениеПоЗаказам.Номенклатура = РезервДляИМ.Номенклатура
	//|			И ДвижениеПоЗаказам.ЗаказПокупателя = РезервДляИМ.Регистратор
	//|			И ДвижениеПоЗаказам.ЗаказПокупателяПодразделение = РезервДляИМ.Подразделение
	//|			И ДвижениеПоЗаказам.ДоговорКонтрагентаВладелецКонтрагентДляРезерваИМ = РезервДляИМ.КонтрагентДляРезерваИМ";
	"ВЫБРАТЬ
	|	ЗаказыПокупателей.Номенклатура,
	|	ЗаказыПокупателей.ЗаказПокупателя,
	|	ЗаказыПокупателей.Количество,
	|	ЗаказыПокупателей.Регистратор,
	|	ЗаказыПокупателей.ЗаказПокупателя.Подразделение КАК Подразделение,
	//|	ЗаказыПокупателей.ДоговорКонтрагента.Владелец.КонтрагентДляРезерваИМ КАК КонтрагентДляРезерваИМ, //123Заменить
	|	ЗаказыПокупателей.ДоговорКонтрагента.КонтрагентДляРезерваИМ КАК КонтрагентДляРезерваИМ,
	|	ЗаказыПокупателей.ВидДвижения
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей КАК ЗаказыПокупателей
	|ГДЕ
	|	ЗаказыПокупателей.Регистратор = &Ссылка";
	// Сакулина. Поменяла алгоритм. Так как при проведении уже проверили на равенство остатков по регистру Резервы для ИМ и для Заказы покупателя,
	// тогда можно просто сделать аналогичные движения по Резерву для ИМ как сделали по регистру Заказы покупателя. 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВидДвиженияПриход = ВидДвиженияНакопления.Приход;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидДвижения = ВидДвиженияПриход Тогда 
			//Это ошибка.Не должно быть движения в плюс.Всегда списываем.
			Отказ = Истина;
		КонецЕсли;	
		Движение = Движения.РезервДляИМ.Добавить();
		ЗаполнитьЗначенияСвойств(Движение,ВыборкаДетальныеЗаписи);
		Движение.Период = Дата;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, Отказ, Заголовок)

	ИмяТабличнойЧасти = "Товары";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество");

	// Теперь позовем общую процедуру проверки.
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	ПроверитьЧтоНетУслугВТЧ(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	ПроверитьЧтоНетНаборовВТЧ(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

Процедура ПроверитьЧтоНетУслугВТЧ(ДокументОбъект, ИмяТабличнойЧасти, ТаблицаЗначений, 
                                                    Отказ, Заголовок) Экспорт

	ПредставлениеТабличнойЧасти = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();

	// Цикл по строкам таблицы значений.
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл

		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
		                               """ табличной части """ + ПредставлениеТабличнойЧасти + """: ";

		Если Не ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура)
		   И  СтрокаТаблицы.Номенклатура.Услуга Тогда

				ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "содержится услуга. " +
				                   "Услуг здесь быть не должно!", Отказ, Заголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЧтоНетУслуг()

Процедура ПроверитьЧтоНетНаборовВТЧ(ДокументОбъект, ИмяТабличнойЧасти, ТаблицаЗначений, 
                                                    Отказ, Заголовок) Экспорт

	ПредставлениеТабличнойЧасти = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();

	// Цикл по строкам таблицы значений.
	Для каждого СтрокаТаблицы Из ТаблицаЗначений Цикл

		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
		                               """ табличной части """ + ПредставлениеТабличнойЧасти + """: ";

		Если Не ЗначениеНеЗаполнено(СтрокаТаблицы.Номенклатура) И ТипЗнч(СтрокаТаблицы.Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		   И  СтрокаТаблицы.Номенклатура.Набор Тогда

				ОшибкаПриПроведении(СтрокаНачалаСообщенияОбОшибке + "содержится набор. " +
				                   "Наборов здесь быть не должно!", Отказ, Заголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЧтоНетНаборов()


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Контрагент.Пустая() тогда //23.01.2017 - старые документы - только 1 резерв
		Контрагент = Справочники.Контрагенты.НайтиПоКоду("П004703");	
    КонецЕсли;

КонецПроцедуры

