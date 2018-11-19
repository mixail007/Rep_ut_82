﻿

Процедура ПолеВвода1НачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = "\\Terminal\ОТДЕЛ ДИСКОВ\ПРАЙСЫ!!!!!!!!!!";
	если Диалог.выбрать() тогда
		ИмяШаблона = Диалог.ПолноеИмяФайла;
	КонецЕсли;	

КонецПроцедуры

Процедура ИмяНовогоФайлаНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ЛОЖЬ;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Каталог = "\\Terminal\ОТДЕЛ ДИСКОВ\ПРАЙСЫ!!!!!!!!!!";
	если Диалог.выбрать() тогда
		ИмяНовогоФайла = Диалог.ПолноеИмяФайла;
	КонецЕсли;	

КонецПроцедуры



Процедура КоманднаяПанель2Обновить(Кнопка)
	ЗаполнитьДеревоТоваров();
КонецПроцедуры

//=======================================================================
Процедура Кнопка1Нажатие(Элемент)
	
	Ответ = КодВозвратаДиалога.Да;
	
	Если СписокМоделей.Количество()>0 тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Список моделей уже заполнен.
		|Очистить список перед заполнением?", Режим, 30);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			СписокМоделей.Очистить();		
		Иначе
			Предупреждение("Возможно дублирование моделей!", 10);
		КонецЕсли;
	КонецЕсли;
	
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СписокМоделей = НайтиМоделиПоКодам();
    Иначе
		СписокМоделейНов = НайтиМоделиПоКодам();
		Для i=0 по СписокМоделейНов.Количество()-1 цикл
        СписокМоделей.Добавить(СписокМоделейНов[i].Значение);
        КонецЦикла;
        СписокМоделей.СортироватьПоПредставлению();//по названию!
	КонецЕсли;	
	
	ЗаполнитьДеревоТоваров();

КонецПроцедуры


