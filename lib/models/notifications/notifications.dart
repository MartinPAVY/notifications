import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notify_me/models/notifications/notification.dart';

part 'notifications.freezed.dart';
part 'notifications.g.dart';

@freezed
abstract class NotificationsModel with _$NotificationsModel {
  const factory NotificationsModel({
    required List<NotificationModel> notifications,
  }) = _NotificationsModel;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsModelFromJson(json);
}
