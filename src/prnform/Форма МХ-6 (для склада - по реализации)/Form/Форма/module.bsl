﻿Процедура Отчет()

		
 Док = Печать();
 Док.Показать();


КонецПроцедуры
 


Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
	

	ПриОткрытии();
	
КонецПроцедуры

Процедура ПриОткрытии()
	// Вставить содержимое обработчика.
	
	
	Если НЕ СсылкаНаОбъект = Документы.РеализацияТоваровУслуг.ПустаяСсылка() Тогда
	
		Отчет();
	
	КонецЕсли; 
	
КонецПроцедуры
