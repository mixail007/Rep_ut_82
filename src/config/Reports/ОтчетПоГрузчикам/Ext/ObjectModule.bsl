﻿Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Ложь, ВысотаЗаголовка = 0, ТолькоЗаголовок = Ложь) Экспорт
    //ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("КонДата", НачалоДня(КонецДня(ОбщийОтчет.ДатаКон)+1));
	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("КонДата", Новый Граница(КонецДня(ОбщийОтчет.ДатаКон),ВидГраницы.Включая));

	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("НачДата", ОбщийОтчет.ДатаНач);
	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("Расценка", ЭтотОбъект.Расценка);
	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("Подразделение", ЭтотОбъект.Подразделение);
	ОбщийОтчет.ПостроительОтчета.Параметры.Вставить("ПодразделениеТранзит",  ?( РольДоступна("ПравоЗавершенияРаботыПользователей"), Ложь,  //26.04.2016 - для нас - НЕ искаженная картина
				ЭтотОбъект.Подразделение.ОбособленноеПодразделение));
	
	ОбщийОтчет.СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок);

КонецПроцедуры

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	СтруктураПредставлениеПолей = Новый Структура;
	МассивОтбора = Новый Массив;
	ПостроительОтчета = ОбщийОтчет.ПостроительОтчета;
	


Текст= "ВЫБРАТЬ 
| ВесОборот,
| ВесНеттоОборот,
| //ВесДискиОборот,
| //ВесИмпортОборот,
| //ВесВыходныеОборот,
| //ВесПеремещенияОборот,
| СуммаНетто,
| СуммаДиски,
| СуммаИмпорт,
| СуммаВыходные,
| СуммаПеремещения,
| СуммаИтого
| {ВЫБРАТЬ
| Сотрудник,
| ВидДокумента,
| Регистратор,
| 0 тест,
| ВесОборот,
| ВесНеттоОборот,
| //ВесДискиОборот,
| //ВесИмпортОборот,
| //ВесВыходныеОборот,
| //ВесПеремещенияОборот,
| СуммаНетто,
| СуммаДиски,
| СуммаИмпорт,
| СуммаВыходные,
| СуммаПеремещения,
| СуммаИтого,
|	НачалоПериода(Период, День) КАК ПериодДень ,
|	НачалоПериода(Период, Месяц) КАК ПериодМесяц 
|  }
| ИЗ
|	(ВЫБРАТЬ
|	Сотрудник,
|	ВЫБОР
|		КОГДА Регистратор ССЫЛКА Документ.ОперацияПоОтветственномуХранению
|			ТОГДА ""Ответ. хранение""
|			КОГДА Регистратор ССЫЛКА Документ.РеализацияТоваровУслуг
|			ТОГДА ""Реализация""
|			КОГДА Регистратор ССЫЛКА Документ.ПоступлениеТоваровУслуг
|			ТОГДА ""Поступление""
|			КОГДА Регистратор ССЫЛКА Документ.КомплектацияНоменклатуры
|			ТОГДА ""Комплектация""
|			КОГДА Регистратор ССЫЛКА Документ.ПеремещениеТоваров
|			ТОГДА ""Перемещение""
|
|
|		ИНАЧЕ ""ИНОЕ""
|	КОНЕЦ КАК ВидДокумента,
|	Регистратор,
|	ВесОборот,
|	ВесНеттоОборот,
|	//ВесДискиОборот,
|	//ВесИмпортОборот,
|	//ВесВыходныеОборот,
|	//ВесПеремещенияОборот,
|   ВесНеттоОборот*&Расценка СуммаНетто,
|	ВесДискиОборот*&Расценка СуммаДиски,
|	ВесИмпортОборот*&Расценка СуммаИмпорт,
|	ВесВыходныеОборот*&Расценка СуммаВыходные,
|   ВесПеремещенияОборот*&Расценка СуммаПеремещения,
|	ВесОборот*&Расценка СуммаИтого,
|   Период
|
|ИЗ
|	РегистрНакопления.ДанныеПоГрузчикам.Обороты(&НачДата, &КонДата, Регистратор, )) КАК ДанныеПоГрузчикамОбороты
//+++ 19.02.2016
|ГДЕ ДанныеПоГрузчикамОбороты.Регистратор.Подразделение = &Подразделение

//+++ 26.04.2016 - ограничение по грузчикам подразделения
| И выбор когда &ПодразделениеТранзит тогда
|	ДанныеПоГрузчикамОбороты.Сотрудник 
|	В (ВЫБРАТЬ РАЗЛИЧНЫЕ ГруппыСкладовСостав.ФизЛицо 
|	   ИЗ Справочник.ГруппыСкладов.Состав как ГруппыСкладовСостав
|	   ГДЕ ГруппыСкладовСостав.ссылка.Транзит 
|      ) 
| иначе Истина Конец

