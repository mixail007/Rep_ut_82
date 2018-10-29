﻿Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Процедура контролирует объем отгрузки по заказу, с проверкой прав пользователя
//
Процедура КонтрольПревышенияОбъемаЗаказа(ДокОбъект, СтруктураШапкиДокумента, ИмяТЧ, Отказ, Заголовок) Экспорт
	
	Если СтруктураШапкиДокумента.Свойство("Заказ") Тогда
		ДокЗаказ = СтруктураШапкиДокумента.Заказ;
	ИначеЕсли СтруктураШапкиДокумента.Свойство("Сделка") Тогда
		ДокЗаказ = СтруктураШапкиДокумента.Сделка;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ЗначениеНеЗаполнено(ДокЗаказ) Тогда
		Возврат;
	КонецЕсли;
	
	СписокПрав = ПолучитьЗначениеПраваПользователя(
		ПланыВидовХарактеристик.ПраваПользователей.КонтролироватьПревышениеОбъемЗаказаПриОтгрузке,
		Ложь);
		
	НуженКонтроль = Ложь;
	Для Каждого СтрокаПрав Из СписокПрав Цикл
		НуженКонтроль = Макс(НуженКонтроль, СтрокаПрав.Значение);
		Если НуженКонтроль Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НуженКонтроль Тогда
		КонтрольОстатков(ДокОбъект, ИмяТЧ, СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // КонтрольПревышенияОбъемаЗаказа()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщегние.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, Отказ, Заголовок) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	ИмяТаблицы          = ИмяДокумента + "." + СокрЛП(ИмяТабличнойЧасти);
	ЗаказПокупателя     = СтруктураШапкиДокумента.Сделка;
	ЕстьКоэффициент     = ЕстьРеквизитТабЧастиДокумента("Коэффициент", МетаданныеДокумента, ИмяТабличнойЧасти);
	ЕстьХарактеристика  = ЕстьРеквизитТабЧастиДокумента("ХарактеристикаНоменклатуры", МетаданныеДокумента, ИмяТабличнойЧасти);
	
	// Текст вложенного запроса, ограничивающего номенклатуру при получении остатков
	ТекстЗапросаСписокНоменклатуры = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура 
	|ИЗ
	|	Документ." + ИмяТаблицы +"
	|ГДЕ Ссылка = &ДокументСсылка";


	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",          СтруктураШапкиДокумента.Ссылка);
	Запрос.УстановитьПараметр("ЗаказПокупателя",         СтруктураШапкиДокумента.Сделка);
	Если ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартийТоваров.ВозвратнаяТара);
	Иначе
		Запрос.УстановитьПараметр("СтатусПартии", Перечисления.СтатусыПартийТоваров.Купленный);
	КонецЕсли;

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры.Представление           КАК ХарактеристикаНоменклатурыПредставление," , "")
	+ ?(ЕстьКоэффициент, "
	|	СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК ДокументКоличество,", "
	|	СУММА(Док.Количество)                                  КАК ДокументКоличество,") + "
	|	МАКСИМУМ(Остатки.КоличествоОстаток)                    КАК ОстатокКоличество
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(,
	|		Номенклатура В (" + ТекстЗапросаСписокНоменклатуры + ")
	|	И ЗаказПокупателя            = &ЗаказПокупателя
	|   И СтатусПартии = &СтатусПартии
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры", "") + "
	|
	|ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(ЕстьХарактеристика, ",
	|	Док.ХарактеристикаНоменклатуры ", "") + "
	|
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ЗаказыПокупателей.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		КоличествоОстаток = ?(Выборка.ОстатокКоличество = NULL, 0, Выборка.ОстатокКоличество);

		Если КоличествоОстаток < Выборка.ДокументКоличество Тогда

			СтрокаСообщения = "Остатка " + 
			ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
			                          Выборка.ХарактеристикаНоменклатурыПредставление) +
			", заказанного по документу " + (ЗаказПокупателя) + " недостаточно.";

			ОшибкаНетОстатка(СтрокаСообщения, КоличествоОстаток, Выборка.ДокументКоличество,
			Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

Процедура ПередЗаписью(Отказ, Замещение)
// пока отключаем
//		ПроверкаПериодаЗаписей(ЭтотОбъект, Отказ);
// 	 месяц или граница запрета что раньше
       	#Если Клиент тогда
		ПроверкаПериодаЗаписейТолькоЗаказ(ЭтотОбъект, Отказ);
		#КонецЕсли
КонецПроцедуры
	
	
Процедура ПроверкаПериодаЗаписейТолькоЗаказ(ЭтотОбъект, Отказ)	
	
	
	Если ЗначениеНеЗаполнено( ЭтотОбъект.Отбор.Регистратор.Значение) Тогда
		Возврат;
	Иначе
		СсылкаНаОбъектДокумент= ЭтотОбъект.Отбор.Регистратор.Значение;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",Справочники.Организации.ПустаяСсылка());
	
	Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "РазрешитьРедактироватьНоменклатурныеГруппыВДокументахПриОтраженииВЗатратах") Тогда
		Запрос.УстановитьПараметр("Роль", Перечисления.НаборПравПользователей.МенеджерПоЗакупкам);	
	ИначеЕсли РольДоступна("ПолныеПрава") Тогда
		Запрос.УстановитьПараметр("Роль", Перечисления.НаборПравПользователей.ПолныеПрава);
	Иначе
		Запрос.УстановитьПараметр("Роль" ,Перечисления.НаборПравПользователей.МенеджерПоПродажам);	
	КонецЕсли;	
	
	ГраницаЗапретаИзменений = ДобавитьМесяц(НачалоДня(ТекущаяДата()),-1);
	
		Запрос.Текст = "ВЫБРАТЬ
	|	ГраницаЗапретаИзменений ИЗ
	|	РегистрСведений.ГраницыЗапретаИзмененияДанных 
	|	ГДЕ Организация =&Организация И Роль =&Роль" ;
	
	Результат=Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка=Результат.Выбрать();
		Выборка.Следующий();
		ГраницаЗапретаИзменений =  Мин (Выборка.ГраницаЗапретаИзменений,ГраницаЗапретаИзменений);
	КонецЕсли;	
		
	
	Если  СсылкаНаОбъектДокумент.Дата < ГраницаЗапретаИзменений  Тогда
		 Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры	