﻿
Процедура ДействияФормыАналитикаПродажПоБрендамСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(АналитикаПродажПоБрендам)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ТабДок = ЭлементыФормы.ПолеТабличногоДокумента;
	АналитикаПродажПоБрендам(ТабДок);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура АналитикаПродажПоБрендам(ТабДок) Экспорт
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ(АналитикаПродажПоБрендам)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Макет = ПолучитьМакет("АналитикаПродажПоБрендам");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АналитикаПродажПоБрендам.Производитель КАК Производитель,
	|	АналитикаПродажПоБрендам.Статус КАК Статус,
	|	АналитикаПродажПоБрендам.Контрагент КАК Контрагент,
	|	АналитикаПродажПоБрендам.КоличествоЗима КАК КоличествоЗима,
	|	АналитикаПродажПоБрендам.КоличествоЛето КАК КоличествоЛето
	|ИЗ
	|	РегистрСведений.АналитикаПродажПоБрендам КАК АналитикаПродажПоБрендам
	|
	|УПОРЯДОЧИТЬ ПО
	|	АналитикаПродажПоБрендам.Производитель.Наименование,
	|	Статус
	|ИТОГИ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Контрагент),
	|	СУММА(КоличествоЗима),
	|	СУММА(КоличествоЛето)
	|ПО
	|	ОБЩИЕ,
	|	Производитель,
	|	Статус";

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
	ОбластьПроизводитель = Макет.ПолучитьОбласть("Производитель");
	
	ОбластьСтатус = Макет.ПолучитьОбласть("Статус");

	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ВыборкаОбщийИтог.Следующий();		// Общий итог
	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

	ВыборкаПроизводитель = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	Пока ВыборкаПроизводитель.Следующий() Цикл
		ОбластьПроизводитель.Параметры.Заполнить(ВыборкаПроизводитель);
		ТабДок.Вывести(ОбластьПроизводитель, ВыборкаПроизводитель.Уровень());

		ВыборкаСтатус = ВыборкаПроизводитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

		Пока ВыборкаСтатус.Следующий() Цикл
			ОбластьСтатус.Параметры.Заполнить(ВыборкаСтатус);
			
			
			
			ТабДок.Вывести(ОбластьСтатус, ВыборкаСтатус.Уровень());
			ВыборкаКонтрагент = ВыборкаСтатус.Выбрать(ОбходРезультатаЗапроса.Прямой);
			
			Пока ВыборкаКонтрагент.Следующий() Цикл
				ОбластьКонтрагент = Макет.ПолучитьОбласть("Детали");
				ОбластьКонтрагент.Параметры.Заполнить(ВыборкаКонтрагент);
				 ТабДок.Вывести(ОбластьКонтрагент, ВыборкаКонтрагент.Уровень());
				
			КонецЦикла;	
			
			
			
		КонецЦикла;
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ
КонецПроцедуры


