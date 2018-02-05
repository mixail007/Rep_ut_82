﻿
Процедура ПередЗаписью(Отказ)

	Если (НЕ ЭтоГруппа)
	   И (НЕ ОбменДанными.Загрузка)
	   И ЗначениеНеЗаполнено(ВидДенежныхСредств) Тогда
		ТекстСообщения = "Необходимо заполнить вид денежных средств для вида оплаты чека ККМ"
		                  + ?(НЕ Ссылка.Пустая(), " """ + СокрЛП(Ссылка) + """!", "");
		СообщитьОбОшибке(ТекстСообщения, Отказ);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		
		обЗаписатьПротоколИзменений(ЭтотОбъект);
		
	КонецЕсли; 

КонецПроцедуры

