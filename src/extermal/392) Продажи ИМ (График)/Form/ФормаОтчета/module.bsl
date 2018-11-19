﻿
Процедура ДействияФормыДействие6(Кнопка) экспорт
	ЭлементыФормы.Результат.Очистить();
	СхемаКД	= ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");

    //2. Получаем настройки компоновки данных
    НастройкиКД = КомпоновщикНастроек.Настройки;
    НастройкиКД.ПараметрыДанных.УстановитьЗначениеПараметра("НаправлениеПродажКолесаТУТ", Справочники.НаправленияПродаж.НайтиПоКоду("16"));

    //3. Получаем макет компоновки данных
    КомпоновщикМакетаКД	= Новый КомпоновщикМакетаКомпоновкиДанных;
    МакетКД		= КомпоновщикМакетаКД.Выполнить(СхемаКД, НастройкиКД);

    //4, 5. Выводим результат компоновки данных в табличный документ
    ПроцессорКД	= Новый ПроцессорКомпоновкиДанных;
    ПроцессорКД.Инициализировать(МакетКД);

    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(ЭлементыФормы.Результат);
    ПроцессорВывода.Вывести(ПроцессорКД);
	
	//ЭлементыФормы.Результат.Рисунки[0].Ширина = ЭлементыФормы.Результат.Ширина/4 - 20;
	//ЭлементыФормы.Результат.Рисунки[0].высота = ЭлементыФормы.Результат.Высота/4 - 20;
	
	//цвет прошлый год такой же как тек год
	//линия - пунктир
	для каждого рисунок из ЭлементыФормы.Результат.Рисунки цикл
		рисунок.Ширина = ЭлементыФормы.Результат.Ширина/4 - 20;
	    рисунок.высота = ЭлементыФормы.Результат.Высота/4 - 20;
		Для каждого серия из рисунок.Объект.Серии цикл
			Если Найти(Серия.текст,"прошлый год")>0 тогда
				Цвет = Серия.Цвет;
				ИмяСерияТек = СокрЛП(СтрЗаменить(Серия.текст," прошлый год",""));
				Для каждого серияВрем из рисунок.Объект.Серии цикл
					Если СерияВрем.Текст = ИмяСерияТек тогда
						Цвет = СерияВрем.Цвет;
						прервать;
					КонецЕсли;
				КонецЦикла;
				серия.Цвет = Цвет;
				серия.Линия = новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Точечная,2);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
КонецПроцедуры
