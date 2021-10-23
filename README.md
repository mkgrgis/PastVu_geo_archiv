#PastVu GeoArchive
*Архивирует географические координаты изображений из проекта* **https://github.com/PastVu/pastvu**
Может архивировать изображения по указанному региону.

##Формат вызова архивирующей программы координат изображений

cd *КаталогПрограммы*
./'PastVu GeoArchive.sh' НачальныйКод КонечныйКод Шаг;
**Где**
*НачальныйКод* - наименьший код изображения, координаты кторого должны быть архивированы
*КонечныйКод* - набольший код изображения, координаты кторого должны быть архивированы
*Шаг* лучше выбирать так, чтобы диапазон делился на 2 или 3 шага.

**Настроить**
1. Создать базу данных в PostgreSQL 10+, установить в ней PostGIS 2+.
2. Создать объекты в базе данных согласно *PastVu GeoArchive.sql*.
3. Убедиться в правильности первых строк *PastVu GeoArchive.sh* для своей конфигурации

> DB='Геоинформационная система';
> API_table='"PastVu"."JSON_API"';
> API_URL='https://pastvu.com/api2?method=photo.giveForPage';

##Формат вызова архивирующей программы изображений по региону

cd *КаталогПрограммы*
./'PastVu ImgArchive region.sh' Код;
**Где**
*Код* Код региона в виде целого числа согласно БД PastVu.

**Настроить**
1. Провести архивацию всего диапазона координат для поиска изображений дагнного региона

##Вспомогательная программа-информатор

*PastVu GeoArchive info.sh* в бесконечном цикле показывает сообщение с числом изображений, координаты которых архивированы. Требует установки программы **zenity**, присутствующей во многих листрибутивах GNU/Linux.

##Системные требования
1. **GNU/Linux** или многие др. Unix-подобные ОС
2. **PostgreSQL** 10+ как СУБД для ахивирования координат
3. **PostGIS** 2+ как пакет географических утилит для PostgreSQL
4. **jq** как обработчик JSON данных от API PastVu
5. **sed** как фильтр замены 
6. **tr** как фильтр данных против недостустимых в PostgreSQL JSON нулевых символов
7. **wget** как средство скачивания данных