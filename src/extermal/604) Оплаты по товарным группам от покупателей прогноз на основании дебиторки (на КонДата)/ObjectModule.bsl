﻿Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт
    ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("НачДата", НачалоДня(ОбщийОтчет.ДатаНач));
	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("КонДата", КонецДня(ОбщийОтчет.ДатаКон));
	//ОбщийОтчет.мРежимВводаПериода = 0;
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

//=======================ГЛАВНАЯ=============================
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	
	Текст= "ВЫБРАТЬ
	       |	ДТГ.Вид КАК Вид,
	       |	ДТГ.ДоговорКонтрагента.ОтветственноеЛицо КАК Менеджер,
	       |	ДТГ.Контрагент КАК Контрагент,
	       |	ДТГ.ДоговорКонтрагента КАК ДоговорКонтрагента,
	       |	ДТГ.Сделка КАК Сделка,
	       |	ДТГ.Номенклатура КАК Номенклатура,
	       |	ДТГ.СуммаВЗаказе КАК СуммаВЗаказе,
	       |	ДТГ.Регистратор КАК Регистратор,
	       |	ДТГ.Сумма КАК Сумма
	       |{ВЫБРАТЬ
	       |	Номенклатура.*,
	       |	Менеджер.*,
	       |	Контрагент.*,
	       |	ДоговорКонтрагента.*,
	       |	Сделка.*,
	       |	Регистратор.*}
	       |ИЗ
	       |	(ВЫБРАТЬ
	       |		ВЫБОР
	       |			КОГДА ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот > 0
	       |				ТОГДА ""Дебиторка""
	       |			ИНАЧЕ ""Оплата""
	       |		КОНЕЦ КАК Вид,
	       |		Заказы.Номенклатура КАК Номенклатура,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.Регистратор КАК Регистратор,
	       |		ВЫБОР
	       |			КОГДА ЕСТЬNULL(Заказы.СуммаДокумента, 0) = 0
	       |				ТОГДА 0
	       |			ИНАЧЕ ВЫБОР
	       |					КОГДА ВзаиморасчетыСКонтрагентамиОстатки.Сделка.СуммаВключаетНДС
	       |						ТОГДА ВЫРАЗИТЬ(Заказы.Сумма / Заказы.СуммаДокумента * ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот КАК ЧИСЛО(15, 2))
	       |					ИНАЧЕ ВЫРАЗИТЬ((Заказы.Сумма + Заказы.СуммаНДС) / Заказы.СуммаДокумента * ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот КАК ЧИСЛО(15, 2))
	       |				КОНЕЦ
	       |		КОНЕЦ КАК Сумма,
	       |		ВЫБОР
	       |			КОГДА НЕ ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот > 0
	       |				ТОГДА -Заказы.Сумма
	       |			ИНАЧЕ Заказы.Сумма
	       |		КОНЕЦ КАК СуммаВЗаказе
	       |	{ВЫБРАТЬ
	       |		Номенклатура.*,
	       |		Контрагент.*,
	       |		ДоговорКонтрагента.*,
	       |		Сделка.*,
	       |		Регистратор.*}
	       |	ИЗ
	       |		РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(
	       |				&НачДата,
	       |				&КонДата,
	       |				Регистратор,
	       |				ДоговорКонтрагента.Владелец.Покупатель = ИСТИНА
	       |					И ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам) КАК ВзаиморасчетыСКонтрагентамиОстатки
	       |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	       |				ЗаказПокупателяТовары.Ссылка.ДоговорКонтрагента КАК ДоговорКонтрагента,
	       |				ЗаказПокупателяТовары.Ссылка КАК Сделка,
	       |				ЗаказПокупателяТовары.Номенклатура КАК Номенклатура,
	       |				ЗаказПокупателяТовары.Сумма КАК Сумма,
	       |				ЗаказПокупателяТовары.СуммаНДС КАК СуммаНДС,
	       |				ЗаказПокупателяТовары.Ссылка.СуммаДокумента КАК СуммаДокумента
	       |			ИЗ
	       |				Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	       |			ГДЕ
	       |				НЕ ЗаказПокупателяТовары.Ссылка.ПометкаУдаления
	       |				И ЗаказПокупателяТовары.Ссылка.Проведен
	       |				И ЗаказПокупателяТовары.Ссылка.Проверен
	       |				И ЗаказПокупателяТовары.Ссылка.Дата >= &ДатаЗак) КАК Заказы
	       |			ПО ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента = Заказы.ДоговорКонтрагента
	       |				И ВзаиморасчетыСКонтрагентамиОстатки.Сделка = Заказы.Сделка
	       |	ГДЕ
	       |		Заказы.СуммаДокумента > 0
	       |	{ГДЕ
	       |		(ВЫБОР
	       |				КОГДА ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот > 0
	       |					ТОГДА ""Дебиторка""
	       |				ИНАЧЕ ""Кредиторка""
	       |			КОНЕЦ) КАК Вид,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец.* КАК Контрагент,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.*,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.Сделка.*,
	       |		Заказы.Номенклатура.*,
	       |		(ВЫБОР
	       |				КОГДА ЕСТЬNULL(Заказы.СуммаДокумента, 0) = 0
	       |					ТОГДА 0
	       |				ИНАЧЕ ВЫБОР
	       |						КОГДА ВзаиморасчетыСКонтрагентамиОстатки.Сделка.СуммаВключаетНДС
	       |							ТОГДА ВЫРАЗИТЬ(Заказы.Сумма / Заказы.СуммаДокумента * ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот КАК ЧИСЛО(15, 2))
	       |						ИНАЧЕ ВЫРАЗИТЬ((Заказы.Сумма + Заказы.СуммаНДС) / Заказы.СуммаДокумента * ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот КАК ЧИСЛО(15, 2))
	       |					КОНЕЦ
	       |			КОНЕЦ) КАК Сумма,
	       |		ВзаиморасчетыСКонтрагентамиОстатки.Регистратор.*,
	       |		(ВЫБОР
	       |				КОГДА НЕ ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОборот > 0
	       |					ТОГДА -Заказы.Сумма
	       |				ИНАЧЕ Заказы.Сумма
	       |			КОНЕЦ) КАК СуммаВЗаказе}) КАК ДТГ
	       |{ГДЕ
	       |	ДТГ.Вид,
	       |	ДТГ.ДоговорКонтрагента.ОтветственноеЛицо.* КАК Менеджер,
	       |	ДТГ.Контрагент.*,
	       |	ДТГ.ДоговорКонтрагента.*,
	       |	ДТГ.Номенклатура.*,
	       |	ДТГ.Сделка.*,
	       |	ДТГ.Регистратор.*}
	       |ИТОГИ
	       |	СУММА(СуммаВЗаказе),
	       |	СУММА(Сумма)
	       |ПО
	       |	ОБЩИЕ,
	       |	Номенклатура,
	       |	Сделка,
	       |	Менеджер,
	       |	Контрагент,
	       |	ДоговорКонтрагента,
	       |	Регистратор,
	       |	Вид
	       |{ИТОГИ ПО
	       |	Менеджер.*,
	       |	Контрагент.*,
	       |	ДоговорКонтрагента.*,
	       |	Вид,
	       |	Номенклатура.*,
	       |	Сделка.*,
	       |	Регистратор.*,
	       |	СуммаВЗаказе,
	       |	Сумма}
	       |АВТОУПОРЯДОЧИВАНИЕ";

		   Текст ="ВЫБРАТЬ
