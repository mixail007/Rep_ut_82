﻿
Процедура ПередУдалением(Отказ)
	Если Состояние = Перечисления.СостоянияОбъектов.Подготовлен или не ЗначениеЗаполнено(Состояние) тогда
	иначе
		Сообщить("Документ можно удалить только в статусе <Подготовлен>");
		отказ = истина;
	конецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Если Состояние = Перечисления.СостоянияОбъектов.Подготовлен или не ЗначениеЗаполнено(Состояние) тогда
	иначе
		Сообщить("Документ можно удалить только в статусе <Подготовлен>");
		отказ = истина;
	конецЕсли;

КонецПроцедуры
