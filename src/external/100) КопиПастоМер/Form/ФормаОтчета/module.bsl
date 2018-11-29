﻿Процедура КнопкаСформироватьНажатие(Кнопка)
	
	Старт = ТочноеТекущееВремя();
	ЭлементыФормы.Файл1.Заголовок = "<ИмяФайла1>";
	ЭлементыФормы.Файл2.Заголовок = "<ИмяФайла2>";
	ЭлементыФормы.Строка1.Заголовок = "_";
	ЭлементыФормы.Строка2.Заголовок = "_";
	
	Повторы.Очистить();
	ЭлементыФормы.ПолеТекстовогоДокумента1.Очистить();
	
	Ранг = Новый Массив; 
	След = Новый Массив;
    РазныхСтрок = ЧтениеМодулей(ПутьВыгрузки, Ранг, След,    ТипФайла, ВклПодпапки, Кодировка);// все файлы с таким типом!
	ВсегоСтрок = Ранг.Количество();
	Если ВсегоСтрок=0 тогда
		Предупреждение("Не найдены файлы "+ТипФайла+". Нет строк для анализа!");
		возврат;
	КонецЕсли;	
	
	ВсегоСтрок = Ранг.Количество();
	
	//Тень = ЗначениеИзСтрокиВнутр(ЗначениеВСтрокуВнутр(Ранг));
	
	Тень = Новый Массив(Ранг.Количество()); 
	Для i = 0 По Ранг.Количество() - 1 Цикл Тень[i] = Ранг[i] КонецЦикла;
	
	Состояние("Получение суффиксного массива");
	
	ПолучитьСуффиксныйМассив(Ранг, След);
	
	Путь = Новый Массив(Ранг.Количество());
	Рост = Новый Массив(Ранг.Количество());
	
	Состояние("Получение длин наибольших общих префиксов");
	
	ПолучитьДлиныНаибольшихОбщихПрефиксов(Тень, Ранг, Путь, Рост);
	
	Состояние("Вычисление среднего роста");
	Сумма = 0;
	Для Каждого Элемент Из Рост Цикл Сумма = Сумма + Элемент
	КонецЦикла;
	СреднийРост = Окр(Сумма / Рост.Количество(), 2); 
	
	Состояние("Отбор мест повторов");
	
	Повторы.Загрузить(ОтборМестПовторов(Ранг, Путь, Рост));
	
	Состояние("Сортировка повторов");
	
	Повторы.Сортировать("Рост Убыв");
	
	ЭтаФорма.Заголовок = "КопиПастаМер - " + (ТочноеТекущееВремя() - Старт) + " Cек, "  + "всего строк " + ВсегоСтрок + ", различных " + РазныхСтрок + ", повторяется в среднем " + СреднийРост

КонецПроцедуры

Процедура ПутьВыгрузкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	ДВФ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДВФ.Заголовок = "Выберите каталог, куда были выгружены тексты модулей";
	Если ДВФ.Выбрать() Тогда
		ПутьВыгрузки = ДВФ.Каталог	
	КонецЕсли
КонецПроцедуры

Процедура ПовторыПриАктивизацииСтроки(Элемент)
	
	Детали = Расшифровка(Элемент.ТекущаяСтрока, ТипФайла, Кодировка);
	
	ЭлементыФормы.Файл1.Заголовок = Детали.Файл1;
	ЭлементыФормы.Строка1.Значение = Детали.Строка1;
	
	ЭлементыФормы.Файл2.Заголовок = Детали.Файл2;
	ЭлементыФормы.Строка2.Значение = Детали.Строка2;
	
	ЭлементыФормы.ПолеТекстовогоДокумента1.УстановитьТекст(Детали.Текст)
	
КонецПроцедуры

Процедура ПриОткрытии()
	ТипФайла = ".txt";
	ЭлементыФормы.ТипФайла.СписокВыбора.Добавить(".txt");
	
	ЭлементыФормы.ТипФайла.СписокВыбора.Добавить(".bsl");
	ЭлементыФормы.ТипФайла.СписокВыбора.Добавить(".os");
	
	ЭлементыФормы.ТипФайла.СписокВыбора.Добавить(".md");	
	
	ЭлементыФормы.ТипФайла.СписокВыбора.Добавить(".xml");
	
	ТаблКодировок = ПолучитьТаблКодировок();
	ЭлементыФормы.Кодировка.СписокВыбора.ЗагрузитьЗначения( ТаблКодировок.ВыгрузитьКолонку("Кодировка") );
	Кодировка = "ANSI";   
	
	Порог = 3; // 2 строки!
	Повторы.Очистить();
КонецПроцедуры

Процедура Файл1Нажатие(Элемент)
	Если ЭлементыФормы.Файл1.Заголовок = "<ИмяФайла1>" тогда 
		Предупреждение("Выберите строку повтора. Файл не определен.",30);
		возврат;
	КонецЕсли;	
	ЗапуститьПриложение( ПутьВыгрузки + "\"+ЭлементыФормы.Файл1.Заголовок+ТипФайла);
КонецПроцедуры

Процедура Файл2Нажатие(Элемент)
	Если ЭлементыФормы.Файл2.Заголовок = "<ИмяФайла2>" тогда 
		Предупреждение("Выберите строку повтора. Файл не определен.",30);
		возврат;
	КонецЕсли;	
	ЗапуститьПриложение( ПутьВыгрузки + "\"+ЭлементыФормы.Файл2.Заголовок+ТипФайла);
КонецПроцедуры
