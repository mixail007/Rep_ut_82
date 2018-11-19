﻿// Процедура устанавливает заголовок формы в зависимости от заказа
//
Процедура УстановитьЗаголовок()
	
	ТипЗаказа = ТипЗнч(Заказ);

	Если      ТипЗаказа = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		Заголовок = "Анализ заказа поставщику";
	ИначеЕсли ТипЗаказа = Тип("ДокументСсылка.ВнутреннийЗаказ") Тогда
		Заголовок = "Анализ внутреннего заказа";
	Иначе
		Заголовок = "Анализ заказа покупателя";
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗаголовок()

// Запускает процедуру формирования отчета.
//
Процедура КнопкаСформироватьНажатие(Элемент)
	
    СформироватьОтчет(ЭлементыФормы.ДокументРезультат);
	
КонецПроцедуры // КнопкаСформироватьНажатие()

// Устанавливает дату анализа на текущий момент.
//
Процедура ЗаказПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ЗаказПокупателя = ВыбранноеЗначение;
	
КонецПроцедуры // ЗаказПокупателяОбработкаВыбора()

// Процедура - обработчик начала выбора в поле "ЗаказПокупателя"
//
Процедура ЗаказПокупателяНачалоВыбора(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить( "ЗаказПокупателя", Метаданные.Документы.ЗаказПокупателя.Синоним);
	СписокТипов.Добавить( "ЗаказПоставщику", Метаданные.Документы.ЗаказПоставщику.Синоним);
	СписокТипов.Добавить( "ВнутреннийЗаказ", Метаданные.Документы.ВнутреннийЗаказ.Синоним);

	ВыбранныйЭлемент = ЭтаФорма.ВыбратьИзСписка(СписокТипов,Элемент);

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Элемент.Значение = Документы[ВыбранныйЭлемент.Значение].ПустаяСсылка();

	// В качестве владельца формы выбора устанавливаем данный элемент формы, чтобы выбранное
	// значение было присвоено стандартно.
	ФормаВыбора = Документы[ВыбранныйЭлемент.Значение].ПолучитьФормуВыбора(, Элемент,);

	ФормаВыбора.РежимВыбора = Истина;
	ФормаВыбора.Открыть();

КонецПроцедуры

// Открывает новое окно отчета, копируя содержимое текущего.
Процедура ДействияФормыНовоеОкно(Кнопка)
	ТекущийОтчет = ЭтотОбъект;

	НовыйОтчет = Отчеты.АнализЗаказа.Создать();

	Для каждого Реквизит Из Метаданные.Отчеты["АнализЗаказа"].Реквизиты Цикл

		НовыйОтчет[Реквизит.Имя] = ТекущийОтчет[Реквизит.Имя];

	КонецЦикла;
	
	НовыйОтчетФорма = НовыйОтчет.ПолучитьФорму();
	НовыйОтчетФорма.ЭлементыФормы.ДокументРезультат.Очистить();
	НовыйОтчетФорма.ЭлементыФормы.ДокументРезультат.Вывести(ЭлементыФормы.ДокументРезультат.ПолучитьОбласть());
	НовыйОтчетФорма.Открыть();
КонецПроцедуры

// Процедура - обработчик ПриИзменении в поле "ЗаказПокупателя"
//
Процедура ЗаказПокупателяПриИзменении(Элемент)
	
	УстановитьЗаголовок();
	
КонецПроцедуры // ЗаказПокупателяПриИзменении()

// Процедура - обработчик события ПриОткрытии формы
Процедура ПриОткрытии()
	
	УстановитьЗаголовок();
	Заказ = СсылкаНаОбъект;
	
КонецПроцедуры // ПриОткрытии()


