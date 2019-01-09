﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	//Если ИмяМакета = "Накладная" Тогда
	//		ТабДокумент = ПечатьДокумента();

	//Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

	//	ТабДокумент = НапечататьВнешнююФорму(Ссылка, ИмяМакета);
	//	
	//	Если ТабДокумент = Неопределено Тогда
	//		Возврат
	//	КонецЕсли; 
	//	
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

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект));

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
//       ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА
////////////////////////////////////////////////////////////////////////////////

// Проверяет правильность заполнения строк табличной части "ОС".
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ОсновноеСредство");

	// Теперь вызовем общую процедуру проверки.
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

Процедура ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если (НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете) И (НЕ СтруктураШапкиДокумента.ОтражатьВНалоговомУчете) Тогда
		Возврат;
	КонецЕсли;
	
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей 	= Новый Структура("Организация,СобытиеРегл");
	
	// Теперь вызовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// Проверим чем заполнено событие
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.СобытиеРегл.Представление();
	ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.СобытиеРегл.ВидСобытияОС,
							  Перечисления.ВидыСобытийОС.Прочее,
							  ПредставлениеРеквизита,Отказ);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "СпособОтраженияРасходовПоАмортизации";
	СтруктураОбязательныхПолей = 
	Новый Структура(ОбязательныеРеквизитыШапки);
	
	Если СтруктураШапкиДокумента.ОтражатьВУправленческомУчете тогда
		СтруктураОбязательныхПолей.Вставить("Событие");
	КонецЕсли;
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок, Истина);

	// Теперь вызовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.Событие.Представление();
	ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.Событие.ВидСобытияОС,
								  Перечисления.ВидыСобытийОС.Прочее,
								  ПредставлениеРеквизита,Отказ);

КонецПроцедуры // ПроверитьЗаполнениеШапки()


// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС);
	ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС);
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС);
КонецПроцедуры // ДвиженияПоРегистрам

Процедура ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС)

	Если НЕ СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		Возврат;
	КонецЕсли;

	ДатаДока = Дата;
	НаправленияОС = Движения.СпособыОтраженияРасходовПоАмортизацииОС;
	СобытиеОС     = Движения.СобытияОС;

	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
		
		Движение = НаправленияОС.Добавить();
		Движение.Период           = ДатаДока;
		Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		Движение.СпособыОтраженияРасходовПоАмортизации= СтруктураШапкиДокумента.СпособОтраженияРасходовПоАмортизации;
		
		Движение = СобытиеОС.Добавить();
		Движение.Период            = ДатаДока;
		Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
		Движение.Событие           = СтруктураШапкиДокумента.Событие;
		Движение.НазваниеДокумента = Метаданные().Представление();
		Движение.НомерДокумента    = Номер;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС)

	Если (НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете) И (НЕ СтруктураШапкиДокумента.ОтражатьВНалоговомУчете) Тогда
		Возврат;
	КонецЕсли;

	ДатаДока       = Дата;
	ТекОрганизация = СтруктураШапкиДокумента.Организация;
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		
		НаправленияОС = Движения.СпособыОтраженияРасходовПоАмортизацииОСБухгалтерскийУчет;
		СобытиеОСБух  = Движения.СобытияОСОрганизаций;
		
		Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
			Движение = НаправленияОС.Добавить();
			
			Движение.Период           = ДатаДока;
			Движение.Организация      = ТекОрганизация;
			Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
			Движение.СпособыОтраженияРасходовПоАмортизации= СтруктураШапкиДокумента.СпособОтраженияРасходовПоАмортизации;
			
			Движение = СобытиеОСБух.Добавить();
			
			Движение.Период             = ДатаДока;
			Движение.ОсновноеСредство   = СтрокаТЧ.ОсновноеСредство;
			Движение.Организация        = СтруктураШапкиДокумента.Организация;
			Движение.Событие            = СтруктураШапкиДокумента.СобытиеРегл;
			Движение.НазваниеДокумента 	= Метаданные().Представление();
			Движение.НомерДокумента    	= Номер;

		КонецЦикла;
		
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		
		НаправленияОС = Движения.СпособыОтраженияРасходовПоАмортизацииОСНалоговыйУчет;
		
		Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
			
			Движение = НаправленияОС.Добавить();
			Движение.Период           = ДатаДока;
			Движение.Организация      = ТекОрганизация;
			Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
			Движение.СпособыОтраженияРасходовПоАмортизации= СтруктураШапкиДокумента.СпособОтраженияРасходовПоАмортизации;
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
////////////////////////////////////////////////////////////////////////////////

Процедура ОбработкаПроведения(Отказ)

	
	Если мУдалятьДвижения Тогда
		УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = "";

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство", "ОсновноеСредство");

	РезультатЗапросаПоОС = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();

	ПроверитьЗаполнениеТабличнойЧастиОС(Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
		
	Если НЕ Отказ Тогда
		
		обЗаписатьПротоколИзменений(ЭтотОбъект);
		
	КонецЕсли; 


КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)

	
	УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, ложь);

КонецПроцедуры // ОбработкаУдаленияПроведения

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	//ДобавитьПрефиксУзла(Префикс);
КонецПроцедуры


