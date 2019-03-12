﻿Перем мЭтоНовый Экспорт;

// Функция проверяет, существуют ли ссылки на единицу измерения в движениях регистров накопления.
// Если есть - нельзя менять коэффицент
//
// Параметры:
//  СуществуютСсылки - булево, переменная, в которой сохраняется результат работы функции, чтобы
//                     при последующих вызовах заново не считать функцию.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки(СуществуютСсылки) Экспорт

	Если ЗначениеНеЗаполнено(Ссылка) Тогда
		Возврат Ложь;
	ИначеЕсли СуществуютСсылки <> Неопределено Тогда
		Возврат СуществуютСсылки; // уже было рассчитано
	КонецЕсли;
	
	Запрос = Новый Запрос();

	Запрос.УстановитьПараметр("ТекущийВладелец", Ссылка);

	ТипНоменклатура = ТипЗнч(Справочники.Номенклатура.ПустаяСсылка());

	Запрос.Текст = "";

	Для Каждого РегистрНакопления Из Метаданные.РегистрыНакопления Цикл
		Для Каждого РеквизитРегистра Из РегистрНакопления.Измерения Цикл
			Если РеквизитРегистра.Тип.СодержитТип(ТипНоменклатура) Тогда
				Если Запрос.Текст <> "" Тогда
					Запрос.Текст = Запрос.Текст + "
					|ОБЪЕДИНИТЬ ВСЕ
					|";
				КонецЕсли;
				Запрос.Текст = Запрос.Текст + "
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	РегистрНакопления."+РегистрНакопления.Имя+"."+РеквизитРегистра.Имя+" КАК Номенклатура
				|ГДЕ
				|	"+РеквизитРегистра.Имя+" = &ТекущийВладелец
				|";
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	СуществуютСсылки = НЕ Запрос.Выполнить().Пустой();

	Возврат СуществуютСсылки;

КонецФункции //  СуществуютСсылки()

// Обработчик события элемента ПриКопировании
//
Процедура ПриКопировании(ОбъектКопирования)
	
	Если Не ЭтоГруппа Тогда
		
		ЕдиницаХраненияОстатков = Неопределено;
		ЕдиницаДляОтчетов       = Неопределено;
		ОсновноеИзображение     = Неопределено;
		КодСБИС = "";
		
	КонецЕсли;
	
КонецПроцедуры

#Если Клиент Тогда

