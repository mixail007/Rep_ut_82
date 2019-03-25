﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если не Согласованно  тогда
		отказ = истина;
		Сообщить("Перед проведением согласуйте с Егором Малышевым");
	конецесли;	
	
	Для каждого стр  Из товары Цикл
		если не ЗначениеЗаполнено(стр.Заготовка)  тогда
			сообщить("не заполнена заготовка в строке № "+стр.НомерСтроки);
			отказ = истина;
		конецесли;
		Если  Дата> Дата('20181201')  тогда
			Если стр.Количество>1 тогда
				Сообщить("Не верное количество в строке № "+стр.НомерСтроки);
				отказ = Истина;
			конецесли;
			//Если СтрДлина(стр.ID_диска)>0 и СтрДлина(стр.ID_диска)<16 тогда   //***заремлено 2019.03.25
			//	Сообщить("Неверное количество символов в ID в строке № "+стр.НомерСтроки);
			//	отказ = Истина;
			//конецесли;
		Конецесли;
	конецЦикла;
	Если не отказ тогда
		Движения.РезервЗаготовокПодЗаказы.Записывать = Истина;
		Движения.РезервЗаготовокПодЗаказы.Очистить();
		ТоварыДляЗаписи =  Товары.Выгрузить();
		ТоварыДляЗаписи.свернуть("Номенклатура,Заготовка","Количество");
		Для Каждого ТекСтрока Из ТоварыДляЗаписи Цикл
			Движение = Движения.РезервЗаготовокПодЗаказы.Добавить();
			Движение.Задание = ссылка;
			Движение.Диск = ТекСтрока.номенклатура;
			Движение.Заготовка = ТекСтрока.Заготовка;
			Движение.Количество = ТекСтрока.Количество;
		КонецЦикла;
	конецЕсли;
КонецПроцедуры

Функция ПолучитьСписокПечатныхФорм() Экспорт
	
	СписокМакетов = Новый СписокЗначений;
	
	//СписокМакетов.Добавить("Заказ", "Заказ покупателя");
	//СписокМакетов.Добавить("ЗаказКорректировка", "Заказ покупателя (с учетом корректировок)");
	//СписокМакетов.Добавить("Счет", "Счет на оплату (с учетом корректировок)");
	//СписокМакетов.Добавить("СчетАртикул", "Счет на оплату (Артикул)");
	
	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	
	
	Возврат СписокМакетов;
	
КонецФункции // ПолучитьСписокПечатныхФорм()
	
процедура печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь)  экспорт
	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ДополнительныеПечатныеФормы") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
		ОбъектВнешнейФормы = ИмяМакета.ПолучитьОбъект();
		Если ОбъектВнешнейФормы = Неопределено Тогда
			Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяФайла);
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Ссылка;
		ТабДокумент = Обработка.Печать();
		
	КонецЕсли; 
	
	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));
	
	
конецпроцедуры	