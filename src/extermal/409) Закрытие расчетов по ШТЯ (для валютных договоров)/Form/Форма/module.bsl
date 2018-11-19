﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	ВыполнитьСозданиеВзаимозачетов();
	
КонецПроцедуры

Функция ПолучитьДолгКлиентаПоРеализации(ДокРеализация)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
		|			&Дата,
		|			ДоговорКонтрагента = &ДоговорКонтрагента
		|				И Сделка = &Сделка) КАК ВзаиморасчетыСКонтрагентамиОстатки";
	
	ТекДата = ТекущаяДата();
	Запрос.УстановитьПараметр("Дата"              , ТекДата);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДокРеализация.ДоговорКонтрагента);
	Запрос.УстановитьПараметр("Сделка"            , ДокРеализация.Сделка);
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ДолгКлиента = Выборка.СуммаВзаиморасчетовОстаток;
	Иначе
		ДолгКлиента = 0;
	КонецЕсли;
	
	Возврат ДолгКлиента;
	
КонецФункции // ПолучитьДолгКлиентаПоРеализации()

// Функция из старой обработки (409), делала Аня Алексеева
Функция получитьСуммуЗатрат(Док)
								//сумма транспортных
				Запрос = Новый Запрос("ВЫБРАТЬ
				|	ПЗ1.Реализация,
				|	СУММА(ПЗ2.ДоставкаНал) КАК ДоставкаНал,
				|	СУММА(ПЗ2.ДоставкаВЦене) КАК ДоставкаВЦене
				|ИЗ
				|	(ВЫБРАТЬ
				|		ЗаданиеНаОтгрузкуЗаказыПокупателей.Ссылка КАК Ссылка,
				|		ЗаданиеНаОтгрузкуЗаказыПокупателей.Реализация КАК Реализация,
				|		ЗаданиеНаОтгрузкуЗаказыПокупателей.Реализация.Сделка КАК ЗАказ
				|	ИЗ
				|		Документ.ЗаданиеНаОтгрузку.ЗаказыПокупателей КАК ЗаданиеНаОтгрузкуЗаказыПокупателей
				|	ГДЕ
				|		ЗаданиеНаОтгрузкуЗаказыПокупателей.Реализация = &Реализация) КАК ПЗ1
				|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ 
				|			ИнформацияПоПроезду.Задание КАК Задание,
				|			ИнформацияПоПроезду.Заказ КАК Заказ,
				|			ИнформацияПоПроезду.ДоставкаНал КАК ДоставкаНал,
				|			ИнформацияПоПроезду.ДоставкаВЦене КАК ДоставкаВЦене
				|		ИЗ
				|			РегистрСведений.ИнформацияПоПроезду КАК ИнформацияПоПроезду) КАК ПЗ2
				|		ПО ПЗ1.Ссылка = ПЗ2.Задание
				|			И ПЗ1.ЗАказ = ПЗ2.Заказ
				|
				|СГРУППИРОВАТЬ ПО
				|	ПЗ1.Реализация");
				Запрос.УстановитьПараметр("Реализация",Док);
				Выб = Запрос.Выполнить().Выбрать();
				
				Если (Выб.Следующий()) Тогда 
					ЗначениеГрязное = ?(ЗначениеЗаполнено(Выб.ДоставкаНал),Выб.ДоставкаНал,0) + ?(ЗначениеЗаполнено(Выб.ДоставкаВЦене),Выб.ДоставкаВЦене,0);
					Если (ЗначениеГрязное<0) Тогда 
						ТР = 0;
					Иначе 
						ТР = ЗначениеГрязное;
					КонецЕсли;
				Иначе 
					ТР = 0;                                 
				КонецЕсли;
				
					N = 0.5;	
					К1 = 1-N/100;
					К2 = 1-(ТР+Док.Сделка.СуммаДопРасходовЭкспорт)/(Док.Товары.Итог("Сумма")*Док.КурсВзаиморасчетов);
				Товары = Док.Товары.Выгрузить();	
				Для каждого стр из Товары Цикл
					стр.Цена =  Окр(Стр.Сумма*Док.КурсВзаиморасчетов/стр.Количество*К1*К2*1.18,0)/118*100;
					стр.Сумма = Стр.Цена*Стр.Количество;	
				конецЦикла;
				
возврат Док.Товары.Итог("Сумма")*Док.КурсВзаиморасчетов -Товары.Итог("Сумма");				
	
КонецФункции

