﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ИмяТипаОбъекта = ?(ТипОбъекта = 1,"Документ","Справочник");
	СписокВыбранных.Очистить();
	Для каждого Строка Из ДеревоТаблиц.Строки Цикл
		Если Не ОбрабатыватьТабличныеЧасти Тогда
			
			Если Строка.Пометка Тогда
				СписокВыбранных.Добавить(Строка.ИмяТаблицы,Строка.ПредставлениеТаблицы)
			КонецЕсли; 
			
		Иначе
			
			Для каждого СтрокаТаблицы Из Строка.Строки Цикл
				
				Если СтрокаТаблицы.Пометка Тогда
					СписокВыбранных.Добавить(СтрокаТаблицы.ИмяТаблицы,Строка.ПредставлениеТаблицы+" [ ТЧ : "+СтрокаТаблицы.ПредставлениеТаблицы+" ] ")
				КонецЕсли; 
				
			КонецЦикла; 
		КонецЕсли; 
		
	КонецЦикла; 
	ЭтаФорма.ОповеститьОВыборе(СписокВыбранных);
КонецПроцедуры

Процедура ПриОткрытии()

	ЭлементыФормы.ДеревоТаблиц.Колонки.ПредставлениеТаблицы.КартинкиСтрок = БиблиотекаКартинок[?(ТипОбъекта = 1,"Документ","Справочник")+"Объект"];
	ДеревоТаблиц.Строки.Очистить();
	
	МетаданныеОбъектов = Метаданные[?(ТипОбъекта = 1,"Документы","Справочники")];
	ИмяТипаОбъекта = ?(ТипОбъекта = 1,"Документ","Справочник");
	Если ОбрабатыватьТабличныеЧасти Тогда
		Заголовок = "Отбор по табличным частям " +  ?(ТипОбъекта = 1,"документов","справочников");
	Иначе
		Заголовок = "Отбор по " +  ?(ТипОбъекта = 1,"документам","справочникам");
	КонецЕсли; 
	
	
	Для каждого Метаданное Из МетаданныеОбъектов Цикл
		
		Если ОбрабатыватьТабличныеЧасти И Метаданное.ТабличныеЧасти.Количество() = 0 Тогда
			
			Продолжить;
			
		КонецЕсли; 
		
		
		Строка                      = ДеревоТаблиц.Строки.Добавить();
		ИмяМетаданного              = Метаданное.Имя;
		Строка.ИмяТаблицы           = ИмяМетаданного;
		Строка.ПредставлениеТаблицы = Метаданное.Представление();
		
		Если Не ОбрабатыватьТабличныеЧасти Тогда
			
			Если Не СписокВыбранных.НайтиПоЗначению(ИмяМетаданного) = Неопределено Тогда
				
				Строка.Пометка = Истина;
				
			КонецЕсли; 
			
		Иначе
			ПометкаРодителя = Неопределено;
			Для каждого ТабличнаяЧасть Из Метаданное.ТабличныеЧасти Цикл
				
				СтрокаТЧ                      = Строка.Строки.Добавить();
				ИмяТаблицы                    = ТабличнаяЧасть.Имя;
				СтрокаТЧ.ИмяТаблицы           = ИмяМетаданного+"."+ИмяТаблицы;
				СтрокаТЧ.ПредставлениеТаблицы = ТабличнаяЧасть.Представление();
				
				Если Не СписокВыбранных.НайтиПоЗначению(ИмяМетаданного+"."+ИмяТаблицы) = Неопределено Тогда
					
					СтрокаТЧ.Пометка = Истина;
					
				КонецЕсли; 
				
				Если ПометкаРодителя = Неопределено Тогда
					ПометкаРодителя = СтрокаТЧ.Пометка;
				ИначеЕсли Не ПометкаРодителя = 2 И ПометкаРодителя <> СтрокаТЧ.Пометка Тогда
					ПометкаРодителя = 2;
				КонецЕсли; 
				
			КонецЦикла; 
			Строка.Пометка = ПометкаРодителя;
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры

Процедура ДеревоТаблицПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ОбрабатыватьТабличныеЧасти Тогда
		Если Не ДанныеСтроки.Уровень() = 0 Тогда
			ОформлениеСтроки.Ячейки.ПредставлениеТаблицы.ОтображатьКартинку = Ложь;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельДереваТаблицУстановитьФлажки(Кнопка)
	Для каждого Строка Из ДеревоТаблиц.Строки Цикл
		Строка.Пометка = Истина;
		Для каждого СтрокаТаблицы Из Строка.Строки Цикл
			СтрокаТаблицы.Пометка = Истина;
		КонецЦикла; 
	КонецЦикла; 
КонецПроцедуры

Процедура КоманднаяПанельДереваТаблицСнятьФлажки(Кнопка)
	Для каждого Строка Из ДеревоТаблиц.Строки Цикл
		Строка.Пометка = Ложь;
		Для каждого СтрокаТаблицы Из Строка.Строки Цикл
			СтрокаТаблицы.Пометка = Ложь;
		КонецЦикла; 
	КонецЦикла; 
КонецПроцедуры

Процедура ДеревоТаблицПриИзмененииФлажка(Элемент, Колонка)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.Пометка = 2 Тогда
		ТекущиеДанные.Пометка = 0;
	КонецЕсли; 
	
	Если ТекущиеДанные.Уровень() = 1 Тогда
		ПометкаРодителя = ТекущиеДанные.Пометка;
		Для каждого Строка Из ТекущиеДанные.Родитель.Строки Цикл
			Если Строка.Пометка <> ПометкаРодителя Тогда
				ПометкаРодителя = 2;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
		ТекущиеДанные.Родитель.Пометка = ПометкаРодителя;
	Иначе
		Для каждого Строка Из ТекущиеДанные.Строки Цикл
			Строка.Пометка = ТекущиеДанные.Пометка;
		КонецЦикла; 
	КонецЕсли; 
КонецПроцедуры

