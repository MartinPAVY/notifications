// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    _NotificationsModel(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationsModelToJson(_NotificationsModel instance) =>
    <String, dynamic>{'notifications': instance.notifications};
