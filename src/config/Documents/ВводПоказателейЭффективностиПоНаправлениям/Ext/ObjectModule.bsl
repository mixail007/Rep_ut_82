﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Для Каждого ТекСтрокаДанные Из Данные Цикл
		
		Движение = Движения.ПланыПродажПоПоказателямЭффективности.Добавить();
		Движение.Период = ПериодРегистрации;
		Движение.ОбъектПланирования = Справочники.НаправленияПродаж.ПустаяСсылка(); //пустая
		Движение.ПоказательЭффективности = ТекСтрокаДанные.ПоказательЭффективности;
		Движение.ПараметрПоказателя = ТекСтрокаДанные.ПараметрПоказателя;
		Движение.ЗначениеПлан = ТекСтрокаДанные.ПланПоКомпании;                     //берется  только 1 сумма...
		Движение.Вес = ТекСтрокаДанные.Вес;
				
	КонецЦикла;

КонецПроцедуры


