# Архитектура приложения CharacterBook

```
<корневой каталог проекта>
├── .github/                  # Конфигурация GitHub Actions
│   └── workflows/
│       └── dart.yml          # CI/CD пайплайн
├── assets/                   # Статические ресурсы приложения
│   ├── fonts/                # Шрифты
│   └── ...                   # Изображения и иконки
├── lib/                      # Основная кодовая база на Dart
│   ├── features/             # Функциональные модули
│   │   ├── backup/           # Резервное копирование и восстановление
│   │   │   ├── data/         # Адаптеры репозиториев, файлов и Google Drive
│   │   │   ├── domain/       # Порты, контракт хранилища и use case
│   │   │   └── presentation/ # Экран настроек, контроллер, автокопирование
│   │   ├── notifications/    # Локальные напоминания и in-app уведомления
│   │   │   ├── data/         # Адаптер flutter_local_notifications
│   │   │   └── presentation/ # Оверлей уведомлений
│   │   └── sharing/          # Системный шаринг, clipboard и экспорт файлов
│   │       ├── data/
│   │       │   ├── file_share_service.dart
│   │       │   ├── pdf_export_service.dart
│   │       │   └── word_export_service.dart
│   │       └── presentation/
│   │           ├── clipboard_service.dart
│   │           ├── pdf_export_manager.dart
│   │           ├── share_options_dialog.dart
│   │           ├── sharing_manager.dart
│   │           └── word_export_manager.dart
│   ├── adapters/             # Адаптеры для Hive
│   │   └── custom_field_adapter.dart
│   ├── core/                 # Ядро приложения, базовые сущности
│   │   ├── base_entity.dart
│   │   ├── app_notification_actions.dart
│   │   ├── file_share_actions.dart
│   │   └── local_notification_actions.dart
│   ├── data/                 # Слой данных
│   │   ├── enums/            # Перечисления
│   │   │   ├── calendar_event_type_enum.dart
│   │   │   ├── character_sort_enum.dart
│   │   │   ├── home_content_type_enum.dart
│   │   │   ├── note_sort_enum.dart
│   │   │   ├── template_sort_enum.dart
│   │   │   └── race_sort_enum.dart
│   │   ├── models/           # Модели данных
│   │   │   ├── calendar_event_model.dart
│   │   │   ├── character_model.dart
│   │   │   ├── ... (другие модели)
│   │   │   └── relationship_model.dart
│   │   ├── repositories/     # Репозитории для доступа к данным
│   │   │   ├── character_repository.dart
│   │   │   ├── ... (другие репозитории)
│   │   │   └── template_repository.dart
│   │   └── services/         # Сервисы для работы с данными
│   │       ├── character_service.dart
│   │       ├── ... (другие сервисы)
│   │       └── template_service.dart
│   ├── extensions/           # Расширения для встроенных классов
│   │   └── color_extension.dart
│   ├── gen/                  # Сгенерированные файлы (assets)
│   │   └── assets.gen.dart
│   ├── generated/            # Сгенерированные файлы локализации
│   │   └── intl/
│   │       ├── messages_all.dart
│   │       ├── messages_en.dart
│   │       ├── messages_ru.dart
│   │       └── l10n.dart
│   ├── handlers/             # Обработчики файлов для разных платформ
│   │   ├── desktop_file_handler.dart
│   │   ├── file_handler.dart
│   │   ├── file_handler_wrapper.dart
│   │   └── web_file_handler.dart
│   ├── interfaces/           # Интерфейсы (контракты)
│   │   └── file_handler_interface.dart
│   ├── l10n/                 # Исходные файлы локализации
│   │   ├── intl_en.arb
│   │   └── intl_ru.arb
│   ├── providers/            # Провайдеры состояния
│   │   ├── locale_provider.dart
│   │   ├── swipe_action_settings_provider.dart
│   │   └── theme_provider.dart
│   ├── services/             # Внешние сервисы и утилиты
│   │   ├── date_formatter.dart
│   │   └── ...
│   └── ui/                   # Компоненты пользовательского интерфейса
│       ├── controllers/      # Контроллеры для экранов
│       ├── navigation/       # Навигационные компоненты
│       ├── screens/          # Основные экраны
│       │   ├── settings/
│       │   ├── characters/
│       │   ├── races/
│       │   ├── notes/
│       │   ├── templates/
│       │   ├── calendar/     # Экран календаря
│       │   └── ...
│       └── widgets/          # Переиспользуемые виджеты
├── test/                     # Модульные и виджет-тесты
│   ├── unit/                 # Unit-тесты сервисов и репозиториев
│   └── widget/               # Виджет-тесты экранов
├── web/                      # Конфигурация для Web
├── android/                  # Конфигурация для Android
├── ios/                      # Конфигурация для iOS
├── linux/                    # Конфигурация для Linux
├── macos/                    # Конфигурация для macOS
└── windows/                  # Конфигурация для Windows

main.dart                     # Точка входа в приложение
```

