# Money Trail - Development Task List

This task list follows the flow a user experiences in the app.

---

## 🌐 API Overview

> ⚠️ Base URL is TBD (Backend not yet hosted)

### Authentication (JWT-based, 30-day token expiry)

| Endpoint              | Method | Description               |
|-----------------------|--------|---------------------------|
| `/api/auth/signup`    | POST   | Register new user         |
| `/api/auth/login`     | POST   | Authenticate user         |

### Expenses

| Endpoint                        | Method | Description                           |
|---------------------------------|--------|---------------------------------------|
| `/api/expenses`                 | POST   | Submit expense (manual or confirmed)  |
| `/api/expenses/history`         | GET    | Fetch all past expenses               |
| `/api/expenses/process-text`    | POST   | NLP from voice-transcribed text       |
| `/api/expenses/upload-image`    | POST   | OCR on receipt image (Gemini Flash)   |

> Additional endpoints for budgeting/insights will be added later.

#### Auth Header Format

    Authorization: Bearer <JWT>

---

## 🧰 Initial Setup

- [ ] Setup Flutter project and directory structure
- [ ] Add dependencies: `provider`, `http`, `image_picker`, `charts_flutter`, `file_picker`, etc.
- [ ] Create `.env` config for base URL placeholder

---

## 🔐 1. Sign-Up Screen

- [ ] UI for email and password input
- [ ] Form validation and error states
- [ ] Call `POST /api/auth/signup`
- [ ] Show error for duplicate user

---

## 🔑 2. Login Screen

- [ ] JWT-based login via `POST /api/auth/login`
- [ ] Store JWT securely
- [ ] Navigate to dashboard on success
- [ ] Handle login failure

---

## 🏠 3. Dashboard Screen

- [ ] Fetch monthly total and recent expenses
- [ ] Show pie/bar chart with category-wise breakdown
- [ ] Display expense summary cards

---

## 🧾 4. Manual Expense Entry

- [ ] Input fields: amount, shop, category, date
- [ ] Submit via `POST /api/expenses`
- [ ] Confirm and notify on success

---

## 🎙️ 5. Voice Note Entry

- [ ] Record/upload audio (limit 3MB)
- [ ] Transcribe to text (frontend library)
- [ ] Send text to `POST /api/expenses/process-text`
- [ ] Display extracted data, allow edit/confirmation
- [ ] Save expense via `/api/expenses`

---

## 🖼️ 6. Receipt Upload

- [ ] Upload/preview image (limit 5MB)
- [ ] Send image to `POST /api/expenses/upload-image`
- [ ] Show extracted data
- [ ] Redirect to manual entry if failure
- [ ] Save confirmed data via `/api/expenses`

---

## 📜 7. Expense History Screen

- [ ] Fetch data from `/api/expenses/history`
- [ ] Display in reverse chronological order
- [ ] Use reusable `ExpenseCard` widget

---

## 💹 8. Budget/Insights Screen

- [ ] Set/edit monthly budget
- [ ] View total vs. limit in bar chart
- [ ] Aggregate yearly trends (optional API to be added)

---

## 🧪 Final Steps

- [ ] Global error UI for API failures
- [ ] State management via Provider
- [ ] Secure storage of JWT
- [ ] Full test on Android and iOS
- [ ] App build for deployment




## 📂 Default Categories (Customizable)
Default categories can include:
- Groceries
- Dining
- Transport
- Utilities
- Entertainment
- Health
- Rent
- Education
- Shopping
- Miscellaneous

Users may be allowed to customize these in future updates.





# 🗃️ Database Schema Overview

This file summarizes the structure of the schemas used in the Money Trail backend.

---

## 👤 User Schema

- **username**: *String*, unique, used as email  
- **password**: *String*, hashed via bcrypt

---

## 💸 Expense Schema

- **amount**: *Number* (required)  
- **shop_name**: *String* (required)  
- **purpose**: *String* (required)  
- **timestamp**: *Date*  
- **input_method**: *Enum* — one of `manual`, `image`, `text`  
- **created_at**: *Date* (auto-generated)

---

## 🧾 Invoice Schema

- **image_path**: *String* (required)  
- **extracted_text**: *String*  
- **processed_at**: *Date* (auto-generated)



## 🧾 Upload Limits (Recommended)
Receipt image size: Max 5MB (.jpg, .png)
Voice audio size: Max 3MB (.mp3, .wav, ~30 seconds duration)
