﻿
// Обработчик события "ПередЗаписью" Объекта
//
Процедура ПередЗаписью(Отказ)
	
	//СтрокаОшибки = "Контактное лицо " + Наименование + " не записано!";
	//
	//Если НЕ ОбменДанными.Загрузка Тогда
	//	Если ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента
	//	   И ЗначениеНеЗаполнено(ОбъектВладелец) Тогда
	//		СообщитьОбОшибке("Не указан контрагент.",, СтрокаОшибки);
	//		Отказ = Истина;
	//	КонецЕсли;
	//	Если ОбъектВладелец.ЭтоГруппа Тогда
	//		Если ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента Тогда
	//			ОписаниеОшибки = "В качестве контрагента нельзя выбирать группу.";
	//		Иначе
	//			ОписаниеОшибки = "В качестве ответственного нельзя выбирать группу пользователей.";
	//		КонецЕсли;
	//		СообщитьОбОшибке(ОписаниеОшибки,, СтрокаОшибки);
	//		Отказ = Истина;
	//	КонецЕсли; 
	//КонецЕсли;
	//
	//Если ВидКонтактногоЛица = Перечисления.ВидыКонтактныхЛиц.ЛичныйКонтакт Тогда
	//	ПользовательДляОграниченияПравДоступа = глТекущийПользователь;
	//	КонтрагентДляОграниченияПравДоступа   = Справочники.Контрагенты.ПустаяСсылка();
	//Иначе
	//	Если ТипЗнч(ОбъектВладелец) = Тип("СправочникСсылка.Контрагенты") Тогда
	//		ПользовательДляОграниченияПравДоступа = Справочники.Пользователи.ПустаяСсылка();
	//		КонтрагентДляОграниченияПравДоступа   = ОбъектВладелец;
	//	ИначеЕсли ТипЗнч(ОбъектВладелец) = Тип("СправочникСсылка.Пользователи") Тогда
	//		ПользовательДляОграниченияПравДоступа = ОбъектВладелец;
	//		КонтрагентДляОграниченияПравДоступа   = Справочники.Контрагенты.ПустаяСсылка();
	//	КонецЕсли; 
	//КонецЕсли;
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 
	
КонецПроцедуры