## Технологический стек

### Основные технологии
- Flutter 3.13+ — кроссплатформенный UI фреймворк
- Dart 3.7.2+ — язык программирования

### Управление состоянием
- Provider — основной инструмент для управления состоянием (используется `ChangeNotifierProvider`, `ProxyProvider`, `MultiProvider`)
- Flutter Bloc ^9.1.1 — для более сложных сценариев управления состоянием

### Генерация кода
- json_serializable, build_runner — для сериализации JSON
- hive_generator — генерация адаптеров Hive
- flutter_gen — генерация типизированных ассетов
- intl_utils — для локализации

### Локальное хранилище
- Hive 2.2.3 — быстрая NoSQL база данных для хранения моделей
- Shared Preferences — для хранения пользовательских настроек

### Работа с файловой системой
- file_picker — выбор файлов
- `features/sharing/data/FileShareService` — системный шаринг файлов через `share_plus`
- `features/sharing/presentation/ClipboardService` — копирование форматированного содержимого

### Генерация PDF
- pdf — создание PDF-документов
- printing — печать
- docs_gee — создание DOCX-файлов (Word)

### Интеграция с платформой
- url_launcher — открытие внешних ссылок
- dynamic_color — поддержка динамических цветов Material You

### Взаимодействие с платформой и облаком
- google_sign_in — аутентификация Google
- googleapis — работа с Google Drive API
- extension_google_sign_in_as_googleapis_auth — адаптер для использования токенов
- image_picker — выбор изображений
- crop_image — обрезка изображений
- open_filex — открытие файлов

### Календарь и уведомления
- table_calendar — виджет календаря
- `features/notifications/data/LocalNotificationService` — локальные напоминания через flutter_local_notifications
- `features/notifications/presentation/OverlayNotificationService` — внутриигровые уведомления-оверлеи

### Форматирование
- flutter_markdown — отображение Markdown в описаниях

## Модульная структура
Разделение приложения на модули выполняется постепенно. Сейчас в проекте выделяются слои и функциональные модули, но архитектура ещё не является полностью независимой clean architecture:
- Ядро (`core/`) — базовые сущности предметной области.
- Общие контракты (`core/`) — интерфейсы интеграции, не привязанные к реализациям модулей.
- Данные (`data/`) — модели, репозитории, сервисы для работы с данными.
- Функциональные модули (`features/`) — самостоятельные вертикальные части функциональности.
- Обработчики (`handlers/`) — платформозависимая работа с файлами.
- Интерфейсы (`interfaces/`) — контракты для реализации функций.
- Общие сервисы (`services/`) — общеприложенческие сервисы и утилиты.
- Провайдеры (`providers/`) — управление состоянием приложения (тема, язык, настройки).
- UI (`ui/`) — представление данных, экраны, виджеты, контроллеры.

Новые функциональные области следует выделять в `features/`, сохраняя зависимости направленными внутрь модуля и не перенося в него модели или хранилища без необходимости.

### Модуль `features/sharing/`
- `presentation/ShareOptionsDialog` показывает действия «Копировать», «Поделиться файлом», «Экспорт в PDF» и «Экспорт в Word», получая конкретные действия от вызывающей стороны.
- `presentation/SharingManager` содержит сценарии сериализации и отправки персонажей (`.character`), рас (`.race`), заметок (`.note`/`.json`) и шаблонов (`.chax`). UI-контроллеры вызывают модуль; data-сервисы отвечают только за чтение и изменение хранимых данных.
- Формирование PDF/DOCX, показ статусов экспорта, системный share sheet и форматирование текста для clipboard находятся внутри модуля. UI-компоненты импортируют нужные возможности из `features/sharing/`.
- Порт `core/FileShareActions` позволяет другим сценариям передавать байты на системный share sheet без зависимости от sharing-модуля. Composition root (`main.dart`) связывает порт с `features/sharing/data/FileShareService`; модуль резервного копирования не зависит от sharing.

