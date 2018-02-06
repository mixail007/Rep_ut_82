﻿
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь, Форма = Неопределено) Экспорт

	#Если Клиент тогда
	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли; 
	
	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	#КонецЕсли

	Если ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ДополнительныеПечатныеФормы") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
		ОбъектВнешнейФормы = ИмяМакета.ПолучитьОбъект();
		Если ОбъектВнешнейФормы = Неопределено Тогда
			Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяФайла);
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Ссылка;
		ТабДокумент = Обработка.Печать();
		
	КонецЕсли;

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект));

КонецПроцедуры // Печать


Процедура ПриКопировании(ОбъектКопирования)
	
	Для каждого стр из Бонусы Цикл
		стр.Статус = Перечисления.СтатусыСтрокЗаказа.ПустаяСсылка();
		стр.ЗадачаНаСогласование = Задачи.ЗадачиПользователя.ПустаяСсылка();
	КонецЦикла;
	
	Состояние = Перечисления.СостоянияОбъектов.ПустаяСсылка();
	Выполнен  = ЛОЖЬ;
	Дата = ТекущаяДата();
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Бонус=0 тогда
		Если ДатаПо<ДатаС тогда
		#Если Клиент тогда
			Сообщить("Неверно выбран период действия Бонусов! Проведение невозможно!", СтатусСообщения.Внимание);
		#КонецЕсли	
		Отказ = Истина;
		КонецЕсли;
	
		Если Бонусы.Количество()=0 тогда
		#Если Клиент тогда
			Сообщить("Не заполнена таблица Бонусов! Проведение невозможно!", СтатусСообщения.Внимание);
		#КонецЕсли	
		Отказ = Истина;
		КонецЕсли;	
		
		Если ставкиБонуса.Количество()=0 тогда
		#Если Клиент тогда
			Сообщить("Не заполнена таблица по месяцам! Проведение невозможно!", СтатусСообщения.Внимание);
		#КонецЕсли	
		Отказ = Истина;
		КонецЕсли;	
		
		Если НоменклатурнаяГруппа.Пустая() тогда
		#Если Клиент тогда
			Сообщить("Не заполнено обязательное поле Номенклатурная Группа! Проведение невозможно!", СтатусСообщения.Внимание);
		#КонецЕсли	
		Отказ = Истина;
		КонецЕсли;	
			
	КонецЕсли;
	
	Если Отказ тогда возврат; КонецЕсли;
		
	//Если Состояние = Перечисления.СостоянияОбъектов.Отклонен тогда
	//	#Если Клиент тогда
	//		Сообщить("Нельзя проводить документ "+строка(ссылка)+" в состоянии ""Отменен""!
	//		|Все движения по регистру СтавкиБонусовКонтрагентов - удалены!", СтатусСообщения.Внимание);
	//	#КонецЕсли
	//	возврат;
	//КонецЕсли;	
	
	Движения.БонусыКонтрагентов.Записывать = истина;
	
	Если Бонус = 1  тогда //ОТК ------------Движение на Дату документа!---------------------
		Если  ВидОперации = Перечисления.ВидыОперацийУстановкаБонуса.Установка  Тогда
			
		ПроверитьУникальностьОТК(Отказ, 1);
		Если Отказ тогда Возврат КонецЕсли;
		
		Для Каждого стр из Бонусы Цикл
			Если стр.Статус <> перечисления.СтатусыСтрокЗаказа.Отменен Тогда
				НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
				НовЗапись.Период = Дата;
				НовЗапись.Регистратор = Ссылка; //+++ 22.12.2017
				НовЗапись.Основание  = Ссылка;
				НовЗапись.Контрагент = Контрагент;
				//НовЗапись.Производитель = стр.Производитель;
				//НовЗапись.НоменклатурнаяГруппа = стр.НоменклатурнаяГруппа;
				НовЗапись.ВидТовара = стр.ВидТовара;
				НовЗапись.Активность = Истина;
				НовЗапись.Вид = Перечисления.ВидБонуса.ОТК;
				НовЗапись.ТипБонуса = перечисления.ТипыБонусов.ПустаяСсылка();
				НовЗапись.Значение    = стр.Бонус;
				НовЗапись.Коэффициент = стр.Коэффициент;
				НовЗапись.Записать();
			КонецЕсли;
		КонецЦикла;
		Состояние = Перечисления.СостоянияОбъектов.Утвержден; //сразу без Согласований!
		
	//+++ 25.12.2017 ---- контроль уникальности ---------------	
		стр1 = Движения.БонусыКонтрагентов.Добавить();
		стр1.Регистратор = ссылка;
		стр1.Контрагент = Контрагент;
		стр1.ОТК = Истина;
		стр1.Нал = ЛОЖЬ;
		//-----------------ВСЕГДА ПУСТЫЕ!--------------------------------
		стр1.ТипБонуса = перечисления.ТипыБонусов.ПустаяСсылка();
		стр1.НоменклатурнаяГруппа = справочники.НоменклатурныеГруппы.ПустаяСсылка(); 
		
  		стр1.Период = НачалоМесяца(Дата);
        стр1.Значение = 1;
		
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийУстановкаБонуса.Удаление  Тогда		
			
		ПроверитьУникальностьОТК(Отказ, -1);
		Если Отказ тогда Возврат КонецЕсли;
		
		Для Каждого стр из Бонусы Цикл
			Если стр.Статус <> перечисления.СтатусыСтрокЗаказа.Отменен Тогда
				НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
				НовЗапись.Период = НачалоМесяца(Дата);
				НовЗапись.Регистратор = Ссылка; //+++ 22.12.2017
				НовЗапись.Основание = Ссылка;
				НовЗапись.Контрагент = Контрагент;
				//НовЗапись.Производитель = стр.Производитель;
				//НовЗапись.НоменклатурнаяГруппа = стр.НоменклатурнаяГруппа;
				НовЗапись.ВидТовара = стр.ВидТовара;
				НовЗапись.Активность = Истина;
				НовЗапись.Вид = Перечисления.ВидБонуса.ОТК;
				НовЗапись.ТипБонуса = перечисления.ТипыБонусов.ПустаяСсылка();
				НовЗапись.Значение = 0;
				НовЗапись.Коэффициент = стр.Коэффициент;
				НовЗапись.Записать();
			КонецЕсли;
		КонецЦикла;
		Состояние = Перечисления.СостоянияОбъектов.Утвержден; //сразу без Согласований!
		
	//+++ 25.12.2017 ---- контроль уникальности ---------------	
		стр1 = Движения.БонусыКонтрагентов.Добавить();
		стр1.Регистратор = ссылка;
		стр1.Контрагент = Контрагент;
		стр1.ОТК = Истина;
		стр1.Нал = ЛОЖЬ;
		//-----------------ВСЕГДА ПУСТЫЕ!--------------------------------
		стр1.ТипБонуса = перечисления.ТипыБонусов.ПустаяСсылка();
		стр1.НоменклатурнаяГруппа = справочники.НоменклатурныеГруппы.ПустаяСсылка(); 
		
		стр1.Период = НачалоМесяца(Дата);
        стр1.Значение = -1;  //сторно

		КонецЕсли; 
	КонецЕсли;

	Если Бонус = 0 тогда //Бонус -------------Делаем движение по месяцам из документа! -------
		
		Если ВидОперации = Перечисления.ВидыОперацийУстановкаБонуса.Установка Тогда
			
			//Контроль сразу все месяцы
			КолМес =  Месяц( ДатаПо ) - Месяц( ДатаС ) + 1
						+?( Год(ДатаПо) > Год(ДатаС),  12 * (Год(ДатаПо) - Год(ДатаС)), 0);
 			ПроверитьУникальностьБонуса(Отказ, КолМес);
			Если Отказ тогда Возврат КонецЕсли;

				Для Каждого стр из Бонусы Цикл
					Если стр.Статус = Перечисления.СтатусыСтрокЗаказа.Подтвержден Тогда
						
						Для каждого стр11 из СтавкиБонуса Цикл
							Если стр.Производитель = стр11.Производитель //+++ 27.12.2017
								или стр11.Производитель.Пустая() тогда
								НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
								НовЗапись.Период = стр11.Месяц; // до дня!
								НовЗапись.Регистратор = Ссылка; //+++ 22.12.2017
								НовЗапись.Основание = Ссылка;
								НовЗапись.Контрагент = Контрагент;
								
								НовЗапись.ВидТовара = стр.ВидТовара;
								НовЗапись.Производитель        = стр.Производитель;
								НовЗапись.НоменклатурнаяГруппа = стр.НоменклатурнаяГруппа;
								
								НовЗапись.Активность = Истина;
								НовЗапись.Вид = Перечисления.ВидБонуса.Бонус;
								НовЗапись.ТипБонуса = ТипБонуса;  //+++ новое измерение
								
 								НовЗапись.Значение = стр11.Ставка; //ставка для каждого производителя - своя!
								НовЗапись.Записать();
							КонецЕсли;	
 						КонецЦикла;
						
					  // последний месяц - выключаем всё -----------------------------------------------------
						НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
						НовЗапись.Период = КонецДня(ДатаПо)+1; // на следующий день после ДатыПо !
						НовЗапись.Основание = Ссылка;
						НовЗапись.Регистратор = Ссылка; //+++ 22.12.2017
						НовЗапись.Контрагент = Контрагент;
						НовЗапись.Производитель = стр.Производитель;
						НовЗапись.НоменклатурнаяГруппа = стр.НоменклатурнаяГруппа;
						НовЗапись.ВидТовара = стр.ВидТовара;
						НовЗапись.Активность = Истина;
						НовЗапись.Вид = Перечисления.ВидБонуса.Бонус;
						НовЗапись.ТипБонуса = ТипБонуса;  //+++ новое измерение
						НовЗапись.Значение = 0; //Зануляем для прекращения расчетов!
						НовЗапись.Записать();
					КонецЕсли;
				КонецЦикла;
				
		//+++ 25.12.2017 ---- контроль уникальности ---------------	
			стр1 = Движения.БонусыКонтрагентов.Добавить();
			стр1.Регистратор = ссылка;
			стр1.Контрагент = Контрагент;
			стр1.ОТК = ЛОЖЬ;
			стр1.Нал = Нал; //06.02.2018
			стр1.ТипБонуса = ТипБонуса;
			стр1.НоменклатурнаяГруппа = НоменклатурнаяГруппа; //+++ 27.12.2017
			
  			стр1.Период = НачалоМесяца(ДатаС);
            стр1.Значение = КолМес;
				
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийУстановкаБонуса.Удаление тогда//------------------------------------
			
		//Контроль по кол-ву месяцев!
		КолМес =  Месяц( ДатаПо ) - Месяц( ДатаС ) + 1
					+?( Год(ДатаПо) > Год(ДатаС),  12 * (Год(ДатаПо) - Год(ДатаС)), 0);
		ПроверитьУникальностьБонуса(Отказ, -КолМес);
			Если Отказ тогда Возврат КонецЕсли;

 			// выключаем всё-----------------------------------------------------
			Для Каждого стр из Бонусы Цикл
				Если стр.Статус = Перечисления.СтатусыСтрокЗаказа.Подтвержден Тогда
					Для каждого стр11 из СтавкиБонуса Цикл
						Если стр.Производитель = стр11.Производитель //+++ 27.12.2017
								или стр11.Производитель.Пустая() тогда
						НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
						НовЗапись.Период = стр11.Месяц;
						НовЗапись.Основание = Ссылка;
						НовЗапись.Контрагент = Контрагент;
						НовЗапись.Производитель = стр.Производитель;
						НовЗапись.НоменклатурнаяГруппа = стр.НоменклатурнаяГруппа;
						НовЗапись.ВидТовара = стр.ВидТовара;
						НовЗапись.Активность = Истина;
						НовЗапись.Вид = Перечисления.ВидБонуса.Бонус;
						НовЗапись.ТипБонуса = ТипБонуса;  //+++ новое измерение
 						НовЗапись.Значение = 0;//ЗАНУЛЯЕМ!
						НовЗапись.Записать();
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
				
		//+++ 25.12.2017 ---- убиваем ставку ---------------	
			стр1 = Движения.БонусыКонтрагентов.Добавить();
			стр1.Регистратор = ссылка;
			стр1.Контрагент = Контрагент;
			стр1.ОТК = ЛОЖЬ;
			стр1.Нал = Нал; //06.02.2018
			стр1.ТипБонуса = ТипБонуса;
		стр1.НоменклатурнаяГруппа = НоменклатурнаяГруппа; //+++ 27.12.2017
			
  			стр1.Период = НачалоМесяца(ДатаС); //помесячно!
            стр1.Значение = КолМес;
				
		КонецЕсли;
	
	КонецЕсли;//Бонус	
	
		