Процедура ПересчитатьПараметрыСтрокиПоКурсу(ТекСтр)
	
	Если НЕ КурсПоступление = 0 Тогда
		ТекСтр.СуммаБезДолиШТЯУЕ   = ТекСтр.СуммаБезДолиШТЯРуб  / КурсПоступление;
		ТекСтр.СуммаДоляШТЯУЕ      = ТекСтр.СуммаДоляШТЯРуб / КурсПоступление;
	Иначе
		ТекСтр.СуммаБезДолиШТЯУЕ   = 0;
		ТекСтр.СуммаДоляШТЯУЕ      = 0;
		Сообщить("Не все параметры удалось вычислить при нулевом курсе");
	КонецЕсли;
//	ТекСтр.ЗатратыПолнУЕ           = ТекСтр.СуммаРеализацииУЕ       - ТекСтр.СуммаБезДолиШТЯУЕ;
	//ТекСтр.СуммаЗатратыКурсРазнУЕ  = ТекСтр.СуммаРеализацииУЕ       - ТекСтр.СуммаБезДолиШТЯУЕ;
	//ТекСтр.СуммаЗатратыКурсРазнРуб = ТекСтр.СуммаЗатратыКурсРазнУЕ  * КурсПоступление;
	//ТекСтр.СуммаКурсоваяРазницаРуб = ТекСтр.СуммаЗатратыКурсРазнРуб - ТекСтр.СуммаДоляШТЯРуб;
	ТекСтр.СуммаКурсоваяРазницаРуб = ТекСтр.СуммаРеализацииУЕ * (КурсПоступление - ТекСтр.КурсПродажи);
	ТекСтр.КурсРазницаУЕ = ТекСтр.СуммаРеализацииУЕ * (КурсПоступление - ТекСтр.КурсПродажи)/КурсПоступление;
 
КонецПроцедуры // ПересчитатьПараметрыСтрокиПоКурсу()

Процедура ПриИзмененииРеализации()
	
	ТекСтр = ЭлементыФормы.ТабРасчеты.ТекущиеДанные;
	
	ТекСтр.КурсПродажи = ТекСтр.Реализация.КурсВзаиморасчетов;
	
	ТекСтр.СуммаДоляШТЯРуб         = получитьСуммуЗатрат(ТекСтр.Реализация);
	ТекСтр.СуммаДоляШТЯУЕ          = ТекСтр.СуммаДоляШТЯРуб / ТекСтр.КурсПродажи;
	ТекСтр.СуммаРеализацииУЕ       = ТекСтр.Реализация.СуммаДокумента;
	ТекСтр.СуммаРеализацииРуб      = ТекСтр.СуммаРеализацииУЕ       * ТекСтр.КурсПродажи; 
	ТекСтр.СуммаБезДолиШТЯРуб      = ТекСтр.СуммаРеализацииРуб      - ТекСтр.СуммаДоляШТЯРуб;
	ТекСтр.ДолгКлиентаУЕ           = ПолучитьДолгКлиентаПоРеализации(ТекСтр.Реализация);
	
	ПересчитатьПараметрыСтрокиПоКурсу(ТекСтр);
	
КонецПроцедуры // ПриИзмененииРеализации()

Процедура ТабРасчетыРеализацияПриИзменении(Элемент)
	
	ПриИзмененииРеализации();
	
КонецПроцедуры

Процедура ПересчитатьСуммаРаспределитьУЕИтог()
	
	Если НЕ КурсПоступление = 0 Тогда
		СуммаРаспределитьУЕИтог = СуммаРаспределитьРубИтог / КурсПоступление;
	Иначе
		СуммаРаспределитьУЕИтог = 0;
	КонецЕсли;
	
КонецПроцедуры // ПересчитатьСуммаРаспределитьУЕИтог()

Процедура СуммаРаспределитьРубИтогПриИзменении(Элемент)
	
	ПересчитатьСуммаРаспределитьУЕИтог();
	
КонецПроцедуры

Процедура КурсПоступлениеПриИзменении(Элемент)
	
	ПересчитатьСуммаРаспределитьУЕИтог();
	
	Для Каждого ТекСтр Из ТабРасчеты Цикл
		ПересчитатьПараметрыСтрокиПоКурсу(ТекСтр);
	КонецЦикла;
	
	ВыполнитьРаспределение();
	
КонецПроцедуры

Процедура ТабРасчетыРеализацияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка= Ложь;
	
	ФормаВыбора = Документы.РеализацияТоваровУслуг.ПолучитьФормуВыбора(,Элемент);
	ФормаВыбора.Отбор.Контрагент.ВидСравнения = ВидСравнения.Равно;
	ФормаВыбора.Отбор.Контрагент.Значение = Контрагент;
	ФормаВыбора.Отбор.Контрагент.Использование = Истина;
	ФормаВыбора.Отбор.ВалютаДокумента.ВидСравнения = ВидСравнения.НеРавно;
	ФормаВыбора.Отбор.ВалютаДокумента.Значение = Константы.ВалютаРегламентированногоУчета.Получить();
	ФормаВыбора.Отбор.ВалютаДокумента.Использование = Истина;
	ФормаВыбора.Открыть();
	
