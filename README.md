[![Flutter](https://img.shields.io/badge/Flutter-3.41.9-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat)](LICENSE)

# 🎭 CharacterBook

**Cross‑platform app for creating and managing characters in tabletop RPGs.**

Want to keep all your player characters and NPCs organised in one place? CharacterBook helps you quickly build detailed characters using flexible templates, sort them into folders and tags, and then export them as beautiful PDF sheets.

[![Google Play](https://img.shields.io/badge/Get_it_on_Google_Play-414141?style=flat&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters&hl)
[![Microsoft Store](https://img.shields.io/badge/Get_it_on_Microsoft_Store-0078D6?style=flat&logo=microsoft&logoColor=white)](https://apps.microsoft.com/detail/9NKV4DBQJW0S)
[![GitHub Release](https://img.shields.io/badge/Download_on_GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/maxgog/characterbook/releases)

## ✨ Key Features

*   **🎲 Flexible character creation:** Use built‑in templates (D&D 5e, universal) or build your own with the template constructor!
*   **🗂️ Smart organisation:** Organise characters, races, and notes with tags, then use search to find them quickly.
*   **🔗 Share your content:** Share characters, races, notes, and templates as files or copy their content; export characters and races to PDF or Word.
*   **📄 Export to PDF and Word:** Turn characters and races into ready‑to‑print sheets (PDF), and characters, races, and templates into editable documents (DOCX).
*   **💾 Backups:** Export or restore all app data using a local file or Google Drive, with optional automatic cloud backups.
*   **📱 Cross‑platform:** The app works seamlessly on Android, Windows, and macOS. Web and iOS versions are in development.
*   **💯 Free and ad‑free:** All features are available without any limitations or hidden fees.

## 🚀 Quick Start

### 📥 For Users

Simply download the app from your preferred store:

| Platform | Link |
| :--- | :--- |
| **Android** | [Google Play](https://play.google.com/store/apps/details?id=ru.maxgog.listcharacters&hl) or [RuStore](https://www.rustore.ru/catalog/app/ru.maxgog.listcharacters) |
| **Windows** | [Microsoft Store](https://apps.microsoft.com/detail/9NKV4DBQJW0S) or [GitHub Releases](https://github.com/maxgog/characterbook/releases) |
| **macOS** | [GitHub Releases](https://github.com/maxgog/characterbook/releases) *(beta)* |

### 🛠️ For Developers

To build and run the project locally:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/maxgog/characterbook.git
    cd characterbook
    ```
2.  **Install dependencies:**
    ```bash
    fvm install
    fvm flutter pub get
    ```
3.  **Run the app:**
    ```bash
    fvm flutter run
    ```

> For detailed information, see our [installation guide](docs/INSTALLATION.md).

## 🧱 Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/) (3.41.9; pinned in `.fvmrc`).
*   **Language:** [Dart](https://dart.dev/) (3.7+).
*   **Database:** [Hive](https://docs.hivedb.dev/) for fast local storage.
*   **State management:** `Provider` and `flutter_bloc`.
*   **Document generation:** `pdf`, `printing`, and `docs_gee` for creating PDF and DOCX files.

For a full list of dependencies and architectural details, refer to the [ARCHITECTURE.md](docs/ARCHITECTURE.md) file.

## 👥 Contributing

We welcome any suggestions and help in developing the project! Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) for information on how to report bugs, suggest improvements, and submit Pull Requests.

## ⚖️ License

Distributed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for details.

## 💖 Support the Project

If you like CharacterBook, you can support its developer:

[![Boosty](https://img.shields.io/badge/Boosty-FF6B6B?style=flat&logo=heart&logoColor=white)](https://boosty.to/maxupshur/donate)

## 📞 Contacts

*   **Author:** Max Upshur (Максим Гоглов)
*   **Email:** max.gog2005@outlook.com
*   **GitHub:** [maxgog](https://github.com/maxgog)