﻿// Модуль справочника Банки

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОПОЛНИТЕЛЬНЫХ МЕТОДОВ ОБЪЕКТА

// Возвращает структуру обязательных / уникальных реквизитов элемента
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента
// Если ДляГруппы = Истина, аналогично для группы
// Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры для табличных частей
// Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента=Истина, ДляГруппы=Ложь) Экспорт
	ОбязательныеРеквизиты=Новый Структура();
	ОбязательныеРеквизиты.Вставить("Код",1);
	ОбязательныеРеквизиты.Вставить("Наименование",1);
	
	Если ДляЭлемента Тогда
		ОбязательныеРеквизиты.Вставить("Номенклатура",1);
	КонецЕсли;
	
	Возврат ОбязательныеРеквизиты;
КонецФункции

// Проверяет корректность заполнения объекта.
// Возвращает Истина если все заполнено корректно и Ложь иначе.
// В случае некорректного заполнения формирует строку описанием возникших ошибок "Ошибки"
// На вход может быть передана структура ДопРеквизиты с дополнительными реквизитами для проверки
// может управляться булевыми флагами выполняемых проверок Заполнение, Уникальность
// (могут быть и другие необязательные)
// Обычно выполняется универсальным обработчиком, но могут быть добавлены доп. проверки
Функция ПроверитьКорректность(Ошибки="", ДопРеквизиты=Неопределено, Заполнение=Истина, Уникальность=Истина) Экспорт
	//Возврат спПроверитьКорректность(ЭтотОбъект, Ошибки, ДопРеквизиты, Заполнение, Уникальность);
КонецФункции
 
// Функция проверяет, допустимо ли изменение объекта
// Возвращает Истина, если изменения возможны, ложь иначе
// Если изменения доступны частично, возвращает ложь и структуру блокируемых на изменение реквизитов,
Функция ДоступностьИзменения(БлокироватьРеквизиты=Неопределено) Экспорт
	Возврат Истина;
КонецФункции

//Получение цены работы в нормочасах из элемента справочники или справочника нормочасов работ
Процедура ПолучитьЦенуРаботыВНормочасах(НормочасРаботы,ВремяРаботы,КлассАвтомобиля=Неопределено) Экспорт
	//Сформируем запрос на выборку цены работы
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	//|	НормочасыРабот.Нормочас КАК Нормочас,
	|	НормочасыРабот.Время КАК Время
	|ИЗ
	|	РегистрСведений.НормочасыРабот КАК НормочасыРабот
	|ГДЕ
	|	НормочасыРабот.Авторабота = &Авторабота И
	|	НормочасыРабот.КлассАвтомобиля = &КлассАвтомобиля";
	Запрос.УстановитьПараметр("Авторабота",Ссылка);
	Если КлассАвтомобиля<>Неопределено Тогда
		//Если указан класс автомобиля - производим выбор цены работы именно этого класса
		Запрос.УстановитьПараметр("КлассАвтомобиля",КлассАвтомобиля);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			//Если цена запрашиваемого класса задана - вернем ее
//			НормочасРаботы=Выборка.Нормочас;
			ВремяРаботы=Выборка.Время;
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	//Если класс автомобиля не задан или нет цены для этого класса авто - Получим цену общей работы
	Запрос.УстановитьПараметр("КлассАвтомобиля",Справочники.КлассыАвтомобилей.ОбщиеРаботы.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		//Найдена цена общей работы
//		НормочасРаботы=Выборка.Нормочас;
		ВремяРаботы=Выборка.Время;
		Возврат;
	КонецЕсли;
	//В противном случае цена данного класса работы не указана и нет цены общей работы
//	НормочасРаботы=Справочники.Нормочасы.ПустаяСсылка();
	ВремяРаботы=0; 
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	// Вставить содержимое обработчика.
	Если не(ЭтоГруппа) Тогда
		Отказ=ЗначениеНеЗаполнено(Наименование) или ЗначениеНеЗаполнено(Номенклатура) ;
		Если Отказ Тогда
			Предупреждение("Элемент не записан. Обязательно должны быть заполнены поля ""Наименование"" и ""Номенклатура""");
		КонецЕсли;	
	КонецЕсли;
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

	
КонецПроцедуры

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	Префикс = ПолучитьПрефиксНомера();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
//Права = Неопределено;
//#Если Клиент Тогда
//Права = глПрава;
//#КонецЕсли