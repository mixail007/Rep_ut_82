﻿
Функция Печать() Экспорт
	
		ОбработкаПечати = ПолучитьФорму("Форма");

		Документ       = ЭтотОбъект.СсылкаНаОбъект;
		СрокДоставки   		= Документ.СрокДоставки;
		Сообщить(СрокДоставки);
		МаркаАвтомобиля 	= Документ.МаркаАвтомобиля;
		МаркаПрицепа		= Документ.МаркаПрицепа;
		ГосНомерАвтомобиля  = Документ.ГосНомерАвтомобиля;
		ГосНомерПрицепа     = Документ.ГосНомерПрицепа;
		ПунктПогрузки		= Документ.ПунктПогрузки;
		ПунктРазгрузки      = Документ.ПунктРазгрузки;
		Водитель            = Документ.Водитель;
		Перевозчик          = Документ.Перевозчик;
		Заказчик            = Документ.Заказчик;
		ВидПеревозки        = Документ.ВидПеревозки;
		ВодительскоеУдостоверение = Документ.ВодительскоеУдостоверение;
		
		ОбработкаПечати.Документ = Документ;
		//ОбработкаПечати.Форма 			= Форма;
		ОбработкаПечати.Открыть();

		Возврат Неопределено;

КонецФункции