﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПЕРЕМЕННЫЕ
// 

Перем РегистрацияИзменений_НеРегистрировать Экспорт;
Перем РегистрацияИзменений_ВызовМетода Экспорт;
Перем РегистрацияИзменений_ЗаписьЭлемента Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ
// 

// Процедура заполняет набор узлов по списку узлов
// <Описание процедуры>
//
// Параметры
//  Набор	–	НаборУзлов	– набор узлов, который необходимо заполнить
//
//  Список  –	Массив – список узлов для заполнения набора

//
Процедура ЗаполнитьНаборУзлов(Набор, Список)

	Набор.Очистить();
	Для каждого Элемент Из Список Цикл
	
		Набор.Добавить(Элемент);
	
	КонецЦикла;    

КонецПроцедуры // ЗаполнитьНаборУзлов(Набор, Список)
    

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ
// 

/////////////////////////////////////////////////////////////////////////////////
// Функция получения полного имени для объектов метаданных верхнего уровня
//
// Параметры:
//  ОбъектМетаданных - объект описания метаданного, для которого
//                     необходимо получить полное имя
//  Коллекция        - признак необходимости формирования вида коллекции объектов
//                     метаданных
//
// Результат:
//  ВидОбъекта      - строка, вид объекта метаданных, Неопределено - если вид не установлен
//
Функция ВидОбъектаМетаданныхОбмена(ОбъектМетаданных, Коллекция = Ложь) Экспорт
    
    ВидОбъекта = Неопределено;
    Если Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "Константа";
        Если Коллекция Тогда
            
            ВидОбъекта = "Константы";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "Справочник";
        Если Коллекция Тогда
            
            ВидОбъекта = "Справочники";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "Документ";
        Если Коллекция Тогда
            
            ВидОбъекта = "Документы";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.Последовательности.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "Последовательность";
        Если Коллекция Тогда
            
            ВидОбъекта = "Последовательности";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "ПланВидовХарактеристик";
        Если Коллекция Тогда
            
            ВидОбъекта = "ПланыВидовХарактеристик";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "ПланСчетов";
        Если Коллекция Тогда
            
            ВидОбъекта = "ПланыСчетов";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "ПланВидовРасчета";
        Если Коллекция Тогда
            
            ВидОбъекта = "ПланыВидовРасчета";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "БизнесПроцесс";
        Если Коллекция Тогда
            
            ВидОбъекта = "БизнесПроцессы";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.Задачи.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "Задача";
        Если Коллекция Тогда
            
            ВидОбъекта = "Задачи";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "РегистрСведений";
        Если Коллекция Тогда
            
            ВидОбъекта = "РегистрыСведений";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "РегистрНакопления";
        Если Коллекция Тогда
            
            ВидОбъекта = "РегистрыНакопления";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "РегистрБухгалтерии";
        Если Коллекция Тогда
            
            ВидОбъекта = "РегистрыБухгалтерии";
            
        КонецЕсли;
        
    ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
        
        ВидОбъекта = "РегистрРасчета";
        Если Коллекция Тогда
            
            ВидОбъекта = "РегистрыРасчета";
            
        КонецЕсли;
        
    ИначеЕсли ОбъектМетаданных.Родитель() <> Неопределено Тогда
        
            Родитель = ОбъектМетаданных.Родитель();
            Если ВидОбъектаМетаданныхОбмена(Родитель) = "РегистрРасчета"
                И Родитель.Перерасчеты.Содержит(ОбъектМетаданных) Тогда
        
                ВидОбъекта = "Перерасчет";
                Если Коллекция Тогда
                    
                    ВидОбъекта = "Перерасчеты";
                    
                КонецЕсли;
                
            КонецЕсли;
        
    КонецЕсли;
        
    Возврат ВидОбъекта;
    
КонецФункции    // ВидОбъектаМетаданныхОбмена(ОбъектМетаданных) Экспорт

