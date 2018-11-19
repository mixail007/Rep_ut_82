﻿Перем мИмяФайла;                        // имя файла запросов
Перем мИмяПути;                         // путь к файлу запорсов

Перем мЗаголовокФормы;                  // заголовок формы

Перем мТекущаяСтрока;                   // текущая(прошлая) строка дерева запросов.
Перем мИдетДобавление;                  // признак добавления
Перем мАктивизированаДобавляемаяЗапись; // признак активизации добавленной записи

Перем мРезЗапроса;                      // результат 

Перем мФормаПараметров;                 // форма параметров

Перем мТаблицаЗагружена;                // признак того, что рез-т запроса загружен в табличное поле
Перем мСводнаяТаблицаЗагружена;         // признак того, что рез-т запроса загружен в сводную таблицу
Перем мКолВременныхТаблиц;

Перем мЯваСкрипт; //Использована идея DimitrO   (http://www.itland.ru/forum/lofiversion/index.php/t18959.html)

///////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Получает текст запроса из текстового поля
//
// Параметры:
//  СВыделением - признак получения только выделенного текста.
//
// Возвращаемое значение:
//	Текст запроса в виде строки.
//
Функция вПолучитьТекстЗапроса(СВыделением = Ложь)
    СВыделением = ИспользоватьТолькоВыделеннуюОбласть;
	Если Не СВыделением Тогда
		Возврат ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	КонецЕсли;

    ТекстЗап = ЭлементыФормы.ТекстЗапроса.ПолучитьВыделенныйТекст();
	Если СтрДлина(ТекстЗап) <> 0 Тогда
		Возврат ТекстЗап;
	Иначе
		Возврат ЭлементыФормы.ТекстЗапроса.ПолучитьТекст();
	КонецЕсли;

КонецФункции // ПолучитьТекстЗапроса()

