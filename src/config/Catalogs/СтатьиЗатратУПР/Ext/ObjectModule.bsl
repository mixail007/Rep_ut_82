﻿
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка 
	   И НЕ ЭтоГруппа Тогда

		Если ВидЗатрат.Пустая() Тогда
			Сообщить("Укажите вид затрат!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;

		Если ХарактерЗатрат.Пустая() Тогда
			Сообщить("Укажите характер затрат!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
					
		////+++ 17.08.2015
		//Если НЕ ( РольДоступна("яштФинДиректор")  или РольДоступна("ПравоЗавершенияРаботыПользователей") ) тогда
		//	Сообщить("У Вас недостаточно прав для записи!", СтатусСообщения.Важное);
		//	Отказ = Истина;
		//КонецЕсли;
				
	КонецЕсли;
	
	Если (ЭтотОбъект.ПринадлежитЭлементу(Справочники.СтатьиЗатратУпр.ПроцентыПоКредитамИЗаймам))
		ИЛИ (ЭтотОбъект.ПринадлежитЭлементу(Справочники.СтатьиЗатратУпр.РасчетноКассовоеОбслуживаниеВБанках)) Тогда
		
		ЭтотОбъект.ОбменДанными.Получатели.Очистить();
		
		Запрос = Новый Запрос;
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РаспределеннаяИнформационнаяБаза.Ссылка
		|ИЗ
		|	ПланОбмена.РаспределеннаяИнформационнаяБаза КАК РаспределеннаяИнформационнаяБаза
		|ГДЕ
		|	РаспределеннаяИнформационнаяБаза.Ссылка <> &ЭтотУзел";
		
		Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена.РаспределеннаяИнформационнаяБаза.ЭтотУзел());  
		
		Выборка = Запрос.Выполнить().Выбрать();
		// Регистрация изменений для выбранных узлов
		
		Пока Выборка.Следующий() Цикл
			ЭтотОбъект.ОбменДанными.Получатели.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
	
		обЗаписатьПротоколИзменений(ЭтотОбъект);
	
	КонецЕсли; 

КонецПроцедуры

