import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';

class JobModel {
  AllocationModel? allocation;
  ClientInfoMd? get client => allocation?.shift.client;
  set client(ClientInfoMd? clientInfoMd) {
    allocation?.shift.client = clientInfoMd;
  }

  //Getters
  bool get isCreate => allocation == null;
  bool get isUpdate => allocation != null;

  //Late initialized variables

  JobModel({this.allocation});
}