|	 ЗаказПокупателяТовары.Номенклатура Номенклатура,
| //	ВзаиморасчетыСКонтрагентамиОбороты.Вид,
|	ВзаиморасчетыСКонтрагентамиОбороты.Регистратор,
|	ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента,
|	ВзаиморасчетыСКонтрагентамиОбороты.Сделка,
|//	ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрРасход КАК СуммаУпрРасход,
|//	ЗаказПокупателяТовары.Ссылка.СуммаДокумента,
| //	ЗаказПокупателяТовары.Сумма,
|   ВЫБОР КОГДА   ЗаказПокупателяТовары.Ссылка.СуммаДокумента =0 ТОГДА 0 
|   ИНАЧЕ
|	ВЫРАЗИТЬ (ЕстьNULL(СуммаУпрРасход*ЗаказПокупателяТовары.Сумма/ЗаказПокупателяТовары.Ссылка.СуммаДокумента,0) КАК ЧИСЛО(15,2)) 
|   КОНЕЦ СуммаОплаты
|	{ВЫБРАТЬ
|	(НАЧАЛОПЕРИОДА(Период, МЕСЯЦ)) КАК ПериодМесяц,
|	Номенклатура.*,
|	//Менеджер.*,
|	//Контрагент.*,
|	ДоговорКонтрагента.*,
|	Сделка.*,
|	Регистратор.*}
|ИЗ
|	(ВЫБРАТЬ
|		ТИПЗНАЧЕНИЯ(ВзаиморасчетыСКонтрагентамиОбороты.Регистратор) КАК Вид,
|		ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.Номер КАК РегистраторНомер,
|		ВзаиморасчетыСКонтрагентамиОбороты.Регистратор КАК Регистратор,
|		ВзаиморасчетыСКонтрагентамиОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
|		ВзаиморасчетыСКонтрагентамиОбороты.Сделка КАК Сделка,
|   	ВзаиморасчетыСКонтрагентамиОбороты.Период,
|		ВзаиморасчетыСКонтрагентамиОбороты.СуммаУпрРасход КАК СуммаУпрРасход
|	ИЗ
|		РегистрНакопления.ВзаиморасчетыСКонтрагентами.Обороты(
|				&НачДата,
|				КОНЕЦПЕРИОДА(&КонДата, ДЕНЬ),
|				Регистратор,
|				ДоговорКонтрагента.Владелец.Покупатель
|					И ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам) КАК ВзаиморасчетыСКонтрагентамиОбороты
|	ГДЕ
|		(ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.ПлатежноеПоручениеВходящее
|				ИЛИ ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.ПриходныйКассовыйОрдер
|				ИЛИ ВзаиморасчетыСКонтрагентамиОбороты.Регистратор ССЫЛКА Документ.Взаимозачет
|					И ВзаиморасчетыСКонтрагентамиОбороты.Регистратор.УчитыватьДляРасчетаПремии)) КАК ВзаиморасчетыСКонтрагентамиОбороты
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
|		ПО ВзаиморасчетыСКонтрагентамиОбороты.Сделка = ЗаказПокупателяТовары.Ссылка
|{ГДЕ
|	Период,
|	ДоговорКонтрагента.* КАК Менеджер,
|	Номенклатура.*,
|	Сделка.*,
|	Регистратор.*}
|//	УПОРЯДОЧИТЬ ПО Период
|ИТОГИ
|	СУММА(СуммаОплаты)
|//	СУММА(Сумма)
|  ПО ОБЩИЕ //, Номенклатура
|{ИТОГИ ПО
|	(НАЧАЛОПЕРИОДА(Период, МЕСЯЦ)) КАК ПериодМесяц,
|	ДоговорКонтрагента.*,
|	Номенклатура.*,
|	Сделка.*,
|	Регистратор.*}
|{УПОРЯДОЧИТЬ ПО
|	ДоговорКонтрагента.*,
|	Номенклатура.*,
|	Сделка.*,
|	Регистратор.*}
| АВТОУПОРЯДОЧИВАНИЕ"; 



