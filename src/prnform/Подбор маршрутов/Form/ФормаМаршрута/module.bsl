﻿
Функция РазложитьСтрокуВМассив(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции 

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

Процедура ПриОткрытии()
	СписокГородов.Очистить();
	ТОЧКИМАРШРУТА="";
	МассивТочекСКоличеством=РазложитьСтрокуВМассив(Маршрут,"|");
	МаршрутМ=новый массив(МассивТочекСКоличеством.Количество(),2);
    к=0;
	ПервыйПункт=Истина;
	Для каждого элМ из МассивТочекСКоличеством цикл
		Массив2=РазложитьСтрокуВМассив(элМ,",");
		МаршрутМ[к][0]=Массив2[0];
		МаршрутМ[к][1]=Массив2[1];
		к=к+1;
		СписокГородов.Добавить(Массив2[0],Массив2[0]);
		ТОЧКИМАРШРУТА=ТОЧКИМАРШРУТА+?(ПервыйПункт,"",", "+Символы.ПС)+"'"+Массив2[0]+"'";
		ПервыйПункт=ложь;
	КонецЦикла;
	
	Текст = ПолучитьМакет("МакетЯндексМаршрут").ПолучитьТекст();    
	Текст=СтрЗаменить(Текст,"ТОЧКИМАРШРУТА",ТОЧКИМАРШРУТА);
    ЭлементыФормы.Карта.УстановитьТекст(Текст);

КонецПроцедуры

Процедура КоманднаяПанель2Действие3(Кнопка)
	Сообщить(ЭлементыФормы.Карта.ПолучитьТекст());
КонецПроцедуры

Процедура КоманднаяПанель2ТекстКарты(Кнопка)
	Сообщить(ЭлементыФормы.Карта.ПолучитьТекст());
КонецПроцедуры
