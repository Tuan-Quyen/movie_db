import 'package:movie_db/model/notification_model.dart';
import 'database_creator.dart';

class RepositoryServiceTodo {
  static Future<List<NotificationData>> getAllNotifications() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.notificationTable}''';
    final data = await db.rawQuery(sql);
    List<NotificationData> notificationDatas = List();

    for (final node in data) {
      final notificationData = NotificationData.fromJson(node);
      notificationDatas.add(notificationData);
    }
    return notificationDatas;
  }

  static Future<NotificationData> getNotificationData(int id) async {
    //final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    //WHERE ${DatabaseCreator.id} = $id''';
    //final data = await db.rawQuery(sql);

    final sql = '''SELECT * FROM ${DatabaseCreator.notificationTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final notificationData = NotificationData.fromJson(data.first);
    return notificationData;
  }

  static Future<void> addNotification(NotificationData notificationData) async {
    final sql = '''INSERT INTO ${DatabaseCreator.notificationTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.title},
      ${DatabaseCreator.overview},
      ${DatabaseCreator.badge}
    )
    VALUES (?,?,?,?)''';
    List<dynamic> params = [notificationData.id, notificationData.title, notificationData.overview, notificationData.badge];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add notification', sql, null, result, params);
  }

  static Future<void> deleteNotification(NotificationData notificationData) async {
    /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/

    final sql = '''UPDATE ${DatabaseCreator.notificationTable}
    SET ${DatabaseCreator.badge} = 0
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [notificationData.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete notification', sql, null, result, params);
  }

  static Future<int> notificationsCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.notificationTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
