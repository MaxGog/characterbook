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

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get select {
    return Intl.message(
      'Selected',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Replace`
  String get replace {
    return Intl.message(
      'Replace',
      name: 'replace',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get processing {
    return Intl.message(
      'Loading...',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Operation completed successfully`
  String get operationCompleted {
    return Intl.message(
      'Operation completed successfully',
      name: 'operationCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copied_to_clipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copied_to_clipboard',
      desc: '',
      args: [],
    );
  }

  /// `Required field`
  String get required_field_error {
    return Intl.message(
      'Required field',
      name: 'required_field_error',
      desc: '',
      args: [],
    );
  }

  /// `Not selected`
  String get not_selected {
    return Intl.message(
      'Not selected',
      name: 'not_selected',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message(
      'None',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items {
    return Intl.message(
      'items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Character`
  String get character {
    return Intl.message(
      'Character',
      name: 'character',
      desc: '',
      args: [],
    );
  }

  /// `Characters`
  String get characters {
    return Intl.message(
      'Characters',
      name: 'characters',
      desc: '',
      args: [],
    );
  }

  /// `My Characters`
  String get my_characters {
    return Intl.message(
      'My Characters',
      name: 'my_characters',
      desc: '',
      args: [],
    );
  }

  /// `New Character`
  String get new_character {
    return Intl.message(
      'New Character',
      name: 'new_character',
      desc: '',
      args: [],
    );
  }

  /// `Character Management`
  String get character_management {
    return Intl.message(
      'Character Management',
      name: 'character_management',
      desc: '',
      args: [],
    );
  }

  /// `Edit Character`
  String get edit_character {
    return Intl.message(
      'Edit Character',
      name: 'edit_character',
      desc: '',
      args: [],
    );
  }

  /// `Delete Character`
  String get delete_character {
    return Intl.message(
      'Delete Character',
      name: 'delete_character',
      desc: '',
      args: [],
    );
  }

  /// `Copy Character`
  String get copy_character {
    return Intl.message(
      'Copy Character',
      name: 'copy_character',
      desc: '',
      args: [],
    );
  }

  /// `Share Character`
  String get share_character {
    return Intl.message(
      'Share Character',
      name: 'share_character',
      desc: '',
      args: [],
    );
  }

  /// `Select Character`
  String get select_character {
    return Intl.message(
      'Select Character',
      name: 'select_character',
      desc: '',
      args: [],
    );
  }

  /// `Create Character`
  String get create_character {
    return Intl.message(
      'Create Character',
      name: 'create_character',
      desc: '',
      args: [],
    );
  }

  /// `Race`
  String get race {
    return Intl.message(
      'Race',
      name: 'race',
      desc: '',
      args: [],
    );
  }

  /// `Races`
  String get races {
    return Intl.message(
      'Races',
      name: 'races',
      desc: '',
      args: [],
    );
  }

  /// `New Race`
  String get new_race {
    return Intl.message(
      'New Race',
      name: 'new_race',
      desc: '',
      args: [],
    );
  }

  /// `Race Management`
  String get race_management {
    return Intl.message(
      'Race Management',
      name: 'race_management',
      desc: '',
      args: [],
    );
  }

  /// `Edit Race`
  String get edit_race {
    return Intl.message(
      'Edit Race',
      name: 'edit_race',
      desc: '',
      args: [],
    );
  }

  /// `Import Race`
  String get import_race {
    return Intl.message(
      'Import Race',
      name: 'import_race',
      desc: '',
      args: [],
    );
  }

  /// `Template`
  String get template {
    return Intl.message(
      'Template',
      name: 'template',
      desc: '',
      args: [],
    );
  }

  /// `Templates`
  String get templates {
    return Intl.message(
      'Templates',
      name: 'templates',
      desc: '',
      args: [],
    );
  }

  /// `New Template`
  String get new_template {
    return Intl.message(
      'New Template',
      name: 'new_template',
      desc: '',
      args: [],
    );
  }

  /// `Edit Template`
  String get edit_template {
    return Intl.message(
      'Edit Template',
      name: 'edit_template',
      desc: '',
      args: [],
    );
  }

  /// `Create Template`
  String get create_template {
    return Intl.message(
      'Create Template',
      name: 'create_template',
      desc: '',
      args: [],
    );
  }

  /// `Select Template`
  String get select_template {
    return Intl.message(
      'Select Template',
      name: 'select_template',
      desc: '',
      args: [],
    );
  }

  /// `Folder`
  String get folder {
    return Intl.message(
      'Folder',
      name: 'folder',
      desc: '',
      args: [],
    );
  }

  /// `Folders`
  String get folders {
    return Intl.message(
      'Folders',
      name: 'folders',
      desc: '',
      args: [],
    );
  }

  /// `New Folder`
  String get new_folder {
    return Intl.message(
      'New Folder',
      name: 'new_folder',
      desc: '',
      args: [],
    );
  }

  /// `Edit Folder`
  String get edit_folder {
    return Intl.message(
      'Edit Folder',
      name: 'edit_folder',
      desc: '',
      args: [],
    );
  }

  /// `Folder Name`
  String get folder_name {
    return Intl.message(
      'Folder Name',
      name: 'folder_name',
      desc: '',
      args: [],
    );
  }

  /// `Folder Color`
  String get folder_color {
    return Intl.message(
      'Folder Color',
      name: 'folder_color',
      desc: '',
      args: [],
    );
  }

  /// `Select Folder`
  String get select_folder {
    return Intl.message(
      'Select Folder',
      name: 'select_folder',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Related Posts`
  String get related_notes {
    return Intl.message(
      'Related Posts',
      name: 'related_notes',
      desc: '',
      args: [],
    );
  }

  /// `Start writing...`
  String get start_writing {
    return Intl.message(
      'Start writing...',
      name: 'start_writing',
      desc: '',
      args: [],
    );
  }

  /// `Choose character`
  String get choose_character {
    return Intl.message(
      'Choose character',
      name: 'choose_character',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Short Name`
  String get short_name {
    return Intl.message(
      'Short Name',
      name: 'short_name',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `years`
  String get years {
    return Intl.message(
      'years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get another {
    return Intl.message(
      'Other',
      name: 'another',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Biography`
  String get biography {
    return Intl.message(
      'Biography',
      name: 'biography',
      desc: '',
      args: [],
    );
  }

  /// `Personality`
  String get personality {
    return Intl.message(
      'Personality',
      name: 'personality',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Abilities`
  String get abilities {
    return Intl.message(
      'Abilities',
      name: 'abilities',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Biology`
  String get biology {
    return Intl.message(
      'Biology',
      name: 'biology',
      desc: '',
      args: [],
    );
  }

  /// `Backstory`
  String get backstory {
    return Intl.message(
      'Backstory',
      name: 'backstory',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `Add Tag`
  String get add_tag {
    return Intl.message(
      'Add Tag',
      name: 'add_tag',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Main Image`
  String get main_image {
    return Intl.message(
      'Main Image',
      name: 'main_image',
      desc: '',
      args: [],
    );
  }

  /// `Reference Image`
  String get reference_image {
    return Intl.message(
      'Reference Image',
      name: 'reference_image',
      desc: '',
      args: [],
    );
  }

  /// `Additional Images`
  String get additional_images {
    return Intl.message(
      'Additional Images',
      name: 'additional_images',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get add_picture {
    return Intl.message(
      'Add Image',
      name: 'add_picture',
      desc: '',
      args: [],
    );
  }

  /// `Character Avatar`
  String get character_avatar {
    return Intl.message(
      'Character Avatar',
      name: 'character_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Character Reference`
  String get character_reference {
    return Intl.message(
      'Character Reference',
      name: 'character_reference',
      desc: '',
      args: [],
    );
  }

  /// `Character Gallery`
  String get character_gallery {
    return Intl.message(
      'Character Gallery',
      name: 'character_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Avatar Cropping`
  String get avatar_crop_title {
    return Intl.message(
      'Avatar Cropping',
      name: 'avatar_crop_title',
      desc: '',
      args: [],
    );
  }

  /// `Save Crop`
  String get avatar_crop_save {
    return Intl.message(
      'Save Crop',
      name: 'avatar_crop_save',
      desc: '',
      args: [],
    );
  }

  /// `Template Name`
  String get template_name_label {
    return Intl.message(
      'Template Name',
      name: 'template_name_label',
      desc: '',
      args: [],
    );
  }

  /// `Standard Fields`
  String get standard_fields {
    return Intl.message(
      'Standard Fields',
      name: 'standard_fields',
      desc: '',
      args: [],
    );
  }

  /// `Custom Fields`
  String get custom_fields {
    return Intl.message(
      'Custom Fields',
      name: 'custom_fields',
      desc: '',
      args: [],
    );
  }

  /// `Custom Fields`
  String get custom_fields_editor_title {
    return Intl.message(
      'Custom Fields',
      name: 'custom_fields_editor_title',
      desc: '',
      args: [],
    );
  }

  /// `Add field`
  String get add_field {
    return Intl.message(
      'Add field',
      name: 'add_field',
      desc: '',
      args: [],
    );
  }

  /// `No custom fields added`
  String get no_custom_fields {
    return Intl.message(
      'No custom fields added',
      name: 'no_custom_fields',
      desc: '',
      args: [],
    );
  }

  /// `Field Name`
  String get field_name {
    return Intl.message(
      'Field Name',
      name: 'field_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter field name`
  String get field_name_hint {
    return Intl.message(
      'Enter field name',
      name: 'field_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Field Value`
  String get field_value {
    return Intl.message(
      'Field Value',
      name: 'field_value',
      desc: '',
      args: [],
    );
  }

  /// `Enter field value`
  String get field_value_hint {
    return Intl.message(
      'Enter field value',
      name: 'field_value_hint',
      desc: '',
      args: [],
    );
  }

  /// `standard`
  String get standard {
    return Intl.message(
      'standard',
      name: 'standard',
      desc: '',
      args: [],
    );
  }

  /// `custom`
  String get custom {
    return Intl.message(
      'custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `{count} fields`
  String fields_count(Object count) {
    return Intl.message(
      '$count fields',
      name: 'fields_count',
      desc: '',
      args: [count],
    );
  }

  /// `{count} more`
  String more_fields(Object count) {
    return Intl.message(
      '$count more',
      name: 'more_fields',
      desc: '',
      args: [count],
    );
  }

  /// `Children`
  String get children {
    return Intl.message(
      'Children',
      name: 'children',
      desc: '',
      args: [],
    );
  }

  /// `Young`
  String get young {
    return Intl.message(
      'Young',
      name: 'young',
      desc: '',
      args: [],
    );
  }

  /// `Adults`
  String get adults {
    return Intl.message(
      'Adults',
      name: 'adults',
      desc: '',
      args: [],
    );
  }

  /// `Elderly`
  String get elderly {
    return Intl.message(
      'Elderly',
      name: 'elderly',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get color_purple {
    return Intl.message(
      'Purple',
      name: 'color_purple',
      desc: '',
      args: [],
    );
  }

  /// `Teal`
  String get color_teal {
    return Intl.message(
      'Teal',
      name: 'color_teal',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get color_red {
    return Intl.message(
      'Red',
      name: 'color_red',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get color_pink {
    return Intl.message(
      'Pink',
      name: 'color_pink',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get color_dark {
    return Intl.message(
      'Dark',
      name: 'color_dark',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get color_green {
    return Intl.message(
      'Green',
      name: 'color_green',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get color_blue {
    return Intl.message(
      'Blue',
      name: 'color_blue',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get color_brown {
    return Intl.message(
      'Brown',
      name: 'color_brown',
      desc: '',
      args: [],
    );
  }

  /// `Orange`
  String get color_orange {
    return Intl.message(
      'Orange',
      name: 'color_orange',
      desc: '',
      args: [],
    );
  }

  /// `Grey`
  String get color_grey {
    return Intl.message(
      'Grey',
      name: 'color_grey',
      desc: '',
      args: [],
    );
  }

  /// `Accent Color`
  String get accentColor {
    return Intl.message(
      'Accent Color',
      name: 'accentColor',
      desc: '',
      args: [],
    );
  }

  /// `Color Scheme`
  String get colorScheme {
    return Intl.message(
      'Color Scheme',
      name: 'colorScheme',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `D&D Tools`
  String get dnd_tools {
    return Intl.message(
      'D&D Tools',
      name: 'dnd_tools',
      desc: '',
      args: [],
    );
  }

  /// `More Options`
  String get more_options {
    return Intl.message(
      'More Options',
      name: 'more_options',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get aboutApp {
    return Intl.message(
      'About App',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Acknowledgements`
  String get acknowledgements {
    return Intl.message(
      'Acknowledgements',
      name: 'acknowledgements',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `GitHub Repository`
  String get githubRepo {
    return Intl.message(
      'GitHub Repository',
      name: 'githubRepo',
      desc: '',
      args: [],
    );
  }

  /// `Licenses`
  String get licenses {
    return Intl.message(
      'Licenses',
      name: 'licenses',
      desc: '',
      args: [],
    );
  }

  /// `Used Libraries`
  String get usedLibraries {
    return Intl.message(
      'Used Libraries',
      name: 'usedLibraries',
      desc: '',
      args: [],
    );
  }

  /// `Flutter License`
  String get flutterLicense {
    return Intl.message(
      'Flutter License',
      name: 'flutterLicense',
      desc: '',
      args: [],
    );
  }

  /// `CharacterBook License (GNU GPL v3.0)`
  String get characterbookLicense {
    return Intl.message(
      'CharacterBook License (GNU GPL v3.0)',
      name: 'characterbookLicense',
      desc: '',
      args: [],
    );
  }

  /// `Export PDF settings`
  String get export_pdf_settings {
    return Intl.message(
      'Export PDF settings',
      name: 'export_pdf_settings',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get backup {
    return Intl.message(
      'Backup',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get createBackup {
    return Intl.message(
      'Create Backup',
      name: 'createBackup',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get creatingBackup {
    return Intl.message(
      'Create Backup',
      name: 'creatingBackup',
      desc: '',
      args: [],
    );
  }

  /// `Restore from Backup`
  String get restoringBackup {
    return Intl.message(
      'Restore from Backup',
      name: 'restoringBackup',
      desc: '',
      args: [],
    );
  }

  /// `Restore Data`
  String get restoreData {
    return Intl.message(
      'Restore Data',
      name: 'restoreData',
      desc: '',
      args: [],
    );
  }

  /// `Backup Options`
  String get backup_options {
    return Intl.message(
      'Backup Options',
      name: 'backup_options',
      desc: '',
      args: [],
    );
  }

  /// `Restore Options`
  String get restore_options {
    return Intl.message(
      'Restore Options',
      name: 'restore_options',
      desc: '',
      args: [],
    );
  }

  /// `Backup to Cloud`
  String get backup_to_cloud {
    return Intl.message(
      'Backup to Cloud',
      name: 'backup_to_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Backup to File`
  String get backup_to_file {
    return Intl.message(
      'Backup to File',
      name: 'backup_to_file',
      desc: '',
      args: [],
    );
  }

  /// `Restore from Cloud`
  String get restore_from_cloud {
    return Intl.message(
      'Restore from Cloud',
      name: 'restore_from_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Restore from File`
  String get restore_from_file {
    return Intl.message(
      'Restore from File',
      name: 'restore_from_file',
      desc: '',
      args: [],
    );
  }

  /// `File (.character)`
  String get file_character {
    return Intl.message(
      'File (.character)',
      name: 'file_character',
      desc: '',
      args: [],
    );
  }

  /// `PDF Document (.pdf)`
  String get file_pdf {
    return Intl.message(
      'PDF Document (.pdf)',
      name: 'file_pdf',
      desc: '',
      args: [],
    );
  }

  /// `File ready to send`
  String get file_ready {
    return Intl.message(
      'File ready to send',
      name: 'file_ready',
      desc: '',
      args: [],
    );
  }

  /// `Creating PDF...`
  String get creating_pdf {
    return Intl.message(
      'Creating PDF...',
      name: 'creating_pdf',
      desc: '',
      args: [],
    );
  }

  /// `Creating file...`
  String get creating_file {
    return Intl.message(
      'Creating file...',
      name: 'creating_file',
      desc: '',
      args: [],
    );
  }

  /// `Save Error`
  String get save_error {
    return Intl.message(
      'Save Error',
      name: 'save_error',
      desc: '',
      args: [],
    );
  }

  /// `Delete Error`
  String get delete_error {
    return Intl.message(
      'Delete Error',
      name: 'delete_error',
      desc: '',
      args: [],
    );
  }

  /// `Copy Error`
  String get copy_error {
    return Intl.message(
      'Copy Error',
      name: 'copy_error',
      desc: '',
      args: [],
    );
  }

  /// `Export Error`
  String get export_error {
    return Intl.message(
      'Export Error',
      name: 'export_error',
      desc: '',
      args: [],
    );
  }

  /// `Import error: {error}`
  String import_error(Object error) {
    return Intl.message(
      'Import error: $error',
      name: 'import_error',
      desc: '',
      args: [error],
    );
  }

  /// `Import cancelled`
  String get import_cancelled {
    return Intl.message(
      'Import cancelled',
      name: 'import_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `File selection error`
  String get file_pick_error {
    return Intl.message(
      'File selection error',
      name: 'file_pick_error',
      desc: '',
      args: [],
    );
  }

  /// `Image selection error: {error}`
  String image_picker_error(Object error) {
    return Intl.message(
      'Image selection error: $error',
      name: 'image_picker_error',
      desc: '',
      args: [error],
    );
  }

  /// `Authorization cancelled`
  String get auth_cancelled {
    return Intl.message(
      'Authorization cancelled',
      name: 'auth_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to get API client`
  String get auth_client_error {
    return Intl.message(
      'Failed to get API client',
      name: 'auth_client_error',
      desc: '',
      args: [],
    );
  }

  /// `Not available for web`
  String get web_not_supported {
    return Intl.message(
      'Not available for web',
      name: 'web_not_supported',
      desc: '',
      args: [],
    );
  }

  /// `Invalid age entered`
  String get invalid_age {
    return Intl.message(
      'Invalid age entered',
      name: 'invalid_age',
      desc: '',
      args: [],
    );
  }

  /// `Select gender`
  String get select_gender_error {
    return Intl.message(
      'Select gender',
      name: 'select_gender_error',
      desc: '',
      args: [],
    );
  }

  /// `Select race`
  String get select_race_error {
    return Intl.message(
      'Select race',
      name: 'select_race_error',
      desc: '',
      args: [],
    );
  }

  /// `The selected file is empty`
  String get empty_file_error {
    return Intl.message(
      'The selected file is empty',
      name: 'empty_file_error',
      desc: '',
      args: [],
    );
  }

  /// `Backup Error`
  String get cloud_backup_error {
    return Intl.message(
      'Backup Error',
      name: 'cloud_backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Backup created successfully`
  String get cloud_backup_success {
    return Intl.message(
      'Backup created successfully',
      name: 'cloud_backup_success',
      desc: '',
      args: [],
    );
  }

  /// `Error creating characters backup`
  String get cloud_backup_characters_error {
    return Intl.message(
      'Error creating characters backup',
      name: 'cloud_backup_characters_error',
      desc: '',
      args: [],
    );
  }

  /// `Characters backup created successfully`
  String get cloud_backup_characters_success {
    return Intl.message(
      'Characters backup created successfully',
      name: 'cloud_backup_characters_success',
      desc: '',
      args: [],
    );
  }

  /// `Full backup successfully created in Google Drive`
  String get cloud_backup_full_success {
    return Intl.message(
      'Full backup successfully created in Google Drive',
      name: 'cloud_backup_full_success',
      desc: '',
      args: [],
    );
  }

  /// `No backups found`
  String get cloud_backup_not_found {
    return Intl.message(
      'No backups found',
      name: 'cloud_backup_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Google Drive export error`
  String get cloud_export_error {
    return Intl.message(
      'Google Drive export error',
      name: 'cloud_export_error',
      desc: '',
      args: [],
    );
  }

  /// `Google Drive import error`
  String get cloud_import_error {
    return Intl.message(
      'Google Drive import error',
      name: 'cloud_import_error',
      desc: '',
      args: [],
    );
  }

  /// `Restore Error`
  String get cloud_restore_error {
    return Intl.message(
      'Restore Error',
      name: 'cloud_restore_error',
      desc: '',
      args: [],
    );
  }

  /// `Successfully restored:\n{charactersCount} characters\n{notesCount} notes\n{racesCount} races\n{templatesCount} templates\n{foldersCount} folders`
  String cloud_restore_success(Object charactersCount, Object notesCount,
      Object racesCount, Object templatesCount, Object foldersCount) {
    return Intl.message(
      'Successfully restored:\n$charactersCount characters\n$notesCount notes\n$racesCount races\n$templatesCount templates\n$foldersCount folders',
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

  /// `Backup created successfully`
  String get local_backup_success {
    return Intl.message(
      'Backup created successfully',
      name: 'local_backup_success',
      desc: '',
      args: [],
    );
  }

  /// `Backup error`
  String get local_backup_error {
    return Intl.message(
      'Backup error',
      name: 'local_backup_error',
      desc: '',
      args: [],
    );
  }

  /// `Restore completed successfully`
  String get local_restore_success {
    return Intl.message(
      'Restore completed successfully',
      name: 'local_restore_success',
      desc: '',
      args: [],
    );
  }

  /// `Restore error`
  String get local_restore_error {
    return Intl.message(
      'Restore error',
      name: 'local_restore_error',
      desc: '',
      args: [],
    );
  }

  /// `Character created from template "{name}"`
  String character_created_from_template(Object name) {
    return Intl.message(
      'Character created from template "$name"',
      name: 'character_created_from_template',
      desc: '',
      args: [name],
    );
  }

  /// `Character "{name}" successfully exported to PDF`
  String character_exported(Object name) {
    return Intl.message(
      'Character "$name" successfully exported to PDF',
      name: 'character_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Character "{name}" imported successfully`
  String character_imported(Object name) {
    return Intl.message(
      'Character "$name" imported successfully',
      name: 'character_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Character deleted`
  String get character_deleted {
    return Intl.message(
      'Character deleted',
      name: 'character_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Race "{name}" imported successfully`
  String race_imported(Object name) {
    return Intl.message(
      'Race "$name" imported successfully',
      name: 'race_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Race deleted`
  String get race_deleted {
    return Intl.message(
      'Race deleted',
      name: 'race_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Race copied to clipboard`
  String get race_copied {
    return Intl.message(
      'Race copied to clipboard',
      name: 'race_copied',
      desc: '',
      args: [],
    );
  }

  /// `Template "{name}" exported successfully`
  String template_exported(Object name) {
    return Intl.message(
      'Template "$name" exported successfully',
      name: 'template_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Template "{name}" imported successfully`
  String template_imported(Object name) {
    return Intl.message(
      'Template "$name" imported successfully',
      name: 'template_imported',
      desc: '',
      args: [name],
    );
  }

  /// `Template deleted`
  String get template_deleted {
    return Intl.message(
      'Template deleted',
      name: 'template_deleted',
      desc: '',
      args: [],
    );
  }

  /// `PDF exported successfully`
  String get pdf_export_success {
    return Intl.message(
      'PDF exported successfully',
      name: 'pdf_export_success',
      desc: '',
      args: [],
    );
  }

  /// `Unsaved Changes`
  String get unsaved_changes_title {
    return Intl.message(
      'Unsaved Changes',
      name: 'unsaved_changes_title',
      desc: '',
      args: [],
    );
  }

  /// `You have unsaved changes. Do you want to save before exiting?`
  String get unsaved_changes_content {
    return Intl.message(
      'You have unsaved changes. Do you want to save before exiting?',
      name: 'unsaved_changes_content',
      desc: '',
      args: [],
    );
  }

  /// `Delete Character?`
  String get character_delete_title {
    return Intl.message(
      'Delete Character?',
      name: 'character_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this character? This action cannot be undone.`
  String get character_delete_confirm {
    return Intl.message(
      'Are you sure you want to delete this character? This action cannot be undone.',
      name: 'character_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete Race`
  String get race_delete_title {
    return Intl.message(
      'Delete Race',
      name: 'race_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this race?`
  String get race_delete_confirm {
    return Intl.message(
      'Are you sure you want to delete this race?',
      name: 'race_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cannot Delete Race`
  String get race_delete_error_title {
    return Intl.message(
      'Cannot Delete Race',
      name: 'race_delete_error_title',
      desc: '',
      args: [],
    );
  }

  /// `This race is used by characters. Change their race first.`
  String get race_delete_error_content {
    return Intl.message(
      'This race is used by characters. Change their race first.',
      name: 'race_delete_error_content',
      desc: '',
      args: [],
    );
  }

  /// `Delete Template`
  String get template_delete_title {
    return Intl.message(
      'Delete Template',
      name: 'template_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this template?`
  String get template_delete_confirm {
    return Intl.message(
      'Are you sure you want to delete this template?',
      name: 'template_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Template "{name}" already exists. Replace it?`
  String template_replace_confirm(Object name) {
    return Intl.message(
      'Template "$name" already exists. Replace it?',
      name: 'template_replace_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `Discard`
  String get discard_changes {
    return Intl.message(
      'Discard',
      name: 'discard_changes',
      desc: '',
      args: [],
    );
  }

  /// `It's empty here!`
  String get empty_list {
    return Intl.message(
      'It\'s empty here!',
      name: 'empty_list',
      desc: '',
      args: [],
    );
  }

  /// `No data found`
  String get no_data_found {
    return Intl.message(
      'No data found',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found for the query`
  String get nothing_found {
    return Intl.message(
      'Nothing found for the query',
      name: 'nothing_found',
      desc: '',
      args: [],
    );
  }

  /// `No characters`
  String get no_characters {
    return Intl.message(
      'No characters',
      name: 'no_characters',
      desc: '',
      args: [],
    );
  }

  /// `No races created`
  String get no_races_created {
    return Intl.message(
      'No races created',
      name: 'no_races_created',
      desc: '',
      args: [],
    );
  }

  /// `No templates`
  String get no_templates {
    return Intl.message(
      'No templates',
      name: 'no_templates',
      desc: '',
      args: [],
    );
  }

  /// `No content`
  String get no_content {
    return Intl.message(
      'No content',
      name: 'no_content',
      desc: '',
      args: [],
    );
  }

  /// `No description`
  String get no_description {
    return Intl.message(
      'No description',
      name: 'no_description',
      desc: '',
      args: [],
    );
  }

  /// `No Information`
  String get no_information {
    return Intl.message(
      'No Information',
      name: 'no_information',
      desc: '',
      args: [],
    );
  }

  /// `No race`
  String get no_race {
    return Intl.message(
      'No race',
      name: 'no_race',
      desc: '',
      args: [],
    );
  }

  /// `No images added`
  String get no_additional_images {
    return Intl.message(
      'No images added',
      name: 'no_additional_images',
      desc: '',
      args: [],
    );
  }

  /// `No folder selected`
  String get no_folder_selected {
    return Intl.message(
      'No folder selected',
      name: 'no_folder_selected',
      desc: '',
      args: [],
    );
  }

  /// `Nothing here yet`
  String get no_content_home {
    return Intl.message(
      'Nothing here yet',
      name: 'no_content_home',
      desc: '',
      args: [],
    );
  }

  /// `Create your first character or race`
  String get create_first_content {
    return Intl.message(
      'Create your first character or race',
      name: 'create_first_content',
      desc: '',
      args: [],
    );
  }

  /// `Search characters...`
  String get search_characters {
    return Intl.message(
      'Search characters...',
      name: 'search_characters',
      desc: '',
      args: [],
    );
  }

  /// `Search races...`
  String get search_race_hint {
    return Intl.message(
      'Search races...',
      name: 'search_race_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search for characters, races, notes, and templates...`
  String get search_hint {
    return Intl.message(
      'Search for characters, races, notes, and templates...',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Search characters and races...`
  String get search_home {
    return Intl.message(
      'Search characters and races...',
      name: 'search_home',
      desc: '',
      args: [],
    );
  }

  /// `All Tags`
  String get all_tags {
    return Intl.message(
      'All Tags',
      name: 'all_tags',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basic_info {
    return Intl.message(
      'Basic Information',
      name: 'basic_info',
      desc: '',
      args: [],
    );
  }

  /// `A-Z`
  String get a_to_z {
    return Intl.message(
      'A-Z',
      name: 'a_to_z',
      desc: '',
      args: [],
    );
  }

  /// `Z-A`
  String get z_to_a {
    return Intl.message(
      'Z-A',
      name: 'z_to_a',
      desc: '',
      args: [],
    );
  }

  /// `Age ↑`
  String get age_asc {
    return Intl.message(
      'Age ↑',
      name: 'age_asc',
      desc: '',
      args: [],
    );
  }

  /// `Age ↓`
  String get age_desc {
    return Intl.message(
      'Age ↓',
      name: 'age_desc',
      desc: '',
      args: [],
    );
  }

  /// `By field count (ascending)`
  String get fields_asc {
    return Intl.message(
      'By field count (ascending)',
      name: 'fields_asc',
      desc: '',
      args: [],
    );
  }

  /// `By field count (descending)`
  String get fields_desc {
    return Intl.message(
      'By field count (descending)',
      name: 'fields_desc',
      desc: '',
      args: [],
    );
  }

  /// `Last Updated`
  String get last_updated {
    return Intl.message(
      'Last Updated',
      name: 'last_updated',
      desc: '',
      args: [],
    );
  }

  /// `{years} years ago`
  String years_ago(Object years) {
    return Intl.message(
      '$years years ago',
      name: 'years_ago',
      desc: '',
      args: [years],
    );
  }

  /// `{months} months ago`
  String months_ago(Object months) {
    return Intl.message(
      '$months months ago',
      name: 'months_ago',
      desc: '',
      args: [months],
    );
  }

  /// `{days} days ago`
  String days_ago(Object days) {
    return Intl.message(
      '$days days ago',
      name: 'days_ago',
      desc: '',
      args: [days],
    );
  }

  /// `{hours} hours ago`
  String hours_ago(Object hours) {
    return Intl.message(
      '$hours hours ago',
      name: 'hours_ago',
      desc: '',
      args: [hours],
    );
  }

  /// `Just now`
  String get just_now {
    return Intl.message(
      'Just now',
      name: 'just_now',
      desc: '',
      args: [],
    );
  }

  /// `Grid view`
  String get grid_view {
    return Intl.message(
      'Grid view',
      name: 'grid_view',
      desc: '',
      args: [],
    );
  }

  /// `List view`
  String get list_view {
    return Intl.message(
      'List view',
      name: 'list_view',
      desc: '',
      args: [],
    );
  }

  /// `Detailed`
  String get detailed {
    return Intl.message(
      'Detailed',
      name: 'detailed',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get my {
    return Intl.message(
      'My',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `Create from Template`
  String get create_from_template_tooltip {
    return Intl.message(
      'Create from Template',
      name: 'create_from_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Create Template`
  String get create_template_tooltip {
    return Intl.message(
      'Create Template',
      name: 'create_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `Import Template`
  String get import_template {
    return Intl.message(
      'Import Template',
      name: 'import_template',
      desc: '',
      args: [],
    );
  }

  /// `Import Template`
  String get import_template_tooltip {
    return Intl.message(
      'Import Template',
      name: 'import_template_tooltip',
      desc: '',
      args: [],
    );
  }

  /// `From Template`
  String get from_template {
    return Intl.message(
      'From Template',
      name: 'from_template',
      desc: '',
      args: [],
    );
  }

  /// `New Character (from Template)`
  String get new_character_from_template {
    return Intl.message(
      'New Character (from Template)',
      name: 'new_character_from_template',
      desc: '',
      args: [],
    );
  }

  /// `Save Template`
  String get save_template {
    return Intl.message(
      'Save Template',
      name: 'save_template',
      desc: '',
      args: [],
    );
  }

  /// `Save Race`
  String get save_race {
    return Intl.message(
      'Save Race',
      name: 'save_race',
      desc: '',
      args: [],
    );
  }

  /// `Enter age`
  String get enter_age {
    return Intl.message(
      'Enter age',
      name: 'enter_age',
      desc: '',
      args: [],
    );
  }

  /// `Enter race name`
  String get enter_race_name {
    return Intl.message(
      'Enter race name',
      name: 'enter_race_name',
      desc: '',
      args: [],
    );
  }

  /// `Select Template File`
  String get select_template_file {
    return Intl.message(
      'Select Template File',
      name: 'select_template_file',
      desc: '',
      args: [],
    );
  }

  /// `Here's my CharacterBook backup file`
  String get share_backup_file {
    return Intl.message(
      'Here\'s my CharacterBook backup file',
      name: 'share_backup_file',
      desc: '',
      args: [],
    );
  }

  /// `Character file {name}`
  String character_share_text(Object name) {
    return Intl.message(
      'Character file $name',
      name: 'character_share_text',
      desc: '',
      args: [name],
    );
  }

  /// `Race file {name}`
  String race_share_text(Object name) {
    return Intl.message(
      'Race file $name',
      name: 'race_share_text',
      desc: '',
      args: [name],
    );
  }

  /// `Bold`
  String get markdown_bold {
    return Intl.message(
      'Bold',
      name: 'markdown_bold',
      desc: '',
      args: [],
    );
  }

  /// `Italic`
  String get markdown_italic {
    return Intl.message(
      'Italic',
      name: 'markdown_italic',
      desc: '',
      args: [],
    );
  }

  /// `Underline`
  String get markdown_underline {
    return Intl.message(
      'Underline',
      name: 'markdown_underline',
      desc: '',
      args: [],
    );
  }

  /// `Bullet List`
  String get markdown_bullet_list {
    return Intl.message(
      'Bullet List',
      name: 'markdown_bullet_list',
      desc: '',
      args: [],
    );
  }

  /// `Numbered List`
  String get markdown_numbered_list {
    return Intl.message(
      'Numbered List',
      name: 'markdown_numbered_list',
      desc: '',
      args: [],
    );
  }

  /// `Quote`
  String get markdown_quote {
    return Intl.message(
      'Quote',
      name: 'markdown_quote',
      desc: '',
      args: [],
    );
  }

  /// `Code (inline)`
  String get markdown_inline_code {
    return Intl.message(
      'Code (inline)',
      name: 'markdown_inline_code',
      desc: '',
      args: [],
    );
  }

  /// `Your collection of characters and races`
  String get home_subtitle {
    return Intl.message(
      'Your collection of characters and races',
      name: 'home_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Template already exists`
  String get template_exists {
    return Intl.message(
      'Template already exists',
      name: 'template_exists',
      desc: '',
      args: [],
    );
  }

  /// `No templates found`
  String get templates_not_found {
    return Intl.message(
      'No templates found',
      name: 'templates_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Error loading related posts`
  String get error_loading_notes {
    return Intl.message(
      'Error loading related posts',
      name: 'error_loading_notes',
      desc: '',
      args: [],
    );
  }

  /// `Random Number Generator`
  String get randomNumberGenerator {
    return Intl.message(
      'Random Number Generator',
      name: 'randomNumberGenerator',
      desc: '',
      args: [],
    );
  }

  /// `SELECT RANGE`
  String get selectRange {
    return Intl.message(
      'SELECT RANGE',
      name: 'selectRange',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Generate Number`
  String get generateNumber {
    return Intl.message(
      'Generate Number',
      name: 'generateNumber',
      desc: '',
      args: [],
    );
  }

  /// `Generating...`
  String get generating {
    return Intl.message(
      'Generating...',
      name: 'generating',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Event Calendar`
  String get event_calendar {
    return Intl.message(
      'Event Calendar',
      name: 'event_calendar',
      desc: '',
      args: [],
    );
  }

  /// `All Events`
  String get all_events {
    return Intl.message(
      'All Events',
      name: 'all_events',
      desc: '',
      args: [],
    );
  }

  /// `Character Events`
  String get character_events {
    return Intl.message(
      'Character Events',
      name: 'character_events',
      desc: '',
      args: [],
    );
  }

  /// `Race Events`
  String get race_events {
    return Intl.message(
      'Race Events',
      name: 'race_events',
      desc: '',
      args: [],
    );
  }

  /// `Note Events`
  String get note_events {
    return Intl.message(
      'Note Events',
      name: 'note_events',
      desc: '',
      args: [],
    );
  }

  /// `No events on the selected day`
  String get no_events {
    return Intl.message(
      'No events on the selected day',
      name: 'no_events',
      desc: '',
      args: [],
    );
  }

  /// `Error loading events`
  String get events_loading_error {
    return Intl.message(
      'Error loading events',
      name: 'events_loading_error',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event {
    return Intl.message(
      'Event',
      name: 'event',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Calendar View`
  String get calendar_view {
    return Intl.message(
      'Calendar View',
      name: 'calendar_view',
      desc: '',
      args: [],
    );
  }

  /// `Event Type`
  String get event_type {
    return Intl.message(
      'Event Type',
      name: 'event_type',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created {
    return Intl.message(
      'Created',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `Go to Event`
  String get go_to_event {
    return Intl.message(
      'Go to Event',
      name: 'go_to_event',
      desc: '',
      args: [],
    );
  }

  /// `Filter Events`
  String get filter_events {
    return Intl.message(
      'Filter Events',
      name: 'filter_events',
      desc: '',
      args: [],
    );
  }

  /// `Calendar Statistics`
  String get calendar_statistics {
    return Intl.message(
      'Calendar Statistics',
      name: 'calendar_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Total Events`
  String get total_events {
    return Intl.message(
      'Total Events',
      name: 'total_events',
      desc: '',
      args: [],
    );
  }

  /// `Events This Month`
  String get events_this_month {
    return Intl.message(
      'Events This Month',
      name: 'events_this_month',
      desc: '',
      args: [],
    );
  }

  /// `Events Today`
  String get events_today {
    return Intl.message(
      'Events Today',
      name: 'events_today',
      desc: '',
      args: [],
    );
  }

  /// `Activity Timeline`
  String get activity_timeline {
    return Intl.message(
      'Activity Timeline',
      name: 'activity_timeline',
      desc: '',
      args: [],
    );
  }

  /// `Template Management`
  String get template_management {
    return Intl.message(
      'Template Management',
      name: 'template_management',
      desc: '',
      args: [],
    );
  }

  /// `Tool Management`
  String get tool_management {
    return Intl.message(
      'Tool Management',
      name: 'tool_management',
      desc: '',
      args: [],
    );
  }

  /// `Create Race`
  String get create_race {
    return Intl.message(
      'Create Race',
      name: 'create_race',
      desc: '',
      args: [],
    );
  }

  /// `Import Character`
  String get import_character {
    return Intl.message(
      'Import Character',
      name: 'import_character',
      desc: '',
      args: [],
    );
  }

  /// `Recent Activity`
  String get recent_activity {
    return Intl.message(
      'Recent Activity',
      name: 'recent_activity',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get quick_actions {
    return Intl.message(
      'Quick Actions',
      name: 'quick_actions',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get view_all {
    return Intl.message(
      'View All',
      name: 'view_all',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Total: {count}`
  String total_count(Object count) {
    return Intl.message(
      'Total: $count',
      name: 'total_count',
      desc: '',
      args: [count],
    );
  }

  /// `Recently Edited`
  String get recently_edited {
    return Intl.message(
      'Recently Edited',
      name: 'recently_edited',
      desc: '',
      args: [],
    );
  }

  /// `Most Popular`
  String get most_popular {
    return Intl.message(
      'Most Popular',
      name: 'most_popular',
      desc: '',
      args: [],
    );
  }

  /// `By Race`
  String get by_race {
    return Intl.message(
      'By Race',
      name: 'by_race',
      desc: '',
      args: [],
    );
  }

  /// `By Tags`
  String get by_tags {
    return Intl.message(
      'By Tags',
      name: 'by_tags',
      desc: '',
      args: [],
    );
  }

  /// `No Recent Activity`
  String get no_recent_activity {
    return Intl.message(
      'No Recent Activity',
      name: 'no_recent_activity',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome_back {
    return Intl.message(
      'Welcome Back!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Your Collection`
  String get your_collection {
    return Intl.message(
      'Your Collection',
      name: 'your_collection',
      desc: '',
      args: [],
    );
  }

  /// `Collection Overview`
  String get collection_overview {
    return Intl.message(
      'Collection Overview',
      name: 'collection_overview',
      desc: '',
      args: [],
    );
  }

  /// `Characters: {count}`
  String characters_count(Object count) {
    return Intl.message(
      'Characters: $count',
      name: 'characters_count',
      desc: '',
      args: [count],
    );
  }

  /// `Races: {count}`
  String races_count(Object count) {
    return Intl.message(
      'Races: $count',
      name: 'races_count',
      desc: '',
      args: [count],
    );
  }

  /// `Notes: {count}`
  String notes_count(Object count) {
    return Intl.message(
      'Notes: $count',
      name: 'notes_count',
      desc: '',
      args: [count],
    );
  }

  /// `Templates: {count}`
  String templates_count(Object count) {
    return Intl.message(
      'Templates: $count',
      name: 'templates_count',
      desc: '',
      args: [count],
    );
  }

  /// `Folders: {count}`
  String folders_count(Object count) {
    return Intl.message(
      'Folders: $count',
      name: 'folders_count',
      desc: '',
      args: [count],
    );
  }

  /// `Last Created`
  String get last_created {
    return Intl.message(
      'Last Created',
      name: 'last_created',
      desc: '',
      args: [],
    );
  }

  /// `Last Edited`
  String get last_edited {
    return Intl.message(
      'Last Edited',
      name: 'last_edited',
      desc: '',
      args: [],
    );
  }

  /// `Most Edited`
  String get most_edited {
    return Intl.message(
      'Most Edited',
      name: 'most_edited',
      desc: '',
      args: [],
    );
  }

  /// `Recent Characters`
  String get recent_characters {
    return Intl.message(
      'Recent Characters',
      name: 'recent_characters',
      desc: '',
      args: [],
    );
  }

  /// `Recent Races`
  String get recent_races {
    return Intl.message(
      'Recent Races',
      name: 'recent_races',
      desc: '',
      args: [],
    );
  }

  /// `Recent Notes`
  String get recent_notes {
    return Intl.message(
      'Recent Notes',
      name: 'recent_notes',
      desc: '',
      args: [],
    );
  }

  /// `Popular Tags`
  String get popular_tags {
    return Intl.message(
      'Popular Tags',
      name: 'popular_tags',
      desc: '',
      args: [],
    );
  }

  /// `Tag Cloud`
  String get tag_cloud {
    return Intl.message(
      'Tag Cloud',
      name: 'tag_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Search Collection...`
  String get search_collection {
    return Intl.message(
      'Search Collection...',
      name: 'search_collection',
      desc: '',
      args: [],
    );
  }

  /// `Filter By`
  String get filter_by {
    return Intl.message(
      'Filter By',
      name: 'filter_by',
      desc: '',
      args: [],
    );
  }

  /// `Sort By`
  String get sort_by {
    return Intl.message(
      'Sort By',
      name: 'sort_by',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get all_categories {
    return Intl.message(
      'All Categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get archived {
    return Intl.message(
      'Archived',
      name: 'archived',
      desc: '',
      args: [],
    );
  }

  /// `Recently Viewed`
  String get recently_viewed {
    return Intl.message(
      'Recently Viewed',
      name: 'recently_viewed',
      desc: '',
      args: [],
    );
  }

  /// `Suggested Actions`
  String get suggested_actions {
    return Intl.message(
      'Suggested Actions',
      name: 'suggested_actions',
      desc: '',
      args: [],
    );
  }

  /// `Quick Create`
  String get quick_create {
    return Intl.message(
      'Quick Create',
      name: 'quick_create',
      desc: '',
      args: [],
    );
  }

  /// `Browse Templates`
  String get browse_templates {
    return Intl.message(
      'Browse Templates',
      name: 'browse_templates',
      desc: '',
      args: [],
    );
  }

  /// `Import Data`
  String get import_data {
    return Intl.message(
      'Import Data',
      name: 'import_data',
      desc: '',
      args: [],
    );
  }

  /// `Export Data`
  String get export_data {
    return Intl.message(
      'Export Data',
      name: 'export_data',
      desc: '',
      args: [],
    );
  }

  /// `Create Backup`
  String get backup_data {
    return Intl.message(
      'Create Backup',
      name: 'backup_data',
      desc: '',
      args: [],
    );
  }

  /// `Restore Data`
  String get restore_data {
    return Intl.message(
      'Restore Data',
      name: 'restore_data',
      desc: '',
      args: [],
    );
  }

  /// `App Tour`
  String get app_tour {
    return Intl.message(
      'App Tour',
      name: 'app_tour',
      desc: '',
      args: [],
    );
  }

  /// `Help and Support`
  String get help_and_support {
    return Intl.message(
      'Help and Support',
      name: 'help_and_support',
      desc: '',
      args: [],
    );
  }

  /// `Community`
  String get community {
    return Intl.message(
      'Community',
      name: 'community',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Rate App`
  String get rate_app {
    return Intl.message(
      'Rate App',
      name: 'rate_app',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get share_app {
    return Intl.message(
      'Share App',
      name: 'share_app',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get terms_of_service {
    return Intl.message(
      'Terms of Service',
      name: 'terms_of_service',
      desc: '',
      args: [],
    );
  }

  /// `Version Info`
  String get version_info {
    return Intl.message(
      'Version Info',
      name: 'version_info',
      desc: '',
      args: [],
    );
  }

  /// `Check for Updates`
  String get check_for_updates {
    return Intl.message(
      'Check for Updates',
      name: 'check_for_updates',
      desc: '',
      args: [],
    );
  }

  /// `What's New`
  String get whats_new {
    return Intl.message(
      'What\'s New',
      name: 'whats_new',
      desc: '',
      args: [],
    );
  }

  /// `Reset Settings`
  String get reset_settings {
    return Intl.message(
      'Reset Settings',
      name: 'reset_settings',
      desc: '',
      args: [],
    );
  }

  /// `Save Settings`
  String get save_settings {
    return Intl.message(
      'Save Settings',
      name: 'save_settings',
      desc: '',
      args: [],
    );
  }

  /// `Sections to Include`
  String get sections_to_include {
    return Intl.message(
      'Sections to Include',
      name: 'sections_to_include',
      desc: '',
      args: [],
    );
  }

  /// `Font Settings`
  String get font_settings {
    return Intl.message(
      'Font Settings',
      name: 'font_settings',
      desc: '',
      args: [],
    );
  }

  /// `Color Settings`
  String get color_settings {
    return Intl.message(
      'Color Settings',
      name: 'color_settings',
      desc: '',
      args: [],
    );
  }

  /// `Title Font Size`
  String get title_font_size {
    return Intl.message(
      'Title Font Size',
      name: 'title_font_size',
      desc: '',
      args: [],
    );
  }

  /// `Body Font Size`
  String get body_font_size {
    return Intl.message(
      'Body Font Size',
      name: 'body_font_size',
      desc: '',
      args: [],
    );
  }

  /// `Title Color`
  String get title_color {
    return Intl.message(
      'Title Color',
      name: 'title_color',
      desc: '',
      args: [],
    );
  }

  /// `Body Color`
  String get body_color {
    return Intl.message(
      'Body Color',
      name: 'body_color',
      desc: '',
      args: [],
    );
  }

  /// `Settings Saved`
  String get settings_saved {
    return Intl.message(
      'Settings Saved',
      name: 'settings_saved',
      desc: '',
      args: [],
    );
  }

  /// `PDF settings load error`
  String get settings_load_error {
    return Intl.message(
      'PDF settings load error',
      name: 'settings_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Font Size`
  String get font_size {
    return Intl.message(
      'Font Size',
      name: 'font_size',
      desc: '',
      args: [],
    );
  }

  /// `Color Picker`
  String get color_picker {
    return Intl.message(
      'Color Picker',
      name: 'color_picker',
      desc: '',
      args: [],
    );
  }

  /// `Export Options`
  String get export_options {
    return Intl.message(
      'Export Options',
      name: 'export_options',
      desc: '',
      args: [],
    );
  }

  /// `Page Layout`
  String get page_layout {
    return Intl.message(
      'Page Layout',
      name: 'page_layout',
      desc: '',
      args: [],
    );
  }

  /// `Page Size`
  String get page_size {
    return Intl.message(
      'Page Size',
      name: 'page_size',
      desc: '',
      args: [],
    );
  }

  /// `Page Margins`
  String get page_margins {
    return Intl.message(
      'Page Margins',
      name: 'page_margins',
      desc: '',
      args: [],
    );
  }

  /// `Include Images`
  String get include_images {
    return Intl.message(
      'Include Images',
      name: 'include_images',
      desc: '',
      args: [],
    );
  }

  /// `Image Quality`
  String get image_quality {
    return Intl.message(
      'Image Quality',
      name: 'image_quality',
      desc: '',
      args: [],
    );
  }

  /// `High Quality`
  String get high_quality {
    return Intl.message(
      'High Quality',
      name: 'high_quality',
      desc: '',
      args: [],
    );
  }

  /// `Medium Quality`
  String get medium_quality {
    return Intl.message(
      'Medium Quality',
      name: 'medium_quality',
      desc: '',
      args: [],
    );
  }

  /// `Low Quality`
  String get low_quality {
    return Intl.message(
      'Low Quality',
      name: 'low_quality',
      desc: '',
      args: [],
    );
  }

  /// `Compression`
  String get compression {
    return Intl.message(
      'Compression',
      name: 'compression',
      desc: '',
      args: [],
    );
  }

  /// `Page Orientation`
  String get page_orientation {
    return Intl.message(
      'Page Orientation',
      name: 'page_orientation',
      desc: '',
      args: [],
    );
  }

  /// `Portrait`
  String get portrait {
    return Intl.message(
      'Portrait',
      name: 'portrait',
      desc: '',
      args: [],
    );
  }

  /// `Landscape`
  String get landscape {
    return Intl.message(
      'Landscape',
      name: 'landscape',
      desc: '',
      args: [],
    );
  }

  /// `Auto Layout`
  String get auto_layout {
    return Intl.message(
      'Auto Layout',
      name: 'auto_layout',
      desc: '',
      args: [],
    );
  }

  /// `Custom Layout`
  String get custom_layout {
    return Intl.message(
      'Custom Layout',
      name: 'custom_layout',
      desc: '',
      args: [],
    );
  }

  /// `Page Numbering`
  String get page_numbering {
    return Intl.message(
      'Page Numbering',
      name: 'page_numbering',
      desc: '',
      args: [],
    );
  }

  /// `Headers and Footers`
  String get headers_footers {
    return Intl.message(
      'Headers and Footers',
      name: 'headers_footers',
      desc: '',
      args: [],
    );
  }

  /// `Table of Contents`
  String get table_of_contents {
    return Intl.message(
      'Table of Contents',
      name: 'table_of_contents',
      desc: '',
      args: [],
    );
  }

  /// `Watermark`
  String get watermark {
    return Intl.message(
      'Watermark',
      name: 'watermark',
      desc: '',
      args: [],
    );
  }

  /// `Security Options`
  String get security_options {
    return Intl.message(
      'Security Options',
      name: 'security_options',
      desc: '',
      args: [],
    );
  }

  /// `Password Protection`
  String get password_protection {
    return Intl.message(
      'Password Protection',
      name: 'password_protection',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get permissions {
    return Intl.message(
      'Permissions',
      name: 'permissions',
      desc: '',
      args: [],
    );
  }

  /// `Allow Printing`
  String get allow_printing {
    return Intl.message(
      'Allow Printing',
      name: 'allow_printing',
      desc: '',
      args: [],
    );
  }

  /// `Allow Copying`
  String get allow_copying {
    return Intl.message(
      'Allow Copying',
      name: 'allow_copying',
      desc: '',
      args: [],
    );
  }

  /// `Allow Modifications`
  String get allow_modifications {
    return Intl.message(
      'Allow Modifications',
      name: 'allow_modifications',
      desc: '',
      args: [],
    );
  }

  /// `Metadata`
  String get metadata {
    return Intl.message(
      'Metadata',
      name: 'metadata',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get author {
    return Intl.message(
      'Author',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Keywords`
  String get keywords {
    return Intl.message(
      'Keywords',
      name: 'keywords',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Settings`
  String get advanced_settings {
    return Intl.message(
      'Advanced Settings',
      name: 'advanced_settings',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Generate Sample`
  String get generate_sample {
    return Intl.message(
      'Generate Sample',
      name: 'generate_sample',
      desc: '',
      args: [],
    );
  }

  /// `Default Settings`
  String get default_settings {
    return Intl.message(
      'Default Settings',
      name: 'default_settings',
      desc: '',
      args: [],
    );
  }

  /// `Export Preset`
  String get export_preset {
    return Intl.message(
      'Export Preset',
      name: 'export_preset',
      desc: '',
      args: [],
    );
  }

  /// `Custom Preset`
  String get custom_preset {
    return Intl.message(
      'Custom Preset',
      name: 'custom_preset',
      desc: '',
      args: [],
    );
  }

  /// `Save Preset`
  String get save_preset {
    return Intl.message(
      'Save Preset',
      name: 'save_preset',
      desc: '',
      args: [],
    );
  }

  /// `Load Preset`
  String get load_preset {
    return Intl.message(
      'Load Preset',
      name: 'load_preset',
      desc: '',
      args: [],
    );
  }

  /// `Delete Preset`
  String get delete_preset {
    return Intl.message(
      'Delete Preset',
      name: 'delete_preset',
      desc: '',
      args: [],
    );
  }

  /// `Preset Name`
  String get preset_name {
    return Intl.message(
      'Preset Name',
      name: 'preset_name',
      desc: '',
      args: [],
    );
  }

  /// `Preset Saved`
  String get preset_saved {
    return Intl.message(
      'Preset Saved',
      name: 'preset_saved',
      desc: '',
      args: [],
    );
  }

  /// `Preset Loaded`
  String get preset_loaded {
    return Intl.message(
      'Preset Loaded',
      name: 'preset_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Preset Deleted`
  String get preset_deleted {
    return Intl.message(
      'Preset Deleted',
      name: 'preset_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Service creation error`
  String get service_creation_error {
    return Intl.message(
      'Service creation error',
      name: 'service_creation_error',
      desc: '',
      args: [],
    );
  }

  /// `Race service creation error`
  String get race_service_creation_error {
    return Intl.message(
      'Race service creation error',
      name: 'race_service_creation_error',
      desc: '',
      args: [],
    );
  }

  /// `Unsupported model type for PDF export`
  String get unsupported_model_type {
    return Intl.message(
      'Unsupported model type for PDF export',
      name: 'unsupported_model_type',
      desc: '',
      args: [],
    );
  }

  /// `PDF generation error`
  String get pdf_generation_error {
    return Intl.message(
      'PDF generation error',
      name: 'pdf_generation_error',
      desc: '',
      args: [],
    );
  }

  /// `Font load timeout`
  String get font_load_timeout {
    return Intl.message(
      'Font load timeout',
      name: 'font_load_timeout',
      desc: '',
      args: [],
    );
  }

  /// `PDF settings save error`
  String get settings_save_error {
    return Intl.message(
      'PDF settings save error',
      name: 'settings_save_error',
      desc: '',
      args: [],
    );
  }

  /// `Character Profile`
  String get character_profile_title {
    return Intl.message(
      'Character Profile',
      name: 'character_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Race Profile`
  String get race_profile_title {
    return Intl.message(
      'Race Profile',
      name: 'race_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `PDF creation timeout`
  String get pdf_creation_timeout {
    return Intl.message(
      'PDF creation timeout',
      name: 'pdf_creation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `PDF generation timeout`
  String get pdf_generation_timeout {
    return Intl.message(
      'PDF generation timeout',
      name: 'pdf_generation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `File sharing timeout`
  String get file_sharing_timeout {
    return Intl.message(
      'File sharing timeout',
      name: 'file_sharing_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Operation timeout`
  String get operation_timeout {
    return Intl.message(
      'Operation timeout',
      name: 'operation_timeout',
      desc: '',
      args: [],
    );
  }

  /// `PDF creation failed`
  String get pdf_creation_failed {
    return Intl.message(
      'PDF creation failed',
      name: 'pdf_creation_failed',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get timeout_error {
    return Intl.message(
      'Timeout',
      name: 'timeout_error',
      desc: '',
      args: [],
    );
  }

  /// `PDF successfully created and ready to share`
  String get export_success {
    return Intl.message(
      'PDF successfully created and ready to share',
      name: 'export_success',
      desc: '',
      args: [],
    );
  }

  /// `Race "{name}" successfully exported to PDF`
  String race_exported(Object name) {
    return Intl.message(
      'Race "$name" successfully exported to PDF',
      name: 'race_exported',
      desc: '',
      args: [name],
    );
  }

  /// `Initialization`
  String get initialization {
    return Intl.message(
      'Initialization',
      name: 'initialization',
      desc: '',
      args: [],
    );
  }

  /// `Initialization Error`
  String get initialization_error {
    return Intl.message(
      'Initialization Error',
      name: 'initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Critical Error`
  String get critical_error {
    return Intl.message(
      'Critical Error',
      name: 'critical_error',
      desc: '',
      args: [],
    );
  }

  /// `The app reset some data and settings to restore functionality`
  String get initialization_reset_warning {
    return Intl.message(
      'The app reset some data and settings to restore functionality',
      name: 'initialization_reset_warning',
      desc: '',
      args: [],
    );
  }

  /// `The app attempted to restore functionality, but some data may have been lost`
  String get critical_error_warning {
    return Intl.message(
      'The app attempted to restore functionality, but some data may have been lost',
      name: 'critical_error_warning',
      desc: '',
      args: [],
    );
  }

  /// `Understood`
  String get understood {
    return Intl.message(
      'Understood',
      name: 'understood',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Close App`
  String get close_app {
    return Intl.message(
      'Close App',
      name: 'close_app',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_text {
    return Intl.message(
      'Continue',
      name: 'continue_text',
      desc: '',
      args: [],
    );
  }

  /// `Error Details`
  String get error_details {
    return Intl.message(
      'Error Details',
      name: 'error_details',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during app initialization. Detailed technical information:`
  String get error_details_description {
    return Intl.message(
      'An error occurred during app initialization. Detailed technical information:',
      name: 'error_details_description',
      desc: '',
      args: [],
    );
  }

  /// `Technical Details`
  String get technical_details {
    return Intl.message(
      'Technical Details',
      name: 'technical_details',
      desc: '',
      args: [],
    );
  }

  /// `The app automatically attempted to restore functionality. If the error persists, try reinstalling the app.`
  String get recovery_advice {
    return Intl.message(
      'The app automatically attempted to restore functionality. If the error persists, try reinstalling the app.',
      name: 'recovery_advice',
      desc: '',
      args: [],
    );
  }

  /// `Database initialization error`
  String get hive_initialization_error {
    return Intl.message(
      'Database initialization error',
      name: 'hive_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Window manager initialization error`
  String get window_manager_initialization_error {
    return Intl.message(
      'Window manager initialization error',
      name: 'window_manager_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Data initialization error`
  String get data_initialization_error {
    return Intl.message(
      'Data initialization error',
      name: 'data_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Service initialization error`
  String get service_initialization_error {
    return Intl.message(
      'Service initialization error',
      name: 'service_initialization_error',
      desc: '',
      args: [],
    );
  }

  /// `Initialization completed successfully`
  String get initialization_success {
    return Intl.message(
      'Initialization completed successfully',
      name: 'initialization_success',
      desc: '',
      args: [],
    );
  }

  /// `Initialization failed`
  String get initialization_failed {
    return Intl.message(
      'Initialization failed',
      name: 'initialization_failed',
      desc: '',
      args: [],
    );
  }

  /// `Retry Initialization`
  String get retry_initialization {
    return Intl.message(
      'Retry Initialization',
      name: 'retry_initialization',
      desc: '',
      args: [],
    );
  }

  /// `Initializing app...`
  String get initialization_progress {
    return Intl.message(
      'Initializing app...',
      name: 'initialization_progress',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get loading_data {
    return Intl.message(
      'Loading data...',
      name: 'loading_data',
      desc: '',
      args: [],
    );
  }

  /// `Preparing services...`
  String get preparing_services {
    return Intl.message(
      'Preparing services...',
      name: 'preparing_services',
      desc: '',
      args: [],
    );
  }

  /// `Checking dependencies...`
  String get checking_dependencies {
    return Intl.message(
      'Checking dependencies...',
      name: 'checking_dependencies',
      desc: '',
      args: [],
    );
  }

  /// `Initialization timeout`
  String get initialization_timeout {
    return Intl.message(
      'Initialization timeout',
      name: 'initialization_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Initialization took too long. Check your internet connection and try again.`
  String get initialization_timeout_message {
    return Intl.message(
      'Initialization took too long. Check your internet connection and try again.',
      name: 'initialization_timeout_message',
      desc: '',
      args: [],
    );
  }

  /// `Warning: Low device storage`
  String get low_storage_warning {
    return Intl.message(
      'Warning: Low device storage',
      name: 'low_storage_warning',
      desc: '',
      args: [],
    );
  }

  /// `Your device is running low on storage. This may affect the app's performance.`
  String get low_storage_message {
    return Intl.message(
      'Your device is running low on storage. This may affect the app\'s performance.',
      name: 'low_storage_message',
      desc: '',
      args: [],
    );
  }

  /// `Permission Required`
  String get permission_required {
    return Intl.message(
      'Permission Required',
      name: 'permission_required',
      desc: '',
      args: [],
    );
  }

  /// `The app requires storage permission to function.`
  String get storage_permission_message {
    return Intl.message(
      'The app requires storage permission to function.',
      name: 'storage_permission_message',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get grant_permission {
    return Intl.message(
      'Grant Permission',
      name: 'grant_permission',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip_for_now {
    return Intl.message(
      'Skip',
      name: 'skip_for_now',
      desc: '',
      args: [],
    );
  }

  /// `Initialization Complete`
  String get initialization_complete {
    return Intl.message(
      'Initialization Complete',
      name: 'initialization_complete',
      desc: '',
      args: [],
    );
  }

  /// `App is ready to use`
  String get ready_to_use {
    return Intl.message(
      'App is ready to use',
      name: 'ready_to_use',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to CharacterBook!`
  String get welcome_message {
    return Intl.message(
      'Welcome to CharacterBook!',
      name: 'welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Configuring environment...`
  String get configuring_environment {
    return Intl.message(
      'Configuring environment...',
      name: 'configuring_environment',
      desc: '',
      args: [],
    );
  }

  /// `Loading resources...`
  String get loading_resources {
    return Intl.message(
      'Loading resources...',
      name: 'loading_resources',
      desc: '',
      args: [],
    );
  }

  /// `Verifying integrity...`
  String get verifying_integrity {
    return Intl.message(
      'Verifying integrity...',
      name: 'verifying_integrity',
      desc: '',
      args: [],
    );
  }

  /// `Migrating data...`
  String get migration_in_progress {
    return Intl.message(
      'Migrating data...',
      name: 'migration_in_progress',
      desc: '',
      args: [],
    );
  }

  /// `Creating backup...`
  String get backup_creation {
    return Intl.message(
      'Creating backup...',
      name: 'backup_creation',
      desc: '',
      args: [],
    );
  }

  /// `Clearing cache...`
  String get cache_clearing {
    return Intl.message(
      'Clearing cache...',
      name: 'cache_clearing',
      desc: '',
      args: [],
    );
  }

  /// `Optimizing performance...`
  String get optimizing_performance {
    return Intl.message(
      'Optimizing performance...',
      name: 'optimizing_performance',
      desc: '',
      args: [],
    );
  }

  /// `Finalizing setup...`
  String get finalizing_setup {
    return Intl.message(
      'Finalizing setup...',
      name: 'finalizing_setup',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
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
