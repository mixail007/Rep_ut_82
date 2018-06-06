﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если ЗначениеНеЗаполнено(ЗаявкаНаРасходованиеСредствИсточник)	Тогда
		Сообщить("Не выбрана заявка-источник",СтатусСообщения.Важное);
		Отказ=Истина;
	КонецЕсли;	
	
	Если ЗначениеНеЗаполнено(ЗаявкаНаРасходованиеСредствПриемник)	Тогда
		Сообщить("Не выбрана заявка-приемник",СтатусСообщения.Важное);
		Отказ=Истина;
	КонецЕсли;	
	
	Если НЕ Отказ Тогда
		Если ДанныеЗаявкиИсточник.Итог("СуммаПлатежа")<>ДанныеЗаявкиПриемник.Итог("СуммаПлатежа") Тогда
		Сообщить("Суммы переданная = " +Строка(ДанныеЗаявкиИсточник.Итог("СуммаПлатежа"))+" и принятая = "+Строка(ДанныеЗаявкиПриемник.Итог("СуммаПлатежа"))+" отличаются.",СтатусСообщения.Важное);
		Отказ=Истина;
		КонецЕсли;
	КонецЕсли;	
	
	Если  Отказ Тогда
	Возврат;
	КонецЕсли;
		
		

	
	Запрос=Новый Запрос;
	
Запрос.Текст="ВЫБРАТЬ 
|КорректировкаЗаявки.ДоговорКонтрагента ДоговорКонтрагента,
|КорректировкаЗаявки.Сделка Сделка,
|КорректировкаЗаявки.СтатьяДвиженияДенежныхСредств СтатьяДвиженияДенежныхСредств,
|КорректировкаЗаявки.СуммаПлатежа СуммаПлатежа,
|ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток СуммаОстаток
|ИЗ
| (ВЫБРАТЬ ДоговорКонтрагента,
| Сделка,
| СтатьяДвиженияДенежныхСредств,
| СуммаПлатежа
|ИЗ
|	Документ.КорректировкаЗаявкиНаРасходованиеСредств.ДанныеЗаявкиИсточник
|	ГДЕ Ссылка=&ТекущийДокумент
|	)  КорректировкаЗаявки
|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаявкиНаРасходованиеСредств.Остатки(,ЗаявкаНаРасходование = &ЗаявкаНаРасходование) КАК ЗаявкиНаРасходованиеСредствОстатки
|		ПО КорректировкаЗаявки.ДоговорКонтрагента = ЗаявкиНаРасходованиеСредствОстатки.ДоговорКонтрагента
|			И КорректировкаЗаявки.Сделка = ЗаявкиНаРасходованиеСредствОстатки.Сделка
|			И КорректировкаЗаявки.СтатьяДвиженияДенежныхСредств = ЗаявкиНаРасходованиеСредствОстатки.СтатьяДвиженияДенежныхСредств
|ГДЕ	КорректировкаЗаявки.СуммаПлатежа-ЕстьNULL(ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток,0)>0	";

Запрос.УстановитьПараметр("ЗаявкаНаРасходование",ЗаявкаНаРасходованиеСредствИсточник);
Запрос.УстановитьПараметр("ТекущийДокумент",Ссылка);

Выборка=Запрос.Выполнить().Выбрать();
Если Выборка.Следующий() Тогда
	Сообщить("По договору "+Строка(Выборка.ДоговорКонтрагента)+", сделке "+Строка(Выборка.Сделка)+" и статье ДДС "+Строка(Выборка.СтатьяДвиженияДенежныхСредств)+" сумма больше, чем остаток");
	Отказ = Истина;
	Возврат;
Иначе
	Для Каждого СтрокаДанныеЗаявки Из ДанныеЗаявкиИсточник Цикл
		// регистр ЗаявкиНаРасходованиеСредств Расход
		Движение = Движения.ЗаявкиНаРасходованиеСредств.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.ЗаявкаНаРасходование= ЗаявкаНаРасходованиеСредствИсточник;
		Движение.ДоговорКонтрагента = СтрокаДанныеЗаявки.ДоговорКонтрагента;
		Движение.Сделка = СтрокаДанныеЗаявки.Сделка;
		Движение.СтатьяДвиженияДенежныхСредств= СтрокаДанныеЗаявки.СтатьяДвиженияДенежныхСредств;
		Движение.Сумма= СтрокаДанныеЗаявки.СуммаПлатежа;
		Движение.СуммаВзаиморасчетов= СтрокаДанныеЗаявки.СуммаПлатежа;
		Движение.СуммаУпр= СтрокаДанныеЗаявки.СуммаПлатежа;
		
	КонецЦикла;
	
	Для Каждого СтрокаДанныеЗаявки Из ДанныеЗаявкиПриемник Цикл
		// регистр ЗаявкиНаРасходованиеСредств Расход
		Движение = Движения.ЗаявкиНаРасходованиеСредств.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.ЗаявкаНаРасходование= ЗаявкаНаРасходованиеСредствПриемник;
		Движение.ДоговорКонтрагента = СтрокаДанныеЗаявки.ДоговорКонтрагента;
		Движение.Сделка = СтрокаДанныеЗаявки.Сделка;
		Движение.СтатьяДвиженияДенежныхСредств= СтрокаДанныеЗаявки.СтатьяДвиженияДенежныхСредств;
		Движение.Сумма= СтрокаДанныеЗаявки.СуммаПлатежа;
		Движение.СуммаВзаиморасчетов= СтрокаДанныеЗаявки.СуммаПлатежа;
		Движение.СуммаУпр= СтрокаДанныеЗаявки.СуммаПлатежа;
		
	КонецЦикла;

	// записываем движения регистров
	Движения.ЗаявкиНаРасходованиеСредств.Записать();
	
	
КонецЕсли;	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если Ответственный<> глТекущийПользователь Тогда
	Ответственный =глТекущийПользователь;
	КонецЕсли;
КонецПроцедуры
