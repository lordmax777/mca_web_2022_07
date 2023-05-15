import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';

class JobModel {
  AllocationModel? allocation;

  //Getters
  bool get isCreate => allocation == null;
  bool get isUpdate => allocation != null;

  //Late initialized variables

  JobModel({this.allocation});
}
