# Архитектура приложения
```
<корневой каталог проекта>
├── .github/                 # Конфигурация GitHub Actions
│   └── workflows/
│       └── dart.yml        # CI/CD пайплайн
├── docs/                   # Документация приложения
│   ├── ARCHITECTURE.md     # Этот файл
│   ├── FEATURES.md         # Описание функциональности
│   ├── INSTALLATION.md     # Инструкции по установке
│   └── MANUAL.md           # Руководство пользователя
├── android/                # Платформо-специфичная конфигурация для Android
│   ├── app/               # Конфигурация приложения
│   │   ├── src/           # Исходный код Android
│   │   └── build.gradle.kts
│   ├── gradle/            # Система сборки Gradle
│   └── keystore.jks       # Ключ для подписи приложения
├── assets/                 # Статические ресурсы приложения
│   ├── fonts/             # Шрифты
│   ├── github-mark.png    # Иконка GitHub
│   ├── icon.svg           # Иконка приложения (SVG)
│   ├── iconapp.png        # Иконка приложения (PNG)
│   └── underdeveloped.png # Заглушка для недоразвитых функций
├── ios/                   # Платформо-специфичная конфигурация для iOS
├── lib/                   # Основная кодовая база на Dart
│   ├── adapters/          # Адаптеры для внешних сервисов
│   │   └── custom_field_adapter.dart
│   ├── extensions/        # Расширения для встроенных классов
│   │   └── color_extension.dart
│   ├── gen/              # Сгенерированные файлы (assets)
│   │   └── assets.gen.dart
│   ├── generated/         # Автоматически сгенерированные файлы
│   │   └── intl/         # Локализация
│   │       ├── messages_all.dart
│   │       ├── messages_en.dart
│   │       ├── messages_ru.dart
│   │       └── l10n.dart
│   ├── l10n/             # Файлы локализации
│   │   ├── intl_en.arb
│   │   └── intl_ru.arb
│   ├── models/           # Модели данных
│   │   ├── characters/   # Модели персонажей
│   │   │   ├── character_model.dart
│   │   │   ├── character_universal_model.dart
│   │   │   └── template_model.dart
│   │   ├── custom_field_model.dart
│   │   ├── folder_model.dart
│   │   ├── note_model.dart
│   │   └── race_model.dart
│   ├── providers/        # State Providers для управления состоянием
│   │   ├── locale_provider.dart
│   │   └── theme_provider.dart
│   ├── services/         # Сервисы бизнес-логики
│   │   ├── backup_service.dart
│   │   ├── character_service.dart
│   │   ├── clipboard_service.dart
│   │   ├── default_templates.dart
│   │   ├── file_handler.dart
│   │   ├── file_handler_wrapper.dart
│   │   ├── file_picker_service.dart
│   │   ├── folder_service.dart
│   │   ├── hive_service.dart
│   │   ├── migration_service.dart
│   │   ├── notification_service.dart
│   │   ├── race_service.dart
│   │   └── template_service.dart
│   └── ui/              # Компоненты пользовательского интерфейса
│       ├── cards/       # Карточки для отображения данных
│       │   └── character_modal_card.dart
│       ├── dialogs/     # Диалоговые окна
│       ├── handlers/    # Обработчики UI событий
│       │   └── unsaved_changes_handler.dart
│       ├── pages/       # Страницы приложения
│       │   ├── characters/    # Управление персонажами
│       │   │   ├── character_list_page.dart
│       │   │   └── character_management_page.dart
│       │   ├── folders/       # Управление папками
│       │   │   └── folder_list_page.dart
│       │   ├── notes/         # Управление заметками
│       │   │   ├── note_list_page.dart
│       │   │   └── note_management_page.dart
│       │   ├── races/         # Управление расами
│       │   │   ├── race_list_page.dart
│       │   │   └── race_management_page.dart
│       │   ├── templates/     # Управление шаблонами
│       │   │   ├── template_edit_page.dart
│       │   │   └── templates_page.dart
│       │   ├── home_page.dart
│       │   ├── home_screen.dart
│       │   ├── random_number_page.dart
│       │   ├── search_page.dart
│       │   └── settings_page.dart
│       └── widgets/     # Переиспользуемые виджеты
│           ├── appbar/  # Виджеты AppBar
│           │   ├── common_edit_app_bar.dart
│           │   └── custom_app_bar.dart
│           ├── fields/  # Поля ввода
│           │   ├── custom_fields_editor.dart
│           │   ├── custom_text_field.dart
│           │   ├── gender_selector_field.dart
│           │   ├── image_picker_field.dart
│           │   └── race_selector_field.dart
│           ├── items/   # Элементы списков
│           │   ├── character_card.dart
│           │   ├── folder_card.dart
│           │   ├── note_card.dart
│           │   ├── race_card.dart
│           │   ├── search_result_card.dart
│           │   └── template_card.dart
│           ├── list/    # Виджеты списков
│           ├── mixins/  # Миксины для виджетов
│           │   ├── list_page_mixin.dart
│           │   └── tag_mixin.dart
│           ├── performance/ # Виджеты производительности
│           ├── sections/    # Секции настроек
│           │   ├── about_section.dart
│           │   ├── acknowledgements_section.dart
│           │   ├── backup_section.dart
│           │   ├── build_section.dart
│           │   ├── expandable_section.dart
│           │   ├── image_gallery_section.dart
│           │   ├── import_section.dart
│           │   ├── language_section.dart
│           │   ├── licenses_section.dart
│           │   ├── settings_section.dart
│           │   ├── tags_and_folder_section.dart
│           │   └── theme_section.dart
│           ├── states/  # Виджеты состояний
│           ├── tags/    # Виджеты тегов
│           └── отдельные виджеты (avatar_picker_widget.dart и др.)
├── linux/               # Конфигурация для Linux
├── macos/               # Конфигурация для macOS
├── test/                # Модульные и виджет-тесты
├── web/                 # Конфигурация для Web
└── windows/             # Конфигурация для Windows

main.dart                # Точка входа в приложение
```

## 📐 Технологический стек

### Основные технологии

**Фреймворк:**
- **Flutter** 3.13+ - кроссплатформенный UI фреймворк
- **Dart** 3.7.2+ - язык программирования

**Управление состоянием:**
- **Provider** - для простого state management
- **Flutter Bloc** - для сложной бизнес-логики

**Локальное хранилище:**
- **Hive** 2.2.3 - быстрая NoSQL база данных
- **Shared Preferences** - для настроек приложения

**Вспомогательные пакеты:**
- **PDF** - генерация документов
- **File Selector** - работа с файловой системой
- **URL Launcher** - интеграция с ОС
- **Google Sign-In** - будущая аутентификация

### Структура зависимостей

```yaml
dependencies:
  # State Management
  provider: ^6.0.5
  flutter_bloc: ^8.1.3
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.5.3
  
  # File Operations
  pdf: ^3.10.0
  printing: ^5.9.1
  file_selector: ^1.0.3
  
  # Platform Integration
  window_manager: ^0.5.1
  msix: ^3.16.10
```

## 🏗️ Модульная структура

Приложение следует принципам **чистой архитектуры** с разделением на:

- **Модели** (`models/`) - структуры данных
- **Сервисы** (`services/`) - бизнес-логика
- **Провайдеры** (`providers/`) - управление состоянием
- **UI компоненты** (`ui/`) - представление данных

Каждый модуль отвечает за свою зону ответственности, что обеспечивает поддерживаемость и тестируемость кода.