// Обработчик события ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)
	
	//***20150714
	Если ЭтоНовый() И Не ЭтоГруппа И (ВидТовара = Перечисления.ВидыТоваров.Шины ИЛИ ВидТовара = Перечисления.ВидыТоваров.Диски) Тогда
		Если ЗначениеНеЗаполнено(Типоразмер) Тогда
			Сообщить("Для шин и дисков обязательно должен быть указан типоразмер", СтатусСообщения.Важное);
			Отказ=Истина;
		КонецЕсли;		 
		Если ЗначениеНеЗаполнено(Модель) Тогда
			Сообщить("Для шин и дисков обязательно должна быть указана модель'", СтатусСообщения.Важное);
			Отказ=Истина;
		КонецЕсли;
		Если ЗначениеНеЗаполнено(Производитель) Тогда
			Сообщить("Для шин и дисков обязательно должен быть указан производитель'", СтатусСообщения.Важное);
			Отказ=Истина;
		КонецЕсли;	
		//***20151028  добавленпа проверка по НГ
		Если ЗначениеНеЗаполнено(НоменклатурнаяГруппа) Тогда
			Сообщить("Для шин и дисков обязательно должа быть указана номенклатурная группа'", СтатусСообщения.Важное);
			Отказ=Истина;
		КонецЕсли;	
	КонецЕсли;
	//***
	
	// Локальная номенклатура, ОС и НМА
	
	Если мЭтоНовый = Неопределено Тогда
	
		мЭтоНовый = Ложь;
	
	КонецЕсли; 
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		Если НЕ ЭтоНовый() и НЕ мЭтоНовый Тогда
			
			Если ЭтотОбъект.Родитель <> Ссылка.Родитель Тогда
				
				Если Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы) Тогда
					
					Если НЕ ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы) Тогда
						
						Отказ = Истина;
						Предупреждение("Нельзя переносить внеоборотные активы в другую группу!", 5);
						Возврат;
						
					КонецЕсли; 	
					
				КонецЕсли;  
				
				Если Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) Тогда
					
					Если НЕ ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) Тогда
						
						Отказ = Истина;
						Предупреждение("Нельзя переносить материалы в другую группу!", 5);
						Возврат;
						
					КонецЕсли; 	
					
				КонецЕсли;
				
				Если Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.ЛокальнаяНоменклатура) Тогда
					
					Если НЕ ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) Тогда
						
						Отказ = Истина;
						Предупреждение("Нельзя переносить локальную номенклатуру в другую группу!", 5);
						Возврат;
						
					КонецЕсли; 	
					
				КонецЕсли;
				
				Если Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.Автозапчасти) Тогда
					
						Отказ = Истина;
						Предупреждение("Нельзя переносить автозапчасти в другую группу!", 5);
						Возврат;
						
				КонецЕсли;
			
				Если НЕ Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) И ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ЛокальнаяНоменклатура) Тогда
					
					Отказ = Истина;
					Предупреждение("Нельзя переносить элементы справочника в группу локальная номенклатура,
								   |т.к. нумерация отличается!", 5);
					Возврат;
					
				КонецЕсли; 
			
				
				Если НЕ Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) И ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) Тогда
					
					Отказ = Истина;
					Предупреждение("Нельзя переносить элементы справочника в группу материалы,
								   |т.к. нумерация отличается!", 5);
					Возврат;
					
				КонецЕсли; 
				
				Если НЕ Ссылка.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы) И ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы) Тогда
					
					Отказ = Истина;
					Предупреждение("Нельзя переносить элементы справочника в группу внеоборотные активы (ОС),
									|т.к. нумерация отличается!", 5);
					Возврат;
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли;
	
	//----- ОС и НМА
	
	//Проверка переноса по доступу к группе
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		Если НЕ ЭтоНовый() И НЕ мЭтоНовый Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Пользователь", глТекущийПользователь);
			Запрос.Текст = "
			|ВЫБРАТЬ
			|	ГруппаНоменклатуры
			|ИЗ
			|	РегистрСведений.ГруппыРедактированияНоменклатуры
			|ГДЕ
			|	Пользователь = &Пользователь
			|";
			
			Результат = Запрос.Выполнить().Выгрузить();
			СписокГрупп = Новый СписокЗначений;
			СписокГрупп = Результат.ВыгрузитьКолонку("ГруппаНоменклатуры");
			РазрешениеИзИсточника = Ложь;
			РазрешениеВПриемник	  = Ложь;
			
			Для каждого СтрокаГрупп Из СписокГрупп Цикл
				
				// Из источника
				Если (Ссылка.ПринадлежитЭлементу(СтрокаГрупп)) 
					 ИЛИ (СтрокаГрупп = Справочники.Номенклатура.ПустаяСсылка())
					 ИЛИ (Ссылка.Родитель = СтрокаГрупп) Тогда
				
					РазрешениеИзИсточника = Истина;
				
				КонецЕсли;
				
				Если ЭтотОбъект.ПринадлежитЭлементу(СтрокаГрупп) 
				     ИЛИ (СтрокаГрупп = Справочники.Номенклатура.ПустаяСсылка()) 
					 ИЛИ (ЭтотОбъект.Родитель = СтрокаГрупп) Тогда
					 
					РазрешениеВПриемник = Истина;
				
				КонецЕсли;
				
				Если РазрешениеВПриемник И РазрешениеИзИсточника Тогда
				
					Прервать;
				
				КонецЕсли; 
				
			КонецЦикла;

			Если НЕ РазрешениеВПриемник ИЛИ НЕ РазрешениеИзИсточника Тогда
				
				Если НЕ РазрешениеВПриемник И НЕ РазрешениеИзИсточника Тогда
					
					Предупреждение("Вам не разрешено работать с группами " + Ссылка.Родитель + " и " + ЭтотОбъект.Родитель, 5);	
					
				Иначе
					
					Если НЕ РазрешениеВПриемник Тогда
						
						Предупреждение("Вам не разрешено работать с группой " + ЭтотОбъект.Родитель, 5);	
						
					КонецЕсли;
					
					Если НЕ РазрешениеИзИсточника Тогда
						
						Предупреждение("Вам не разрешено работать с группой " + Ссылка.Родитель, 5);	
						
					КонецЕсли;
					
				КонецЕсли;
				
				Отказ = Истина;
				Возврат;
				
			КонецЕсли; 
			
			
			
		КонецЕсли;
		
	КонецЕсли;
	
	//-----Проверка переноса по доступу к группе
	
	
	
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоГруппа Тогда
		
		Если Не Услуга И ЗначениеНеЗаполнено(БазоваяЕдиницаИзмерения) Тогда
			СообщитьПользователюНезаполненРеквизит(Ссылка, "базовая единица");
			Отказ = Истина;
		Иначе
			// Надо проверить владельца единицы хранения остатков
			Если Не ЗначениеНеЗаполнено(ЕдиницаХраненияОстатков)
			   И ЕдиницаХраненияОстатков.Владелец <> Ссылка Тогда
				ТекстСообщения = "У единицы хранения остатков номенклатуры """ + СокрЛП(Ссылка) + """ неверно указан владелец!";
				СообщитьОбОшибке(ТекстСообщения, Отказ);
			КонецЕсли;
		КонецЕсли;

		Если ЗначениеНеЗаполнено(ЕдиницаДляОтчетов) Тогда
			ЕдиницаДляОтчетов = ЕдиницаХраненияОстатков;
		КонецЕсли;

		// Надо проверить владельца единицы для отчетов
		Если Не ЗначениеНеЗаполнено(ЕдиницаДляОтчетов)
		   И ЕдиницаДляОтчетов.Владелец <> Ссылка Тогда
			ТекстСообщения = "У единицы для отчетов номенклатуры """ + СокрЛП(Ссылка) + """ неверно указан владелец!";
			СообщитьОбОшибке(ТекстСообщения, Отказ);
		КонецЕсли;
		
		СуществуютСсылки = Неопределено;
		Если Ссылка.ЕдиницаХраненияОстатков <> ЕдиницаХраненияОстатков И СуществуютСсылки(СуществуютСсылки) Тогда
			ТекстСообщения = "Единица """ + СокрЛП(Ссылка.ЕдиницаХраненияОстатков) + """ является единицей хранения остатков для """ + Наименование + """
			|и уже участвует в товародвижении. 
			|Изменить эту единицу уже нельзя!";
			СообщитьОбОшибке(ТекстСообщения, Отказ);
		КонецЕсли;
		Если Услуга <> Ссылка.Услуга И СуществуютСсылки(СуществуютСсылки)Тогда
			ТекстСообщения = "Номенклатура """ + СокрЛП(Ссылка) + """ участвует в товародвижении.
			|Признак услуги не может быть изменен!";
			СообщитьОбОшибке(ТекстСообщения, Отказ);
		КонецЕсли;
		
		АртикулСокр = ПолучитьАртикулБезЗнаковПрепинания(Артикул);

		
		//06.03.19 Смирнов производитель в модели должен соответствовать производителю из карточки
		//если нет, то тогда сначала ищем подходящую модель, если не нашли - создаем
		Если ЗначениеЗаполнено(Модель) и ЗначениеЗаполнено(Производитель) тогда
			Если Модель.Производитель <> Производитель и СокрЛП(Модель.Наименование) <> "" тогда
				//Найдем модедь с таким же наименованием и производителем из карточки
				Запрос = новый Запрос;
				Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
				|	МоделиТоваров.Ссылка КАК Модель
				|ИЗ
				|	Справочник.МоделиТоваров КАК МоделиТоваров
				|ГДЕ
				|	МоделиТоваров.Наименование ПОДОБНО &Наименование
				|	И МоделиТоваров.Производитель = &Производитель
				|	И МоделиТоваров.ПометкаУдаления = ЛОЖЬ";
				Запрос.УстановитьПараметр("Производитель", Производитель);
				Запрос.УстановитьПараметр("Наименование", Модель.Наименование);
				рез = Запрос.Выполнить().Выбрать();
				
				Если Рез.Количество()>0 тогда
					Пока Рез.Следующий() цикл
						Модель = Рез.Модель;
					КонецЦикла;
				иначе
					//создадим новую модель
					МодельОб = Модель.Скопировать();
					МодельОб.Производитель = Производитель;
					МодельОб.Записать();
					Модель = МодельОб.Ссылка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	
	//// ОС и НМА
	ПроверитьРегистрацию(ЭтотОбъект, ЭтотОбъект);
	/// ОС и НМА 
	
	
	//БАЛАНС (04.12.2007)                       
	//
	ЗарегистрироватьОбъект(ЭтотОбъект,Отказ,Истина); 
	
	
	ВывестиРегистрацию(ЭтотОбъект);
	
	
	//Если (Типоразмер <> Справочники.Типоразмеры.ПустаяСсылка()) и (ЭтоГруппа=Ложь) Тогда
	//	Размер = Типоразмер.Наименование;
	//КонецЕсли;
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 
    	
КонецПроцедуры // ПередЗаписью()

#КонецЕсли

Процедура ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)
	
	Если (ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы))
		  ИЛИ (ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы)) 
		  ИЛИ (ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ЛокальнаяНоменклатура))
		  ИЛИ (ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Автозапчасти)) Тогда
		  
		  Если ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ВнеоборотныеАктивы) Тогда
			  
			  Префикс = "ОС";
			  
		  ИначеЕсли	ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Материалы) Тогда 
		  
			  Префикс = "М";
			  
		  ИначеЕсли	ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.ЛокальнаяНоменклатура) Тогда 
		  
			  Префикс = "ЛН";
			  
		  ИначеЕсли	ЭтотОбъект.ПринадлежитЭлементу(Справочники.Номенклатура.Автозапчасти) Тогда 
		  
			  Префикс = "АЗ";
			  
		  КонецЕсли; 
		  
	Иначе
		
		#Если Клиент Тогда
		
		Префикс = ПолучитьПрефиксНомера();
		
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры // ПриУстановкеНовогоКода(СтандартнаяОбработка, Префикс)

Процедура ОбработкаЗаполнения(Основание)
	ф=1;
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	ф=1;
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	//06.03.19 Смирнов
	Если ЗначениеЗаполнено(Модель) и ЗначениеЗаполнено(Производитель) тогда
		Если Модель.Производитель<>Производитель тогда
			//Найдем модедь с таким же наименованием и производителем из карточки
			Запрос = новый Запрос;
			Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
			|	МоделиТоваров.Ссылка КАК Модель
			|ИЗ
			|	Справочник.МоделиТоваров КАК МоделиТоваров
			|ГДЕ
			|	МоделиТоваров.Наименование ПОДОБНО &Наименование
			|	И МоделиТоваров.Производитель = &Производитель
			|	И МоделиТоваров.ПометкаУдаления = ЛОЖЬ";
			Запрос.УстановитьПараметр("Производитель", Производитель);
			Запрос.УстановитьПараметр("Наименование", Модель.Наименование);
			рез = Запрос.Выполнить().Выбрать();
			
			Если Рез.Количество()>0 тогда
				Пока Рез.Следующий() цикл
					Модель = Рез.Модель;
				КонецЦикла;
			иначе
				//создадим новую модель
				МодельОб = Модель.Скопировать();
				МодельОб.Производитель = Производитель;
				МодельОб.Записать();
				Модель = МодельОб.Ссылка;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