// Устанавливает текст запроса в текстовом поле
//
// Параметры:
//  Текст - устанавливаемый текст запроса.
//
Процедура вЗадатьТекстЗапроса(Текст)

	Если ПустаяСтрока(текст) Тогда
		ЭлементыФормы.ТекстЗапроса.УстановитьТекст("ВЫБРАТЬ
												   |	
												   |ИЗ");
	Иначе
		ЭлементыФормы.ТекстЗапроса.УстановитьТекст(Текст);
	КонецЕсли;

КонецПроцедуры // ЗадатьТекстЗапроса()

// Устанавливает заголовок формы по имени файла запросов
//
// Параметры:
//  Нет.
//
Процедура вУстановитьЗаголовокФормы()
	
	Если мИмяФайла <> "" Тогда
		Заголовок = мЗаголовокФормы + " : " + мИмяФайла;
	Иначе
		Заголовок = мЗаголовокФормы;
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗаголовокФормы()

// Записывает в дерево запросов текст запроса из текстового поля
//
// Параметры:
//  Нет.
//
Процедура вСохранитьЗапросТекущейСтроки()

	Если ДеревоЗапросов.Строки.Количество() <> 0 И мТекущаяСтрока <> НеОпределено Тогда

		Если мТекущаяСтрока.ТекстЗапроса <> вПолучитьТекстЗапроса(Ложь) Тогда
			Модифицированность = Истина;
		КонецЕсли;
		     
		мТекущаяСтрока.ТекстЗапроса = вПолучитьТекстЗапроса(Ложь);
		мТекущаяСтрока.ПараметрыЗапроса = мФормаПараметров.Параметры.Скопировать();
		мТекущаяСтрока.СпособВыгрузки = СпособВыгрузки;

	КонецЕсли;

КонецПроцедуры // СохранитьЗапросТекущейСтроки()

// Очищает дерево запросов, текстовое поле, список параметров
//
// Параметры:
//  Нет.
//
Процедура вОчиститьЗначения()

	ДеревоЗапросов.Строки.Очистить();
	вЗадатьТекстЗапроса("ВЫБРАТЬ
						|
						|ИЗ");
	мФормаПараметров.Параметры.Очистить();

КонецПроцедуры // ОчиститьЗначения()

// Сохраняет имя файла и путь к нему для использования в последующих сеансах работы
//
// Параметры:
//  Нет.
//
Процедура вСохранитьИмяФайла()

	СохранитьЗначение("КонсольЗапросов_ИмяФайла", мИмяФайла);
	СохранитьЗначение("КонсольЗапросов_ИмяПути",  мИмяПути);

КонецПроцедуры // СохранитьИмяФайла()

// Восстанавливает имя открывавшегося в предыдущем сеансе работы файла и путь к нему 
//
// Параметры:
//  Нет.
//
Процедура вВосстановитьИмяФайла()

	мИмяФайла = ВосстановитьЗначение("КонсольЗапросов_ИмяФайла");
	мИмяПути  = ВосстановитьЗначение("КонсольЗапросов_ИмяПути");

	Если мИмяФайла = НеОпределено Тогда
		мИмяФайла = "";
	КонецЕсли;

	Если мИмяПути = НеОпределено Тогда
		мИмяПути = "";
	КонецЕсли;

КонецПроцедуры // ВосстановитьИмяФайла()

// Копирует дерево запросов
//
// Параметры:
//  ИсходноеДерево
//	НовоеДерево.
//
Процедура вСкопироватьДеревоЗапросов(ИсходноеДерево, НовоеДерево)

	НовоеДерево.Строки.Очистить();

	Если ИсходноеДерево.Строки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Для каждого СтрокаДерева из ИсходноеДерево.Строки Цикл

		НоваяСтрока = НовоеДерево.Строки.Добавить();
		НоваяСтрока[0] = СтрокаДерева[0]; // Запрос
		НоваяСтрока[1] = СтрокаДерева[1]; // ТекстЗапроса
		НоваяСтрока[2] = СтрокаДерева[2]; // ПараметрыЗапроса
		НоваяСтрока[3] = СтрокаДерева[3]; // СпособВыгрузки

		вСкопироватьДеревоЗапросов(СтрокаДерева, НоваяСтрока);
		
	КонецЦикла;

КонецПроцедуры // СкопироватьДеревоЗапросов()

// Подготовка к созданию нового файла запросов
//
// Параметры:
//  Нет.
//
Процедура вСоздатьНовыйФайлЗапросов()

	мИмяФайла = "";
	мИмяПути = "";
	вСохранитьИмяФайла();

	вОчиститьЗначения();
	вУстановитьЗаголовокФормы();
	мТекущаяСтрока = НеОпределено;

	мТекущаяСтрока = ДеревоЗапросов.Строки.Добавить();
	мТекущаяСтрока.Запрос = "Запросы";
	мТекущаяСтрока.ТекстЗапроса = "ВЫБРАТЬ
								  |
								  |ИЗ";
	
	Модифицированность = Ложь;
	
КонецПроцедуры // СоздатьНовыйФайлЗапросов()

// Загружает дерево запросов из файла
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьЗапросыИзФайла()

	//Проверим существование файла.
	ФайлЗначения = Новый Файл(мИмяФайла);
	ПолученноеЗначение = ?(ФайлЗначения.Существует(), ЗначениеИзФайла(мИмяФайла), Неопределено);

	Если ТипЗнч(ПолученноеЗначение) = Тип("ТаблицаЗначений") Тогда

		вОчиститьЗначения();
		Для каждого СтрокаВремТаблицы из ПолученноеЗначение Цикл
			НовСтрока = ДеревоЗапросов.Строки.Добавить();
			НовСтрока[0] = СтрокаВремТаблицы[0]; // Запрос
			НовСтрока[1] = СтрокаВремТаблицы[1]; // ТекстЗапроса
			НовСтрока[2] = СтрокаВремТаблицы[2]; // ПараметрыЗапроса
			Если ПолученноеЗначение.Колонки.Количество() > 3 Тогда
				НовСтрока[3] = СтрокаВремТаблицы[3]; // СпособВыгрузки
			КонецЕсли;
		КонецЦикла;
		Модифицированность = Ложь;

	ИначеЕсли ТипЗнч(ПолученноеЗначение) = Тип("ДеревоЗначений") Тогда

		вОчиститьЗначения();
		вСкопироватьДеревоЗапросов(ПолученноеЗначение, ДеревоЗапросов);
		Модифицированность = Ложь;

	Иначе // Формат файла не опознан
		Предупреждение("Невозможно загрузить список запросов из указанного файла!
					   |Выберите другой файл.");

	КонецЕсли;

	вУстановитьЗаголовокФормы();

КонецПроцедуры // ЗагрузитьЗапросыИзФайла()

// Сохраняет дерево запросов в файл
//
// Параметры:
//  ЗапрашиватьСохранение - признак необходимости предупрежедния перед сохранением
//	ЗапрашиватьИмяФайла - признак необходимости запроса имени файла.
//
Функция вСохранитьЗапросыВФайл(ЗапрашиватьСохранение = Ложь, ЗапрашиватьИмяФайла = Ложь)

	вСохранитьЗапросТекущейСтроки();

	Если Не ЗапрашиватьИмяФайла Тогда
		Если ЗапрашиватьСохранение Тогда
			Если Не Модифицированность Тогда
				Возврат Истина;
			Иначе
				Ответ = Вопрос("Сохранить текущие запросы?", РежимДиалогаВопрос.ДаНетОтмена);
				Если Ответ = КодВозвратаДиалога.Отмена Тогда
					Возврат Ложь;
				ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если ПустаяСтрока(мИмяФайла) или ЗапрашиватьИмяФайла Тогда

		Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);

		Длг.ПолноеИмяФайла = мИмяФайла;
		Длг.Каталог = мИмяПути;
		Длг.Заголовок = "Укажите файл для списка запросов";
		Длг.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
		Длг.Расширение = "sel";
		
		Если Длг.Выбрать() Тогда
			мИмяФайла = Длг.ПолноеИмяФайла;
			мИмяПути = Длг.Каталог;
		Иначе
			Возврат Ложь;
		КонецЕсли;

	КонецЕсли;

	ЗначениеВФайл(мИмяФайла, ДеревоЗапросов);
	Модифицированность = Ложь;
	вСохранитьИмяФайла();
	вУстановитьЗаголовокФормы();

	Возврат Истина;

КонецФункции // СохранитьЗапросыВФайл()

// Загружает результат запроса в таблицу или сводную таблицу
//
// Параметры:
//  Нет.
//
Процедура вЗагрузитьРезультат()
	
	Если мРезЗапроса <> Неопределено Тогда
		
		Если ЭлементыФормы.ПанельРезультата.ТекущаяСтраница.Имя = "Результат" Тогда
			Если мТаблицаЗагружена = Ложь Тогда
				ЭлементыФормы.ТаблицаРезультата.Колонки.Очистить();
				Если СпособВыгрузки = 2 Тогда // Дерево
					РезультатДерево = мРезЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
					ЭлементыФормы.ТаблицаРезультата.Данные = "РезультатДерево";
					ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
				Иначе // Список
					Если ТипЗнч(мРезЗапроса) = Тип("Массив") Тогда
						ТЗ = Новый ТаблицаЗначений;
						ТЗ.Колонки.Добавить("РезультатЗапроса"); 
						Для каждого ЭлемМассива Из мРезЗапроса Цикл
							НовСтрока = ТЗ.Добавить();
							НовСтрока.РезультатЗапроса = ЭлемМассива.Выгрузить();
						КонецЦикла;
						
						Если мКолВременныхТаблиц <> 0 Тогда
							ТЗ2 = Новый ТаблицаЗначений;
							ТЗ2.Колонки.Добавить("РезультатЗапроса"); 
                            ТекТаблица = ТЗ.Количество() - мКолВременныхТаблиц + 1;
							Пока ТекТаблица <> ТЗ.Количество() + 1 Цикл
								НовСтрока = ТЗ2.Добавить();
								НовСтрока.РезультатЗапроса = ТЗ[ТекТаблица-1].РезультатЗапроса;
								ТекТаблица = ТекТаблица + 1;
							КонецЦикла;
							ТЗ = ТЗ2;
						КонецЕсли; 
						
						РезультатТаблица = ТЗ;
					Иначе
						РезультатТаблица = мРезЗапроса.Выгрузить(ОбходРезультатаЗапроса.Прямой);
					КонецЕсли;
					
					ЭлементыФормы.ТаблицаРезультата.Данные = "РезультатТаблица";
					ЭлементыФормы.ТаблицаРезультата.СоздатьКолонки();
				КонецЕсли;
				мТаблицаЗагружена = Истина;
			КонецЕсли;
		ИначеЕсли ЭлементыФормы.ПанельРезультата.ТекущаяСтраница.Имя = "СводнаяТаблица" Тогда
			Если мСводнаяТаблицаЗагружена = Ложь Тогда
				Попытка
					ЭлементыФормы.РезультатТабДокСвод.ВстроенныеТаблицы.СводнаяТаблица.ИсточникДанных = мРезЗапроса;
				Исключение
				КонецПопытки;
				мСводнаяТаблицаЗагружена = Истина;
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
		
КонецПроцедуры // ЗагрузитьРезультат()

// Добавляет строки при копировании строки дерева запросов
//
// Параметры:
//  ТекСтрока - текущая строка
//	ДобСтрока - добавляемая строка
//	Дерево - дерево значений.
//
Процедура вДобавитьСтроки(ТекСтрока, ДобСтрока, Дерево)

	Для Каждого Кол Из Дерево.Колонки Цикл
		ДобСтрока[Кол.Имя] = ТекСтрока[Кол.Имя];
	КонецЦикла; 
	
	Для Каждого Строка Из ТекСтрока.Строки Цикл
		НоваяСтрока = ДобСтрока.Строки.Добавить();
		вДобавитьСтроки(Строка, НоваяСтрока, Дерево);
	КонецЦикла;

КонецПроцедуры // ДобавитьСтроки()

// Включает или отключает запуск автосохранения.
//
// Параметры:
//  Нет.
//
Процедура вОбработкаАвтосохранения()

	Если ИспользоватьАвтосохранение Тогда
		ПодключитьОбработчикОжидания("Сохранить", ИнтервалАвтосохранения);
	Иначе
		ОтключитьОбработчикОжидания("Сохранить");
	КонецЕсли;

КонецПроцедуры // ОбработкаАвтосохранения()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ

// Обработчик нажатия кнопки командной панели "Новый список запросов"
//
Процедура НовыйФайл()

	Если вСохранитьЗапросыВФайл(Истина) Тогда
		вСоздатьНовыйФайлЗапросов();
	КонецЕсли;

КонецПроцедуры // НовыйФайл()

// Обработчик нажатия кнопки командной панели "Открыть файл запросов"
//
Процедура ОткрытьФайл()

	Если вСохранитьЗапросыВФайл(Истина) Тогда

		Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
		Длг.ПолноеИмяФайла = мИмяФайла;
		Длг.Каталог = мИмяПути;
		Длг.Заголовок = "Выберите файл со списком запросов";
		Длг.Фильтр = "Файлы запросов (*.sel)|*.sel|Все файлы (*.*)|*.*";
		Длг.Расширение = "sel";
		
		Если Длг.Выбрать() Тогда
			мИмяФайла = Длг.ПолноеИмяФайла;
			мИмяПути = Длг.Каталог;
			вЗагрузитьЗапросыИзФайла();
			мТекущаяСтрока = НеОпределено;
			вСохранитьИмяФайла();
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОткрытьФайл()

// Обработчик нажатия кнопки командной панели "Сохранить"
//
Процедура Сохранить()

	вСохранитьЗапросыВФайл();

КонецПроцедуры // Сохранить()

// Обработчик нажатия кнопки командной панели "Сохранить как"
//
Процедура СохранитьКак()

	вСохранитьЗапросыВФайл(Ложь, Истина);

КонецПроцедуры // СохранитьКак()

// Обработчик нажатия кнопки командной панели "Настройка автосохранения"
//
Процедура Настройка()

	ФормаНастройкиАвтосохранения = ПолучитьФорму("ФормаНастройки");
	ФормаНастройкиАвтосохранения.ОткрытьМодально();

	вОбработкаАвтосохранения();

КонецПроцедуры // НастройкаАвтосохранения()

// Обработчик нажатия кнопки командной панели "Перенести в другую группу"
//
Процедура ПеренестиСтрокуДерева()

	ФормаВыбораСтрокиДереваЗапросов = ПолучитьФорму("ФормаВыбораСтрокиДереваЗапросов", ЭтаФорма);
	ФормаВыбораСтрокиДереваЗапросов.ЗакрыватьПриВыборе = Истина;

	ФормаВыбораСтрокиДереваЗапросов.ДеревоЗапросов = ДеревоЗапросов;
	ФормаВыбораСтрокиДереваЗапросов.ТекущаяСтрокаВладельца = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;
	ФормаВыбораСтрокиДереваЗапросов.ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;

	ФормаВыбораСтрокиДереваЗапросов.ОткрытьМодально();

КонецПроцедуры // ПеренестиСтрокуДерева()

// Обработчик нажатия кнопки командной панели "Выполнить"
//
Процедура ВыполнитьЗапрос(Элемент = Неопределено, Пакетный = Неопределено, ТекстЗапроса = Неопределено)

	вСохранитьЗапросТекущейСтроки();

	ОбъектЗапрос = Новый Запрос;
	ОбъектЗапрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Для каждого СтрокаПараметров Из мФормаПараметров.Параметры Цикл
		Если СтрокаПараметров.ЭтоВыражение Тогда
			ОбъектЗапрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, Вычислить(СтрокаПараметров.ЗначениеПараметра));
		Иначе
			ОбъектЗапрос.УстановитьПараметр(СтрокаПараметров.ИмяПараметра, СтрокаПараметров.ЗначениеПараметра);
		КонецЕсли;
	КонецЦикла;

	Если ТекстЗапроса <> Неопределено Тогда
		ОбъектЗапрос.Текст = ТекстЗапроса;
	Иначе
		ОбъектЗапрос.Текст = СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", "");
	КонецЕсли; 

	Если ПустаяСтрока(ОбъектЗапрос.Текст) Тогда
		Предупреждение("Не заполнен текст запроса!", 30);
		Возврат;
	КонецЕсли;

	Если мЯваСкрипт <> Неопределено Тогда
		ВремяНачала = мЯваСкрипт.Eval("(new Date()).valueOf()");
    КонецЕсли;
	
	Попытка
		Если Пакетный <> Неопределено Тогда
			мРезЗапроса = ОбъектЗапрос.ВыполнитьПакет();
		Иначе
			мРезЗапроса = ОбъектЗапрос.Выполнить();
		КонецЕсли;
		Если мЯваСкрипт <> Неопределено Тогда
			ВремяКонцаВыполнения = мЯваСкрипт.Eval("(new Date()).valueOf()");
	    КонецЕсли;
	
		мТаблицаЗагружена = Ложь;
		мСводнаяТаблицаЗагружена = Ложь;

		вЗагрузитьРезультат();
		Если мЯваСкрипт <> Неопределено Тогда
			Заголовок = "Консоль запросов. Время выполнения: " + Формат((ВремяКонцаВыполнения-ВремяНачала)/1000, "ЧДЦ=3; ЧРД=.; ЧН=0; ЧГ=") + " (www.chistov.spb.ru)";
		КонецЕсли;
	Исключение
		Предупреждение(Сред(ОписаниеОшибки(),69));
	КонецПопытки;

КонецПроцедуры // ВыполнитьЗапрос()

// Обработчик нажатия кнопки командной панели "Параметры"
//
Процедура Параметры()

	Если мФормаПараметров.Открыта() = Истина Тогда
		мФормаПараметров.Закрыть();
	Иначе
		мФормаПараметров.Открыть();
	КонецЕсли;

КонецПроцедуры // Параметры()

// Обработчик нажатия кнопки командной панели "Сохранить в табличный документ"
//
Процедура СохранитьРезультат()
	Перем ЗаголовокКолонки;

	Если мРезЗапроса <> Неопределено Тогда
		ТабДок = Новый ТабличныйДокумент;
		КоличествоКолонок = мРезЗапроса.Колонки.Количество();

		Выборка = мРезЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);

        ДетальнаяСтрока = ТабДок.ПолучитьОбласть(1, , 1, );
		ОбластьОбщихИтогов = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьОбщихИтогов.Область().Шрифт = Новый Шрифт(ОбластьОбщихИтогов.Область().Шрифт, , , Истина, , ,);
		ОбластьИерархическихЗаписей = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьИерархическихЗаписей.Область().Шрифт = Новый Шрифт(ОбластьИерархическихЗаписей.Область().Шрифт, , , Истина, , ,);
		ОбластьГрупповыхЗаписей = ТабДок.ПолучитьОбласть(1, , 1, );
	    ОбластьГрупповыхЗаписей.Область().Шрифт = Новый Шрифт(ОбластьГрупповыхЗаписей.Область().Шрифт, , , Истина, , ,);
		ОбластьЗаголвка = ТабДок.ПолучитьОбласть(1, , 1, );
		
		Для ТекущееПоле = 0 По КоличествоКолонок - 1 Цикл
			Область = ОбластьЗаголвка.Область(1, ТекущееПоле + 1);
			Область.Текст = мРезЗапроса.Колонки[ТекущееПоле].Имя;
            Область.ШиринаКолонки = мРезЗапроса.Колонки[ТекущееПоле].Ширина;
		КонецЦикла;
		ТабДок.Вывести(ОбластьЗаголвка);
		ОбластьЗаголвка = ТабДок.Область(1, 1, 1, КоличествоКолонок);
		
		ОбластьЗаголвка.Шрифт = Новый Шрифт(ОбластьЗаголвка.Шрифт, , , Истина, , ,);
		ОбластьЗаголвка.ЦветФона = Новый Цвет(255, 255, 0);
		ОбластьЗаголвка.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);

        ТабДок.НачатьАвтогруппировкуСтрок();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда 
				ИсходнаяСтрока = ОбластьГрупповыхЗаписей;
			ИначеЕсли Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда 
				ИсходнаяСтрока = ОбластьИерархическихЗаписей;
			ИначеЕсли Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ОбщийИтог Тогда 
				ИсходнаяСтрока = ОбластьОбщихИтогов;
			Иначе
				ИсходнаяСтрока = ДетальнаяСтрока;
			КонецЕсли;
				
			Для ТекущееПоле = 0 По КоличествоКолонок - 1 Цикл
				Область = ИсходнаяСтрока.Область(1, ТекущееПоле + 1);
				Область.Текст = Выборка[ТекущееПоле];
			КонецЦикла;
			ТабДок.Вывести(ИсходнаяСтрока, Выборка.Уровень());
		КонецЦикла;
		ТабДок.ЗакончитьАвтогруппировкуСтрок();

		ТабДок.Показать();
	КонецЕсли;
	