| УПОРЯДОЧИТЬ ПО Сотрудник.Наименование
|{УПОРЯДОЧИТЬ ПО
|Сотрудник.*
|}
| { ГДЕ Сотрудник,ВидДокумента, Регистратор.*}
|
|{ИТОГИ ПО
|Сотрудник,ВидДокумента,Регистратор.*,
|	НачалоПериода(Период, День) КАК ПериодДень ,
|	НачалоПериода(Период, Месяц) КАК ПериодМесяц
|}
| ИТОГИ

|	СУММА(ВесОборот),
|	СУММА(ВесНеттоОборот),
|	//СУММА(ВесДискиОборот),
|	//СУММА(ВесИмпортОборот),
|	//СУММА(ВесВыходныеОборот),
|	//СУММА(ВесПеремещенияОборот),
|	СУММА(СуммаНетто),
|	СУММА(СуммаДиски),
|	СУММА(СуммаИмпорт),
|	СУММА(СуммаВыходные),
|	СУММА(СуммаПеремещения),
|	СУММА(СуммаИтого)
|ПО ОБЩИЕ,Сотрудник
|";


	
	СтруктураПредставлениеПолей = Новый Структура("
	|ПериодДень,
	|ПериодМесяц",
	"По дням",	
	"По месяцам");

	
		
	ПостроительОтчета.Текст = Текст;
	
	
	ОбщийОтчет.ЗаполнитьПоказатели("ВесОборот", "Вес ИТОГО, кг.", Истина, "ЧЦ=10; ЧДЦ=3");
	
	ОбщийОтчет.ЗаполнитьПоказатели("ВесНеттоОборот", "Вес нетто, кг.", Истина, "ЧЦ=10; ЧДЦ=3");
	//ОбщийОтчет.ЗаполнитьПоказатели("ВесДискиОборот", "Вес (диски)", Истина, "ЧЦ=10; ЧДЦ=3");
	//ОбщийОтчет.ЗаполнитьПоказатели("ВесИмпортОборот", "Вес (импорт)", Истина, "ЧЦ=10; ЧДЦ=3");
	//ОбщийОтчет.ЗаполнитьПоказатели("ВесВыходныеОборот", "Вес (выходные)", Истина, "ЧЦ=10; ЧДЦ=3");
	//ОбщийОтчет.ЗаполнитьПоказатели("ВесПеремещенияОборот", "Вес (перемещения)", Истина, "ЧЦ=10; ЧДЦ=3");
	
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаНетто", "Сумма за погр./разгр.", Истина, "ЧЦ=10; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаДиски", "Сумма за диски", Истина, "ЧЦ=10; ЧДЦ=2");
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаИмпорт", "Сумма за импорт", Истина, "ЧЦ=10; ЧДЦ=2");
	
	//+++ 26.04.2013 - просто переименовано поле!
	//ОбщийОтчет.ЗаполнитьПоказатели("СуммаВыходные", "Сумма за выходные", Истина, "ЧЦ=10; ЧДЦ=2");
	 ОбщийОтчет.ЗаполнитьПоказатели("СуммаВыходные", "Сумма за переработку", Истина, "ЧЦ=10; ЧДЦ=2");
	 
	 //+++ 10.06.2015
	 ОбщийОтчет.ЗаполнитьПоказатели("СуммаПеремещения", "Сумма за перемещения", Истина, "ЧЦ=10; ЧДЦ=2");
	 
	 
	ОбщийОтчет.ЗаполнитьПоказатели("СуммаИтого", "Сумма ИТОГО", Истина, "ЧЦ=10; ЧДЦ=2");

	
	
	ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	ОчиститьДополнительныеПоляПостроителя(ПостроительОтчета);
	ЗаполнитьОтбор(МассивОтбора, ПостроительОтчета);
	
	//ОбщийОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить("Программа");
	//ОбщийОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить("Производитель");
	//ОбщийОтчет.ПостроительОтчета.ИзмеренияКолонки.Добавить("Вид");
	
	ОбщийОтчет.мНазваниеОтчета = "Отчет по грузчикам";

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

ОбщийОтчет.ИмяРегистра = "Данные по грузчикам";
ОбщийОтчет.мНазваниеОтчета = "Отчет по грузчикам";
ОбщийОтчет.мВыбиратьИмяРегистра = Ложь;
ОбщийОтчет.мВыбиратьИспользованиеСвойств=Ложь;
ОбщийОтчет.мРежимВводаПериода = 0;
ОбщийОтчет.ВыводитьПоказателиВСтроку=Истина;