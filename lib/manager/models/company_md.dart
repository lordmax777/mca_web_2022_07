class CompanyMd {
  String name;
  String domain;
  String timezone;

  //country code
  String country;
  Currency currency;
  int payment_method_id;
  int paying_days;
  String logo;
  String type;
  int rotalength;
  int auto_logout;
  int auto_sign_out;
  int time_validity;
  int max_attempts;
  int colour_schema_id;
  String company_email;
  int ahe;
  double ahew;
  int hct;
  String yearstart;
  int paid_sickness;
  int piw;
  int min_rest;
  int lunchtime;
  int lunchtime_unpaid;
  int rounding;
  int grace;
  int breaks;
  int break_time;
  int break_time_total;
  int min_hours_for_lunch;
  String late_reminders;
  String long_break_reminders;
  String sign_out_reminders;
  bool photo_required;
  bool strict_location;
  int undo_time;
  String locale;
  bool status;
  bool show_title;
  String special_word;

  CompanyMd({
    required this.name,
    required this.domain,
    required this.timezone,
    required this.country,
    required this.currency,
    required this.payment_method_id,
    required this.paying_days,
    required this.logo,
    required this.type,
    required this.rotalength,
    required this.auto_logout,
    required this.auto_sign_out,
    required this.time_validity,
    required this.max_attempts,
    required this.colour_schema_id,
    required this.company_email,
    required this.ahe,
    required this.ahew,
    required this.hct,
    required this.yearstart,
    required this.paid_sickness,
    required this.piw,
    required this.min_rest,
    required this.lunchtime,
    required this.lunchtime_unpaid,
    required this.rounding,
    required this.grace,
    required this.breaks,
    required this.break_time,
    required this.break_time_total,
    required this.min_hours_for_lunch,
    required this.late_reminders,
    required this.long_break_reminders,
    required this.sign_out_reminders,
    required this.photo_required,
    required this.strict_location,
    required this.undo_time,
    required this.locale,
    required this.status,
    required this.show_title,
    required this.special_word,
  });

  // init
  factory CompanyMd.init() {
    return CompanyMd(
      name: '',
      domain: '',
      timezone: '',
      country: '',
      currency: Currency.init(),
      payment_method_id: 0,
      paying_days: 0,
      logo: '',
      type: '',
      rotalength: 0,
      auto_logout: 0,
      auto_sign_out: 0,
      time_validity: 0,
      max_attempts: 0,
      colour_schema_id: 0,
      company_email: '',
      ahe: 0,
      ahew: 0,
      hct: 0,
      yearstart: '',
      paid_sickness: 0,
      piw: 0,
      min_rest: 0,
      lunchtime: 0,
      lunchtime_unpaid: 0,
      rounding: 0,
      grace: 0,
      breaks: 0,
      break_time: 0,
      break_time_total: 0,
      min_hours_for_lunch: 0,
      late_reminders: '',
      long_break_reminders: '',
      sign_out_reminders: '',
      photo_required: false,
      strict_location: false,
      undo_time: 0,
      locale: '',
      status: false,
      show_title: false,
      special_word: '',
    );
  }

  //from json
  factory CompanyMd.fromJson(Map<String, dynamic> json) {
    try {
      return CompanyMd(
        name: json['name'],
        domain: json['domain'],
        timezone: json['timezone'],
        country: json['country'],
        currency: Currency.fromJson(json['currency']),
        payment_method_id: json['payment_method_id'],
        paying_days: json['paying_days'],
        logo: json['logo'],
        type: json['type'],
        rotalength: json['rotalength'],
        auto_logout: json['auto_logout'],
        auto_sign_out: json['auto_sign_out'],
        time_validity: json['time_validity'],
        max_attempts: json['max_attempts'],
        colour_schema_id: json['colour_schema_id'],
        company_email: json['company_email'],
        ahe: json['ahe'],
        ahew: json['ahew'],
        hct: json['hct'],
        yearstart: json['yearstart'],
        paid_sickness: json['paid_sickness'],
        piw: json['piw'],
        min_rest: json['min_rest'],
        lunchtime: json['lunchtime'],
        lunchtime_unpaid: json['lunchtime_unpaid'],
        rounding: json['rounding'],
        grace: json['grace'],
        breaks: json['breaks'],
        break_time: json['break_time'],
        break_time_total: json['break_time_total'],
        min_hours_for_lunch: json['min_hours_for_lunch'],
        late_reminders: json['late_reminders'],
        long_break_reminders: json['long_break_reminders'],
        sign_out_reminders: json['sign_out_reminders'],
        photo_required: json['photo_required'],
        strict_location: json['strict_location'],
        undo_time: json['undo_time'],
        locale: json['locale'],
        status: json['status'],
        show_title: json['show_title'],
        special_word: json['special_word'],
      );
    } on TypeError catch (e) {
      print("CompanyMd.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }
}

class Currency {
  final String code;
  final String sign;
  final bool signFront;
  final int digits;

  Currency({
    required this.code,
    required this.sign,
    required this.signFront,
    required this.digits,
  });

  // init
  factory Currency.init() {
    return Currency(
      code: '',
      sign: '',
      signFront: false,
      digits: 0,
    );
  }

  //from json
  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      sign: json['sign'],
      signFront: json['signFront'],
      digits: json['digits'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['sign'] = sign;
    data['signFront'] = signFront;
    data['digits'] = digits;
    return data;
  }
}
