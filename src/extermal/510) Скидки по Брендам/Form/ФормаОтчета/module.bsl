﻿
Процедура скидкаПриИзменении(Элемент)
	ТабДок = Новый ТабличныйДокумент;
	ЭтотОбъект.СкомпоноватьРезультат(ТабДок);
	ЭлементыФормы.Результат.ТолькоПросмотр = Истина;
	ЭлементыФормы.Результат.Вывести(ТабДОк);
КонецПроцедуры

Процедура ПриОткрытии()
	Если Найти(глТекущийПользователь,"Малышев") = 0 и Найти(глТекущийПользователь,"Плотников") = 0 и Найти(глТекущийПользователь,"Марешева") и Найти(глТекущийПользователь,"Бондаренко") = 0 Тогда
		ЭтаФорма.Закрыть();
	КонецЕсли;  
	видСравнения = ">";
	ЭлементыФормы.видСравнения.СписокВыбора.Добавить(">");
	ЭлементыФормы.видСравнения.СписокВыбора.Добавить("<");
	ЭлементыФормы.видСравнения.СписокВыбора.Добавить("=");
	ЭлементыФормы.видСравнения.СписокВыбора.Добавить("<>");
	
КонецПроцедуры
