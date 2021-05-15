import 'package:amrita_quizzes/models/Questions.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/models/QuizUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class Database {
  Future<void> updateUserData(String name, String dept, String section);
  Future<String> getUserName();
  Future<void> addQuiz(Quiz q, String uid);
  Future<int> numberOfQuizzes();
  Future<List<Quiz>> getQuizzes(String category);
  //Future<Map> getUsers();
  Future<List> getUsers();
  Future<Quiz> getQuizById(String id);
  Future<QuizUser> getUserDetails();
}

class DatabaseService implements Database {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference quizCollection = FirebaseFirestore.instance.collection('quizzes');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String dept, String section) async {
    return await userCollection.doc(uid).update({
      'name': name,
      'department': dept,
      'section':section,
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

  Future<QuizUser> getUserDetails() async {
    QuizUser qUser;
    await userCollection.doc(uid).get().then((DocumentSnapshot ds) {
      print(ds.data());
      qUser = QuizUser.fromJson(ds.data());
    }).catchError((e){});
    return qUser;
  }

  /*

  Future<Map> getUsers() async{
    Map users = {};
    //print("hello");
    await userCollection.get().then((value){
      for(var i in value.docs){
        //print(i.data());
        //print(i.data()['name']);
        //print(i.id);
        users[i.id] = i.data()['name'];
        //users.add(i.data()['name']);
      }
    });
    return users;
  }

  */

  Future<List> getUsers() async{
    List users = [];
    await userCollection.get().then((value){
      for(var i in value.docs){
        users.add(i.data()['name']);
      }
    });
    return users;
  }

  Future<int> numberOfQuizzes() async {
    return quizCollection.snapshots().length;
  }

  Future<Quiz> getQuizById(String id) async {
    var qs = await quizCollection.where('id', isEqualTo: id).get();
    //print(qs.docs[0].data());
    Quiz qById;
    if(qs.docs.length > 0) {
      var quizData = qs.docs[0].data();
      quizData['startTime'] = quizData['startTime'].toDate();
      quizData['endTime'] = quizData['endTime'].toDate();
      quizData['numQuestions'] = quizData['numQuestions'].toDouble();
      qById  = Quiz.fromJson(quizData);

      await quizCollection.doc(qs.docs[0].id).collection("Questions").get().then((questions) {
        for(var question in questions.docs){
          Question _question = Question.fromJson(question.data());
          qById.addQuestions(_question);
        }
      });
      return qById;
    }

    else {
      qById = Quiz.fromJson({'starttime': DateTime(2017, 9, 7, 17, 30),'endtime': DateTime(2017, 9, 7, 17, 30),'duration':'' ,'numQuestions':0.0 ,'marks':0 });
      return qById;
    }
    /*
    for(var q in qs.docs) {
      print("in getQuizById");
      print(q.id);
      print(q.data());
      //userCollection.doc(db_user.id).update({'quizzes_to_take': FieldValue.arrayUnion([q.title]),});

    }
    */
  }



  Future<List<Quiz>> getQuizzes(String category) async{
    List quizzesToTake = [];
    List<Quiz> qList = [];
    await userCollection.doc(uid).get().then((DocumentSnapshot ds) {
      quizzesToTake = ds.get(category);
      /*quizCollection.get().then((value){
        for(var i in value.docs){
          var quizData = i.data();
          print(quizData['title']);
          quizData['startTime'] = quizData['startTime'].toDate();
          quizData['endTime'] = quizData['endTime'].toDate();
          quizData['numQuestions'] = quizData['numQuestions'].toDouble();
          Quiz _quiz = Quiz.fromJson(quizData);
          print(_quiz.toString());
        }
      });*/
    }).catchError((e){});
    for (var quiz in quizzesToTake) {
      await quizCollection.doc(quiz).get().then((DocumentSnapshot qt) async {

        var quizData = qt.data();
        print(quizData['title']);
        quizData['startTime'] = quizData['startTime'].toDate();
        quizData['endTime'] = quizData['endTime'].toDate();
        quizData['numQuestions'] = quizData['numQuestions'].toDouble();
        Quiz _quiz = Quiz.fromJson(quizData);

        await quizCollection.doc(quiz).collection("Questions").get().then((questions) {
          for(var question in questions.docs){
            Question _question = Question.fromJson(question.data());
            _quiz.addQuestions(_question);
          }
        });
        qList.add(_quiz);
      }).catchError((e) {});
    }
    return qList;
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
    for(var user in q.takers){
      var db_users = await userCollection.where('name', isEqualTo: user).get();
      for(var db_user in db_users.docs){
        print(db_user.id);
        print(db_user.data());
        userCollection.doc(db_user.id).update({'quizzes_to_take': FieldValue.arrayUnion([q.title]),});
      }
    }
    //Reference storageRef = FirebaseStorage.instance.ref().child('quizDashImages');
    Reference storageRef = FirebaseStorage.instance.ref().child(q.id);
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