[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/UPnP/blob/master/README.md) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/UPnP/blob/master/README.RU.md) 
# UPnP
Приложение для перенаправления портов на маршрутизаторе, через UPnP.

## Скриншоты
![](https://user-images.githubusercontent.com/9499881/34568119-374720d0-f17e-11e7-8a0b-43560f397b87.PNG)

## Настройка
Для авто-добавления порта, при запуске системы, нужно заранее добавить ярлык в автозагрузку, с параметрами запуска.<br>
<br>**Пример добавления TCP порта:**
>"C:\Program Files\UPnP\UPnP.exe" -add -i 8080 -e 80 -ip 192.168.0.100 -n "webserver (TCP)"

Где "nginx (TCP)" это название, "8080" - внутренний порт, "80" - внешний. Для UDP добавить параметр "-udp".
<br><br><br>**Пример удаление TCP порта:**

>"C:\Program Files\UPnP\UPnP.exe" -rem -e 80

Для UDP добавить параметр "-udp".

## Загрузка
>Версия для Windows 7, 8.1, 10.<br>
**[Загрузить](https://github.com/r57zone/UPnP/releases)**

## Обратная связь
`r57zone[собака]gmail.com`