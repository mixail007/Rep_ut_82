﻿// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

// Формирует структуру полей, обязательных для заполнения при отражении движения средств.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолей()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Касса");
	СтруктураПолей.Вставить("КассаПолучатель");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("Ответственный");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует движения по регистрам
// СтруктураКурсыВалют - структура, содержащая курсы необходимых для расчетов валют.
//
Процедура ДвиженияПоРегистрам(СтруктураКурсыВалют)
	
	СуммаУпр = ПересчитатьИзВалютыВВалюту(СуммаДокумента, СтруктураКурсыВалют.ВалютаДокумента,
			СтруктураКурсыВалют.ВалютаУпрУчета, 
			СтруктураКурсыВалют.ВалютаДокументаКурс,
			СтруктураКурсыВалют.ВалютаУпрУчетаКурс, 
			СтруктураКурсыВалют.ВалютаДокументаКратность,
			СтруктураКурсыВалют.ВалютаУпрУчетаКратность);
			
	// По регистру "Денежные средства к получению"
	НаборДвижений = Движения.ДенежныеСредстваКПолучению;
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.СуммаУпр            = СуммаУпр;
	СтрокаДвижений.ДокументПолучения   = Ссылка;
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Движения.ДенежныеСредстваКПолучению.ВыполнитьПриход();
	
	// По регистру "Денежные средства к списанию"
	НаборДвижений = Движения.ДенежныеСредстваКСписанию;
	ТаблицаДвижений = НаборДвижений.Выгрузить();

	СтрокаДвижений = ТаблицаДвижений.Добавить();
	СтрокаДвижений.БанковскийСчетКасса = Касса;
	СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
	СтрокаДвижений.Сумма               = СуммаДокумента;
	СтрокаДвижений.ДокументСписания    = Ссылка;
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Движения.ДенежныеСредстваКСписанию.ВыполнитьПриход();
							
	Если Оплачено Тогда
		
		// По регистру "Денежные средства"
		НаборДвижений = Движения.ДенежныеСредства;	
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Расход;
		СтрокаДвижений.Период              = Дата;
		
		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр    		   = СуммаУпр;
		СтрокаДвижений.Активность		   = Истина;
		СтрокаДвижений.ВидДвижения         = ВидДвиженияНакопления.Приход;
		СтрокаДвижений.Период              = Дата;

		Движения.ДенежныеСредства.мТаблицаДвижений=ТаблицаДвижений;
		Движения.ДенежныеСредства.ВыполнитьДвижения();
		
		// По регистру "Денежные средства к получению"
		НаборДвижений = Движения.ДенежныеСредстваКПолучению;
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = КассаПолучатель;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
		СтрокаДвижений.СуммаУпр            = СуммаУпр;
        СтрокаДвижений.ДокументПолучения   = Ссылка;
		
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Движения.ДенежныеСредстваКПолучению.ВыполнитьРасход();
		
		// По регистру "Денежные средства к списанию"
		НаборДвижений = Движения.ДенежныеСредстваКСписанию;
		ТаблицаДвижений = НаборДвижений.Выгрузить();
		ТаблицаДвижений.Очистить();

		СтрокаДвижений = ТаблицаДвижений.Добавить();
		СтрокаДвижений.БанковскийСчетКасса = Касса;
		СтрокаДвижений.ВидДенежныхСредств  = Перечисления.ВидыДенежныхСредств.Наличные;
		СтрокаДвижений.Сумма               = СуммаДокумента;
        СтрокаДвижений.ДокументСписания    = Ссылка;
		
		НаборДвижений.мПериод          = Дата;
		НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

		Движения.ДенежныеСредстваКСписанию.ВыполнитьРасход();
		
	КонецЕсли;
			
КонецПроцедуры// ДвиженияПоРегистрам()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураКурсаДокумента = ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента      = СтруктураКурсаДокумента.Курс;
	КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	
	ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей(), Отказ, Заголовок);
		
	Если НЕ Оплачено И РежимПроведения=РежимПроведенияДокумента.Оперативный Тогда
		
		// Проверяем остаток доступных денежных средств
		СвободныйОстаток = ПолучитьСвободныйОстатокДС(Касса,Дата,);
		
		Если СвободныйОстаток < СуммаДокумента Тогда
			
			Сообщить(Заголовок+"
			|Сумма документа превышает возможный к использованию остаток денежных средств
			|по " + Касса.Наименование + ".
			|Возможный к использованию остаток: " + Формат(СвободныйОстаток,"ЧЦ=15; ЧДЦ=2")+" "+ВалютаДокумента+"
			|Сумма документа = "+Формат(СуммаДокумента,"ЧЦ=15; ЧДЦ=2")+" "+ВалютаДокумента);
			
			Если НЕ ЕстьРазрешениеПревышатьСвободныйОстатокДС() Тогда
				Отказ = Истина;
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		СтруктураГруппаВалют = Новый Структура;
		СтруктураГруппаВалют.Вставить("ВалютаУпрУчета",Константы.ВалютаУправленческогоУчета.Получить().Код);
		СтруктураГруппаВалют.Вставить("ВалютаДокумента",ВалютаДокумента.Код);
		СтруктураКурсыВалют=ПолучитьКурсыДляГруппыВалют(СтруктураГруппаВалют,Дата);
		
		ДвиженияПоРегистрам(СтруктураКурсыВалют);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры
