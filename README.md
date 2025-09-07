# Instagram Comment Checker 📱

Instagram paylaşımlarındaki yorumları kontrol eden ve belirtilen kullanıcıların yorum yapıp yapmadığını tespit eden Flutter uygulaması.

## 🚀 Özellikler

- ✅ Instagram çerezleri ile otomatik oturum açma
- ✅ Grup üyelerinin yorum kontrolü
- ✅ Yorum yapmayanların listesi
- ✅ Arama ve filtreleme özellikleri
- ✅ Dark mode tasarım
- ✅ Local storage ile çerez saklama

## 📦 Kurulum

### Gereksinimler
- Flutter SDK (3.16.0 veya üzeri)
- Dart SDK (3.0.0 veya üzeri)
- Android Studio veya VS Code
- Git

### Projeyi Klonlama
```bash
git clone https://github.com/kullaniciadi/instagram-comment-checker.git
cd instagram-comment-checker
```

### Bağımlılıkları Yükleme
```bash
flutter pub get
```

### Uygulamayı Çalıştırma
```bash
flutter run
```

## 🔨 Build İşlemleri

### APK Oluşturma (Local)
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK (daha küçük boyut)
flutter build apk --release --split-per-abi
```

### GitHub Actions ile Otomatik Build

Proje, her push işleminde otomatik olarak APK build eder. 

1. Kodunuzu GitHub'a push edin
2. Actions sekmesine gidin
3. Build tamamlandığında APK dosyalarını indirebilirsiniz

## 📱 Kullanım

### 1. Instagram Çerezlerini Ekleme
1. Tarayıcıda Instagram'a giriş yapın
2. F12 ile Developer Tools açın
3. Application > Cookies > instagram.com
4. Çerezleri JSON formatında export edin
5. Uygulamada Ayarlar > Çerezler sayfasına yapıştırın

### 2. Yorum Kontrolü
1. URL Girişi sayfasına gidin
2. Grup üyelerini satır satır girin
3. Instagram post URL'sini girin
4. Onayla butonuna basın

## 🛠 Teknolojiler

- **Flutter** - UI Framework
- **Dart** - Programlama Dili
- **Provider** - State Management
- **SharedPreferences** - Local Storage
- **HTTP** - API İstekleri
- **Material Design 3** - UI Components

## 📁 Proje Yapısı

```
lib/
├── models/          # Veri modelleri
├── providers/       # State management
├── screens/         # Uygulama ekranları
├── services/        # API servisleri
├── utils/          # Yardımcı fonksiyonlar
└── main.dart       # Ana dosya
```

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'e push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📞 İletişim

Sorularınız için issue açabilir veya pull request gönderebilirsiniz.

---

⭐ Projeyi beğendiyseniz yıldız vermeyi unutmayın!
