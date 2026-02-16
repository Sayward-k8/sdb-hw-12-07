## Домашнее задание к занятию «`Репликация и масштабирование. Часть 2`» - ` Игонин В.А.`

# Задание 1
Опишите основные преимущества использования масштабирования методами:

  - активный master-сервер и пассивный репликационный slave-сервер;
  - master-сервер и несколько slave-серверов;

Дайте ответ в свободной форме.

# Решение 1

Master-Master - Клиенты могут считывать данные с любого мастера. Распределяет сетевую нагрузку на запись между мастерами. Простой, автоматический и быстрый переход на другой ресурс.

Master-Slave - Клиенты производят чтение со слейвов, не нагружая чтением мастер. Резервное копирование всей базы данных не сильно влияет на мастер. Слейвы могут быть переведены в автономный режим и синхронизированы с мастером без простоев. Уменьшает нагрузку на основной сервер, значительно повышая отказоустойчивость и сокращая время простоя работы с БД в случае отказа до минимума.

Master-Slave x N - так же, как и мастер-слейв, но многократно прямопропорционально кол-ву слейвов.

# Задание 2
Разработайте план для выполнения горизонтального и вертикального шаринга базы данных. База данных состоит из трёх таблиц:

  - пользователи,
  - книги,
  - магазины (столбцы произвольно).

Опишите принципы построения системы и их разграничение или разбивку между базами данных.

Пришлите блоксхему, где и что будет располагаться. Опишите, в каких режимах будут работать сервера.

# Решение 2

![alt text](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/img/12-7-1.png)

#### Вертикальный шардинг
Разносим таблицы по трем серверам (каждая таблица на отдельном сервере)

| Сервер | Таблицы |
|--------|---------|
| Server A | users, user_books |
| Server B | books |
| Server C | stores |

#### Горизонтальный шардинг

SERVER A (users + user_books)
Ключ шардирования: user_id

| SERVER A | user_id |
|--------|---------|
| Server A1 | 1-100 |
| Server A2 | 101-200 |
| Server A3 | 201-300 |
| Server A* | и тд. |

Либо использовать чётные ID/нечётные ID

SERVER B (books)
Ключ шардирования: book_id

| SERVER B | book_id |
|--------|---------|
| Server B1 | 1-100 |
| Server B2 | 101-200 |
| Server B3 | 201-300 |
| Server B* | и тд. |

Либо использовать чётные ID/нечётные ID

SERVER C (stores)

| SERVER C | region |
|--------|---------|
| Server C1 | территориальная принадлежность |
| Server C2 | например страна |
| Server C3 |  регионы РФ |
| Server C* | или города |


# Задание 3*

Выполните настройку выбранных методов шардинга из задания 2.

Пришлите конфиг Docker и SQL скрипт с командами для базы данных.

# Решение 3

Я решил вставлять данные сразу и поэтому в конце добавил INSERT, но столкнулся с проблемой, что шарды не успевали стартовать и данных не было, поэтому я запускаю 
`` docker-compose up -d users_1 users_2 books_1 books_2 ``, а затем `` docker-compose up -d stores users books ``

[полный конфиг](https://github.com/Sayward-k8/sdb-hw-12-07/tree/main/SHARD)


[docker-compose.yml](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/docker-compose.yml)
[shards_books.sql](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/books/shards_books.sql)
[shards.sql для books_1](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/books_1/shards.sql)
[shards.sql для books_2](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/books_2/shards.sql)
[shards_users.sql](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/users/shards_users.sql)
[shards.sql для users_1](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/users_1/shards.sql)
[shards.sql для users_2](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/users_2/shards.sql)
[shards.sql для stores](https://github.com/Sayward-k8/sdb-hw-12-07/blob/main/SHARD/conf/stores/shards.sql)
