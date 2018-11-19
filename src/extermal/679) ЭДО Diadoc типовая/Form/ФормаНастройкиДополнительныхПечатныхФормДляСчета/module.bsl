﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	// Вставить содержимое обработчика.
	Успех = Истина;
	результат = Новый Структура;
	результат.Вставить("ДиадокСпособОтправкиСчета" , ДокументОснованиеСчета);
	Если (ИспользоватьСтандартнуюФормуСчета = 0) или (ДокументОснованиеСчета="НеФормировать") Тогда
		результат.Вставить("ДиадокВнешняяПечатнаяФормаСчета" , "");
	Иначе
		
		Если ЗначениеЗаполнено(ВнешняяПечатнаяФормаСчета)=Ложь Тогда
			Предупреждение("Не указана внешняя печатная форма
			|для счета на оплату!", ,НаименованиеСистемы);
			Возврат;
		КонецЕсли;
	
		Результат.Вставить("ДиадокВнешняяПечатнаяФормаСчета", строка(ВнешняяПечатнаяФормаСчета.УникальныйИдентификатор())); 
		
	КонецЕсли;
	
	НастройкиВнешнихПечатныхФорм = результат;
	ЭтаФорма.закрыть();
КонецПроцедуры

Процедура НастроитьСписокВыбора()
	ЭлементыФормы.ДокументОснованиеСчета.СписокВыбора.Добавить("СчетНаОплату","Счет на оплату");
	Если метаданные.Документы.Найти("ЗаказПокупателя")<>Неопределено Тогда 
		   ЭлементыФормы.ДокументОснованиеСчета.СписокВыбора.Добавить("Заказ","Заказ");
	КонецЕсли;
    ЭлементыФормы.ДокументОснованиеСчета.СписокВыбора.Добавить("РеализацияТоваров","Реализация");
	ЭлементыФормы.ДокументОснованиеСчета.СписокВыбора.Добавить("НеФормировать","Не формировать");
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	КартинкаЗаголовка= ЭДО_БиблиотекаКартинок().КартинкаЗаголовка;
	
	НастроитьСписокВыбора();
	ВнешняяПечатнаяФормаСчета = справочники.ВнешниеОбработки.ПустаяСсылка();
	ВнешняяПечатнаяФормаАкта = справочники.ВнешниеОбработки.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета) Тогда
		ДокументОснованиеСчета =  НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСчета) Тогда
		Попытка 
			ВнешняяПечатнаяФормаСчета = ПолучитьМодульПрог("Модуль_ИнтеграцияОбщий").ВнешняяОбработкаПоGUID(НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСчета);
		Исключение 
			предупреждение("Не удалось найти внешнюю печатную форму.
			|Необходимо заново выбрать нужный элемент.",,НаименованиеСистемы);
		КонецПопытки;
		
		ИспользоватьСтандартнуюФормуСчета = 1;
	КонецЕсли;	
	
		   
	НастроитьДоступность();

КонецПроцедуры


Процедура НастроитьДоступность()
	Элементыформы.ВнешняяПечатнаяФормаСчета.Доступность = (ИспользоватьСтандартнуюФормуСчета=1) и (ДокументОснованиеСчета<>"НеФормировать");
	Элементыформы.ИспользоватьСтандартнуюФормуСчета.Доступность =   (ДокументОснованиеСчета<>"НеФормировать");
	Элементыформы.ИспользоватьВнешнююФормуСчета.Доступность =   (ДокументОснованиеСчета<>"НеФормировать") ;
КонецПроцедуры	

Процедура ИспользоватьСтандартнуюФормуСчетаПриИзменении(Элемент)
	НастроитьДоступность()
КонецПроцедуры

Функция  получитьСписокВнешнихПечатныхФорм(МетаданныеОбъекта)
	
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВнешниеОбработкиПринадлежность.Ссылка
	 	|ИЗ
		|	Справочник.ВнешниеОбработки.Принадлежность КАК ВнешниеОбработкиПринадлежность
	 	|ГДЕ
		|	//ВнешниеОбработкиПринадлежность.СсылкаОбъекта В(&МетаданныеОбъекта)   и
	 	|	 ВнешниеОбработкиПринадлежность.Ссылка.ПометкаУдаления = Ложь
		|	И ВнешниеОбработкиПринадлежность.Ссылка.ВидОбработки = ЗНАЧЕНИЕ(Перечисление.ВидыДополнительныхВнешнихОбработок.ПечатнаяФорма)";
	 
	 Запрос.УстановитьПараметр("МетаданныеОбъекта", МетаданныеОбъекта);
	 
	 МассивВыбора =   Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	 
	 Результат = Новый СписокЗначений;
	 Результат.ЗагрузитьЗначения(МассивВыбора);
	 
	 Возврат Результат; 
	 
КонецФункции	

Функция ВыбратьВнешнююФПИзСписка(СписокВыбора)
	фрм = справочники.ВнешниеОбработки.ПолучитьФормуВыбора();
	отбор = фрм.СправочникСписок.Отбор.Ссылка;
	отбор.видсравнения = видСравнения.ВСписке;
	отбор.использование = Истина;
	отбор.значение = СписокВыбора;
	
	Возврат фрм.ОткрытьМодально();

КонецФункции

Процедура ВнешняяПечатнаяФормаСчетаНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	МетаданныеОбъекта = Новый списокЗначений;
	МетаданныеОбъекта.Добавить(Документы.РеализацияТоваровУслуг.ПустаяСсылка());
	//МетаданныеОбъекта.Добавить("Документ.ЗаказПокупателя");
	МетаданныеОбъекта.Добавить(Документы.СчетНаОплатуПокупателю.ПустаяСсылка());

	СписокВыбора = получитьСписокВнешнихПечатныхФорм(МетаданныеОбъекта);
	выбранноеЗначение = ВыбратьВнешнююФПИзСписка(СписокВыбора);
	
	Если ЗначениеЗаполнено(выбранноеЗначение) Тогда 
		ВнешняяПечатнаяФормаСчета = выбранноеЗначение;
	КонецЕсли;	
КонецПроцедуры

