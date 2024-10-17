# infra_test
Для теста использовалась виртуальная машина Amazon Linux. 
Порядок действий:
1) Установить Ansible (sudo yum install ansible)
2) Скопировать файлы [setup.yml](https://github.com/HungryMurky/infra_test/blob/main/setup.yml) и [inventory.ini](https://github.com/HungryMurky/infra_test/blob/main/inventory.ini) на виртуальную машину

  wget https://raw.githubusercontent.com/HungryMurky/infra_test/refs/heads/main/setup.yml
  
  wget https://raw.githubusercontent.com/HungryMurky/infra_test/refs/heads/main/inventory.ini
  
4) Запустить Ansible playbook: ansible-playbook -i inventory.ini setup.yml

Playbook выполнит следующее:
- Установит docker
- Установит docker-compose
- Скопирует все необходимые файлы из данного репозитория в папку /home/ec2-user/infra_test (создаст директорию при необходимости)
- Запустит docker и docker-compose (в данном случае результатом этого будет 3 контейнера: nginx как reverse proxy , apache как webserver , postgresql как БД с необходимой информацией)
- Установит cron
- Добавит задачи в cron для выполнения двух bash скриптов раз в 5 минут, подробнее о скриптах ниже:

[pushtoDB.bash](https://github.com/HungryMurky/infra_test/blob/main/pushtoDB.bash). Собирает данные согласно заданию, подключается к postgres, при необходимости создает таблицу и заносит в нее данные;

[getfromDB.bash](https://github.com/HungryMurky/infra_test/blob/main/getfromDB.bash). Подключается к postgres, запрашивает последнюю добавленную строку из таблицы, переносит данные в html страницу Apache.

Проверить работу здесь: http://13.60.50.63:8080/
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Тестовое задание на IT Infrastructure Engineer
Список технологий (продуктов): 
•	Docker и Docker Compose, 
•	Ansible, 
•	Nginx, 
•	Apache, 
•	база данных (MariaDB, PostgreSQL и т. Д.), 
•	Bash-скрипт, 
•	CMS или HTML страница.
Среда реализации задания: Linux.

1.	Для выполнения задания вы должны реализовать цепочку (структуру) на дистрибутиве Linux. Необходимо использовать все (!) технологии, перечисленные в списке выше. 
2.	Ваше решение должно иметь описание и быть опубликовано в Github или аналогичной среде.

В случае замены технологии из списка на другую, обосновать в описании: почему и какие преимущества это вам дает. Без такого обоснования нельзя выбирать другую технологию, даже если вы с ней знакомы лучше.

Реализовать вывод характеристик операционной системы Linux: сеть, вычислительные ресурсы, время, пользователи, процессы и т. п.
Для публикации использовать связку web-серверов Nginx и Apache.  
Для публикации данных на web-сервере допустимо использовать любую CMS или html-страницу.
