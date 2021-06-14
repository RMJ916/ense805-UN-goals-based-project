import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhadmin/models/event.dart';

class EventProvider with ChangeNotifier {
  Map<String, Event> events;

  String last_fetch_event_id;
  EventProvider() {
    loadUpcomingEvent();
  }

  loadUpcomingEvent() async {
    FirebaseFirestore.instance
        .collection('events')
        .where('event_date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('event_date')
        .snapshots()
        .listen((event) {
      events = {};
      event.docs.forEach((element) {
        events.putIfAbsent(element.id, () => Event.fromJson(element.data()));
        notifyListeners();
      });
    });
  }
}
