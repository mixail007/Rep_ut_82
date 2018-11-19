﻿
Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ТабДок = ЭлементыФормы.ПолеТабличногоДокумента;
	Отчет(ТабДок);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура Отчет(ТабДок) Экспорт
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Макет = ВнешняяОбработкаОбъект.ПолучитьМакет("Отчет");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ 
|Б.Номенклатура.Код,
|Б.Номенклатура,
|ТоварыНаСкладахОстатки.КоличествоОстаток Остаток,
|Б.МаксимальныйВход
|ИЗ
|(ВЫБРАТЬ
|		А.Номенклатура,
|		МАКСИМУМ(А.ВходнаяЦена) КАК МаксимальныйВход
|	ИЗ
|		(ВЫБРАТЬ
|			Номенклатура КАК Номенклатура,
|			ВЫБОР
|				КОГДА КоличествоОстаток > 0
|					ТОГДА СтоимостьОстаток / КоличествоОстаток
|				ИНАЧЕ 0
|			КОНЕЦ КАК ВходнаяЦена,
|			ДокументОприходования 
|		ИЗ
|			РегистрНакопления.ПартииТоваровНаСкладах.Остатки(, (НЕ Склад.ЗапретитьИспользование)) ) КАК А
|	СГРУППИРОВАТЬ ПО Номенклатура) Б		
|  ЛЕВОЕ СОЕДИНЕНИЕ
|		РегистрНакопления.ТоварыНаСкладах.Остатки(, (НЕ Склад.ЗапретитьИспользование)) КАК ТоварыНаСкладахОстатки
|		ПО  Б.Номенклатура=ТоварыНаСкладахОстатки.Номенклатура
|	Упорядочить по Б.Номенклатура.Наименование";

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаДетали = Результат.Выбрать();

	Пока ВыборкаДетали.Следующий() Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетали);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетали.Уровень());
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ
КонецПроцедуры