КонецПроцедуры

Процедура ВыполнитьРаспределение()
	
	Если КурсПоступление = 0 Тогда
		Сообщить("Укажите курс поступления");
	КонецЕсли;
	
	ОсталосьРаспределитьУЕ = СуммаРаспределитьУЕИтог;
	
	Для Каждого ТекСтр Из ТабРасчеты Цикл
		
		ТекСтр.ДолгКлиентаУЕ = ПолучитьДолгКлиентаПоРеализации(ТекСтр.Реализация);
		
		СумРаспределитьСейчасУЕ = ОсталосьРаспределитьУЕ;
		
		Если СумРаспределитьСейчасУЕ < ТекСтр.СуммаБезДолиШТЯУЕ Тогда
			Если НЕ ТекСтр.СуммаБезДолиШТЯУЕ = 0 Тогда
				ТекКоэфРаспределения = СумРаспределитьСейчасУЕ / ТекСтр.СуммаБезДолиШТЯУЕ;
			Иначе
				ТекКоэфРаспределения = 0;
				Сообщить("В стр. " + ТекСтр.НомерСтроки + " ""Сум без доли ШТЯ, руб"" нулевая");
			КонецЕсли;
		Иначе
			ТекКоэфРаспределения = 1;
			СумРаспределитьСейчасУЕ = ТекСтр.СуммаБезДолиШТЯУЕ;
		КонецЕсли;
		
		ТекСтр.КоэфРаспред = ТекКоэфРаспределения;
		ТекСтр.ЗатратыЗачетРуб         = ТекКоэфРаспределения * ТекСтр.СуммаДоляШТЯРуб;
		ТекСтр.СуммаЗаТоварЗачетУЕ = СумРаспределитьСейчасУЕ * ТекКоэфРаспределения;
		//ТекСтр.КурсоваяРазницаЗачетРуб = ТекКоэфРаспределения * ТекСтр.СуммаКурсоваяРазницаРуб;
		
		Если НЕ КурсПоступление = 0 Тогда
//			ТекСтр.ЗатратыПолнЗачетУЕ      = ТекКоэфРаспределения * ТекСтр.ЗатратыПолнУЕ;
			ТекСтр.ЗатратыЗачетУЕ          = ТекСтр.ЗатратыЗачетРуб / КурсПоступление;
			ТекСтр.СуммаЗаТоварЗачетУЕ     = СумРаспределитьСейчасУЕ;
			//ТекСтр.КурсоваяРазницаЗачетРуб = (ТекСтр.ЗатратыЗачетУЕ + ТекСтр.СуммаЗаТоварЗачетУЕ) * (КурсПоступление - ТекСтр.КурсПродажи);
			ТекСтр.КурсоваяРазницаЗачетРуб = ТекКоэфРаспределения * ТекСтр.СуммаКурсоваяРазницаРуб;
			ТекСтр.КурсоваяРазницаЗачетУЕ  = ТекСтр.КурсоваяРазницаЗачетРуб / КурсПоступление; 
			
			// Ошибка округления
			Дельта = ТекСтр.ЗатратыПолнЗачетУЕ + ТекСтр.СуммаЗаТоварЗачетУЕ - ТекСтр.ДолгКлиентаУЕ;
			Если Sqrt(Дельта * Дельта) < 0.5 Тогда
				ТекСтр.СуммаЗаТоварЗачетУЕ = ТекСтр.СуммаЗаТоварЗачетУЕ - Дельта;
			КонецЕсли;
			
		Иначе
			ТекСтр.ЗатратыЗачетУЕ          = 0;
			ТекСтр.СуммаЗаТоварЗачетУЕ     = 0;
			ТекСтр.КурсоваяРазницаЗачетРуб = 0;
			ТекСтр.КурсоваяРазницаЗачетУЕ  = 0;
			ТекСтр.ЗатратыПолнЗачетУЕ      = 0;
		КонецЕсли;
		
		ТекСумПойдетВЗачетКлиенту = ТекСтр.СуммаЗаТоварЗачетУЕ + ТекСтр.ЗатратыПолнЗачетУЕ;
		Если ТекСумПойдетВЗачетКлиенту >= ТекСтр.ДолгКлиентаУЕ + 0.5 Тогда
			ТекСтр.СуммаЗаТоварЗачетУЕ = ТекСтр.ДолгКлиентаУЕ / ТекСумПойдетВЗачетКлиенту * ТекСтр.СуммаЗаТоварЗачетУЕ;
			ТекСтр.ЗатратыПолнЗачетУЕ  = ТекСтр.ДолгКлиентаУЕ - ТекСтр.СуммаЗаТоварЗачетУЕ;
			ТекСтр.КурсоваяРазницаЗачетРуб = (КурсПоступление - ТекСтр.КурсПродажи) * (ТекСтр.СуммаЗаТоварЗачетУЕ + ТекСтр.ЗатратыПолнЗачетУЕ);
		КонецЕсли;
		
		ОсталосьРаспределитьУЕ = ОсталосьРаспределитьУЕ - ТекСтр.СуммаЗаТоварЗачетУЕ;
		
	КонецЦикла;
	
