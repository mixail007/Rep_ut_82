﻿
Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	ТабДок = ЭлементыФормы.ПолеТабличногоДокумента;
	ПолучитьОтчет(табДок, НачДата);
	
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура ПриОткрытии()
	НачДата = НачалоНедели( ТекущаяДата() ) - 7*86400;
КонецПроцедуры