КонецПроцедуры


Процедура ОбработкаУдаленияПроведения(Отказ)
	Если Отказ тогда возврат; КонецЕсли;
	
	//--------------Удаляем все движения!-------------------------------------------
	Табл = ПолучитьДвиженияПоДокументу();
	для каждого стр1 из табл цикл
		НовЗапись = РегистрыСведений.СтавкиБонусовКонтрагентов.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств( НовЗапись, стр1);
		НовЗапись.Удалить();
	КонецЦикла;
	
КонецПроцедуры

//==============Вспомогательные функции================================
функция ПолучитьДвиженияПоДокументу()
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ *
	 |ИЗ
	 |	РегистрСведений.СтавкиБонусовКонтрагентов КАК СтавкиБонусовКонтрагентов
	 |ГДЕ
	 |	СтавкиБонусовКонтрагентов.Основание = &Основание";
	 
	 Запрос.УстановитьПараметр("Основание", Ссылка);
	 
	 Результат = Запрос.Выполнить();
	табл = Результат.Выгрузить();
	
	возврат табл;
КонецФункции	


процедура ПроверитьУникальностьОТК(Отказ, Кол)
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	 |	БонусыКонтрагентовОстатки.ЗначениеОстаток
	 |ИЗ
	 |	РегистрНакопления.БонусыКонтрагентов.Остатки(
	 |			&Дата,
	 |			Контрагент = &Контрагент
	 |				И ОТК = &ОТК
	// |				И НоменклатурнаяГруппа = &НоменклатурнаяГруппа
	 //|				И ТипБонуса = &ТипБонуса
	 |) КАК БонусыКонтрагентовОстатки";
	 Запрос.УстановитьПараметр("Дата", Дата);
	 Запрос.УстановитьПараметр("Контрагент", Контрагент);
	 Запрос.УстановитьПараметр("ОТК", (Бонус=1) );
 //	 Запрос.УстановитьПараметр("ТипБонуса", ТипБонуса);