КонецПроцедуры // ВыполнитьРаспределение()

Процедура КоманднаяПанельТабРасчетыРаспределить(Кнопка)
	
	ВыполнитьРаспределение();
	
КонецПроцедуры

Процедура ДобавитьДокВТабВзаимозачетов(ДокСсылка)
	
	НовСтрВзаимозачет = Взаимозачеты.Добавить();
	НовСтрВзаимозачет.Взаимозачет = ДокСсылка;
	
КонецПроцедуры // ДобавитьДокВТабВзаимозачетов()

// 1. с рублей на доллары
// По регистру "ВзаиморасчетыСКонтрагентами" доллары спишутся, рубли оприходуются
Процедура СоздатьВзаимозачетРублиНаДоллары_Документ1(ТекДата, ОрганизацияЛок, КредиторЛок, ДоговорВалютныйНД, ВалютаДолларЛок)
	
	//Перебросили долг с валютного договора на рублевый в пределах контрагента ШТЯ
	
	ДебиторЛок          = КредиторЛок;
	ДоговорДебитораЛок  = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("В0891"); // "Договор НД" - рублевый
	ДоговорКредитораЛок = ДоговорВалютныйНД;
	
	// Шапка
	ДокОбъект = Документы.Взаимозачет.СоздатьДокумент();
	
	ДокОбъект.Дата                         = ТекДата;
	ДокОбъект.Организация                  = ОрганизацияЛок;
	ДокОбъект.КонтрагентКредитор           = КредиторЛок;
	ДокОбъект.КонтрагентДебитор            = ДебиторЛок;
	ДокОбъект.ДоговорКонтрагентаДебитора   = ДоговорДебитораЛок;
	ДокОбъект.ДоговорКонтрагентаКредитора  = ДоговорКредитораЛок;
	ДокОбъект.ОтражатьВУправленческомУчете = Истина;
	ДокОбъект.ВидОперации                  = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженностиВал;
	ДокОбъект.ВалютаДокумента              = ВалютаДолларЛок;
	ДокОбъект.КурсДокумента                = 1;
	ДокОбъект.КратностьДокумента           = 1;
	
	Для Каждого ТекСтрРасчеты Из ТабРасчеты Цикл

	// ТабЧасть
	//долг организации
	// При проведении - это списание
	НовСтрДебет = ДокОбъект.СуммыДолга.Добавить();
	НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
	НовСтрДебет.ДоговорКонтрагента = ДоговорКредитораЛок;  //НД Валютный
	НовСтрДебет.Валюта             = НовСтрДебет.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрДебет.КурсВзаиморасчетов = КурсПоступление;
	НовСтрДебет.Сумма              = СуммаРаспределитьУЕИтог;
	//НовСтрДебет.СуммаУпр           = НовСтрДебет.Сумма * НовСтрДебет.КурсВзаиморасчетов;  // Были расхождения из-за ошибок округления
	НовСтрДебет.СуммаУпр           = СуммаРаспределитьРубИтог;
	
	//Долг контрагента
	//нераспределенные деньги
	// При проведении - это оприходование
	НовСтрКредит = ДокОбъект.СуммыДолга.Добавить();
	НовСтрКредит.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
	НовСтрКредит.ДоговорКонтрагента = ДоговорДебитораЛок; //НД рублевый
	НовСтрКредит.Валюта             = НовСтрКредит.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрКредит.КурсВзаиморасчетов = 1;
	НовСтрКредит.Сумма              = СуммаРаспределитьРубИтог;
	НовСтрКредит.СуммаУпр           = СуммаРаспределитьРубИтог;
	конецЦикла;
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
КонецПроцедуры // СоздатьВзаимозачетРублиНаДоллары_Документ1()

