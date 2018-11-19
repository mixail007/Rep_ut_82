﻿Перем тзМенеджерПомощник;

Процедура СоздатьСобытие() экспорт
	
		ДокСобытие=Документы.Событие.СоздатьДокумент();
		ДокСобытие.ТипСобытия=Перечисления.ВходящееИсходящееСобытие.Входящее;
		ДокСобытие.ВидСобытия=Перечисления.ВидыСобытий.Прочее;
		ДокСобытие.Важность=Перечисления.Важность.Высокая;
		ДокСобытие.СостояниеСобытия=Перечисления.СостоянияСобытий.Запланировано;
		ДокСобытие.НапомнитьОСобытии=Истина;
		ДокСобытие.ВремяНапоминания=НачалоДня(ТекущаяДата())+28830;//8 утра
		ДокСобытие.Дата=ТекущаяДата();
		ДокСобытие.НачалоСобытия=НачалоДня(ТекущаяДата())+28800;//8 утра
		ДокСобытие.ОкончаниеСобытия=КонецДня(ТекущаяДата())+5*24*60*60;//
		ДокСобытие.ОписаниеСобытия="Создать сезонные заказы поставщикам.";
		ТекстСообщения="Создать сезонные заказы поставщикам.";
		ДокСобытие.СодержаниеСобытия=ТекстСообщения;
		Менеджер=Справочники.Пользователи.НайтиПоКоду("Смирнов А.А.");
		ДокСобытие.Ответственный=Менеджер;
		ДокСобытие.Записать(РежимЗаписиДокумента.Проведение);
	    ОтправитьПисьмо(ТекстСообщения);
КонецПроцедуры

Процедура ОтправитьПисьмо(Текст)
		Почта=Новый ИнтернетПочта;
		УЗ = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоНаименованию("no-reply@yst76.ru");
		ИПП=Новый ИнтернетПочтовыйПрофиль;
		ИПП.АдресСервераSMTP=УЗ.SMTPСервер;
		ИПП.ПортSMTP=УЗ.ПортSMTP;
		Если УЗ.ТребуетсяSMTPАутентификация Тогда
			ИПП.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
			ИПП.ПарольSMTP         = УЗ.ПарольSMTP;
			ИПП.ПользовательSMTP   = УЗ.ЛогинSMTP;
		Иначе
			ИПП.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
			ИПП.ПарольSMTP         = "";
			ИПП.ПользовательSMTP   = "";
		КонецЕсли;
		
		Письмо=Новый ИнтернетПочтовоеСообщение;
		Письмо.Отправитель=УЗ.АдресЭлектроннойПочты;
		Письмо.Получатели.Добавить("smirnov@yst.ru");
		//Письмо.Получатели.Добавить("serebrennikovaa@mail.ru");
		
		
		Письмо.Тема="Создать сезонные заказы поставщикам!";
		Письмо.ИмяОтправителя ="Робот";
		Письмо.Организация ="ТК ""Яршинторг""";
		
		
		Письмо.Тексты.Добавить("Создать сезонные заказы поставщикам.",ТипТекстаПочтовогоСообщения.ПростойТекст);
		Письмо.ОбработатьТексты();
		
		попытка
			Почта.Подключиться(ИПП);
			Почта.Послать(Письмо);
			Почта.Отключиться();
		исключение
			попытка
				Пауза(2);
				Почта.Подключиться(ИПП);
				Почта.Послать(Письмо);
				Почта.Отключиться();
			исключение
			конецПопытки;
		конецПопытки;
КонецПроцедуры

Процедура Пауза(Сек)
	scr = Новый COMОбъект("WScript.Shell");
	scr.Run("sleep "+СокрЛП(Число(Сек)),0,1);
КонецПроцедуры

Процедура ОповеститьПоПодразделениям(ДатаОповещения=неопределено) Экспорт
 СоздатьСобытие();
КонецПроцедуры
