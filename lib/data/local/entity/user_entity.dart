import 'package:drift/drift.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().named('name')();
  TextColumn get address => text().named('address')();
  TextColumn get emailAddress => text().named('emailAddress')();
}