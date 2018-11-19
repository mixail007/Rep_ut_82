﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Если ПринтерЭтикеток1 Тогда//24.10.2017
		Если ЗначениеЗаполнено(НоменклатураСписок) 
			И ТипЗнч(НоменклатураСписок)=Тип("СправочникСсылка.Номенклатура") Тогда
		    СсылкаНаОбъект = НоменклатураСписок;
    		ТабДок = Печать();
			ТабДок.Показать(); 
		Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТабДок =  Новый ТабличныйДокумент;
	
	ТабДок.ПолеСлева=0;
	ТабДок.ПолеСправа=0;
	ТабДок.ПолеСверху=0;
	ТабДок.ПолеСнизу=0;
	
	Макет = ПолучитьМакет("Макет");
	Если ПринтерЭтикеток Тогда
		Макет = ПолучитьМакет("МакетЭтикетка");
    КонецЕсли;	
	ОбластьСтрока=Макет.ПолучитьОбласть("Строка|Столбец");
	
	Если ЗначениеЗаполнено(НоменклатураСписок) Тогда
	если ТипЗнч(НоменклатураСписок)=Тип("СправочникСсылка.Номенклатура") Тогда
			Номенклатура = НоменклатураСписок;
		Для сч=1 по КоличествоШтрихКодов Цикл
			ОбработкаПрерыванияПользователя();
			Наименование = Номенклатура.Наименование; 
			ШтрихКод1 = мПолучитьКодШтрихКода(Номенклатура);
			если ШтрихКод1 ="" Тогда
				ШтрихКод=мПолучитьНовыйКодДляШтрихКодаЯШТ(Номенклатура.Код);
			иначе
				ШтрихКод= ШтрихКод1;
			КонецЕсли;	
			//ШтрихКод        = "1234567890128";
			//ОбластьСтрока.Параметры.ШК = ШтрихКод;
			Наименование = СтрЗаменить(Наименование,"LegeArtis","TopDriver");
			Если ЗначениеЗаполнено(Номенклатура.ВидДефектаДляУценки) Тогда
				//ОбластьСтрока.Параметры.Наименование = ОбластьСтрока.Параметры.Наименование + "("+Номенклатура.ВидДефектаДляУценки+")";
				Наименование = Наименование + "("+Номенклатура.ВидДефектаДляУценки+")";
			конецЕсли;
			ДобавитьАртикулКНаименованию(Наименование, Номенклатура);
			ОбластьСтрока.Параметры.Наименование = Наименование;
			ОбШтрихКод=ОбластьСтрока.Рисунки.ШК.Объект;
			ОбШтрихКод.ТипКода = 1; 
			ОбШтрихКод.Сообщение = ШтрихКод; 
			ОбШтрихКод.ОтображатьТекст = Истина;
			ОбШтрихКод.ТекстКода = ШтрихКод; 
			
			Если ПринтерЭтикеток Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();			
				ТабДок.Вывести(ОбластьСтрока);
			иначе	
			Если сч%2=1 Тогда
				Если Не ТабДок.ПроверитьВывод(ОбластьСтрока) Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();			
				КонецЕсли;
				ТабДок.Вывести(ОбластьСтрока);
			Иначе
				ТабДок.Присоединить(ОбластьСтрока);
			КонецЕсли;
			конецЕсли;
		КонецЦикла;
	Иначе //------------------------------------------ список
		для ii=0 по НоменклатураСписок.Количество()-1 цикл
			ОбработкаПрерыванияПользователя();
		    Номенклатура = НоменклатураСписок[ii].Значение;
			сч=ii+1;
			Наименование = Номенклатура.Наименование;
			ШтрихКод1 = мПолучитьКодШтрихКода(Номенклатура);
			если ШтрихКод1 ="" Тогда
				ШтрихКод=мПолучитьНовыйКодДляШтрихКодаЯШТ(Номенклатура.Код);
			иначе
				ШтрихКод= ШтрихКод1;
			КонецЕсли;	
			//ШтрихКод        = "1234567890128";
			//ОбластьСтрока.Параметры.ШК = ШтрихКод;
			//ОбластьСтрока.Параметры.Наименование = СтрЗаменить(Наименование,"LegeArtis","TopDriver");
			Наименование = СтрЗаменить(Наименование,"LegeArtis","TopDriver");
			ДобавитьАртикулКНаименованию(Наименование, Номенклатура);
			ОбластьСтрока.Параметры.Наименование = Наименование;
			
			ОбШтрихКод=ОбластьСтрока.Рисунки.ШК.Объект;
			ОбШтрихКод.ТипКода = 1; 
			ОбШтрихКод.Сообщение = ШтрихКод; 
			ОбШтрихКод.ОтображатьТекст = Истина;
			ОбШтрихКод.ТекстКода = ШтрихКод; 
			
			Если ПринтерЭтикеток Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();			
				ТабДок.Вывести(ОбластьСтрока);
			иначе	
			Если сч%2=1 Тогда
				Если Не ТабДок.ПроверитьВывод(ОбластьСтрока) Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();			
				КонецЕсли;
				ТабДок.Вывести(ОбластьСтрока);
			Иначе
				ТабДок.Присоединить(ОбластьСтрока);
			КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;	
	
	ТабДок.ТолькоПросмотр = Истина;	
	ТабДок.Показать(); 
	
	КонецЕсли;	
	
	