КонецПроцедуры // СохранитьРезультат()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ

// Обработчик выбора строки в дереве запросов
//
Процедура ДеревоЗапросовВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыполнитьЗапрос();

КонецПроцедуры // ДеревоЗапросовВыбор()

// Обработчик активизации строки в дереве запросов
//
Процедура ДеревоЗапросовПриАктивизацииСтроки(Элемент)

	НадоСохранять = Истина;
	
	Если мИдетДобавление Тогда
		Если мАктивизированаДобавляемаяЗапись Тогда

			// Произошла отмена добавления записи.
			НадоСохранять = Ложь;
			мАктивизированаДобавляемаяЗапись = Ложь;
		Иначе
			мАктивизированаДобавляемаяЗапись = Истина;
		КонецЕсли;
	КонецЕсли;

	Если НадоСохранять Тогда
		вСохранитьЗапросТекущейСтроки();
	КонецЕсли;

	мТекущаяСтрока = ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока;

	Если ДеревоЗапросов.Строки.Количество() <> 0 И мТекущаяСтрока <> НеОпределено Тогда

		вЗадатьТекстЗапроса(мТекущаяСтрока.ТекстЗапроса);

		Если НЕ ЕдиныеПараметрыДляВсехЗапрсов Тогда
			ИсходнаяТаблицаПараметров = мТекущаяСтрока.ПараметрыЗапроса;
			мФормаПараметров.Параметры.Очистить();
			Если Не ИсходнаяТаблицаПараметров = НеОпределено Тогда
				Для каждого СтрокаИсходнойТаблицы из ИсходнаяТаблицаПараметров Цикл
					НоваяСтрока = мФормаПараметров.Параметры.Добавить();
					НоваяСтрока[0] = СтрокаИсходнойТаблицы[0]; // Имя параметра
					НоваяСтрока[1] = СтрокаИсходнойТаблицы[1]; // Вид параметра
					НоваяСтрока[2] = СтрокаИсходнойТаблицы[2]; // Значение
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

        Если мТекущаяСтрока.СпособВыгрузки = Неопределено Тогда
			мТекущаяСтрока.СпособВыгрузки = 1;
		КонецЕсли;

		СпособВыгрузки = мТекущаяСтрока.СпособВыгрузки;

	Иначе

		вЗадатьТекстЗапроса("ВЫБРАТЬ
							|
							|ИЗ");
		Если НЕ ЕдиныеПараметрыДляВсехЗапрсов Тогда
			мФормаПараметров.Параметры.Очистить();
        КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ДеревоЗапросовПриАктивизацииСтроки()

// Обработчик события перед началом добавления строки в дереве запросов
//
Процедура ДеревоЗапросовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель)

	Если Копирование Тогда
		Отказ = Истина;
		ТекСтрока = Элемент.ТекущаяСтрока;
		Если ТекСтрока.Родитель <> Неопределено Тогда
			НоваяСтрока = ТекСтрока.Родитель.Строки.Добавить();
		Иначе
			НоваяСтрока = Элемент.Значение.Строки.Добавить();
		КонецЕсли; 
		вДобавитьСтроки(ТекСтрока, НоваяСтрока, Элемент.Значение);
	КонецЕсли; 
	
	мИдетДобавление = Истина;
	
