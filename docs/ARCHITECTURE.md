# Архитектура приложения

```bash
<корневой каталог проекта>
├── .github/                 # Конфигурация GitHub Actions
│   └── workflows/
│       └── dart.yml        # CI/CD пайплайн
├── assets/                  # Статические ресурсы приложения
│   ├── fonts/              # Шрифты
│   ├── github-mark.png     # Иконка GitHub
│   ├── icon.svg            # Иконка приложения (SVG)
│   ├── iconapp.png         # Иконка приложения (PNG)
│   ├── avatardeveloper.png # Аватар разработчика
│   └── underdeveloped.png  # Бейджик разработчика
├── lib/                    # Основная кодовая база на Dart
│   ├── adapters/           # Адаптеры для Hive
│   │   └── custom_field_adapter.dart
│   ├── enums/
│   │   ├── calendar_event_type_enum.dart
│   │   ├── character_sort_enum.dart
│   │   ├── home_content_type_enum.dart
│   │   ├── note_sort_enum.dart
│   │   ├── template_sort_enum.dart
│   │   └── race_sort_enum.dart
│   ├── extensions/         # Расширения для встроенных классов
│   │   └── color_extension.dart
│   ├── gen/                # Сгенерированные файлы (assets)
│   │   └── assets.gen.dart
│   ├── generated/          # Автоматически сгенерированные файлы локализации
│   │   └── intl/          
│   │       ├── messages_all.dart
│   │       ├── messages_en.dart
│   │       ├── messages_ru.dart
│   │       └── l10n.dart
│   ├── l10n/               # Исходные файлы локализации
│   │   ├── intl_en.arb
│   │   └── intl_ru.arb
│   ├── models/             # Модели данных
│   │   ├── calendar_event_model.dart
│   │   ├── character_model.dart
│   │   ├── custom_field_model.dart
│   │   ├── export_pdf_settings_model.dart
│   │   ├── folder_model.dart
│   │   ├── note_model.dart
│   │   ├── race_model.dart
│   │   ├── swipe_action.dart
│   │   ├── relationship_model.dart
│   │   └── template_model.dart
│   ├── providers/          # Провайдеры состояния
│   │   ├── locale_provider.dart
│   │   ├── swipe_action_settings_provider.dart
│   │   └── theme_provider.dart
│   ├── repositories/       # Репозитории для доступа к данным
│   │   ├── character_repository.dart
│   │   ├── folder_repository.dart
│   │   ├── note_repository.dart
│   │   ├── race_repository.dart
│   │   ├── relationship_repository.dart
│   │   └── template_repository.dart
│   ├── services/           # Сервисы бизнес-логики
│   │   ├── backup_service.dart          # Резервное копирование (локальное и облачное)
│   │   ├── character_service.dart
│   │   ├── clipboard_service.dart
│   │   ├── date_formatter.dart
│   │   ├── file_handler.dart
│   │   ├── file_handler_wrapper.dart
│   │   ├── file_picker_service.dart
│   │   ├── file_share_service.dart
│   │   ├── folder_service.dart
│   │   ├── hive_service.dart
│   │   ├── menu_channel_service.dart
│   │   ├── migration_service.dart
│   │   ├── note_service.dart
│   │   ├── notification_service.dart
│   │   ├── pdf_export_manager.dart
│   │   ├── pdf_export_service.dart
│   │   ├── race_service.dart
│   │   ├── relationship_service.dart
│   │   └── template_service.dart
│   └── ui/                 # Компоненты пользовательского интерфейса
│       ├── controllers/    # Контроллеры для экранов
│       │   │── home_controller.dart
│       │   └── ... (другие контроллеры)
│       ├── navigation/     # Навигационные компоненты
│       │   ├── app_navigation_bar.dart
│       │   └── menu_content.dart
│       ├── screens/        # Основные экраны
│       │   ├── settings/   # Экраны с настройками
│       │   ├── characters/ # Экраны с персонажами
│       │   ├── races/      # Экраны с расами
│       │   ├── notes/      # Экраны с заметками
│       │   ├── templates/  # Экраны с шаблонами
│       │   ├── calendar_screen.dart
│       │   ├── folder_list_screen.dart
│       │   ├── random_number_screen.dart
│       │   └── home_screen.dart
│       └── widgets/        # Переиспользуемые виджеты
│           ├── modals/     # Модальные окна
│           │   ├── common_modal_card.dart  # Основной виджет модальных окон
│           │   ├── character_modal_card.dart
│           │   └── race_modal_card.dart
│           ├── buttons/    # Кастомные кнопки
│           │   └── home_fab_menu.dart
│           ├── items/      # Элементы списков
│           │   ├── character_keep_card_item.dart
│           │   ├── home_item.dart
│           │   ├── race_keep_card_item.dart
│           │   └── tool_keep_card_item.dart
│           ├── tools_context_menu.dart
│           ├── avatar_picker_widget.dart
│           ├── custom_fields_editor.dart
│           └── ... (другие виджеты)
├── test/                  # Модульные и виджет-тесты
├── web/                   # Конфигурация для Web
├── android/               # Платформо-специфичная конфигурация для Android
├── ios/                   # Платформо-специфичная конфигурация для iOS
├── linux/                 # Конфигурация для Linux
├── macos/                 # Конфигурация для macOS
└── windows/               # Конфигурация для Windows

main.dart                  # Точка входа в приложение
```