Процедура СоздатьВзаимозачетПоВалютнымДоговорам_Документ2(ТекДата, ОрганизацияЛок, КредиторЛок, ДоговорВалютныйНД, ДоговорВалютныйЗатраты, ДоговорКурсРазн, ВалютаДолларЛок, ЕстьОтрицательныеЗатраты)
	//Зачет между ШТЯ и клиентом
	
	
	// Шапка
	ДокОбъект = Документы.Взаимозачет.СоздатьДокумент();
	
	ДокОбъект.Дата                         = ТекДата;
	ДокОбъект.Организация                  = ОрганизацияЛок;
	ДокОбъект.КонтрагентКредитор           = КредиторЛок;
	ДокОбъект.КонтрагентДебитор            = Контрагент;
	ДокОбъект.ОтражатьВУправленческомУчете = Истина;
	ДокОбъект.ВидОперации                  = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета;
	ДокОбъект.ВалютаДокумента              = ВалютаДолларЛок;
	ДокОбъект.КурсДокумента                = 1;
	ДокОбъект.КратностьДокумента           = 1;
	
	// ТабЧасть
	Для Каждого ТекСтрРасчеты Из ТабРасчеты Цикл
		
		Если ТекСтрРасчеты.СуммаЗаТоварЗачетУЕ > 0 Тогда
			НовСтрДебет = ДокОбъект.СуммыДолга.Добавить();
			НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
			НовСтрДебет.ДоговорКонтрагента = ТекСтрРасчеты.Реализация.ДоговорКонтрагента;   // Там должен быть валютный договор клиента
			НовСтрДебет.Валюта             = НовСтрДебет.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			НовСтрДебет.КурсВзаиморасчетов = КурсПоступление;
			НовСтрДебет.Сделка             = ТекСтрРасчеты.Реализация.Сделка;
			НовСтрДебет.Сумма              = ТекСтрРасчеты.ЗатратыЗачетУЕ  +  ТекСтрРасчеты.СуммаЗаТоварЗачетУЕ + ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ;
			НовСтрДебет.СуммаУпр           = НовСтрДебет.Сумма * КурсПоступление;
		
		
		//нераспределенные деньги 
		
			
			НовСтрКредит1 = ДокОбъект.СуммыДолга.Добавить();
			НовСтрКредит1.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская;
			НовСтрКредит1.ДоговорКонтрагента = ДоговорВалютныйНД;
			НовСтрКредит1.Валюта             = НовСтрКредит1.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			НовСтрКредит1.КурсВзаиморасчетов = КурсПоступление;
			НовСтрКредит1.Сумма          = ТекСтрРасчеты.СуммаЗаТоварЗачетУЕ;
			НовСтрКредит1.СуммаУпр           = НовСтрКредит1.Сумма * КурсПоступление;
			
			Если ТекСтрРасчеты.СуммаЗаТоварЗачетУЕ< ТекСтрРасчеты.СуммаРеализацииУЕ тогда
			ЕстьОтрицательныеРазницы = Истина;	
			НовСтрКредит2 = ДокОбъект.СуммыДолга.Добавить();
			НовСтрКредит2.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская;
			НовСтрКредит2.ДоговорКонтрагента = ДоговорВалютныйЗатраты;
			НовСтрКредит2.Валюта             = НовСтрКредит2.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			НовСтрКредит2.КурсВзаиморасчетов = КурсПоступление;
			НовСтрКредит2.Сумма              = ТекСтрРасчеты.ЗатратыЗачетУЕ + ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ;
			НовСтрКредит2.СуммаУпр           = НовСтрКредит2.Сумма * КурсПоступление;
			конецЕсли;
		конецЕсли;
		
	КонецЦикла;
	
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
КонецПроцедуры // СоздатьВзаимозачетПоВалютнымДоговорам_Документ2()

