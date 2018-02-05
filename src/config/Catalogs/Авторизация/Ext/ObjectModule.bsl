﻿
функция СлучайныйНабор(КолСимв = 6) Экспорт
	
	//начЧисло = 534523512;
	рез = "";
	ГСЧ = Новый ГенераторСлучайныхЧисел;

	для i=1 по КолСимв цикл    //48 - 122 это максимально... но попадаются спецсимволы, скобки и т.п.

		вар = ГСЧ.СлучайноеЧисло(1, 3);
		если Цел(вар)=1 тогда
			рез = рез + Символ( Цел(ГСЧ.СлучайноеЧисло(65, 90)) );		//41-5A  Б буквы латинского алф.
		иначеесли Цел(вар)=2 тогда
			рез = рез + Символ( Цел(ГСЧ.СлучайноеЧисло(97, 122)) );		//61-7A  м буквы латинского алф.
		иначе //Цел(вар)=1 тогда
			рез = рез + Символ( Цел(ГСЧ.СлучайноеЧисло(48, 57)) );		//цифры
		КонецЕсли;
		
	КонецЦикла;
	
	возврат рез;
	
КонецФункции

//+++ 01.07.2015 - сразу запишем в Store
Процедура ПриЗаписи(Отказ) 


Если этотобъект.ПометкаУдаления тогда 
	Возврат; 
КонецЕсли;

//----------Выгрузка в Store и Terminal (если есть логин или пароль И они не были установлены ранее)-----------------------------------  
Если (этотобъект.Логин<>"") 
	и (этотобъект.Пароль<>"") тогда //08.12.2015
	
//1. создание XML файла		
	ИмяФайла = КаталогВременныхФайлов()+"user1.xml";
	выгрузитьПользователяВФайл( ИмяФайла );
	
  //----- убираем 30.09.2016 ----------
  //тестовый режим:  СтрокаПодключения="LAPENKOV_vi:8090"; 
  //СтрокаПодключения="store.yst.ru:80";
  // рез1  = ВыгрузитьНаСервер(ИмяФайла, СтрокаПодключения);
  //Отказ1 = ОбработатьРезультатВыгрузки(рез1, СтрокаПодключения);  // НЕ блокируем!

  
//----------------------с 28.01.2016 запущена Выгрузка в Terminal--------------------------
  СтрокаПодключения="terminal.yst.ru"; //БЕЗ порта!
  рез2 = ВыгрузитьНаСервер(ИмяФайла, СтрокаПодключения, Истина);  //удалить файл после выгрузки
  Отказ = ОбработатьРезультатВыгрузки(рез2, СтрокаПодключения);

КонецЕсли;

КонецПроцедуры // ПослеЗаписи()


функция ОбработатьРезультатВыгрузки(рез1, СтрокаПодключения)
	
Отказ1 = ложь;

  #Если Клиент тогда
  если лев(рез1,1)="+" тогда
	  сообщить("Успешно создан новый пользователь: "+Логин+" в "+СтрокаПодключения, СтатусСообщения.Информация);
  иначе
	  если Найти(рез1,"exists")>0 тогда
	  	сообщить("Пользователь с таким именем: "+Логин+" уже существует в "+СтрокаПодключения, СтатусСообщения.Внимание);
	  иначе	  
	  	сообщить("Не удалось создать пользователя в "+СтрокаПодключения+рез1, СтатусСообщения.Внимание);
	  КонецЕсли;	
	  Отказ1 = НЕ РольДоступна("ПравоЗавершенияРаботыПользователей");
  КонецЕсли;	  
#КонецЕсли	  

возврат Отказ1;

КонецФункции

функция КлиентРаспродажа()
	СвойствоРаспродажи = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90183"); //Цены распродажи
	
	Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	                |	ЗначенияСвойствОбъектов.Объект КАК Контрагент
	                |ИЗ
	                |	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	                |ГДЕ
	                |	ЗначенияСвойствОбъектов.Свойство = &Свойство
	                |	И ЗначенияСвойствОбъектов.Значение = ИСТИНА
	                |	И ЗначенияСвойствОбъектов.Объект = &Объект";
	 
	 Запрос.УстановитьПараметр("Объект", ссылка.Владелец);
	 Запрос.УстановитьПараметр("Свойство", СвойствоРаспродажи);
	 
	 Результат = Запрос.Выполнить();
	 выборка = Результат.Выбрать();
	 рез = ложь;
	 если выборка.Следующий() тогда
		 рез = истина;
	 КонецЕсли;	
	возврат рез; 
КонецФункции	 


