import './models/jar_model.dart';

var dummyJars = [
  JarModel(
    id: 'j1',
    name: 'PS4 Fund',
    owner: '1234',
    currentAmount: 270.55,
    goalAmount: 600.0,
    lastUpdated: DateTime.parse("2018-02-27 13:27:00"),
    sharedTo: <String>[],
  ),
  JarModel(
    id: 'j2',
    name: 'Dummy 2',
    owner: '1234',
    currentAmount: 380.45,
    goalAmount: 600.0,
    lastUpdated: DateTime.parse("2018-03-27 13:27:00"),
    sharedTo: <String>[],
  ),
  JarModel(
    id: 'j2',
    name: 'Dummy 3',
    owner: '1234',
    currentAmount: 33.0,
    goalAmount: 700.0,
    lastUpdated: DateTime.parse("2018-03-27 13:27:00"),
    sharedTo: <String>[],
  ),
  JarModel(
    id: 'j2',
    name: 'Rainy Day Fund',
    owner: '1234',
    currentAmount: 120.99,
    goalAmount: 10000.0,
    lastUpdated: DateTime.parse("2018-03-27 13:27:00"),
    sharedTo: <String>[],
  ),
  JarModel(
    id: 'j2',
    name: 'Overflow test',
    owner: '1234',
    currentAmount: 10000000,
    goalAmount: 99999.0,
    lastUpdated: DateTime.parse("2018-03-27 13:27:00"),
    sharedTo: <String>[],
  ),
];
