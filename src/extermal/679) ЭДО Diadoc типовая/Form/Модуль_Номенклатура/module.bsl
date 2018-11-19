﻿Процедура УстановитьСоответствие(Номенклатура, Контрагент, Code, NomenclatureArticle, Name) Экспорт
	ПолучитьМодульПрог("Модуль_Логика_ПрофилиКонфигурации").УстановитьНоменклатруПоставщика(
		Номенклатура,
		Контрагент,
		Code,
		NomenclatureArticle,
		Name);
КонецПроцедуры

Функция ПолучитьНоменклатуруПоставщика(Контрагент, Name, Code, NomenclatureArticle) Экспорт
	Возврат ПолучитьМодульПрог("Модуль_Логика_ПрофилиКонфигурации").ПолучитьНоменклатуруПоставщика(
		Контрагент,
		Name,
		Code,
		NomenclatureArticle);
КонецФункции

Функция ПолучитьНоменклатуруПоАртикулу(NomenclatureArticle) Экспорт
	Возврат ПолучитьМодульПрог("Модуль_Логика_ПрофилиКонфигурации").ПолучитьНоменклатуруПоАртикулу(
		NomenclatureArticle);
КонецФункции