КонецПроцедуры // ДеревоЗапросовПередНачаломДобавления()

// Обработчик события перед удалением строки в дереве запросов
//
Процедура ДеревоЗапросовПередУдалением(Элемент, Отказ)

	мТекущаяСтрока = НеОпределено;
	Модифицированность = Истина;

КонецПроцедуры // ДеревоЗапросовПередУдалением()

// Обработчик события при окончании редактирования строки в дереве запросов
//
Процедура ДеревоЗапросовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	Если НоваяСтрока и Элемент.ТекущаяСтрока.СпособВыгрузки = НеОпределено Тогда
		Элемент.ТекущаяСтрока.СпособВыгрузки = 1;
	КонецЕсли;

	ДеревоЗапросовПриАктивизацииСтроки(Элемент);

	Если мИдетДобавление Тогда

		Если ОтменаРедактирования Тогда
			мТекущаяСтрока = Неопределено;
		КонецЕсли;
		
		мИдетДобавление = Ложь;
	КонецЕсли;

	Модифицированность = Истина;

КонецПроцедуры // ДеревоЗапросовПриОкончанииРедактирования()

// Обработчик изменения способа выгрузки
//
Процедура СпособВыгрузкиПриИзменении(Элемент)

	Модифицированность = Истина;

КонецПроцедуры // СпособВыгрузкиПриИзменении()