### Модуль `features/notifications/`
- `data/LocalNotificationService` — адаптер платформенного плагина для планирования и отмены уведомлений. Он реализует контракт `core/LocalNotificationActions`; календарь использует контракт и не зависит от плагина.
- `presentation/OverlayNotificationService` реализует `core/AppNotificationActions` и отображает in-app уведомления поверх корневого Navigator. Оверлей и platform-specific SDK остаются внутри модуля.
- Composition root (`main.dart`) инициализирует платформенный адаптер и связывает реализации с контрактами. `AppNavigator` зависит только от `AppNotificationActions`, а календарь — только от `LocalNotificationActions`. Модуль уведомлений не зависит от backup, sharing, календаря или навигации.
- Зависимости передаются у composition root; локальные уведомления инициализируются до `runApp`. Это соответствует рекомендациям Flutter разделять UI и data-слои, использовать явные контракты и внедрение зависимостей: [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide).

### Модуль `features/backup/`
- `domain/BackupManager` координирует создание и восстановление резервной копии через абстракции `BackupRepository` и `LocalBackupActions`/`CloudBackupActions`; доменный слой не обращается к Hive, файловой системе, Google Drive или UI.
- `data/RepositoryBackupRepository` адаптирует существующие репозитории персонажей, рас, заметок, шаблонов и связей к формату JSON-резервной копии. Перед очисткой данных входные секции и записи проверяются, а неизвестный формат отклоняется.
- `data/LocalBackupService` реализует локальный экспорт/импорт; экспорт на мобильных и десктопных платформах использует порт `core/FileShareActions`, а веб-экспорт скачивает файл браузером.
- `data/CloudBackupService` инкапсулирует вход через Google Sign-In и работу с Google Drive. Он не вызывает экран настроек и не показывает уведомления.
- `presentation/BackupController`, `AutoBackupProvider` и `BackupSettingsScreen` содержат состояние действий, настройку автокопирования и весь UI сценария. Контроллер зависит от доменных портов, а не от data-реализаций. Общий экран настроек только открывает экран резервного копирования.
- Composition root (`main.dart`) соединяет модуль с общими репозиториями и платформенными адаптерами. Backup использует общие порты хранения и share sheet; модули backup и sharing не зависят друг от друга.
- Локализационные строки остаются в общей локализации приложения; предметная логика и отображение ошибок принадлежат presentation-слою, а сервисы возвращают ошибки вызывающему коду вместо их подавления.

## Модели данных (из `lib/data/models/`)

### Character (Персонаж)
- Тип Hive: `typeId: 0`
- Назначение: Основная сущность приложения для хранения данных о персонажах.
- Ключевые поля: `id`, `name`, `age`, `gender`, `biography`, `personality`, `appearance`, `imageBytes`, `referenceImageBytes`, `additionalImages`, `customFields`, `race`, `tags` (вместо `folderId` используется система тегов).

### Race (Раса)
- Тип Hive: `typeId: 3`
- Назначение: Хранение данных о расах персонажей.
- Ключевые поля: `name`, `description`, `biology`, `backstory`, `logo`, `tags`.

### Note (Заметка)
- Тип Hive: `typeId: 2`
- Назначение: Система заметок, связанных с персонажами.
- Ключевые поля: `title`, `content`, `characterIds`, `tags`.

### QuestionnaireTemplate (Шаблон анкеты)
- Тип Hive: `typeId: 4`
- Назначение: Шаблоны для быстрого создания персонажей.
- Ключевые поля: `name`, `standardFields`, `customFields`.

### Relationship (Связь)
- Тип Hive: `typeId: 6`
- Назначение: Хранение связей между персонажами.
- Ключевые поля: `fromCharacterId`, `toCharacterId`, `type`, `description`.

### ExportPdfSettings (Настройки экспорта PDF)
- Тип Hive: `typeId: 7`
- Назначение: Настройки для генерации PDF.
- Ключевые поля: `paperSize`, `orientation`, `includeImages`, `template`.

### CustomField (Пользовательское поле)
- Тип Hive: `typeId: 1`
- Назначение: Хранение пользовательских полей типа ключ-значение.
- Ключевые поля: `key`, `value`.

### CalendarEvent (Событие календаря)
- Тип Hive: `typeId: 11`
- Назначение: Планирование событий, связанных с персонажами или кампанией.
- Ключевые поля: `title`, `description`, `date`, `characterIds`, `type`, `reminder` (время напоминания).

### SwipeAction (Жесты свайпа)
- Тип Hive: `typeId: 12`
- Назначение: Хранение настроек действий по свайпу для списков.
- Ключевые поля: `leftAction`, `rightAction`, `enabled`.

