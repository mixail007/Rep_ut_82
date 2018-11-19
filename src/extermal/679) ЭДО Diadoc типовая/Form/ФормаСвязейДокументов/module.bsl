﻿Процедура ПоказСтруктурыПодчиненности(DocumentПар) Экспорт
	Document = DocumentПар;
	BoxId = Document.OrganizationId;
	DocumentId = Document.DocumentId;
	Направление = Document.Direction;
	
	ИнициализироватьФорму();
	
	Открыть();
КонецПроцедуры

Функция ИнициализироватьФорму()
	Document =  Модуль_РаботаССерверомДиадок.ОбновитьЭДоОбъектДиадока(Document, ЭтаФорма);
	ДеревоДокументов.Строки.Очистить();
	Модуль_РаботаССерверомДиадок.ПолучитьДеревоСвязейДокументов(Document, ДеревоДокументов);
	Для каждого стр Из ДеревоДокументов.Строки Цикл
		ЭлементыФормы.ДеревоДокументов.Развернуть(стр);
	КонецЦикла;
	
	Если ДеревоДокументов.Строки.Количество() > 0 Тогда
		Продавец = Модуль_РаботаССерверомДиадок.ПредставлениеПродавца(ДеревоДокументов.Строки[0].ЭДОбъект);
		Покупатель = Модуль_РаботаССерверомДиадок.ПредставлениеПокупателя(ДеревоДокументов.Строки[0].ЭДОбъект);
		
		ПерваяСтрока = ДеревоДокументов.Строки[0];
		ОформлениеСтроки = ЭлементыФормы.ДеревоДокументов.ОформлениеСтроки(ПерваяСтрока);
		ПолучитьМодульПрог("Модуль_Логика_СверкаДанных").ОформитьСтрокуДанныхЭД(ОформлениеСтроки, Document);
		РасшифровкаОшибок = ПерваяСтрока.ТекстОшибки;
	Иначе
		РасшифровкаОшибок = "";
	КонецЕсли;
КонецФункции

Процедура ДеревоДокументовПередНачаломИзменения(Элемент, Отказ)
	КоманднаяПанель1ОткрытьКарточкуДокумента("");
	
	Отказ = Истина;
КонецПроцедуры

Процедура КоманднаяПанель1ОткрытьКарточкуДокумента(Кнопка)
	текущаяСтрока = ЭлементыФормы.ДеревоДокументов.ТекущиеДанные;
	Если  текущаяСтрока = Неопределено Тогда
		Предупреждение("Выберите документ.",, НаименованиеСистемы);
		Возврат
	КонецЕсли;
	ПолучитьМодульПрог("Модуль_Логика_ПоведениеФорм").ОткрытьКарточкуДокументаДД(текущаяСтрока.ЭДОбъект, ЭтаФорма);
 КонецПроцедуры

Процедура ДеревоДокументовПриПолученииДанных(Элемент, ОформленияСтрок)
	ПолучитьМодульПрог("Модуль_Логика_СверкаДанных").ОформитьСписокЭД(ОформленияСтрок);
	Для Каждого стр Из ОформленияСтрок цикл 
		текДанные = стр.ДанныеСтроки;
		Если текДанные.DocumentId = DocumentId Тогда
			стр.Шрифт = Новый Шрифт(стр.Шрифт,,, Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ДеревоДокументовПриАктивизацииСтроки(Элемент)
	РасшифровкаОшибок = ?(Элемент.ТекущиеДанные=Неопределено, "", Элемент.ТекущиеДанные.ТекстОшибки);
КонецПроцедуры

Процедура КоманднаяПанель1Обновить(Кнопка)
	ДеревоДокументов.Строки.Очистить();
	ИнициализироватьФорму();
КонецПроцедуры

Процедура ДеревоДокументовПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

Процедура ОбновитьОбъектЭДО(КоллекцияСтрок,МассивОформленийСтрок, ЭДОбъект)
	//МассивОформленийСтрок = Новый Массив();

	Для каждого строка из КоллекцияСтрок цикл 
		Если (строка.BoxID =  ЭДОБъект.OrganizationId) и (строка.DocumentID =  ЭДОБъект.DocumentID) Тогда
			строка.ЭДОбъект = ЭДОбъект;
			МассивОформленийСтрок.Добавить(Элементыформы.ДеревоДокументов.ОформлениеСтроки(строка));
			Модуль_РаботаССерверомДиадок.ЗаполнитьПараметрыДокументаВДереве(строка,ЭДОБъект);
		КонецЕсли;
		ОбновитьОбъектЭДО(строка.Строки , МассивОформленийСтрок, ЭДОбъект);
	КонецЦикла;	
КонецПроцедуры	

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если (ИмяСобытия = "ОбновитьСтроку") или ( ИмяСобытия = "ИзменениеДокумента1С") Тогда 
		// Параметр - ЭДОбъект
		МассивОформленийСтрок = Новый Массив();
		//подменим объект ЭД
		ОбновитьОбъектЭДО(ДеревоДокументов.Строки, МассивОформленийСтрок, Параметр);
		ДеревоДокументовПриПолученииДанных("", МассивОформленийСтрок);
		Если ЗначениеЗаполнено(Элементыформы.ДеревоДокументов.ТекущиеДанные) Тогда 
			РасшифровкаОшибок = Элементыформы.ДеревоДокументов.ТекущиеДанные.ТекстОшибки;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзменениеСвязиДД1С" И Параметр.ТипСущности = "Документ" Тогда
		// Параметр - ЭДОбъект
		МассивОформленийСтрок = Новый Массив();
		//подменим объект ЭД
		ОбновитьОбъектЭДО(ДеревоДокументов.Строки, МассивОформленийСтрок, Параметр.СсылкаДД);
		ДеревоДокументовПриПолученииДанных("", МассивОформленийСтрок);
		Если ЗначениеЗаполнено(Элементыформы.ДеревоДокументов.ТекущиеДанные) Тогда 
			РасшифровкаОшибок = Элементыформы.ДеревоДокументов.ТекущиеДанные.ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ДеревоДокументовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)
	отказ = Истина;
КонецПроцедуры

Процедура ПриОткрытии()
	КартинкаЗаголовка= ЭДО_БиблиотекаКартинок().КартинкаЗаголовка;
	ЭтаФорма.Заголовок = "Структура связей документов в "+НаименованиеСистемы;
КонецПроцедуры