// Обработчик выбора строки в таблице результата
//
Процедура ТаблицаРезультатаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
    СодержимоеЯчейки = ВыбраннаяСтрока[Колонка.Имя];

	Если ТипЗнч(СодержимоеЯчейки) = Тип("ТаблицаЗначений") Тогда
		ФормаВложеннойТаблицы = Обработка.ПолучитьФорму("ФормаВложеннойТаблицы", ЭтаФорма);
		ФормаВложеннойТаблицы.ВложеннаяТаблица = СодержимоеЯчейки;
		ФормаВложеннойТаблицы.ЭлементыФормы.ВложеннаяТаблица.СоздатьКолонки();
		ФормаВложеннойТаблицы.Открыть();
	Иначе
		ОткрытьЗначение(СодержимоеЯчейки);
	КонецЕсли;

КонецПроцедуры // ТаблицаРезультатаВыбор()

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события при открытии формы
//
Процедура ПриОткрытии()

	// Создадим структуру дерева запросов
	ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
	ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
	ДеревоЗапросов.Колонки.Добавить("СпособВыгрузки");

	// Попытаемся загрузить последний открывавшийся файл запросов
	вВосстановитьИмяФайла();
	Если ПустаяСтрока(мИмяФайла) Тогда
		вСоздатьНовыйФайлЗапросов();
	Иначе
		вЗагрузитьЗапросыИзФайла();
		мТекущаяСтрока = НеОпределено;
	КонецЕсли;

	ИспользоватьАвтосохранение = ВосстановитьЗначение("КонсольЗапросов_ИспользоватьАвтосохранение");
	ИнтервалАвтосохранения = ВосстановитьЗначение("КонсольЗапросов_ИнтервалАвтосохранения");
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Текст = "Выполнить запрос";
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Действие = Новый Действие("ВыполнитьЗапрос");
	вОбработкаАвтосохранения();

