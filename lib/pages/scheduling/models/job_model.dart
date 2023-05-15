import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/timing_model.dart';

import '../../../manager/models/location_item_md.dart';

class JobModel {
  AllocationModel? allocation;

  ClientInfoMd get client {
    final cl = allocation?.shift.client;
    if (cl == null) {
      return ClientInfoMd.init();
    }
    return cl;
  }

  set client(ClientInfoMd? clientInfoMd) {
    allocation?.shift.client = clientInfoMd;
  }

  LocationAddress? get address => allocation?.shift.location;
  set address(LocationAddress? loc) {
    if (loc == null) return;
    allocation?.shift.location = loc;
  }

  LocationAddress? get workAddress => null;
  set workAddress(LocationAddress? loc) {
    if (loc == null) return;
    allocation?.shift.location = loc;
  }

  TimingModel timingInfo = TimingModel();

  Map<UserRes, double> addedChildren = {};

  //Getters
  bool get isCreate => allocation == null;
  bool get isUpdate => allocation != null;

  //Late initialized variables

  JobModel({this.allocation});
}