Процедура СоздатьВзаимозачетПоВалютнымДоговорам_Документ2_5(ТекДата, ОрганизацияЛок, КредиторЛок, ДоговорВалютныйНД, ДоговорВалютныйЗатраты, ВалютаДолларЛок)
	
	// Шапка
	ДокОбъект = Документы.Взаимозачет.СоздатьДокумент();
	
	ДокОбъект.Дата                         = ТекДата;
	ДокОбъект.Организация                  = ОрганизацияЛок;
	ДокОбъект.КонтрагентКредитор           = КредиторЛок;
	ДокОбъект.КонтрагентДебитор            = КредиторЛок;
	ДокОбъект.ОтражатьВУправленческомУчете = Истина;
	ДокОбъект.ВидОперации                  = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженностиВал;
	ДокОбъект.ВалютаДокумента              = ВалютаДолларЛок;
	ДокОбъект.КурсДокумента                = 1;
	ДокОбъект.КратностьДокумента           = 1;
	
	// ТабЧасть
	Для Каждого ТекСтрРасчеты Из ТабРасчеты Цикл
		
			НовСтрДебет1 = ДокОбъект.СуммыДолга.Добавить();
			НовСтрДебет1.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
			НовСтрДебет1.ДоговорКонтрагента = ДоговорВалютныйНД;  
			НовСтрДебет1.Валюта             = НовСтрДебет1.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			НовСтрДебет1.КурсВзаиморасчетов = КурсПоступление;
			НовСтрДебет1.Сумма              = -(ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ-ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ);
			НовСтрДебет1.СуммаУпр           = НовСтрДебет1.Сумма * КурсПоступление;
			
			//нераспределенные деньги 
			
			НовСтрКредит2 = ДокОбъект.СуммыДолга.Добавить();
			НовСтрКредит2.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская;
			НовСтрКредит2.ДоговорКонтрагента = ДоговорВалютныйЗатраты;
			НовСтрКредит2.Валюта             = НовСтрКредит2.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			НовСтрКредит2.КурсВзаиморасчетов = КурсПоступление;
			НовСтрКредит2.Сумма              = -(ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ-ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ);
			НовСтрКредит2.СуммаУпр           = НовСтрКредит2.Сумма * КурсПоступление;
			
		
		
	КонецЦикла;
	
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);	
	
КонецПроцедуры //СоздатьВзаимозачетПоВалютнымДоговорам_Документ2_5()

Процедура СоздатьОдинВзаимозачетПоТаблицам(ДокОбъект, тзДолгФирме, тзДолгКлиенту)
	
	ТабЧасть = ДокОбъект.СуммыДолга;
	ТабЧасть.Загрузить(тзДолгФирме);
	
	Для Каждого ТекСтр Из тзДолгКлиенту Цикл
		НовСтр = ТабЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ТекСтр);
	КонецЦикла;
	
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
КонецПроцедуры // СоздатьОдинВзаимозачетПоТаблицам()

Процедура СоздатьДваВзаимозачетаПоТаблицам(ДокОбъект, тзДанные1, тзДанные2)
	
	ДокОбъект2 = ДокОбъект.Скопировать(); ДокОбъект2.Дата = ДокОбъект.Дата;
	
	НовСтр = ДокОбъект.СуммыДолга.Добавить();
	ЗаполнитьЗначенияСвойств(НовСтр, тзДанные1[0]);

	НовСтр = ДокОбъект.СуммыДолга.Добавить();
	ЗаполнитьЗначенияСвойств(НовСтр, тзДанные2[0], "ВидЗадолженности, ДоговорКонтрагента, Валюта, КурсВзаиморасчетов");
	Если тзДанные1[0].Валюта = тзДанные2[0].Валюта Тогда
		НовСтр.Сумма    = тзДанные1[0].Сумма;
		НовСтр.СуммаУпр = тзДанные1[0].СуммаУпр;
	Иначе
		// Выполнить пересчет по валюте
		НовСтр.Сумма    = тзДанные1[0].Сумма * тзДанные1[0].КурсВзаиморасчетов / НовСтр.КурсВзаиморасчетов;
		НовСтр.СуммаУпр = тзДанные1[0].СуммаУпр;
	КонецЕсли;
	
	НовСтр = ДокОбъект2.СуммыДолга.Добавить();
	//ЗаполнитьЗначенияСвойств(НовСтр, тзДанные1[1]);
	ЗаполнитьЗначенияСвойств(НовСтр, тзДанные1[0], "ВидЗадолженности, ДоговорКонтрагента, Валюта, КурсВзаиморасчетов");
	НовСтр.Сумма    = тзДанные2[0].Сумма;// - тзДанные1[0].Сумма * тзДанные1[0].КурсВзаиморасчетов / НовСтр.КурсВзаиморасчетов;
	НовСтр.СуммаУпр = тзДанные2[0].СуммаУпр;// - тзДанные1[0].СуммаУпр;
	
	НовСтр = ДокОбъект2.СуммыДолга.Добавить();
	ЗаполнитьЗначенияСвойств(НовСтр, тзДанные2[0], "ВидЗадолженности, ДоговорКонтрагента, Валюта, КурсВзаиморасчетов");
	НовСтр.Сумма    = тзДанные2[0].Сумма;// - тзДанные1[0].Сумма * тзДанные1[0].КурсВзаиморасчетов / НовСтр.КурсВзаиморасчетов;
	НовСтр.СуммаУпр = тзДанные2[0].СуммаУпр;// - тзДанные1[0].СуммаУпр;
	
	ДокОбъект.Записать();
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
	ДокОбъект2.Записать();
	ДобавитьДокВТабВзаимозачетов(ДокОбъект2.Ссылка);
	
