# ExampleSVC
Описание сервиса.

После клонирования заменить во всех файлах
`ExampleSVC` => `ServiceNameSVC`
`example_svc` => `service_name_svc`
`EXAMPLESVC` => `SERVICENAMESVC`
`examplesvc` => `servicenamesvc`

Сервис принимает сообщения Kafka через topic `example_svc` и отправляет ответ через topic `api`. 

# Окружение
### Ruby 3.1.1
### Karafka 2.0.0.alpha2
#### ROM, Dry::Monads, Dry::System

# Настройка и запуск
Переменные окружения могут быть добавлены через ".env" файл.

## Переменные для подключения к базе данных:

`DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`

## Другие переменные

`APP_ENV` - `test`, `development` или `production`

## Алгоритм установки зависимостей
1) Установить **Ruby**;
2) Установить **Postgres**;
3) Установить **Kafka** сервер;
3) Запустить `bundle install` в корне проекта.

## Команда для запуска сервера приложения:
`bundle exec karafka server`

## Команда запуска консоли разработчика
`bundle exec karafka console`
ИЛИ 
`./bin/console`

## Команда запуска тестов
`rspec`

## Команда запуска ruby линтера
`rubocop`

# Алгоритм внесения изменений в репозиторий сервиса
1) Добавить изменения;
2) Написать или исправить тесты;
3) Запустить тесты и проверить на наличие ошибок;
4) Проверить на наличие ошибок линтера.