> **Примечание:** Модель `Folder` была удалена. Организация контента теперь полностью осуществляется через систему **тегов**. Теги можно назначать персонажам, расам и заметкам, а затем фильтровать по ним.

## Жизненный цикл приложения

### Инициализация
- `WidgetsFlutterBinding.ensureInitialized()`
- Инициализация Hive через `HiveService.initHive()`
- Регистрация адаптеров Hive (например, `RelationshipAdapter`)
- Открытие всех боксов с повторными попытками (`_openBoxWithRetry`)
- Инициализация `FileHandler.initialize()`
- Инициализация `LocalNotificationService` до `runApp`; `AppNavigator` получает in-app адаптер через core-порт
- Запуск `runApp` с `CharacterBookApp`
- В `CharacterBookApp` создаётся `MultiProvider` с репозиториями, сервисами и провайдерами состояния
- В `_AppContent` настраивается метод-канал (`MenuChannel`) и проверяется успешность инициализации Hive

### Управление состоянием
- `ThemeProvider` — управление светлой/тёмной темой
- `LocaleProvider` — управление локализацией
- `SwipeActionSettingsProvider` — настройки жестов свайпа
- Уведомления приложения управляются модулем `features/notifications/`; его интеграция описана выше в разделе модульной структуры

### Работа с данными
- Репозитории (`*Repository`) инкапсулируют доступ к Hive боксам.
- Сервисы (`*Service`) используют репозитории для бизнес-логики.
- Провайдеры связывают UI с состоянием (например, `HomeController` использует сервисы для загрузки данных).

### MenuChannelService
- Обработка вызовов из нативного меню (например, открытие файла, создание персонажа).
- Интеграция с `MethodChannel` для десктопных платформ.

## Десктоп-специфичные функции
- Кастомная панель заголовка (управление окном) — реализована через `window_manager`.
- Кнопки управления окном (свернуть/развернуть/закрыть).
- Автоматическое определение платформы и адаптация UI.
- Поддержка нативных диалогов выбора файлов через `file_selector`.
- Интеграция с системным меню через `MenuChannelService`.

## Облачная синхронизация
- Google Drive используется модулем `features/backup/data/CloudBackupService` для хранения резервных копий.
- Резервные копии доступны через Google Drive API в пространстве файлов приложения.
- Настройка автоматического облачного резервирования и запуск при старте приложения реализованы внутри модуля резервного копирования.
- Планируется поддержка iCloud (iOS) и OneDrive.

## Календарь и напоминания
- Экран календаря (`ui/screens/calendar/`) построен на виджете `table_calendar`.
- События (`CalendarEvent`) отображаются на календаре с цветовой индикацией по типу.
- При создании/редактировании события можно установить время напоминания (через `flutter_local_notifications`).
- В указанное время приложение показывает уведомление даже в фоновом режиме (на платформах, где это поддерживается).

## Ключевые компоненты UI
### Экран «Главный» (HomeScreen)
- Отображает сетку последних персонажей, рас и инструментов.
- Использует `HomeController` для загрузки данных и управления поиском.
- Плавающая кнопка `HomeFloatingMenu` для быстрого создания нового контента.
- Контекстное меню для элементов (через `tools_context_menu.dart`).

### Навигация
- `AppNavigationBar` — главная навигационная панель (нижняя на мобильных, боковая на десктопе).
- `MenuContent` — содержимое бокового меню.

### Модальные окна
- `CharacterModalCard` — детальный просмотр персонажа.
- `RaceModalCard` — детальный просмотр расы.
- `EventModalCard` — детальный просмотр/редактирование события календаря.

### Виджеты списков
- `CharacterKeepCardItem` — карточка персонажа на главном экране.
- `RaceKeepCardItem` — карточка расы.
- `ToolKeepCardItem` — карточка инструмента.

## Тестирование
- **Unit-тесты** (`test/unit/`) — покрывают бизнес-логику модулей и репозиториев; тесты резервного копирования находятся рядом с соответствующей feature-областью.
- **Виджет-тесты** (`test/widget/`) — проверяют ключевые экраны: `HomeScreen`, `CharacterScreen`, `CalendarScreen`, а также переиспользуемые виджеты.
- **Интеграционные тесты** (`integration_test/`) — проверяют сквозные сценарии (импорт/экспорт, синхронизация с облаком).

Для запуска тестов:
```bash
flutter test
flutter test --coverage
```