## 📐 Технологический стек

### Основные технологии

- **Flutter** 3.13+ — кроссплатформенный UI фреймворк
- **Dart** 3.7.2+ — язык программирования

### Управление состоянием

- **Provider** — основной инструмент для управления состоянием (используется `ChangeNotifierProvider`, `ProxyProvider`, `MultiProvider`)

### Генерация кода

- **json_serializable**, **build_runner** — для сериализации JSON
- **hive_generator** — генерация адаптеров Hive
- **flutter_gen** — генерация типизированных ассетов
- **intl_utils** — для локализации

### Локальное хранилище

- **Hive** 2.2.3 — быстрая NoSQL база данных для хранения моделей
- **Shared Preferences** — для хранения пользовательских настроек

### Работа с файловой системой

- **File Picker** — выбор файлов
- **File Share** — шаринг файлов
- **Clipboard** — работа с буфером обмена

### Генерация PDF

- **PDF** — создание PDF-документов
- **Printing** — печать

### Интеграция с платформой

- **URL Launcher** — открытие внешних ссылок

### Вспомогательные пакеты

- **Hive Flutter** — интеграция Hive с Flutter
- **Provider** — DI и управление состоянием
- **Flutter Localizations** — локализация

### Взаимодействие с платформой

- **google_sign_in** — аутентификация Google
- **googleapis** — работа с Google Drive API
- **extension_google_sign_in_as_googleapis_auth** — адаптер для использования токенов
- **share_plus** — системный шеринг
- **open_filex** — открытие файлов
- **image_picker** — выбор изображений
- **crop_image** — обрезка изображений
- **table_calendar** — виджет календаря
- **flutter_markdown** — отображение Markdown в описаниях

## 🏗️ Модульная структура

Приложение следует принципам **чистой архитектуры** с разделением на слои:

- **Модели** (`models/`) — описание сущностей данных (Character, Race, Note, Folder, Template, Relationship, CustomField, ExportPdfSettings)
- **Репозитории** (`repositories/`) — абстракция доступа к данным (CRUD операции над Hive боксами)
- **Сервисы** (`services/`) — бизнес-логика, работа с репозиториями, внешние сервисы (резервное копирование, PDF-экспорт, уведомления)
- **Провайдеры** (`providers/`) — управление состоянием приложения (тема, язык, настройки)
- **UI** (`ui/`) — представление данных, экраны, виджеты, контроллеры

Такое разделение обеспечивает тестируемость, переиспользование кода и упрощает поддержку.

## 🗃️ Модели данных

### Character (Персонаж)

- **Тип Hive**: `typeId: 0`
- **Назначение**: Основная сущность приложения для хранения данных о персонажах
- **Ключевые поля**:
  - `id` — уникальный идентификатор
  - `name`, `age`, `gender` — базовые атрибуты
  - `biography`, `personality`, `appearance` — текстовые описания
  - `imageBytes`, `referenceImageBytes`, `additionalImages` — система изображений
  - `customFields` — расширяемая система полей
  - `race` — связь с расой
  - `folderId`, `tags` — система организации

### Race (Раса)

- **Тип Hive**: `typeId: 3`
- **Назначение**: Хранение данных о расах персонажей
- **Ключевые поля**:
  - `name`, `description`, `biology`, `backstory` — описания
  - `logo` — изображение расы
  - `folderId`, `tags` — организация

### Note (Заметка)

- **Тип Hive**: `typeId: 2`
- **Назначение**: Система заметок, связанных с персонажами
- **Ключевые поля**:
  - `title`, `content` — содержимое заметки
  - `characterIds` — привязка к персонажам
  - `folderId`, `tags` — организация

### Folder (Папка)

- **Тип Hive**: `typeId: 5`
- **Назначение**: Организация контента в папки
- **Ключевые поля**:
  - `name`, `type` — название и тип содержимого
  - `parentId` — поддержка вложенности
  - `contentIds` — список ID содержимого
  - `colorValue` — цветовое кодирование

### QuestionnaireTemplate (Шаблон анкеты)

- **Тип Hive**: `typeId: 4`
- **Назначение**: Шаблоны для быстрого создания персонажей
- **Ключевые поля**:
  - `name` — название шаблона
  - `standardFields` — список стандартных полей
  - `customFields` — пользовательские поля шаблона

### Relationship (Связь)

- **Тип Hive**: `typeId: 6`
- **Назначение**: Хранение связей между персонажами
- **Ключевые поля**:
  - `fromCharacterId` — ID первого персонажа
  - `toCharacterId` — ID второго персонажа
  - `type` — тип связи (дружба, любовь, вражда и т.д.)
  - `description` — описание связи

### ExportPdfSettings (Настройки экспорта PDF)

- **Тип Hive**: `typeId: 7`
- **Назначение**: Настройки для генерации PDF
- **Ключевые поля**:
  - `paperSize` — размер бумаги
  - `orientation` — ориентация страницы
  - `includeImages` — включать ли изображения
  - `template` — выбранный шаблон оформления

### CustomField (Пользовательское поле)

- **Тип Hive**: `typeId: 1`
- **Назначение**: Хранение пользовательских полей типа ключ-значение
- **Ключевые поля**:
  - `key` — название поля
  - `value` — значение поля

### CalendarEvent (Событие календаря)

- **Тип Hive**: `typeId: 11`
- **Назначение**: Планирование событий, связанных с персонажами или кампанией
- **Ключевые поля**:
  - `title`, `description` — название и описание события
  - `date` — дата и время
  - `characterIds` — список ID персонажей, участвующих в событии
  - `type` — тип события (встреча, бой, праздник и т.д.) из `CalendarEventType`
  - `reminder` — напоминание (если реализовано)

### SwipeAction (Жесты свайпа)

- **Тип Hive**: `typeId: 12`
- **Назначение**: Хранение настроек действий по свайпу для списков
- **Ключевые поля**:
  - `leftAction` — действие при свайпе влево
  - `rightAction` — действие при свайпе вправо
  - `enabled` — включены ли жесты

## 🔄 Жизненный цикл приложения

### Инициализация