КонецПроцедуры // ПриОткрытии()

// Обработчик события выбора в подчиненной форме
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)

	НоваяСтрока = ЗначениеВыбора.Строки.Добавить();
	НоваяСтрока[0] = мТекущаяСтрока[0]; // Запрос
	НоваяСтрока[1] = мТекущаяСтрока[1]; // ТекстЗапроса
	НоваяСтрока[2] = мТекущаяСтрока[2]; // ПараметрыЗапроса
	НоваяСтрока[3] = мТекущаяСтрока[3]; // СпособВыгрузки

	вСкопироватьДеревоЗапросов(мТекущаяСтрока, НоваяСтрока);

    РодительТекущейСтроки = ?(мТекущаяСтрока.Родитель = НеОпределено, ДеревоЗапросов, мТекущаяСтрока.Родитель);
	РодительТекущейСтроки.Строки.Удалить(РодительТекущейСтроки.Строки.Индекс(мТекущаяСтрока));
	мТекущаяСтрока = НеОпределено;

	ЭлементыФормы.ДеревоЗапросов.ТекущаяСтрока = НоваяСтрока;

	Модифицированность = Истина;

КонецПроцедуры // ОбработкаВыбора()

// Обработчик события преред закрытием формы
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если вСохранитьЗапросыВФайл(Истина) Тогда
		СохранитьЗначение("КонсольЗапросов_ИспользоватьАвтосохранение", ИспользоватьАвтосохранение);
		СохранитьЗначение("КонсольЗапросов_ИнтервалАвтосохранения", ИнтервалАвтосохранения);
	Иначе
        СтандартнаяОбработка = Ложь;
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры // ПередЗакрытием()

