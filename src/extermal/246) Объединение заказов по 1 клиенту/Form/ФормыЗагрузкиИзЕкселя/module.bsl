﻿
Процедура ОсновныеДействияФормыПеренести(Кнопка)
	НСтр = 1;
	НКол = 1;
	
	МассивНомеров = Новый СписокЗначений;
	
	Ячейка = ЭлементыФормы.СписокДокументов.Область(НСтр, НКол, НСтр, НКол);
	Пока Ячейка.Текст <> "" Цикл
		МассивНомеров.Добавить(СокрЛП(Ячейка.Текст));
		НСтр = НСтр + 1;
		Ячейка = ЭлементыФормы.СписокДокументов.Область(НСтр, НКол, НСтр, НКол);
	КонецЦикла;
    Закрыть(МассивНомеров);
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	Закрыть();
КонецПроцедуры
