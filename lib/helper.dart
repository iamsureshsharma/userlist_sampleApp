import 'package:new_app/data/models/user_model.dart';
import 'package:drift/drift.dart' as drift;
import 'data/local/database/user_db.dart';

class Helper {
  static Future<List<UserData>> getDataFromDB(Database db) async {
    List<UserData> userlist = await db.getUserList();

    return userlist;
  }

  static void saveDataInDB(UserModel userModel, Database db) {
    db.deleteAllUser();
    userModel.results?.forEach((user) async {
      final entity = UserCompanion(
        name: drift.Value('${user.name?.first}' '${user.name?.last}'),
        address: drift.Value('${user.location?.street?.name!}' '${user.location?.city}' '${user.location?.state}'),
        emailAddress: drift.Value(user.email!),
      );
      await db.addUser(entity);
      print('DB data saved');
    });
  }
}
