﻿
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ОтчетИнициализация();

КонецПроцедуры

Процедура ПриЗакрытии()

	СохранитьЗначение("НастройкаВнешниеОтчетыОтчетПоБюджетуЗатратОтчет_32368574-c0b2-44fe-8096-f904eb4dbece", ПостроительОтчетаОтчет.ПолучитьНастройки());

КонецПроцедуры

Процедура ДействияФормыОтчетНастройка(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Форма = ВнешнийОтчетОбъект.ПолучитьФорму("ОтчетНастройка");
	Форма.ПостроительОтчета = ПостроительОтчетаОтчет;
	Настройка = ПостроительОтчетаОтчет.ПолучитьНастройки();
	Если Форма.ОткрытьМодально() = Истина Тогда
		ОтчетВывести();
	Иначе
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_НАСТРОЙКА
КонецПроцедуры

Процедура ДействияФормыОтчетСформировать(Кнопка)
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ОтчетВывести();

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПРОЦЕДУРА_ВЫЗОВА
КонецПроцедуры

Процедура ОтчетВывести(ТДок=неопределено,ДатаНач=Неопределено,ДатаКон=Неопределено) Экспорт 
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Если ЗначениеЗаполнено(ДатаНач) и ЗначениеЗаполнено(ДатаКон) Тогда 
		НачПериода = НачалоДня(ДатаНач); 		
		КонПериода = конецДня(ДатаКон); 		
	Иначе 
		Если (Полугодие=1) Тогда 
			НачПериода = НачалоГода(Дата(Формат(Год,"ЧГ=0")+"0101000000"));
			КонПериода = КонецМесяца(ДобавитьМесяц(НачПериода,5));
		Иначе 
			КонПериода = КонецГода(Дата(Формат(Год,"ЧГ=0")+"0101000000"));
			НачПериода = НачалоМесяца(ДобавитьМесяц(КонПериода,-5));
		КонецЕсли;	
	КонецЕсли;
	
	ЭлементыФормы.ПолеТабличногоДокумента.Очистить();

	ПостроительОтчетаОтчет.Параметры.Вставить("Год", Год);
	ПостроительОтчетаОтчет.Параметры.Вставить("полугодие", полугодие);
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц1",?(Полугодие=1,"1.Январь(руб.)","1.Июль(руб.)"));
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц2",?(Полугодие=1,"2.Февраль(руб.)","2.Август(руб.)"));
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц3",?(Полугодие=1,"3.Март(руб.)","3.Сентябрь(руб.)"));
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц4",?(Полугодие=1,"4.Апрель(руб.)","4.Октябрь(руб.)"));
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц5",?(Полугодие=1,"5.Май(руб.)","5.Ноябрь(руб.)"));
	ПостроительОтчетаОтчет.Параметры.Вставить("месяц6",?(Полугодие=1,"6.Июнь(руб.)","6.Декабрь(руб.)"));
	
	ПостроительОтчетаОтчет.ВыбранныеПоля.Очистить();
	ПостроительОтчетаОтчет.ВыбранныеПоля.Добавить("Ответственный");
	ПостроительОтчетаОтчет.ВыбранныеПоля.Добавить("Статья");
	ПостроительОтчетаОтчет.ВыбранныеПоля.Добавить("Сумма");
	ПостроительОтчетаОтчет.ВыбранныеПоля.Добавить("Месяц");
	
	
	ПостроительОтчетаОтчет.ИзмеренияКолонки.Очистить();
	ПостроительОтчетаОтчет.ИзмеренияКолонки.Добавить("Месяц");
	
	ПостроительОтчетаОтчет.ИзмеренияСтроки.Очистить();
	ПостроительОтчетаОтчет.ИзмеренияСтроки.Добавить("Ответственный");
	ПостроительОтчетаОтчет.ИзмеренияСтроки.Добавить("Статья");	
	
	ПостроительОтчетаОтчет.Порядок.Очистить();
	ПостроительОтчетаОтчет.Порядок.Добавить("Месяц");	

	ПостроительОтчетаОтчет.Выполнить();
	//ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет по бюджету затрат за период с " + Формат(НачПериода,"ДЛФ=Д") + " по " + Формат(КонПериода,"ДЛФ=Д");
	ПостроительОтчетаОтчет.ВыводитьЗаголовокОтчета = ложь;
	ПостроительОтчетаОтчет.РазмещениеИзмеренийВСтроках = ТипРазмещенияИзмерений.Отдельно;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВСтроках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.РазмещениеРеквизитовИзмеренийВКолонках = ТипРазмещенияРеквизитовИзмерений.Отдельно;
	ПостроительОтчетаОтчет.МакетОформления = ПолучитьМакетОформления(СтандартноеОформление.Камень);
	
	Если ТДок=Неопределено Тогда 
		ПостроительОтчетаОтчет.Вывести(ЭлементыФормы.ПолеТабличногоДокумента);
		РасчетШириныКолонок(ЭлементыФормы.ПолеТабличногоДокумента);
	Иначе 
		ПостроительОтчетаОтчет.Вывести(ТДОК);
		РасчетШириныКолонок(ТДОК);	
	конецЕсли;
	
	Если (Тдок = неопределено) Тогда 
	 	ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("1.Январь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"1.Январь","Январь");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("2.Февраль");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"2.Февраль","Февраль");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("3.Март");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"3.Март","Март");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("4.Апрель");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"4.Апрель","Апрель");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("5.Май");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"5.Май","Май");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("6.Июнь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"6.Июнь","Июнь");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("1.Июль");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"1.Июль","Июль");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("2.Август");
		Если (ЯчейкаТ<>Неопределено) Тогда             
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"2.Август","Август");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("3.Сентябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"3.Сентябрь","Сентябрь");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("4.Октябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"4.Октябрь","Октябрь");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("5.Ноябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"5.Ноябрь","Ноябрь");
		КонецЕсли;
		
		ЯчейкаТ = ЭлементыФормы.ПолеТабличногоДокумента.НайтиТекст("6.Декабрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"6.Декабрь","Декабрь");
		КонецЕсли;	
	Иначе 
	 	ЯчейкаТ = ТДОК.НайтиТекст("1.Январь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"1.Январь","Январь");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("2.Февраль");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"2.Февраль","Февраль");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("3.Март");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"3.Март","Март");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("4.Апрель");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"4.Апрель","Апрель");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("5.Май");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"5.Май","Май");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("6.Июнь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"6.Июнь","Июнь");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("1.Июль");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"1.Июль","Июль");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("2.Август");
		Если (ЯчейкаТ<>Неопределено) Тогда             
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"2.Август","Август");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("3.Сентябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"3.Сентябрь","Сентябрь");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("4.Октябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"4.Октябрь","Октябрь");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("5.Ноябрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"5.Ноябрь","Ноябрь");
		КонецЕсли;
		
		ЯчейкаТ = ТДОК.НайтиТекст("6.Декабрь");
		Если (ЯчейкаТ<>Неопределено) Тогда 
			ЯчейкаТ.Текст = СтрЗаменить(ЯчейкаТ.Текст,"6.Декабрь","Декабрь");
		КонецЕсли;			
	КонецЕсли;
	
	//Если ТДОК<>Неопределено Тогда 
	//	ЗАкрыть();		
	//КонецЕсли;
	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ВЫПОЛНИТЬ
КонецПроцедуры

Процедура ОтчетИнициализация() ЭКспорт
	//{{КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ(Отчет)
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	ПостроительОтчетаОтчет.Текст =
	"ВЫБРАТЬ
	|	СЗ.Ответственный КАК Ответственный,
	|	СЗ.Ссылка КАК Статья,
	|	ВЫБОР
	|		КОГДА БюджетРасходов.месяц = 1
	|			ТОГДА &Месяц1
	|		ИНАЧЕ ВЫБОР
	|				КОГДА БюджетРасходов.месяц = 2
	|					ТОГДА &Месяц2
	|				ИНАЧЕ ВЫБОР
	|						КОГДА БюджетРасходов.месяц = 3
	|							ТОГДА &Месяц3
	|						ИНАЧЕ ВЫБОР
	|								КОГДА БюджетРасходов.месяц = 4
	|									ТОГДА &Месяц4
	|								ИНАЧЕ ВЫБОР
	|										КОГДА БюджетРасходов.месяц = 5
	|											ТОГДА &Месяц5
	|										ИНАЧЕ ВЫБОР
	|												КОГДА БюджетРасходов.месяц = 6
	|													ТОГДА &Месяц6
	|											КОНЕЦ
	|									КОНЕЦ
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК месяц,
	|	БюджетРасходов.Подразделение КАК Подразделение,
	|	БюджетРасходов.Состояние КАК Состояние,
	|	СУММА(БюджетРасходов.Сумма) КАК Сумма
	|{ВЫБРАТЬ
	|	Ответственный.*,
	|	Статья.*,
	|	месяц,
	|	Подразделение.*,
	|	Состояние.*,
	|	Сумма}
	|ИЗ
	|	Справочник.СтатьиЗатрат КАК СЗ
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			БюджетРасходов.Период КАК Период,
	|			БюджетРасходов.Регистратор КАК Регистратор,
	|			БюджетРасходов.НомерСтроки КАК НомерСтроки,
	|			БюджетРасходов.Месяц КАК месяц,
	|			БюджетРасходов.Активность КАК Активность,
	|			БюджетРасходов.Статья КАК Статья,
	|			БюджетРасходов.Подразделение КАК Подразделение,
	|			БюджетРасходов.Состояние КАК Состояние,
	|			БюджетРасходов.Сумма КАК Сумма
	|		ИЗ
	|			РегистрСведений.БюджетРасходов КАК БюджетРасходов
	|		ГДЕ
	|			БюджетРасходов.Регистратор.Год = &Год И БюджетРасходов.Регистратор.Полугодие=&полугодие) КАК БюджетРасходов
	|		ПО СЗ.Ссылка = БюджетРасходов.Статья
	|ГДЕ
	|	НЕ СЗ.Ссылка.ПометкаУдаления
	|	И НЕ СЗ.ЭтоГруппа
	|
	|СГРУППИРОВАТЬ ПО
	|	СЗ.Ответственный,
	|	СЗ.Ссылка,
	|	БюджетРасходов.месяц,
	|	БюджетРасходов.Подразделение,
	|	БюджетРасходов.Состояние
	|ИТОГИ
	|	СУММА(Сумма)
	|ПО
	|	ОБЩИЕ,
	|	Ответственный,
	|	Статья,
	|	месяц,
	|	Подразделение";
	ПостроительОтчетаОтчет.ЗаполнитьНастройки();
	ПостроительОтчетаОтчет.ЗаполнениеРасшифровки = ВидЗаполненияРасшифровкиПостроителяОтчета.ЗначенияГруппировок;
	ПостроительОтчетаОтчет.ТекстЗаголовка = "Отчет";
	Настройка = ВосстановитьЗначение("НастройкаВнешниеОтчетыОтчетПоБюджетуЗатратОтчет_32368574-c0b2-44fe-8096-f904eb4dbece");
	Если Настройка <> Неопределено Тогда
		ПостроительОтчетаОтчет.УстановитьНастройки(Настройка);
	КонецЕсли;

	//}}КОНСТРУКТОР_ВЫХОДНЫХ_ФОРМ_ПОСТРОИТЕЛЬОТЧЕТА_ИНИЦИАЛИЗАЦИЯ