// Функция формирует полное имя объекта метаданных
//
// Параметры:
//  ОбъектМетаданных - объект описания метаданных, для которого необходимо получить имя
//
// Результат
//  ПолноеИмя - полное имя объекта метаданных
//
Функция ПолноеИмяОбъектаМетаданных(ОбъектМетаданных) Экспорт
    
    ПолноеИмя = ОбъектМетаданных.Имя;
    ВидОбъекта = ВидОбъектаМетаданныхОбмена(ОбъектМетаданных, Истина);
    Если ВидОбъекта <> Неопределено Тогда
        
        ПолноеИмя = ВидОбъектаМетаданныхОбмена(ОбъектМетаданных, Истина) + "." + ПолноеИмя;
        
    КонецЕсли;
    
    Родитель = ОбъектМетаданных.Родитель();
    Если Родитель <> Неопределено И Родитель <> Метаданные.Языки[0].Родитель() Тогда
        
        ПолноеИмя = ПолноеИмяОбъектаМетаданных(Родитель) + "." + ПолноеИмя;
        
    КонецЕсли;
    
    Возврат ПолноеИмя;
    
КонецФункции    


// Функция создает таблицу значений и заполняет ее составом плана обмена
//
// Параметры:
//  ПланОбменаМетаданные - объект описания метаданного ПланОбмена, для которого
//                         необходимо заполнить состав.
//
// Возвращаемое значение:
//  СоставПланаОбмена - таблица значений, содержащая состав плана обмена и
//                      виды регистрации изменений данных для объектов
//

Функция ЗаполнитьСоставОбмена(ПланОбменаМетаданные) Экспорт
    
    СоставПланаОбмена = Новый ТаблицаЗначений;
    СоставПланаОбмена.Колонки.Добавить("ОбъектМетаданных", , "Объект метаданных");
    СоставПланаОбмена.Колонки.Добавить("Регистрация", , "Регистрация");
    СоставПланаОбмена.Колонки.Добавить("ЭлементСостава");
    Состав = ПланОбменаМетаданные.Состав;
    
    // заполняем таблицу значений составом
    Для каждого Элемент из Состав Цикл
        
        Стр = СоставПланаОбмена.Добавить();
        Стр.ЭлементСостава = Элемент;
        Стр.Регистрация = РегистрацияИзменений_НеРегистрировать;
        Стр.ОбъектМетаданных = Элемент.Метаданные.Имя;
        
        // Определяем какой это объект описания метаданного
        ВидОбъекта = ВидОбъектаМетаданныхОбмена(Элемент.Метаданные);
        
        // Если успешно определили, то устанавливаем полное имя
        Если ВидОбъекта <> Неопределено Тогда
            
            Стр.ОбъектМетаданных = ПолноеИмяОбъектаМетаданных(Элемент.Метаданные);
            
        КонецЕсли;
            
    КонецЦикла;
    
    СоставПланаОбмена.Сортировать("ОбъектМетаданных");
    Возврат СоставПланаОбмена;
    
КонецФункции    // ЗаполнитьСоставОбмена(ПланОбмена) Экспорт

