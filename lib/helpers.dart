// ignore_for_file: body_might_complete_normally_nullable

import 'dart:math';
import 'dart:convert';

import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

abstract class Helpers {
  static final random = Random();
  static final Random _random = Random.secure();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/300/300';
  }

  static String createCryptoRandomString([int length = 32]){
          var values = List<int>.generate(length, (i) => _random.nextInt(256));
          print(base64Url.encode(values));
          return base64Url.encode(values).replaceAll("=", "_");
  }

  static DateTime randomDate() {
    final random = Random();
    final currentDate = DateTime.now();
    return currentDate.subtract(Duration(seconds: random.nextInt(200000)));
  }

  static String getChannelName(Channel channel, User currentUser) {
    if (channel.name != null) {
      return channel.name!;
    } else if (channel.state?.members.isNotEmpty ?? false) {
      final otherMembers = channel.state?.members
          .where(
            (element) => element.userId != currentUser.id,
          )
          .toList();

      if (otherMembers?.length == 1) {
        return otherMembers!.first.user?.name ?? 'No name';
      } else {
        return 'Multiple users';
      }
    } else {
      return 'No Channel Name';
    }
  }

  static String? getChannelImage(Channel channel, User currentUser) {
    if (channel.image != null) {
      return channel.image!;
    } else if (channel.state?.members.isNotEmpty ?? false) {
      final otherMembers = channel.state?.members
          .where(
            (element) => element.userId != currentUser.id,
          )
          .toList();

      if (otherMembers?.length == 1) {
        return otherMembers!.first.user?.image;
      }
    } else {
      return null;
    }
  }
}