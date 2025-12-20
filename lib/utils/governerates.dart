class Governorates {
  static const Map<String, double> _shippingRates = {
    'القاهرة': 55.0,
    'الجيزة': 55.0,
    'القليوبية': 55.0,
    'المنوفية': 55.0,
    'الشرقية': 55.0,
    'الغربية': 55.0,

    'الإسكندرية': 65.0,
    'البحيرة': 65.0,
    'الدقهلية': 65.0,
    'كفر الشيخ': 65.0,
    'الإسماعيلية': 65.0,
    'السويس': 65.0,
    'بورسعيد': 65.0,
    'الفيوم': 65.0,
    'بني سويف': 65.0,
    'المنيا': 65.0,

    'أسيوط': 80.0,
    'شمال سيناء': 80.0,
    'جنوب سيناء': 80.0,

    'سوهاج': 90.0,
    'البحر الأحمر': 90.0,
    'مطروح': 90.0,

    'قنا': 100.0,
    'الأقصر': 100.0,
    'أسوان': 100.0,

    'الوادي الجديد': 105.0,
  };

  static List<String> get list => _shippingRates.keys.toList();

  static bool isValid(String? input) {
    if (input == null || input.isEmpty) return false;
    return _shippingRates.containsKey(_normalize(input));
  }

  static double getDeliveryPrice(String city) {
    String normalizedCity = _normalize(city);
    if (!_shippingRates.containsKey(normalizedCity)) {
      return 80;
    }
    return _shippingRates[normalizedCity]!;
  }

  static String _normalize(String input) {
    String text = input.trim();

    if (text.endsWith('ه') && text != 'الله') {
      text = '${text.substring(0, text.length - 1)}ة';
    }

    if (text == 'الاقصر') return 'الأقصر';
    if (text == 'اسوان') return 'أسوان';
    if (text == 'اسيوط') return 'أسيوط';
    if (text == 'الاسكندرية' || text == 'الاسكندريه') return 'الإسكندرية';
    if (text == 'الاسماعيلية' || text == 'الاسماعيليه') return 'الإسماعيلية';
    if (text == 'جيزة') return 'الجيزة';

    return text;
  }
}