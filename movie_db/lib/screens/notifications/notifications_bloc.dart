import 'package:movie_db/model/notification_model.dart';
import 'package:movie_db/other/repository/repository_service_notification.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsBloc {
  final BehaviorSubject<List<NotificationData>> _subject = BehaviorSubject();

  final BehaviorSubject<List<NotificationData>> _notifications = BehaviorSubject();

  BehaviorSubject<List<NotificationData>> get notifications => _notifications;

  getAllNotifications() async {
    RepositoryServiceTodo.getAllNotifications().then((notifications) {
      _notifications.add(notifications);
    });
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<List<NotificationData>> get subject => _subject;
}
