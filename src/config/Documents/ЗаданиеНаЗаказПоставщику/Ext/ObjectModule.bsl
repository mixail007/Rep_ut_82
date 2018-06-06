﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателяСезонный") Тогда
		ТоварыЗаказ = ДанныеЗаполнения.Товары.выгрузить();
		ТоварыЗаказ.Свернуть("Завод");
		Если ТоварыЗаказ.Количество()>1 тогда
			Сообщить("Недопускается создание задания на заказ поставщику, если в заказе несколько заводов");
			Возврат;
		КонецЕсли;
		// Заполнение шапки
		Контрагент = ДанныеЗаполнения.Контрагент;
		ЗаказПокупателяСезонный = ДанныеЗаполнения.Ссылка;
		ДатаСогласования = ТекущаяДата()+14*24*60*60;
		Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Завод = ТекСтрокаТовары.Завод;
			НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	Если не рольДоступна("ПравоЗавершенияРаботыПользователей") тогда
		Сообщить("У вас нет прав для удаление задания.");
		отказ = истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//+++ Шарафутдинов 23.04.2018 по задаче 45625 
	
	//записывать можно всем
	
	//Если не рольДоступна("ПравоЗавершенияРаботыПользователей") 
	//	и не СокрЛП(глТекущийПользователь.Код) = "Малышев Егор" 
	//	и не СокрЛП(глТекущийПользователь.Код) = "Гугунишвили О. Г."
	//	и не СокрЛП(глТекущийПользователь.Код) = "Жарикова В."
	//	и не СокрЛП(глТекущийПользователь.Код) = "Вострилов А.В."
	//	и не СокрЛП(глТекущийПользователь.Код) = "Ильина Н.В.(ВЭД)"
	//	и не СокрЛП(глТекущийПользователь.Код) = "Доколин"
	//	и не СокрЛП(глТекущийПользователь.Код) = "Сухачева А.В."
	//	и не СокрЛП(глТекущийПользователь.Код) = "Голубева В.С." Тогда
	//	Сообщить("У вас нет прав для записи задания.");
	//	отказ = истина;
	//КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение или РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения тогда
		Если не рольДоступна("ПравоЗавершенияРаботыПользователей") 
			и не СокрЛП(глТекущийПользователь.Код) = "Бондаренко Е.Д. (снабжение)" 
			и не СокрЛП(глТекущийПользователь.Код) = "Ильина Н.В."
			и не СокрЛП(глТекущийПользователь.Код) = "Жарикова В."
			и не СокрЛП(глТекущийПользователь.Код) = "Малышев Егор"  тогда
			Сообщить("У вас нет прав для проведения задания.");
			отказ = истина;
		КонецЕсли;	
	КонецЕсли;
		
	
	
	//--- Шарафутдинов 23.04.2018 по задаче 45625 
	
КонецПроцедуры 