Текст = "
|  ВЫБРАТЬ       
| ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента,
| ПериодМесяц,
|СуммаОплаты
|{ВЫБРАТЬ
|	 ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента,
| ПериодМесяц,
|СуммаОплаты
|} 
|ИЗ
|(
|ВЫБРАТЬ 
|//ДТГ.Вид,
|ДТГ.Номенклатура.ВидТовара ВидТовара,
|ДТГ.Номенклатура.НоменклатурнаяГруппа НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель Производитель,
|Контрагент,
|ДоговорКонтрагента,
|(НАЧАЛОПЕРИОДА(Сделка.ДатаОплаты, МЕСЯЦ)) КАК ПериодМесяц,
|//Сделка,
|СУММА(Сумма) СуммаОплаты
|ИЗ
|(
|ВЫБРАТЬ
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
|	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
|	ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК Сделка,
|	Заказы.Номенклатура Номенклатура,

|   ВЫБОР КОГДА ЕстьNULL(Заказы.СуммаДокумента,0)=0 ТОГДА 0
|   ИНАЧЕ
|   ВЫБОР КОГДА ВзаиморасчетыСКонтрагентамиОстатки.Сделка.СуммаВключаетНДС Тогда
|	 ВЫРАЗИТЬ (Заказы.Сумма/Заказы.Сделка.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   ИНАЧЕ
|	  ВЫРАЗИТЬ ((Заказы.Сумма+Заказы.СуммаНДС)/Заказы.Сделка.СуммаДокумента*ВзаиморасчетыСКонтрагентамиОстатки.СуммаУпрОстаток КАК ЧИСЛО (15,2))
|   КОНЕЦ 
|КОНЕЦ Сумма
|	
|ИЗ
|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&КонДата , ДоговорКонтрагента.ВедениеВзаиморасчетов = &ПоЗаказам И ДоговорКонтрагента.Владелец.Покупатель) ВзаиморасчетыСКонтрагентамиОстатки
|ЛЕВОЕ СОЕДИНЕНИЕ		    
|(
| ВЫБРАТЬ ДоговорКОнтрагента, Сделка,Номенклатура, СУММА(Сумма) Сумма, СУММА(СуммаНДС) СуммаНДС, СУММА(СуммаДокумента) СуммаДокумента
| ИЗ
|(ВЫБРАТЬ
|	ЗаказПокупателяТовары.Ссылка.ДоговорКонтрагента ДоговорКонтрагента,
|	ЗаказПокупателяТовары.Ссылка Сделка,
|	ЗаказПокупателяТовары.Номенклатура Номенклатура,
|	ЗаказПокупателяТовары.Сумма Сумма,
|	ЗаказПокупателяТовары.СуммаНДС СуммаНДС,
|	ЗаказПокупателяТовары.Ссылка.СуммаДокумента  СуммаДокумента
|ИЗ
|	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
|  ) А
| СГРУППИРОВАТЬ ПО ДоговорКОнтрагента, Сделка,Номенклатура
|) Заказы
|ПО	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента=Заказы.ДоговорКонтрагента
|И  ВзаиморасчетыСКонтрагентамиОстатки.Сделка= Заказы.Сделка
|ГДЕ   СуммаУпрОстаток>0
|) ДТГ
| ГДЕ Сумма>0

| СГРУППИРОВАТЬ ПО 
| //ДТГ.Вид,
|ДТГ.Номенклатура.ВидТовара,
|ДТГ.Номенклатура.НоменклатурнаяГруппа,
|ДТГ.Номенклатура.Производитель,
|Контрагент,
|ДоговорКонтрагента,
|(НАЧАЛОПЕРИОДА(Сделка.ДатаОплаты, МЕСЯЦ))  ) А
|{ГДЕ
|	 ВидТовара.*,
|НоменклатурнаяГруппа.*,
|Производитель.*,
|Контрагент,
|ДоговорКонтрагента,
| ПериодМесяц,
|СуммаОплаты
|} 
|ИТОГИ 
|СУММА(СуммаОплаты) ПО ОБЩИЕ
|{
|ИТОГИ ПО
| ВидТовара,
|НоменклатурнаяГруппа,
|Производитель,
|Контрагент,
|ДоговорКонтрагента,
| ПериодМесяц,
|СуммаОплаты     
|}
|{УПОРЯДОЧИТЬ ПО
|	ВидТовара.*,
|	НоменклатурнаяГруппа.*,
|	Производитель.*,
|	Контрагент.*,
|	ПериодМесяц
|	}
| АВТОУПОРЯДОЧИВАНИЕ";

