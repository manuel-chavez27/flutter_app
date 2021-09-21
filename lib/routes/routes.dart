import 'package:flutter/material.dart';
import 'package:my_app/screens/chat/chatRoomsScreen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'chat': (BuildContext context) => ChatRoom(),
  };
}
