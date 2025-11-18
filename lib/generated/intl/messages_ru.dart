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

  static String m0(name) => "Персонаж создан из шаблона \"${name}\"";

  static String m1(name) => "Персонаж \"${name}\" успешно экспортирован";

  static String m2(name) => "Персонаж \"${name}\" успешно импортирован";

  static String m3(name) => "Файл персонажа ${name}";

  static String m4(charactersCount, notesCount, racesCount, templatesCount,
          foldersCount) =>
      "Успешно восстановлено:\n${charactersCount} персонажей\n${notesCount} заметок\n${racesCount} рас\n${templatesCount} шаблонов \n${foldersCount} папок";

  static String m5(days) => "${days} назад";

  static String m6(count) => "${count} полей";

  static String m7(hours) => "${hours} назад";

  static String m8(error) => "Ошибка при выборе изображения: ${error}";

  static String m9(error) => "Ошибка импорта: ${error}";

  static String m10(months) => "${months} назад";

  static String m11(count) => "${count} еще";

  static String m12(name) => "Раса \"${name}\" успешно импортирована";

  static String m13(name) => "Файл расы ${name}";

  static String m14(name) => "Шаблон \"${name}\" успешно экспортирован";

  static String m15(name) => "Шаблон \"${name}\" успешно импортирован";

  static String m16(name) => "Шаблон \"${name}\" уже существует. Заменить его?";

  static String m17(years) => "${years} лет назад";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "a_to_z": MessageLookupByLibrary.simpleMessage("А-Я"),
        "abilities": MessageLookupByLibrary.simpleMessage("Способности"),
        "aboutApp": MessageLookupByLibrary.simpleMessage("О приложении"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Акцентный цвет"),
        "acknowledgements":
            MessageLookupByLibrary.simpleMessage("Благодарности"),
        "add_picture":
            MessageLookupByLibrary.simpleMessage("Добавить изображение"),
        "add_tag": MessageLookupByLibrary.simpleMessage("Добавить тег"),
        "additional_images":
            MessageLookupByLibrary.simpleMessage("Доп. изображения"),
        "adults": MessageLookupByLibrary.simpleMessage("Взрослые"),
        "age": MessageLookupByLibrary.simpleMessage("Возраст"),
        "age_asc": MessageLookupByLibrary.simpleMessage("Возраст ↑"),
        "age_desc": MessageLookupByLibrary.simpleMessage("Возраст ↓"),
        "all": MessageLookupByLibrary.simpleMessage("Все"),
        "all_tags": MessageLookupByLibrary.simpleMessage("Все теги"),
        "another": MessageLookupByLibrary.simpleMessage("Другой"),
        "appLanguage": MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "app_name": MessageLookupByLibrary.simpleMessage("CharacterBook"),
        "appearance": MessageLookupByLibrary.simpleMessage("Внешность"),
        "auth_cancelled":
            MessageLookupByLibrary.simpleMessage("Авторизация отменена"),
        "auth_client_error": MessageLookupByLibrary.simpleMessage(
            "Не удалось получить клиент для API"),
        "avatar_crop_save":
            MessageLookupByLibrary.simpleMessage("Сохранение обрезки"),
        "avatar_crop_title":
            MessageLookupByLibrary.simpleMessage("Обрезка аватарки"),
        "back": MessageLookupByLibrary.simpleMessage("Назад"),
        "backstory": MessageLookupByLibrary.simpleMessage("Предыстория"),
        "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
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
        "blue": MessageLookupByLibrary.simpleMessage("Синий"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "character": MessageLookupByLibrary.simpleMessage("Персонаж"),
        "character_avatar":
            MessageLookupByLibrary.simpleMessage("Аватар персонажа"),
        "character_created_from_template": m0,
        "character_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить."),
        "character_delete_title":
            MessageLookupByLibrary.simpleMessage("Удалить персонажа?"),
        "character_deleted":
            MessageLookupByLibrary.simpleMessage("Персонаж удален"),
        "character_exported": m1,
        "character_gallery":
            MessageLookupByLibrary.simpleMessage("Галерея персонажа"),
        "character_imported": m2,
        "character_management":
            MessageLookupByLibrary.simpleMessage("Управление персонажами"),
        "character_reference":
            MessageLookupByLibrary.simpleMessage("Референс персонажа"),
        "character_share_text": m3,
        "characterbookLicense": MessageLookupByLibrary.simpleMessage(
            "CharacterBook лицензия (GNU GPL v3.0)"),
        "characters": MessageLookupByLibrary.simpleMessage("Персонажи"),
        "children": MessageLookupByLibrary.simpleMessage("Дети"),
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
        "cloud_export_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при экспорте в Google Drive"),
        "cloud_import_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при импорте из Google Drive"),
        "cloud_restore_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка при восстановлении данных"),
        "cloud_restore_success": m4,
        "colorScheme": MessageLookupByLibrary.simpleMessage("Цветовая схема"),
        "color_blue": MessageLookupByLibrary.simpleMessage("Синий"),
        "color_brown": MessageLookupByLibrary.simpleMessage("Коричневый"),
        "color_dark": MessageLookupByLibrary.simpleMessage("Тёмный"),
        "color_green": MessageLookupByLibrary.simpleMessage("Зелёный"),
        "color_grey": MessageLookupByLibrary.simpleMessage("Серый"),
        "color_orange": MessageLookupByLibrary.simpleMessage("Оранжевый"),
        "color_pink": MessageLookupByLibrary.simpleMessage("Розовый"),
        "color_purple": MessageLookupByLibrary.simpleMessage("Фиолетовый"),
        "color_red": MessageLookupByLibrary.simpleMessage("Красный"),
        "color_teal": MessageLookupByLibrary.simpleMessage("Бирюзовый"),
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
        "create_first_content": MessageLookupByLibrary.simpleMessage(
            "Создайте первого персонажа или расу"),
        "create_from_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Создать из шаблона"),
        "create_template":
            MessageLookupByLibrary.simpleMessage("Создать шаблон"),
        "create_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Создать шаблон"),
        "creatingBackup":
            MessageLookupByLibrary.simpleMessage("Создать резервную копию"),
        "creating_file":
            MessageLookupByLibrary.simpleMessage("Создание файла..."),
        "creating_pdf": MessageLookupByLibrary.simpleMessage("Создание PDF..."),
        "custom": MessageLookupByLibrary.simpleMessage("пользовательских"),
        "custom_fields":
            MessageLookupByLibrary.simpleMessage("Пользовательские поля"),
        "dark": MessageLookupByLibrary.simpleMessage("Тёмная"),
        "days_ago": m5,
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "delete_character":
            MessageLookupByLibrary.simpleMessage("Удалить персонажа"),
        "delete_error":
            MessageLookupByLibrary.simpleMessage("Ошибка при удалении"),
        "description": MessageLookupByLibrary.simpleMessage("Описание"),
        "detailed": MessageLookupByLibrary.simpleMessage("Подробный"),
        "developer": MessageLookupByLibrary.simpleMessage("Разработчик"),
        "discard_changes": MessageLookupByLibrary.simpleMessage("Не сохранять"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "edit_character":
            MessageLookupByLibrary.simpleMessage("Редактировать персонажа"),
        "edit_folder":
            MessageLookupByLibrary.simpleMessage("Редактирование папки"),
        "edit_race": MessageLookupByLibrary.simpleMessage("Редактировать расу"),
        "edit_template": MessageLookupByLibrary.simpleMessage("Редактирование"),
        "elderly": MessageLookupByLibrary.simpleMessage("Пожилые"),
        "empty_file_error":
            MessageLookupByLibrary.simpleMessage("Выбранный файл пуст"),
        "empty_list": MessageLookupByLibrary.simpleMessage("Здесь пусто!"),
        "enter_age": MessageLookupByLibrary.simpleMessage("Введите возраст"),
        "enter_race_name":
            MessageLookupByLibrary.simpleMessage("Введите название расы"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "error_loading_notes": MessageLookupByLibrary.simpleMessage(
            "Ошибка загрузки связанных постов"),
        "export": MessageLookupByLibrary.simpleMessage("Экспорт в PDF"),
        "export_error": MessageLookupByLibrary.simpleMessage("Ошибка экспорта"),
        "female": MessageLookupByLibrary.simpleMessage("Женский"),
        "fields_asc":
            MessageLookupByLibrary.simpleMessage("По количеству полей (возр.)"),
        "fields_count": m6,
        "fields_desc":
            MessageLookupByLibrary.simpleMessage("По количеству полей (убыв.)"),
        "file_character":
            MessageLookupByLibrary.simpleMessage("Файл (.character)"),
        "file_pdf": MessageLookupByLibrary.simpleMessage("Документ PDF (.pdf)"),
        "file_pick_error":
            MessageLookupByLibrary.simpleMessage("Ошибка выбора файла"),
        "file_ready":
            MessageLookupByLibrary.simpleMessage("Файл готов к отправке"),
        "flutterLicense":
            MessageLookupByLibrary.simpleMessage("Flutter лицензия"),
        "folder": MessageLookupByLibrary.simpleMessage("Папка"),
        "folder_color": MessageLookupByLibrary.simpleMessage("Цвет папки"),
        "folder_name": MessageLookupByLibrary.simpleMessage("Имя папки"),
        "folders": MessageLookupByLibrary.simpleMessage("Папки"),
        "from_template": MessageLookupByLibrary.simpleMessage("Из шаблона"),
        "gender": MessageLookupByLibrary.simpleMessage("Гендер"),
        "githubRepo":
            MessageLookupByLibrary.simpleMessage("GitHub репозиторий"),
        "green": MessageLookupByLibrary.simpleMessage("Зеленый"),
        "grid_view":
            MessageLookupByLibrary.simpleMessage("Представление сетки"),
        "home_subtitle": MessageLookupByLibrary.simpleMessage(
            "Ваша коллекция персонажей и рас"),
        "hours_ago": m7,
        "image": MessageLookupByLibrary.simpleMessage("Изображение"),
        "image_picker_error": m8,
        "import": MessageLookupByLibrary.simpleMessage("Импорт"),
        "import_cancelled":
            MessageLookupByLibrary.simpleMessage("Импорт отменен"),
        "import_character":
            MessageLookupByLibrary.simpleMessage("Импортировать персонажа"),
        "import_error": m9,
        "import_race":
            MessageLookupByLibrary.simpleMessage("Импортирование расы"),
        "import_template":
            MessageLookupByLibrary.simpleMessage("Импортировать шаблон"),
        "import_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Импорт шаблона"),
        "invalid_age":
            MessageLookupByLibrary.simpleMessage("Введён неверный возраст"),
        "items": MessageLookupByLibrary.simpleMessage("элементов"),
        "just_now": MessageLookupByLibrary.simpleMessage("Только что"),
        "language": MessageLookupByLibrary.simpleMessage("Язык"),
        "last_updated": MessageLookupByLibrary.simpleMessage("Обновлено"),
        "licenses": MessageLookupByLibrary.simpleMessage("Лицензия"),
        "light": MessageLookupByLibrary.simpleMessage("Светлая"),
        "lightBlue": MessageLookupByLibrary.simpleMessage("Голубой"),
        "list_view":
            MessageLookupByLibrary.simpleMessage("Представление списка"),
        "local_backup_error": MessageLookupByLibrary.simpleMessage(
            "Ошибка создания резервной копии"),
        "local_backup_success": MessageLookupByLibrary.simpleMessage(
            "Резервная копия успешно создана"),
        "local_restore_error":
            MessageLookupByLibrary.simpleMessage("Ошибка восстановления"),
        "local_restore_success": MessageLookupByLibrary.simpleMessage(
            "Восстановление произошло успешно"),
        "main_image":
            MessageLookupByLibrary.simpleMessage("Основное изображение"),
        "male": MessageLookupByLibrary.simpleMessage("Мужской"),
        "markdown_bold": MessageLookupByLibrary.simpleMessage("Жирный"),
        "markdown_bullet_list":
            MessageLookupByLibrary.simpleMessage("Маркированный список"),
        "markdown_inline_code":
            MessageLookupByLibrary.simpleMessage("Код (inline)"),
        "markdown_italic": MessageLookupByLibrary.simpleMessage("Курсив"),
        "markdown_numbered_list":
            MessageLookupByLibrary.simpleMessage("Нумерованный список"),
        "markdown_quote": MessageLookupByLibrary.simpleMessage("Цитата"),
        "markdown_underline":
            MessageLookupByLibrary.simpleMessage("Подчеркнутый"),
        "months_ago": m10,
        "more_fields": m11,
        "my": MessageLookupByLibrary.simpleMessage("Мои"),
        "my_characters": MessageLookupByLibrary.simpleMessage("Мои персонажи"),
        "name": MessageLookupByLibrary.simpleMessage("Имя"),
        "new_character": MessageLookupByLibrary.simpleMessage("Новый персонаж"),
        "new_character_from_template":
            MessageLookupByLibrary.simpleMessage("Новый персонаж (из шаблона)"),
        "new_folder": MessageLookupByLibrary.simpleMessage("Новая папка"),
        "new_race": MessageLookupByLibrary.simpleMessage("Новая раса"),
        "new_template": MessageLookupByLibrary.simpleMessage("Новый шаблон"),
        "no_additional_images": MessageLookupByLibrary.simpleMessage(
            "Не добавлено ни одного изображение"),
        "no_characters": MessageLookupByLibrary.simpleMessage("Нет персонажей"),
        "no_content":
            MessageLookupByLibrary.simpleMessage("Содержание отсутствует"),
        "no_content_home":
            MessageLookupByLibrary.simpleMessage("Пока ничего нет"),
        "no_data_found":
            MessageLookupByLibrary.simpleMessage("Данные не найдены"),
        "no_description":
            MessageLookupByLibrary.simpleMessage("Описание отсутствует"),
        "no_folder_selected":
            MessageLookupByLibrary.simpleMessage("Нет выбранной папки"),
        "no_information":
            MessageLookupByLibrary.simpleMessage("Нет информации"),
        "no_race": MessageLookupByLibrary.simpleMessage("Без расы"),
        "no_races_created":
            MessageLookupByLibrary.simpleMessage("Нет созданных рас"),
        "no_templates": MessageLookupByLibrary.simpleMessage("Нет шаблонов"),
        "none": MessageLookupByLibrary.simpleMessage("Пусто"),
        "not_selected": MessageLookupByLibrary.simpleMessage("Не выбрано"),
        "nothing_found": MessageLookupByLibrary.simpleMessage(
            "Ничего не найдено по запросу"),
        "ok": MessageLookupByLibrary.simpleMessage("Хорошо"),
        "operationCompleted":
            MessageLookupByLibrary.simpleMessage("Операция выполнена успешно"),
        "orange": MessageLookupByLibrary.simpleMessage("Оранжевый"),
        "other": MessageLookupByLibrary.simpleMessage("Прочее"),
        "pdf_export_success":
            MessageLookupByLibrary.simpleMessage("PDF успешно экспортирован"),
        "personality": MessageLookupByLibrary.simpleMessage("Характер"),
        "pink": MessageLookupByLibrary.simpleMessage("Розовый"),
        "posts": MessageLookupByLibrary.simpleMessage("Посты"),
        "processing": MessageLookupByLibrary.simpleMessage("Загрузка..."),
        "purple": MessageLookupByLibrary.simpleMessage("Фиолетовый"),
        "race": MessageLookupByLibrary.simpleMessage("Раса"),
        "race_copied":
            MessageLookupByLibrary.simpleMessage("Раса скопирована в буфер"),
        "race_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить эту расу?"),
        "race_delete_error_content": MessageLookupByLibrary.simpleMessage(
            "Эта раса используется персонажами. Сначала измените их расу."),
        "race_delete_error_title":
            MessageLookupByLibrary.simpleMessage("Невозможно удалить расу"),
        "race_delete_title":
            MessageLookupByLibrary.simpleMessage("Удаление расы"),
        "race_deleted": MessageLookupByLibrary.simpleMessage("Раса удалена"),
        "race_imported": m12,
        "race_management":
            MessageLookupByLibrary.simpleMessage("Управление расами"),
        "race_name": MessageLookupByLibrary.simpleMessage("Название расы"),
        "race_share_text": m13,
        "races": MessageLookupByLibrary.simpleMessage("Расы"),
        "red": MessageLookupByLibrary.simpleMessage("Красный"),
        "reference_image": MessageLookupByLibrary.simpleMessage("Референс"),
        "related_notes":
            MessageLookupByLibrary.simpleMessage("Связанные посты"),
        "replace": MessageLookupByLibrary.simpleMessage("Заменить"),
        "required_field_error":
            MessageLookupByLibrary.simpleMessage("Обязательное поле"),
        "restoreData":
            MessageLookupByLibrary.simpleMessage("Восстановить данные"),
        "restore_from_cloud":
            MessageLookupByLibrary.simpleMessage("Восстановить из облака"),
        "restore_from_file":
            MessageLookupByLibrary.simpleMessage("Восстановить из файла"),
        "restore_options":
            MessageLookupByLibrary.simpleMessage("Варианты восстановления"),
        "restoringBackup": MessageLookupByLibrary.simpleMessage(
            "Восстановить из резервной копии"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "save_error": MessageLookupByLibrary.simpleMessage("Ошибка сохранения"),
        "save_race": MessageLookupByLibrary.simpleMessage("Сохранить расу"),
        "save_template":
            MessageLookupByLibrary.simpleMessage("Сохранить шаблон"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "search_characters":
            MessageLookupByLibrary.simpleMessage("Поиск персонажей..."),
        "search_hint": MessageLookupByLibrary.simpleMessage(
            "Поиск по персонажам, расам, заметкам и шаблонам..."),
        "search_home":
            MessageLookupByLibrary.simpleMessage("Поиск персонажей и рас..."),
        "search_race_hint":
            MessageLookupByLibrary.simpleMessage("Поиск рас..."),
        "select": MessageLookupByLibrary.simpleMessage("Выбрано"),
        "select_character":
            MessageLookupByLibrary.simpleMessage("Выберите персонажа"),
        "select_folder": MessageLookupByLibrary.simpleMessage("Выбрать папку"),
        "select_gender_error":
            MessageLookupByLibrary.simpleMessage("Выберите пол"),
        "select_race": MessageLookupByLibrary.simpleMessage("Выберите расу"),
        "select_race_error":
            MessageLookupByLibrary.simpleMessage("Выберите расу"),
        "select_template":
            MessageLookupByLibrary.simpleMessage("Выберите шаблон"),
        "select_template_file":
            MessageLookupByLibrary.simpleMessage("Выберите файл шаблона"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "share_backup_file": MessageLookupByLibrary.simpleMessage(
            "Вот моя резервная копия CharacterBook"),
        "share_character": MessageLookupByLibrary.simpleMessage("Поделиться"),
        "short_name": MessageLookupByLibrary.simpleMessage("Короткое имя"),
        "standard": MessageLookupByLibrary.simpleMessage("стандартных"),
        "standard_fields":
            MessageLookupByLibrary.simpleMessage("Стандартные поля"),
        "system": MessageLookupByLibrary.simpleMessage("Системная"),
        "tags": MessageLookupByLibrary.simpleMessage("Теги"),
        "teal": MessageLookupByLibrary.simpleMessage("Бирюзовый"),
        "template": MessageLookupByLibrary.simpleMessage("Шаблон"),
        "template_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить этот шаблон?"),
        "template_delete_title":
            MessageLookupByLibrary.simpleMessage("Удаление шаблона"),
        "template_deleted":
            MessageLookupByLibrary.simpleMessage("Шаблон удален"),
        "template_exists":
            MessageLookupByLibrary.simpleMessage("Шаблон уже существует"),
        "template_exported": m14,
        "template_imported": m15,
        "template_name_label":
            MessageLookupByLibrary.simpleMessage("Название шаблона"),
        "template_replace_confirm": m16,
        "templates": MessageLookupByLibrary.simpleMessage("Шаблоны"),
        "templates_not_found":
            MessageLookupByLibrary.simpleMessage("Шаблоны не найдены"),
        "theme": MessageLookupByLibrary.simpleMessage("Тема"),
        "unsaved_changes_content": MessageLookupByLibrary.simpleMessage(
            "У вас есть несохраненные изменения. Хотите сохранить перед выходом?"),
        "unsaved_changes_title":
            MessageLookupByLibrary.simpleMessage("Несохраненные изменения"),
        "usedLibraries":
            MessageLookupByLibrary.simpleMessage("Используемые библиотеки"),
        "version": MessageLookupByLibrary.simpleMessage("Версия"),
        "web_not_supported":
            MessageLookupByLibrary.simpleMessage("Недоступно для веба"),
        "years": MessageLookupByLibrary.simpleMessage("лет"),
        "years_ago": m17,
        "young": MessageLookupByLibrary.simpleMessage("Молодые"),
        "z_to_a": MessageLookupByLibrary.simpleMessage("Я-А")
      };
}
