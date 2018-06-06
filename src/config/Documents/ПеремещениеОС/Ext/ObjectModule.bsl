﻿Перем мУдалятьДвижения;


// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми

Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)
Перем мСтрокаРеквизитыНалУчета Экспорт; // (Регл)

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой ОС-2,
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьОС2(ПечатьПоДаннымУпрУчета = Истина)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если ПечатьПоДаннымУпрУчета тогда
		НазваниеСтоимости	= "Стоимость";	
		ВалютаПечати 		= Константы.ВалютаУправленческогоУчета.Получить();
		СтрокиСдатчикПолучатель = "		ПеремещениеОС.Подразделение КАК ПодрПолучатель,";
		СтрокиСтоимость		= "		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОС.Остатки(&Дата) КАК СтоимостьОС
							  |		ПО ПеремещениеОСОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство";


	Иначе
		НазваниеСтоимости	= "СтоимостьБУ";	
		ВалютаПечати		= Константы.ВалютаРегламентированногоУчета.Получить();
		СтрокиСдатчикПолучатель = "		ПеремещениеОС.Организация	КАК Организация,
								  |		ПеремещениеОС.Организация.КодПоОКПО		  КАК КодПоОКПО,
								  |		ПеремещениеОС.ПодразделениеОрганизации КАК ПодрПолучатель,";
		СтрокиСтоимость		= "			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОСБухгалтерскийУчет.Остатки(&Дата) КАК СтоимостьОС
							  |		ПО ПеремещениеОСОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство";
									
	КонецЕсли;	
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ПеремещениеОС.Дата          КАК ДатаДок,
	|	ПеремещениеОС.Номер         КАК НомерДок,
	|	ПеремещениеОС.Ответственный,"
	+СтрокиСдатчикПолучатель +"
	|	ПеремещениеОС.Дата          КАК ДатаПередачи
	|ИЗ
	|	Документ.ПеремещениеОС КАК ПеремещениеОС
	|ГДЕ
	|	Ссылка = &Ссылка";
	ВыборкаОС = Запрос.Выполнить().Выбрать();
	ВыборкаОС.Следующий();
	
	Если Не ПечатьПоДаннымУпрУчета тогда	
		СведенияОРуководителеГлавбухе = ПолучитьСведенияОРуководителеГлавБухе(ВыборкаОС.Организация,ВыборкаОС.ДатаДок);
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка",    Ссылка);
	Запрос.УстановитьПараметр("Дата",ВыборкаОС.ДатаДок);
	
	Если ПечатьПоДаннымУпрУчета Тогда
		Запрос.Текст = "ВЫБРАТЬ
		               |	ПеремещениеОСОС.НомерСтроки КАК НС,
		               |	ПеремещениеОСОС.ОсновноеСредство,
		               |	ПеремещениеОСОС.ОсновноеСредство.Код КАК ИнвНомерУпр,
		               |	ПеремещениеОСОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
		               |	ПеремещениеОСОС.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
		               |	СтоимостьОС.СтоимостьОстаток КАК СуммаПеремещения,
		               |	МестонахождениеОССрезПоследних.Местонахождение.Представление КАК ПодрСдатчик
		               |ИЗ
		               |	Документ.ПеремещениеОС.ОС КАК ПеремещениеОСОС
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОС.Остатки(&Дата, ) КАК СтоимостьОС
		               |		ПО ПеремещениеОСОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство
		               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(&Дата, Регистратор <> &Ссылка) КАК МестонахождениеОССрезПоследних
		               |		ПО МестонахождениеОССрезПоследних.ОсновноеСредство = ПеремещениеОСОС.ОсновноеСредство
		               |ГДЕ
		               |	ПеремещениеОСОС.Ссылка = &Ссылка";
	Иначе

		Запрос.Текст =	"ВЫБРАТЬ
		              	|	ПеремещениеОСОС.НомерСтроки КАК НС,
		              	|	ПеремещениеОСОС.ОсновноеСредство,
		              	|	ПеремещениеОСОС.ОсновноеСредство.Код КАК ИнвНомерУпр,
		              	|	ПеремещениеОСОС.ОсновноеСредство.НаименованиеПолное КАК НаименованиеОС,
		              	|	ПеремещениеОСОС.ОсновноеСредство.ДатаВыпуска КАК ГодВыпуска,
		              	|	СтоимостьОС.СтоимостьОстаток КАК СуммаПеремещения,
		              	|	МестонахождениеОССрезПоследних.Местонахождение.Представление КАК ПодрСдатчик
		              	|ИЗ
		              	|	Документ.ПеремещениеОС.ОС КАК ПеремещениеОСОС
		              	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОСБухгалтерскийУчет.Остатки(&Дата, ) КАК СтоимостьОС
		              	|		ПО ПеремещениеОСОС.ОсновноеСредство = СтоимостьОС.ОсновноеСредство
		              	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&Дата, Регистратор <> &Ссылка) КАК МестонахождениеОССрезПоследних
		              	|		ПО МестонахождениеОССрезПоследних.ОсновноеСредство = ПеремещениеОСОС.ОсновноеСредство
		              	|ГДЕ
		              	|	ПеремещениеОСОС.Ссылка = &Ссылка";
	КонецЕсли;
	
	ТаблицаПоОС = Запрос.Выполнить().Выгрузить();

	ДокВвода  = Неопределено;
	ДатаВвода = Дата('00000000');
	
	ТабДокумент   = Новый ТабличныйДокумент();
	Макет         = ПолучитьМакет("ОС2");
	ОбластьШапка1 = Макет.ПолучитьОбласть("Шапка1");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапка2 = Макет.ПолучитьОбласть("Шапка2");

	ОбластьШапка1.Параметры.Заполнить(ВыборкаОС);
	ОбластьШапка1.Параметры.Валюта = ВалютаПечати;

	ПодрСдатчик = ТаблицаПоОС.ВыгрузитьКолонку("ПодрСдатчик");
	СтрокаПодрСдатчик = "";
	
	Для Счетчик = 0 по ПодрСдатчик.Количество()-1 Цикл
		СтрокаПодрСдатчик = СтрокаПодрСдатчик + ПодрСдатчик[Счетчик];
		Если Счетчик < ПодрСдатчик.Количество()-1 Тогда
			СтрокаПодрСдатчик = СтрокаПодрСдатчик + ", ";
		КонецЕсли; 
	КонецЦикла;
	
	ОбластьШапка1.Параметры.ПодрСдатчик = СтрокаПодрСдатчик;
	
	ТабДокумент.Вывести(ОбластьШапка1);

	ИтогСумма = 0;
	Для Каждого ВыборкаПоОС из ТаблицаПоОС Цикл
		Если ВыборкаПоОС.НС>1 тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();	
			ТабДокумент.Вывести(ОбластьШапка2);
		КонецЕсли;
		ОбластьСтрока.Параметры.Заполнить(ВыборкаПоОС);
		
		Если ПечатьПоДаннымУпрУчета тогда
			ОбластьСтрока.Параметры.ИнвНомер = ВыборкаПоОС.ИнвНомерУпр;
		Иначе
			ВыборкаЗаписей = РегистрыСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.ПолучитьПоследнее(ВыборкаОС.ДатаДок,
														Новый Структура("ОсновноеСредство",ВыборкаПоОС.ОсновноеСредство));
			ИнвНомерБух	   = ?(ВыборкаЗаписей.Количество() > 0,ВыборкаЗаписей.ИнвентарныйНомер,0);
			ОбластьСтрока.Параметры.ИнвНомер = ИнвНомерБух;
		КонецЕсли;
		
		
		Если ПустаяСтрока(ВыборкаПоОС.НаименованиеОС) Тогда
			ОбластьСтрока.Параметры.НаименованиеОС = СокрЛП(ВыборкаПоОС.ОсновноеСредство);
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьСтрока);
		ИтогСумма = ИтогСумма + ?(ВыборкаПоОС.СуммаПеремещения<>Null,ВыборкаПоОС.СуммаПеремещения,0);
	КонецЦикла;


	ОбластьПодвал.Параметры.ИтогСумма = ИтогСумма;
	
	Если Не ПечатьПоДаннымУпрУчета тогда
		ОбластьПодвал.Параметры.Заполнить(СведенияОРуководителеГлавбухе);
	КонецЕсли;

	ТабДокумент.Вывести(ОбластьПодвал);
	// Зададим параметры макета
	ТабДокумент.ПолеСверху         = 0;
	ТабДокумент.ПолеСлева          = 0;
	ТабДокумент.ПолеСнизу          = 0;
	ТабДокумент.ПолеСправа         = 0;
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Возврат ТабДокумент;
	
