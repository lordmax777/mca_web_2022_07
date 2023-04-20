class CompanyMd {
  final String name;
  final String domain;
  final String timezone;
  final Currency currency;
  final String logo;
  final String type;
  final int rotalength;
  final int autoLogout;
  final int autoSignOut;
  final int timeValidity;
  final int maxAttempts;
  final int colourSchemaId;
  final String companyEmail;
  final int ahe;
  final double ahew;
  final int hct;
  final String yearstart;
  final int paidSickness;
  final int piw;
  final int minRest;
  final int lunchtime;
  final int lunchtimeUnpaid;
  final int rounding;
  final int grace;
  final int breaks;
  final int breakTime;
  final int breakTimeTotal;
  final int minHoursForLunch;
  final String lateReminders;
  final String longBreakReminders;
  final String signOutReminders;
  final bool photoRequired;
  final bool strictLocation;
  final int undoTime;
  final String locale;
  final bool status;
  final bool showTitle;
  final String special_word;

  CompanyMd({
    required this.name,
    required this.domain,
    required this.timezone,
    required this.currency,
    required this.logo,
    required this.type,
    required this.rotalength,
    required this.autoLogout,
    required this.autoSignOut,
    required this.timeValidity,
    required this.maxAttempts,
    required this.colourSchemaId,
    required this.companyEmail,
    required this.ahe,
    required this.ahew,
    required this.hct,
    required this.yearstart,
    required this.paidSickness,
    required this.piw,
    required this.minRest,
    required this.lunchtime,
    required this.lunchtimeUnpaid,
    required this.rounding,
    required this.grace,
    required this.breaks,
    required this.breakTime,
    required this.breakTimeTotal,
    required this.minHoursForLunch,
    required this.lateReminders,
    required this.longBreakReminders,
    required this.signOutReminders,
    required this.photoRequired,
    required this.strictLocation,
    required this.undoTime,
    required this.locale,
    required this.status,
    required this.showTitle,
    required this.special_word,
  });

  // init
  factory CompanyMd.init() {
    return CompanyMd(
      name: '',
      domain: '',
      timezone: '',
      currency: Currency.init(),
      logo: '',
      type: '',
      rotalength: 0,
      autoLogout: 0,
      autoSignOut: 0,
      timeValidity: 0,
      maxAttempts: 0,
      colourSchemaId: 0,
      companyEmail: '',
      ahe: 0,
      ahew: 0,
      hct: 0,
      yearstart: '',
      paidSickness: 0,
      piw: 0,
      minRest: 0,
      lunchtime: 0,
      lunchtimeUnpaid: 0,
      rounding: 0,
      grace: 0,
      breaks: 0,
      breakTime: 0,
      breakTimeTotal: 0,
      minHoursForLunch: 0,
      lateReminders: '',
      longBreakReminders: '',
      signOutReminders: '',
      photoRequired: false,
      strictLocation: false,
      undoTime: 0,
      locale: '',
      status: false,
      showTitle: false,
      special_word: '',
    );
  }

  //from json
  factory CompanyMd.fromJson(Map<String, dynamic> json) {
    return CompanyMd(
      name: json['name'],
      domain: json['domain'],
      timezone: json['timezone'],
      currency: Currency.fromJson(json['currency']),
      logo: json['logo'],
      type: json['type'],
      rotalength: json['rotalength'],
      autoLogout: json['auto_logout'],
      autoSignOut: json['auto_sign_out'],
      timeValidity: json['time_validity'],
      maxAttempts: json['max_attempts'],
      colourSchemaId: json['colour_schema_id'],
      companyEmail: json['company_email'],
      ahe: json['ahe'],
      ahew: json['ahew'],
      hct: json['hct'],
      yearstart: json['yearstart'],
      paidSickness: json['paid_sickness'],
      piw: json['piw'],
      minRest: json['min_rest'],
      lunchtime: json['lunchtime'],
      lunchtimeUnpaid: json['lunchtime_unpaid'],
      rounding: json['rounding'],
      grace: json['grace'],
      breaks: json['breaks'],
      breakTime: json['break_time'],
      breakTimeTotal: json['break_time_total'],
      minHoursForLunch: json['min_hours_for_lunch'],
      lateReminders: json['late_reminders'],
      longBreakReminders: json['long_break_reminders'],
      signOutReminders: json['sign_out_reminders'],
      photoRequired: json['photo_required'],
      strictLocation: json['strict_location'],
      undoTime: json['undo_time'],
      locale: json['locale'],
      status: json['status'],
      showTitle: json['show_title'],
      special_word: json['special_word'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['domain'] = domain;
    data['timezone'] = timezone;
    data['currency'] = currency.toJson();
    data['logo'] = logo;
    data['type'] = type;
    data['rotalength'] = rotalength;
    data['auto_logout'] = autoLogout;
    data['auto_sign_out'] = autoSignOut;
    data['time_validity'] = timeValidity;
    data['max_attempts'] = maxAttempts;
    data['colour_schema_id'] = colourSchemaId;
    data['company_email'] = companyEmail;
    data['ahe'] = ahe;
    data['ahew'] = ahew;
    data['hct'] = hct;
    data['yearstart'] = yearstart;
    data['paid_sickness'] = paidSickness;
    data['piw'] = piw;
    data['min_rest'] = minRest;
    data['lunchtime'] = lunchtime;
    data['lunchtime_unpaid'] = lunchtimeUnpaid;
    data['rounding'] = rounding;
    data['grace'] = grace;
    data['breaks'] = breaks;
    data['break_time'] = breakTime;
    data['break_time_total'] = breakTimeTotal;
    data['min_hours_for_lunch'] = minHoursForLunch;
    data['late_reminders'] = lateReminders;
    data['long_break_reminders'] = longBreakReminders;
    data['sign_out_reminders'] = signOutReminders;
    data['photo_required'] = photoRequired;
    data['strict_location'] = strictLocation;
    data['undo_time'] = undoTime;
    data['locale'] = locale;
    data['status'] = status;
    data['show_title'] = showTitle;
    data['special_word'] = special_word;
    return data;
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
