# CharacterBook – приложение для структуризированного хранения персонажей

**🔗 Ссылки:**
- [Исходный код (GitHub)](https://github.com/maxgog/characterbook)
- [![Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters&hl)
- [![RuStore](https://img.shields.io/badge/RuStore-5551FF?style=for-the-badge&logo=rustore&logoColor=white)](https://www.rustore.ru/catalog/app/ru.maxgog.listcharacters)
- [![Microsoft Store](https://img.shields.io/badge/Microsoft_Store-0078D6?style=for-the-badge&logo=microsoft&logoColor=white)](https://apps.microsoft.com/detail/9NKV4DBQJW0S)
- [Поддержать разработчика](https://boosty.to/maxupshur/donate)

## 📌 О проекте

**CharacterBook** – кроссплатформенное приложение на **Flutter**, предназначенное для удобного создания, хранения и экспорта персонажей для ролевых игр (RPG, D&D и других систем). Доступно на **Android, Windows и в веб-версии**.

### � Основные возможности:
- **Структурированное хранение** персонажей с разделами:
    - Основная информация (имя, раса, способности, возраст)
    - Заметки и backstory
    - Расы
- **Гибкие шаблоны** под разные RPG-системы (РП).
- **Экспорт в текстовый документ** (PDF) для печати или передачи мастеру.
- **Оффлайн-доступ** – данные хранятся локально (SQLite).
- **Тёмная/светлая тема** для комфортного использования.
- **Синхронизация между устройствами** (в разработке).

## 🛠 Технологии и инструменты
- **Flutter** (Dart) – кроссплатформенная разработка.
- **Локальная БД**: Hive (noSQL).
- **Экспорт документов**: pdf / character / race генерация.
- **UI**: Adaptive Design, Material 3, поддержка Desktop.

## 📸 Скриншоты
| Главный экран | Создание персонажа | Расы |  
|--------------|-------------------|---------|  
| ![Главный экран](https://play-lh.googleusercontent.com/s8D2VaHx1PO5JEfIaisZrezpEGOImAeLFBzdL68pHrOVD86-ByCn_8dAvAFILe4X8g=w5120-h2880) | ![Создание](https://play-lh.googleusercontent.com/rbMgJUpij1St19tMacQ_IyMhQ_3IpWntD-deZ8BfafKjSJRAcdHWdETjgQPuk_-tkps=w5120-h2880) | ![Расы](https://github.com/user-attachments/assets/017700ff-da16-4c44-b979-fa6aaafdfc7c) |  

## Структура проекта
```
<корневой каталог проекта>
├── .github/
│   └── workflows/          # Конфигурация непрерывной интеграции и доставки (CI/CD)
│       └── dart.yml        # Конвейер автоматизированной сборки и тестирования (GitHub Actions)
├── android/                # Платформо-специфичная конфигурация и код для ОС Android
├── assets/                 # Статические ресурсы приложения: изображения, шрифты, файлы данных
├── ios/                    # Платформо-специфичная конфигурация и код для ОС iOS
├── lib/                    # Основная кодовая база приложения на языке Dart
│   ├── adapters/           # Адаптеры для взаимодействия со внешними сервисами и библиотеками
│   ├── extensions/         # Расширения (extension methods) для встроенных классов Dart/Flutter
│   ├── gen/                # Сгенерированные файлы (кодогенерация для сериализации)
│   ├── generated/          # Автоматически сгенерированные файлы (локализация)
│   ├── l10n/               # Файлы ресурсов для локализации (арbфайлы .arb)
│   ├── models/             # Модели данных: DTO (слой данных) и Entities (доменный слой)
│   │   ├── data/           # Модели данных для слоя Data (DTO)
│   │   └── domain/         # Модели сущностей для доменного слоя (Entities)
│   ├── providers/          # Поставщики состояния (State Providers) для управления состоянием UI
│   ├── services/           # Сервисы, реализующие бизнес-логику и взаимодействие с данными
│   └── ui/                 # Компоненты пользовательского интерфейса (слой представления)
│       ├── screens/        # Экраны (страницы) приложения
│       ├── widgets/        # Переиспользуемые виджеты
│       ├── themes/         # Конфигурация тем оформления приложения
│       └── constants/      # Константы, используемые в UI (цвета, отступы, строки)
├── linux/                  # Платформо-специфичная конфигурация и код для ОС Linux
├── macos/                  # Платформо-специфичная конфигурация и код для ОС macOS
├── test/                   # Модульные, интеграционные и виджет-тесты
├── web/                    # Платформо-специфичная конфигурация и код для Web-платформы
└── windows/                # Платформо-специфичная конфигурация и код для ОС Windows
main.dart                   # Точка входа в приложение
```

## 📥 Установка и запуск
1. Клонируйте репозиторий:
   ```bash  
   git clone https://github.com/maxgog/characterbook.git  
   ```  
2. Установите зависимости:
   ```bash  
   flutter pub get  
   ```  
3. Запустите приложение:
   ```bash  
   flutter run  
   ```  

Или установите из магазинов:
- [Google Play](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters&hl)
- [RuStore](https://www.rustore.ru/catalog/app/ru.maxgog.listcharacters)
- [Microsoft Store](https://apps.microsoft.com/detail/9NKV4DBQJW0S)

## 📄 Лицензия
Проект распространяется под лицензией **GPL-3.0**.

---  
**👨‍💻 Автор:** MaxGog  
**📧 Почта:** max.gog2005@outlook.com  
**💖 Поддержать:** [boosty.to/maxupshur](https://boosty.to/maxupshur/donate)

[![Flutter](https://img.shields.io/badge/Flutter-3.13-blue)]()
[![Platforms](https://img.shields.io/badge/Platforms-Android%20|%20Windows%20|%20Web-blue)]()  
 
*Приложение создано для удобства игроков и мастеров RPG-сеттингов. Вдохновлено классическими бумажными листами персонажей! Теперь доступно на всех ваших устройствах.*
