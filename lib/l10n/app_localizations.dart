import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'appTitle': 'Smart Solar Pump',
      'login': 'Login',
      'signup': 'Sign Up',
      'phone': 'Phone Number',
      'password': 'Password',
      'name': 'Name',
      'confirmPassword': 'Confirm Password',
      'forgotPassword': 'Forgot Password?',
      'noAccount': "Don't have an account? ",
      'haveAccount': 'Already have an account? ',
      'connect': 'Connect',
      'createAccount': 'Create Account',
      
      // Profile
      'myProfile': 'My Profile',
      'editProfile': 'Edit Profile',
      'services': 'Services',
      'manageSystems': 'Manage Systems',
      'settings': 'Settings',
      'logout': 'Logout',
      'changePhoto': 'Change Photo',
      'save': 'Save',
      'profileUpdated': 'Profile updated!',
      
      // Settings
      'changePassword': 'Change Password',
      'chooseLanguage': 'Choose Language',
      'help': 'Help',
      'chooseLanguageTitle': 'Choose Language',
      
      // Services
      'contactUs': 'Contact Us',
      'contactDescription': 'Would you like to get in touch? Here is how you can reach us:',
      'call': 'Call',
      'email': 'Email',
      'message': 'Message',
      
      // Language selection
      'languageChanged': 'Language changed',
    },
    'fr': {
      // Common
      'appTitle': 'Smart Solar Pump',
      'login': 'Connexion',
      'signup': 'Inscription',
      'phone': 'Numéro de téléphone',
      'password': 'Mot de passe',
      'name': 'Nom',
      'confirmPassword': 'Confirmer le mot de passe',
      'forgotPassword': 'Mot de passe oublié ?',
      'noAccount': "Pas de compte ? ",
      'haveAccount': 'Tu as déjà un compte ? ',
      'connect': 'Se connecter',
      'createAccount': 'Créer un compte',
      
      // Profile
      'myProfile': 'Mon Profil',
      'editProfile': 'Modifier Profil',
      'services': 'Services',
      'manageSystems': 'Gérer les systèmes',
      'settings': 'Paramètres',
      'logout': 'Déconnexion',
      'changePhoto': 'Changer la photo',
      'save': 'Enregistrer',
      'profileUpdated': 'Profil mis à jour !',
      
      // Settings
      'changePassword': 'Changer le mot de passe',
      'chooseLanguage': 'Choisir langue',
      'help': 'Help',
      'chooseLanguageTitle': 'choisissez la language',
      
      // Services
      'contactUs': 'Contactez-nous',
      'contactDescription': 'Vous souhaitez prendre contact ? Voici comment vous pouvez nous joindre :',
      'call': 'Appeler',
      'email': 'Email',
      'message': 'Message',
      
      // Language selection
      'languageChanged': 'Langue changée',
    },
    'ar': {
      // Common
      'appTitle': 'مضخة الطاقة الشمسية الذكية',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'phone': 'رقم الهاتف',
      'password': 'كلمة المرور',
      'name': 'الاسم',
      'confirmPassword': 'تأكيد كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'noAccount': 'ليس لديك حساب؟ ',
      'haveAccount': 'لديك حساب بالفعل؟ ',
      'connect': 'تسجيل الدخول',
      'createAccount': 'إنشاء حساب',
      
      // Profile
      'myProfile': 'ملفي الشخصي',
      'editProfile': 'تعديل الملف الشخصي',
      'services': 'الخدمات',
      'manageSystems': 'إدارة الأنظمة',
      'settings': 'الإعدادات',
      'logout': 'تسجيل الخروج',
      'changePhoto': 'تغيير الصورة',
      'save': 'حفظ',
      'profileUpdated': 'تم تحديث الملف الشخصي!',
      
      // Settings
      'changePassword': 'تغيير كلمة المرور',
      'chooseLanguage': 'اختر اللغة',
      'help': 'المساعدة',
      'chooseLanguageTitle': 'اختر اللغة',
      
      // Services
      'contactUs': 'اتصل بنا',
      'contactDescription': 'هل تريد الاتصال بنا؟ إليك كيف يمكنك التواصل معنا:',
      'call': 'اتصال',
      'email': 'البريد الإلكتروني',
      'message': 'رسالة',
      
      // Language selection
      'languageChanged': 'تم تغيير اللغة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['fr']?[key] ?? 
           key;
  }

  // Getters for common translations
  String get appTitle => translate('appTitle');
  String get login => translate('login');
  String get signup => translate('signup');
  String get phone => translate('phone');
  String get password => translate('password');
  String get name => translate('name');
  String get confirmPassword => translate('confirmPassword');
  String get forgotPassword => translate('forgotPassword');
  String get noAccount => translate('noAccount');
  String get haveAccount => translate('haveAccount');
  String get connect => translate('connect');
  String get createAccount => translate('createAccount');
  String get myProfile => translate('myProfile');
  String get editProfile => translate('editProfile');
  String get services => translate('services');
  String get manageSystems => translate('manageSystems');
  String get settings => translate('settings');
  String get logout => translate('logout');
  String get changePhoto => translate('changePhoto');
  String get save => translate('save');
  String get profileUpdated => translate('profileUpdated');
  String get changePassword => translate('changePassword');
  String get chooseLanguage => translate('chooseLanguage');
  String get help => translate('help');
  String get chooseLanguageTitle => translate('chooseLanguageTitle');
  String get contactUs => translate('contactUs');
  String get contactDescription => translate('contactDescription');
  String get call => translate('call');
  String get email => translate('email');
  String get message => translate('message');
  String get languageChanged => translate('languageChanged');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