процедура выгрузитьПользователяВФайл(имяФайла)
	user = ЭтотОбъект.Ссылка;
	инфоКонтр = СведенияОЮрФизЛице( user.Владелец, ТекущаяДата() );
	КонтактЛицо = ПолучитьКонтЛицо( user.Владелец );
	Культура  = ?(user.Владелец.Экспорт 
			                и user.Владелец.основнойДоговорКонтрагента.ВалютаВзаиморасчетов.Код<>"643", "en-US", "");
							
							
	//текст1 = "<AppUserDTO xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/YstIdentity.Models"">
	текст1 = "<Partner xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"">
    |<PartnerId>"+СокрЛП(user.Владелец.Код)+"</PartnerId>
	|<Name>"+СокрЛП(user.Владелец.Наименование)+"</Name> 
    |<FullName>"+СокрЛП(user.Владелец.НаименованиеПолное)+"</FullName> 
	
	|<ContactFIO>"+КонтактЛицо+"</ContactFIO> 
	|<Address>"+инфоКонтр.ЮридическийАдрес+"</Address> 
    |<PhoneNumber>"+инфоКонтр.Телефоны+"</PhoneNumber> 
	
    |<INN>"+СокрЛП(user.Владелец.ИНН)+"</INN> 
    |<KPP>"+СокрЛП(user.Владелец.КПП)+"</KPP>
	
	//+++ 09.09.2015 GUID после кпп
	|<Guid>"+СокрЛП(user.Владелец.УникальныйИдентификатор())+"</Guid>"
	//01.02.2016
	+?(Культура<>"" или КлиентРаспродажа(),"
	|<SALE>1</SALE>", "")
	+?(Культура="","", "
	|<Culture>"+Культура+"</Culture>")+"
	|</Partner>";
	//|</AppUserDTO>";
	
	//текст1 = стрЗаменить(текст1, """", "&quot;");  //  " заменяется на  &quot;
	//текст1 = стрЗаменить(текст1, "'", "&apos;");  //   ' заменяется на  &apos;
		
	ОбъектXML = Новый ТекстовыйДокумент;
	ОбъектXML.УстановитьТекст( текст1);
	ОбъектXML.Записать(ИмяФайла, "UTF-8");
	
КонецПроцедуры	

функция ПолучитьКонтЛицо(Контр)
	рез = "";
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("ОбъектВладелец", Контр);
	Запрос.Текст = "ВЫБРАТЬ
	               |	КонтактныеЛица.Наименование
	               |ИЗ
	               |	Справочник.КонтактныеЛица КАК КонтактныеЛица
	               |ГДЕ
	               |	КонтактныеЛица.ОбъектВладелец = &ОбъектВладелец
	               |	И НЕ КонтактныеЛица.ПометкаУдаления
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КонтактныеЛица.ВидКонтактногоЛица";
	РезультатЗапроса = Запрос.Выполнить();
	выборка = РезультатЗапроса.выбрать();
	
	Если выборка.Следующий() Тогда
		рез = сокрЛП( выборка.Наименование );
	КонецЕсли;
возврат рез;	
КонецФункции

Функция ВыгрузитьНаСервер(ИмяФайла="", СтрокаПодключения="terminal.yst.ru", УдалятьВременныеФайлы=ЛОЖЬ)
	
//---------------соединение с сервером---------------------------
Попытка
	login="admin"; password="cegthvfhbj";
	Соединение = Новый HTTPСоединение(СтрокаПодключения, ,login, password, , Истина);    //+++ 15.08.2017  https!

	Если Соединение = Неопределено Тогда
		Возврат "- Соединение с сервером: "+СтрокаПодключения+" - не установлено!";
	КонецЕсли;

//----------------------------------------------------------------
ресурс= "api/partnerapi/create";	
user  = ЭтотОбъект.Ссылка;
Ресурс1 = Ресурс+"?username="+СокрЛП(user.Логин)+"&password="+user.Пароль;
ИмяФайлаРезультата = КаталогВременныхФайлов()+"json1.xml";

Заголовки = Новый Соответствие();
//Если найти(Ресурс,"create")>0 тогда
   Заголовки.Вставить("HASH", "D5790E89580D8B75927F804E738CFCE");  
   Заголовки.Вставить("Content-Type", "text/xml");  
//КонецЕсли;

		HTTPОтвет = Соединение.ОтправитьДляОбработки( ИмяФайла, Ресурс1, 
														ИмяФайлаРезультата, Заголовки) ;

 Соединение = Неопределено; // разорвать соединение

 ТекстовыйФайлОтвет = Новый ТекстовыйДокумент;
 ТекстовыйФайлОтвет.Прочитать(ИмяФайлаРезультата, КодировкаТекста.UTF8);
 СтрокаJSONРезультат = ТекстовыйФайлОтвет.ПолучитьТекст();
 ТекстовыйФайлОтвет = неопределено; // отключается от файла
 
РезТекст = "Статус ответа: "+строка(HTTPОтвет.КодСостояния)+" Ответ сервера: '"+СтрокаJSONРезультат+"'";

Если HTTPОтвет.КодСостояния = 200 тогда
	рез = Истина;
Иначе
	рез = ЛОЖЬ;
КонецЕсли;

//--------------------Удаляем временные файлы-------------------------
Если УдалятьВременныеФайлы тогда
	файл = новый ФАЙЛ(ИмяФайла);
	если файл.Существует() тогда
		путь = файл.Путь;
		УдалитьФайлы(путь, файл.Имя);
		РезТекст = РезТекст + "удален файл данных XML "+ИмяФайла;
	КонецЕсли;
	файл = новый ФАЙЛ(ИмяФайлаРезультата);
	если файл.Существует() тогда
		путь = файл.Путь;
		УдалитьФайлы(путь, файл.Имя);
		РезТекст = РезТекст + "удален файл ответа XML "+ИмяФайлаРезультата;
	КонецЕсли;
КонецЕсли;


исключение
	рез = ложь;
	РезТекст = "Ошибка : "+ОписаниеОшибки();
КонецПопытки;

рез1 =  ?(рез,"+","- ")+РезТекст;
возврат рез1;

КонецФункции

Процедура ПередЗаписью(Отказ)
	если ЭтоНовый() тогда
		ДатаСоздания = ТекущаяДата();
	конецЕсли;	
КонецПроцедуры
