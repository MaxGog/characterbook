// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `О приложении`
  String get aboutApp {
    return Intl.message(
      'О приложении',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Способности`
  String get abilities {
    return Intl.message(
      'Способности',
      name: 'abilities',
      desc: '',
      args: [],
    );
  }

  /// `Акцентный цвет`
  String get accentColor {
    return Intl.message(
      'Акцентный цвет',
      name: 'accentColor',
      desc: '',
      args: [],
    );
  }

  /// `Благодарности`
  String get acknowledgements {
    return Intl.message(
      'Благодарности',
      name: 'acknowledgements',
      desc: '',
      args: [],
    );
  }

  /// `Добавить изображение`
  String get add_picture {
    return Intl.message(
      'Добавить изображение',
      name: 'add_picture',
      desc: '',
      args: [],
    );
  }

  /// `Взрослые`
  String get adults {
    return Intl.message(
      'Взрослые',
      name: 'adults',
      desc: '',
      args: [],
    );
  }

  /// `Возраст`
  String get age {
    return Intl.message(
      'Возраст',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Возраст ↑`
  String get age_asc {
    return Intl.message(
      'Возраст ↑',
      name: 'age_asc',
      desc: '',
      args: [],
    );
  }

  /// `Возраст ↓`
  String get age_desc {
    return Intl.message(
      'Возраст ↓',
      name: 'age_desc',
      desc: '',
      args: [],
    );
  }

  /// `Все`
  String get all {
    return Intl.message(
      'Все',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Все теги`
  String get all_tags {
    return Intl.message(
      'Все теги',
      name: 'all_tags',
      desc: '',
      args: [],
    );
  }

  /// `Другой`
  String get another {
    return Intl.message(
      'Другой',
      name: 'another',
      desc: '',
      args: [],
    );
  }

  /// `Язык приложения`
  String get appLanguage {
    return Intl.message(
      'Язык приложения',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `CharacterBook`
  String get app_name {
    return Intl.message(
      'CharacterBook',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Внешность`
  String get appearance {
    return Intl.message(
      'Внешность',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Авторизация отменена`
  String get auth_cancelled {
    return Intl.message(
      'Авторизация отменена',
      name: 'auth_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось получить клиент для API`
  String get auth_client_error {
    return Intl.message(
      'Не удалось получить клиент для API',
      name: 'auth_client_error',
      desc: '',
      args: [],
    );
  }

  /// `Назад`
  String get back {
    return Intl.message(
      'Назад',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Резервное копирование`
  String get backup {
    return Intl.message(
      'Резервное копирование',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Основная информация`
  String get basic_info {
    return Intl.message(
      'Основная информация',
      name: 'basic_info',
      desc: '',
      args: [],
    );
  }

  /// `Биография`
  String get biography {
    return Intl.message(
      'Биография',
      name: 'biography',
      desc: '',
      args: [],
    );
  }

  /// `Биология`
  String get biology {
    return Intl.message(
      'Биология',
      name: 'biology',
      desc: '',
      args: [],
    );
  }

  /// `Синий`
  String get blue {
    return Intl.message(
      'Синий',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж`
  String get character {
    return Intl.message(
      'Персонаж',
      name: 'character',
      desc: '',
      args: [],
    );
  }

  /// `Аватар персонажа`
  String get character_avatar {
    return Intl.message(
      'Аватар персонажа',
      name: 'character_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж создан из шаблона "{name}"`
  String character_created_from_template(Object name) {
    return Intl.message(
      'Персонаж создан из шаблона "$name"',
      name: 'character_created_from_template',
      desc: '',
      args: [name],
    );
  }

  /// `Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить.`
  String get character_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить.',
      name: 'character_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Удалить персонажа?`
  String get character_delete_title {
    return Intl.message(
      'Удалить персонажа?',
      name: 'character_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж удален`
  String get character_deleted {
    return Intl.message(
      'Персонаж удален',
      name: 'character_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж "{name}" успешно экспортирован`
  String character_exported(Object name) {
    return Intl.message(
      'Персонаж "$name" успешно экспортирован',
      name: 'character_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Галерея персонажа`
  String get character_gallery {
    return Intl.message(
      'Галерея персонажа',
      name: 'character_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж "{name}" успешно импортирован`
  String character_imported(Object name) {
    return Intl.message(
      'Персонаж "$name" успешно импортирован',
      name: 'character_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Управление персонажами`
  String get character_management {
    return Intl.message(
      'Управление персонажами',
      name: 'character_management',
      desc: '',
      args: [],
    );
  }

  /// `Референс персонажа`
  String get character_reference {
    return Intl.message(
      'Референс персонажа',
      name: 'character_reference',
      desc: '',
      args: [],
    );
  }

  /// `Файл персонажа {name}`
  String character_share_text(Object name) {
    return Intl.message(
      'Файл персонажа $name',
      name: 'character_share_text',
      desc: '',
      args: [name],
    );
  }

  /// `Персонажи`
  String get characters {
    return Intl.message(
      'Персонажи',
      name: 'characters',
      desc: '',
      args: [],
    );
  }

  /// `Дети`
  String get children {
    return Intl.message(
      'Дети',
      name: 'children',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при создании резервной копии персонажей`
  String get cloud_backup_characters_error {
    return Intl.message(
      'Ошибка при создании резервной копии персонажей',
      name: 'cloud_backup_characters_error',
      desc: '',
      args: [],
    );
  }

  /// `Резервная копия персонажей успешно создана`
  String get cloud_backup_characters_success {
    return Intl.message(
      'Резервная копия персонажей успешно создана',
      name: 'cloud_backup_characters_success',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при создании резервной копии`
  String get cloud_backup_error {
    return Intl.message(
      'Ошибка при создании резервной копии',
      name: 'cloud_backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Полная резервная копия успешно создана в Google Drive`
  String get cloud_backup_full_success {
    return Intl.message(
      'Полная резервная копия успешно создана в Google Drive',
      name: 'cloud_backup_full_success',
      desc: '',
      args: [],
    );
  }

  /// `Резервные копии не найдены`
  String get cloud_backup_not_found {
    return Intl.message(
      'Резервные копии не найдены',
      name: 'cloud_backup_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при экспорте в Google Drive`
  String get cloud_export_error {
    return Intl.message(
      'Ошибка при экспорте в Google Drive',
      name: 'cloud_export_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при импорте из Google Drive`
  String get cloud_import_error {
    return Intl.message(
      'Ошибка при импорте из Google Drive',
      name: 'cloud_import_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при восстановлении данных`
  String get cloud_restore_error {
    return Intl.message(
      'Ошибка при восстановлении данных',
      name: 'cloud_restore_error',
      desc: '',
      args: [],
    );
  }

  /// `Успешно восстановлено:\n{charactersCount} персонажей\n{notesCount} заметок\n{racesCount} рас\n{templatesCount} шаблонов \n{foldersCount} папок`
  String cloud_restore_success(Object charactersCount, Object notesCount,
      Object racesCount, Object templatesCount, Object foldersCount) {
    return Intl.message(
      'Успешно восстановлено:\n$charactersCount персонажей\n$notesCount заметок\n$racesCount рас\n$templatesCount шаблонов \n$foldersCount папок',
      name: 'cloud_restore_success',
      desc: '',
      args: [
        charactersCount,
        notesCount,
        racesCount,
        templatesCount,
        foldersCount
      ],
    );
  }

  /// `Цветовая схема`
  String get colorScheme {
    return Intl.message(
      'Цветовая схема',
      name: 'colorScheme',
      desc: '',
      args: [],
    );
  }

  /// `Копировать`
  String get copy {
    return Intl.message(
      'Копировать',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Скопировать персонажа`
  String get copy_character {
    return Intl.message(
      'Скопировать персонажа',
      name: 'copy_character',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка копирования`
  String get copy_error {
    return Intl.message(
      'Ошибка копирования',
      name: 'copy_error',
      desc: '',
      args: [],
    );
  }

  /// `Скопировано в буфер обмена`
  String get copied_to_clipboard {
    return Intl.message(
      'Скопировано в буфер обмена',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Создать`
  String get create {
    return Intl.message(
      'Создать',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Создать резервную копию`
  String get createBackup {
    return Intl.message(
      'Создать резервную копию',
      name: 'createBackup',
      desc: '',
      args: [],
    );
  }

  /// `Создание PDF...`
  String get creating_pdf {
    return Intl.message(
      'Создание PDF...',
      name: 'creating_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Создание файла...`
  String get creating_file {
    return Intl.message(
      'Создание файла...',
      name: 'creating_file',
      desc: '',
      args: [],
    );
  }

  /// `Создать персонажа`
  String get create_character {
    return Intl.message(
      'Создать персонажа',
      name: 'create_character',
      desc: '',
      args: [],
    );
  }

  /// `Создать из шаблона`
  String get create_from_template_tooltip {
    return Intl.message(
      'Создать из шаблона',
      name: 'create_from_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Создать шаблон`
  String get create_template_tooltip {
    return Intl.message(
      'Создать шаблон',
      name: 'create_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Создать шаблон`
  String get create_template {
    return Intl.message(
      'Создать шаблон',
      name: 'create_template',
      desc: '',
      args: [],
    );
  }

  /// `Пользовательские поля`
  String get custom_fields {
    return Intl.message(
      'Пользовательские поля',
      name: 'custom_fields',
      desc: '',
      args: [],
    );
  }

  /// `Тёмная`
  String get dark {
    return Intl.message(
      'Тёмная',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message(
      'Удалить',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Удалить персонажа`
  String get delete_character {
    return Intl.message(
      'Удалить персонажа',
      name: 'delete_character',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при удалении`
  String get delete_error {
    return Intl.message(
      'Ошибка при удалении',
      name: 'delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Описание`
  String get description {
    return Intl.message(
      'Описание',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Разработчик`
  String get developer {
    return Intl.message(
      'Разработчик',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `Не сохранять`
  String get discard_changes {
    return Intl.message(
      'Не сохранять',
      name: 'discard_changes',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать`
  String get edit {
    return Intl.message(
      'Редактировать',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать персонажа`
  String get edit_character {
    return Intl.message(
      'Редактировать персонажа',
      name: 'edit_character',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать расу`
  String get edit_race {
    return Intl.message(
      'Редактировать расу',
      name: 'edit_race',
      desc: '',
      args: [],
    );
  }

  /// `Редактирование`
  String get edit_template {
    return Intl.message(
      'Редактирование',
      name: 'edit_template',
      desc: '',
      args: [],
    );
  }

  /// `Пожилые`
  String get elderly {
    return Intl.message(
      'Пожилые',
      name: 'elderly',
      desc: '',
      args: [],
    );
  }

  /// `Здесь пусто!`
  String get empty_list {
    return Intl.message(
      'Здесь пусто!',
      name: 'empty_list',
      desc: '',
      args: [],
    );
  }

  /// `Введите возраст`
  String get enter_age {
    return Intl.message(
      'Введите возраст',
      name: 'enter_age',
      desc: '',
      args: [],
    );
  }

  /// `Введите название расы`
  String get enter_race_name {
    return Intl.message(
      'Введите название расы',
      name: 'enter_race_name',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка`
  String get error {
    return Intl.message(
      'Ошибка',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки связанных постов`
  String get error_loading_notes {
    return Intl.message(
      'Ошибка загрузки связанных постов',
      name: 'error_loading_notes',
      desc: '',
      args: [],
    );
  }

  /// `Экспорт в PDF`
  String get export {
    return Intl.message(
      'Экспорт в PDF',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка экспорта`
  String get export_error {
    return Intl.message(
      'Ошибка экспорта',
      name: 'export_error',
      desc: '',
      args: [],
    );
  }

  /// `Женский`
  String get female {
    return Intl.message(
      'Женский',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Файл (.character)`
  String get file_character {
    return Intl.message(
      'Файл (.character)',
      name: 'file_character',
      desc: '',
      args: [],
    );
  }

  /// `Документ PDF (.pdf)`
  String get file_pdf {
    return Intl.message(
      'Документ PDF (.pdf)',
      name: 'file_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка выбора файла`
  String get file_pick_error {
    return Intl.message(
      'Ошибка выбора файла',
      name: 'file_pick_error',
      desc: '',
      args: [],
    );
  }

  /// `Файл готов к отправке`
  String get file_ready {
    return Intl.message(
      'Файл готов к отправке',
      name: 'file_ready',
      desc: '',
      args: [],
    );
  }

  /// `{count} полей`
  String fields_count(Object count) {
    return Intl.message(
      '$count полей',
      name: 'fields_count',
      desc: '',
      args: [count],
    );
  }

  /// `Из шаблона`
  String get from_template {
    return Intl.message(
      'Из шаблона',
      name: 'from_template',
      desc: '',
      args: [],
    );
  }

  /// `Гендер`
  String get gender {
    return Intl.message(
      'Гендер',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `GitHub репозиторий`
  String get githubRepo {
    return Intl.message(
      'GitHub репозиторий',
      name: 'githubRepo',
      desc: '',
      args: [],
    );
  }

  /// `Зеленый`
  String get green {
    return Intl.message(
      'Зеленый',
      name: 'green',
      desc: '',
      args: [],
    );
  }

  /// `Представление сетки`
  String get grid_view {
    return Intl.message(
      'Представление сетки',
      name: 'grid_view',
      desc: '',
      args: [],
    );
  }

  /// `Изображение`
  String get image {
    return Intl.message(
      'Изображение',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при выборе изображения: {error}`
  String image_picker_error(Object error) {
    return Intl.message(
      'Ошибка при выборе изображения: $error',
      name: 'image_picker_error',
      desc: '',
      args: [error],
    );
  }

  /// `Импорт отменен`
  String get import_cancelled {
    return Intl.message(
      'Импорт отменен',
      name: 'import_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Импортировать персонажа`
  String get import_character {
    return Intl.message(
      'Импортировать персонажа',
      name: 'import_character',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка импорта: {error}`
  String import_error(Object error) {
    return Intl.message(
      'Ошибка импорта: $error',
      name: 'import_error',
      desc: '',
      args: [error],
    );
  }

  /// `Импортировать шаблон`
  String get import_template {
    return Intl.message(
      'Импортировать шаблон',
      name: 'import_template',
      desc: '',
      args: [],
    );
  }

  /// `Импорт шаблона`
  String get import_template_tooltip {
    return Intl.message(
      'Импорт шаблона',
      name: 'import_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Введён неверный возраст`
  String get invalid_age {
    return Intl.message(
      'Введён неверный возраст',
      name: 'invalid_age',
      desc: '',
      args: [],
    );
  }

  /// `Язык`
  String get language {
    return Intl.message(
      'Язык',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Обновлено`
  String get last_updated {
    return Intl.message(
      'Обновлено',
      name: 'last_updated',
      desc: '',
      args: [],
    );
  }

  /// `Светлая`
  String get light {
    return Intl.message(
      'Светлая',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Голубой`
  String get lightBlue {
    return Intl.message(
      'Голубой',
      name: 'lightBlue',
      desc: '',
      args: [],
    );
  }

  /// `Представление списка`
  String get list_view {
    return Intl.message(
      'Представление списка',
      name: 'list_view',
      desc: '',
      args: [],
    );
  }

  /// `Основное изображение`
  String get main_image {
    return Intl.message(
      'Основное изображение',
      name: 'main_image',
      desc: '',
      args: [],
    );
  }

  /// `Мужской`
  String get male {
    return Intl.message(
      'Мужской',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Жирный`
  String get markdown_bold {
    return Intl.message(
      'Жирный',
      name: 'markdown_bold',
      desc: '',
      args: [],
    );
  }

  /// `Маркированный список`
  String get markdown_bullet_list {
    return Intl.message(
      'Маркированный список',
      name: 'markdown_bullet_list',
      desc: '',
      args: [],
    );
  }

  /// `Код (inline)`
  String get markdown_inline_code {
    return Intl.message(
      'Код (inline)',
      name: 'markdown_inline_code',
      desc: '',
      args: [],
    );
  }

  /// `Курсив`
  String get markdown_italic {
    return Intl.message(
      'Курсив',
      name: 'markdown_italic',
      desc: '',
      args: [],
    );
  }

  /// `Нумерованный список`
  String get markdown_numbered_list {
    return Intl.message(
      'Нумерованный список',
      name: 'markdown_numbered_list',
      desc: '',
      args: [],
    );
  }

  /// `Цитата`
  String get markdown_quote {
    return Intl.message(
      'Цитата',
      name: 'markdown_quote',
      desc: '',
      args: [],
    );
  }

  /// `Подчеркнутый`
  String get markdown_underline {
    return Intl.message(
      'Подчеркнутый',
      name: 'markdown_underline',
      desc: '',
      args: [],
    );
  }

  /// `Мои`
  String get my {
    return Intl.message(
      'Мои',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `Мои персонажи`
  String get my_characters {
    return Intl.message(
      'Мои персонажи',
      name: 'my_characters',
      desc: '',
      args: [],
    );
  }

  /// `Имя`
  String get name {
    return Intl.message(
      'Имя',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Новый персонаж`
  String get new_character {
    return Intl.message(
      'Новый персонаж',
      name: 'new_character',
      desc: '',
      args: [],
    );
  }

  /// `Новый персонаж (из шаблона)`
  String get new_character_from_template {
    return Intl.message(
      'Новый персонаж (из шаблона)',
      name: 'new_character_from_template',
      desc: '',
      args: [],
    );
  }

  /// `Новая раса`
  String get new_race {
    return Intl.message(
      'Новая раса',
      name: 'new_race',
      desc: '',
      args: [],
    );
  }

  /// `Новый шаблон`
  String get new_template {
    return Intl.message(
      'Новый шаблон',
      name: 'new_template',
      desc: '',
      args: [],
    );
  }

  /// `Не добавлено ни одного изображение`
  String get no_additional_images {
    return Intl.message(
      'Не добавлено ни одного изображение',
      name: 'no_additional_images',
      desc: '',
      args: [],
    );
  }

  /// `Нет персонажей`
  String get no_characters {
    return Intl.message(
      'Нет персонажей',
      name: 'no_characters',
      desc: '',
      args: [],
    );
  }

  /// `Содержание отсутствует`
  String get no_content {
    return Intl.message(
      'Содержание отсутствует',
      name: 'no_content',
      desc: '',
      args: [],
    );
  }

  /// `Данные не найдены`
  String get no_data_found {
    return Intl.message(
      'Данные не найдены',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `Описание отсутствует`
  String get no_description {
    return Intl.message(
      'Описание отсутствует',
      name: 'no_description',
      desc: '',
      args: [],
    );
  }

  /// `Нет информации`
  String get no_information {
    return Intl.message(
      'Нет информации',
      name: 'no_information',
      desc: '',
      args: [],
    );
  }

  /// `Без расы`
  String get no_race {
    return Intl.message(
      'Без расы',
      name: 'no_race',
      desc: '',
      args: [],
    );
  }

  /// `Нет созданных рас`
  String get no_races_created {
    return Intl.message(
      'Нет созданных рас',
      name: 'no_races_created',
      desc: '',
      args: [],
    );
  }

  /// `Нет шаблонов`
  String get no_templates {
    return Intl.message(
      'Нет шаблонов',
      name: 'no_templates',
      desc: '',
      args: [],
    );
  }

  /// `Не выбрано`
  String get not_selected {
    return Intl.message(
      'Не выбрано',
      name: 'not_selected',
      desc: '',
      args: [],
    );
  }

  /// `Ничего не найдено по запросу`
  String get nothing_found {
    return Intl.message(
      'Ничего не найдено по запросу',
      name: 'nothing_found',
      desc: '',
      args: [],
    );
  }

  /// `Хорошо`
  String get ok {
    return Intl.message(
      'Хорошо',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Операция выполнена успешно`
  String get operationCompleted {
    return Intl.message(
      'Операция выполнена успешно',
      name: 'operationCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Оранжевый`
  String get orange {
    return Intl.message(
      'Оранжевый',
      name: 'orange',
      desc: '',
      args: [],
    );
  }

  /// `Прочее`
  String get other {
    return Intl.message(
      'Прочее',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `PDF успешно экспортирован`
  String get pdf_export_success {
    return Intl.message(
      'PDF успешно экспортирован',
      name: 'pdf_export_success',
      desc: '',
      args: [],
    );
  }

  /// `Характер`
  String get personality {
    return Intl.message(
      'Характер',
      name: 'personality',
      desc: '',
      args: [],
    );
  }

  /// `Розовый`
  String get pink {
    return Intl.message(
      'Розовый',
      name: 'pink',
      desc: '',
      args: [],
    );
  }

  /// `Посты`
  String get posts {
    return Intl.message(
      'Посты',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Фиолетовый`
  String get purple {
    return Intl.message(
      'Фиолетовый',
      name: 'purple',
      desc: '',
      args: [],
    );
  }

  /// `Раса`
  String get race {
    return Intl.message(
      'Раса',
      name: 'race',
      desc: '',
      args: [],
    );
  }

  /// `Раса скопирована в буфер`
  String get race_copied {
    return Intl.message(
      'Раса скопирована в буфер',
      name: 'race_copied',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить эту расу?`
  String get race_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить эту расу?',
      name: 'race_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Эта раса используется персонажами. Сначала измените их расу.`
  String get race_delete_error_content {
    return Intl.message(
      'Эта раса используется персонажами. Сначала измените их расу.',
      name: 'race_delete_error_content',
      desc: '',
      args: [],
    );
  }

  /// `Невозможно удалить расу`
  String get race_delete_error_title {
    return Intl.message(
      'Невозможно удалить расу',
      name: 'race_delete_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Удаление расы`
  String get race_delete_title {
    return Intl.message(
      'Удаление расы',
      name: 'race_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Раса удалена`
  String get race_deleted {
    return Intl.message(
      'Раса удалена',
      name: 'race_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Раса "{name}" успешно импортирована`
  String race_imported(Object name) {
    return Intl.message(
      'Раса "$name" успешно импортирована',
      name: 'race_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Управление расами`
  String get race_management {
    return Intl.message(
      'Управление расами',
      name: 'race_management',
      desc: '',
      args: [],
    );
  }

  /// `Название расы`
  String get race_name {
    return Intl.message(
      'Название расы',
      name: 'race_name',
      desc: '',
      args: [],
    );
  }

  /// `Файл расы {name}`
  String race_share_text(Object name) {
    return Intl.message(
      'Файл расы $name',
      name: 'race_share_text',
      desc: '',
      args: [name],
    );
  }

  /// `Расы`
  String get races {
    return Intl.message(
      'Расы',
      name: 'races',
      desc: '',
      args: [],
    );
  }

  /// `Красный`
  String get red {
    return Intl.message(
      'Красный',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `Референс`
  String get reference_image {
    return Intl.message(
      'Референс',
      name: 'reference_image',
      desc: '',
      args: [],
    );
  }

  /// `Связанные посты`
  String get related_notes {
    return Intl.message(
      'Связанные посты',
      name: 'related_notes',
      desc: '',
      args: [],
    );
  }

  /// `Заменить`
  String get replace {
    return Intl.message(
      'Заменить',
      name: 'replace',
      desc: '',
      args: [],
    );
  }

  /// `Обязательное поле`
  String get required_field_error {
    return Intl.message(
      'Обязательное поле',
      name: 'required_field_error',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить данные`
  String get restoreData {
    return Intl.message(
      'Восстановить данные',
      name: 'restoreData',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get save {
    return Intl.message(
      'Сохранить',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения`
  String get save_error {
    return Intl.message(
      'Ошибка сохранения',
      name: 'save_error',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить расу`
  String get save_race {
    return Intl.message(
      'Сохранить расу',
      name: 'save_race',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить шаблон`
  String get save_template {
    return Intl.message(
      'Сохранить шаблон',
      name: 'save_template',
      desc: '',
      args: [],
    );
  }

  /// `Поиск`
  String get search {
    return Intl.message(
      'Поиск',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Поиск персонажей...`
  String get search_characters {
    return Intl.message(
      'Поиск персонажей...',
      name: 'search_characters',
      desc: '',
      args: [],
    );
  }

  /// `Поиск по персонажам, расам, заметкам и шаблонам...`
  String get search_hint {
    return Intl.message(
      'Поиск по персонажам, расам, заметкам и шаблонам...',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Поиск рас...`
  String get search_race_hint {
    return Intl.message(
      'Поиск рас...',
      name: 'search_race_hint',
      desc: '',
      args: [],
    );
  }

  /// `Выбрано`
  String get select {
    return Intl.message(
      'Выбрано',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Выберите персонажа`
  String get select_character {
    return Intl.message(
      'Выберите персонажа',
      name: 'select_character',
      desc: '',
      args: [],
    );
  }

  /// `Выберите пол`
  String get select_gender_error {
    return Intl.message(
      'Выберите пол',
      name: 'select_gender_error',
      desc: '',
      args: [],
    );
  }

  /// `Выберите расу`
  String get select_race {
    return Intl.message(
      'Выберите расу',
      name: 'select_race',
      desc: '',
      args: [],
    );
  }

  /// `Выберите расу`
  String get select_race_error {
    return Intl.message(
      'Выберите расу',
      name: 'select_race_error',
      desc: '',
      args: [],
    );
  }

  /// `Выберите шаблон`
  String get select_template {
    return Intl.message(
      'Выберите шаблон',
      name: 'select_template',
      desc: '',
      args: [],
    );
  }

  /// `Выберите файл шаблона`
  String get select_template_file {
    return Intl.message(
      'Выберите файл шаблона',
      name: 'select_template_file',
      desc: '',
      args: [],
    );
  }

  /// `Настройки`
  String get settings {
    return Intl.message(
      'Настройки',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Поделиться`
  String get share_character {
    return Intl.message(
      'Поделиться',
      name: 'share_character',
      desc: '',
      args: [],
    );
  }

  /// `Короткое имя`
  String get short_name {
    return Intl.message(
      'Короткое имя',
      name: 'short_name',
      desc: '',
      args: [],
    );
  }

  /// `Стандартные поля`
  String get standard_fields {
    return Intl.message(
      'Стандартные поля',
      name: 'standard_fields',
      desc: '',
      args: [],
    );
  }

  /// `Системная`
  String get system {
    return Intl.message(
      'Системная',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон`
  String get template {
    return Intl.message(
      'Шаблон',
      name: 'template',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить этот шаблон?`
  String get template_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить этот шаблон?',
      name: 'template_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Удаление шаблона`
  String get template_delete_title {
    return Intl.message(
      'Удаление шаблона',
      name: 'template_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон удален`
  String get template_deleted {
    return Intl.message(
      'Шаблон удален',
      name: 'template_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон уже существует`
  String get template_exists {
    return Intl.message(
      'Шаблон уже существует',
      name: 'template_exists',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон "{name}" успешно экспортирован`
  String template_exported(Object name) {
    return Intl.message(
      'Шаблон "$name" успешно экспортирован',
      name: 'template_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Шаблон "{name}" успешно импортирован`
  String template_imported(Object name) {
    return Intl.message(
      'Шаблон "$name" успешно импортирован',
      name: 'template_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Название шаблона`
  String get template_name_label {
    return Intl.message(
      'Название шаблона',
      name: 'template_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон "{name}" уже существует. Заменить его?`
  String template_replace_confirm(Object name) {
    return Intl.message(
      'Шаблон "$name" уже существует. Заменить его?',
      name: 'template_replace_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `Шаблоны`
  String get templates {
    return Intl.message(
      'Шаблоны',
      name: 'templates',
      desc: '',
      args: [],
    );
  }

  /// `Шаблоны не найдены`
  String get templates_not_found {
    return Intl.message(
      'Шаблоны не найдены',
      name: 'templates_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Бирюзовый`
  String get teal {
    return Intl.message(
      'Бирюзовый',
      name: 'teal',
      desc: '',
      args: [],
    );
  }

  /// `Тема`
  String get theme {
    return Intl.message(
      'Тема',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `У вас есть несохраненные изменения. Хотите сохранить перед выходом?`
  String get unsaved_changes_content {
    return Intl.message(
      'У вас есть несохраненные изменения. Хотите сохранить перед выходом?',
      name: 'unsaved_changes_content',
      desc: '',
      args: [],
    );
  }

  /// `Несохраненные изменения`
  String get unsaved_changes_title {
    return Intl.message(
      'Несохраненные изменения',
      name: 'unsaved_changes_title',
      desc: '',
      args: [],
    );
  }

  /// `Версия`
  String get version {
    return Intl.message(
      'Версия',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Недоступно для веба`
  String get web_not_supported {
    return Intl.message(
      'Недоступно для веба',
      name: 'web_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `лет`
  String get years {
    return Intl.message(
      'лет',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Молодые`
  String get young {
    return Intl.message(
      'Молодые',
      name: 'young',
      desc: '',
      args: [],
    );
  }

  /// `А-Я`
  String get a_to_z {
    return Intl.message(
      'А-Я',
      name: 'a_to_z',
      desc: '',
      args: [],
    );
  }

  /// `Я-А`
  String get z_to_a {
    return Intl.message(
      'Я-А',
      name: 'z_to_a',
      desc: '',
      args: [],
    );
  }

  /// `Доп. изображения`
  String get additional_images {
    return Intl.message(
      'Доп. изображения',
      name: 'additional_images',
      desc: '',
      args: [],
    );
  }

  /// `Предыстория`
  String get backstory {
    return Intl.message(
      'Предыстория',
      name: 'backstory',
      desc: '',
      args: [],
    );
  }

  /// `Создать резервную копию`
  String get creatingBackup {
    return Intl.message(
      'Создать резервную копию',
      name: 'creatingBackup',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить из резервной копии`
  String get restoringBackup {
    return Intl.message(
      'Восстановить из резервной копии',
      name: 'restoringBackup',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка...`
  String get processing {
    return Intl.message(
      'Загрузка...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Варианты резервного копирования`
  String get backup_options {
    return Intl.message(
      'Варианты резервного копирования',
      name: 'backup_options',
      desc: '',
      args: [],
    );
  }

  /// `Варианты восстановления`
  String get restore_options {
    return Intl.message(
      'Варианты восстановления',
      name: 'restore_options',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить в облако`
  String get backup_to_cloud {
    return Intl.message(
      'Сохранить в облако',
      name: 'backup_to_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить в файл`
  String get backup_to_file {
    return Intl.message(
      'Сохранить в файл',
      name: 'backup_to_file',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить из облака`
  String get restore_from_cloud {
    return Intl.message(
      'Восстановить из облака',
      name: 'restore_from_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить из файла`
  String get restore_from_file {
    return Intl.message(
      'Восстановить из файла',
      name: 'restore_from_file',
      desc: '',
      args: [],
    );
  }

  /// `Резервная копия успешно создана`
  String get local_backup_success {
    return Intl.message(
      'Резервная копия успешно создана',
      name: 'local_backup_success',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка создания резервной копии`
  String get local_backup_error {
    return Intl.message(
      'Ошибка создания резервной копии',
      name: 'local_backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Восстановление произошло успешно`
  String get local_restore_success {
    return Intl.message(
      'Восстановление произошло успешно',
      name: 'local_restore_success',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка восстановления`
  String get local_restore_error {
    return Intl.message(
      'Ошибка восстановления',
      name: 'local_restore_error',
      desc: '',
      args: [],
    );
  }

  /// `Вот моя резервная копия CharacterBook`
  String get share_backup_file {
    return Intl.message(
      'Вот моя резервная копия CharacterBook',
      name: 'share_backup_file',
      desc: '',
      args: [],
    );
  }

  /// `Выбранный файл пуст`
  String get empty_file_error {
    return Intl.message(
      'Выбранный файл пуст',
      name: 'empty_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Импорт`
  String get import {
    return Intl.message(
      'Импорт',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Импортирование расы`
  String get import_race {
    return Intl.message(
      'Импортирование расы',
      name: 'import_race',
      desc: '',
      args: [],
    );
  }

  /// `Обрезка аватарки`
  String get avatar_crop_title {
    return Intl.message(
      'Обрезка аватарки',
      name: 'avatar_crop_title',
      desc: '',
      args: [],
    );
  }

  /// `Сохранение обрезки`
  String get avatar_crop_save {
    return Intl.message(
      'Сохранение обрезки',
      name: 'avatar_crop_save',
      desc: '',
      args: [],
    );
  }

  /// `Лицензия`
  String get licenses {
    return Intl.message(
      'Лицензия',
      name: 'licenses',
      desc: '',
      args: [],
    );
  }

  /// `Flutter лицензия`
  String get flutterLicense {
    return Intl.message(
      'Flutter лицензия',
      name: 'flutterLicense',
      desc: '',
      args: [],
    );
  }

  /// `CharacterBook лицензия (GNU GPL v3.0)`
  String get characterbookLicense {
    return Intl.message(
      'CharacterBook лицензия (GNU GPL v3.0)',
      name: 'characterbookLicense',
      desc: '',
      args: [],
    );
  }

  /// `Используемые библиотеки`
  String get usedLibraries {
    return Intl.message(
      'Используемые библиотеки',
      name: 'usedLibraries',
      desc: '',
      args: [],
    );
  }

  /// `Папки`
  String get folders {
    return Intl.message(
      'Папки',
      name: 'folders',
      desc: '',
      args: [],
    );
  }

  /// `Папка`
  String get folder {
    return Intl.message(
      'Папка',
      name: 'folder',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать папку`
  String get select_folder {
    return Intl.message(
      'Выбрать папку',
      name: 'select_folder',
      desc: '',
      args: [],
    );
  }

  /// `Нет выбранной папки`
  String get no_folder_selected {
    return Intl.message(
      'Нет выбранной папки',
      name: 'no_folder_selected',
      desc: '',
      args: [],
    );
  }

  /// `Пусто`
  String get none {
    return Intl.message(
      'Пусто',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Имя папки`
  String get folder_name {
    return Intl.message(
      'Имя папки',
      name: 'folder_name',
      desc: '',
      args: [],
    );
  }

  /// `Новая папка`
  String get new_folder {
    return Intl.message(
      'Новая папка',
      name: 'new_folder',
      desc: '',
      args: [],
    );
  }

  /// `Редактирование папки`
  String get edit_folder {
    return Intl.message(
      'Редактирование папки',
      name: 'edit_folder',
      desc: '',
      args: [],
    );
  }

  /// `Цвет папки`
  String get folder_color {
    return Intl.message(
      'Цвет папки',
      name: 'folder_color',
      desc: '',
      args: [],
    );
  }

  /// `Теги`
  String get tags {
    return Intl.message(
      'Теги',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Добавить тег`
  String get add_tag {
    return Intl.message(
      'Добавить тег',
      name: 'add_tag',
      desc: '',
      args: [],
    );
  }

  /// `элементов`
  String get items {
    return Intl.message(
      'элементов',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Фиолетовый`
  String get color_purple {
    return Intl.message(
      'Фиолетовый',
      name: 'color_purple',
      desc: 'Название фиолетового цвета',
      args: [],
    );
  }

  /// `Бирюзовый`
  String get color_teal {
    return Intl.message(
      'Бирюзовый',
      name: 'color_teal',
      desc: 'Название бирюзового цвета',
      args: [],
    );
  }

  /// `Красный`
  String get color_red {
    return Intl.message(
      'Красный',
      name: 'color_red',
      desc: 'Название красного цвета',
      args: [],
    );
  }

  /// `Розовый`
  String get color_pink {
    return Intl.message(
      'Розовый',
      name: 'color_pink',
      desc: 'Название розового цвета',
      args: [],
    );
  }

  /// `Тёмный`
  String get color_dark {
    return Intl.message(
      'Тёмный',
      name: 'color_dark',
      desc: 'Название тёмного цвета',
      args: [],
    );
  }

  /// `Зелёный`
  String get color_green {
    return Intl.message(
      'Зелёный',
      name: 'color_green',
      desc: 'Название зелёного цвета',
      args: [],
    );
  }

  /// `Синий`
  String get color_blue {
    return Intl.message(
      'Синий',
      name: 'color_blue',
      desc: 'Название синего цвета',
      args: [],
    );
  }

  /// `Коричневый`
  String get color_brown {
    return Intl.message(
      'Коричневый',
      name: 'color_brown',
      desc: 'Название коричневого цвета',
      args: [],
    );
  }

  /// `Оранжевый`
  String get color_orange {
    return Intl.message(
      'Оранжевый',
      name: 'color_orange',
      desc: 'Название оранжевого цвета',
      args: [],
    );
  }

  /// `Серый`
  String get color_grey {
    return Intl.message(
      'Серый',
      name: 'color_grey',
      desc: 'Название серого цвета',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
