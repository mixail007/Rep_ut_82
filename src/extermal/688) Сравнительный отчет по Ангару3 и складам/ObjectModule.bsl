﻿Параметры = КомпоновщикНастроек.Настройки.ПараметрыДанных;	
	Параметры.УстановитьЗначениеПараметра("ангар3", Справочники.Склады.НайтиПоКоду("01249"));
	Параметры.УстановитьЗначениеПараметра("Подразделение", Справочники.Подразделения.НайтиПоКоду("00005"));
	Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДата());
