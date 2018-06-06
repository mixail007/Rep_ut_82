﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФАЙЛАМИ ДЛЯ МЕХАНИЗМА ДОПРОЛНИТЕЛЬНОЙ ИНФОРМАЦИИ

// Открывает переданный файл на диске с учетом типа файлов. Файлы, с которыми 
// может работать 1С:Предприятие открываются в 1С:Предприятии. Остальные файлы
// пытаются открыться зарегистрированным для них в системе приложением.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
Процедура ОткрытьФайлДополнительнойИнформации(ИмяКаталога, ИмяФайла) Экспорт

	ПолноеИмяФайла = ПолучитьИмяФайла(ИмяКаталога, ИмяФайла);
	РасширениеФайла = Врег(ПолучитьРасширениеФайла(ИмяФайла));

	Если РасширениеФайла = "MXL" Тогда

		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ПолноеИмяФайла);
		ТабличныйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "TXT" Тогда

		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
		ТекстовыйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "EPF" Тогда

		ВнешняяОбработка = ВнешниеОбработки.Создать(ПолноеИмяФайла);
		ВнешняяОбработка.ПолучитьФорму().Открыть();

	Иначе

		ЗапуститьПриложение(ПолноеИмяФайла);

	КонецЕсли;

КонецПроцедуры // ОткрытьФайлДополнительнойИнформации()