КонецПроцедуры // СоздатьДваВзаимозачетаПоТаблицам()

Процедура СоздатьВзаимозачетИзДолларовВРубли_Документ3(ТекДата, ОрганизацияЛок, КонтрагентШТЯ, ДоговорРубЗатраты, ДоговорВалютныйЗатраты, ДоговорКурсРазн, ВалютаДолларЛок)
	 //переводим затраты в рубли
	// Шапка
	ДокОбъект = Документы.Взаимозачет.СоздатьДокумент();
	
	ДокОбъект.Дата                         = ТекДата;
	ДокОбъект.Организация                  = ОрганизацияЛок;
	ДокОбъект.КонтрагентКредитор           = КонтрагентШТЯ;
	ДокОбъект.КонтрагентДебитор            = КонтрагентШТЯ;
	ДокОбъект.ДоговорКонтрагентаКредитора  = ДоговорРубЗатраты;
	ДокОбъект.ДоговорКонтрагентаДебитора   = ДоговорВалютныйЗатраты;
	ДокОбъект.ОтражатьВУправленческомУчете = Истина;
	ДокОбъект.ВидОперации                  = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженностиВал;
	ДокОбъект.ВалютаДокумента              = ВалютаДолларЛок;
	ДокОбъект.КурсДокумента                = 1;
	ДокОбъект.КратностьДокумента           = 1;
	
	Для Каждого ТекСтрРасчеты Из ТабРасчеты Цикл
	
	НовСтрДебет = ДокОбъект.СуммыДолга.Добавить();
	НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
	НовСтрДебет.ДоговорКонтрагента = ДоговорВалютныйЗатраты;  
	НовСтрДебет.Валюта             = НовСтрДебет.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрДебет.КурсВзаиморасчетов = КурсПоступление;
	НовСтрДебет.Сумма              = ТекСтрРасчеты.ЗатратыЗачетУЕ+ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ;
	НовСтрДебет.СуммаУпр           = НовСтрДебет.Сумма*КурсПоступление;
	
	НовСтрКредит = ДокОбъект.СуммыДолга.Добавить();
	НовСтрКредит.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
	НовСтрКредит.ДоговорКонтрагента =  ДоговорРубЗатраты; //НД рублевый
	НовСтрКредит.Валюта             = НовСтрКредит.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрКредит.КурсВзаиморасчетов = 1;
	НовСтрКредит.Сумма              = (ТекСтрРасчеты.ЗатратыЗачетУЕ+ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ)*КурсПоступление;
	НовСтрКредит.СуммаУпр           = НовСтрКредит.Сумма;
	
	
	Если (ТекСтрРасчеты.ЗатратыЗачетУЕ+ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ)<0 тогда
	НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
	НовСтрДебет.Сумма              = -(ТекСтрРасчеты.ЗатратыЗачетУЕ+ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ);
	НовСтрДебет.СуммаУпр           = НовСтрДебет.Сумма*КурсПоступление;
	
	НовСтрКредит.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
	НовСтрКредит.Сумма              = -(ТекСтрРасчеты.ЗатратыЗачетУЕ+ТекСтрРасчеты.КурсоваяРазницаЗачетУЕ)*КурсПоступление;
	НовСтрКредит.СуммаУпр           = НовСтрКредит.Сумма;
	
	конецЕсли;
	
	конецЦикла;
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
	//снимаем курсовые разницы
	
	// Шапка
	ДокОбъект = Документы.Взаимозачет.СоздатьДокумент();
	
	ДокОбъект.Дата                         = ТекДата;
	ДокОбъект.Организация                  = ОрганизацияЛок;
	ДокОбъект.КонтрагентКредитор           = КонтрагентШТЯ;
	ДокОбъект.КонтрагентДебитор            = КонтрагентШТЯ;
	ДокОбъект.ДоговорКонтрагентаКредитора  = ДоговорРубЗатраты;
	ДокОбъект.ДоговорКонтрагентаДебитора   = ДоговорКурсРазн;
	ДокОбъект.ОтражатьВУправленческомУчете = Истина;
	ДокОбъект.ВидОперации                  = Перечисления.ВидыОперацийКорректировкаДолга.ПроведениеВзаимозачета;
	ДокОбъект.ВалютаДокумента              = константы.ВалютаРегламентированногоУчета.Получить();
	ДокОбъект.КурсДокумента                = 1;
	ДокОбъект.КратностьДокумента           = 1;
	
	Для Каждого ТекСтрРасчеты Из ТабРасчеты Цикл
	
	НовСтрДебет = ДокОбъект.СуммыДолга.Добавить();
	НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
	НовСтрДебет.ДоговорКонтрагента = ДоговорКурсРазн;  
	НовСтрДебет.Валюта             = НовСтрДебет.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрДебет.КурсВзаиморасчетов = КурсПоступление;
	НовСтрДебет.Сумма              = ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	НовСтрДебет.СуммаУпр           = ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	
	НовСтрКредит = ДокОбъект.СуммыДолга.Добавить();
	НовСтрКредит.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
	НовСтрКредит.ДоговорКонтрагента = ДоговорРубЗатраты; 
	НовСтрКредит.Валюта             = НовСтрКредит.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НовСтрКредит.КурсВзаиморасчетов = 1;
	НовСтрКредит.Сумма              = ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	НовСтрКредит.СуммаУпр           = ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	
	
	Если ТекСтрРасчеты.КурсоваяРазницаЗачетРуб< 0 тогда
	НовСтрДебет.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Дебиторская;
	НовСтрКредит.ВидЗадолженности   = Перечисления.ВидыЗадолженности.Кредиторская;
	НовСтрДебет.Сумма              = -ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	НовСтрДебет.СуммаУпр           = -ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
   	НовСтрКредит.Сумма              = -ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;
	НовСтрКредит.СуммаУпр           = -ТекСтрРасчеты.КурсоваяРазницаЗачетРуб;

	конецЕсли;
	
	конецЦикла;
	ДокОбъект.Записать();
	
	ДобавитьДокВТабВзаимозачетов(ДокОбъект.Ссылка);
	
	
	
	
	
	
	
	
	
	