//ПостроительОтчета.Параметры.Вставить("ДатаЗак", '20130101');// не ранее 01.01.2013г.
ПостроительОтчета.Параметры.Вставить("ПоЗаказам", Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
	
	СтруктураПредставлениеПолей = Новый Структура("
	|ДоговорКонтрагента,
	|Сделка,
	|Номенклатура,
	|СуммаОплаты,
	|ПериодМесяц", 
	
	"Договор контрагента",
	"Сделка",
	"Номенклатура",
	"Сумма оплаты",
	"По месяцам");

	
		
	ПостроительОтчета.Текст = Текст;
	МассивОтбора = Новый Массив;
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаОплаты", "Сумма оплаты", Истина, "ЧЦ=15; ЧДЦ=2");
//	ОбщийОтчет.ЗаполнитьПоказатели("Сумма", "Сумма заказа", Ложь, "ЧЦ=15; ЧДЦ=2");
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	
	ОбщийОтчет.мНазваниеОтчета = "Оплаты по товарным группам предстоящие по ";

КонецПроцедуры

// Читает свойство Построитель отчета
//
// Параметры
//	Нет
//
Функция ПолучитьПостроительОтчета() Экспорт

	Возврат ОбщийОтчет.ПолучитьПостроительОтчета();

КонецФункции // ПолучитьПостроительОтчета()

// Настраивает отчет по переданной структуре параметров
//
// Параметры:
//	Нет.
//
Процедура Настроить(Параметры) Экспорт

	ОбщийОтчет.Настроить(Параметры, ЭтотОбъект);

КонецПроцедуры

// Возвращает основную форму отчета, связанную с данным экземпляром отчета
//
// Параметры
//	Нет
//
Функция ПолучитьОсновнуюФорму() Экспорт
	
	ОснФорма = ПолучитьФорму();
	ОснФорма.ОбщийОтчет = ОбщийОтчет;
	ОснФорма.ЭтотОтчет = ЭтотОбъект;
	Возврат ОснФорма;
	
КонецФункции // ПолучитьОсновнуюФорму()

// Возвращает форму настройки 
//
// Параметры:
//	Нет.
//
// Возвращаемое значение:
//	
//
Функция ПолучитьФормуНастройки() Экспорт
	
	ФормаНастройки = ОбщийОтчет.ПолучитьФорму("ФормаНастройка");
	Возврат ФормаНастройки;
	
КонецФункции // ПолучитьФормуНастройки()

// Процедура обработки расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровки(РасшифровкаСтроки, ПолеТД, ВысотаЗаголовка, СтандартнаяОбработка) Экспорт
	
	// Добавление расшифровки из колонки
	Если ТипЗнч(РасшифровкаСтроки) = Тип("Структура") Тогда
		
		// Расшифровка колонки находится в заголовке колонки
		РасшифровкаКолонки = ПолеТД.Область(ВысотаЗаголовка+2, ПолеТД.ТекущаяОбласть.Лево).Расшифровка;

		Расшифровка = Новый Структура;

		Для каждого Элемент Из РасшифровкаСтроки Цикл
			Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
		КонецЦикла;

		Если ТипЗнч(РасшифровкаКолонки) = Тип("Структура") Тогда

			Для каждого Элемент Из РасшифровкаКолонки Цикл
				Расшифровка.Вставить(Элемент.Ключ, Элемент.Значение);
			КонецЦикла;

		КонецЕсли; 

		ОбщийОтчет.ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОбъект);

	КонецЕсли;
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру, в которую складываются настройки
//
Функция СформироватьСтруктуруДляСохраненияНастроек(ПоказыватьЗаголовок) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	ОбщийОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураНастроек, ПоказыватьЗаголовок);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Заполняет настройки из структуры - кроме состояния панели "Отбор"
//
Процедура ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет=Неопределено) Экспорт
	
	// Если отчет, вызвавший порцедуру, не передан, то считаем, что ее вызвал этот отчет
	Если Отчет = Неопределено Тогда
		Отчет = ЭтотОбъект;
	КонецЕсли;

	ОбщийОтчет.ВосстановитьНастройкиИзСтруктуры(СохраненныеНастройки, ПоказыватьЗаголовок, Отчет);
	
КонецПроцедуры

ОбщийОтчет.ИмяРегистра = "ВзаиморасчетыСКонтрагентами";
ОбщийОтчет.мНазваниеОтчета = "Оплаты по товарным группам";
ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
ОбщийОтчет.мВыбиратьИспользованиеСвойств=Ложь;
ОбщийОтчет.мРежимВводаПериода = 0;
ОбщийОтчет.ВыводитьПоказателиВСтроку=Истина;