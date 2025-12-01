// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(error) => "Ошибка при обрезке: ${error}";

  static String m1(error) => "Ошибка: ${error}";

  static String m2(name) => "Персонаж создан из шаблона \"${name}\"";

  static String m3(name) => "Персонаж \"${name}\" успешно экспортирован в PDF";

  static String m4(name) => "Персонаж \"${name}\" успешно импортирован";

  static String m5(name) => "Файл персонажа ${name}";

  static String m20(count) => "Персонажей: ${count}";

  static String m6(charactersCount, notesCount, racesCount, templatesCount,
          foldersCount) =>
      "Успешно восстановлено:\n${charactersCount} персонажей\n${notesCount} заметок\n${racesCount} рас\n${templatesCount} шаблонов\n${foldersCount} папок";

  static String m7(days) => "${days} дней назад";

  static String m8(count) => "${count} полей";

  static String m21(count) => "Папок: ${count}";

  static String m9(hours) => "${hours} часов назад";

  static String m10(error) => "Ошибка при выборе изображения: ${error}";

  static String m11(error) => "Ошибка импорта: ${error}";

  static String m12(months) => "${months} месяцев назад";

  static String m13(count) => "еще ${count}";

  static String m22(count) => "Заметок: ${count}";

  static String m23(name) => "Раса \"${name}\" успешно экспортирована в PDF";

  static String m14(name) => "Раса \"${name}\" успешно импортирована";

  static String m15(name) => "Файл расы ${name}";

  static String m24(count) => "Рас: ${count}";

  static String m16(name) => "Шаблон \"${name}\" успешно экспортирован";

  static String m17(name) => "Шаблон \"${name}\" успешно импортирован";

  static String m18(name) => "Шаблон \"${name}\" уже существует. Заменить его?";

  static String m25(count) => "Шаблонов: ${count}";

  static String m26(count) => "Всего: ${count}";

  static String m19(years) => "${years} лет назад";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "a_to_z": MessageLookupByLibrary.simpleMessage("А-Я"),
        "abilities": MessageLookupByLibrary.simpleMessage("Способности"),
        "about": MessageLookupByLibrary.simpleMessage("О приложении"),
        "aboutApp": MessageLookupByLibrary.simpleMessage("О приложении"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Акцентный цвет"),
        "acknowledgements":
            MessageLookupByLibrary.simpleMessage("Благодарности"),
        "activity_timeline":
            MessageLookupByLibrary.simpleMessage("Хронология активности"),
        "add_field": MessageLookupByLibrary.simpleMessage("Добавить поле"),
        "add_picture":
            MessageLookupByLibrary.simpleMessage("Добавить изображение"),
        "add_tag": MessageLookupByLibrary.simpleMessage("Добавить тег"),
        "additional_images":
            MessageLookupByLibrary.simpleMessage("Дополнительные изображения"),
        "adults": MessageLookupByLibrary.simpleMessage("Взрослые"),
        "advanced_settings":
            MessageLookupByLibrary.simpleMessage("Расширенные настройки"),
        "age": MessageLookupByLibrary.simpleMessage("Возраст"),
        "age_asc": MessageLookupByLibrary.simpleMessage("Возраст ↑"),
        "age_desc": MessageLookupByLibrary.simpleMessage("Возраст ↓"),
        "all": MessageLookupByLibrary.simpleMessage("Все"),
        "all_categories": MessageLookupByLibrary.simpleMessage("Все категории"),
        "all_events": MessageLookupByLibrary.simpleMessage("Все события"),
        "all_tags": MessageLookupByLibrary.simpleMessage("Все теги"),
        "allow_copying":
            MessageLookupByLibrary.simpleMessage("Разрешить копирование"),
        "allow_modifications":
            MessageLookupByLibrary.simpleMessage("Разрешить изменения"),
        "allow_printing":
            MessageLookupByLibrary.simpleMessage("Разрешить печать"),
        "another": MessageLookupByLibrary.simpleMessage("Другой"),
        "appLanguage": MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "app_name": MessageLookupByLibrary.simpleMessage("CharacterBook"),
        "app_tour": MessageLookupByLibrary.simpleMessage("Обзор приложения"),
        "appearance": MessageLookupByLibrary.simpleMessage("Внешность"),
        "archived": MessageLookupByLibrary.simpleMessage("В архиве"),
        "auth_cancelled":
            MessageLookupByLibrary.simpleMessage("Авторизация отменена"),
        "auth_client_error": MessageLookupByLibrary.simpleMessage(
            "Не удалось получить клиент для API"),
        "author": MessageLookupByLibrary.simpleMessage("Автор"),
        "auto_layout":
            MessageLookupByLibrary.simpleMessage("Автоматический макет"),
        "avatar_crop_coordinates_error": MessageLookupByLibrary.simpleMessage(
            "Некорректные координаты обрезки"),
        "avatar_crop_error": m0,
        "avatar_crop_save":
            MessageLookupByLibrary.simpleMessage("Сохранить обрезку"),
        "avatar_crop_title":
            MessageLookupByLibrary.simpleMessage("Обрезка аватара"),
        "avatar_crop_widget_size_error": MessageLookupByLibrary.simpleMessage(
            "Не удалось получить размер виджета"),
        "avatar_picker_error": m1,
        "back": MessageLookupByLibrary.simpleMessage("Назад"),
        "backstory": MessageLookupByLibrary.simpleMessage("История"),
        "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
        "backup_creation":
            MessageLookupByLibrary.simpleMessage("Создание резервной копии..."),
        "backup_data":
            MessageLookupByLibrary.simpleMessage("Создать резервную копию"),
        "backup_options": MessageLookupByLibrary.simpleMessage(
            "Варианты резервного копирования"),
        "backup_to_cloud":
            MessageLookupByLibrary.simpleMessage("Сохранить в облако"),
        "backup_to_file":
            MessageLookupByLibrary.simpleMessage("Сохранить в файл"),
        "basic_info":
            MessageLookupByLibrary.simpleMessage("Основная информация"),
        "biography": MessageLookupByLibrary.simpleMessage("Биография"),
        "biology": MessageLookupByLibrary.simpleMessage("Биология"),
        "body_color": MessageLookupByLibrary.simpleMessage("Цвет текста"),
        "body_font_size":
            MessageLookupByLibrary.simpleMessage("Размер шрифта текста"),
        "browse_templates":
            MessageLookupByLibrary.simpleMessage("Просмотреть шаблоны"),
        "by_race": MessageLookupByLibrary.simpleMessage("По расам"),
        "by_tags": MessageLookupByLibrary.simpleMessage("По тегам"),
        "cache_clearing":
            MessageLookupByLibrary.simpleMessage("Очистка кеша..."),
        "calendar": MessageLookupByLibrary.simpleMessage("Календарь"),
        "calendar_statistics":
            MessageLookupByLibrary.simpleMessage("Статистика календаря"),
        "calendar_view": MessageLookupByLibrary.simpleMessage("Вид календаря"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "character": MessageLookupByLibrary.simpleMessage("Персонаж"),
        "character_avatar":
            MessageLookupByLibrary.simpleMessage("Аватар персонажа"),
        "character_created_from_template": m2,
        "character_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить."),
        "character_delete_title":
            MessageLookupByLibrary.simpleMessage("Удалить персонажа?"),
        "character_deleted":
            MessageLookupByLibrary.simpleMessage("Персонаж удален"),
        "character_events":
            MessageLookupByLibrary.simpleMessage("События персонажей"),
        "character_exported": m3,
        "character_gallery":
            MessageLookupByLibrary.simpleMessage("Галерея персонажа"),
        "character_imported": m4,
        "character_management":
            MessageLookupByLibrary.simpleMessage("Управление персонажами"),
        "character_profile_title":
            MessageLookupByLibrary.simpleMessage("Характеристика персонажа"),
        "character_reference":
            MessageLookupByLibrary.simpleMessage("Референс персонажа"),
        "character_share_text": m5,
        "characterbookLicense": MessageLookupByLibrary.simpleMessage(
            "Лицензия CharacterBook (GNU GPL v3.0)"),
        "characters": MessageLookupByLibrary.simpleMessage("Персонажи"),
        "characters_count": m20,
        "check_for_updates":
            MessageLookupByLibrary.simpleMessage("Проверить обновления"),
        "checking_dependencies":
            MessageLookupByLibrary.simpleMessage("Проверка зависимостей..."),
        "children": MessageLookupByLibrary.simpleMessage("Дети"),
        "choose_character":
            MessageLookupByLibrary.simpleMessage("Выбранные персонажи"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "close_app": MessageLookupByLibrary.simpleMessage("Закрыть приложение"),
        "cloud_backup_characters_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при создании резервной копии персонажей"),
        "cloud_backup_characters_success": MessageLookupByLibrary.simpleMessage(
            "Резервная копия персонажей успешно создана"),
        "cloud_backup_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при создании резервной копии"),
        "cloud_backup_full_success": MessageLookupByLibrary.simpleMessage(
            "Полная резервная копия успешно создана в Google Drive"),
        "cloud_backup_not_found":
            MessageLookupByLibrary.simpleMessage("Резервные копии не найдены"),
        "cloud_backup_success": MessageLookupByLibrary.simpleMessage(
            "Резервная копия успешно создана"),
        "cloud_export_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при экспорте в Google Drive"),
        "cloud_import_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при импорте из Google Drive"),
        "cloud_restore_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при восстановлении данных"),
        "cloud_restore_success": m6,
        "collection_overview":
            MessageLookupByLibrary.simpleMessage("Обзор коллекции"),
        "colorScheme": MessageLookupByLibrary.simpleMessage("Цветовая схема"),
        "color_blue": MessageLookupByLibrary.simpleMessage("Синий"),
        "color_brown": MessageLookupByLibrary.simpleMessage("Коричневый"),
        "color_dark": MessageLookupByLibrary.simpleMessage("Тёмный"),
        "color_green": MessageLookupByLibrary.simpleMessage("Зелёный"),
        "color_grey": MessageLookupByLibrary.simpleMessage("Серый"),
        "color_orange": MessageLookupByLibrary.simpleMessage("Оранжевый"),
        "color_picker": MessageLookupByLibrary.simpleMessage("Выбор цвета"),
        "color_pink": MessageLookupByLibrary.simpleMessage("Розовый"),
        "color_purple": MessageLookupByLibrary.simpleMessage("Фиолетовый"),
        "color_red": MessageLookupByLibrary.simpleMessage("Красный"),
        "color_settings":
            MessageLookupByLibrary.simpleMessage("Настройки цветов"),
        "color_teal": MessageLookupByLibrary.simpleMessage("Бирюзовый"),
        "community": MessageLookupByLibrary.simpleMessage("Сообщество"),
        "compression": MessageLookupByLibrary.simpleMessage("Сжатие"),
        "configuring_environment":
            MessageLookupByLibrary.simpleMessage("Настройка окружения..."),
        "continue_text": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("Скопировано в буфер обмена"),
        "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
        "copy_character":
            MessageLookupByLibrary.simpleMessage("Скопировать персонажа"),
        "copy_error":
            MessageLookupByLibrary.simpleMessage("Ошибка копирования"),
        "create": MessageLookupByLibrary.simpleMessage("Создать"),
        "createBackup":
            MessageLookupByLibrary.simpleMessage("Создать резервную копию"),
        "create_character":
            MessageLookupByLibrary.simpleMessage("Создать персонажа"),
        "create_first_content": MessageLookupByLibrary.simpleMessage(
            "Создайте первого персонажа или расу"),
        "create_from_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Создать из шаблона"),
        "create_race": MessageLookupByLibrary.simpleMessage("Создать расу"),
        "create_template":
            MessageLookupByLibrary.simpleMessage("Создать шаблон"),
        "create_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Создать шаблон"),
        "created": MessageLookupByLibrary.simpleMessage("Создано"),
        "creatingBackup":
            MessageLookupByLibrary.simpleMessage("Создание резервной копии"),
        "creating_file":
            MessageLookupByLibrary.simpleMessage("Создание файла..."),
        "creating_pdf": MessageLookupByLibrary.simpleMessage("Создание PDF..."),
        "critical_error":
            MessageLookupByLibrary.simpleMessage("Критическая ошибка"),
        "critical_error_warning": MessageLookupByLibrary.simpleMessage(
            "Приложение попыталось восстановить работоспособность, но некоторые данные могли быть утеряны"),
        "custom": MessageLookupByLibrary.simpleMessage("пользовательских"),
        "custom_fields":
            MessageLookupByLibrary.simpleMessage("Дополнительные поля"),
        "custom_fields_editor_title":
            MessageLookupByLibrary.simpleMessage("Пользовательские поля"),
        "custom_layout":
            MessageLookupByLibrary.simpleMessage("Пользовательский макет"),
        "custom_preset":
            MessageLookupByLibrary.simpleMessage("Пользовательский пресет"),
        "dark": MessageLookupByLibrary.simpleMessage("Тёмная"),
        "data_initialization_error":
            MessageLookupByLibrary.simpleMessage("Ошибка инициализации данных"),
        "day": MessageLookupByLibrary.simpleMessage("День"),
        "days_ago": m7,
        "default_settings":
            MessageLookupByLibrary.simpleMessage("Настройки по умолчанию"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "delete_character":
            MessageLookupByLibrary.simpleMessage("Удалить персонажа"),
        "delete_error":
            MessageLookupByLibrary.simpleMessage("Ошибка при удалении"),
        "delete_preset": MessageLookupByLibrary.simpleMessage("Удалить пресет"),
        "description": MessageLookupByLibrary.simpleMessage("Описание"),
        "detailed": MessageLookupByLibrary.simpleMessage("Подробный"),
        "details": MessageLookupByLibrary.simpleMessage("Подробнее"),
        "developer": MessageLookupByLibrary.simpleMessage("Разработчик"),
        "discard_changes": MessageLookupByLibrary.simpleMessage("Не сохранять"),
        "dnd_tools": MessageLookupByLibrary.simpleMessage("Инструменты D&D"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "edit_character":
            MessageLookupByLibrary.simpleMessage("Редактировать персонажа"),
        "edit_folder":
            MessageLookupByLibrary.simpleMessage("Редактирование папки"),
        "edit_race": MessageLookupByLibrary.simpleMessage("Редактировать расу"),
        "edit_template":
            MessageLookupByLibrary.simpleMessage("Редактирование шаблона"),
        "elderly": MessageLookupByLibrary.simpleMessage("Пожилые"),
        "empty_file_error":
            MessageLookupByLibrary.simpleMessage("Выбранный файл пуст"),
        "empty_list": MessageLookupByLibrary.simpleMessage("Здесь пусто!"),
        "enter_age": MessageLookupByLibrary.simpleMessage("Введите возраст"),
        "enter_race_name":
            MessageLookupByLibrary.simpleMessage("Введите название расы"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "error_details": MessageLookupByLibrary.simpleMessage("Детали ошибки"),
        "error_details_description": MessageLookupByLibrary.simpleMessage(
            "Произошла ошибка во время инициализации приложения. Подробная техническая информация:"),
        "error_loading_notes": MessageLookupByLibrary.simpleMessage(
            "Ошибка загрузки связанных заметок"),
        "event": MessageLookupByLibrary.simpleMessage("Событие"),
        "event_calendar":
            MessageLookupByLibrary.simpleMessage("Календарь событий"),
        "event_type": MessageLookupByLibrary.simpleMessage("Тип события"),
        "events": MessageLookupByLibrary.simpleMessage("События"),
        "events_loading_error":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки событий"),
        "events_this_month":
            MessageLookupByLibrary.simpleMessage("Событий в этом месяце"),
        "events_today": MessageLookupByLibrary.simpleMessage("Событий сегодня"),
        "export": MessageLookupByLibrary.simpleMessage("Экспорт"),
        "export_data":
            MessageLookupByLibrary.simpleMessage("Экспортировать данные"),
        "export_error": MessageLookupByLibrary.simpleMessage("Ошибка экспорта"),
        "export_options":
            MessageLookupByLibrary.simpleMessage("Опции экспорта"),
        "export_pdf_settings":
            MessageLookupByLibrary.simpleMessage("Настройки PDF экспорта"),
        "export_preset":
            MessageLookupByLibrary.simpleMessage("Пресет экспорта"),
        "export_success": MessageLookupByLibrary.simpleMessage(
            "PDF успешно создан и готов к использованию"),
        "favorites": MessageLookupByLibrary.simpleMessage("Избранное"),
        "feedback": MessageLookupByLibrary.simpleMessage("Обратная связь"),
        "female": MessageLookupByLibrary.simpleMessage("Женский"),
        "field_name": MessageLookupByLibrary.simpleMessage("Название поля"),
        "field_name_hint":
            MessageLookupByLibrary.simpleMessage("Введите название поля"),
        "field_value": MessageLookupByLibrary.simpleMessage("Значение поля"),
        "field_value_hint":
            MessageLookupByLibrary.simpleMessage("Введите значение поля"),
        "fields_asc": MessageLookupByLibrary.simpleMessage(
            "По количеству полей (по возрастанию)"),
        "fields_count": m8,
        "fields_desc": MessageLookupByLibrary.simpleMessage(
            "По количеству полей (по убыванию)"),
        "file_character":
            MessageLookupByLibrary.simpleMessage("Файл (.character)"),
        "file_pdf": MessageLookupByLibrary.simpleMessage("Документ PDF (.pdf)"),
        "file_pick_error":
            MessageLookupByLibrary.simpleMessage("Ошибка выбора файла"),
        "file_race": MessageLookupByLibrary.simpleMessage("Файл расы (.race)"),
        "file_ready":
            MessageLookupByLibrary.simpleMessage("Файл готов к отправке"),
        "file_sharing_timeout": MessageLookupByLibrary.simpleMessage(
            "Шаринг файла занял слишком много времени"),
        "filter_by": MessageLookupByLibrary.simpleMessage("Фильтровать по"),
        "filter_events":
            MessageLookupByLibrary.simpleMessage("Фильтровать события"),
        "finalizing_setup":
            MessageLookupByLibrary.simpleMessage("Завершение настройки..."),
        "flutterLicense":
            MessageLookupByLibrary.simpleMessage("Лицензия Flutter"),
        "folder": MessageLookupByLibrary.simpleMessage("Папка"),
        "folder_color": MessageLookupByLibrary.simpleMessage("Цвет папки"),
        "folder_name": MessageLookupByLibrary.simpleMessage("Имя папки"),
        "folders": MessageLookupByLibrary.simpleMessage("Папки"),
        "folders_count": m21,
        "font_load_timeout":
            MessageLookupByLibrary.simpleMessage("Таймаут загрузки шрифта"),
        "font_settings":
            MessageLookupByLibrary.simpleMessage("Настройки шрифтов"),
        "font_size": MessageLookupByLibrary.simpleMessage("Размер шрифта"),
        "from": MessageLookupByLibrary.simpleMessage("От"),
        "from_template": MessageLookupByLibrary.simpleMessage("Из шаблона"),
        "gender": MessageLookupByLibrary.simpleMessage("Пол"),
        "generateNumber":
            MessageLookupByLibrary.simpleMessage("Сгенерировать число"),
        "generate_sample":
            MessageLookupByLibrary.simpleMessage("Сгенерировать образец"),
        "generating": MessageLookupByLibrary.simpleMessage("Генерация..."),
        "githubRepo":
            MessageLookupByLibrary.simpleMessage("GitHub репозиторий"),
        "go_to_event":
            MessageLookupByLibrary.simpleMessage("Перейти к событию"),
        "grant_permission":
            MessageLookupByLibrary.simpleMessage("Предоставить разрешение"),
        "grid_view": MessageLookupByLibrary.simpleMessage("Вид сеткой"),
        "headers_footers": MessageLookupByLibrary.simpleMessage("Колонтитулы"),
        "help_and_support":
            MessageLookupByLibrary.simpleMessage("Помощь и поддержка"),
        "high_quality":
            MessageLookupByLibrary.simpleMessage("Высокое качество"),
        "hive_initialization_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка инициализации базы данных"),
        "home": MessageLookupByLibrary.simpleMessage("Главная"),
        "home_subtitle": MessageLookupByLibrary.simpleMessage(
            "Ваша коллекция персонажей и рас"),
        "hours_ago": m9,
        "image": MessageLookupByLibrary.simpleMessage("Изображение"),
        "image_picker_error": m10,
        "image_quality":
            MessageLookupByLibrary.simpleMessage("Качество изображений"),
        "import": MessageLookupByLibrary.simpleMessage("Импорт"),
        "import_cancelled":
            MessageLookupByLibrary.simpleMessage("Импорт отменен"),
        "import_character":
            MessageLookupByLibrary.simpleMessage("Импортировать персонажа"),
        "import_data":
            MessageLookupByLibrary.simpleMessage("Импортировать данные"),
        "import_error": m11,
        "import_race": MessageLookupByLibrary.simpleMessage("Импорт расы"),
        "import_template":
            MessageLookupByLibrary.simpleMessage("Импортировать шаблон"),
        "import_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Импорт шаблона"),
        "include_images":
            MessageLookupByLibrary.simpleMessage("Включать изображения"),
        "initialization": MessageLookupByLibrary.simpleMessage("Инициализация"),
        "initialization_complete":
            MessageLookupByLibrary.simpleMessage("Инициализация завершена"),
        "initialization_error":
            MessageLookupByLibrary.simpleMessage("Ошибка инициализации"),
        "initialization_failed":
            MessageLookupByLibrary.simpleMessage("Инициализация не удалась"),
        "initialization_progress":
            MessageLookupByLibrary.simpleMessage("Инициализация приложения..."),
        "initialization_reset_warning": MessageLookupByLibrary.simpleMessage(
            "Приложение сбросило некоторые данные и настройки для восстановления работоспособности"),
        "initialization_success": MessageLookupByLibrary.simpleMessage(
            "Инициализация завершена успешно"),
        "initialization_timeout":
            MessageLookupByLibrary.simpleMessage("Таймаут инициализации"),
        "initialization_timeout_message": MessageLookupByLibrary.simpleMessage(
            "Инициализация заняла слишком много времени. Проверьте подключение к интернету и попробуйте снова."),
        "invalid_age":
            MessageLookupByLibrary.simpleMessage("Введён неверный возраст"),
        "items": MessageLookupByLibrary.simpleMessage("элементов"),
        "just_now": MessageLookupByLibrary.simpleMessage("Только что"),
        "keywords": MessageLookupByLibrary.simpleMessage("Ключевые слова"),
        "landscape": MessageLookupByLibrary.simpleMessage("Альбомная"),
        "language": MessageLookupByLibrary.simpleMessage("Язык"),
        "last_created":
            MessageLookupByLibrary.simpleMessage("Последний созданный"),
        "last_edited":
            MessageLookupByLibrary.simpleMessage("Последний отредактированный"),
        "last_updated": MessageLookupByLibrary.simpleMessage("Обновлено"),
        "licenses": MessageLookupByLibrary.simpleMessage("Лицензии"),
        "light": MessageLookupByLibrary.simpleMessage("Светлая"),
        "list_view": MessageLookupByLibrary.simpleMessage("Вид списком"),
        "load_preset": MessageLookupByLibrary.simpleMessage("Загрузить пресет"),
        "loading_data":
            MessageLookupByLibrary.simpleMessage("Загрузка данных..."),
        "loading_resources":
            MessageLookupByLibrary.simpleMessage("Загрузка ресурсов..."),
        "local_backup_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка создания резервной копии"),
        "local_backup_success": MessageLookupByLibrary.simpleMessage(
            "Резервная копия успешно создана"),
        "local_restore_error":
            MessageLookupByLibrary.simpleMessage("Ошибка восстановления"),
        "local_restore_success": MessageLookupByLibrary.simpleMessage(
            "Данные успешно восстановлены"),
        "low_quality": MessageLookupByLibrary.simpleMessage("Низкое качество"),
        "low_storage_message": MessageLookupByLibrary.simpleMessage(
            "На вашем устройстве осталось мало места. Это может повлиять на работу приложения."),
        "low_storage_warning": MessageLookupByLibrary.simpleMessage(
            "Предупреждение: мало места на устройстве"),
        "main_image":
            MessageLookupByLibrary.simpleMessage("Основное изображение"),
        "male": MessageLookupByLibrary.simpleMessage("Мужской"),
        "markdown_bold": MessageLookupByLibrary.simpleMessage("Жирный"),
        "markdown_bullet_list":
            MessageLookupByLibrary.simpleMessage("Маркированный список"),
        "markdown_inline_code":
            MessageLookupByLibrary.simpleMessage("Код (в строке)"),
        "markdown_italic": MessageLookupByLibrary.simpleMessage("Курсив"),
        "markdown_numbered_list":
            MessageLookupByLibrary.simpleMessage("Нумерованный список"),
        "markdown_quote": MessageLookupByLibrary.simpleMessage("Цитата"),
        "markdown_underline":
            MessageLookupByLibrary.simpleMessage("Подчёркнутый"),
        "medium_quality":
            MessageLookupByLibrary.simpleMessage("Среднее качество"),
        "metadata": MessageLookupByLibrary.simpleMessage("Метаданные"),
        "migration_in_progress":
            MessageLookupByLibrary.simpleMessage("Миграция данных..."),
        "month": MessageLookupByLibrary.simpleMessage("Месяц"),
        "months_ago": m12,
        "more_fields": m13,
        "more_options":
            MessageLookupByLibrary.simpleMessage("Дополнительные настройки"),
        "most_edited":
            MessageLookupByLibrary.simpleMessage("Чаще всего редактируемый"),
        "most_popular":
            MessageLookupByLibrary.simpleMessage("Самые популярные"),
        "my": MessageLookupByLibrary.simpleMessage("Мои"),
        "my_characters": MessageLookupByLibrary.simpleMessage("Мои персонажи"),
        "name": MessageLookupByLibrary.simpleMessage("Название"),
        "new_character": MessageLookupByLibrary.simpleMessage("Новый персонаж"),
        "new_character_from_template":
            MessageLookupByLibrary.simpleMessage("Новый персонаж (из шаблона)"),
        "new_folder": MessageLookupByLibrary.simpleMessage("Новая папка"),
        "new_race": MessageLookupByLibrary.simpleMessage("Новая раса"),
        "new_template": MessageLookupByLibrary.simpleMessage("Новый шаблон"),
        "no_additional_images": MessageLookupByLibrary.simpleMessage(
            "Не добавлено ни одного изображения"),
        "no_characters": MessageLookupByLibrary.simpleMessage("Нет персонажей"),
        "no_content":
            MessageLookupByLibrary.simpleMessage("Содержание отсутствует"),
        "no_content_home":
            MessageLookupByLibrary.simpleMessage("Пока ничего нет"),
        "no_custom_fields":
            MessageLookupByLibrary.simpleMessage("Нет пользовательских полей"),
        "no_data_found":
            MessageLookupByLibrary.simpleMessage("Данные не найдены"),
        "no_description":
            MessageLookupByLibrary.simpleMessage("Описание отсутствует"),
        "no_events": MessageLookupByLibrary.simpleMessage(
            "Нет событий на выбранный день"),
        "no_folder_selected":
            MessageLookupByLibrary.simpleMessage("Нет выбранной папки"),
        "no_information":
            MessageLookupByLibrary.simpleMessage("Нет информации"),
        "no_race": MessageLookupByLibrary.simpleMessage("Раса не выбрана"),
        "no_races_created":
            MessageLookupByLibrary.simpleMessage("Нет созданных рас"),
        "no_recent_activity":
            MessageLookupByLibrary.simpleMessage("Нет недавней активности"),
        "no_templates": MessageLookupByLibrary.simpleMessage("Нет шаблонов"),
        "none": MessageLookupByLibrary.simpleMessage("Пусто"),
        "not_selected": MessageLookupByLibrary.simpleMessage("Не выбрано"),
        "note_events": MessageLookupByLibrary.simpleMessage("События заметок"),
        "notes_count": m22,
        "nothing_found": MessageLookupByLibrary.simpleMessage(
            "Ничего не найдено по запросу"),
        "ok": MessageLookupByLibrary.simpleMessage("Хорошо"),
        "operationCompleted":
            MessageLookupByLibrary.simpleMessage("Операция выполнена успешно"),
        "operation_timeout": MessageLookupByLibrary.simpleMessage(
            "Операция заняла слишком много времени"),
        "optimizing_performance": MessageLookupByLibrary.simpleMessage(
            "Оптимизация производительности..."),
        "other": MessageLookupByLibrary.simpleMessage("Другое"),
        "page_layout": MessageLookupByLibrary.simpleMessage("Макет страницы"),
        "page_margins": MessageLookupByLibrary.simpleMessage("Поля страницы"),
        "page_numbering":
            MessageLookupByLibrary.simpleMessage("Нумерация страниц"),
        "page_orientation":
            MessageLookupByLibrary.simpleMessage("Ориентация страницы"),
        "page_size": MessageLookupByLibrary.simpleMessage("Размер страницы"),
        "password_protection":
            MessageLookupByLibrary.simpleMessage("Защита паролем"),
        "pdf_creation_failed":
            MessageLookupByLibrary.simpleMessage("Не удалось создать PDF"),
        "pdf_creation_timeout": MessageLookupByLibrary.simpleMessage(
            "Создание PDF заняло слишком много времени"),
        "pdf_export_success":
            MessageLookupByLibrary.simpleMessage("PDF успешно экспортирован"),
        "pdf_generation_error":
            MessageLookupByLibrary.simpleMessage("Ошибка генерации PDF"),
        "pdf_generation_timeout": MessageLookupByLibrary.simpleMessage(
            "Генерация PDF заняла слишком много времени"),
        "permission_required":
            MessageLookupByLibrary.simpleMessage("Требуется разрешение"),
        "permissions": MessageLookupByLibrary.simpleMessage("Разрешения"),
        "personality": MessageLookupByLibrary.simpleMessage("Характер"),
        "popular_tags": MessageLookupByLibrary.simpleMessage("Популярные теги"),
        "portrait": MessageLookupByLibrary.simpleMessage("Портретная"),
        "posts": MessageLookupByLibrary.simpleMessage("Заметки"),
        "preparing_services":
            MessageLookupByLibrary.simpleMessage("Подготовка сервисов..."),
        "preset_deleted": MessageLookupByLibrary.simpleMessage("Пресет удален"),
        "preset_loaded":
            MessageLookupByLibrary.simpleMessage("Пресет загружен"),
        "preset_name": MessageLookupByLibrary.simpleMessage("Имя пресета"),
        "preset_saved": MessageLookupByLibrary.simpleMessage("Пресет сохранен"),
        "preview": MessageLookupByLibrary.simpleMessage("Предпросмотр"),
        "privacy_policy":
            MessageLookupByLibrary.simpleMessage("Политика конфиденциальности"),
        "processing": MessageLookupByLibrary.simpleMessage("Загрузка..."),
        "quick_actions":
            MessageLookupByLibrary.simpleMessage("Быстрые действия"),
        "quick_create":
            MessageLookupByLibrary.simpleMessage("Быстрое создание"),
        "race": MessageLookupByLibrary.simpleMessage("Раса"),
        "race_copied": MessageLookupByLibrary.simpleMessage(
            "Раса скопирована в буфер обмена"),
        "race_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить эту расу?"),
        "race_delete_error_content": MessageLookupByLibrary.simpleMessage(
            "Эта раса используется персонажами. Сначала измените их расу."),
        "race_delete_error_title":
            MessageLookupByLibrary.simpleMessage("Невозможно удалить расу"),
        "race_delete_title":
            MessageLookupByLibrary.simpleMessage("Удаление расы"),
        "race_deleted": MessageLookupByLibrary.simpleMessage("Раса удалена"),
        "race_events": MessageLookupByLibrary.simpleMessage("События рас"),
        "race_exported": m23,
        "race_imported": m14,
        "race_management":
            MessageLookupByLibrary.simpleMessage("Управление расами"),
        "race_profile_title":
            MessageLookupByLibrary.simpleMessage("Описание расы"),
        "race_service_creation_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка создания сервиса для расы"),
        "race_share_text": m15,
        "races": MessageLookupByLibrary.simpleMessage("Расы"),
        "races_count": m24,
        "randomNumberGenerator":
            MessageLookupByLibrary.simpleMessage("Генератор случайных чисел"),
        "rate_app": MessageLookupByLibrary.simpleMessage("Оценить приложение"),
        "ready_to_use": MessageLookupByLibrary.simpleMessage(
            "Приложение готово к использованию"),
        "recent_activity":
            MessageLookupByLibrary.simpleMessage("Недавняя активность"),
        "recent_characters":
            MessageLookupByLibrary.simpleMessage("Недавние персонажи"),
        "recent_notes":
            MessageLookupByLibrary.simpleMessage("Недавние заметки"),
        "recent_races": MessageLookupByLibrary.simpleMessage("Недавние расы"),
        "recently_edited":
            MessageLookupByLibrary.simpleMessage("Недавно редактировались"),
        "recently_viewed":
            MessageLookupByLibrary.simpleMessage("Недавно просмотренные"),
        "recovery_advice": MessageLookupByLibrary.simpleMessage(
            "Приложение автоматически попыталось восстановить работоспособность. Если ошибка повторяется, попробуйте переустановить приложение."),
        "reference_image":
            MessageLookupByLibrary.simpleMessage("Референс изображение"),
        "related_notes":
            MessageLookupByLibrary.simpleMessage("Связанные заметки"),
        "replace": MessageLookupByLibrary.simpleMessage("Заменить"),
        "required_field_error":
            MessageLookupByLibrary.simpleMessage("Обязательное поле"),
        "reset_settings":
            MessageLookupByLibrary.simpleMessage("Сбросить настройки"),
        "restoreData":
            MessageLookupByLibrary.simpleMessage("Восстановить данные"),
        "restore_data":
            MessageLookupByLibrary.simpleMessage("Восстановить данные"),
        "restore_from_cloud":
            MessageLookupByLibrary.simpleMessage("Восстановить из облака"),
        "restore_from_file":
            MessageLookupByLibrary.simpleMessage("Восстановить из файла"),
        "restore_options":
            MessageLookupByLibrary.simpleMessage("Варианты восстановления"),
        "restoringBackup": MessageLookupByLibrary.simpleMessage(
            "Восстановление из резервной копии"),
        "retry_initialization":
            MessageLookupByLibrary.simpleMessage("Повторить инициализацию"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "save_error": MessageLookupByLibrary.simpleMessage("Ошибка сохранения"),
        "save_preset": MessageLookupByLibrary.simpleMessage("Сохранить пресет"),
        "save_race": MessageLookupByLibrary.simpleMessage("Сохранить расу"),
        "save_settings":
            MessageLookupByLibrary.simpleMessage("Сохранить настройки"),
        "save_template":
            MessageLookupByLibrary.simpleMessage("Сохранить шаблон"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "search_characters":
            MessageLookupByLibrary.simpleMessage("Поиск персонажей..."),
        "search_collection":
            MessageLookupByLibrary.simpleMessage("Поиск по коллекции..."),
        "search_hint": MessageLookupByLibrary.simpleMessage(
            "Поиск по персонажам, расам, заметкам и шаблонам..."),
        "search_home":
            MessageLookupByLibrary.simpleMessage("Поиск персонажей и рас..."),
        "search_race_hint":
            MessageLookupByLibrary.simpleMessage("Поиск рас..."),
        "sections_to_include":
            MessageLookupByLibrary.simpleMessage("Включаемые разделы"),
        "security_options":
            MessageLookupByLibrary.simpleMessage("Опции безопасности"),
        "select": MessageLookupByLibrary.simpleMessage("Выбрано"),
        "selectRange":
            MessageLookupByLibrary.simpleMessage("ВЫБЕРИТЕ ДИАПАЗОН"),
        "select_character":
            MessageLookupByLibrary.simpleMessage("Выберите персонажа"),
        "select_folder": MessageLookupByLibrary.simpleMessage("Выбрать папку"),
        "select_gender_error":
            MessageLookupByLibrary.simpleMessage("Выберите пол"),
        "select_race_error":
            MessageLookupByLibrary.simpleMessage("Выберите расу"),
        "select_template":
            MessageLookupByLibrary.simpleMessage("Выберите шаблон"),
        "select_template_file":
            MessageLookupByLibrary.simpleMessage("Выберите файл шаблона"),
        "service_creation_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка создания сервиса для персонажа"),
        "service_initialization_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка инициализации сервиса"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "settings_load_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка загрузки настроек PDF"),
        "settings_save_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка сохранения настроек PDF"),
        "settings_saved":
            MessageLookupByLibrary.simpleMessage("Настройки сохранены"),
        "share": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "share_app":
            MessageLookupByLibrary.simpleMessage("Поделиться приложением"),
        "share_backup_file": MessageLookupByLibrary.simpleMessage(
            "Вот моя резервная копия CharacterBook"),
        "share_character": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "short_name": MessageLookupByLibrary.simpleMessage("Короткое имя"),
        "skip_for_now": MessageLookupByLibrary.simpleMessage("Пропустить"),
        "sort_by": MessageLookupByLibrary.simpleMessage("Сортировать по"),
        "standard": MessageLookupByLibrary.simpleMessage("стандартных"),
        "standard_fields":
            MessageLookupByLibrary.simpleMessage("Стандартные поля"),
        "start_writing":
            MessageLookupByLibrary.simpleMessage("Начните писать здесь..."),
        "statistics": MessageLookupByLibrary.simpleMessage("Статистика"),
        "storage_permission_message": MessageLookupByLibrary.simpleMessage(
            "Для работы приложения требуется разрешение на доступ к хранилищу."),
        "subject": MessageLookupByLibrary.simpleMessage("Тема"),
        "suggested_actions":
            MessageLookupByLibrary.simpleMessage("Рекомендуемые действия"),
        "system": MessageLookupByLibrary.simpleMessage("Системная"),
        "table_of_contents": MessageLookupByLibrary.simpleMessage("Оглавление"),
        "tag_cloud": MessageLookupByLibrary.simpleMessage("Облако тегов"),
        "tags": MessageLookupByLibrary.simpleMessage("Теги"),
        "technical_details":
            MessageLookupByLibrary.simpleMessage("Технические детали"),
        "template": MessageLookupByLibrary.simpleMessage("Шаблон"),
        "template_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить этот шаблон?"),
        "template_delete_title":
            MessageLookupByLibrary.simpleMessage("Удаление шаблона"),
        "template_deleted":
            MessageLookupByLibrary.simpleMessage("Шаблон удален"),
        "template_exists":
            MessageLookupByLibrary.simpleMessage("Шаблон уже существует"),
        "template_exported": m16,
        "template_imported": m17,
        "template_management": MessageLookupByLibrary.simpleMessage(
            "Управление шаблонами персонажей"),
        "template_name_label":
            MessageLookupByLibrary.simpleMessage("Название шаблона"),
        "template_replace_confirm": m18,
        "templates": MessageLookupByLibrary.simpleMessage("Шаблоны"),
        "templates_count": m25,
        "templates_not_found":
            MessageLookupByLibrary.simpleMessage("Шаблоны не найдены"),
        "terms_of_service":
            MessageLookupByLibrary.simpleMessage("Условия использования"),
        "theme": MessageLookupByLibrary.simpleMessage("Тема"),
        "timeout_error": MessageLookupByLibrary.simpleMessage("Таймаут"),
        "title_color": MessageLookupByLibrary.simpleMessage("Цвет заголовков"),
        "title_font_size":
            MessageLookupByLibrary.simpleMessage("Размер шрифта заголовков"),
        "to": MessageLookupByLibrary.simpleMessage("До"),
        "today": MessageLookupByLibrary.simpleMessage("Сегодня"),
        "tool_management":
            MessageLookupByLibrary.simpleMessage("Управление инструментами"),
        "total_count": m26,
        "total_events": MessageLookupByLibrary.simpleMessage("Всего событий"),
        "understood": MessageLookupByLibrary.simpleMessage("Понятно"),
        "unsaved_changes_content": MessageLookupByLibrary.simpleMessage(
            "У вас есть несохранённые изменения. Хотите сохранить перед выходом?"),
        "unsaved_changes_title":
            MessageLookupByLibrary.simpleMessage("Несохранённые изменения"),
        "unsupported_model_type": MessageLookupByLibrary.simpleMessage(
            "Неподдерживаемый тип модели для экспорта PDF"),
        "updated": MessageLookupByLibrary.simpleMessage("Обновлено"),
        "usedLibraries":
            MessageLookupByLibrary.simpleMessage("Используемые библиотеки"),
        "verifying_integrity":
            MessageLookupByLibrary.simpleMessage("Проверка целостности..."),
        "version": MessageLookupByLibrary.simpleMessage("Версия"),
        "version_info":
            MessageLookupByLibrary.simpleMessage("Информация о версии"),
        "view_all": MessageLookupByLibrary.simpleMessage("Показать все"),
        "watermark": MessageLookupByLibrary.simpleMessage("Водяной знак"),
        "web_not_supported":
            MessageLookupByLibrary.simpleMessage("Недоступно для веба"),
        "week": MessageLookupByLibrary.simpleMessage("Неделя"),
        "welcome_back": MessageLookupByLibrary.simpleMessage("С возвращением!"),
        "welcome_message": MessageLookupByLibrary.simpleMessage(
            "Добро пожаловать в CharacterBook!"),
        "whats_new": MessageLookupByLibrary.simpleMessage("Что нового"),
        "window_manager_initialization_error":
            MessageLookupByLibrary.simpleMessage(
                "Ошибка инициализации менеджера окон"),
        "years": MessageLookupByLibrary.simpleMessage("лет"),
        "years_ago": m19,
        "young": MessageLookupByLibrary.simpleMessage("Молодые"),
        "your_collection":
            MessageLookupByLibrary.simpleMessage("Ваша коллекция"),
        "z_to_a": MessageLookupByLibrary.simpleMessage("Я-А")
      };
}
