// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(name) => "Character created from template \"${name}\"";

  static String m1(name) => "Character \"${name}\" exported successfully";

  static String m2(name) => "Character \"${name}\" imported successfully";

  static String m3(name) => "Character file ${name}";

  static String m4(charactersCount, notesCount, racesCount, templatesCount,
          foldersCount) =>
      "Successfully restored:\n${charactersCount} characters\n${notesCount} notes\n${racesCount} races\n${templatesCount} templates\n${foldersCount} folders";

  static String m5(days) => "${days} days ago";

  static String m6(count) => "${count} fields";

  static String m7(hours) => "${hours} hours ago";

  static String m8(error) => "Image selection error: ${error}";

  static String m9(error) => "Import error: ${error}";

  static String m10(months) => "${months} months ago";

  static String m11(count) => "${count} more";

  static String m12(name) => "Race \"${name}\" imported successfully";

  static String m13(name) => "Race file ${name}";

  static String m14(name) => "Template \"${name}\" exported successfully";

  static String m15(name) => "Template \"${name}\" imported successfully";

  static String m16(name) => "Template \"${name}\" already exists. Replace it?";

  static String m17(years) => "${years} years ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "a_to_z": MessageLookupByLibrary.simpleMessage("A-Z"),
        "abilities": MessageLookupByLibrary.simpleMessage("Abilities"),
        "aboutApp": MessageLookupByLibrary.simpleMessage("About App"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Accent Color"),
        "acknowledgements":
            MessageLookupByLibrary.simpleMessage("Acknowledgements"),
        "add_field": MessageLookupByLibrary.simpleMessage("Add field"),
        "add_picture": MessageLookupByLibrary.simpleMessage("Add Image"),
        "add_tag": MessageLookupByLibrary.simpleMessage("Add Tag"),
        "additional_images":
            MessageLookupByLibrary.simpleMessage("Additional Images"),
        "adults": MessageLookupByLibrary.simpleMessage("Adults"),
        "age": MessageLookupByLibrary.simpleMessage("Age"),
        "age_asc": MessageLookupByLibrary.simpleMessage("Age ↑"),
        "age_desc": MessageLookupByLibrary.simpleMessage("Age ↓"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "all_tags": MessageLookupByLibrary.simpleMessage("All Tags"),
        "another": MessageLookupByLibrary.simpleMessage("Other"),
        "appLanguage": MessageLookupByLibrary.simpleMessage("App Language"),
        "app_name": MessageLookupByLibrary.simpleMessage("CharacterBook"),
        "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
        "auth_cancelled":
            MessageLookupByLibrary.simpleMessage("Authorization cancelled"),
        "auth_client_error":
            MessageLookupByLibrary.simpleMessage("Failed to get API client"),
        "avatar_crop_save": MessageLookupByLibrary.simpleMessage("Save Crop"),
        "avatar_crop_title":
            MessageLookupByLibrary.simpleMessage("Avatar Cropping"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "backstory": MessageLookupByLibrary.simpleMessage("Backstory"),
        "backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "backup_options":
            MessageLookupByLibrary.simpleMessage("Backup Options"),
        "backup_to_cloud":
            MessageLookupByLibrary.simpleMessage("Backup to Cloud"),
        "backup_to_file":
            MessageLookupByLibrary.simpleMessage("Backup to File"),
        "basic_info": MessageLookupByLibrary.simpleMessage("Basic Info"),
        "biography": MessageLookupByLibrary.simpleMessage("Biography"),
        "biology": MessageLookupByLibrary.simpleMessage("Biology"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "character": MessageLookupByLibrary.simpleMessage("Character"),
        "character_avatar":
            MessageLookupByLibrary.simpleMessage("Character Avatar"),
        "character_created_from_template": m0,
        "character_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this character? This action cannot be undone."),
        "character_delete_title":
            MessageLookupByLibrary.simpleMessage("Delete Character?"),
        "character_deleted":
            MessageLookupByLibrary.simpleMessage("Character deleted"),
        "character_exported": m1,
        "character_gallery":
            MessageLookupByLibrary.simpleMessage("Character Gallery"),
        "character_imported": m2,
        "character_management":
            MessageLookupByLibrary.simpleMessage("Character Management"),
        "character_reference":
            MessageLookupByLibrary.simpleMessage("Character Reference"),
        "character_share_text": m3,
        "characterbookLicense": MessageLookupByLibrary.simpleMessage(
            "CharacterBook License (GNU GPL v3.0)"),
        "characters": MessageLookupByLibrary.simpleMessage("Characters"),
        "children": MessageLookupByLibrary.simpleMessage("Children"),
        "cloud_backup_characters_error": MessageLookupByLibrary.simpleMessage(
            "Error creating characters backup"),
        "cloud_backup_characters_success": MessageLookupByLibrary.simpleMessage(
            "Characters backup created successfully"),
        "cloud_backup_error":
            MessageLookupByLibrary.simpleMessage("Backup Error"),
        "cloud_backup_full_success": MessageLookupByLibrary.simpleMessage(
            "Full backup successfully created in Google Drive"),
        "cloud_backup_not_found":
            MessageLookupByLibrary.simpleMessage("No backups found"),
        "cloud_backup_success":
            MessageLookupByLibrary.simpleMessage("Backup created successfully"),
        "cloud_export_error":
            MessageLookupByLibrary.simpleMessage("Google Drive export error"),
        "cloud_import_error":
            MessageLookupByLibrary.simpleMessage("Google Drive import error"),
        "cloud_restore_error":
            MessageLookupByLibrary.simpleMessage("Restore Error"),
        "cloud_restore_success": m4,
        "colorScheme": MessageLookupByLibrary.simpleMessage("Color Scheme"),
        "color_blue": MessageLookupByLibrary.simpleMessage("Blue"),
        "color_brown": MessageLookupByLibrary.simpleMessage("Brown"),
        "color_dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "color_green": MessageLookupByLibrary.simpleMessage("Green"),
        "color_grey": MessageLookupByLibrary.simpleMessage("Grey"),
        "color_orange": MessageLookupByLibrary.simpleMessage("Orange"),
        "color_pink": MessageLookupByLibrary.simpleMessage("Pink"),
        "color_purple": MessageLookupByLibrary.simpleMessage("Purple"),
        "color_red": MessageLookupByLibrary.simpleMessage("Red"),
        "color_teal": MessageLookupByLibrary.simpleMessage("Teal"),
        "copied_to_clipboard":
            MessageLookupByLibrary.simpleMessage("Copied to clipboard"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "copy_character":
            MessageLookupByLibrary.simpleMessage("Copy Character"),
        "copy_error": MessageLookupByLibrary.simpleMessage("Copy Error"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createBackup": MessageLookupByLibrary.simpleMessage("Create Backup"),
        "create_first_content": MessageLookupByLibrary.simpleMessage(
            "Create your first character or race"),
        "create_from_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Create from Template"),
        "create_template":
            MessageLookupByLibrary.simpleMessage("Create Template"),
        "create_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Create Template"),
        "creatingBackup": MessageLookupByLibrary.simpleMessage("Create Backup"),
        "creating_file":
            MessageLookupByLibrary.simpleMessage("Creating file..."),
        "creating_pdf": MessageLookupByLibrary.simpleMessage("Creating PDF..."),
        "custom": MessageLookupByLibrary.simpleMessage("custom"),
        "custom_fields": MessageLookupByLibrary.simpleMessage("Custom Fields"),
        "custom_fields_editor_title":
            MessageLookupByLibrary.simpleMessage("Custom Fields"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "days_ago": m5,
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "delete_character":
            MessageLookupByLibrary.simpleMessage("Delete Character"),
        "delete_error": MessageLookupByLibrary.simpleMessage("Delete Error"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "detailed": MessageLookupByLibrary.simpleMessage("Detailed"),
        "developer": MessageLookupByLibrary.simpleMessage("Developer"),
        "discard_changes": MessageLookupByLibrary.simpleMessage("Discard"),
        "dnd_tools": MessageLookupByLibrary.simpleMessage("D&D Tools"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "edit_character":
            MessageLookupByLibrary.simpleMessage("Edit Character"),
        "edit_folder": MessageLookupByLibrary.simpleMessage("Edit Folder"),
        "edit_race": MessageLookupByLibrary.simpleMessage("Edit Race"),
        "edit_template": MessageLookupByLibrary.simpleMessage("Edit Template"),
        "elderly": MessageLookupByLibrary.simpleMessage("Elderly"),
        "empty_file_error":
            MessageLookupByLibrary.simpleMessage("The selected file is empty"),
        "empty_list": MessageLookupByLibrary.simpleMessage("It\'s empty here!"),
        "enter_age": MessageLookupByLibrary.simpleMessage("Enter age"),
        "enter_race_name":
            MessageLookupByLibrary.simpleMessage("Enter race name"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "error_loading_notes":
            MessageLookupByLibrary.simpleMessage("Error loading related posts"),
        "export": MessageLookupByLibrary.simpleMessage("Export"),
        "export_error": MessageLookupByLibrary.simpleMessage("Export Error"),
        "female": MessageLookupByLibrary.simpleMessage("Female"),
        "field_name": MessageLookupByLibrary.simpleMessage("Field Name"),
        "field_name_hint":
            MessageLookupByLibrary.simpleMessage("Enter field name"),
        "field_value": MessageLookupByLibrary.simpleMessage("Field Value"),
        "field_value_hint":
            MessageLookupByLibrary.simpleMessage("Enter field value"),
        "fields_asc":
            MessageLookupByLibrary.simpleMessage("By field count (ascending)"),
        "fields_count": m6,
        "fields_desc":
            MessageLookupByLibrary.simpleMessage("By field count (descending)"),
        "file_character":
            MessageLookupByLibrary.simpleMessage("File (.character)"),
        "file_pdf": MessageLookupByLibrary.simpleMessage("PDF Document (.pdf)"),
        "file_pick_error":
            MessageLookupByLibrary.simpleMessage("File selection error"),
        "file_ready":
            MessageLookupByLibrary.simpleMessage("File ready to send"),
        "flutterLicense":
            MessageLookupByLibrary.simpleMessage("Flutter License"),
        "folder": MessageLookupByLibrary.simpleMessage("Folder"),
        "folder_color": MessageLookupByLibrary.simpleMessage("Folder Color"),
        "folder_name": MessageLookupByLibrary.simpleMessage("Folder Name"),
        "folders": MessageLookupByLibrary.simpleMessage("Folders"),
        "from_template": MessageLookupByLibrary.simpleMessage("From Template"),
        "gender": MessageLookupByLibrary.simpleMessage("Gender"),
        "githubRepo": MessageLookupByLibrary.simpleMessage("GitHub Repository"),
        "grid_view": MessageLookupByLibrary.simpleMessage("Grid view"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "home_subtitle": MessageLookupByLibrary.simpleMessage(
            "Your collection of characters and races"),
        "hours_ago": m7,
        "image": MessageLookupByLibrary.simpleMessage("Image"),
        "image_picker_error": m8,
        "import": MessageLookupByLibrary.simpleMessage("Import"),
        "import_cancelled":
            MessageLookupByLibrary.simpleMessage("Import cancelled"),
        "import_error": m9,
        "import_race": MessageLookupByLibrary.simpleMessage("Import Race"),
        "import_template":
            MessageLookupByLibrary.simpleMessage("Import Template"),
        "import_template_tooltip":
            MessageLookupByLibrary.simpleMessage("Import Template"),
        "invalid_age":
            MessageLookupByLibrary.simpleMessage("Invalid age entered"),
        "items": MessageLookupByLibrary.simpleMessage("items"),
        "just_now": MessageLookupByLibrary.simpleMessage("Just now"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "last_updated": MessageLookupByLibrary.simpleMessage("Last Updated"),
        "licenses": MessageLookupByLibrary.simpleMessage("Licenses"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "list_view": MessageLookupByLibrary.simpleMessage("List view"),
        "local_backup_error":
            MessageLookupByLibrary.simpleMessage("Backup error"),
        "local_backup_success":
            MessageLookupByLibrary.simpleMessage("Backup created successfully"),
        "local_restore_error":
            MessageLookupByLibrary.simpleMessage("Restore error"),
        "local_restore_success": MessageLookupByLibrary.simpleMessage(
            "Restore completed successfully"),
        "main_image": MessageLookupByLibrary.simpleMessage("Main Image"),
        "male": MessageLookupByLibrary.simpleMessage("Male"),
        "markdown_bold": MessageLookupByLibrary.simpleMessage("Bold"),
        "markdown_bullet_list":
            MessageLookupByLibrary.simpleMessage("Bullet List"),
        "markdown_inline_code":
            MessageLookupByLibrary.simpleMessage("Code (inline)"),
        "markdown_italic": MessageLookupByLibrary.simpleMessage("Italic"),
        "markdown_numbered_list":
            MessageLookupByLibrary.simpleMessage("Numbered List"),
        "markdown_quote": MessageLookupByLibrary.simpleMessage("Quote"),
        "markdown_underline": MessageLookupByLibrary.simpleMessage("Underline"),
        "months_ago": m10,
        "more_fields": m11,
        "more_options": MessageLookupByLibrary.simpleMessage("More Options"),
        "my": MessageLookupByLibrary.simpleMessage("My"),
        "my_characters": MessageLookupByLibrary.simpleMessage("My Characters"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "new_character": MessageLookupByLibrary.simpleMessage("New Character"),
        "new_character_from_template": MessageLookupByLibrary.simpleMessage(
            "New Character (from Template)"),
        "new_folder": MessageLookupByLibrary.simpleMessage("New Folder"),
        "new_race": MessageLookupByLibrary.simpleMessage("New Race"),
        "new_template": MessageLookupByLibrary.simpleMessage("New Template"),
        "no_additional_images":
            MessageLookupByLibrary.simpleMessage("No images added"),
        "no_characters": MessageLookupByLibrary.simpleMessage("No characters"),
        "no_content": MessageLookupByLibrary.simpleMessage("No content"),
        "no_content_home":
            MessageLookupByLibrary.simpleMessage("Nothing here yet"),
        "no_custom_fields":
            MessageLookupByLibrary.simpleMessage("No custom fields added"),
        "no_data_found": MessageLookupByLibrary.simpleMessage("No data found"),
        "no_description":
            MessageLookupByLibrary.simpleMessage("No description"),
        "no_folder_selected":
            MessageLookupByLibrary.simpleMessage("No folder selected"),
        "no_information":
            MessageLookupByLibrary.simpleMessage("No Information"),
        "no_race": MessageLookupByLibrary.simpleMessage("No race"),
        "no_races_created":
            MessageLookupByLibrary.simpleMessage("No races created"),
        "no_templates": MessageLookupByLibrary.simpleMessage("No templates"),
        "none": MessageLookupByLibrary.simpleMessage("None"),
        "not_selected": MessageLookupByLibrary.simpleMessage("Not selected"),
        "nothing_found":
            MessageLookupByLibrary.simpleMessage("Nothing found for the query"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "operationCompleted": MessageLookupByLibrary.simpleMessage(
            "Operation completed successfully"),
        "other": MessageLookupByLibrary.simpleMessage("Other"),
        "pdf_export_success":
            MessageLookupByLibrary.simpleMessage("PDF exported successfully"),
        "personality": MessageLookupByLibrary.simpleMessage("Personality"),
        "posts": MessageLookupByLibrary.simpleMessage("Posts"),
        "processing": MessageLookupByLibrary.simpleMessage("Loading..."),
        "race": MessageLookupByLibrary.simpleMessage("Race"),
        "race_copied":
            MessageLookupByLibrary.simpleMessage("Race copied to clipboard"),
        "race_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this race?"),
        "race_delete_error_content": MessageLookupByLibrary.simpleMessage(
            "This race is used by characters. Change their race first."),
        "race_delete_error_title":
            MessageLookupByLibrary.simpleMessage("Cannot Delete Race"),
        "race_delete_title":
            MessageLookupByLibrary.simpleMessage("Delete Race"),
        "race_deleted": MessageLookupByLibrary.simpleMessage("Race deleted"),
        "race_imported": m12,
        "race_management":
            MessageLookupByLibrary.simpleMessage("Race Management"),
        "race_share_text": m13,
        "races": MessageLookupByLibrary.simpleMessage("Races"),
        "reference_image": MessageLookupByLibrary.simpleMessage("Reference"),
        "related_notes": MessageLookupByLibrary.simpleMessage("Related Posts"),
        "replace": MessageLookupByLibrary.simpleMessage("Replace"),
        "required_field_error":
            MessageLookupByLibrary.simpleMessage("Required field"),
        "restoreData": MessageLookupByLibrary.simpleMessage("Restore Data"),
        "restore_from_cloud":
            MessageLookupByLibrary.simpleMessage("Restore from Cloud"),
        "restore_from_file":
            MessageLookupByLibrary.simpleMessage("Restore from File"),
        "restore_options":
            MessageLookupByLibrary.simpleMessage("Restore Options"),
        "restoringBackup":
            MessageLookupByLibrary.simpleMessage("Restore from Backup"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "save_error": MessageLookupByLibrary.simpleMessage("Save Error"),
        "save_race": MessageLookupByLibrary.simpleMessage("Save Race"),
        "save_template": MessageLookupByLibrary.simpleMessage("Save Template"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "search_characters":
            MessageLookupByLibrary.simpleMessage("Search characters..."),
        "search_hint": MessageLookupByLibrary.simpleMessage(
            "Search for characters, races, notes, and templates..."),
        "search_home": MessageLookupByLibrary.simpleMessage(
            "Search characters and races..."),
        "search_race_hint":
            MessageLookupByLibrary.simpleMessage("Search races..."),
        "select": MessageLookupByLibrary.simpleMessage("Selected"),
        "select_character":
            MessageLookupByLibrary.simpleMessage("Select Character"),
        "select_folder": MessageLookupByLibrary.simpleMessage("Select Folder"),
        "select_gender_error":
            MessageLookupByLibrary.simpleMessage("Select gender"),
        "select_race_error":
            MessageLookupByLibrary.simpleMessage("Select race"),
        "select_template":
            MessageLookupByLibrary.simpleMessage("Select Template"),
        "select_template_file":
            MessageLookupByLibrary.simpleMessage("Select Template File"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "share_backup_file": MessageLookupByLibrary.simpleMessage(
            "Here\'s my CharacterBook backup file"),
        "share_character":
            MessageLookupByLibrary.simpleMessage("Share Character"),
        "short_name": MessageLookupByLibrary.simpleMessage("Short Name"),
        "standard": MessageLookupByLibrary.simpleMessage("standard"),
        "standard_fields":
            MessageLookupByLibrary.simpleMessage("Standard Fields"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "template": MessageLookupByLibrary.simpleMessage("Template"),
        "template_delete_confirm": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this template?"),
        "template_delete_title":
            MessageLookupByLibrary.simpleMessage("Delete Template"),
        "template_deleted":
            MessageLookupByLibrary.simpleMessage("Template deleted"),
        "template_exists":
            MessageLookupByLibrary.simpleMessage("Template already exists"),
        "template_exported": m14,
        "template_imported": m15,
        "template_name_label":
            MessageLookupByLibrary.simpleMessage("Template Name"),
        "template_replace_confirm": m16,
        "templates": MessageLookupByLibrary.simpleMessage("Templates"),
        "templates_not_found":
            MessageLookupByLibrary.simpleMessage("No templates found"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "unsaved_changes_content": MessageLookupByLibrary.simpleMessage(
            "You have unsaved changes. Do you want to save before exiting?"),
        "unsaved_changes_title":
            MessageLookupByLibrary.simpleMessage("Unsaved Changes"),
        "usedLibraries": MessageLookupByLibrary.simpleMessage("Used Libraries"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "web_not_supported":
            MessageLookupByLibrary.simpleMessage("Not available for web"),
        "years": MessageLookupByLibrary.simpleMessage("years"),
        "years_ago": m17,
        "young": MessageLookupByLibrary.simpleMessage("Young"),
        "z_to_a": MessageLookupByLibrary.simpleMessage("Z-A")
      };
}