КонецФункции // ПечатьОС2()

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

	//Если ЭтоНовый() Тогда
	//	Предупреждение("Документ можно распечатать только после его записи");
	//	Возврат;
	//ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
	//	Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
	//	Возврат;
	//КонецЕсли; 

	//Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
	//	Возврат;
	//КонецЕсли;

	//// Получить экземпляр документа на печать
	//Если ИмяМакета = "ОС2упр" тогда
	//	ТабДокумент = ПечатьОС2();
	//ИначеЕсли ИмяМакета = "ОС2бух" тогда
	//	ТабДокумент = ПечатьОС2(Ложь);
	//ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

	//	ТабДокумент = НапечататьВнешнююФорму(Ссылка, ИмяМакета);
	//	
	//	Если ТабДокумент = Неопределено Тогда
	//		Возврат
	//	КонецЕсли;
	//
	//КонецЕсли;

	//НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;

	Если  ОтражатьВУправленческомУчете тогда 
		СтруктураМакетов.Вставить("ОС2упр", "Форма ОС-2(упр. учет)");
	КонецЕсли;
	Если  ОтражатьВБухгалтерскомУчете тогда 
		СтруктураМакетов.Вставить("ОС2бух", "Форма ОС-2(бух. учет)");
	КонецЕсли;
	
	Возврат СтруктураМакетов;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли


// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для определенного вида учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета() Экспорт

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр();
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл();

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для управленческого учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

	мСтрокаРеквизитыУпрУчета =  "МОЛ,
								|Подразделение,
								|Событие";

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для регламентированного учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()


	мСтрокаРеквизитыБухУчета =  "ПодразделениеОрганизации,
								|МОЛОрганизации,
								|СобытиеРегл";
	мСтрокаРеквизитыНалУчета = "";

КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Дополняет список обязательных параметров шапки
// упр. параметрами
Процедура ДополнитьОбязательныеРеквизитыШапкиУпр(Реквизиты)
	
	Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты), "", ", ") + "Событие";

КонецПроцедуры

// Дополняет список обязательных параметров шапки
// регл. параметрами
Процедура ДополнитьОбязательныеРеквизитыШапкиРегл(Реквизиты)
	
	Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты), "", ", ") + "СобытиеРегл";

КонецПроцедуры

// Проверяет правильность заполнения упр. реквизитов шапки
Процедура ПроверитьЗаполнениеШапкиУпр(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.Событие.Представление();
	ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.Событие.ВидСобытияОС,
							  Перечисления.ВидыСобытийОС.ВнутреннееПеремещение,
							  ПредставлениеРеквизита,Отказ);

КонецПроцедуры

// Проверяет правильность заполнения регл. реквизитов шапки
Процедура ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок)
	
	Если (НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете) Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеНеЗаполнено(СтруктураШапкиДокумента.Организация) Тогда
		ОшибкаПриПроведении("Не заполнено поле Организация", Отказ,Заголовок);
	Иначе
		Если НЕ ЗначениеНеЗаполнено(СтруктураШапкиДокумента.ПодразделениеОрганизации) 
			И НЕ ЗначениеНеЗаполнено(СтруктураШапкиДокумента.Организация) 
			И СтруктураШапкиДокумента.ПодразделениеОрганизации.Владелец <> СтруктураШапкиДокумента.Организация Тогда
			ОшибкаПриПроведении("Выбранное подразделение организации не соответствует указанной организации", Отказ,Заголовок);
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеРеквизита = ЭтотОбъект.Метаданные().Реквизиты.СобытиеРегл.Представление();
	ПроверкаЗаполненияСобытий(СтруктураШапкиДокумента.СобытиеРегл.ВидСобытияОС,
							  Перечисления.ВидыСобытийОС.ВнутреннееПеремещение,
							  ПредставлениеРеквизита,Отказ);

