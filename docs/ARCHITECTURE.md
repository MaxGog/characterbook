# Архитектура приложения CharacterBook

```
<корневой каталог проекта>
├── .github/                  # Конфигурация GitHub Actions
│   └── workflows/
│       ├── dart.yml          # Анализ, тесты и сборки всех платформ
│       └── ...               # Ручная упаковка платформенных артефактов
├── assets/                   # Статические ресурсы приложения
│   ├── fonts/                # Шрифты
│   └── ...                   # Изображения и иконки
├── lib/                      # Основная кодовая база на Dart
│   ├── features/             # Функциональные модули
│   │   ├── characters/       # Персонажи и связанные сценарии/экраны
│   │   │   ├── application/  # Сценарии использования
│   │   │   ├── data/         # Hive records, мапперы и репозиторий
│   │   │   ├── domain/       # Сущности, enums/, контракт репозитория
│   │   │   └── presentation/ # UI, контроллеры и Provider-состояние
│   │   ├── races/            # Расы, выбор расы и связанные экраны
│   │   │   ├── application/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── notes/            # Заметки и связанные экраны
│   │   │   ├── application/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── relationships/    # Связи между персонажами
│   │   ├── templates/        # Шаблоны персонажей
│   │   ├── calendar/         # События календаря и напоминания
│   │   ├── home/             # Главный экран, контроллер и его виджеты
│   │   ├── backup/           # Резервное копирование и восстановление
│   │   │   ├── data/         # Адаптеры репозиториев, файлов и Google Drive
│   │   │   ├── domain/       # Порты, контракт хранилища и use case
│   │   │   └── presentation/ # Экран настроек, контроллер, автокопирование
│   │   ├── settings/         # Тема, локаль и настройки жестов
│   │   │   ├── data/         # Реализации состояния и локального хранения
│   │   │   ├── domain/       # Контракты действий настроек и типы темы
│   │   │   └── presentation/ # Экраны и виджеты настроек
│   │   ├── notifications/    # Локальные напоминания и in-app уведомления
│   │   │   ├── data/         # Адаптер flutter_local_notifications
│   │   │   └── presentation/ # Оверлей уведомлений
│   │   └── sharing/          # Системный шаринг, clipboard и экспорт файлов
│   │       ├── application/  # Use cases экспорта документов
│   │       ├── domain/       # Контракты настроек экспорта
│   │       ├── data/
│   │       │   ├── file_share_service.dart
│   │       │   ├── pdf_export_service.dart
│   │       │   └── word_export_service.dart
│   │       └── presentation/
│   │           ├── clipboard_service.dart
│   │           ├── export_pdf_settings_screen.dart
│   │           ├── pdf_export_manager.dart
│   │           ├── share_options_dialog.dart
│   │           ├── sharing_manager.dart
│   │           └── word_export_manager.dart
│   ├── core/                 # Ядро приложения, базовые сущности
│   │   ├── base_entity.dart
│   │   ├── app_settings_actions.dart
│   │   ├── app_notification_actions.dart
│   │   ├── file_share_actions.dart
│   │   └── local_notification_actions.dart
│   │   └── storage/          # Общая Hive-инфраструктура и маппинг-репозиторий
│   ├── data/                 # Старый каталог; Dart-модели и репозитории перенесены
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
│   ├── providers/            # Общие, не принадлежащие feature-модулям провайдеры
│   ├── services/             # Внешние сервисы и утилиты
│   │   ├── date_formatter.dart
│   │   └── ...
│   └── ui/                   # Компоненты пользовательского интерфейса
│       ├── navigation/       # Навигационные компоненты
│       ├── screens/          # Общие экраны приложения
│       └── widgets/          # Общие и переиспользуемые виджеты
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

- Flutter 3.50.0 — кроссплатформенный UI-фреймворк (версия закреплена в `.fvmrc`)
- Dart из закреплённого Flutter SDK — язык программирования

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
- androidx.appcompat — нативная per-app локализация Android через `AppCompatDelegate.setApplicationLocales` (см. раздел «Android-специфичные функции»)

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

Фичи организованы по слоям `domain`, `application`, `data` и `presentation`. Направление зависимостей — внутрь: доменные сущности и контракты не импортируют Flutter, Hive или реализации репозиториев. `main.dart` выступает composition root для зависимостей и маршрутизации.

- Ядро (`core/`) — базовые сущности предметной области.
- Общие контракты (`core/`) — интерфейсы интеграции, не привязанные к реализациям модулей.
- Данные (`features/*/data/`) — адаптеры хранилища и мапперы доменных сущностей.
- Функциональные модули (`features/`) — самостоятельные вертикальные части функциональности.
- Обработчики (`handlers/`) — платформозависимая работа с файлами.
- Интерфейсы (`interfaces/`) — контракты для реализации функций.
- Общие сервисы (`services/`) — общеприложенческие сервисы и утилиты.
- Провайдеры (`providers/`) — управление состоянием приложения (тема, язык, настройки).
- UI (`ui/`) — представление данных, экраны, виджеты, контроллеры.

Персонажи, расы и заметки разделены на независимые доменные модели и Hive persistence records. `data/` преобразует records в сущности через мапперы и реализует контракты из `domain/`; UI не открывает Hive-box напрямую. Provider-классы, наследующие `ChangeNotifier`, находятся в `presentation/providers/`, а прикладные сценарии без UI-зависимостей — в `application/`. Общая Hive-инфраструктура находится в `core/storage/`.

### Модули `features/characters/`, `features/races/` и `features/notes/`

- Для каждой области определены контракты репозиториев в `domain/`, Hive-реализации и мапперы в `data/`. Общие операции над Hive-box вынесены в `core/storage/HiveBoxRepository`.
- Доменные модели `Character`, `Race`, `Note` и `CustomField` не зависят от Hive. Адаптеры регистрируются для отдельных persistence records в соответствующих каталогах `data/`; Hive typeId и индексы полей сохранены для чтения существующих данных.
- Hive records персонажей, рас, заметок и связей содержат опциональное поле `sortOrder`; отсутствие этого поля в старых записях поддерживается. Порядок обновляется без изменения Hive-ключей, на которые могли ссылаться старые заметки.
- Типы сортировки персонажей, рас и заметок также принадлежат `domain/enums/` соответствующей фичи.
- Экраны, контроллеры, Provider-состояние и специфичные для фичи виджеты находятся в её `presentation/`. Переиспользуемые компоненты приложения остаются в `ui/`; навигация связывает их с экранами фич.
- Presentation-слой получает данные через доменные контракты репозиториев и не открывает Hive-box напрямую.
- `Character.race` опциональна. Форма персонажа проверяет наличие имени, но не требует выбранной расы.

### Модуль `features/settings/`

- Экраны настроек темы, языка и жестов, а также соответствующие реализации состояния и локального хранения принадлежат модулю. Экран настроек приложения не импортирует экраны backup или sharing.
- `presentation/SettingsActions` — UI-контракты для темы и локали. Экраны зависят от них, а не от конкретных провайдеров; composition root (`main.dart`) связывает реализации с портами.
- `domain/LocaleChannelActions` — платформенно-независимый порт для нативной синхронизации языка; реализация `data/LocaleChannelService` использует `MethodChannel`.
- `core/SwipeActionSettingsActions` — минимальный контракт для общего виджета карточки вне модуля. Settings реализует его, а composition root публикует реализацию; общий UI не зависит от конкретного провайдера настроек.
- `AppRouter` — composition root навигации: он связывает маршруты settings с экранами settings, backup и PDF-экспорта. Переходы между feature-модулями выполняются по маршрутам, поэтому settings не импортирует соседние модули.
- Провайдеры темы, локали и жестов находятся в `presentation/providers/` и создаются у composition root, так как ими пользуется всё приложение (`MaterialApp`). Провайдер локали получает `LocaleChannelActions`, а не вызывает MethodChannel-адаптер напрямую.
- Модуль следует направлению зависимостей Flutter: presentation использует состояние/контракты, а платформенные и внешние реализации остаются в data; общие зависимости передаются через composition root. См. [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide).
- `data/LocaleChannelService` — адаптер над `MethodChannel('app_locale')`; он реализует порт `LocaleChannelActions`, проверяет Android-платформу и перехватывает недоступность нативного канала.
- `presentation/providers/LocaleProvider` остаётся единственным источником истины для `MaterialApp.locale`. При старте он вызывает `_loadPreferences()` (SharedPreferences) и `_syncFromNative()` (только Android). `setLocale` сохраняет выбор, обновляет состояние и вызывает порт `LocaleChannelActions`.
- `presentation/SettingsScreen` содержит `_AndroidLanguageSyncNote` — информационный блок по гайдлайнам Material 3 (`secondaryContainer`, `FilledButton.tonalIcon`). Виджет рендерится только на Android и скрыт на остальных платформах через `kIsWeb` + `defaultTargetPlatform`.

### Модуль `features/sharing/`

- `presentation/ShareOptionsDialog` показывает действия «Копировать», «Поделиться файлом», «Экспорт в PDF» и «Экспорт в Word», получая конкретные действия от вызывающей стороны.
- `presentation/SharingManager` содержит сценарии сериализации и отправки персонажей (`.character`), рас (`.race`), заметок (`.note`/`.json`) и шаблонов (`.chax`). UI-контроллеры вызывают модуль; data-сервисы отвечают только за чтение и изменение хранимых данных.
- Формирование DOCX находится в `application/WordExportService`; PDF-экспорт вызывается через `application/PdfExportActions`. Настройки PDF доступны через контракт `domain/ExportPdfSettingsActions`.
- `presentation/` отвечает за статусы экспорта и форматирование clipboard; системный share sheet вызывается через порт `core/FileShareActions`, а не прямым созданием data-реализации.
- Composition root (`main.dart`) связывает порты с адаптерами `features/sharing/data/`; модуль резервного копирования также использует `FileShareActions` и не зависит от sharing-модуля.

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

## Доменные модели и Hive records

Доменные модели и контракты расположены в `features/*/domain/`. Hive records, соответствующие адаптеры и мапперы находятся в `features/*/data/`. Их Hive typeId и индексы полей сохраняют совместимость с уже созданными базами.

### Character (Персонаж)

- Путь: `features/characters/domain/character_model.dart`; сортировка: `features/characters/domain/enums/character_sort_enum.dart`
- Hive record: `features/characters/data/CharacterRecord` (`typeId: 0`)
- Назначение: Основная сущность приложения для хранения данных о персонажах.
- Ключевые поля: `id`, `name`, `age`, `gender`, `biography`, `personality`, `appearance`, `imageBytes`, `referenceImageBytes`, `additionalImages`, `customFields`, опциональные `race` и `folderId`, `tags`.
- **Раса необязательна.** Поле `race` имеет тип `Race?`; персонажа можно сохранить без привязки к расе. `RaceSelectorField` по умолчанию работает в опциональном режиме (`isRequired: false`), всегда содержит пункт «Не выбрано» и не блокирует отправку формы. Валидация в `CharacterManagementController.save()` и `CharacterManagementScreen._onSaveAttempt()` проверяет только имя.
- `Character.copyWith(race: null)` снимает привязку к расе (sentinel-аргумент отличает «не передано» от «передано `null`»); при передаче непустой расы объект `Race` используется как есть, без пересоздания через `Race(id, name)` — остальные поля расы (`description`, `biology`, `backstory`, `logo`, `tags`) сохраняются.
- `Character.fromJson` восстанавливает расу только при наличии имени в JSON; отсутствующий `raceId` больше не приводит к ошибке — идентификатор генерируется.
- Hive-ключи не используются как доменные идентификаторы. Старые ссылки заметок на ключи персонажей преобразуются в стабильные ID при чтении; если строка уже является доменным ID, она сохраняется без преобразования.
- `sortOrder` хранится только в persistence records. Старые записи без этого поля читаются с порядком по существующей последовательности box; новые изменения порядка сохраняют ключи Hive.

### Race (Раса)

- Путь: `features/races/domain/race_model.dart`; сортировка: `features/races/domain/enums/race_sort_enum.dart`
- Hive record: `features/races/data/RaceRecord` (`typeId: 3`)
- Назначение: Хранение данных о расах персонажей.
- Ключевые поля: `name`, `description`, `biology`, `backstory`, `logo`, `tags`.

### Note (Заметка)

- Путь: `features/notes/domain/note_model.dart`; сортировка: `features/notes/domain/enums/note_sort_enum.dart`
- Hive record: `features/notes/data/NoteRecord` (`typeId: 2`)
- Назначение: Система заметок, связанных с персонажами.
- Ключевые поля: `title`, `content`, `characterIds`, `tags`.

### QuestionnaireTemplate (Шаблон анкеты)

- Hive record: `features/templates/data/TemplateRecord` (`typeId: 4`)
- Назначение: Шаблоны для быстрого создания персонажей.
- Ключевые поля: `name`, `standardFields`, `customFields`.

### Relationship (Связь)

- Hive record: `features/relationships/data/RelationshipRecord` (`typeId: 12`)
- Назначение: Хранение связей между персонажами.
- Ключевые поля: `fromCharacterId`, `toCharacterId`, `type`, `description`.

### ExportPdfSettings (Настройки экспорта PDF)

- Hive record: `features/sharing/data/ExportPdfSettingsRecord` (`typeId: 11`)
- Назначение: Настройки для генерации PDF.
- Ключевые поля: `paperSize`, `orientation`, `includeImages`, `template`.

### CustomField (Пользовательское поле)

- Путь: `features/characters/domain/custom_field_model.dart`
- Hive record: `CustomFieldRecord`, вложенный в `CharacterRecord` (`typeId: 1`)
- Назначение: Хранение пользовательских полей типа ключ-значение.
- Ключевые поля: `key`, `value`.

### CustomEvent (Событие календаря)

- Hive record: `features/calendar/data/CustomEventRecord` (`typeId: 13`)
- Назначение: Планирование событий, связанных с персонажами или кампанией.
- Ключевые поля: `title`, `description`, `date`, `characterIds`, `type`, `reminder` (время напоминания).

### SwipeAction (Жесты свайпа)

- Хранится в настройках приложения; Hive-адаптера у модели нет.
- Назначение: Хранение настроек действий по свайпу для списков.
- Ключевые поля: `leftAction`, `rightAction`, `enabled`.

> **Примечание:** Модель `Folder` была удалена. Организация контента теперь полностью осуществляется через систему **тегов**. Теги можно назначать персонажам, расам и заметкам, а затем фильтровать по ним.

## Жизненный цикл приложения

### Инициализация

- `WidgetsFlutterBinding.ensureInitialized()`
- Инициализация Hive через `HiveService.initializeAll()`
- Регистрация адаптеров Hive для persistence records (`CharacterRecordAdapter`, `NoteRecordAdapter` и т. д.)
- Открытие типизированных Hive-боксов; ошибки открытия не приводят к автоматическому удалению данных
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

- Репозитории (`*Repository`) инкапсулируют доступ к Hive-боксам и предоставляют доменные сущности.
- Сценарии приложения используют контракты репозиториев, а Provider-классы в `presentation/providers/` связывают UI с состоянием.
- Ошибки открытия Hive-боксов передаются вызывающему коду; приложение не удаляет автоматически повреждённые или несовместимые пользовательские данные.

### MenuChannelService

- Обработка вызовов из нативного меню (например, открытие файла, создание персонажа).
- Интеграция с `MethodChannel` для десктопных платформ.

## Десктоп-специфичные функции

- Кастомная панель заголовка (управление окном) — реализована через `window_manager`.
- Кнопки управления окном (свернуть/развернуть/закрыть).
- Автоматическое определение платформы и адаптация UI.
- Поддержка нативных диалогов выбора файлов через `file_selector`.
- Интеграция с системным меню через `MenuChannelService`.

## Android-специфичные функции

### Нативная локализация

- `MainActivity` (`android/app/src/main/kotlin/ru/maxgog/listcharacters/MainActivity.kt`) регистрирует MethodChannel `app_locale` с обработчиками `setLocale`, `getLocale`, `openSystemLanguageSettings`. Канал работает параллельно с существующими каналами `file_picker` и `file_handler` — файловая логика не затронута.
- Применение локали выполняется через `AppCompatDelegate.setApplicationLocales(LocaleListCompat)`. Это единый API для Android 13+ (нативно) и Android ≤ 12 (бэкпорт AppCompat). Требуется `androidx.appcompat:appcompat` версии ≥ 1.6.0.
- В `AndroidManifest.xml`:
  - `android:localeConfig="@xml/locales_config"` — список поддерживаемых локалей (`en`, `ru`) для системного экрана выбора языка.
  - `AppLocalesMetadataHolderService` с `android:enabled="false"` и `autoStoreLocales=true` — автоматическое сохранение per-app локали на API ≤ 32 (без ручного `SharedPreferences`).
  - `locale` в `android:configChanges` — Activity не пересоздаётся при смене языка; вместо этого `MainActivity.onConfigurationChanged` отправляет `onLocaleChanged` в Dart-канал, а `LocaleProvider` обновляет состояние.
- `res/xml/locales_config.xml` перечисляет поддерживаемые локали. Синхронизируется с `S.delegate.supportedLocales` в Dart-слое.
- `androidResources.localeFilters.addAll("en", "ru")` в `android/app/build.gradle.kts` — аналог устаревшего `resourceConfigurations`, оставляет в сборке только перечисленные языковые ресурсы (уменьшает размер APK/AAB).
- Кнопка «Открыть настройки системы» вызывает `Settings.ACTION_APP_LOCALE_SETTINGS` (Android 13+) или `Settings.ACTION_APPLICATION_DETAILS_SETTINGS` (Android ≤ 12). На остальных платформах метод возвращает `false`, UI показывает SnackBar с ошибкой.
- На iOS, macOS, Windows, Linux и Web нативной per-app локализации нет — `LocaleChannelService` не вызывает MethodChannel, а `LocaleProvider` использует только `SharedPreferences`. Единое поведение UI (селектор языка) при этом сохраняется на всех платформах.

## iOS-специфичные функции

- Минимальная версия iOS — 15.0.
- `SceneDelegate` принимает открытые системой URL документов и передаёт их `AppDelegate`; метод-каналы файлового выбора и открытия регистрируются в `didInitializeImplicitFlutterEngine`.
- `Info.plist` объявляет типы файлов CharacterBook, чтобы iOS могла передавать такие документы приложению.
- Зависимости Flutter, поддерживающие Swift Package Manager, фиксируются в `Package.resolved` рабочего пространства Xcode.

## Облачная синхронизация

- Google Drive используется модулем `features/backup/data/CloudBackupService` для хранения резервных копий.
- Резервные копии доступны через Google Drive API в пространстве файлов приложения.
- Настройка автоматического облачного резервирования и запуск при старте приложения реализованы внутри модуля резервного копирования.
- Планируется поддержка iCloud (iOS) и OneDrive.

## Календарь и напоминания

- Экран календаря (`features/calendar/presentation/calendar_screen.dart`) построен на виджете `table_calendar`.
- Доменные события календаря и их Hive records находятся в `features/calendar/`; события отображаются с цветовой индикацией по типу.
- `CalendarController` зависит от порта `DeviceCalendarActions`; реализация `DeviceCalendarService` остаётся в data-слое.
- При создании/редактировании события можно установить время напоминания (через `flutter_local_notifications`).
- В указанное время приложение показывает уведомление даже в фоновом режиме (на платформах, где это поддерживается).

## Ключевые компоненты UI

### Экран «Главный» (HomeScreen)

- Путь: `features/home/presentation/`.
- Отображает сетку последних персонажей, рас и инструментов.
- Использует `HomeController` для загрузки данных и управления поиском; модели карточек и закреплённая секция находятся в том же feature-модуле.
- Плавающая кнопка `HomeFloatingMenu` для быстрого создания нового контента.
- Контекстное меню для элементов (через `tools_context_menu.dart`).

### Навигация

- `AppNavigationBar` — главная навигационная панель (нижняя на мобильных, боковая на десктопе).
- `MenuContent` — общее содержимое бокового меню и мобильного нижнего меню; `AppNavigator.openMenu` выбирает вариант по ширине окна.
- `showAppMenuBottomSheet` — единая реализация мобильного меню, используемая навигацией и общей панелью приложения.

### Модальные окна

- `features/characters/presentation/widgets/modals/CharacterModalCard` — детальный просмотр персонажа.
- `features/races/presentation/widgets/modals/RaceModalCard` — детальный просмотр расы.
- `EventModalCard` — детальный просмотр/редактирование события календаря.

### Виджеты списков

- `features/characters/presentation/widgets/items/CharacterKeepCardItem` — карточка персонажа на главном экране.
- `features/races/presentation/widgets/items/RaceKeepCardItem` — карточка расы.
- `ToolKeepCardItem` — карточка инструмента.

### Переиспользуемые редакторы

- `LongTextEditor` (`ui/widgets/fields/long_text_editor.dart`) задаёт единое оформление многострочного редактора и используется в редакторах заметок и пользовательских полей.
- `CustomTextField` (`ui/widgets/fields/custom_text_field.dart`) — общий оформленный `TextFormField`; поддерживает подсказку, диапазон строк и параметры ввода, используемые редактором пользовательских полей.
- `FieldEditorScreen` (`ui/screens/field_editor_screen.dart`) используется персонажами, расами и пользовательскими полями; возвращает обрезанные значения и поддерживает отложенное автосохранение.

## Тестирование

- **Unit-тесты** (`test/unit/`) — покрывают бизнес-логику модулей и репозиториев; тесты персонажей, рас и заметок размещены в `test/unit/features/` рядом с соответствующими областями.
- **Виджет-тесты** (`test/widget/`) — проверяют ключевые экраны и общие UI-компоненты, включая `FieldEditorScreen` и `CustomFieldsEditor`.
- **Интеграционные тесты** (`integration_test/`) — проверяют сквозные сценарии (импорт/экспорт, синхронизация с облаком).

Для запуска тестов:
```bash
fvm flutter test
fvm flutter test --coverage
```