///////////////////////////////////////////////////////////////////////////////
// Выполняет регистрацию изменений объектов по выбранному методу
//
// Параметры:
//  ПланОбмена      - объект описания метаданного для узлов которого 
//                    необходимо выполнить регистрацию
//  Узлы            - массив узлов, для которых необходимо выполнить регистрацию
//  СоставОбмена    - состав плана обмена
// 
Процедура ЗарегистрироватьИзменения(ПланОбмена, Узлы, СоставОбмена) Экспорт
    
    // Регистрируем изменения объектов соответствующих объектам описания метаданных
    Для каждого Стр из СоставОбмена Цикл
        
        ОбъектМетаданных = Стр.ЭлементСостава.Метаданные;
        Если Стр.Регистрация = РегистрацияИзменений_ВызовМетода Тогда
            
            Сообщить("Регистрация изменений для элементов данных '" + ПолноеИмяОбъектаМетаданных(ОбъектМетаданных) + "' для узлов:");
			Для каждого Узел Из Узлы Цикл
			
				Сообщить("	- " + Узел);
			
			КонецЦикла; 
            // вызов стандартного метода плана обмена
            ПланыОбмена.ЗарегистрироватьИзменения(Узлы, ОбъектМетаданных);
            
        ИначеЕсли Стр.Регистрация = РегистрацияИзменений_ЗаписьЭлемента Тогда
            
            // создаем объекты данного вида и вызываем у них запись
            Если Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда
                
                // константы записываются с помощью менеджера значения константы
                МенеджерЗначения = Константы[ОбъектМетаданных.Имя].СоздатьМенеджерЗначения();
                МенеджерЗначения.Прочитать();
				// заполняем набор узлов-получателей
				МенеджерЗначения.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
				ЗаполнитьНаборУзлов(МенеджерЗначения.ОбменДанными.Получатели, Узлы);
				// записываем элемент данных
                МенеджерЗначения.Записать();
                
            ИначеЕсли Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
                
                // выбираем по одному все элементы справочника
                Выборка = Справочники[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;

            ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
                
                // выбираем по одному все документы
                Выборка = Документы[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.Последовательности.Содержит(ОбъектМетаданных) Тогда
                
                // Регистрация изменений выполняется по наборам записей
                
                // отбираем уникальных регистраторов записей последовательности
                Запрос = Новый Запрос;
                Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ Регистратор ИЗ Последовательность." + ОбъектМетаданных.Имя;
                Выборка = Запрос.Выполнить().Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    // Создаем набор записей
                    Набор = Последовательности[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                    Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
                    // читаем данные набора записей
                    Набор.Прочитать();
					// заполняем набор узлов-получателей
					Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                    // записываем данные набора записей
                    Набор.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных) Тогда
                
                // выбираем по одному все планы видов характеристик
                Выборка = ПланыВидовХарактеристик[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
                
                // выбираем по одному все планы счетов
                Выборка = ПланыСчетов[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(ОбъектМетаданных) Тогда
                
                // выбираем по одному все планы видов расчета
                Выборка = ПланыВидовРасчета[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
                
		    ИначеЕсли Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных) Тогда
		        
                // выбираем по одному все бизнес-процессы
                Выборка = БизнесПроцессы[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
		        
		    ИначеЕсли Метаданные.Задачи.Содержит(ОбъектМетаданных) Тогда
		        
                // выбираем по одному все задачи бизнес-процессов
                Выборка = Задачи[ОбъектМетаданных.Имя].Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    Объект = Выборка.ПолучитьОбъект();
					// заполняем набор узлов-получателей
					Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Объект.ОбменДанными.Получатели, Узлы);
					// записываем элемент данных
                    Объект.Записать();
                    
                КонецЦикла;
		        
            ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
                
                // опеределяем поля, входящие в ключ регистра
                КлючЗаписи = Новый Массив;
                Если ОбъектМетаданных.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
                    
                    КлючЗаписи.Добавить("Регистратор");
                    
                Иначе
                    
                    Если ОбъектМетаданных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
                        И ОбъектМетаданных.ОсновнойОтборПоПериоду Тогда
                        
                        КлючЗаписи.Добавить("Период");
                        
                    КонецЕсли;
                    
                    Для Каждого Измерение ИЗ ОбъектМетаданных.Измерения Цикл
                        
                        Если Измерение.ОсновнойОтбор Тогда
                            
                            КлючЗаписи.Добавить(Измерение.Имя);
                            
                        КонецЕсли;    
                        
                    КонецЦикла;
                    
                КонецЕсли;    
                
                // отбираем уникальных регистраторов записей регистра накопления
                Запрос = Новый Запрос;
                Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ "; 

                НужнаЗапятая = Ложь;
                Для Каждого Поле Из КлючЗаписи Цикл
                    
                    Запрос.Текст = Запрос.Текст + ?(НужнаЗапятая, ", ", "") + Поле;
                    НужнаЗапятая = Истина;
                    
                КонецЦикла;
                
                Запрос.Текст = Запрос.Текст + " ИЗ РегистрСведений." + ОбъектМетаданных.Имя;
                Выборка = Запрос.Выполнить().Выбрать();
                
                Пока Выборка.Следующий() Цикл
                    
                    // Создаем набор записей
                    Набор = РегистрыСведений[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                    
                    // устанавливаем значения отбора
                    Для каждого Поле Из КлючЗаписи Цикл
                        
                        Набор.Отбор[Поле].Установить(Выборка[Поле]);
                        
                    КонецЦикла;
                    
                    // читаем данные набора записей
                    Набор.Прочитать();
					// заполняем набор узлов-получателей
					Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                    // записываем данные набора записей
                    Набор.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ОбъектМетаданных) Тогда
                
                // Регистрация изменений выполняется по наборам записей
                
                // отбираем уникальных регистраторов записей регистра накопления
                Запрос = Новый Запрос;
                Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ Регистратор ИЗ РегистрНакопления." + ОбъектМетаданных.Имя;
                Выборка = Запрос.Выполнить().Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    // Создаем набор записей
                    Набор = РегистрыНакопления[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                    Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
                    // читаем данные набора записей
                    Набор.Прочитать();
					// заполняем набор узлов-получателей
					Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                    // записываем данные набора записей
                    Набор.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ОбъектМетаданных) Тогда
                
                // Регистрация изменений выполняется по наборам записей
                
                // отбираем уникальных регистраторов записей регистра бухгалтерии
                Запрос = Новый Запрос;
                Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ Регистратор ИЗ РегистрБухгалтерии." + ОбъектМетаданных.Имя;
                Выборка = Запрос.Выполнить().Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    // Создаем набор записей
                    Набор = РегистрыБухгалтерии[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                    Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
                    // читаем данные набора записей
                    Набор.Прочитать();
					// заполняем набор узлов-получателей
					Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                    // записываем данные набора записей
                    Набор.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
                
                // Регистрация изменений выполняется по наборам записей
                
                // отбираем уникальных регистраторов записей регистра расчета
                Запрос = Новый Запрос;
                Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ Регистратор ИЗ РегистрРасчета." + ОбъектМетаданных.Имя;
                Выборка = Запрос.Выполнить().Выбрать();
                Пока Выборка.Следующий() Цикл
                    
                    // Создаем набор записей
                    Набор = РегистрыРасчета[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                    Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
                    // читаем данные набора записей
                    Набор.Прочитать();
					// заполняем набор узлов-получателей
					Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
					ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                    // записываем данные набора записей
                    Набор.Записать();
                    
                КонецЦикла;
                
            ИначеЕсли ОбъектМетаданных.Родитель() <> Неопределено Тогда
                
                Родитель = ОбъектМетаданных.Родитель();
                Если ВидОбъектаМетаданныхОбмена(Родитель) = "РегистрРасчета"
                    И Родитель.Перерасчеты.Содержит(ОбъектМетаданных) Тогда
            
                    // отбираем уникальных регистраторов записей регистра расчета
                    Запрос = Новый Запрос;
                    Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ОбъектПерерасчета ИЗ РегистрРасчета." + Родитель.Имя + "." + ОбъектМетаданных.Имя;
                    Выборка = Запрос.Выполнить().Выбрать();
                    Пока Выборка.Следующий() Цикл
                        
                        // Создаем набор записей
                        Набор = РегистрыРасчета[ОбъектМетаданных.Имя].СоздатьНаборЗаписей();
                        Набор.Отбор.ОбъектПерерасчета.Установить(Выборка.ОбъектПерерасчета);
                        // читаем данные набора записей
                        Набор.Прочитать();
						// заполняем набор узлов-получателей
						Набор.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
						ЗаполнитьНаборУзлов(Набор.ОбменДанными.Получатели, Узлы);
                        // записываем данные набора записей
                        Набор.Записать();
                        
                    КонецЦикла;
                    
                КонецЕсли;
            
            КонецЕсли;
            
        КонецЕсли;
        
    КонецЦикла;

КонецПроцедуры  // ЗарегистрироватьИзменения(ПланОбмена, Узлы, СоставОбмена) Экспорт

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ ЭКСПОРТНЫХ ПЕРЕМЕННЫХ
// 

РегистрацияИзменений_НеРегистрировать = "НеРегистрировать";
РегистрацияИзменений_ВызовМетода = "ВызовМетода";
РегистрацияИзменений_ЗаписьЭлемента = "ЗаписьЭлемента";