КонецПроцедуры // СоздатьВзаимозачетИзДолларовВРубли_Документ3()

Процедура ВыполнитьСозданиеВзаимозачетов()
	
	ТекДата                 = ТекущаяДата();
	ОрганизацияЛок          = Справочники.Организации.НайтиПоКоду("00001");
	КонтрагентШТЯ           = Справочники.Контрагенты.НайтиПоКоду("П001125");         // "ШинТрейд Ярославль (Контаер)"
	ВалютаДолларЛок         = Справочники.Валюты.НайтиПоНаименованию("USD");
	ДоговорВалютныйНД       = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("Г1535");  // "Договор НД $" - валютный
	ДоговорВалютныйЗатраты  = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("Г1536"); // "Договор затрат (тр.расходы) $"
	ДоговорРубЗатраты       = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("В1077"); // "Договор затрат (тр.расходы)"
	ДоговорКурсРазн         = Справочники.ДоговорыКонтрагентов.НайтиПоКоду("Д3339"); // "Курсовые разницы"
	
	// 1. с рублей на доллары
	// По регистру "ВзаиморасчетыСКонтрагентами" доллары спишутся, рубли оприходуются
	СоздатьВзаимозачетРублиНаДоллары_Документ1(ТекДата, ОрганизацияЛок, КонтрагентШТЯ, ДоговорВалютныйНД, ВалютаДолларЛок);
	
	// 2 с контрагентом по валютным договорам.
	ЕстьОтрицательныеЗатраты = Ложь;
	СоздатьВзаимозачетПоВалютнымДоговорам_Документ2(ТекДата, ОрганизацияЛок, КонтрагентШТЯ, ДоговорВалютныйНД, ДоговорВалютныйЗатраты, ДоговорКурсРазн, ВалютаДолларЛок, ЕстьОтрицательныеЗатраты);
	
	// 2.5 Подгонка сумм, если встречаются отрицательные затраты
	Если ЕстьОтрицательныеЗатраты Тогда
		СоздатьВзаимозачетПоВалютнымДоговорам_Документ2_5(ТекДата, ОрганизацияЛок, КонтрагентШТЯ, ДоговорВалютныйНД, ДоговорВалютныйЗатраты, ВалютаДолларЛок);
	КонецЕсли;

	// 3  затраты из долларов в рубли
	СоздатьВзаимозачетИзДолларовВРубли_Документ3(ТекДата, ОрганизацияЛок, КонтрагентШТЯ, ДоговорРубЗатраты, ДоговорВалютныйЗатраты, ДоговорКурсРазн, ВалютаДолларЛок);
	
КонецПроцедуры // ВыполнитьСозданиеВзаимозачетов()

Процедура КоманднаяПанельВзаимозачетыВзаимозачетыОчистить(Кнопка)
	
	Взаимозачеты.Очистить();
	
КонецПроцедуры

Процедура ВзаимозачетыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ОформлениеСтроки.Ячейки.Проведен.ОтображатьТекст = Истина;
	ОформлениеСтроки.Ячейки.Проведен.Текст = ДанныеСтроки.Взаимозачет.Проведен;
	
КонецПроцедуры