1. `WidgetsFlutterBinding.ensureInitialized()`
2. Инициализация Hive через `HiveService.initHive()`
3. Регистрация адаптеров Hive (например, `RelationshipAdapter`)
4. Открытие всех боксов с повторными попытками (`_openBoxWithRetry`)
5. Инициализация `FileHandler.initialize()`
6. Запуск `runApp` с `CharacterBookApp`
7. В `CharacterBookApp` создаётся `MultiProvider` с репозиториями, сервисами и провайдерами состояния
8. В `_AppContent` настраивается метод-канал (`MenuChannel`) и проверяется успешность инициализации Hive

### Управление состоянием

- **ThemeProvider** — управление светлой/тёмной темой
- **LocaleProvider** — управление локализацией
- **SwipeActionSettingsProvider** — настройки жестов свайпа
- **NotificationService** — управление уведомлениями (через `ScaffoldMessenger`)

### Работа с данными

- Репозитории (`*Repository`) инкапсулируют доступ к Hive боксам.
- Сервисы (`*Service`) используют репозитории для бизнес-логики.
- Провайдеры связывают UI с состоянием (например, `HomeController` использует сервисы для загрузки данных).

### BackupService (Резервное копирование)

- **Локальное резервирование**: экспорт/импорт через `FilePickerService`
- **Облачное резервирование**: интеграция с Google Drive через `google_sign_in` и `googleapis`
- **Автоматическое резервирование**: планировщик задач (если реализован)

### NotificationService

- Отображает SnackBar уведомления через глобальный `ScaffoldMessengerKey`
- Используется для информирования об успешных/неудачных операциях

### MenuChannelService

- Обработка вызовов из нативного меню (например, открытие файла, создание персонажа)
- Интеграция с `MethodChannel` для десктопных платформ

## 🖥️ Десктоп-специфичные функции

- Кастомная панель заголовка (управление окном) — реализована через `window_manager`.
- Кнопки управления окном (свернуть/развернуть/закрыть).
- Автоматическое определение платформы и адаптация UI.
- Поддержка нативных диалогов выбора файлов через `file_selector`.
- Интеграция с системным меню через `MenuChannelService`.

## ☁️ Облачная синхронизация

- **Google Drive** используется для хранения резервных копий.
- Сервис `CloudBackupService` управляет аутентификацией через `google_sign_in` и загрузкой/скачиванием файлов.
- Резервные копии хранятся в папке приложения на Google Drive пользователя.
- Планируется поддержка iCloud (iOS) и OneDrive.

## 🧩 Ключевые компоненты UI

### Экран «Главный» (`HomeScreen`)

- Отображает сетку последних персонажей, рас и инструментов.
- Использует `HomeController` для загрузки данных и управления поиском.
- Плавающая кнопка `HomeFloatingMenu` для быстрого создания нового контента.
- Контекстное меню для элементов (через `tools_context_menu.dart`).

### Навигация

- `AppNavigationBar` — главная навигационная панель (нижняя на мобильных, боковая на десктопе).
- `MenuContent` — содержимое бокового меню (используется в `AppDrawer` и в модальном окне на главном экране).

### Модальные окна

- `CharacterModalCard` — детальный просмотр персонажа.
- `RaceModalCard` — детальный просмотр расы.

### Виджеты списков

- `CharacterKeepCardItem` — карточка персонажа на главном экране.
- `RaceKeepCardItem` — карточка расы.
- `ToolKeepCardItem` — карточка инструмента (генератор чисел, поиск и т.д.).

## 📦 Зависимости и интеграции

- **Hive** — для хранения всех данных локально.
- **Provider** — для DI и управления состоянием.
- **File Picker** — для импорта/экспорта файлов.
- **PDF** — для генерации отчётов.
- **URL Launcher** — для открытия ссылок (например, документации).

## 🧪 Тестирование

- Модульные тесты для сервисов и репозиториев.
- Виджет-тесты для ключевых экранов.
- Интеграционные тесты для проверки сценариев импорта/экспорта.