КонецПроцедуры

Процедура ПолеВвода1ПриИзменении(Элемент)
	Если ПолеВвода1.Пустая() Тогда
	НоменклатураСписок = неопределено;
	возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Номенклатура.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.Ссылка В ИЕРАРХИИ(&Родитель)
	               |	И НЕ Номенклатура.ЭтоГруппа
	               |	И НЕ Номенклатура.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Родитель", ПолеВвода1);
	
	Результат = Запрос.Выполнить();
	табл = Результат.Выгрузить();
	Если табл.Количество()>2048 Тогда
	Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("В группе: "+строка(ПолеВвода1)+" содержится "+строка(табл.Количество())+" товаров!
		|Слишком большое количество для распечатки!
		|Вы действительно хотите напечатать все штрих-коды?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
		    Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НоменклатураСписок = новый СписокЗначений;
	НоменклатураСписок.ЗагрузитьЗначения( табл.ВыгрузитьКолонку("ссылка") );
	Предупреждение("Выбрано "+строка(НоменклатураСписок.Количество())+" товаров",10);
	
КонецПроцедуры

Процедура НоменклатураСписокПриИзменении(Элемент)
	Если НоменклатураСписок = неопределено Тогда
		ЭлементыФормы.ПолеВвода1.Доступность = Истина;
		ЭлементыФормы.КоличествоШтрихКодов.Доступность = Истина;
	ИначеЕсли ТипЗнч(НоменклатураСписок) = 	тип("СправочникСсылка.Номенклатура") Тогда
		ЭлементыФормы.ПолеВвода1.Доступность = ЛОЖЬ;
		ЭлементыФормы.КоличествоШтрихКодов.Доступность = Истина;
		ЭлементыФормы.ПринтерЭтикеток1.Доступность = Истина;
	Иначе	
		ЭлементыФормы.ПолеВвода1.Доступность = Истина;
		ЭлементыФормы.КоличествоШтрихКодов.Доступность = ЛОЖЬ;
		ЭлементыФормы.ПринтерЭтикеток1.Доступность = ЛОЖЬ;
		КоличествоШтрихКодов = 1;
	КонецЕсли;	
КонецПроцедуры



Процедура СкладПриИзменении(Элемент)
	
	Если НЕ Склад.Пустая() Тогда
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ 
	|	ТоварыНаСкладах.Номенклатура
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(, Склад = &Склад) КАК ТоварыНаСкладах
	|ГДЕ
	|	ТоварыНаСкладах.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("Склад", Склад);
	
	Результат = Запрос.Выполнить();
	табл = Результат.Выгрузить();
	НоменклатураСписок = новый СписокЗначений;
	НоменклатураСписок.ЗагрузитьЗначения( табл.ВыгрузитьКолонку("Номенклатура") );
	Предупреждение("Найдено "+строка(НоменклатураСписок.Количество())+" различных товаров на складе "+строка(Склад), 30);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьАртикулКНаименованию(Наименование, Номенклатура)
	
	Если НЕ Номенклатура.ВидТовара = Перечисления.ВидыТоваров.Диски Тогда
		Наименование = Наименование
		+ Символы.ПС
		+ "Арт.: " + Номенклатура.Артикул;
	КонецЕсли;
	
КонецПроцедуры // ДобавитьАртикулКНаименованию()

Процедура ПринтерЭтикеток1ПриИзменении(Элемент)
	Если ПринтерЭтикеток1 Тогда
		ПринтерЭтикеток = ЛОЖЬ;
	КонецЕсли;	
КонецПроцедуры

Процедура ПринтерЭтикетокПриИзменении(Элемент)
	Если ПринтерЭтикеток Тогда
		ПринтерЭтикеток1 = ЛОЖЬ;
	КонецЕсли;	
КонецПроцедуры


Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	НоменклатураСписок = СсылкаНаОбъект; // номенклатура
	ПринтерЭтикеток = Истина;
	КоличествоШтрихКодов = 1;
КонецПроцедуры

