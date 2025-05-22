# Money Trail - Project Architecture

This document outlines the project structure, features, and backend integration for the Flutter-based Money Trail app.

---

## 🔧 Directory Structure

```plaintext
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   └── validators.dart
│   │   └── helpers.dart
│   └── services/
│       └── auth_service.dart
│       └── expense_service.dart
│       └── ocr_service.dart
│       └── voice_service.dart
│       └── api_client.dart
├── models/
│   └── user_model.dart
│   └── expense_model.dart
│   └── invoice_model.dart
├── providers/
│   └── auth_provider.dart
│   └── expense_provider.dart
├── views/
│   ├── auth/
│   │   └── login_screen.dart
│   │   └── signup_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   │   └── expense_summary_card.dart
│   │   └── charts_widget.dart
│   ├── expenses/
│   │   └── manual_entry_screen.dart
│   │   └── voice_note_entry_screen.dart
│   │   └── receipt_upload_screen.dart
│   │   └── history_screen.dart
│   ├── insights/
│   │   └── budget_screen.dart
│   │   └── charts_screen.dart
│   └── common/
│       └── custom_button.dart
│       └── expense_card.dart
│       └── input_field.dart
├── routes/
│   └── app_routes.dart
└── config/
    └── env_config.dart
