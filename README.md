# GST Billing App

A Flutter-based **GST Billing App** developed for **TATA Retail Solutions** to automate tax calculations, simplify invoice generation, and maintain sales records.  
The app eliminates manual errors, speeds up the billing process, ensures GST compliance, and offers a scalable solution for retail operations.

---

## ✨ Features

- 🚀 **Automated GST Calculation** (5%, 12%, 18%, 28%)
- 🧲 **Itemized Invoice Generation** with CGST, SGST, and Total
- 🛆 **Product Catalog Management** (Add/Edit/Delete products)
- 🧱 **Real-time GST Breakdown** (CGST + SGST)
- 📒 **Transaction History** for record keeping
- 🔍 **Searchable Database** of products and past invoices
- 📱 **Simple, Intuitive UI** for fast billing during peak hours
- 🛡️ **Compliance with Indian GST Regulations**
- 🔧 **Offline Data Persistence** using SQLite

---

## 💂 Project Structure

```plaintext
lib/
├── models/
│   ├── invoice.dart
│   └── product.dart
│
├── providers/
│   ├── billing_provider.dart
│   └── product_catalog_provider.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── invoice_screen.dart
│   ├── product_catalog_screen.dart
│   └── transaction_history_screen.dart
│
├── utils/
│   ├── database_helper.dart
│   └── gst_calculator.dart
│
├── widgets/
│   ├── invoice_detail.dart
│   ├── product_form.dart
│   ├── product_list.dart
│   └── summary_card.dart
│
└── main.dart
```

---

## 🧴 GST Calculation Logic

For each product:

- **CGST** = (Price × GST%) ÷ 2
- **SGST** = (Price × GST%) ÷ 2
- **Total Price** = Price + CGST + SGST

Example for 18% GST:

```
CGST = (Price × 18%) ÷ 2 = Price × 9%
SGST = (Price × 18%) ÷ 2 = Price × 9%
Total = Price + CGST + SGST
```

✅ GST rates supported: **5%**, **12%**, **18%**, **28%**

---

## 🔧 Tech Stack

- **Flutter** (Frontend & UI)
- **Provider** (State Management)
- **SQLite** (Local Data Persistence)
- **Dart** (Programming Language)

---
## 📸 Screenshots
<p align="center">
  <img src="https://github.com/user-attachments/assets/8fb56992-1513-49a8-b6a0-ac79b2be75e4" alt="Screenshot 1" width="200" />
  <img src="https://github.com/user-attachments/assets/d7c74577-092a-4ca3-8978-38a9772deb23" alt="Screenshot 2" width="200" />
  <img src="https://github.com/user-attachments/assets/40454619-5bc1-429c-bfd8-aaca8fba1702" alt="Screenshot 3" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/4e337822-e1d2-4af3-b62f-f507e8bc0c84" alt="Screenshot 4" width="200" />
  <img src="https://github.com/user-attachments/assets/825ce227-1ed6-4279-ba3b-8471baf6ce1b" alt="Screenshot 5" width="200" />
  <img src="https://github.com/user-attachments/assets/9ba614c1-227a-4bc1-a27b-22ed9ec2af5d" alt="Screenshot 6" width="200" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/7f1fa12a-f89e-45aa-aedd-7b60fbeb7518" alt="Screenshot 7" width="200" />
</p>







---

## 🚀 How to Run the App

1. **Clone the Repository**

```bash
git clone https://github.com/your-username/gst_billing_app.git
cd gst_billing_app
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Run the App**

```bash
flutter run
```

---

## ⚙️ Future Enhancements

- 🧲 Export invoices as PDF
- ☁️ Cloud Backup and Sync
- 📊 Sales Analytics Dashboard
- 🧬 AI-based Product Recommendations

---

## 👨‍💻 Developer

- **Name:** *(Your Name)*
- **Email:** *(Your Email)*

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

# 🚀 Let's Automate GST Billing!
