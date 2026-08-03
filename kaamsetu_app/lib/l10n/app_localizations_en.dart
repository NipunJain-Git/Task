// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KaamSetu';

  @override
  String get loginTitle => 'Welcome to KaamSetu';

  @override
  String get loginSubtitle => 'Enter your phone number to continue';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get homeTab => 'Home';

  @override
  String get jobsTab => 'Jobs';

  @override
  String get profileTab => 'Profile';

  @override
  String get findWork => 'Find Work';

  @override
  String get postJob => 'Post a Job';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';
}
