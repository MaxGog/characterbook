# 🎭 CharacterBook – Your Ultimate RPG Character Companion

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20|%20Windows%20|%20macOS%20-4CAF50?style=for-the-badge)](https://github.com/maxgog/characterbook)
[![License](https://img.shields.io/badge/License-GPL--3.0-4285F4?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)

**Кроссплатформенное приложение для создания и управления персонажами RPG**

[📖 Документация](docs/ARCHITECTURE.md) • [🎮 Возможности](docs/FEATURES.md) • [📥 Установка](docs/INSTALLATION.md) • [👨‍💻 Руководство](docs/MANUAL.md)

</div>

## ✨ О проекте

**CharacterBook** – это мощное кроссплатформенное приложение, созданное для игроков и мастеров ролевых игр. Создавайте, организуйте и экспортируйте персонажей для любых RPG систем с невероятной легкостью!

### 🎯 Ключевые возможности

| Категория | Возможности |
|-----------|-------------|
| **👥 Управление персонажами** | Создание, редактирование, шаблоны, расширенные поля |
| **🗂️ Организация** | Папки, теги, поиск, фильтрация, сортировка |
| **🎨 Шаблоны и расы** | D&D 5e, Для писателей, кастомные шаблоны, база рас |
| **💾 Работа с данными** | PDF экспорт, резервные копии, локальное хранение |
| **🌍 Кроссплатформенность** | Android, Windows, macOS, iOS/Linux/Web (в планах) |

## 🚀 Быстрый старт

### 📥 Установка для пользователей

<div align="center">

[![Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white&label=Android)](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters&hl)
[![RuStore](https://img.shields.io/badge/RuStore-5551FF?style=for-the-badge&logo=rustore&logoColor=white&label=Android)](https://www.rustore.ru/catalog/app/ru.maxgog.listcharacters)
[![Microsoft Store](https://img.shields.io/badge/Microsoft_Store-0078D6?style=for-the-badge&logo=microsoft&logoColor=white&label=Windows)](https://apps.microsoft.com/detail/9NKV4DBQJW0S)
[![GitHub Releases](https://img.shields.io/badge/GitHub_Releases-181717?style=for-the-badge&logo=github&logoColor=white&label=Все%20платформы)](https://github.com/maxgog/characterbook/releases)

</div>

### 🛠️ Для разработчиков

```bash
# 1. Клонируйте репозиторий
git clone https://github.com/maxgog/characterbook.git
cd characterbook

# 2. Установите зависимости
flutter pub get

# 3. Запустите приложение
flutter run

# 4. Сборка для production
flutter build apk --release    # Android
flutter build windows --release # Windows
flutter build web --release    # Web
```

## 📸 Галерея приложения

<div align="center">

| Главный экран | Создание персонажа | Управление расами |
|:-------------:|:------------------:|:-----------------:|
| ![Главный экран](https://play-lh.googleusercontent.com/s8D2VaHx1PO5JEfIaisZrezpEGOImAeLFBzdL68pHrOVD86-ByCn_8dAvAFILe4X8g=w5120-h2880) | ![Создание](https://play-lh.googleusercontent.com/rbMgJUpij1St19tMacQ_IyMhQ_3IpWntD-deZ8BfafKjSJRAcdHWdETjgQPuk_-tkps=w5120-h2880) | ![Расы](https://github.com/user-attachments/assets/017700ff-da16-4c44-b979-fa6aaafdfc7c) |

*Доступный и интуитивный интерфейс для всех платформ*

</div>

## 🏗️ Технологический стек

### 🔧 Основные технологии

| Компонент | Технология | Назначение |
|-----------|------------|------------|
| **🖼️ Фреймворк** | Flutter 3.13+ | Кроссплатформенный UI |
| **💙 Язык** | Dart 3.7+ | Бизнес-логика и производительность |
| **💾 Хранилище** | Hive 2.2.3 | Быстрая NoSQL база данных |
| **🎮 State Management** | Provider + Flutter Bloc | Управление состоянием |
| **📄 Экспорт** | PDF, Printing | Генерация документов |

### 📦 Ключевые зависимости

```yaml
dependencies:
  # State Management
  provider: ^6.0.5
  flutter_bloc: ^8.1.3
  
  # Local Storage
  hive: ^2.2.3
  shared_preferences: ^2.5.3
  
  # File Operations
  pdf: ^3.10.0
  file_selector: ^1.0.3
  
  # Platform Integration
  window_manager: ^0.5.1
  msix: ^3.16.10
```

## 🎯 Для кого это приложение?

### 🎮 Для игроков
- ✅ **Полная кастомизация** персонажей под любую систему
- ✅ **Оффлайн доступ** - играйте где угодно без интернета
- ✅ **Бесплатность** - все функции доступны без подписок
- ✅ **Визуализация** - добавляйте изображения и галереи

### 🎲 Для мастеров
- ✅ **Единая база** всех NPC и персонажей кампании
- ✅ **Быстрый экспорт** материалов для сессий
- ✅ **Гибкая организация** под вашу кампанию
- ✅ **Шаблоны** для быстрого создания контента

### 💻 Для разработчиков
- ✅ **Открытый код** - возможность модификации
- ✅ **Современный стек** - актуальные технологии
- ✅ **Активное развитие** - регулярные обновления

## 📊 Статус разработки

| Компонент | Статус | Примечания |
|-----------|--------|------------|
| **Android** | ✅ Разработано | [Google Play](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters) |
| **Windows** | ✅ Разработано | [Microsoft Store](https://apps.microsoft.com/detail/9NKV4DBQJW0S) |
| **Web** | 🔧 В разработке | Скоро будет доступно |
| **iOS** | 📅 В планах | Требуется Mac для сборки |
| **Облачная синхронизация** | ✅ Разработано | Google Drive интеграция |

## 🤝 Участие в разработке

Мы приветствуем вклад в развитие CharacterBook! 

### 🐛 Сообщение об ошибках
Нашли баг? [Создайте issue](https://github.com/maxgog/characterbook/issues) с подробным описанием.

### 💡 Предложения функций
Есть идея для улучшения? [Обсудим в issues](https://github.com/maxgog/characterbook/issues)!

### 🔧 Pull Requests
1. Форкните репозиторий
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Закоммитьте изменения (`git commit -m 'Add amazing feature'`)
4. Запушьте branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией **GPL-3.0**. Подробнее см. в файле [LICENSE](LICENSE).

## 💖 Поддержка проекта

<div align="center">

Если вам нравится CharacterBook, рассмотрите возможность поддержать разработчика:

[![Boosty](https://img.shields.io/badge/Boosty-FF6B6B?style=for-the-badge&logo=heart&logoColor=white&label=Поддержать%20разработчика)](https://boosty.to/maxupshur/donate)

</div>

---

<div align="center">

## 📞 Контакты

**👨‍💻 Автор:** MaxGog  
**📧 Почта:** max.gog2005@outlook.com  
**🐙 GitHub:** [maxgog](https://github.com/maxgog)  
**💬 Поддержка:** [Создать issue](https://github.com/maxgog/characterbook/issues)

*CharacterBook вдохновлен классическими бумажными листами персонажей и создан для современной эпохи цифровых RPG!*

**⭐ Не забудьте поставить звезду репозиторию, если проект вам понравился!**

</div>
