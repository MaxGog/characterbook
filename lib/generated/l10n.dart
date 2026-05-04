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

  /// `CharacterBook`
  String get app_name {
    return Intl.message(
      'CharacterBook',
      name: 'app_name',
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

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
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

  /// `Удалить`
  String get delete {
    return Intl.message(
      'Удалить',
      name: 'delete',
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

  /// `Ошибка`
  String get error {
    return Intl.message(
      'Ошибка',
      name: 'error',
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

  /// `Сохранить`
  String get save {
    return Intl.message(
      'Сохранить',
      name: 'save',
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

  /// `Выбрано`
  String get select {
    return Intl.message(
      'Выбрано',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Параметры`
  String get settings {
    return Intl.message(
      'Параметры',
      name: 'settings',
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

  /// `Копировать`
  String get copy {
    return Intl.message(
      'Копировать',
      name: 'copy',
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

  /// `Экспорт`
  String get export {
    return Intl.message(
      'Экспорт',
      name: 'export',
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

  /// `Загрузка...`
  String get processing {
    return Intl.message(
      'Загрузка...',
      name: 'processing',
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

  /// `Скопировано в буфер обмена`
  String get copied_to_clipboard {
    return Intl.message(
      'Скопировано в буфер обмена',
      name: 'copied_to_clipboard',
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

  /// `Не выбрано`
  String get not_selected {
    return Intl.message(
      'Не выбрано',
      name: 'not_selected',
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

  /// `Все`
  String get all {
    return Intl.message(
      'Все',
      name: 'all',
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

  /// `Поделиться`
  String get share {
    return Intl.message(
      'Поделиться',
      name: 'share',
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

  /// `Персонажи`
  String get characters {
    return Intl.message(
      'Персонажи',
      name: 'characters',
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

  /// `Новый персонаж`
  String get new_character {
    return Intl.message(
      'Новый персонаж',
      name: 'new_character',
      desc: '',
      args: [],
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

  /// `Редактировать персонажа`
  String get edit_character {
    return Intl.message(
      'Редактировать персонажа',
      name: 'edit_character',
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

  /// `Скопировать персонажа`
  String get copy_character {
    return Intl.message(
      'Скопировать персонажа',
      name: 'copy_character',
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

  /// `Выберите персонажа`
  String get select_character {
    return Intl.message(
      'Выберите персонажа',
      name: 'select_character',
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

  /// `Расы`
  String get races {
    return Intl.message(
      'Расы',
      name: 'races',
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

  /// `Управление расами`
  String get race_management {
    return Intl.message(
      'Управление расами',
      name: 'race_management',
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

  /// `Импорт расы`
  String get import_race {
    return Intl.message(
      'Импорт расы',
      name: 'import_race',
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

  /// `Шаблоны`
  String get templates {
    return Intl.message(
      'Шаблоны',
      name: 'templates',
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

  /// `Редактирование шаблона`
  String get edit_template {
    return Intl.message(
      'Редактирование шаблона',
      name: 'edit_template',
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

  /// `Выберите шаблон`
  String get select_template {
    return Intl.message(
      'Выберите шаблон',
      name: 'select_template',
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

  /// `Папки`
  String get folders {
    return Intl.message(
      'Папки',
      name: 'folders',
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

  /// `Имя папки`
  String get folder_name {
    return Intl.message(
      'Имя папки',
      name: 'folder_name',
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

  /// `Выбрать папку`
  String get select_folder {
    return Intl.message(
      'Выбрать папку',
      name: 'select_folder',
      desc: '',
      args: [],
    );
  }

  /// `Заметки`
  String get posts {
    return Intl.message(
      'Заметки',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Связанные заметки`
  String get related_notes {
    return Intl.message(
      'Связанные заметки',
      name: 'related_notes',
      desc: '',
      args: [],
    );
  }

  /// `Начните писать здесь...`
  String get start_writing {
    return Intl.message(
      'Начните писать здесь...',
      name: 'start_writing',
      desc: '',
      args: [],
    );
  }

  /// `Выбранные персонажи`
  String get choose_character {
    return Intl.message(
      'Выбранные персонажи',
      name: 'choose_character',
      desc: '',
      args: [],
    );
  }

  /// `Название`
  String get name {
    return Intl.message(
      'Название',
      name: 'name',
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

  /// `Возраст`
  String get age {
    return Intl.message(
      'Возраст',
      name: 'age',
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

  /// `Пол`
  String get gender {
    return Intl.message(
      'Пол',
      name: 'gender',
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

  /// `Женский`
  String get female {
    return Intl.message(
      'Женский',
      name: 'female',
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

  /// `Описание`
  String get description {
    return Intl.message(
      'Описание',
      name: 'description',
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

  /// `Характер`
  String get personality {
    return Intl.message(
      'Характер',
      name: 'personality',
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

  /// `Способности`
  String get abilities {
    return Intl.message(
      'Способности',
      name: 'abilities',
      desc: '',
      args: [],
    );
  }

  /// `Другое`
  String get other {
    return Intl.message(
      'Другое',
      name: 'other',
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

  /// `История`
  String get backstory {
    return Intl.message(
      'История',
      name: 'backstory',
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

  /// `Изображение`
  String get image {
    return Intl.message(
      'Изображение',
      name: 'image',
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

  /// `Референс изображение`
  String get reference_image {
    return Intl.message(
      'Референс изображение',
      name: 'reference_image',
      desc: '',
      args: [],
    );
  }

  /// `Дополнительные изображения`
  String get additional_images {
    return Intl.message(
      'Дополнительные изображения',
      name: 'additional_images',
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

  /// `Аватар персонажа`
  String get character_avatar {
    return Intl.message(
      'Аватар персонажа',
      name: 'character_avatar',
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

  /// `Галерея персонажа`
  String get character_gallery {
    return Intl.message(
      'Галерея персонажа',
      name: 'character_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Обрезка аватара`
  String get avatar_crop_title {
    return Intl.message(
      'Обрезка аватара',
      name: 'avatar_crop_title',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить обрезку`
  String get avatar_crop_save {
    return Intl.message(
      'Сохранить обрезку',
      name: 'avatar_crop_save',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось получить размер виджета`
  String get avatar_crop_widget_size_error {
    return Intl.message(
      'Не удалось получить размер виджета',
      name: 'avatar_crop_widget_size_error',
      desc: '',
      args: [],
    );
  }

  /// `Некорректные координаты обрезки`
  String get avatar_crop_coordinates_error {
    return Intl.message(
      'Некорректные координаты обрезки',
      name: 'avatar_crop_coordinates_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка при обрезке: {error}`
  String avatar_crop_error(String error) {
    return Intl.message(
      'Ошибка при обрезке: $error',
      name: 'avatar_crop_error',
      desc: '',
      args: [error],
    );
  }

  /// `Ошибка: {error}`
  String avatar_picker_error(String error) {
    return Intl.message(
      'Ошибка: $error',
      name: 'avatar_picker_error',
      desc: '',
      args: [error],
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

  /// `Стандартные поля`
  String get standard_fields {
    return Intl.message(
      'Стандартные поля',
      name: 'standard_fields',
      desc: '',
      args: [],
    );
  }

  /// `Дополнительные поля`
  String get custom_fields {
    return Intl.message(
      'Дополнительные поля',
      name: 'custom_fields',
      desc: '',
      args: [],
    );
  }

  /// `Пользовательские поля`
  String get custom_fields_editor_title {
    return Intl.message(
      'Пользовательские поля',
      name: 'custom_fields_editor_title',
      desc: '',
      args: [],
    );
  }

  /// `Добавить поле`
  String get add_field {
    return Intl.message(
      'Добавить поле',
      name: 'add_field',
      desc: '',
      args: [],
    );
  }

  /// `Нет пользовательских полей`
  String get no_custom_fields {
    return Intl.message(
      'Нет пользовательских полей',
      name: 'no_custom_fields',
      desc: '',
      args: [],
    );
  }

  /// `Название поля`
  String get field_name {
    return Intl.message(
      'Название поля',
      name: 'field_name',
      desc: '',
      args: [],
    );
  }

  /// `Введите название поля`
  String get field_name_hint {
    return Intl.message(
      'Введите название поля',
      name: 'field_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Значение поля`
  String get field_value {
    return Intl.message(
      'Значение поля',
      name: 'field_value',
      desc: '',
      args: [],
    );
  }

  /// `Введите значение поля`
  String get field_value_hint {
    return Intl.message(
      'Введите значение поля',
      name: 'field_value_hint',
      desc: '',
      args: [],
    );
  }

  /// `стандартных`
  String get standard {
    return Intl.message(
      'стандартных',
      name: 'standard',
      desc: '',
      args: [],
    );
  }

  /// `пользовательских`
  String get custom {
    return Intl.message(
      'пользовательских',
      name: 'custom',
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

  /// `еще {count}`
  String more_fields(Object count) {
    return Intl.message(
      'еще $count',
      name: 'more_fields',
      desc: '',
      args: [count],
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

  /// `Молодые`
  String get young {
    return Intl.message(
      'Молодые',
      name: 'young',
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

  /// `Пожилые`
  String get elderly {
    return Intl.message(
      'Пожилые',
      name: 'elderly',
      desc: '',
      args: [],
    );
  }

  /// `Фиолетовый`
  String get color_purple {
    return Intl.message(
      'Фиолетовый',
      name: 'color_purple',
      desc: '',
      args: [],
    );
  }

  /// `Бирюзовый`
  String get color_teal {
    return Intl.message(
      'Бирюзовый',
      name: 'color_teal',
      desc: '',
      args: [],
    );
  }

  /// `Красный`
  String get color_red {
    return Intl.message(
      'Красный',
      name: 'color_red',
      desc: '',
      args: [],
    );
  }

  /// `Розовый`
  String get color_pink {
    return Intl.message(
      'Розовый',
      name: 'color_pink',
      desc: '',
      args: [],
    );
  }

  /// `Тёмный`
  String get color_dark {
    return Intl.message(
      'Тёмный',
      name: 'color_dark',
      desc: '',
      args: [],
    );
  }

  /// `Зелёный`
  String get color_green {
    return Intl.message(
      'Зелёный',
      name: 'color_green',
      desc: '',
      args: [],
    );
  }

  /// `Синий`
  String get color_blue {
    return Intl.message(
      'Синий',
      name: 'color_blue',
      desc: '',
      args: [],
    );
  }

  /// `Коричневый`
  String get color_brown {
    return Intl.message(
      'Коричневый',
      name: 'color_brown',
      desc: '',
      args: [],
    );
  }

  /// `Оранжевый`
  String get color_orange {
    return Intl.message(
      'Оранжевый',
      name: 'color_orange',
      desc: '',
      args: [],
    );
  }

  /// `Серый`
  String get color_grey {
    return Intl.message(
      'Серый',
      name: 'color_grey',
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

  /// `Цветовая схема`
  String get colorScheme {
    return Intl.message(
      'Цветовая схема',
      name: 'colorScheme',
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

  /// `Настроить тему`
  String get customize_theme {
    return Intl.message(
      'Настроить тему',
      name: 'customize_theme',
      desc: '',
      args: [],
    );
  }

  /// `Системные цвета`
  String get use_system_colors {
    return Intl.message(
      'Системные цвета',
      name: 'use_system_colors',
      desc: '',
      args: [],
    );
  }

  /// `Доступно только на Android 12+`
  String get use_system_colors_unavailable {
    return Intl.message(
      'Доступно только на Android 12+',
      name: 'use_system_colors_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Свой цвет`
  String get custom_color {
    return Intl.message(
      'Свой цвет',
      name: 'custom_color',
      desc: '',
      args: [],
    );
  }

  /// `Material You`
  String get material_you {
    return Intl.message(
      'Material You',
      name: 'material_you',
      desc: '',
      args: [],
    );
  }

  /// `Используются системные цвета обоев`
  String get material_you_status_system {
    return Intl.message(
      'Используются системные цвета обоев',
      name: 'material_you_status_system',
      desc: '',
      args: [],
    );
  }

  /// `Используются сгенерированные цвета Material You`
  String get material_you_status_generated {
    return Intl.message(
      'Используются сгенерированные цвета Material You',
      name: 'material_you_status_generated',
      desc: '',
      args: [],
    );
  }

  /// `Стиль палитры`
  String get color_style {
    return Intl.message(
      'Стиль палитры',
      name: 'color_style',
      desc: '',
      args: [],
    );
  }

  /// `Спецификация`
  String get color_spec {
    return Intl.message(
      'Спецификация',
      name: 'color_spec',
      desc: '',
      args: [],
    );
  }

  /// `2021`
  String get color_spec_2021 {
    return Intl.message(
      '2021',
      name: 'color_spec_2021',
      desc: '',
      args: [],
    );
  }

  /// `2025`
  String get color_spec_2025 {
    return Intl.message(
      '2025',
      name: 'color_spec_2025',
      desc: '',
      args: [],
    );
  }

  /// `Контраст`
  String get contrast {
    return Intl.message(
      'Контраст',
      name: 'contrast',
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

  /// `Светлая`
  String get light {
    return Intl.message(
      'Светлая',
      name: 'light',
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

  /// `Язык`
  String get language {
    return Intl.message(
      'Язык',
      name: 'language',
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

  /// `Главная`
  String get home {
    return Intl.message(
      'Главная',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Инструменты D&D`
  String get dnd_tools {
    return Intl.message(
      'Инструменты D&D',
      name: 'dnd_tools',
      desc: '',
      args: [],
    );
  }

  /// `Дополнительные настройки`
  String get more_options {
    return Intl.message(
      'Дополнительные настройки',
      name: 'more_options',
      desc: '',
      args: [],
    );
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

  /// `Благодарности`
  String get acknowledgements {
    return Intl.message(
      'Благодарности',
      name: 'acknowledgements',
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

  /// `GitHub репозиторий`
  String get githubRepo {
    return Intl.message(
      'GitHub репозиторий',
      name: 'githubRepo',
      desc: '',
      args: [],
    );
  }

  /// `Лицензии`
  String get licenses {
    return Intl.message(
      'Лицензии',
      name: 'licenses',
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

  /// `Лицензия Flutter`
  String get flutterLicense {
    return Intl.message(
      'Лицензия Flutter',
      name: 'flutterLicense',
      desc: '',
      args: [],
    );
  }

  /// `Лицензия CharacterBook (GNU GPL v3.0)`
  String get characterbookLicense {
    return Intl.message(
      'Лицензия CharacterBook (GNU GPL v3.0)',
      name: 'characterbookLicense',
      desc: '',
      args: [],
    );
  }

  /// `Настройки PDF экспорта`
  String get export_pdf_settings {
    return Intl.message(
      'Настройки PDF экспорта',
      name: 'export_pdf_settings',
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

  /// `Создать резервную копию`
  String get createBackup {
    return Intl.message(
      'Создать резервную копию',
      name: 'createBackup',
      desc: '',
      args: [],
    );
  }

  /// `Создание резервной копии`
  String get creatingBackup {
    return Intl.message(
      'Создание резервной копии',
      name: 'creatingBackup',
      desc: '',
      args: [],
    );
  }

  /// `Восстановление из резервной копии`
  String get restoringBackup {
    return Intl.message(
      'Восстановление из резервной копии',
      name: 'restoringBackup',
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

  /// `Файл готов к отправке`
  String get file_ready {
    return Intl.message(
      'Файл готов к отправке',
      name: 'file_ready',
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

  /// `Ошибка сохранения`
  String get save_error {
    return Intl.message(
      'Ошибка сохранения',
      name: 'save_error',
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

  /// `Ошибка копирования`
  String get copy_error {
    return Intl.message(
      'Ошибка копирования',
      name: 'copy_error',
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

  /// `Ошибка импорта: {error}`
  String import_error(Object error) {
    return Intl.message(
      'Ошибка импорта: $error',
      name: 'import_error',
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

  /// `Ошибка выбора файла`
  String get file_pick_error {
    return Intl.message(
      'Ошибка выбора файла',
      name: 'file_pick_error',
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

  /// `Недоступно для веба`
  String get web_not_supported {
    return Intl.message(
      'Недоступно для веба',
      name: 'web_not_supported',
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
  String get select_race_error {
    return Intl.message(
      'Выберите расу',
      name: 'select_race_error',
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

  /// `Ошибка при создании резервной копии`
  String get cloud_backup_error {
    return Intl.message(
      'Ошибка при создании резервной копии',
      name: 'cloud_backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Резервная копия успешно создана`
  String get cloud_backup_success {
    return Intl.message(
      'Резервная копия успешно создана',
      name: 'cloud_backup_success',
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

  /// `Успешно восстановлено:\n{charactersCount} персонажей\n{notesCount} заметок\n{racesCount} рас\n{templatesCount} шаблонов\n{foldersCount} папок`
  String cloud_restore_success(Object charactersCount, Object notesCount,
      Object racesCount, Object templatesCount, Object foldersCount) {
    return Intl.message(
      'Успешно восстановлено:\n$charactersCount персонажей\n$notesCount заметок\n$racesCount рас\n$templatesCount шаблонов\n$foldersCount папок',
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

  /// `Данные успешно восстановлены`
  String get local_restore_success {
    return Intl.message(
      'Данные успешно восстановлены',
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

  /// `Персонаж создан из шаблона "{name}"`
  String character_created_from_template(Object name) {
    return Intl.message(
      'Персонаж создан из шаблона "$name"',
      name: 'character_created_from_template',
      desc: '',
      args: [name],
    );
  }

  /// `Персонаж "{name}" успешно экспортирован в PDF`
  String character_exported(Object name) {
    return Intl.message(
      'Персонаж "$name" успешно экспортирован в PDF',
      name: 'character_exported',
      desc: '',
      args: [name],
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

  /// `Персонаж удален`
  String get character_deleted {
    return Intl.message(
      'Персонаж удален',
      name: 'character_deleted',
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

  /// `Раса удалена`
  String get race_deleted {
    return Intl.message(
      'Раса удалена',
      name: 'race_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Раса скопирована в буфер обмена`
  String get race_copied {
    return Intl.message(
      'Раса скопирована в буфер обмена',
      name: 'race_copied',
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

  /// `Шаблон удален`
  String get template_deleted {
    return Intl.message(
      'Шаблон удален',
      name: 'template_deleted',
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

  /// `Несохранённые изменения`
  String get unsaved_changes_title {
    return Intl.message(
      'Несохранённые изменения',
      name: 'unsaved_changes_title',
      desc: '',
      args: [],
    );
  }

  /// `У вас есть несохранённые изменения. Хотите сохранить перед выходом?`
  String get unsaved_changes_content {
    return Intl.message(
      'У вас есть несохранённые изменения. Хотите сохранить перед выходом?',
      name: 'unsaved_changes_content',
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

  /// `Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить.`
  String get character_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить этого персонажа? Это действие нельзя отменить.',
      name: 'character_delete_confirm',
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

  /// `Вы уверены, что хотите удалить эту расу?`
  String get race_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить эту расу?',
      name: 'race_delete_confirm',
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

  /// `Эта раса используется персонажами. Сначала измените их расу.`
  String get race_delete_error_content {
    return Intl.message(
      'Эта раса используется персонажами. Сначала измените их расу.',
      name: 'race_delete_error_content',
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

  /// `Вы уверены, что хотите удалить этот шаблон?`
  String get template_delete_confirm {
    return Intl.message(
      'Вы уверены, что хотите удалить этот шаблон?',
      name: 'template_delete_confirm',
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

  /// `Не сохранять`
  String get discard_changes {
    return Intl.message(
      'Не сохранять',
      name: 'discard_changes',
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

  /// `Данные не найдены`
  String get no_data_found {
    return Intl.message(
      'Данные не найдены',
      name: 'no_data_found',
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

  /// `Нет персонажей`
  String get no_characters {
    return Intl.message(
      'Нет персонажей',
      name: 'no_characters',
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

  /// `Содержание отсутствует`
  String get no_content {
    return Intl.message(
      'Содержание отсутствует',
      name: 'no_content',
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

  /// `Раса не выбрана`
  String get no_race {
    return Intl.message(
      'Раса не выбрана',
      name: 'no_race',
      desc: '',
      args: [],
    );
  }

  /// `Не добавлено ни одного изображения`
  String get no_additional_images {
    return Intl.message(
      'Не добавлено ни одного изображения',
      name: 'no_additional_images',
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

  /// `Пока ничего нет`
  String get no_content_home {
    return Intl.message(
      'Пока ничего нет',
      name: 'no_content_home',
      desc: '',
      args: [],
    );
  }

  /// `Создайте первого персонажа или расу`
  String get create_first_content {
    return Intl.message(
      'Создайте первого персонажа или расу',
      name: 'create_first_content',
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

  /// `Поиск рас...`
  String get search_race_hint {
    return Intl.message(
      'Поиск рас...',
      name: 'search_race_hint',
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

  /// `Поиск персонажей и рас...`
  String get search_home {
    return Intl.message(
      'Поиск персонажей и рас...',
      name: 'search_home',
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

  /// `Основная информация`
  String get basic_info {
    return Intl.message(
      'Основная информация',
      name: 'basic_info',
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

  /// `По количеству полей (по возрастанию)`
  String get fields_asc {
    return Intl.message(
      'По количеству полей (по возрастанию)',
      name: 'fields_asc',
      desc: '',
      args: [],
    );
  }

  /// `По количеству полей (по убыванию)`
  String get fields_desc {
    return Intl.message(
      'По количеству полей (по убыванию)',
      name: 'fields_desc',
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

  /// `{years} лет назад`
  String years_ago(Object years) {
    return Intl.message(
      '$years лет назад',
      name: 'years_ago',
      desc: '',
      args: [years],
    );
  }

  /// `{months} месяцев назад`
  String months_ago(Object months) {
    return Intl.message(
      '$months месяцев назад',
      name: 'months_ago',
      desc: '',
      args: [months],
    );
  }

  /// `{days} дней назад`
  String days_ago(Object days) {
    return Intl.message(
      '$days дней назад',
      name: 'days_ago',
      desc: '',
      args: [days],
    );
  }

  /// `{hours} часов назад`
  String hours_ago(Object hours) {
    return Intl.message(
      '$hours часов назад',
      name: 'hours_ago',
      desc: '',
      args: [hours],
    );
  }

  /// `Только что`
  String get just_now {
    return Intl.message(
      'Только что',
      name: 'just_now',
      desc: '',
      args: [],
    );
  }

  /// `Вид сеткой`
  String get grid_view {
    return Intl.message(
      'Вид сеткой',
      name: 'grid_view',
      desc: '',
      args: [],
    );
  }

  /// `Вид списком`
  String get list_view {
    return Intl.message(
      'Вид списком',
      name: 'list_view',
      desc: '',
      args: [],
    );
  }

  /// `Подробный`
  String get detailed {
    return Intl.message(
      'Подробный',
      name: 'detailed',
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

  /// `Из шаблона`
  String get from_template {
    return Intl.message(
      'Из шаблона',
      name: 'from_template',
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

  /// `Сохранить шаблон`
  String get save_template {
    return Intl.message(
      'Сохранить шаблон',
      name: 'save_template',
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

  /// `Выберите файл шаблона`
  String get select_template_file {
    return Intl.message(
      'Выберите файл шаблона',
      name: 'select_template_file',
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

  /// `Файл персонажа {name}`
  String character_share_text(Object name) {
    return Intl.message(
      'Файл персонажа $name',
      name: 'character_share_text',
      desc: '',
      args: [name],
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

  /// `Жирный`
  String get markdown_bold {
    return Intl.message(
      'Жирный',
      name: 'markdown_bold',
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

  /// `Подчёркнутый`
  String get markdown_underline {
    return Intl.message(
      'Подчёркнутый',
      name: 'markdown_underline',
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

  /// `Код (в строке)`
  String get markdown_inline_code {
    return Intl.message(
      'Код (в строке)',
      name: 'markdown_inline_code',
      desc: '',
      args: [],
    );
  }

  /// `Ваша коллекция персонажей и рас`
  String get home_subtitle {
    return Intl.message(
      'Ваша коллекция персонажей и рас',
      name: 'home_subtitle',
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

  /// `Шаблоны не найдены`
  String get templates_not_found {
    return Intl.message(
      'Шаблоны не найдены',
      name: 'templates_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки связанных заметок`
  String get error_loading_notes {
    return Intl.message(
      'Ошибка загрузки связанных заметок',
      name: 'error_loading_notes',
      desc: '',
      args: [],
    );
  }

  /// `Генератор случайных чисел`
  String get randomNumberGenerator {
    return Intl.message(
      'Генератор случайных чисел',
      name: 'randomNumberGenerator',
      desc: '',
      args: [],
    );
  }

  /// `ВЫБЕРИТЕ ДИАПАЗОН`
  String get selectRange {
    return Intl.message(
      'ВЫБЕРИТЕ ДИАПАЗОН',
      name: 'selectRange',
      desc: '',
      args: [],
    );
  }

  /// `От`
  String get from {
    return Intl.message(
      'От',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `До`
  String get to {
    return Intl.message(
      'До',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Сгенерировать число`
  String get generateNumber {
    return Intl.message(
      'Сгенерировать число',
      name: 'generateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Генерация...`
  String get generating {
    return Intl.message(
      'Генерация...',
      name: 'generating',
      desc: '',
      args: [],
    );
  }

  /// `Календарь`
  String get calendar {
    return Intl.message(
      'Календарь',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Календарь событий`
  String get event_calendar {
    return Intl.message(
      'Календарь событий',
      name: 'event_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Все события`
  String get all_events {
    return Intl.message(
      'Все события',
      name: 'all_events',
      desc: '',
      args: [],
    );
  }

  /// `События персонажей`
  String get character_events {
    return Intl.message(
      'События персонажей',
      name: 'character_events',
      desc: '',
      args: [],
    );
  }

  /// `События рас`
  String get race_events {
    return Intl.message(
      'События рас',
      name: 'race_events',
      desc: '',
      args: [],
    );
  }

  /// `События заметок`
  String get note_events {
    return Intl.message(
      'События заметок',
      name: 'note_events',
      desc: '',
      args: [],
    );
  }

  /// `Нет событий на выбранный день`
  String get no_events {
    return Intl.message(
      'Нет событий на выбранный день',
      name: 'no_events',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки событий`
  String get events_loading_error {
    return Intl.message(
      'Ошибка загрузки событий',
      name: 'events_loading_error',
      desc: '',
      args: [],
    );
  }

  /// `Событие`
  String get event {
    return Intl.message(
      'Событие',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `События`
  String get events {
    return Intl.message(
      'События',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Сегодня`
  String get today {
    return Intl.message(
      'Сегодня',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Месяц`
  String get month {
    return Intl.message(
      'Месяц',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Неделя`
  String get week {
    return Intl.message(
      'Неделя',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `День`
  String get day {
    return Intl.message(
      'День',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Вид календаря`
  String get calendar_view {
    return Intl.message(
      'Вид календаря',
      name: 'calendar_view',
      desc: '',
      args: [],
    );
  }

  /// `Тип события`
  String get event_type {
    return Intl.message(
      'Тип события',
      name: 'event_type',
      desc: '',
      args: [],
    );
  }

  /// `Создано`
  String get created {
    return Intl.message(
      'Создано',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Обновлено`
  String get updated {
    return Intl.message(
      'Обновлено',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `Перейти к событию`
  String get go_to_event {
    return Intl.message(
      'Перейти к событию',
      name: 'go_to_event',
      desc: '',
      args: [],
    );
  }

  /// `Фильтровать события`
  String get filter_events {
    return Intl.message(
      'Фильтровать события',
      name: 'filter_events',
      desc: '',
      args: [],
    );
  }

  /// `Статистика календаря`
  String get calendar_statistics {
    return Intl.message(
      'Статистика календаря',
      name: 'calendar_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Всего событий`
  String get total_events {
    return Intl.message(
      'Всего событий',
      name: 'total_events',
      desc: '',
      args: [],
    );
  }

  /// `Событий в этом месяце`
  String get events_this_month {
    return Intl.message(
      'Событий в этом месяце',
      name: 'events_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Событий сегодня`
  String get events_today {
    return Intl.message(
      'Событий сегодня',
      name: 'events_today',
      desc: '',
      args: [],
    );
  }

  /// `Хронология активности`
  String get activity_timeline {
    return Intl.message(
      'Хронология активности',
      name: 'activity_timeline',
      desc: '',
      args: [],
    );
  }

  /// `Управление шаблонами персонажей`
  String get template_management {
    return Intl.message(
      'Управление шаблонами персонажей',
      name: 'template_management',
      desc: '',
      args: [],
    );
  }

  /// `Управление инструментами`
  String get tool_management {
    return Intl.message(
      'Управление инструментами',
      name: 'tool_management',
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

  /// `Создать расу`
  String get create_race {
    return Intl.message(
      'Создать расу',
      name: 'create_race',
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

  /// `Недавняя активность`
  String get recent_activity {
    return Intl.message(
      'Недавняя активность',
      name: 'recent_activity',
      desc: '',
      args: [],
    );
  }

  /// `Быстрые действия`
  String get quick_actions {
    return Intl.message(
      'Быстрые действия',
      name: 'quick_actions',
      desc: '',
      args: [],
    );
  }

  /// `Показать все`
  String get view_all {
    return Intl.message(
      'Показать все',
      name: 'view_all',
      desc: '',
      args: [],
    );
  }

  /// `Статистика`
  String get statistics {
    return Intl.message(
      'Статистика',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Всего: {count}`
  String total_count(Object count) {
    return Intl.message(
      'Всего: $count',
      name: 'total_count',
      desc: '',
      args: [count],
    );
  }

  /// `Недавно редактировались`
  String get recently_edited {
    return Intl.message(
      'Недавно редактировались',
      name: 'recently_edited',
      desc: '',
      args: [],
    );
  }

  /// `Самые популярные`
  String get most_popular {
    return Intl.message(
      'Самые популярные',
      name: 'most_popular',
      desc: '',
      args: [],
    );
  }

  /// `По расам`
  String get by_race {
    return Intl.message(
      'По расам',
      name: 'by_race',
      desc: '',
      args: [],
    );
  }

  /// `По тегам`
  String get by_tags {
    return Intl.message(
      'По тегам',
      name: 'by_tags',
      desc: '',
      args: [],
    );
  }

  /// `Нет недавней активности`
  String get no_recent_activity {
    return Intl.message(
      'Нет недавней активности',
      name: 'no_recent_activity',
      desc: '',
      args: [],
    );
  }

  /// `С возвращением!`
  String get welcome_back {
    return Intl.message(
      'С возвращением!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Ваша коллекция`
  String get your_collection {
    return Intl.message(
      'Ваша коллекция',
      name: 'your_collection',
      desc: '',
      args: [],
    );
  }

  /// `Обзор коллекции`
  String get collection_overview {
    return Intl.message(
      'Обзор коллекции',
      name: 'collection_overview',
      desc: '',
      args: [],
    );
  }

  /// `Персонажей: {count}`
  String characters_count(Object count) {
    return Intl.message(
      'Персонажей: $count',
      name: 'characters_count',
      desc: '',
      args: [count],
    );
  }

  /// `Рас: {count}`
  String races_count(Object count) {
    return Intl.message(
      'Рас: $count',
      name: 'races_count',
      desc: '',
      args: [count],
    );
  }

  /// `Заметок: {count}`
  String notes_count(Object count) {
    return Intl.message(
      'Заметок: $count',
      name: 'notes_count',
      desc: '',
      args: [count],
    );
  }

  /// `Шаблонов: {count}`
  String templates_count(Object count) {
    return Intl.message(
      'Шаблонов: $count',
      name: 'templates_count',
      desc: '',
      args: [count],
    );
  }

  /// `Папок: {count}`
  String folders_count(Object count) {
    return Intl.message(
      'Папок: $count',
      name: 'folders_count',
      desc: '',
      args: [count],
    );
  }

  /// `Последний созданный`
  String get last_created {
    return Intl.message(
      'Последний созданный',
      name: 'last_created',
      desc: '',
      args: [],
    );
  }

  /// `Последний отредактированный`
  String get last_edited {
    return Intl.message(
      'Последний отредактированный',
      name: 'last_edited',
      desc: '',
      args: [],
    );
  }

  /// `Чаще всего редактируемый`
  String get most_edited {
    return Intl.message(
      'Чаще всего редактируемый',
      name: 'most_edited',
      desc: '',
      args: [],
    );
  }

  /// `Недавние персонажи`
  String get recent_characters {
    return Intl.message(
      'Недавние персонажи',
      name: 'recent_characters',
      desc: '',
      args: [],
    );
  }

  /// `Недавние расы`
  String get recent_races {
    return Intl.message(
      'Недавние расы',
      name: 'recent_races',
      desc: '',
      args: [],
    );
  }

  /// `Недавние заметки`
  String get recent_notes {
    return Intl.message(
      'Недавние заметки',
      name: 'recent_notes',
      desc: '',
      args: [],
    );
  }

  /// `Популярные теги`
  String get popular_tags {
    return Intl.message(
      'Популярные теги',
      name: 'popular_tags',
      desc: '',
      args: [],
    );
  }

  /// `Облако тегов`
  String get tag_cloud {
    return Intl.message(
      'Облако тегов',
      name: 'tag_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Поиск по коллекции...`
  String get search_collection {
    return Intl.message(
      'Поиск по коллекции...',
      name: 'search_collection',
      desc: '',
      args: [],
    );
  }

  /// `Фильтровать по`
  String get filter_by {
    return Intl.message(
      'Фильтровать по',
      name: 'filter_by',
      desc: '',
      args: [],
    );
  }

  /// `Сортировать по`
  String get sort_by {
    return Intl.message(
      'Сортировать по',
      name: 'sort_by',
      desc: '',
      args: [],
    );
  }

  /// `Все категории`
  String get all_categories {
    return Intl.message(
      'Все категории',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `Избранное`
  String get favorites {
    return Intl.message(
      'Избранное',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `В архиве`
  String get archived {
    return Intl.message(
      'В архиве',
      name: 'archived',
      desc: '',
      args: [],
    );
  }

  /// `Недавно просмотренные`
  String get recently_viewed {
    return Intl.message(
      'Недавно просмотренные',
      name: 'recently_viewed',
      desc: '',
      args: [],
    );
  }

  /// `Рекомендуемые действия`
  String get suggested_actions {
    return Intl.message(
      'Рекомендуемые действия',
      name: 'suggested_actions',
      desc: '',
      args: [],
    );
  }

  /// `Быстрое создание`
  String get quick_create {
    return Intl.message(
      'Быстрое создание',
      name: 'quick_create',
      desc: '',
      args: [],
    );
  }

  /// `Просмотреть шаблоны`
  String get browse_templates {
    return Intl.message(
      'Просмотреть шаблоны',
      name: 'browse_templates',
      desc: '',
      args: [],
    );
  }

  /// `Импортировать данные`
  String get import_data {
    return Intl.message(
      'Импортировать данные',
      name: 'import_data',
      desc: '',
      args: [],
    );
  }

  /// `Экспортировать данные`
  String get export_data {
    return Intl.message(
      'Экспортировать данные',
      name: 'export_data',
      desc: '',
      args: [],
    );
  }

  /// `Создать резервную копию`
  String get backup_data {
    return Intl.message(
      'Создать резервную копию',
      name: 'backup_data',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить данные`
  String get restore_data {
    return Intl.message(
      'Восстановить данные',
      name: 'restore_data',
      desc: '',
      args: [],
    );
  }

  /// `Обзор приложения`
  String get app_tour {
    return Intl.message(
      'Обзор приложения',
      name: 'app_tour',
      desc: '',
      args: [],
    );
  }

  /// `Помощь и поддержка`
  String get help_and_support {
    return Intl.message(
      'Помощь и поддержка',
      name: 'help_and_support',
      desc: '',
      args: [],
    );
  }

  /// `Сообщество`
  String get community {
    return Intl.message(
      'Сообщество',
      name: 'community',
      desc: '',
      args: [],
    );
  }

  /// `Обратная связь`
  String get feedback {
    return Intl.message(
      'Обратная связь',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Оценить приложение`
  String get rate_app {
    return Intl.message(
      'Оценить приложение',
      name: 'rate_app',
      desc: '',
      args: [],
    );
  }

  /// `Поделиться приложением`
  String get share_app {
    return Intl.message(
      'Поделиться приложением',
      name: 'share_app',
      desc: '',
      args: [],
    );
  }

  /// `О приложении`
  String get about {
    return Intl.message(
      'О приложении',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Политика конфиденциальности`
  String get privacy_policy {
    return Intl.message(
      'Политика конфиденциальности',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Условия использования`
  String get terms_of_service {
    return Intl.message(
      'Условия использования',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Информация о версии`
  String get version_info {
    return Intl.message(
      'Информация о версии',
      name: 'version_info',
      desc: '',
      args: [],
    );
  }

  /// `Проверить обновления`
  String get check_for_updates {
    return Intl.message(
      'Проверить обновления',
      name: 'check_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `Что нового`
  String get whats_new {
    return Intl.message(
      'Что нового',
      name: 'whats_new',
      desc: '',
      args: [],
    );
  }

  /// `Сбросить настройки`
  String get reset_settings {
    return Intl.message(
      'Сбросить настройки',
      name: 'reset_settings',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить настройки`
  String get save_settings {
    return Intl.message(
      'Сохранить настройки',
      name: 'save_settings',
      desc: '',
      args: [],
    );
  }

  /// `Включаемые разделы`
  String get sections_to_include {
    return Intl.message(
      'Включаемые разделы',
      name: 'sections_to_include',
      desc: '',
      args: [],
    );
  }

  /// `Настройки шрифтов`
  String get font_settings {
    return Intl.message(
      'Настройки шрифтов',
      name: 'font_settings',
      desc: '',
      args: [],
    );
  }

  /// `Настройки цветов`
  String get color_settings {
    return Intl.message(
      'Настройки цветов',
      name: 'color_settings',
      desc: '',
      args: [],
    );
  }

  /// `Размер шрифта заголовков`
  String get title_font_size {
    return Intl.message(
      'Размер шрифта заголовков',
      name: 'title_font_size',
      desc: '',
      args: [],
    );
  }

  /// `Размер шрифта текста`
  String get body_font_size {
    return Intl.message(
      'Размер шрифта текста',
      name: 'body_font_size',
      desc: '',
      args: [],
    );
  }

  /// `Цвет заголовков`
  String get title_color {
    return Intl.message(
      'Цвет заголовков',
      name: 'title_color',
      desc: '',
      args: [],
    );
  }

  /// `Цвет текста`
  String get body_color {
    return Intl.message(
      'Цвет текста',
      name: 'body_color',
      desc: '',
      args: [],
    );
  }

  /// `Настройки сохранены`
  String get settings_saved {
    return Intl.message(
      'Настройки сохранены',
      name: 'settings_saved',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки настроек PDF`
  String get settings_load_error {
    return Intl.message(
      'Ошибка загрузки настроек PDF',
      name: 'settings_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Размер шрифта`
  String get font_size {
    return Intl.message(
      'Размер шрифта',
      name: 'font_size',
      desc: '',
      args: [],
    );
  }

  /// `Выбор цвета`
  String get color_picker {
    return Intl.message(
      'Выбор цвета',
      name: 'color_picker',
      desc: '',
      args: [],
    );
  }

  /// `Опции экспорта`
  String get export_options {
    return Intl.message(
      'Опции экспорта',
      name: 'export_options',
      desc: '',
      args: [],
    );
  }

  /// `Макет страницы`
  String get page_layout {
    return Intl.message(
      'Макет страницы',
      name: 'page_layout',
      desc: '',
      args: [],
    );
  }

  /// `Размер страницы`
  String get page_size {
    return Intl.message(
      'Размер страницы',
      name: 'page_size',
      desc: '',
      args: [],
    );
  }

  /// `Поля страницы`
  String get page_margins {
    return Intl.message(
      'Поля страницы',
      name: 'page_margins',
      desc: '',
      args: [],
    );
  }

  /// `Включать изображения`
  String get include_images {
    return Intl.message(
      'Включать изображения',
      name: 'include_images',
      desc: '',
      args: [],
    );
  }

  /// `Качество изображений`
  String get image_quality {
    return Intl.message(
      'Качество изображений',
      name: 'image_quality',
      desc: '',
      args: [],
    );
  }

  /// `Высокое качество`
  String get high_quality {
    return Intl.message(
      'Высокое качество',
      name: 'high_quality',
      desc: '',
      args: [],
    );
  }

  /// `Среднее качество`
  String get medium_quality {
    return Intl.message(
      'Среднее качество',
      name: 'medium_quality',
      desc: '',
      args: [],
    );
  }

  /// `Низкое качество`
  String get low_quality {
    return Intl.message(
      'Низкое качество',
      name: 'low_quality',
      desc: '',
      args: [],
    );
  }

  /// `Сжатие`
  String get compression {
    return Intl.message(
      'Сжатие',
      name: 'compression',
      desc: '',
      args: [],
    );
  }

  /// `Ориентация страницы`
  String get page_orientation {
    return Intl.message(
      'Ориентация страницы',
      name: 'page_orientation',
      desc: '',
      args: [],
    );
  }

  /// `Портретная`
  String get portrait {
    return Intl.message(
      'Портретная',
      name: 'portrait',
      desc: '',
      args: [],
    );
  }

  /// `Альбомная`
  String get landscape {
    return Intl.message(
      'Альбомная',
      name: 'landscape',
      desc: '',
      args: [],
    );
  }

  /// `Автоматический макет`
  String get auto_layout {
    return Intl.message(
      'Автоматический макет',
      name: 'auto_layout',
      desc: '',
      args: [],
    );
  }

  /// `Пользовательский макет`
  String get custom_layout {
    return Intl.message(
      'Пользовательский макет',
      name: 'custom_layout',
      desc: '',
      args: [],
    );
  }

  /// `Нумерация страниц`
  String get page_numbering {
    return Intl.message(
      'Нумерация страниц',
      name: 'page_numbering',
      desc: '',
      args: [],
    );
  }

  /// `Колонтитулы`
  String get headers_footers {
    return Intl.message(
      'Колонтитулы',
      name: 'headers_footers',
      desc: '',
      args: [],
    );
  }

  /// `Оглавление`
  String get table_of_contents {
    return Intl.message(
      'Оглавление',
      name: 'table_of_contents',
      desc: '',
      args: [],
    );
  }

  /// `Водяной знак`
  String get watermark {
    return Intl.message(
      'Водяной знак',
      name: 'watermark',
      desc: '',
      args: [],
    );
  }

  /// `Опции безопасности`
  String get security_options {
    return Intl.message(
      'Опции безопасности',
      name: 'security_options',
      desc: '',
      args: [],
    );
  }

  /// `Защита паролем`
  String get password_protection {
    return Intl.message(
      'Защита паролем',
      name: 'password_protection',
      desc: '',
      args: [],
    );
  }

  /// `Разрешения`
  String get permissions {
    return Intl.message(
      'Разрешения',
      name: 'permissions',
      desc: '',
      args: [],
    );
  }

  /// `Разрешить печать`
  String get allow_printing {
    return Intl.message(
      'Разрешить печать',
      name: 'allow_printing',
      desc: '',
      args: [],
    );
  }

  /// `Разрешить копирование`
  String get allow_copying {
    return Intl.message(
      'Разрешить копирование',
      name: 'allow_copying',
      desc: '',
      args: [],
    );
  }

  /// `Разрешить изменения`
  String get allow_modifications {
    return Intl.message(
      'Разрешить изменения',
      name: 'allow_modifications',
      desc: '',
      args: [],
    );
  }

  /// `Метаданные`
  String get metadata {
    return Intl.message(
      'Метаданные',
      name: 'metadata',
      desc: '',
      args: [],
    );
  }

  /// `Автор`
  String get author {
    return Intl.message(
      'Автор',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `Тема`
  String get subject {
    return Intl.message(
      'Тема',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Ключевые слова`
  String get keywords {
    return Intl.message(
      'Ключевые слова',
      name: 'keywords',
      desc: '',
      args: [],
    );
  }

  /// `Расширенные настройки`
  String get advanced_settings {
    return Intl.message(
      'Расширенные настройки',
      name: 'advanced_settings',
      desc: '',
      args: [],
    );
  }

  /// `Предпросмотр`
  String get preview {
    return Intl.message(
      'Предпросмотр',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Сгенерировать образец`
  String get generate_sample {
    return Intl.message(
      'Сгенерировать образец',
      name: 'generate_sample',
      desc: '',
      args: [],
    );
  }

  /// `Настройки по умолчанию`
  String get default_settings {
    return Intl.message(
      'Настройки по умолчанию',
      name: 'default_settings',
      desc: '',
      args: [],
    );
  }

  /// `Пресет экспорта`
  String get export_preset {
    return Intl.message(
      'Пресет экспорта',
      name: 'export_preset',
      desc: '',
      args: [],
    );
  }

  /// `Пользовательский пресет`
  String get custom_preset {
    return Intl.message(
      'Пользовательский пресет',
      name: 'custom_preset',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить пресет`
  String get save_preset {
    return Intl.message(
      'Сохранить пресет',
      name: 'save_preset',
      desc: '',
      args: [],
    );
  }

  /// `Загрузить пресет`
  String get load_preset {
    return Intl.message(
      'Загрузить пресет',
      name: 'load_preset',
      desc: '',
      args: [],
    );
  }

  /// `Удалить пресет`
  String get delete_preset {
    return Intl.message(
      'Удалить пресет',
      name: 'delete_preset',
      desc: '',
      args: [],
    );
  }

  /// `Имя пресета`
  String get preset_name {
    return Intl.message(
      'Имя пресета',
      name: 'preset_name',
      desc: '',
      args: [],
    );
  }

  /// `Пресет сохранен`
  String get preset_saved {
    return Intl.message(
      'Пресет сохранен',
      name: 'preset_saved',
      desc: '',
      args: [],
    );
  }

  /// `Пресет загружен`
  String get preset_loaded {
    return Intl.message(
      'Пресет загружен',
      name: 'preset_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Пресет удален`
  String get preset_deleted {
    return Intl.message(
      'Пресет удален',
      name: 'preset_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка создания сервиса для персонажа`
  String get service_creation_error {
    return Intl.message(
      'Ошибка создания сервиса для персонажа',
      name: 'service_creation_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка создания сервиса для расы`
  String get race_service_creation_error {
    return Intl.message(
      'Ошибка создания сервиса для расы',
      name: 'race_service_creation_error',
      desc: '',
      args: [],
    );
  }

  /// `Неподдерживаемый тип модели для экспорта PDF`
  String get unsupported_model_type {
    return Intl.message(
      'Неподдерживаемый тип модели для экспорта PDF',
      name: 'unsupported_model_type',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка генерации PDF`
  String get pdf_generation_error {
    return Intl.message(
      'Ошибка генерации PDF',
      name: 'pdf_generation_error',
      desc: '',
      args: [],
    );
  }

  /// `Таймаут загрузки шрифта`
  String get font_load_timeout {
    return Intl.message(
      'Таймаут загрузки шрифта',
      name: 'font_load_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения настроек PDF`
  String get settings_save_error {
    return Intl.message(
      'Ошибка сохранения настроек PDF',
      name: 'settings_save_error',
      desc: '',
      args: [],
    );
  }

  /// `Характеристика персонажа`
  String get character_profile_title {
    return Intl.message(
      'Характеристика персонажа',
      name: 'character_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Описание расы`
  String get race_profile_title {
    return Intl.message(
      'Описание расы',
      name: 'race_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Создание PDF заняло слишком много времени`
  String get pdf_creation_timeout {
    return Intl.message(
      'Создание PDF заняло слишком много времени',
      name: 'pdf_creation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Генерация PDF заняла слишком много времени`
  String get pdf_generation_timeout {
    return Intl.message(
      'Генерация PDF заняла слишком много времени',
      name: 'pdf_generation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Шаринг файла занял слишком много времени`
  String get file_sharing_timeout {
    return Intl.message(
      'Шаринг файла занял слишком много времени',
      name: 'file_sharing_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Операция заняла слишком много времени`
  String get operation_timeout {
    return Intl.message(
      'Операция заняла слишком много времени',
      name: 'operation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось создать PDF`
  String get pdf_creation_failed {
    return Intl.message(
      'Не удалось создать PDF',
      name: 'pdf_creation_failed',
      desc: '',
      args: [],
    );
  }

  /// `Таймаут`
  String get timeout_error {
    return Intl.message(
      'Таймаут',
      name: 'timeout_error',
      desc: '',
      args: [],
    );
  }

  /// `PDF успешно создан и готов к использованию`
  String get export_success {
    return Intl.message(
      'PDF успешно создан и готов к использованию',
      name: 'export_success',
      desc: '',
      args: [],
    );
  }

  /// `Раса "{name}" успешно экспортирована в PDF`
  String race_exported(Object name) {
    return Intl.message(
      'Раса "$name" успешно экспортирована в PDF',
      name: 'race_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Инициализация`
  String get initialization {
    return Intl.message(
      'Инициализация',
      name: 'initialization',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка инициализации`
  String get initialization_error {
    return Intl.message(
      'Ошибка инициализации',
      name: 'initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Критическая ошибка`
  String get critical_error {
    return Intl.message(
      'Критическая ошибка',
      name: 'critical_error',
      desc: '',
      args: [],
    );
  }

  /// `Приложение сбросило некоторые данные и настройки для восстановления работоспособности`
  String get initialization_reset_warning {
    return Intl.message(
      'Приложение сбросило некоторые данные и настройки для восстановления работоспособности',
      name: 'initialization_reset_warning',
      desc: '',
      args: [],
    );
  }

  /// `Приложение попыталось восстановить работоспособность, но некоторые данные могли быть утеряны`
  String get critical_error_warning {
    return Intl.message(
      'Приложение попыталось восстановить работоспособность, но некоторые данные могли быть утеряны',
      name: 'critical_error_warning',
      desc: '',
      args: [],
    );
  }

  /// `Понятно`
  String get understood {
    return Intl.message(
      'Понятно',
      name: 'understood',
      desc: '',
      args: [],
    );
  }

  /// `Подробнее`
  String get details {
    return Intl.message(
      'Подробнее',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Закрыть приложение`
  String get close_app {
    return Intl.message(
      'Закрыть приложение',
      name: 'close_app',
      desc: '',
      args: [],
    );
  }

  /// `Продолжить`
  String get continue_text {
    return Intl.message(
      'Продолжить',
      name: 'continue_text',
      desc: '',
      args: [],
    );
  }

  /// `Детали ошибки`
  String get error_details {
    return Intl.message(
      'Детали ошибки',
      name: 'error_details',
      desc: '',
      args: [],
    );
  }

  /// `Произошла ошибка во время инициализации приложения. Подробная техническая информация:`
  String get error_details_description {
    return Intl.message(
      'Произошла ошибка во время инициализации приложения. Подробная техническая информация:',
      name: 'error_details_description',
      desc: '',
      args: [],
    );
  }

  /// `Технические детали`
  String get technical_details {
    return Intl.message(
      'Технические детали',
      name: 'technical_details',
      desc: '',
      args: [],
    );
  }

  /// `Приложение автоматически попыталось восстановить работоспособность. Если ошибка повторяется, попробуйте переустановить приложение.`
  String get recovery_advice {
    return Intl.message(
      'Приложение автоматически попыталось восстановить работоспособность. Если ошибка повторяется, попробуйте переустановить приложение.',
      name: 'recovery_advice',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка инициализации базы данных`
  String get hive_initialization_error {
    return Intl.message(
      'Ошибка инициализации базы данных',
      name: 'hive_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка инициализации менеджера окон`
  String get window_manager_initialization_error {
    return Intl.message(
      'Ошибка инициализации менеджера окон',
      name: 'window_manager_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка инициализации данных`
  String get data_initialization_error {
    return Intl.message(
      'Ошибка инициализации данных',
      name: 'data_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка инициализации сервиса`
  String get service_initialization_error {
    return Intl.message(
      'Ошибка инициализации сервиса',
      name: 'service_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Инициализация завершена успешно`
  String get initialization_success {
    return Intl.message(
      'Инициализация завершена успешно',
      name: 'initialization_success',
      desc: '',
      args: [],
    );
  }

  /// `Инициализация не удалась`
  String get initialization_failed {
    return Intl.message(
      'Инициализация не удалась',
      name: 'initialization_failed',
      desc: '',
      args: [],
    );
  }

  /// `Повторить инициализацию`
  String get retry_initialization {
    return Intl.message(
      'Повторить инициализацию',
      name: 'retry_initialization',
      desc: '',
      args: [],
    );
  }

  /// `Инициализация приложения...`
  String get initialization_progress {
    return Intl.message(
      'Инициализация приложения...',
      name: 'initialization_progress',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка данных...`
  String get loading_data {
    return Intl.message(
      'Загрузка данных...',
      name: 'loading_data',
      desc: '',
      args: [],
    );
  }

  /// `Подготовка сервисов...`
  String get preparing_services {
    return Intl.message(
      'Подготовка сервисов...',
      name: 'preparing_services',
      desc: '',
      args: [],
    );
  }

  /// `Проверка зависимостей...`
  String get checking_dependencies {
    return Intl.message(
      'Проверка зависимостей...',
      name: 'checking_dependencies',
      desc: '',
      args: [],
    );
  }

  /// `Таймаут инициализации`
  String get initialization_timeout {
    return Intl.message(
      'Таймаут инициализации',
      name: 'initialization_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Инициализация заняла слишком много времени. Проверьте подключение к интернету и попробуйте снова.`
  String get initialization_timeout_message {
    return Intl.message(
      'Инициализация заняла слишком много времени. Проверьте подключение к интернету и попробуйте снова.',
      name: 'initialization_timeout_message',
      desc: '',
      args: [],
    );
  }

  /// `Предупреждение: мало места на устройстве`
  String get low_storage_warning {
    return Intl.message(
      'Предупреждение: мало места на устройстве',
      name: 'low_storage_warning',
      desc: '',
      args: [],
    );
  }

  /// `На вашем устройстве осталось мало места. Это может повлиять на работу приложения.`
  String get low_storage_message {
    return Intl.message(
      'На вашем устройстве осталось мало места. Это может повлиять на работу приложения.',
      name: 'low_storage_message',
      desc: '',
      args: [],
    );
  }

  /// `Требуется разрешение`
  String get permission_required {
    return Intl.message(
      'Требуется разрешение',
      name: 'permission_required',
      desc: '',
      args: [],
    );
  }

  /// `Для работы приложения требуется разрешение на доступ к хранилищу.`
  String get storage_permission_message {
    return Intl.message(
      'Для работы приложения требуется разрешение на доступ к хранилищу.',
      name: 'storage_permission_message',
      desc: '',
      args: [],
    );
  }

  /// `Предоставить разрешение`
  String get grant_permission {
    return Intl.message(
      'Предоставить разрешение',
      name: 'grant_permission',
      desc: '',
      args: [],
    );
  }

  /// `Пропустить`
  String get skip_for_now {
    return Intl.message(
      'Пропустить',
      name: 'skip_for_now',
      desc: '',
      args: [],
    );
  }

  /// `Инициализация завершена`
  String get initialization_complete {
    return Intl.message(
      'Инициализация завершена',
      name: 'initialization_complete',
      desc: '',
      args: [],
    );
  }

  /// `Приложение готово к использованию`
  String get ready_to_use {
    return Intl.message(
      'Приложение готово к использованию',
      name: 'ready_to_use',
      desc: '',
      args: [],
    );
  }

  /// `Добро пожаловать в CharacterBook!`
  String get welcome_message {
    return Intl.message(
      'Добро пожаловать в CharacterBook!',
      name: 'welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Настройка окружения...`
  String get configuring_environment {
    return Intl.message(
      'Настройка окружения...',
      name: 'configuring_environment',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка ресурсов...`
  String get loading_resources {
    return Intl.message(
      'Загрузка ресурсов...',
      name: 'loading_resources',
      desc: '',
      args: [],
    );
  }

  /// `Проверка целостности...`
  String get verifying_integrity {
    return Intl.message(
      'Проверка целостности...',
      name: 'verifying_integrity',
      desc: '',
      args: [],
    );
  }

  /// `Миграция данных...`
  String get migration_in_progress {
    return Intl.message(
      'Миграция данных...',
      name: 'migration_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Создание резервной копии...`
  String get backup_creation {
    return Intl.message(
      'Создание резервной копии...',
      name: 'backup_creation',
      desc: '',
      args: [],
    );
  }

  /// `Очистка кеша...`
  String get cache_clearing {
    return Intl.message(
      'Очистка кеша...',
      name: 'cache_clearing',
      desc: '',
      args: [],
    );
  }

  /// `Оптимизация производительности...`
  String get optimizing_performance {
    return Intl.message(
      'Оптимизация производительности...',
      name: 'optimizing_performance',
      desc: '',
      args: [],
    );
  }

  /// `Завершение настройки...`
  String get finalizing_setup {
    return Intl.message(
      'Завершение настройки...',
      name: 'finalizing_setup',
      desc: '',
      args: [],
    );
  }

  /// `Закрыть`
  String get close {
    return Intl.message(
      'Закрыть',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Файл расы (.race)`
  String get file_race {
    return Intl.message(
      'Файл расы (.race)',
      name: 'file_race',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка дублирования`
  String get duplicate_error {
    return Intl.message(
      'Ошибка дублирования',
      name: 'duplicate_error',
      desc: '',
      args: [],
    );
  }

  /// `Дублирование персонажа`
  String get duplicate_character {
    return Intl.message(
      'Дублирование персонажа',
      name: 'duplicate_character',
      desc: '',
      args: [],
    );
  }

  /// `Персонаж продублирован`
  String get character_duplicated {
    return Intl.message(
      'Персонаж продублирован',
      name: 'character_duplicated',
      desc: '',
      args: [],
    );
  }

  /// `Персонажи и расы`
  String get characters_and_races {
    return Intl.message(
      'Персонажи и расы',
      name: 'characters_and_races',
      desc: '',
      args: [],
    );
  }

  /// `Дублировать`
  String get duplicate {
    return Intl.message(
      'Дублировать',
      name: 'duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Информация`
  String get information {
    return Intl.message(
      'Информация',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Вы действительно хотите удалить выбранный объект?`
  String get deleteConfirmation {
    return Intl.message(
      'Вы действительно хотите удалить выбранный объект?',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Голубой`
  String get color_light_blue {
    return Intl.message(
      'Голубой',
      name: 'color_light_blue',
      desc: '',
      args: [],
    );
  }

  /// `Выберите цвет`
  String get choose_color {
    return Intl.message(
      'Выберите цвет',
      name: 'choose_color',
      desc: '',
      args: [],
    );
  }

  /// `Время экспорта заняло слишком много времени. Попробуйте ещё раз.`
  String get export_timeout {
    return Intl.message(
      'Время экспорта заняло слишком много времени. Попробуйте ещё раз.',
      name: 'export_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Действия смахивания`
  String get swipeActions {
    return Intl.message(
      'Действия смахивания',
      name: 'swipeActions',
      desc: '',
      args: [],
    );
  }

  /// `Действие при смахивании влево`
  String get leftSwipeAction {
    return Intl.message(
      'Действие при смахивании влево',
      name: 'leftSwipeAction',
      desc: '',
      args: [],
    );
  }

  /// `Действие при смахивании вправо`
  String get rightSwipeAction {
    return Intl.message(
      'Действие при смахивании вправо',
      name: 'rightSwipeAction',
      desc: '',
      args: [],
    );
  }

  /// `Настроить действия смахивания`
  String get configureSwipeActions {
    return Intl.message(
      'Настроить действия смахивания',
      name: 'configureSwipeActions',
      desc: '',
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