// Обработчик события при смене страницы панели
//
Процедура ПанельРезультатаПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	вЗагрузитьРезультат();
	
КонецПроцедуры // ПанельРезультатаПриСменеСтраницы()

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
    ИспользоватьАвтосохранение = ВосстановитьЗначение("GROOVY_ИспользоватьАвтосохранение");
    ИнтервалАвтосохранения = ВосстановитьЗначение("GROOVY_ИнтервалАвтосохранения");
    ИспользоватьТолькоВыделеннуюОбласть = ВосстановитьЗначение("GROOVY_ИспользоватьТолькоВыделеннуюОбласть");
КонецПроцедуры

Процедура КоманднаяПанельТекстаЗапросаДобавитьПеренос(Кнопка)
    НовыйТекст = "";
    Для Ном = 1 По ЭлементыФормы.ТекстЗапроса.КоличествоСтрок() Цикл
    	НовыйТекст = НовыйТекст + "|" + ЭлементыФормы.ТекстЗапроса.ПолучитьСтроку(Ном) + Символы.ПС;
    КонецЦикла;
    
    ЭлементыФормы.ТекстЗапроса.УстановитьТекст(СокрЛП(НовыйТекст));
КонецПроцедуры

Процедура КоманднаяПанельТекстаЗапросаУбратьПеренос(Кнопка)
    ЭлементыФормы.ТекстЗапроса.УстановитьТекст(СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", ""));
КонецПроцедуры

Процедура КоманднаяПанельТекстаЗапросаПолучитьКод(Кнопка)
    пНазваниеЗапроса = "Запрос";
    Если НЕ ВвестиСтроку(пНазваниеЗапроса, "Введите Имя запроса") Тогда
    	Возврат;
    КонецЕсли; 
    КодЗапроса = пНазваниеЗапроса + " = Новый Запрос;" + Символы.ПС;
    НовыйТекст = "";
	Для Ном = 1 По ЭлементыФормы.ТекстЗапроса.КоличествоСтрок() Цикл
		Текст = СтрЗаменить(ЭлементыФормы.ТекстЗапроса.ПолучитьСтроку(Ном),"|","");
		Текст = СтрЗаменить(Текст, Символ(34), Символ(34) + Символ(34));
    	НовыйТекст = НовыйТекст + "|" + Текст + Символы.ПС;
    КонецЦикла;

    КодЗапроса = КодЗапроса + пНазваниеЗапроса + ".Текст = """ + Символы.ПС + СокрЛП(НовыйТекст) + """;" + Символы.ПС;
    ТекстЗапроса = СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", "");
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Предупреждение("Отсутствует текст запроса.");
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Попытка
		ПараметрыЗапроса = Запрос.НайтиПараметры();
	Исключение
		Предупреждение(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
    Для каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
        КодЗапроса = КодЗапроса + пНазваниеЗапроса+".УстановитьПараметр("""+ПараметрЗапроса.Имя+""","+Символы.Таб+"<"+ПараметрЗапроса.Имя+">);"+Символы.Таб+" //" + ПараметрЗапроса.ТипЗначения + Символы.ПС;
	КонецЦикла;

    КодЗапроса = КодЗапроса + "РезультатЗапроса = " + пНазваниеЗапроса + ".Выполнить();";
    ФормаКода = ПолучитьФорму("ФормаКодаЗапроса");
    ФормаКода.ЭлементыФормы.КодЗапроса.УстановитьТекст(КодЗапроса);
    ФормаКода.Открыть();
КонецПроцедуры

Процедура ВыборДействияВыполнитьЗапрос(Кнопка)
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Текст = "Выполнить запрос";
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Действие = Новый Действие("ВыполнитьЗапрос");
	ВыполнитьЗапрос();
КонецПроцедуры

Процедура ВыборДействияВыполнитьПакет(Кнопка)
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Текст = "Выполнить пакет";
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Действие = Новый Действие("ВыполнитьПакет");
	ВыполнитьПакет();
КонецПроцедуры

Процедура ВыборДействияПросмотрВременныхТаблиц(Кнопка)
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Текст = "Просмотр временных таблиц";
	ЭлементыФормы.КоманднаяПанельФормы.Кнопки.ДействиеПоУмолчанию.Действие = Новый Действие("ПросмотрВременныхТаблиц");
	ПросмотрВременныхТаблиц();
КонецПроцедуры

Процедура ВыполнитьПакет()
	ВыполнитьЗапрос(,Истина);
КонецПроцедуры

Процедура ПросмотрВременныхТаблиц()
	Текст = СокрЛП(ВРЕГ(СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", "")));
	Текст = СтрЗаменить(Текст, Символы.Таб, " ");
	Текст = СтрЗаменить(Текст, Символы.ПС, " ");
	ПервыйСимвол = Найти(Текст, "ПОМЕСТИТЬ ");
	Если ПервыйСимвол = 0 Тогда
		Предупреждение("В запросе не используются временные таблицы!",60); 
		Возврат;
	КонецЕсли; 
	
	СписокТаблиц = Новый Массив;
	Пока ПервыйСимвол <> 0 Цикл
		Стр = СокрЛП(Сред(Текст, ПервыйСимвол+10));
		ПоследнийСимвол = Найти(Стр, " ");
		Если ПоследнийСимвол <> 0 Тогда
			СписокТаблиц.Добавить(Сред(Стр,1, ПоследнийСимвол-1));
			Текст = Сред(Стр, ПоследнийСимвол + 1);
		Иначе
			СписокТаблиц.Добавить(Сред(Стр,1));
			Текст = "";
		КонецЕсли; 
		
		ПервыйСимвол = Найти(Текст, "ПОМЕСТИТЬ ");
	КонецЦикла; 
	
	ТекстЗапроса = СокрЛП(ВРЕГ(СтрЗаменить(вПолучитьТекстЗапроса(Истина), "|", ""))) + " ; ";
	Для каждого НазваниеТаблицы Из СписокТаблиц Цикл
		ТекстЗапроса = ТекстЗапроса + " ВЫБРАТЬ """ + НазваниеТаблицы + """ КАК НазваниеТаблицы, * ИЗ " + НазваниеТаблицы + " КАК " + НазваниеТаблицы + " ; ";
	КонецЦикла; 
	мКолВременныхТаблиц = СписокТаблиц.Количество();
	ВыполнитьЗапрос(, Истина, ТекстЗапроса);
	мКолВременныхТаблиц = 0;
КонецПроцедуры

Процедура КонтМенюСкрытьДеревоЗапросов(Кнопка)
	ЭлементыФормы.ДеревоЗапросов.Свертка = РежимСверткиЭлементаУправления.Лево;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мИмяФайла = "";
мИмяПути = "";

мЗаголовокФормы = Заголовок;

мТекущаяСтрока = НеОпределено;
мИдетДобавление = Ложь;
мАктивизированаДобавляемаяЗапись = Ложь;

мФормаПараметров = Обработка.ПолучитьФорму("ФормаПараметров", ЭтаФорма);
мФормаПараметров.РазрешитьСостояниеПрикрепленное = Истина;
мФормаПараметров.РазрешитьСостояниеПрячущееся = Ложь;
мФормаПараметров.РазрешитьСостояниеСвободное = Истина;
мТаблицаЗагружена = Ложь;
мСводнаяТаблицаЗагружена = Ложь;
мКолВременныхТаблиц = 0;

Попытка
	мЯваСкрипт = Новый COMОбъект("MSScriptControl.ScriptControl");
	мЯваСкрипт.Language = "javascript";
Исключение
	Сообщить("не возможно подключить MSScriptControl.ScriptControl, замер производительности отключен");
КонецПопытки;