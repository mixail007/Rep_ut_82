﻿Функция ПолучитьПараметрыПодключения() Экспорт
	
	результат = Новый Структура;
	Результат.Вставить("КлючРазработчика", "1S82-5-20-619015a6-903b-4a7e-a59d-75737198bea6");
	Результат.Вставить("АдресАПИ", "https://diadoc-api.kontur.ru:443");

	Возврат результат;
	
КонецФункции	

Функция ПолучитьПутьКWEBСерверу() Экспорт
	текстURL = "https://"+ТочкаВходаВеб+"/";
	Возврат текстURL
КонецФункции