функция НайтиМоделиПоКодам()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Номенклатура.Модель КАК Модель
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Код В (&СписокКодов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Модель.Наименование";
	
	СписокКодов1C = новый СписокЗначений;
	стр = СписокКодов;
	
	СимвРазделитель = символ(10); //#10 #13
	i= найти(стр, СимвРазделитель);
	пока i>0 цикл
		стр1 = лев(стр, i-1);
		СписокКодов1C.Добавить( СокрЛП(стр1) );
		
		стр  = прав(стр, стрДлина(стр)-i);
		i= найти(стр, СимвРазделитель);
 	КонецЦикла;
	
	Запрос.УстановитьПараметр("СписокКодов", СписокКодов1C);
	
	Результат = Запрос.Выполнить();
	таб = Результат.Выгрузить();
	
	СписМод = новый СписокЗначений;
	СписМод.ЗагрузитьЗначения( таб.ВыгрузитьКолонку("Модель") );
	возврат СписМод; 
КонецФункции	


Процедура ЗаполнитьДеревоТоваров()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА НЕ &ТолькоПоСпискуКодов тогда Истина
				   |		ИНАЧЕ Выбор Когда СпрНоменклатура.Ссылка.Код В (&СписокКодов)
	               |					ТОГДА ИСТИНА
	               |					ИНАЧЕ ЛОЖЬ
				   |		КОНЕЦ 	
	               |	КОНЕЦ КАК Флаг,
	               |	СпрНоменклатура.Ссылка КАК Номенклатура,
	               |	СпрНоменклатура.Модель КАК Модель,
	               |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК Цена,
	               |	ВложенныйЗапрос.Цвет КАК Цвет
	               |ИЗ
	               |	Справочник.Номенклатура КАК СпрНоменклатура
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	               |				,
	               |				Номенклатура.Модель В (&СписокМоделей)
	               |					И ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних
	               |		ПО СпрНоменклатура.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЗначенияСвойствОбъектов.Объект КАК Объект,
	               |			ЕСТЬNULL(ЗначенияСвойствОбъектов.Значение, """") КАК Цвет
	               |		ИЗ
	               |			РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |		ГДЕ
	               |			ЗначенияСвойствОбъектов.Свойство = &Свойство) КАК ВложенныйЗапрос
	               |		ПО СпрНоменклатура.Ссылка = ВложенныйЗапрос.Объект
	               |ГДЕ
	               |	СпрНоменклатура.Модель В(&СписокМоделей)
	               |	И НЕ СпрНоменклатура.ПометкаУдаления
	               |	И НЕ СпрНоменклатура.Наименование ПОДОБНО &Наименование
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СпрНоменклатура.Модель.Наименование,
	               |	СпрНоменклатура.Типоразмер.Диаметр,
	               |	СпрНоменклатура.Типоразмер.Ширина,
	               |	СпрНоменклатура.Типоразмер.Вылет,
	               |	СпрНоменклатура.Типоразмер.КоличествоОтверстий,
	               |	СпрНоменклатура.Типоразмер.PCD,
	               |	СпрНоменклатура.Типоразмер.ДиаметрСтупицы,
	               |	Цвет,
	               |	СпрНоменклатура.Наименование
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Номенклатура),
	               |	МАКСИМУМ(Цена),
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Цвет)
	               |ПО
	               |	Модель
	               |АВТОУПОРЯДОЧИВАНИЕ";
				   
	Запрос.УстановитьПараметр("ТолькоПоСпискуКодов", ТолькоПоСпискуКодов );
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Цвет") );
	
	СписокКодов1C = новый СписокЗначений;
	стр = СписокКодов;
	
	СимвРазделитель = символ(10); //#10 #13
	i= найти(стр, СимвРазделитель);
	пока i>0 цикл
		стр1 = лев(стр, i-1);
		СписокКодов1C.Добавить( СокрЛП(стр1) );
		
		стр  = прав(стр, стрДлина(стр)-i);
		i= найти(стр, СимвРазделитель);
 	КонецЦикла;
	Запрос.УстановитьПараметр("СписокКодов", СписокКодов1C);
	
	Запрос.УстановитьПараметр("СписокМоделей", СписокМоделей);
	Запрос.УстановитьПараметр("ТипЦен", справочники.ТипыЦенНоменклатуры.НайтиПоКоду("00008"));
	Запрос.УстановитьПараметр("Наименование", "% укомпл%");
	
	Результат = Запрос.Выполнить();
	ВыборкаМоделей = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДеревоМоделей.Строки.Очистить();
	Пока ВыборкаМоделей.Следующий() Цикл
	стрМод = ДеревоМоделей.Строки.Добавить();
	стрМод.модель = ВыборкаМоделей.Модель;
	стрМод.Флаг = Истина;
	стрМод.Цена = ВыборкаМоделей.Цена;
	
		ВыборкаТов = ВыборкаМоделей.Выбрать();
		Пока ВыборкаТов.Следующий() Цикл
		стрТов = стрМод.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(стрТов, ВыборкаТов);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры


Процедура КоманднаяПанель2ВыбратьВсе(Кнопка)
	для каждого стр1 из ДеревоМоделей.Строки цикл
		стр1.флаг = Истина;
		для каждого стр2 из стр1.строки цикл
			стр2.флаг = Истина;
		КонецЦикла;	
	КонецЦикла;	
КонецПроцедуры


Процедура КоманднаяПанель2УбратьВсе(Кнопка)
	для каждого стр1 из ДеревоМоделей.Строки цикл
		стр1.флаг = ЛОЖЬ;
		для каждого стр2 из стр1.строки цикл
			стр2.флаг = ЛОЖЬ;
		КонецЦикла;	
	КонецЦикла;	

КонецПроцедуры
	
//====================================ВЫГРУЗКА В EXCEL========================================================
Процедура КнопкаВыполнитьНажатие(Кнопка)
  
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяШаблона);
		Состояние("Открытие файла Microsoft Excel...");
		ExcelЛист = Excel.Sheets(1);
	Исключение
		Предупреждение("Ошибка.Используется 1-ый лист книги Excel.");
		Возврат;
	КонецПопытки;
	
	//-----------------Определим максимальную строку и столбец-----------------------
	xlLastCell = 11; // переход на конец заполненной области Ctrl + End
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	максСтрока  = ActiveCell.Row;
	максСтолбец = ActiveCell.Column;

//================================ из Дерева - идет Загрузка в Шаблон ==============================	

стрМод = "11:11";  стрТов = "12:12"; // копируем их
НомСтр = 11;  
НомСтолбМод    = 2;
КолСтрокМодели = 10; // минимальное число строк 8-10

Попытка
	
	МаксКолСтрМод = ДеревоМоделей.Строки.Количество();  
	КолСтрМод = 0;
	 
	для каждого стрМод из ДеревоМоделей.Строки цикл
		КолСтрМод = КолСтрМод + 1;
		Если не стрМод.Флаг тогда 
			Продолжить; 
		КонецЕсли;
	 ExcelЛист.Cells(НомСтр, НомСтолбМод).Value = строка(стрМод.Модель); 
	 
	 Состояние("Обрабатывается "+строка(КолСтрМод)+" из "+строка(МаксКолСтрМод)+" моделей ("+Формат(КолСтрМод*100/МаксКолСтрМод,"ЧДЦ=0")+"%)  Текущая модель: "+строка(стрМод.Модель));
	
	 //оформление
	 rangeCells = "B"+формат(НомСтр,"ЧГ=0")+":V"+формат(НомСтр,"ЧГ=0");
	 
	 ExcelЛист.Range(rangeCells).Select();
     Excel.Selection.Interior.ColorIndex = 37;
	 Excel.Selection.Font.Bold = True;
     Excel.Selection.HorizontalAlignment = -4108; // xlCenter

	 НомСтр = НомСтр + 1;	
	 колСтрТов = 0;
		для каждого стрТов из стрМод.Строки цикл
         	Если не стрТов.Флаг тогда 
				Продолжить; 
			КонецЕсли;
			
	 	ExcelЛист.Cells(НомСтр, 3).Value  = строка(стрТов.Модель); // модель
//	4	      5		6		7		8	9      10 
//Ширина, Диаметр, Вылет,  КолОтв, PCD, DIA   Цвет
	 	ExcelЛист.Cells(НомСтр, 4).Value  = стрТов.Номенклатура.Типоразмер.Ширина; 
		ExcelЛист.Cells(НомСтр, 5).Value  = стрТов.Номенклатура.Типоразмер.Диаметр; 
		ExcelЛист.Cells(НомСтр, 6).Value  = стрТов.Номенклатура.Типоразмер.Вылет; 
		ExcelЛист.Cells(НомСтр, 7).Value  = стрТов.Номенклатура.Типоразмер.КоличествоОтверстий; 
		ExcelЛист.Cells(НомСтр, 8).Value  = стрТов.Номенклатура.Типоразмер.PCD; 
		ExcelЛист.Cells(НомСтр, 9).Value  = стрТов.Номенклатура.Типоразмер.ДиаметрСтупицы; 
		
		ExcelЛист.Cells(НомСтр, 10).Value  = стрТов.Цвет;       //Цвет

		ExcelЛист.Cells(НомСтр, 11).Value = стрТов.Цена;           // Цена Базовая
		
		ExcelЛист.Cells(НомСтр, 12).Value = "=RC[-1]*(1-R3C[-9])*(1-R4C[-9])
		|";   //цена клиента от базовой со скидками
		ExcelЛист.Cells(НомСтр, 13).Value = "=RC[-1]*0.72
		|";
		ExcelЛист.Cells(НомСтр, 14).Value = "=RC[-2]*0.62
		|";
		ExcelЛист.Cells(НомСтр, 16).Value = "=RC[-4]*RC[-1]
		|";  // Сумма
	//
		ExcelЛист.Cells(НомСтр, 17).Value = строка(стрТов.Номенклатура.Код);     // Код 1С
		
		ШтрихКод = "05000"+ строка(стрТов.Номенклатура.Код);
		ШтрихКод = ШтрихКод + КонтрольныйСимволEAN(ШтрихКод, 13);

		ExcelЛист.Cells(НомСтр, 18).Value = """"+ШтрихКод+"""";     // ШтрихКодКод 1С
		
		ExcelЛист.Cells(НомСтр, 19).Value = ВычислитьОбъемНоменклатуры(стрТов.Номенклатура, 3);     // объем до литров

		ExcelЛист.Cells(НомСтр, 20).Value = строка(стрТов.Номенклатура.Артикул); 
		ExcelЛист.Cells(НомСтр, 21).Value = "";     // Болт и гайка
		ExcelЛист.Cells(НомСтр, 22).Value = строка(стрТов.Номенклатура);     // Название товара
		
		колСтрТов = колСтрТов + 1;
		
		НомСтр = НомСтр + 1;	
		КонецЦикла;
		
		Если колСтрТов < КолСтрокМодели тогда // "добавляем" пустые строки
			НомСтр = НомСтр + (КолСтрокМодели - колСтрТов);	
		КонецЕсли;
	
	КонецЦикла;
    Num = Excel.WorkBooks.Count();
	Excel.WorkBooks(Num).SaveAs(ИмяНовогоФайла);
	Excel.WorkBooks(Num).Close(false); //не спрашивая
	//Excel.Quit();
	
	Предупреждение("Записан Файл: "+ИмяНовогоФайла);
	 
Исключение
    Num = Excel.WorkBooks.Count();

	Excel.WorkBooks(Num).Close(false);
	//Excel.Quit();
	Сообщить("Ошибка при записи: "+ОписаниеОшибки(), СтатусСообщения.Внимание);
КонецПопытки;

КонецПроцедуры

Процедура КоманднаяПанель2Развернуть(Кнопка)
	для каждого стр1 из ДеревоМоделей.Строки цикл
	ЭлементыФормы.ДеревоМоделей.Развернуть(стр1);
	КонецЦикла;
КонецПроцедуры

Процедура КоманднаяПанель2Свернуть(Кнопка)
	для каждого стр1 из ДеревоМоделей.Строки цикл
	ЭлементыФормы.ДеревоМоделей.Свернуть(стр1);
	КонецЦикла;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ИмяШаблона     = "\\Terminal\ОТДЕЛ ДИСКОВ\ПРАЙСЫ!!!!!!!!!!\ШаблонНового.xls";
	ИмяНовогоФайла = "\\Terminal\ОТДЕЛ ДИСКОВ\ПРАЙСЫ!!!!!!!!!!\Прайс по моделям от "+ формат(ТекущаяДата(), "ДЛФ=DD")+"xls";
	
	СписокКодов = "9103356
	|";
    СписокМоделей.Очистить();                                                 //LegeArtis Replica A25 7x16/5x112 ET35 D57.1 S
	СписокМоделей.Добавить( справочники.МоделиТоваров.НайтиПоКоду("00793") ); //А25

	ТолькоПоСпискуКодов = истина;
КонецПроцедуры


