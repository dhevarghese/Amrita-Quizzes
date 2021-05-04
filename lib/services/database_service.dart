import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class Database {
  Future<void> updateUserData(String name);
  Future<String> getUserName();
  Future<void> addQuiz(Quiz q, String uid);
  Future<int> numberOfQuizzes();
}

class DatabaseService implements Database {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference quizCollection = FirebaseFirestore.instance.collection('quizzes');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name) async {
    return await userCollection.doc(uid).set({
      'name': name,
    });
  }

  Future<String> getUserName() async {
    String uName="";
    await userCollection.doc(uid).get().then((DocumentSnapshot ds) {
      //print(ds.get("name"));
      uName = ds.get("name");
    }).catchError((e){});
    return uName;
  }

  Future<int> numberOfQuizzes() async {
    return quizCollection.snapshots().length;
  }

  Future<void> addQuiz(Quiz q, String uid) async {
    //print(q.toJson());
    await quizCollection.doc(q.title).set(q.toJson());
    for(int i = 0; i< q.questions.length; i++) {
      await quizCollection.doc(q.title).collection("Questions").doc("Question"+(i+1).toString()).set(q.getQuestionJson(i));
      print(q.getQuestionJson(i));
    }
    var autoID = quizCollection.doc().id;
    await quizCollection.doc(q.title).update({'id': autoID});
    await userCollection.doc(uid).update({'quizzes_created': FieldValue.arrayUnion([q.title])});
    Reference storageRef = FirebaseStorage.instance.ref().child('quizDashImages');
    UploadTask uploadTask = storageRef.putFile(q.image);
    // Waits till the file is uploaded then stores the download url
    String imageURL="";
    return await uploadTask.whenComplete((){
      uploadTask.snapshot.ref.getDownloadURL().then((fileURL) {
        imageURL = fileURL;
        quizCollection.doc(q.title).update({'image': imageURL});
      });
    });
    //print('File Uploaded');

  }

}