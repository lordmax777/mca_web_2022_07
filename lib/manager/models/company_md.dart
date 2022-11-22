class CompanyMd {
  String? name;
  String? domain;
  String? timezone;
  Currency? currency;
  String? logo;
  String? type;
  int? rotalength;
  int? autoLogout;
  int? autoSignOut;
  int? timeValidity;
  int? maxAttempts;
  int? colourSchemaId;
  String? companyEmail;
  int? ahe;
  double? ahew;
  int? hct;
  String? yearstart;
  int? paidSickness;
  int? piw;
  int? minRest;
  int? lunchtime;
  int? lunchtimeUnpaid;
  int? rounding;
  int? grace;
  int? breaks;
  int? breakTime;
  int? breakTimeTotal;
  int? minHoursForLunch;
  String? lateReminders;
  String? longBreakReminders;
  String? signOutReminders;
  bool? photoRequired;
  bool? strictLocation;
  int? undoTime;
  String? locale;
  bool? status;
  bool? showTitle;

  CompanyMd(
      {this.name,
      this.domain,
      this.timezone,
      this.currency,
      this.logo,
      this.type,
      this.rotalength,
      this.autoLogout,
      this.autoSignOut,
      this.timeValidity,
      this.maxAttempts,
      this.colourSchemaId,
      this.companyEmail,
      this.ahe,
      this.ahew,
      this.hct,
      this.yearstart,
      this.paidSickness,
      this.piw,
      this.minRest,
      this.lunchtime,
      this.lunchtimeUnpaid,
      this.rounding,
      this.grace,
      this.breaks,
      this.breakTime,
      this.breakTimeTotal,
      this.minHoursForLunch,
      this.lateReminders,
      this.longBreakReminders,
      this.signOutReminders,
      this.photoRequired,
      this.strictLocation,
      this.undoTime,
      this.locale,
      this.status,
      this.showTitle});

  CompanyMd.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    domain = json['domain'];
    timezone = json['timezone'];
    currency =
        json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    logo = json['logo'];
    type = json['type'];
    rotalength = json['rotalength'];
    autoLogout = json['auto_logout'];
    autoSignOut = json['auto_sign_out'];
    timeValidity = json['time_validity'];
    maxAttempts = json['max_attempts'];
    colourSchemaId = json['colour_schema_id'];
    companyEmail = json['company_email'];
    ahe = json['ahe'];
    ahew = json['ahew'];
    hct = json['hct'];
    yearstart = json['yearstart'];
    paidSickness = json['paid_sickness'];
    piw = json['piw'];
    minRest = json['min_rest'];
    lunchtime = json['lunchtime'];
    lunchtimeUnpaid = json['lunchtime_unpaid'];
    rounding = json['rounding'];
    grace = json['grace'];
    breaks = json['breaks'];
    breakTime = json['break_time'];
    breakTimeTotal = json['break_time_total'];
    minHoursForLunch = json['min_hours_for_lunch'];
    lateReminders = json['late_reminders'];
    longBreakReminders = json['long_break_reminders'];
    signOutReminders = json['sign_out_reminders'];
    photoRequired = json['photo_required'];
    strictLocation = json['strict_location'];
    undoTime = json['undo_time'];
    locale = json['locale'];
    status = json['status'];
    showTitle = json['show_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['domain'] = domain;
    data['timezone'] = timezone;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
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
    return data;
  }
}

class Currency {
  String? code;
  String? sign;
  bool? signFront;
  int? digits;

  Currency({this.code, this.sign, this.signFront, this.digits});

  Currency.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    sign = json['sign'];
    signFront = json['signFront'];
    digits = json['digits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['sign'] = sign;
    data['signFront'] = signFront;
    data['digits'] = digits;
    return data;
  }
}
