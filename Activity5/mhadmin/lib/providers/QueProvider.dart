import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mhadmin/models/question.dart';

class QusProivder with ChangeNotifier {
  Map<String, Question> qus = {};

  QusProivder() {
    loadQues();
  }

  loadQues() {
    FirebaseFirestore.instance
        .collection('questions')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
                notifyListeners();
      event.docs.forEach((element) {
       
        try {
          qus[element.id] = Question.fromJson(element.data());
        } catch (e) {
           qus.putIfAbsent(element.id, () => Question.fromJson(element.data()));
        }
        notifyListeners();
      });
    });
  }
}