// Составляет полное имя файла из имени каталога и имени файла.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
// Возвращаемое значение:
//   Строка – полное имя файла с учетом каталога.
//
Функция ПолучитьИмяФайла(ИмяКаталога, ИмяФайла) Экспорт

	Возврат ИмяКаталога + ?(ПустаяСтрока(ИмяФайла), "", "\" + ИмяФайла);

КонецФункции // ПолучитьИмяФайла()

// Формирует строку фильтра для диалога выбора файла с типами файлов.
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Строка – фильтр по типам файлов для диалога выбора файла.
//
Функция ПолучитьФильтрФайлов() Экспорт

	Возврат "Все файлы (*.*)|*.*|"
	      + "Документ Microsoft Word (*.doc)|*.doc|"
	      + "Документ Microsoft Excell (*.xls)|*.xls|"
	      + "Документ Microsoft PowerPoint (*.ppt)|*.ppt|"
	      + "Документ Microsoft Visio (*.vsd)|*.vsd|"
	      + "Письмо электронной почты (*.msg)|*.msg|"
	      + "Картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|"
	      + "Текстовый документ (*.txt)|*.txt|"
	      + "Табличный документ (*.mxl)|*.mxl|";

КонецФункции // ПолучитьФильтрФайлов()

// Формирует строку фильтра для диалога выбора картинки с типами файлов.
//
// Параметры
//  Нет.
//
// Возвращаемое значение:
//   Строка – фильтр по типам файлов для диалога выбора картинки.
//
Функция ПолучитьФильтрИзображений() Экспорт

	Возврат "Все картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf|" 
	      + "Формат bmp (*.bmp;*.dib;*.rle)|*.bmp;*.dib;*.rle|"
	      + "Формат jpeg (*.jpg;*.jpeg)|*.jpg;*.jpeg|"
	      + "Формат tiff (*.tif)|*.tif|"
	      + "Формат gif (*.gif)|*.gif|"
	      + "Формат png (*.png)|*.png|"
	      + "Формат icon (*.ico)|*.ico|"
	      + "Формат метафайл (*.wmf;*.emf)|*.wmf;*.emf|";

КонецФункции // ПолучитьФильтрИзображений()

// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьРасширениеФайла(ИмяФайла) Экспорт

	ПозицияПоследнейТочки = 0;
	РасширениеФайла = ИмяФайла;

	Пока 1 = 1 Цикл
	
		ПозицияПоследнейТочки = Найти(РасширениеФайла, ".");

		Если ПозицияПоследнейТочки = 0 Тогда

			Прервать;

		Иначе

			РасширениеФайла = Сред(РасширениеФайла, ПозицияПоследнейТочки + 1)

		КонецЕсли;

	КонецЦикла;

	Возврат ?(РасширениеФайла = ИмяФайла, "", РасширениеФайла);

КонецФункции // ПолучитьРасширениеФайла()

// Формирует имя каталога для сохранения/чтения файлов. Для различных типов объектов возможны 
// различные алгоритмы определения каталога.
//
// Параметры
//  ОбъектФайла  – Ссылка на объект данных, для которого прикрепляются файлы.
//  ТекущийПользователь - Ссылка на справочник Пользователи, с текущим пользователем
//                 конфигурации.
//
// Возвращаемое значение:
//   Строка – каталог файлов для указанного объекта и пользователя.
//
Функция ПолучитьИмяКаталога(ТекущийПользователь) Экспорт

	// Получим рабочий каталог из свойств пользователя.
	РабочийКаталог = ПолучитьЗначениеПоУмолчанию(ТекущийПользователь,"ОсновнойКаталогФайлов");

	// Если рабочий каталог не указан получим каталог временных файлов прогаммы
	Если ПустаяСтрока(РабочийКаталог) Тогда
		РабочийКаталог = КаталогВременныхФайлов();
	КонецЕсли;

	// Так как при различных указаниях рабочего каталога возможно наличие или отсутствие
	// последнего слеша, приведем строку каталога к унифицированному виду - без слеша на конце.
	Если Прав(РабочийКаталог, 1) = "\" Тогда
		РабочийКаталог = Лев(РабочийКаталог, СтрДлина(РабочийКаталог) - 1);
	КонецЕсли;

	Возврат РабочийКаталог;

КонецФункции // ПолучитьИмяКаталога()

// Проверяет наличие каталога на диске и предлагает создать, если каталога не существует.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//
// Возвращаемое значение:
//   Булево – Истина, если каталог существует или создан, Ложь, если каталога нет.
//
Функция ПроверитьСуществованиеКаталога(ИмяКаталога) Экспорт

	КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если КаталогНаДиске.Существует() Тогда
		Возврат Истина;
	Иначе
		Ответ = Вопрос("Указанный каталог не существует. Создать каталог?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			СоздатьКаталог(ИмяКаталога);
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;

КонецФункции // ПроверитьСуществованиеКаталога()

// Позволяет пользователю выбрать каталог на диске.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая начальный путь к каталогу на диске.
//
// Возвращаемое значение:
//   Булево – Истина, если каталог выбран, Ложь, если нет.
//
Функция ВыбратьКаталог(ИмяКаталога) Экспорт

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Укажите каталог";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = ИмяКаталога;

	Если Диалог.Выбрать() Тогда
		ИмяКаталога = Диалог.Каталог;
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции // ВыбатьКаталог()

// Сохраняет файл на диске.
//
// Параметры
//  Хранилище    – ХранилищеЗначения, которое содержит объект типа 
//                 ДвоичныеДанные с файлом для записи на диск.
//  ИмяФайла     – Строка, содержащая полное имя файла.
//  ТолькоЧтение – Булево, признак установки записываемому файлу атрибута ТолькоЧтение.
//  СпособПерезаписи – Строка. Параметр определеляет способ перезаписи существующих
//                 файлов на диске. В зависимости от пришедшего параметра выдается или
//                 не выдается запрос на перезапись файлов. Может устанавливаться в теле
//                 функции, если это необходимо. Принимаемые значения:
//                 "" (пустая строка) - это означает, что диалог еще ни разу не задавался
//                 и при наличии существующего файла будет выдан диалог запроса перезаписи.
//                 ДА - предыдущий файл был перезаписан, но перезапись текущего надо 
//                 запросить снова
//                 НЕТ - предыдущий файл не был перезаписан, но перезапись текущего надо 
//                 запросить снова
//                 ДАДЛЯВСЕХ - предыдущий файл был перезаписан, и все последующие тоже 
//                 надо перезаписывать.
//                 НЕТДЛЯВСЕХ - предыдущий файл не был перезаписан, и все последующие тоже 
//                 не надо перезаписывать.
//
// Возвращаемое значение:
//   Булево – Истина, если каталог выбран, Ложь, если нет.
//
Функция СохранитьФайлНаДиске(Хранилище, ИмяФайла, ТолькоЧтение, СпособПерезаписи, ВопросОПерезаписи = Истина, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Попытка

		ФайлНаДиске = Новый Файл(ИмяФайла);
		КаталогНаДиске = Новый Файл(ФайлНаДиске.Путь);

		Если Не КаталогНаДиске.Существует() Тогда
			СоздатьКаталог(ФайлНаДиске.Путь);
		КонецЕсли;

		Если ФайлНаДиске.Существует() И ВопросОПерезаписи = Истина Тогда

			Если СпособПерезаписи = ""
			 ИЛИ Врег(СпособПерезаписи) = "ДА"
			 ИЛИ Врег(СпособПерезаписи) = "НЕТ" Тогда

				ФормаЗапросаПерезаписиФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаЗапросаПерезаписиФайлов");
				ФормаЗапросаПерезаписиФайлов.ТекстПредупреждения = 
				    "На локальном диске уже существует файл:
				    |" + ИмяФайла + "
				    |Перезаписать имеющийся файл?";
				СпособПерезаписи = ФормаЗапросаПерезаписиФайлов.ОткрытьМодально();

				Если СпособПерезаписи = Неопределено
				 ИЛИ Врег(СпособПерезаписи) = "НЕТ"
				 ИЛИ Врег(СпособПерезаписи) = "НЕТДЛЯВСЕХ" Тогда
					Возврат Ложь;
				КонецЕсли;

			ИначеЕсли Врег(СпособПерезаписи) = "НЕТДЛЯВСЕХ" Тогда

				Возврат Ложь;

			КонецЕсли;

			// Если существующему файлу установлено ТолькоЧтение, отменим эту установку.
			Если ФайлНаДиске.ПолучитьТолькоЧтение() Тогда
				ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
			КонецЕсли;

		КонецЕсли;

		// Остались случаи когда:
		// - пользователь ответил Да или ДаДляВсех в текущем диалоге
		// - способ перезаписи уже пришел со значением ДаДляВсех
		Если ТипЗнч(Хранилище) <> Тип("ДвоичныеДанные") Тогда
			ДвоичныеДанные = Хранилище.Получить();
		Иначе
			ДвоичныеДанные = Хранилище;
		КонецЕсли; 
		ДвоичныеДанные.Записать(ИмяФайла);
		ФайлНаДиске.УстановитьТолькоЧтение(ТолькоЧтение);

	Исключение

		Предупреждение(ОписаниеОшибки());
		Возврат Ложь;

	КонецПопытки;

	Возврат Истина;

КонецФункции // СохранитьФайлНаДиске()

// Проверяет наличие запрещенных в среде MS Windows символов в имени файла.
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, без каталога.
//
// Возвращаемое значение:
//   Булево – Истина, если есть запрещенные символы, Ложь, если нет.
//
Функция ЕстьЗапрещенныеСимволыИмени(ИмяФайла) Экспорт

	Если Найти(ИмяФайла,  "\") > 0
	 ИЛИ Найти(ИмяФайла,  "/") > 0
	 ИЛИ Найти(ИмяФайла,  ":") > 0
	 ИЛИ Найти(ИмяФайла,  "*") > 0
	 ИЛИ Найти(ИмяФайла,  "&") > 0
	 ИЛИ Найти(ИмяФайла, """") > 0
	 ИЛИ Найти(ИмяФайла,  "<") > 0
	 ИЛИ Найти(ИмяФайла,  ">") > 0
	 ИЛИ Найти(ИмяФайла,  "|") > 0 Тогда

		Возврат Истина;

	Иначе

		Возврат Ложь;

	КонецЕсли;

КонецФункции // ЕстьЗапрещенныеСимволыИмени()

// Проверяет возможность измененния расширения в имени файла. Выдает запрос пользователю
// на смену расширения.
//
// Параметры
//  ТекущееРасширение – Строка, содержащая текущее расширение файла, до изменения.
//  НовоеРасширение – Строка, содержащая новое расширение файла, после изменения.
//
// Возвращаемое значение:
//   Булево – Истина, если пользователь запретил изменение расширения, Ложь, если разрешил.
//
Функция НельзяИзменятьРасширение(ТекущееРасширение, НовоеРасширение) Экспорт

	Если Не ПустаяСтрока(ТекущееРасширение) И Не НовоеРасширение = ТекущееРасширение Тогда

		Ответ = Вопрос("Вы действительно хотите измерить расширение", РежимДиалогаВопрос.ДаНет);

		Если Ответ = КодВозвратаДиалога.Да Тогда

			Возврат Ложь;

		Иначе

			Возврат Истина;

		КонецЕсли;

	Иначе

		Возврат Ложь;

	КонецЕсли;

КонецФункции // НельзяИзменятьРасширение()

// Создает и устанавливает реквизиты диалога выбора фала.
//
// Параметры
//  МножественныйВыбор – Булево, признак множественного выбора.
//  НачальныйКаталог – Строка, содержащая начальный каталог выбора файла.
//
// Возвращаемое значение:
//   ДиалогВыбораФайлов – созданный диалог.
//
Функция ПолучитьДиалогВыбораФайлов(МножественныйВыбор, НачальныйКаталог = "") Экспорт

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = НачальныйКаталог;
	Диалог.Заголовок = "Выберите файл...";
	Диалог.Фильтр = ПолучитьФильтрФайлов();
	Диалог.ПредварительныйПросмотр = Истина;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор = МножественныйВыбор;

	Возврат Диалог;

КонецФункции // ПолучитьДиалогВыбораФайлов()

// Выбор файлов пользователем на диске и добавление их объекту.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ТекущийПользователь - Ссылка на справочник Пользователи, с текущим пользователем
//                 конфигурации.
//  ВидДанных    - ПеречислениеСсылка.ВидыДополнительнойИнформацииОбъектов содержащая вид
//                 дополнительной информации объекта.
//
Процедура ДобавитьФайлы(ОбъектФайла, ТекущийПользователь, ВидДанных, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Если Не ОбъектФайла = Неопределено И ОбъектФайла.Пустая() Тогда
		Предупреждение("Необходимо записать объект, которому принадлежит файл.");
		Возврат;
	КонецЕсли;

	Диалог = ПолучитьДиалогВыбораФайлов(Истина);

	Если Не Диалог.Выбрать() Тогда
		Возврат;
	КонецЕсли;

	Для каждого ПолученноеИмяФайла Из Диалог.ВыбранныеФайлы Цикл

		ПолученныйФайл = Новый Файл(ПолученноеИмяФайла);
		Состояние("Добавляется файл: " + ПолученныйФайл.Имя);

		НачатьТранзакцию();
		
		Отказ = Ложь;
		
		НовыйФайл = Справочники[ИмяСправочника].СоздатьЭлемент();
		НовыйФайл.Объект = ОбъектФайла;
		НовыйФайл.ИмяФайла = ПолученныйФайл.Имя;
		Если ИмяСправочника = "ХранилищеДополнительнойИнформации" Тогда
			НовыйФайл.ВидДанных = ВидДанных;
		КонецЕсли; 

		Попытка
			НовыйФайл.Хранилище = Новый ХранилищеЗначения(Новый ДвоичныеДанные(ПолученныйФайл.ПолноеИмя), Новый СжатиеДанных());
			НовыйФайл.Записать();
		Исключение
			Предупреждение("Файл: " + ПолученныйФайл.ПолноеИмя + Символы.ПС + ОписаниеОшибки() + Символы.ПС + "Файл не добавлен.");
			Отказ = Истина;
		КонецПопытки;
		
		Если Отказ Тогда
			ОтменитьТранзакцию();
		Иначе
			ЗафиксироватьТранзакцию();
		КонецЕсли; 

	КонецЦикла;

КонецПроцедуры // ДобавитьФайлы()

// Сохранение на диск отмеченных файлов объекта.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ТекущийПользователь - Ссылка на справочник Пользователи, с текущим пользователем
//                 конфигурации.
//  ВыделенныеСтроки - ВыделенныеСтроки табличного поля со справочником дополнительной
//                 информации.
//
Процедура СохранитьФайлы(ОбъектФайла, ТекущийПользователь, ВыделенныеСтроки, ИмяКаталога = Неопределено, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ФормаСохраненияФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаСохраненияФайлов");
	ФормаСохраненияФайлов.ИмяКаталога    = ИмяКаталога;
	ФормаСохраненияФайлов.ТолькоЧтение   = Ложь;

	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ПолучитьИмяКаталога(ТекущийПользователь);
		ФормаСохраненияФайлов.ОткрытьКаталог = Истина;
	Иначе
		ФормаСохраненияФайлов.ОткрытьКаталог = Ложь;
	КонецЕсли; 

	СтруктураПараметров = ФормаСохраненияФайлов.ОткрытьМодально();
	
	Если СтруктураПараметров = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Не ПроверитьСуществованиеКаталога(СтруктураПараметров.ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;

	СпособПерезаписи = "";

	Для каждого СсылкаФайл из ВыделенныеСтроки Цикл

		Состояние("Сохраняется файл: " + СсылкаФайл.ИмяФайла);

		ИмяФайла = ПолучитьИмяФайла(СтруктураПараметров.ИмяКаталога, СсылкаФайл.ИмяФайла);
		СохранитьФайлНаДиске(СсылкаФайл.Хранилище, ИмяФайла, СтруктураПараметров.ТолькоЧтение, СпособПерезаписи);

		Если СпособПерезаписи = Неопределено Тогда
			Прервать;
		КонецЕсли; 

	КонецЦикла;

	Если СтруктураПараметров.ОткрытьКаталог Тогда
		ЗапуститьПриложение(СтруктураПараметров.ИмяКаталога);
	КонецЕсли;

КонецПроцедуры // СохранитьФайлы()

// Открывает переданный файл на диске с учетом типа файлов. Файлы, с которыми 
// может работать 1С:Предприятие открываются в 1С:Предприятии. Остальные файлы
// пытаются открыться зарегистрированным для них в системе приложением.
//
// Параметры
//  ИмяКаталога  – Строка, содержащая путь к каталогу файла на диске.
//  ИмяФайла     – Строка, содержащая имя файла, без имени каталога.
//
Процедура ОткрытьФайл(ИмяКаталога, ИмяФайла)

	ПолноеИмяФайла = ПолучитьИмяФайла(ИмяКаталога, ИмяФайла);
	РасширениеФайла = Врег(ПолучитьРасширениеФайла(ИмяФайла));

	Если РасширениеФайла = "MXL" Тогда

		ТабличныйДокумент = Новый ТабличныйДокумент;
		ТабличныйДокумент.Прочитать(ПолноеИмяФайла);
		ТабличныйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "TXT" Тогда

		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ПолноеИмяФайла);
		ТекстовыйДокумент.Показать(ИмяФайла, Лев(ИмяФайла, СтрДлина(ИмяФайла) - 4));

	ИначеЕсли РасширениеФайла = "EPF" Тогда

		ВнешняяОбработка = ВнешниеОбработки.Создать(ПолноеИмяФайла);
		ВнешняяОбработка.ПолучитьФорму().Открыть();

	Иначе

		ЗапуститьПриложение(ПолноеИмяФайла);

	КонецЕсли;

КонецПроцедуры // ОткрытьФайл()

// Сохранение на диск отмеченных файлов объекта и их открытие.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  ТекущийПользователь - Ссылка на справочник Пользователи, с текущим пользователем
//                 конфигурации.
//  ВыделенныеСтроки - ВыделенныеСтроки табличного поля со справочником дополнительной
//                 информации.
//
Процедура ОткрытьФайлы(ОбъектФайла, ТекущийПользователь, ВыделенныеСтроки = Неопределено, ВопросОПерезаписи = Истина) Экспорт

	Если ВыделенныеСтроки = Неопределено Тогда
		
		Если ОткрытьФайлMSG(ОбъектФайла, ТекущийПользователь) Тогда
			Возврат;
		КонецЕсли; 
		
		ИмяКаталога = ПолучитьИмяКаталога(ТекущийПользователь);
		ТолькоЧтение = Ложь;

		СпособПерезаписи = "";

		Состояние("Сохраняется файл: " + ОбъектФайла.ИмяФайла);

		ИмяФайла = ПолучитьИмяФайла(ИмяКаталога, ОбъектФайла.ИмяФайла);
		СохранитьФайлНаДиске(ОбъектФайла.Хранилище, ИмяФайла, Ложь, СпособПерезаписи, ВопросОПерезаписи);

		Если СпособПерезаписи = Неопределено Тогда
			Возврат;
		КонецЕсли;

		ОткрытьФайлДополнительнойИнформации(ИмяКаталога, ОбъектФайла.ИмяФайла);
		
	Иначе
		
		Если ВыделенныеСтроки.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		ИмяКаталога = ПолучитьИмяКаталога(ТекущийПользователь);
		ТолькоЧтение = Ложь;

		СпособПерезаписи = "";

		Для каждого СсылкаФайл из ВыделенныеСтроки Цикл

			Если ОткрытьФайлMSG(СсылкаФайл, ТекущийПользователь) Тогда
				Возврат;
			КонецЕсли; 
			
			Состояние("Сохраняется файл: " + СсылкаФайл.ИмяФайла);

			ИмяФайла = ПолучитьИмяФайла(ИмяКаталога, СсылкаФайл.ИмяФайла);
			СохранитьФайлНаДиске(СсылкаФайл.Хранилище, ИмяФайла, Ложь, СпособПерезаписи, ВопросОПерезаписи);

			Если СпособПерезаписи = Неопределено Тогда
				Прервать;
			КонецЕсли;

			ОткрытьФайлДополнительнойИнформации(ИмяКаталога, СсылкаФайл.ИмяФайла);

		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры // ОткрытьФайлы()

// Получает индекс пиктограммы файла из коллекции пиктограмм в зависимости от расширения файла.
//
// Параметры
//  РасширениеФайла – Строка, содержащая расширение файла.
//
// Возвращаемое значение:
//   Число – индекс пиктограммы в коллекции.
//
Функция ПолучитьИндексПиктограммыФайла(РасширениеФайла) Экспорт

	РасширениеФайла = Врег(РасширениеФайла);

	Если Найти(",1CD,CF,CFU,DT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 1;
	ИначеЕсли "MXL" = РасширениеФайла Тогда
		Возврат 2;
	ИначеЕсли "TXT" = РасширениеФайла Тогда
		Возврат 3;
	ИначеЕсли "EPF" = РасширениеФайла Тогда
		Возврат 4;
	ИначеЕсли Найти(",BMP,DIB,RLE,JPG,JPEG,TIF,GIF,PNG,ICO,WMF,EMF,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 5;
	ИначеЕсли Найти(",HTM,HTML,MHT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 6;
	ИначеЕсли "DOC" = РасширениеФайла Тогда
		Возврат 7;
	ИначеЕсли "XLS" = РасширениеФайла Тогда
		Возврат 8;
	ИначеЕсли "PPT" = РасширениеФайла Тогда
		Возврат 9;
	ИначеЕсли "VSD" = РасширениеФайла Тогда
		Возврат 10;
	ИначеЕсли "MPP" = РасширениеФайла Тогда
		Возврат 11;
	ИначеЕсли "MDB" = РасширениеФайла Тогда
		Возврат 12;
	ИначеЕсли "XML" = РасширениеФайла Тогда
		Возврат 13;
	ИначеЕсли "MSG" = РасширениеФайла Тогда
		Возврат 14;
	ИначеЕсли Найти(",RAR,ZIP,ARJ,CAB,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 15;
	ИначеЕсли Найти(",EXE,COM,,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат 16;
	ИначеЕсли "BAT" = РасширениеФайла Тогда
		Возврат 17;
	Иначе
		Возврат 0;
	КонецЕсли;

КонецФункции // ПолучитьИндексПиктограммыФайла()

// Получает картинку файла из библиотеки картинок в зависимости от расширения файла.
//
// Параметры
//  РасширениеФайла – Строка, содержащая расширение файла.
//
// Возвращаемое значение:
//   Картинка.
//
Функция ПолучитьПиктограммуФайла(РасширениеФайла) Экспорт

	РасширениеФайла = Врег(РасширениеФайла);

	Если Найти(",1CD,CF,CFU,DT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_1С;
	ИначеЕсли "MXL" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MXL;
	ИначеЕсли "TXT" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_TXT;
	ИначеЕсли "EPF" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_EPF;
	ИначеЕсли Найти(",BMP,DIB,RLE,JPG,JPEG,TIF,GIF,PNG,ICO,WMF,EMF,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_BMP;
	ИначеЕсли Найти(",HTM,HTML,MHT,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_HTML;
	ИначеЕсли Найти(",DOC,RTF,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_Word;
	ИначеЕсли "XLS" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_Excel;
	ИначеЕсли "PPT" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_PowerPoint;
	ИначеЕсли "VSD" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_VSD;
	ИначеЕсли "MPP" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MPP;
	ИначеЕсли "MDB" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MDB;
	ИначеЕсли "XML" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_XML;
	ИначеЕсли "MSG" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_MSG;
	ИначеЕсли Найти(",RAR,ZIP,ARJ,CAB,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_WinRar;
	ИначеЕсли Найти(",EXE,COM,", "," + РасширениеФайла + ",") > 0 Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_EXE;
	ИначеЕсли "BAT" = РасширениеФайла Тогда
		Возврат БиблиотекаКартинок.ПиктограммаФайла_BAT;
	Иначе
		Возврат БиблиотекаКартинок.ПиктограммаФайла_НеОпределен;
	КонецЕсли;

КонецФункции // ПолучитьПиктограммуФайла()

// Функция определяет, есть ли у объекта элементы в хранилище дополнительной информации
//
// Параметры
//  Объект - СправочникСсылка, ДокументСсылка, объект для которого определяем наличие файлов
//
// Возвращаемое значение:
//   Булево
//
Функция ЕстьДополнительнаяИнформация(Объект, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	ЗначениеНайдено = Ложь;
	
	Если НЕ ЗначениеНеЗаполнено(Объект) Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Объект", Объект);
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ХранилищеДополнительнойИнформации.Ссылка,
		|	ХранилищеДополнительнойИнформации.ЗначениеРазделенияДоступа,
		|	ХранилищеДополнительнойИнформации.Объект
		|ИЗ
		|	Справочник." + ИмяСправочника + " КАК ХранилищеДополнительнойИнформации
		|ГДЕ
		|	ХранилищеДополнительнойИнформации.Объект = &Объект
		|";
		ЗначениеНайдено = НЕ Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат ЗначениеНайдено;
	
КонецФункции

// Изменяет картинку у кнопки открытия формы списка файлов и изображений.
//
// Параметры
//  ОбъектФайла  - Ссылка на объект данных, для которого прикрепляются файлы.
//  КнопкаОткрытияФайлов - Кнопка тулбара, по нажатию которой открывается
//  форма списка файлов и изображений.
//
Процедура ПолучитьКартинкуКнопкиОткрытияФайлов(ОбъектФайла, СписокКнопокОткрытияФайлов) Экспорт

	КартинкаКнопки = ?(ЕстьДополнительнаяИнформация(ОбъектФайла), БиблиотекаКартинок.ТолькоСкрепка, БиблиотекаКартинок.НевидимаяСкрепка);
	Для каждого КнопкаОткрытияФайлов Из СписокКнопокОткрытияФайлов Цикл
		КнопкаОткрытияФайлов.Значение.Отображение = ОтображениеКнопкиКоманднойПанели.НадписьКартинка;
		КнопкаОткрытияФайлов.Значение.Картинка    = КартинкаКнопки;
	КонецЦикла; 

КонецПроцедуры // ПолучитьКартинкуКнопкиОткрытияФайлов()

// Процедура открывает форму файлов и изображений по объекту отбора
//
Процедура ОткрытьФормуСпискаФайловИИзображений(СтруктураДляСпискаИзображений, СтруктураДляСпискаДополнительныхФайлов, ОбязательныеОтборы, ФормаВладелец, ИмяСправочника = "ХранилищеДополнительнойИнформации") Экспорт

	ФормаФайлов = Справочники[ИмяСправочника].ПолучитьФорму("ФормаСпискаФайловИИзображений", ФормаВладелец);
	
	// Изображения
	Если СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") Тогда
		ФормаФайлов.Изображения.Отбор.Объект.Использование = СтруктураДляСпискаИзображений.ОтборОбъектИспользование;
		ФормаФайлов.Изображения.Отбор.Объект.Значение      = СтруктураДляСпискаИзображений.ОтборОбъектЗначение;
	КонецЕсли;
	Если СтруктураДляСпискаИзображений.Свойство("ДоступностьОтбораОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.Изображения.НастройкаОтбора.Объект.Доступность = СтруктураДляСпискаИзображений.ДоступностьОтбораОбъекта;
	КонецЕсли; 
	Если СтруктураДляСпискаИзображений.Свойство("ВидимостьКолонкиОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.Изображения.Колонки.Объект.Видимость = СтруктураДляСпискаИзображений.ВидимостьКолонкиОбъекта;
	КонецЕсли; 

	// Дополнительные файлы
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ОтборОбъектИспользование") Тогда
		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Использование = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектИспользование;
		ФормаФайлов.ДополнительныеФайлы.Отбор.Объект.Значение      = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектЗначение;
	КонецЕсли;
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ДоступностьОтбораОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.НастройкаОтбора.Объект.Доступность = СтруктураДляСпискаДополнительныхФайлов.ДоступностьОтбораОбъекта;
	КонецЕсли; 
	Если СтруктураДляСпискаДополнительныхФайлов.Свойство("ВидимостьКолонкиОбъекта") Тогда
		ФормаФайлов.ЭлементыФормы.ДополнительныеФайлы.Колонки.Объект.Видимость = СтруктураДляСпискаДополнительныхФайлов.ВидимостьКолонкиОбъекта;
	КонецЕсли; 
	
	ФормаФайлов.ОбязательныеОтборы = ОбязательныеОтборы;
	
	Если СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") И СтруктураДляСпискаИзображений.Свойство("ОтборОбъектИспользование") Тогда
		Если СтруктураДляСпискаИзображений.ОтборОбъектЗначение = СтруктураДляСпискаДополнительныхФайлов.ОтборОбъектЗначение Тогда
			ФормаФайлов.Заголовок = "Хранилище дополнительной информации (" + СокрЛП(Строка(СтруктураДляСпискаИзображений.ОтборОбъектЗначение)) + ")";
		КонецЕсли;
	КонецЕсли; 
	
	ФормаФайлов.Открыть();

КонецПроцедуры

// Открывает форму основного изображения объекта
//
// Параметры
//  ФормаВладелец – Форма – определяет форму владельца открываемой формы
//  ОсновноеИзображение – СправочникСсылка.ХранилищеДополнительнойИнформации – содержит 
//                 ссылку на основное изображение объеата
//
Процедура ОткрытьФормуИзображения(ФормаВладелец, ОсновноеИзображение, ОбъектВладелец) Экспорт

	Если ОсновноеИзображение = Неопределено ИЛИ ОсновноеИзображение.Пустая() Тогда
			
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Заголовок = "Выберите файл с изображением";
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.ПредварительныйПросмотр = Истина;
		ДиалогОткрытияФайла.Фильтр = ПолучитьФильтрИзображений();

		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ВыбранноеИзображение = Новый Картинка(ДиалогОткрытияФайла.ПолноеИмяФайла, Ложь);
		Иначе
			Возврат;
		КонецЕсли;
		
		НовыйОбъект = Справочники.ХранилищеДополнительнойИнформации.СоздатьЭлемент();
		НовыйОбъект.ВидДанных = Перечисления.ВидыДополнительнойИнформацииОбъектов.Изображение;
		НовыйОбъект.Хранилище = Новый ХранилищеЗначения(ВыбранноеИзображение, Новый СжатиеДанных);
		НовыйОбъект.Объект = ОбъектВладелец;
		
		ФормаИзображения = НовыйОбъект.ПолучитьФорму("ФормаИзображения");
		
	Иначе
		
		ФормаИзображения = ОсновноеИзображение.ПолучитьФорму("ФормаИзображения");
		
	КонецЕсли;
	
	ФормаИзображения.ВладелецФормы = ФормаВладелец;
	ФормаИзображения.РежимВыбора = Истина;
	ФормаИзображения.ЗакрыватьПриВыборе = Ложь;
	ФормаИзображения.Открыть();
	
КонецПроцедуры // ОткрытьФормуИзображения()
