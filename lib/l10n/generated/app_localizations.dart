import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uz'),
  ];

  /// No description provided for @appName.
  ///
  /// In uz, this message translates to:
  /// **'Uy biznesi'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Savdo va foydangiz bir joyda'**
  String get appSubtitle;

  /// No description provided for @language.
  ///
  /// In uz, this message translates to:
  /// **'Til'**
  String get language;

  /// No description provided for @languageUzbek.
  ///
  /// In uz, this message translates to:
  /// **'O‘zbekcha'**
  String get languageUzbek;

  /// No description provided for @languageEnglish.
  ///
  /// In uz, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu yozuv o‘chirilsinmi?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryMessage.
  ///
  /// In uz, this message translates to:
  /// **'{fruit} haqidagi yozuv daftaridan o‘chiriladi.'**
  String deleteEntryMessage(String fruit);

  /// No description provided for @cancel.
  ///
  /// In uz, this message translates to:
  /// **'Bekor qilish'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In uz, this message translates to:
  /// **'O‘chirish'**
  String get delete;

  /// No description provided for @addSale.
  ///
  /// In uz, this message translates to:
  /// **'Savdo qo‘shish'**
  String get addSale;

  /// No description provided for @addEntry.
  ///
  /// In uz, this message translates to:
  /// **'Yozuv qo‘shish'**
  String get addEntry;

  /// No description provided for @today.
  ///
  /// In uz, this message translates to:
  /// **'Bugun'**
  String get today;

  /// No description provided for @reports.
  ///
  /// In uz, this message translates to:
  /// **'Hisobotlar'**
  String get reports;

  /// No description provided for @todayNetProfit.
  ///
  /// In uz, this message translates to:
  /// **'BUGUNGI SOF FOYDA'**
  String get todayNetProfit;

  /// No description provided for @sales.
  ///
  /// In uz, this message translates to:
  /// **'Savdo'**
  String get sales;

  /// No description provided for @costsAndExpenses.
  ///
  /// In uz, this message translates to:
  /// **'Xarajatlar'**
  String get costsAndExpenses;

  /// No description provided for @todaysActivity.
  ///
  /// In uz, this message translates to:
  /// **'Bugungi faoliyat'**
  String get todaysActivity;

  /// No description provided for @entriesCount.
  ///
  /// In uz, this message translates to:
  /// **'{count, plural, =0{Yozuv yo‘q} one{{count} ta yozuv} other{{count} ta yozuv}}'**
  String entriesCount(num count);

  /// No description provided for @noSalesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Hozircha savdo kiritilmagan'**
  String get noSalesTitle;

  /// No description provided for @noSalesMessage.
  ///
  /// In uz, this message translates to:
  /// **'Foydani hisoblashni boshlash uchun birinchi savdoni qo‘shing.'**
  String get noSalesMessage;

  /// No description provided for @thisWeek.
  ///
  /// In uz, this message translates to:
  /// **'Shu hafta'**
  String get thisWeek;

  /// No description provided for @reportSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Biznesingiz natijalarini kuzating.'**
  String get reportSubtitle;

  /// No description provided for @daily.
  ///
  /// In uz, this message translates to:
  /// **'Kunlik'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In uz, this message translates to:
  /// **'Haftalik'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In uz, this message translates to:
  /// **'Oylik'**
  String get monthly;

  /// No description provided for @netProfit.
  ///
  /// In uz, this message translates to:
  /// **'Sof foyda'**
  String get netProfit;

  /// No description provided for @totalSales.
  ///
  /// In uz, this message translates to:
  /// **'Jami savdo'**
  String get totalSales;

  /// No description provided for @fruitCost.
  ///
  /// In uz, this message translates to:
  /// **'Meva tannarxi'**
  String get fruitCost;

  /// No description provided for @otherExpenses.
  ///
  /// In uz, this message translates to:
  /// **'Boshqa xarajatlar'**
  String get otherExpenses;

  /// No description provided for @entriesRecorded.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvlar soni'**
  String get entriesRecorded;

  /// No description provided for @profitMargin.
  ///
  /// In uz, this message translates to:
  /// **'Foyda marjasi'**
  String get profitMargin;

  /// No description provided for @periodEntries.
  ///
  /// In uz, this message translates to:
  /// **'Davr yozuvlari'**
  String get periodEntries;

  /// No description provided for @noPeriodEntries.
  ///
  /// In uz, this message translates to:
  /// **'Bu davr uchun hali yozuv yo‘q. Savdo qo‘shsangiz, hisobot shu yerda ko‘rinadi.'**
  String get noPeriodEntries;

  /// No description provided for @saleDetails.
  ///
  /// In uz, this message translates to:
  /// **'{date}  ·  Savdo {amount}'**
  String saleDetails(String date, String amount);

  /// No description provided for @profit.
  ///
  /// In uz, this message translates to:
  /// **'foyda'**
  String get profit;

  /// No description provided for @addSaleTitle.
  ///
  /// In uz, this message translates to:
  /// **'Savdo qo‘shish'**
  String get addSaleTitle;

  /// No description provided for @editEntryTitle.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvni tahrirlash'**
  String get editEntryTitle;

  /// No description provided for @formIntro.
  ///
  /// In uz, this message translates to:
  /// **'Meva nomi, kilogramm narxi va qo‘shimcha xarajatlarni kiriting.'**
  String get formIntro;

  /// No description provided for @date.
  ///
  /// In uz, this message translates to:
  /// **'Sana'**
  String get date;

  /// No description provided for @fruitName.
  ///
  /// In uz, this message translates to:
  /// **'Meva yoki savdo nomi'**
  String get fruitName;

  /// No description provided for @fruitHint.
  ///
  /// In uz, this message translates to:
  /// **'masalan, Olma'**
  String get fruitHint;

  /// No description provided for @addFruitValidation.
  ///
  /// In uz, this message translates to:
  /// **'Meva yoki savdo nomini kiriting'**
  String get addFruitValidation;

  /// No description provided for @salesAmount.
  ///
  /// In uz, this message translates to:
  /// **'Savdo summasi'**
  String get salesAmount;

  /// No description provided for @pricePerKg.
  ///
  /// In uz, this message translates to:
  /// **'1 kg narxi'**
  String get pricePerKg;

  /// No description provided for @pricePerKgHint.
  ///
  /// In uz, this message translates to:
  /// **'Bir kilogramm uchun olgan pulingiz'**
  String get pricePerKgHint;

  /// No description provided for @quantityKg.
  ///
  /// In uz, this message translates to:
  /// **'Sotilgan miqdor (kg)'**
  String get quantityKg;

  /// No description provided for @quantityKgHint.
  ///
  /// In uz, this message translates to:
  /// **'Masalan, 2.5'**
  String get quantityKgHint;

  /// No description provided for @confirmReceivedTitle.
  ///
  /// In uz, this message translates to:
  /// **'Olingan pulni tasdiqlang'**
  String get confirmReceivedTitle;

  /// No description provided for @confirmReceivedMessage.
  ///
  /// In uz, this message translates to:
  /// **'{fruit} uchun sotilgan kilogrammni kiriting.'**
  String confirmReceivedMessage(String fruit);

  /// No description provided for @calculatedReceived.
  ///
  /// In uz, this message translates to:
  /// **'Hisoblangan jami tushum'**
  String get calculatedReceived;

  /// No description provided for @continueToConfirm.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get continueToConfirm;

  /// No description provided for @confirmAndSave.
  ///
  /// In uz, this message translates to:
  /// **'Tasdiqlash va saqlash'**
  String get confirmAndSave;

  /// No description provided for @totalReceivedHint.
  ///
  /// In uz, this message translates to:
  /// **'Olingan jami pul'**
  String get totalReceivedHint;

  /// No description provided for @fruitCostHint.
  ///
  /// In uz, this message translates to:
  /// **'Mevani sotib olish xarajati'**
  String get fruitCostHint;

  /// No description provided for @otherExpensesHint.
  ///
  /// In uz, this message translates to:
  /// **'Yetkazish, paket yoki boshqa xarajatlar'**
  String get otherExpensesHint;

  /// No description provided for @estimatedNetProfit.
  ///
  /// In uz, this message translates to:
  /// **'Taxminiy sof foyda'**
  String get estimatedNetProfit;

  /// No description provided for @optionalNote.
  ///
  /// In uz, this message translates to:
  /// **'Izoh (ixtiyoriy)'**
  String get optionalNote;

  /// No description provided for @noteHint.
  ///
  /// In uz, this message translates to:
  /// **'Eslab qolmoqchi bo‘lgan ma’lumot'**
  String get noteHint;

  /// No description provided for @saveEntry.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvni saqlash'**
  String get saveEntry;

  /// No description provided for @saveChanges.
  ///
  /// In uz, this message translates to:
  /// **'O‘zgarishlarni saqlash'**
  String get saveChanges;

  /// No description provided for @enterAmount.
  ///
  /// In uz, this message translates to:
  /// **'{field}ni kiriting'**
  String enterAmount(String field);

  /// No description provided for @validAmount.
  ///
  /// In uz, this message translates to:
  /// **'Summani to‘g‘ri kiriting'**
  String get validAmount;

  /// No description provided for @nonNegativeAmount.
  ///
  /// In uz, this message translates to:
  /// **'Summa manfiy bo‘lishi mumkin emas'**
  String get nonNegativeAmount;

  /// No description provided for @saveError.
  ///
  /// In uz, this message translates to:
  /// **'Yozuvni saqlab bo‘lmadi. Qayta urinib ko‘ring.'**
  String get saveError;

  /// No description provided for @currency.
  ///
  /// In uz, this message translates to:
  /// **'{amount} so‘m'**
  String currency(String amount);

  /// No description provided for @currencyPrefix.
  ///
  /// In uz, this message translates to:
  /// **'so‘m'**
  String get currencyPrefix;

  /// No description provided for @periodRange.
  ///
  /// In uz, this message translates to:
  /// **'{start} – {end}'**
  String periodRange(String start, String end);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
