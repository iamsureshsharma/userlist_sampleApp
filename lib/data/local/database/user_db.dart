import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../entity/user_entity.dart';

part 'user_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'userList.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [User])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<UserData>> getUserList() async {
    return await select(user).get();
  }

  Future<int> addUser(UserCompanion userCompanion) async {
    return await into(user).insert(userCompanion);
  }

  deleteAllUser() async {
    return delete(user).go();
  }
}
