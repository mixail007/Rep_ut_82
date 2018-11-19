﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка КАК Задание,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.IDТовара КАК Номенклатура,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ВидыРабот КАК ВидРаботы,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка.Менеджер,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка.Контрагент КАК Контрагент,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Сдал,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаСдал КАК ДатаСдал,
		|	ЛОЖЬ КАК Сдать
		|ИЗ
		|	Документ.ЗаданиеНаПроизводствоДисков.СогласованиеПроизводства КАК ЗаданиеНаПроизводствоДисковСогласованиеПроизводства
		|ГДЕ
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаСдал <> &ПустаяДата
		|	И ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Принял = &Ответственный
		|	И ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаПринял = &ПустаяДата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидРаботы,
		|	ДатаСдал,
		|	Контрагент
		|ИТОГИ ПО
		|	ВидРаботы,
		|	Контрагент,
		|	Задание";

	Запрос.УстановитьПараметр("Ответственный", ОтветственноеЛицо);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));

	Результат = Запрос.Выполнить();

	ДеревоЗаданий = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);

    	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка КАК Задание,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.IDТовара КАК Номенклатура,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ВидыРабот КАК ВидРаботы,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка.Менеджер,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Ссылка.Контрагент КАК Контрагент,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Принял,
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаСдал КАК ДатаСдал,
		|	ЛОЖЬ КАК Принять
		|ИЗ
		|	Документ.ЗаданиеНаПроизводствоДисков.СогласованиеПроизводства КАК ЗаданиеНаПроизводствоДисковСогласованиеПроизводства
		|ГДЕ
		|	ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаСдал <> &ПустаяДата
		|	И ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.Сдал = &Ответственный
		|	И ЗаданиеНаПроизводствоДисковСогласованиеПроизводства.ДатаПринял = &ПустаяДата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидРаботы,
		|	ДатаСдал,
		|	Контрагент
		|ИТОГИ ПО
		|	ВидРаботы,
		|	Контрагент,
		|	Задание";

	Запрос.УстановитьПараметр("Ответственный", ОтветственноеЛицо);
	Запрос.УстановитьПараметр("ПустаяДата", Дата(1,1,1));

	Результат = Запрос.Выполнить();

	ДеревоКонтроля = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);

	
	
	
	
	
КонецПроцедуры

Процедура ВсеНажатие(Элемент)
	Для каждого стр из ДеревоЗаданий.Строки цикл
		ПоменятьФлаг(стр,Истина);	
	конецЦикла;
КонецПроцедуры

процедура ПоменятьФлаг(стр,Значение)
  стр.сдать = Значение;
	Для каждого ст из ДеревоЗаданий.Строки цикл
		ПоменятьФлаг(ст,Значение);	
	конецЦикла;
конецПроцедуры	

Процедура НиОднойНажатие(Элемент)
	Для каждого стр из ДеревоЗаданий.Строки цикл
		ПоменятьФлаг(стр,Ложь);	
	конецЦикла;
КонецПроцедуры

Процедура ДеревоЗаданийПриПолученииДанных(Элемент, ОформленияСтрок)
	//	Для каждого ОформлениеСтроки из Оформлениястрок Цикл
	//	Если ОформлениеСтроки.ДанныеСтроки.Пометка = Истина Тогда
	//		Для каждого яч из ОформлениеСтроки.ячейки	Цикл
	//			Яч.ТолькоПросмотр = Истина;
	//			Яч.Шрифт =  Новый Шрифт(,,Истина,,);
	
	//		конецЦикла;
	//	конецЕсли;	
	//ОформлениеСтроки.Ячейки.ПрошлыйГод.Видимость = ЛожЬ; 	
	//ОформлениеСтроки.Ячейки.ТекущийГод.Видимость = ЛожЬ; 	
	//конецЦикла;	
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПринять(Кнопка)
	Для каждого стр из ДеревоЗаданий.Строки цикл
	//	Если стр.сдать = Истина тогда
			СдатьРаботу(стр);
	//	конецесли;
	конецЦикла;	
КонецПроцедуры

процедура СдатьРаботу(стр)
	Если стр.строки.количество()>0 тогда
		Для каждого ст из стр.строки Цикл
	       сдатьРаботу(ст);
	    конецЦикла;
	иначе
		Если стр.сдать = Истина тогда

		докОбъект = стр.Задание.ПолучитьОбъект();              
		отбор = Новый Структура;
		отбор.Вставить("IDтовара",стр.номенклатура);
		отбор.Вставить("ВидыРабот",стр.ВидРаботы);
		нашли = ДокОбъект.СогласованиеПроизводства.найтистроки(отбор);
		нашли[0].ДатаПринял = ТекущаяДата();
		
		
					
		Если стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ПередачаЗаявкиВРаботу тогда
		//2
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.НачалоРазработкиМодели);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.НачалоРазработкиМодели тогда
		//3
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ОкончаниеРазработкиМодели);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ОкончаниеРазработкиМодели тогда
		//4
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.НачалоСогласованияМоделиСКлиентом);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.НачалоСогласованияМоделиСКлиентом тогда
		//5
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ПодтверждениеМоделиСКлиентом);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ПодтверждениеМоделиСКлиентом тогда
		//6
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ПередачаЗаявкиНаПроизводство);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ПередачаЗаявкиНаПроизводство тогда
		//7
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.НачалоРазработкиПрограммДляCNC);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.НачалоРазработкиПрограммДляCNC тогда
		//8
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ОкончаниеРазработкиПрограммДляCNC);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ОкончаниеРазработкиПрограммДляCNC тогда
		//9
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.НачалоПроизводстваДисков);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.НачалоПроизводстваДисков тогда
		//10
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ОкончаниеПроизводстваДисков);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ОкончаниеПроизводстваДисков тогда
		//11
		Отбор.Вставить("ВидыРабот",Перечисления.ВидыРаботПоПроизводству.ВыходГотовойПродукции);
		иначеЕсли стр.видРаботы = Перечисления.ВидыРаботПоПроизводству.ВыходГотовойПродукции тогда
        ДокОбъект.Выполнено = Истина;
		конецЕсли;        
		
		нашли1 = ДокОбъект.СогласованиеПроизводства.найтистроки(отбор);
		если нашли.количество()>0 тогда
		нашли1[0].ДатаСдал = ТекущаяДата();
		конецесли;
		ДокОбъект.записать(РежимЗаписиДокумента.Запись);
		конецЕсли;
	конецесли;
конецПроцедуры	