import 'package:flutter/material.dart';
import 'package:new_app/data/local/database/user_db.dart';
import 'package:new_app/data/models/user_model.dart';
import 'package:new_app/data/remote/datasource/getUserData.dart';
import 'package:new_app/helper.dart';
import 'package:new_app/main.dart';
import 'package:workmanager/workmanager.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool connected = false;
  List<UserData> offlineUserList = [];
  late Database db;
  late UserModel userModel;

  @override
  void initState() {
    db = Database();
    initialiseWorkmanager();
    fetchDataFromNetwork().then((userModel) async {
      await db.deleteAllUser();
      Helper.saveDataInDB(userModel, db);
      Helper.getDataFromDB(db);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    db = Database();
    super.didChangeDependencies();
    Helper.getDataFromDB(db);
  }

  initialiseWorkmanager() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager().registerOneOffTask('this is unique name', '');
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UserList'),
        ),
        body: Container(
          child: offlineUserList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    UserData user = offlineUserList[index];
                    return Card(
                      child: ListTile(title: Text(user.name), subtitle: Text(user.address)),
                    );
                  }),
                  itemCount: offlineUserList.length)
              : const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No Data in Database, Please wait while fetching the data from network',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
