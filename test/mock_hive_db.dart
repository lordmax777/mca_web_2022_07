//Write a mock class using the Mockito package for Hive db

import 'package:hive/hive.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mockito/mockito.dart';

class MockMCADb extends Mock implements MCADb {}

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}
