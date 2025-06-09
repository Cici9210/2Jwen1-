# dotnav

一個用Flutter編輯的商場導引系統

主要功能：
搭配實體標誌尋找商品，及確認售價及商品狀態

![實體標誌設計](assets/images/dotnav_logo.png)
- 語音輸入和手動輸入區域代碼
- 語音輸出查詢結果和商品資訊
- 美觀的使用者介面設計
- 無障礙設計支援

## 功能特色：
- 🎯 **區域代碼搜尋**：輸入代碼快速定位商品區域
- 🔊 **語音互動**：支援語音輸入和語音回饋
- 📱 **美觀界面**：現代化Material Design設計
- ♿ **無障礙支援**：適合視障用戶使用
- 🗂️ **商品管理**：完整的商品資訊展示

## 技術規格：
- **平台**：Flutter (支援Web、Android、iOS)
- **語音功能**：flutter_tts、speech_to_text
- **設計風格**：Material Design 3
- **資料格式**：JSON本地資料庫

## 測試資料：
- **A01** - 生鮮蔬果區（蘋果、香蕉）
- **B01** - 飲料區（礦泉水、咖啡）
- **C01** - 零食區（洋芋片、餅乾）

## 如何運行：

### 前置要求：
- Flutter SDK
- Chrome瀏覽器（Web版本）

### 運行步驟：
```bash
# 1. 安裝依賴項目
flutter pub get

# 2. 運行Web版本
flutter run -d web-server --web-port 8080

# 3. 在瀏覽器中訪問
# http://localhost:8080
```

## 使用說明：
1. 打開應用程式，點擊「開始使用」
2. 選擇「手動輸入」或「語音輸入」
3. 輸入區域代碼（例如：A01、B01、C01）
4. 查看商品資訊並使用語音功能

## 專案結構：
```
lib/
├── main.dart                    # 應用程式入口
├── data/                        # 資料層
│   ├── api_service.dart         # API服務
│   └── models.dart              # 資料模型
├── main/                        # 主要頁面
│   ├── home_screen.dart         # 首頁
│   ├── search_by_code_screen.dart # 搜尋頁面
│   └── product_info_screen.dart  # 產品資訊頁面
├── onboarding/                  # 引導頁面
│   └── welcome_screen.dart      # 歡迎畫面
└── shared/                      # 共用元件
    └── voice_engine.dart        # 語音引擎
```

## 貢獻指南：
歡迎提交Issue和Pull Request來改進這個專案！

## 授權：
本專案採用MIT授權條款。