КонецПроцедуры

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "";
	ДополнитьОбязательныеРеквизитыШапкиУпр(ОбязательныеРеквизитыШапки);
	//ДополнитьОбязательныеРеквизитыШапкиРегл(ОбязательныеРеквизитыШапки);
	
	//НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, ОбязательныеРеквизитыШапки, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, мСтрокаРеквизитыНалУчета);
	
	СтруктураОбязательныхПолей = 
	Новый Структура(ОбязательныеРеквизитыШапки);

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	//ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Теперь вызовем общую процедуру проверки.
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	ПроверитьЗаполнениеШапкиУпр(СтруктураШапкиДокумента, Отказ, Заголовок);
	//ПроверитьЗаполнениеШапкиРегл(СтруктураШапкиДокумента, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Дополняет список обязательных параметров табл. части
// упр. параметрами
Процедура ДополнитьОбязательныеРеквизитыТабОСУпр(Реквизиты)

	//Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты), "", ", ") + "";

КонецПроцедуры

// Дополняет список обязательных параметров табл. части
// регл. параметрами
Процедура ДополнитьОбязательныеРеквизитыТабОСРегл(Реквизиты)

	//Реквизиты = Реквизиты + ?(ПустаяСтрока(Реквизиты), "", ", ") + "";

КонецПроцедуры

// Проверка реквизитов в ТЧ по упр. учету
// 
Процедура ПроверкаРеквизитовТЧУпр(ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок)
	
КонецПроцедуры

// Проверка реквизитов в ТЧ по регл. учету
// 
Процедура ПроверкаРеквизитовТЧРегл(ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок)
	
	// Проверим соответствие организайий ОС и организации документа
	
	//Запрос = Новый Запрос;
	//
	//Запрос.УстановитьПараметр("СписокОС"      , ТаблицаОС.ВыгрузитьКолонку("ОсновноеСредство"));
	//Запрос.УстановитьПараметр("ВыбОрганизация", СтруктураШапкиДокумента.Организация);
	//Запрос.УстановитьПараметр("ДатаСреза"     , СтруктураШапкиДокумента.Дата);
	//
	//Запрос.Текст = "
	//|ВЫБРАТЬ
	//|	МестонахождениеОсновныхСредствОрганизацийСрезПоследних.Организация КАК Организация,
	//|	ОсновныеСредства.Код                                               КАК Инв,
	//|	ОсновныеСредства.Ссылка                                            КАК ОсновноеСредство,
	//|	Представление(ОсновныеСредства.Ссылка)                             КАК ОсновноеСредствоПредставление
	//|ИЗ
	//|	Справочник.ОсновныеСредства КАК ОсновныеСредства
	//|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(&ДатаСреза, (ОсновноеСредство В(&СписокОС) И Организация = &ВыбОрганизация)) КАК МестонахождениеОсновныхСредствОрганизацийСрезПоследних
	//|	ПО ОсновныеСредства.Ссылка = МестонахождениеОсновныхСредствОрганизацийСрезПоследних.ОсновноеСредство
	//|
	//|ГДЕ
	//|	ОсновныеСредства.Ссылка В(&СписокОС)
	//|	И
	//|	НЕ ОсновныеСредства.ЭтоГруппа
	//|	И
	//|	МестонахождениеОсновныхСредствОрганизацийСрезПоследних.Организация ЕСТЬ NULL
	//|";
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Выборка.Количество() > 0 Тогда
	//	Отказ = Истина;
	//	Пока Выборка.Следующий() Цикл
	//		СообщитьОбОшибке(("Бух.учет: Несоответствие организаций ОС """ + СокрЛП(Выборка.ОсновноеСредствоПредставление) + """ инв.№ " + СокрЛП(Выборка.Инв) + " и организации указанной в документе."),, Заголовок);
	//	КонецЦикла; 
	//КонецЕсли; 
	
КонецПроцедуры