//	 Запрос.УстановитьПараметр("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	 
	 Результат = Запрос.Выполнить();
	 Выборка = Результат.Выбрать();
	 рез = "";
	 Если Выборка.Следующий() тогда
		 Если Кол>0 и Выборка.ЗначениеОстаток>0 тогда //уже есть Установка ОТК!
			 рез = "Уже есть Установка ОТК по выбранным параметрам!";
			 Отказ = Истина;
		ИначеЕсли Кол<0 и Выборка.ЗначениеОстаток<=0 тогда  //нечего сторнировать или уже есть сторно
			 рез = "Уже есть документ Удаления ОТК по выбранным параметрам!";
			 Отказ = Истина;
		ИначеЕсли Кол<0 и Выборка.ЗначениеОстаток>0 и Выборка.ЗначениеОстаток+Кол<0 тогда  //сторнируется больше чем надо... можно сторнировать только ВСЁ сразу!
			 рез = "Сторнируется больше чем в установке ОТК!";
			 Отказ = Истина;
		КонецЕсли;	 
	КонецЕсли;
	#Если Клиент тогда
	Если рез<>"" тогда
		сообщить(рез, СтатусСообщения.Внимание);
	КонецЕсли;	
	#КонецЕсли	
КонецПроцедуры	

процедура ПроверитьУникальностьБонуса(Отказ, Кол)
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	 |	БонусыКонтрагентовОстатки.ЗначениеОстаток
	 |ИЗ
	 |	РегистрНакопления.БонусыКонтрагентов.Остатки(
	 |			&Дата,
	 |			Контрагент = &Контрагент
	 |				И НоменклатурнаяГруппа = &НоменклатурнаяГруппа
	 |				И ОТК = &ОТК
	|				И Нал = &Нал
	|				И ТипБонуса = &ТипБонуса) КАК БонусыКонтрагентовОстатки";
	 Запрос.УстановитьПараметр("Дата", Дата);
	 Запрос.УстановитьПараметр("Контрагент", Контрагент);
	 Запрос.УстановитьПараметр("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
	 Запрос.УстановитьПараметр("ОТК", (Бонус=0) );
	 Запрос.УстановитьПараметр("Нал", Нал); // 06.02.2018
	 Запрос.УстановитьПараметр("ТипБонуса", ТипБонуса);
	 
	 Результат = Запрос.Выполнить();
	 Выборка = Результат.Выбрать();
	 
	 рез = "";
	 Если Выборка.Следующий() тогда
		 Если Кол>0 и Выборка.ЗначениеОстаток>0 тогда //уже есть Установка ОТК!
			 рез = "Уже есть Установка Бонусов по выбранным параметрам!";
			 Отказ = Истина;
		ИначеЕсли Кол<0 и Выборка.ЗначениеОстаток<=0 тогда  //нечего сторнировать или уже есть сторно
			 рез = "Уже есть документ Удаления Бонусов по выбранным параметрам!";
			 Отказ = Истина;
		ИначеЕсли Кол<0 и Выборка.ЗначениеОстаток>0 и Выборка.ЗначениеОстаток+Кол<0 тогда  //сторнируется больше чем надо... можно сторнировать только ВСЁ сразу!
			 рез = "Сторнируется больше чем в установке ОТК!";
			 Отказ = Истина;
		КонецЕсли;	 
	КонецЕсли;
	
	//+++ 21.01.2018 --- проверка уже выплаченного бонуса за период этой установки! ---
	Если не Отказ тогда
		 Запрос = новый Запрос;
		 Запрос.Текст = "ВЫБРАТЬ
		                |	ПРЕДСТАВЛЕНИЕ(ВыплатаБонусовКонтрагентам.Ссылка),
		                |	ВыплатаБонусовКонтрагентам.НачалоПериода,
		                |	ВыплатаБонусовКонтрагентам.КонецПериода,
		                |	ВыплатаБонусовКонтрагентам.Состояние
		                |ИЗ
		                |	Документ.ВыплатаБонусовКонтрагентам КАК ВыплатаБонусовКонтрагентам
		                |ГДЕ
		                |	ВыплатаБонусовКонтрагентам.Проведен
		                |	И ВыплатаБонусовКонтрагентам.Бонус = &Бонус
		                |	И ВыплатаБонусовКонтрагентам.Контрагент = &Контрагент
		                |	И ВыплатаБонусовКонтрагентам.ТипБонуса = &ТипБонуса
						//06.02.2018
						|	И ВыплатаБонусовКонтрагентам.Нал = &Нал
	 
		                |	И (&НачалоПериода <= ВыплатаБонусовКонтрагентам.КонецПериода
		                |			ИЛИ &КонецПериода >= ВыплатаБонусовКонтрагентам.НачалоПериода)
		                |	И ВыплатаБонусовКонтрагентам.НоменклатурнаяГруппа = &НоменклатурнаяГруппа
		                |	";
		 Запрос.УстановитьПараметр("Бонус", Бонус ); //0
		 Запрос.УстановитьПараметр("Контрагент", Контрагент);
		 Запрос.УстановитьПараметр("ТипБонуса", ТипБонуса);
		 Запрос.УстановитьПараметр("Нал", Нал);
		 
		 Запрос.УстановитьПараметр("НачалоПериода", ДатаС ); 
		 Запрос.УстановитьПараметр("КонецПериода", ДатаПо ); 
		 Запрос.УстановитьПараметр("НоменклатурнаяГруппа", НоменклатурнаяГруппа);
		 
		 Результат = Запрос.Выполнить();
		 Выборка = Результат.Выбрать();
		 Если Выборка.Следующий() тогда
			 Отказ = Истина;
			 #Если Клиент тогда
				 сообщить("УЖЕ "+?(выборка.Состояние=перечисления.СостоянияОбъектов.Выполнен, "ВЫПЛАЧЕН", "ЕСТЬ") //даже если отклонен! повторно не зачем!
				 +" бонус покупателю '"+строка(Контрагент)+"' по документу: "+строка(выборка.СсылкаПредставление)
				 +" ("+строка(ТипБонуса)+")"+?(нал,"*","") , СтатусСообщения.Внимание);
			#КонецЕсли	
 		 КонецЕсли;	
	КонецЕсли;
	
	#Если Клиент тогда
	Если рез<>"" тогда
		сообщить(рез, СтатусСообщения.Внимание);
	КонецЕсли;	
	#КонецЕсли	

КонецПроцедуры	