[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/UPnP/blob/master/README.md) 
[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/UPnP/blob/master/README.EN.md) 
# UPnP
Приложение для перенаправления портов на маршрутизаторе, через UPnP.

## Скриншоты
![](https://user-images.githubusercontent.com/9499881/34568119-374720d0-f17e-11e7-8a0b-43560f397b87.PNG)
<br><br>

Для авто-добавления порта, при запуске системы, нужно заранее добавить ярлык на приложение, в автозагрузку, с параметрами запуска.<br>
<br>**Пример добавления порта:**
>"C:\Program Files\UPnP\UPnP.exe" /add "nginx (TCP)" 8080 TCP

Где "nginx (TCP)" это описание, "8080" перенаправленный порт, "TCP" тип протокола (или "UDP").
<br><br>**Пример удаление порта:**

>"C:\Program Files\UPnP\UPnP.exe" /remove 8080 TCP

## Загрузка
>Версия для Windows XP, 7, 8.1, 10.<br>
**[Загрузить](https://github.com/r57zone/UPnP/releases)**

## Обратная связь
`r57zone[собака]gmail.com`