﻿
//#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗапросСпКасса=Новый Запрос("ВЫБРАТЬ
	                           |	ТорговоеОборудование.КассаККМ,
	                           |	ТорговоеОборудование.МодельТорговогоОборудования
	                           |ИЗ
	                           |	РегистрСведений.ТорговоеОборудование КАК ТорговоеОборудование
	                           |ГДЕ
	                           |	ТорговоеОборудование.МодельТорговогоОборудования.ВидТорговогоОборудования = &ВидТорговогоОборудования
	                           |	И ТорговоеОборудование.Компьютер = &Компьютер
	                           |	И ТорговоеОборудование.КассаККМ = &КассаККМ");
	ЗапросСпКасса.УстановитьПараметр("ВидТорговогоОборудования",Перечисления.ВидыТорговогоОборудования.ККТсПередачейДанных);			
	ЗапросСпКасса.УстановитьПараметр("Компьютер",ИмяКомпьютера());
	//так коряво, что б если что быстро вернуть на типовой механизм
	ЗапросСпКасса.УстановитьПараметр("КассаККМ",ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяКассаККМ"));
	
	Рез = ЗапросСпКасса.Выполнить().Выгрузить();
	
	КомпьютерШапка = ИмяКомпьютера();
	Если рез.Количество()>0 тогда
		КассаККМШапка = Рез[0].КассаККМ;
		МодельШапка = Рез[0].МодельТорговогоОборудования;
    КонецЕсли;
	УстановитьОтборСписка();
	
КонецПроцедуры
 // Функция возвращает строку c именем компьютера для нужд торгового оборудования.
//
// Возвращаемое значение:
//  Строка - имя компьютера для торгового оборудования.
//
Функция ПолучитьИмяКомпьютераТО() Экспорт

	мИмяКомпьютера = ВРег(ИмяКомпьютера());
	Возврат мИмяКомпьютера;

КонецФункции // ПолучитьИмяКомпьютераТО()

&НаКлиенте
Процедура ПриЗакрытии()
	
	//ПолучитьСерверТО().ОтключитьКлиента(ЭтаФорма);
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РеквизитШапкиПриИзменении(Элемент)
	
	УстановитьОтборСписка();
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьКассовуюСмену(Команда)
	
	ОчиститьСообщения();
	МассивККТ = новый СписокЗначений;
	МассивККТ.Очистить();

	Если ЗначениеЗаполнено(КассаККМШапка) тогда
		МассивККТ.Добавить(КассаККМШапка);
	иначе
		
		//МассивККТ = ПолучитьСерверТО().ПолучитьСписокУстройств(
		//	ПредопределенноеЗначение("Перечисление.ВидыТорговогоОборудования.ККТ"), КассаККМШапка);
		
		
		ЗапросСпКасса=Новый Запрос("ВЫБРАТЬ
		|	ТорговоеОборудование.КассаККМ
		|ИЗ
		|	РегистрСведений.ТорговоеОборудование КАК ТорговоеОборудование
		|ГДЕ
		|	ТорговоеОборудование.МодельТорговогоОборудования.ВидТорговогоОборудования = &ВидТорговогоОборудования
		|	И ТорговоеОборудование.Компьютер = &Компьютер
		|	И (ТорговоеОборудование.КассаККМ.Владелец = &Владелец
		|			ИЛИ &Все)
		//|	И ТорговоеОборудование.КассаККМ = &КассаККМ
		|");
		ЗапросСпКасса.УстановитьПараметр("ВидТорговогоОборудования",Перечисления.ВидыТорговогоОборудования.ККТсПередачейДанных);			
		ЗапросСпКасса.УстановитьПараметр("Компьютер",ИмяКомпьютера());
		ЗапросСпКасса.УстановитьПараметр("Владелец",ОрганизацияШапка);
		//ЗапросСпКасса.УстановитьПараметр("КассаККМ",ПолучитьЗначениеПоУмолчанию(глТекущийПользователь, "ОсновнаяКассаККМ"));
		
		
		Если ЗначениеЗаполнено(ОрганизацияШапка) Тогда
			Все=Ложь;
		Иначе
			Все=Истина;
		КонецЕсли;
		ЗапросСпКасса.УстановитьПараметр("Все",Все);
		
		МассивККТ.ЗагрузитьЗначения(ЗапросСпКасса.Выполнить().Выгрузить().ВыгрузитьКолонку("КассаККМ"));
	КонецЕсли;
		
	КоличествоККТ = МассивККТ.Количество();
	Если КоличествоККТ = 0 Тогда
		ТекстСообщения = НСтр("ru='Отсутствуют доступные фискальные устройства'");
		СообщитьИнформациюПользователю(ТекстСообщения);
	ИначеЕсли КоличествоККТ = 1 Тогда
		ККТ = МассивККТ[0].Значение;
	Иначе
		ПредставлениеУстройства = "";
		ВидУстройства = "";
		СписокККТ = Новый СписокЗначений;
  	Для Каждого ФР из глТорговоеОборудование.млККТ Цикл
		//Если ФР.КассаККМ.Владелец=ОрганизацияШапка Тогда
		СписокККТ.Добавить(ФР, ФР.КассаККМ);
		//КонецЕсли;
	КонецЦикла;


		//Для Каждого Устройство Из МассивККТ Цикл
		//	ПолучитьСерверТО().ПолучитьПредставлениеУстройства(Устройство, ВидУстройства, ПредставлениеУстройства);
		//	СписокККТ.Добавить(Устройство, ПредставлениеУстройства);
		//КонецЦикла;

		ККТ = СписокККТ.ВыбратьЭлемент("Необходимо выбрать фискальное устройство");
		Если ККТ <> Неопределено Тогда
			ККТ = ККТ.Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если ККТ = NULL ИЛИ ККТ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КассовыеСменыКлиент.ОткрытьКассовуюСмену(ККТ);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьКассовуюСмену(Команда)
	
	Если Не КассовыеСменыВызовСервера.ЕстьПравоНаЗакрытиеСмены() Тогда 
		Предупреждение("Нарушение прав доступа");
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ТекущиеДанныеСписка = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанныеСписка <> Неопределено Тогда
		СтатусСмены = ЗначениеРеквизитаОбъекта(ТекущиеДанныеСписка.Ссылка, "Статус");
		Если СтатусСмены = ПредопределенноеЗначение("Перечисление.СтатусыКассовойСмены.Закрыта") Тогда
			СообщитьОбОшибке("Смена уже закрыта.");
			Возврат;
		КонецЕсли;
	Иначе
		СообщитьИнформациюПользователю("Выберите смену, которую нужно закрыть.");
		Возврат;
	КонецЕсли;
	ККТ = ТекущиеДанныеСписка.КассаККМ;
	
	Если ККТ = NULL ИЛИ ККТ = Неопределено ИЛИ ПустаяСтрока(ККТ) Тогда
		Возврат;
	КонецЕсли;

	КассовыеСменыКлиент.ЗакрытьКассовуюСмену(ККТ, ТекущиеДанныеСписка.Ссылка);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборСписка()
	
	Список.Отбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(КомпьютерШапка) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Компьютер");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = КомпьютерШапка;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КассаККМШапка) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("КассаККМ");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = КассаККМШапка;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МодельШапка) Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Модель");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = МодельШапка;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = Период.ДатаНачала;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Дата");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
		ЭлементОтбора.Использование    = Истина;
		ЭлементОтбора.ПравоеЗначение   = Период.ДатаОкончания;
	КонецЕсли;



КонецПроцедуры

&НаКлиенте
Функция ПоддерживаетсяВидТО(Вид) Экспорт

	Результат = Ложь;

	Если Вид = ПредопределенноеЗначение("Перечисление.ВидыТорговогоОборудования.ККТ") Тогда
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции // ПоддерживаетсяВидТО()

//#КонецОбласти
