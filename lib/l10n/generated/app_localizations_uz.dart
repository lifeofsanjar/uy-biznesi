// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'Uy biznesi';

  @override
  String get appSubtitle => 'Savdo va foydangiz bir joyda';

  @override
  String get language => 'Til';

  @override
  String get languageUzbek => 'O‘zbekcha';

  @override
  String get languageEnglish => 'English';

  @override
  String get deleteEntryTitle => 'Bu yozuv o‘chirilsinmi?';

  @override
  String deleteEntryMessage(String fruit) {
    return '$fruit haqidagi yozuv daftaridan o‘chiriladi.';
  }

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get delete => 'O‘chirish';

  @override
  String get addSale => 'Savdo qo‘shish';

  @override
  String get addEntry => 'Yozuv qo‘shish';

  @override
  String get today => 'Bugun';

  @override
  String get reports => 'Hisobotlar';

  @override
  String get todayNetProfit => 'BUGUNGI SOF FOYDA';

  @override
  String get sales => 'Savdo';

  @override
  String get costsAndExpenses => 'Xarajatlar';

  @override
  String get todaysActivity => 'Bugungi faoliyat';

  @override
  String entriesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta yozuv',
      one: '$count ta yozuv',
      zero: 'Yozuv yo‘q',
    );
    return '$_temp0';
  }

  @override
  String get noSalesTitle => 'Hozircha savdo kiritilmagan';

  @override
  String get noSalesMessage =>
      'Foydani hisoblashni boshlash uchun birinchi savdoni qo‘shing.';

  @override
  String get thisWeek => 'Shu hafta';

  @override
  String get reportSubtitle => 'Biznesingiz natijalarini kuzating.';

  @override
  String get daily => 'Kunlik';

  @override
  String get weekly => 'Haftalik';

  @override
  String get monthly => 'Oylik';

  @override
  String get netProfit => 'Sof foyda';

  @override
  String get totalSales => 'Jami savdo';

  @override
  String get fruitCost => 'Meva tannarxi';

  @override
  String get otherExpenses => 'Boshqa xarajatlar';

  @override
  String get entriesRecorded => 'Yozuvlar soni';

  @override
  String get profitMargin => 'Foyda marjasi';

  @override
  String get periodEntries => 'Davr yozuvlari';

  @override
  String get noPeriodEntries =>
      'Bu davr uchun hali yozuv yo‘q. Savdo qo‘shsangiz, hisobot shu yerda ko‘rinadi.';

  @override
  String saleDetails(String date, String amount) {
    return '$date  ·  Savdo $amount';
  }

  @override
  String get profit => 'foyda';

  @override
  String get addSaleTitle => 'Savdo qo‘shish';

  @override
  String get editEntryTitle => 'Yozuvni tahrirlash';

  @override
  String get formIntro =>
      'Meva nomi, kilogramm narxi va qo‘shimcha xarajatlarni kiriting.';

  @override
  String get date => 'Sana';

  @override
  String get fruitName => 'Meva yoki savdo nomi';

  @override
  String get fruitHint => 'masalan, Olma';

  @override
  String get addFruitValidation => 'Meva yoki savdo nomini kiriting';

  @override
  String get salesAmount => 'Savdo summasi';

  @override
  String get pricePerKg => '1 kg narxi';

  @override
  String get pricePerKgHint => 'Bir kilogramm uchun olgan pulingiz';

  @override
  String get quantityKg => 'Sotilgan miqdor (kg)';

  @override
  String get quantityKgHint => 'Masalan, 2.5';

  @override
  String get confirmReceivedTitle => 'Olingan pulni tasdiqlang';

  @override
  String confirmReceivedMessage(String fruit) {
    return '$fruit uchun sotilgan kilogrammni kiriting.';
  }

  @override
  String get calculatedReceived => 'Hisoblangan jami tushum';

  @override
  String get continueToConfirm => 'Davom etish';

  @override
  String get confirmAndSave => 'Tasdiqlash va saqlash';

  @override
  String get totalReceivedHint => 'Olingan jami pul';

  @override
  String get fruitCostHint => 'Mevani sotib olish xarajati';

  @override
  String get otherExpensesHint => 'Yetkazish, paket yoki boshqa xarajatlar';

  @override
  String get estimatedNetProfit => 'Taxminiy sof foyda';

  @override
  String get optionalNote => 'Izoh (ixtiyoriy)';

  @override
  String get noteHint => 'Eslab qolmoqchi bo‘lgan ma’lumot';

  @override
  String get saveEntry => 'Yozuvni saqlash';

  @override
  String get saveChanges => 'O‘zgarishlarni saqlash';

  @override
  String enterAmount(String field) {
    return '${field}ni kiriting';
  }

  @override
  String get validAmount => 'Summani to‘g‘ri kiriting';

  @override
  String get nonNegativeAmount => 'Summa manfiy bo‘lishi mumkin emas';

  @override
  String get saveError => 'Yozuvni saqlab bo‘lmadi. Qayta urinib ko‘ring.';

  @override
  String currency(String amount) {
    return '$amount so‘m';
  }

  @override
  String get currencyPrefix => 'so‘m';

  @override
  String periodRange(String start, String end) {
    return '$start – $end';
  }
}
