﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если ЗначениеНеЗаполнено(Настройка) 
		или ЗначениеНеЗаполнено(ЗначениеНастройки) тогда
		Предупреждение("Не заполнено обязательное поле!",10);
		возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	НастройкиПользователей.Пользователь,
	               |	НастройкиПользователей.Настройка,
	               |	&Значение как Значение
	               |ИЗ
	               |	РегистрСведений.НастройкиПользователей КАК НастройкиПользователей
	               |ГДЕ
	               |	НЕ НастройкиПользователей.Пользователь.ПометкаУдаления
	               |	И НЕ НастройкиПользователей.Пользователь.Заблокирован
				   |//Филиал    И НастройкиПользователей.Пользователь.ОсновноеПодразделение = &ОсновноеПодразделение
	               |	И НастройкиПользователей.Настройка = &Настройка
				   |УПОРЯДОЧИТЬ ПО 
				   |	НастройкиПользователей.Пользователь";
	
	Запрос.УстановитьПараметр("ОсновноеПодразделение", Подразделение );
	Запрос.УстановитьПараметр("Настройка", Настройка );
	Запрос.УстановитьПараметр("Значение", ЗначениеНастройки );
	
	Если ЗначениеЗаполнено(Подразделение) тогда
        Запрос.Текст = стрЗаменить(Запрос.Текст ,"//Филиал","");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		рег = РегистрыСведений.НастройкиПользователей.СоздатьМенеджерЗаписи();
	    ЗаполнитьЗначенияСвойств(рег, выборка);
		попытка
			рег.Записать();
			сообщить("Записан "+строка(выборка.Пользователь) );
		исключение
			сообщить("Ошибка при Записи "+строка(выборка.Пользователь)+" : "+ОписаниеОшибки(), СтатусСообщения.Внимание );
		КонецПопытки;
	
	КонецЦикла;
Сообщить("------------------------------------------");	
КонецПроцедуры