// Процедура проверяет правильность заполнения реквизитов документа
//
Процедура ПроверкаРеквизитовТЧ(РежимПроведения,ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок) Экспорт

	РеквизитыТабОС = "ОсновноеСредство"; //через запятую
	ДополнитьОбязательныеРеквизитыТабОСУпр(РеквизитыТабОС);
	ДополнитьОбязательныеРеквизитыТабОСРегл(РеквизитыТабОС);
	//НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, РеквизитыТабОС, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, мСтрокаРеквизитыНалУчета, "ОС");
	ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ОС", Новый Структура(РеквизитыТабОС), Отказ, Заголовок);
	
	// Логические проверки
	Если ОтражатьВУправленческомУчете Тогда
		ПроверкаРеквизитовТЧУпр(ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок);
	КонецЕсли; 
	Если ОтражатьВБухгалтерскомУчете Тогда
		ПроверкаРеквизитовТЧРегл(ТаблицаОС,СтруктураШапкиДокумента,Отказ, Заголовок);
	КонецЕсли; 
	
	Если РежимПроведения = РежимПроведенияДокумента.Оперативный Тогда
		// Проверим возможность изменения состояния ОС
		Для каждого СтрокаОС из ОС Цикл
			Если ОтражатьВБухгалтерскомУчете тогда
				ПроверитьВозможностьИзмененияСостоянияОС(СтрокаОС.ОсновноеСредство,Дата,СобытиеРегл,Отказ,Организация);
			КонецЕсли;
			Если ОтражатьВУправленческомУчете тогда
				ПроверитьВозможностьИзмененияСостоянияОС(СтрокаОС.ОсновноеСредство,Дата,Событие,Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 

КонецПроцедуры // ПроверкаРеквизитов()


// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС,Отказ, Заголовок)
	ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок);
КонецПроцедуры // ДвиженияПоРегистрам

Процедура ДвиженияПоРегистрамУпр(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок)
	Если НЕ СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		Возврат;
	КонецЕсли;
	ДатаДока = Дата;

	МестонахождениеОС = Движения.МестонахождениеОС;
	СобытиеОС	      = Движения.СобытияОС;

	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
		
		Движение = МестонахождениеОС.Добавить();
		
		Движение.Период           = ДатаДока;
		Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		Движение.МОЛ              = СтруктураШапкиДокумента.МОЛ;
		Движение.Местонахождение  = СтруктураШапкиДокумента.Подразделение;
		
		Движение = СобытиеОС.Добавить();
		Движение.Период            = ДатаДока;
		Движение.ОсновноеСредство  = СтрокаТЧ.ОсновноеСредство;
		Движение.Событие           = СтруктураШапкиДокумента.Событие;
		Движение.НазваниеДокумента = Метаданные().Представление();
		Движение.НомерДокумента    = Номер;
		
	КонецЦикла;

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаПоОС, Отказ, Заголовок)
	
	Если НЕ СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;
	ДатаДока = Дата;
	
	СобытиеОСБух             	 = Движения.СобытияОСОрганизаций;
	МестонахождениеОСОрганизаций = Движения.МестонахождениеОСБухгалтерскийУчет;
	
	Для каждого СтрокаТЧ Из ТаблицаПоОС Цикл
		
		Движение = МестонахождениеОСОрганизаций.Добавить();
	
		Движение.Период           = ДатаДока;
		Движение.ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
		Движение.Организация      = СтруктураШапкиДокумента.Организация;
		Движение.МОЛ              = СтруктураШапкиДокумента.МОЛОрганизации;
		Движение.Местонахождение  = СтруктураШапкиДокумента.ПодразделениеОрганизации;
		
		Движение = СобытиеОСБух.Добавить();
		
		Движение.Период                   = ДатаДока;
		Движение.ОсновноеСредство         = СтрокаТЧ.ОсновноеСредство;
		Движение.Организация         	  = СтруктураШапкиДокумента.Организация;
		Движение.Событие                  = СтруктураШапкиДокумента.Событие;
		Движение.НазваниеДокумента 		  = Метаданные().Представление();
		Движение.НомерДокумента    		  = Номер;
		
	КонецЦикла;
	
КонецПроцедуры
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ,РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета();

	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ОсновноеСредство", "ОсновноеСредство");

	РезультатЗапросаПоОС = СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ОС", СтруктураПолей);
	ТаблицаПоОС          = РезультатЗапросаПоОС.Выгрузить();
	
	ПроверкаРеквизитовТЧ(РежимПроведения,ТаблицаПоОС, СтруктураШапкиДокумента,Отказ, Заголовок);

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаПоОС,Отказ, Заголовок);
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

Процедура ПриЗаписи(Отказ)
	//РегистрацияОбъектовДоступаДокумента(Ссылка, Новый Структура("Организация",
	//														Организация));
КонецПроцедуры