КонецПроцедуры

Процедура ПриОткрытии()
	// Вставить содержимое обработчика.
	Если не ЗначениеЗаполнено(Полугодие) Тогда 
		Если Месяц(ТекущаяДата())<6 Тогда 
			Полугодие = 1;
		Иначе 
			Полугодие = 2;
		Конецесли;
	КонецЕсли;
	
	Год = ГОД(текущаяДата());	
	
	Если ИзБюджета Тогда  
		ПостроительОтчетаОтчет.ИзмеренияСтроки.Очистить();
		ПостроительОтчетаОтчет.ИзмеренияСтроки.Добавить("Ответственный");
		ПостроительОтчетаОтчет.ИзмеренияСтроки.Добавить("Статья");

		ПостроительОтчетаОтчет.ИзмеренияКолонки.Очистить();
		ПостроительОтчетаОтчет.ИзмеренияКолонки.Добавить("Месяц");
	КонецЕсли;	
КонецПроцедуры

Процедура РасчетШириныКолонок(ТабличныйДокумент)
    
    Перем МаксимальноеКоличествоСтрок, МаксимальнаяШиринаКолонки;
    Перем КонечнаяСтрока, НачальнаяСтрока, ТекущаяКолонка, ТекущаяСтрока, НачалоДанных;
    Перем ОбластьШапки, ОбластьПодвала;
    Перем ШиринаКолонки, ТекстЯчейки, НомерСтрокиТекста;
    Перем КоличествоУровнейГруппировокСтрок, Отступ;
    Перем ШириныКолонок;
    
   // Максимальное количество строк отчета, которые будут использованы для расчета ширин колонок
 
    МаксимальноеКоличествоСтрок = 50;
   // Ограничение максимальной ширины колонки
 
    МаксимальнаяШиринаКолонки = 50;
   // Массив, в который будут помещаться ширины колонок
 
    ШириныКолонок = Новый Массив;
   // Получим количество уровней группировок в отчете для учета автоматического отступа
 
    КоличествоУровнейГруппировокСтрок = ТабличныйДокумент.КоличествоУровнейГруппировокСтрок();
    
   // Инициализируем начальные строки
 
    НачальнаяСтрока = 0;
    НачалоДанных = 0;
    
   // Найдем в результирующем документе область шапки таблицы
 
    ОбластьШапки = ТабличныйДокумент.Области.Найти("ШапкаТаблицы");
    Если ТипЗнч(ОбластьШапки) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
        
       // Из шапки таблицы получим начальную строку с которой будем рассчитывать ширины
 
        НачальнаяСтрока = ОбластьШапки.Верх;
        НачалоДанных = ОбластьШапки.Низ + 1;
        
    Иначе
        
       // Если область шапки таблицы не найдена, найдем область шапки строк
 
        ОбластьШапки = ТабличныйДокумент.Области.Найти("ШапкаСтрок");
        Если ТипЗнч(ОбластьШапки) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
            
           // Из шапки таблицы получим начальную строку с которой будем рассчитывать ширины
 
            НачальнаяСтрока = ОбластьШапки.Верх;
            НачалоДанных = ОбластьШапки.Низ + 1;
            
        КонецЕсли;
            
    КонецЕсли;
    
   // Получим область подвала отчета и вычислим конечную строку расчета
 
    ОбластьПодвала = ТабличныйДокумент.Области.Найти("Подвал");
    Если ТипЗнч(ОбластьПодвала) = Тип("ОбластьЯчеекТабличногоДокумента") Тогда
       // Область подвала найдена
 
        КонечнаяСтрока = ОбластьПодвала.Верх - 1;
        
        Если КонечнаяСтрока - НачальнаяСтрока > МаксимальноеКоличествоСтрок Тогда
            
            КонечнаяСтрока = НачальнаяСтрока + МаксимальноеКоличествоСтрок;
            
        КонецЕсли;
        
    Иначе 
           // Область подвала не найдена
 
        КонечнаяСтрока = НачальнаяСтрока + МаксимальноеКоличествоСтрок;
        
    КонецЕсли;
    
   // Ограничим конечную строку
 
    КонечнаяСтрока = Мин(КонечнаяСтрока, ТабличныйДокумент.ВысотаТаблицы);
    
   // Переберем все колонки отчета
 
    Для ТекущаяКолонка = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
        
        АвтоОтступ = 0;
        
       // Переберем строки, которые будут использованы для расчета ширин колонок
 
        Для ТекущаяСтрока = НачальнаяСтрока По КонечнаяСтрока Цикл
            
            ШиринаКолонки = 0;

           // Получим область текущей ячейки
 
            ОбластьЯчейки = ТабличныйДокумент.Область(ТекущаяСтрока, ТекущаяКолонка);
            
            Если ОбластьЯчейки.Лево <> ТекущаяКолонка Или ОбластьЯчейки.Верх <> ТекущаяСтрока Тогда
                
               // Данная ячейка принадлежит объединенным ячейкам и не является начальной ячейкой
 
                Продолжить;
                
            КонецЕсли;
            
            Если КоличествоУровнейГруппировокСтрок > 0 И ТекущаяСтрока = НачалоДанных Тогда
                
               // Для первой строки с данными получим значение автоотступа
 
                АвтоОтступ = ОбластьЯчейки.АвтоОтступ;
                
            КонецЕсли;
            
           // Получим текст ячейки
 
            ТекстЯчейки = ОбластьЯчейки.Текст;
            
           // Для каждой строки из текста ячейки рассчитаем количество символов в строке
 
            Для НомерСтрокиТекста = 1 По СтрЧислоСтрок(ТекстЯчейки) Цикл
                
                ШиринаТекстаЯчейки = СтрДлина(СтрПолучитьСтроку(ТекстЯчейки, НомерСтрокиТекста));
                
               // Если используется автоотступ, то прибавим к ширине ячейки его величину
 
                Если АвтоОтступ <> Неопределено И АвтоОтступ > 0 Тогда
                    
                    ШиринаТекстаЯчейки = ШиринаТекстаЯчейки + КоличествоУровнейГруппировокСтрок * АвтоОтступ;
                    
                КонецЕсли;
                
                ШиринаКолонки = Макс(ШиринаКолонки, ШиринаТекстаЯчейки);

            КонецЦикла;

            Если ШиринаКолонки > МаксимальнаяШиринаКолонки Тогда
                
               // Ограничим ширину колонки
 
                ШиринаКолонки = МаксимальнаяШиринаКолонки;
                
            КонецЕсли;
            
            Если ШиринаКолонки <> 0 Тогда
               // Ширина колонки рассчитана
 
                
               // Определим, сколько ячеек по ширине используется в области для текущей ячейки
 
                КоличествоКолонок = ОбластьЯчейки.Право - ОбластьЯчейки.Лево;
                
               // Переберем все ячейки, расположенные в области
 
                Для НомерКолонки = 0 По КоличествоКолонок Цикл
                    
                    Если ШириныКолонок.ВГраница() > ТекущаяКолонка - 1 + НомерКолонки Тогда
                        
                       // В массиве ширин колонок уже был элемент для текущей колонки
 
                        
                        Если ШириныКолонок[ТекущаяКолонка - 1 + НомерКолонки] = Неопределено Тогда
                           // Значение ширины колонки еще не было установлено
 
                            
                            ШириныКолонок[ТекущаяКолонка - 1 + НомерКолонки] = ШиринаКолонки / (КоличествоКолонок + 1);
                            
                        Иначе
                           // Значение ширины колонки уже было установлено
 
                           // Вычислим максимум ширины колонки
 
                            ШириныКолонок[ТекущаяКолонка - 1 + НомерКолонки] = 
                                Макс(ШириныКолонок[ТекущаяКолонка - 1 + НомерКолонки], ШиринаКолонки / (КоличествоКолонок + 1));
                            
                        КонецЕсли;
                        
                    Иначе
                        
                       // В массиве ширин колонок еще не было элемента для данной колонки
 
                       // Добавим элемент в массив ширин колонок
 
                        ШириныКолонок.Вставить(ТекущаяКолонка - 1 + НомерКолонки, ШиринаКолонки / (КоличествоКолонок + 1));
                        
                    КонецЕсли;
                    
                КонецЦикла;
                
            КонецЕсли;
            
        КонецЦикла;   // Конец цикла перебора строк
 
        
    КонецЦикла;   // Конец цикла перебора колонок
 
    
   // Переберем все элементы в массиве вычисленных ширин колонок
 
    Для ТекущаяКолонка = 0 По ШириныКолонок.ВГраница() Цикл
        
        Если ШириныКолонок[ТекущаяКолонка] <> Неопределено Тогда
           // Ширина колонок установлена
 
           // Установим ширину области ячеек
 
            ТабличныйДокумент.Область(, ТекущаяКолонка + 1, НачалоДанных, ТекущаяКолонка + 1).ШиринаКолонки = ШириныКолонок[ТекущаяКолонка] + 1;
            
        КонецЕсли;
        
    КонецЦикла;

КонецПроцедуры











