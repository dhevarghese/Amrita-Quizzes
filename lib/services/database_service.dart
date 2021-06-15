
import 'dart:collection';
import 'dart:convert';

import 'package:amrita_quizzes/models/Questions.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/models/QuizUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  Future<void> updateQuiz(String quizId, [Map updateData, List qTakers]);
  Future<void> deleteQuiz(Quiz q);
  Future<void> updateQuizQuestions(String quizId, List<Question> questions);
  Future<void> uploadQuizScore(String quizId, String quizName, int marksObtained, int totalMarks, int numCorrectAnswers, LinkedHashMap answerIndex);
  Future<Map> getQuizScores(Quiz q);
  Future<bool> checkIfAlreadyTaken(String quizId);
}

class DatabaseService implements Database {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference quizCollection = FirebaseFirestore.instance.collection('quizzes');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String dept, String section) async {
    return await userCollection.doc(uid).get().then((value) async {
      if(value.exists){
        await userCollection.doc(uid).update({
          'name': name,
          'department': dept,
          'section':section,
        });
      }
      else{
        var status = await OneSignal.shared.getDeviceState();
        String tokenId = status.userId;

        await userCollection.doc(uid).set({
          'name': name,
          'department': dept,
          'section':section,
          'tokenId': tokenId,
        });
      }
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
    //await quizCollection.doc(q.title).set(q.toJson());
    var autoID = quizCollection.doc().id;
    await quizCollection.doc(autoID).set(q.toJson());
    for(int i = 0; i< q.questions.length; i++) {
      await quizCollection.doc(autoID).collection("Questions").doc("Question"+(i+1).toString()).set(q.getQuestionJson(i));
      //print(q.getQuestionJson(i));
    }
    await quizCollection.doc(autoID).update({'id': autoID});
    await userCollection.doc(uid).update({'quizzes_created': FieldValue.arrayUnion([autoID])});
    for(var user in q.takers){
      var db_users = await userCollection.where('name', isEqualTo: user).get();
      for(var db_user in db_users.docs){
        //print(db_user.id);
        //print(db_user.data());
        userCollection.doc(db_user.id).update({'quizzes_to_take': FieldValue.arrayUnion([autoID]),});
        if(db_user.data()["tokenId"] != Null){
          sendNotification([db_user.data()["tokenId"]], "You have been invited into a new quiz " + q.title, "New Quiz");
        }
      }
    }
    await quizCollection.doc(autoID).update({
      'total_Score': 0,
      'takers_Count': 0,
    });
    //Reference storageRef = FirebaseStorage.instance.ref().child('quizDashImages');
    Reference storageRef = FirebaseStorage.instance.ref().child(q.id);
    UploadTask uploadTask = storageRef.putFile(q.image);
    // Waits till the file is uploaded then stores the download url
    String imageURL="";
    return await uploadTask.whenComplete((){
      uploadTask.snapshot.ref.getDownloadURL().then((fileURL) {
        imageURL = fileURL;
        quizCollection.doc(autoID).update({'image': imageURL});
      });
    });
    //print('File Uploaded');

  }

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": "025dd3fa-08bd-47d1-8041-5b231f403a50", // App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color represent the color of the heading text in the notification
        "android_accent_color":"FF9976D2",

        //"small_icon":"ic_stat_onesignal_default",

        //"large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},

      }),
    );
  }

  Future<void> updateQuizQuestions(String quizId, List<Question> questions) async {
    for(Question ques in questions){
      await quizCollection.doc(quizId).collection("Questions").doc("Question"+(ques.id).toString()).set(ques.toJson());
    }
    return true;
  }

  Future<void> updateQuiz(String quizId, [Map updateData, List qTakers]) async {
    Map keyMap = {'qName': 'title', 'qDesc' : 'description', 'qPass': 'password', 'qMarks': 'marks',  'qCategory': 'category', 'qStartDate' : 'startTime', 'qEndDate' : 'endTime', 'qDuration': 'duration', 'qNav': 'nav', 'qPubScore': 'pubScore'};
    updateData.forEach((key, value) async {
      if(value != null && value != ""){
        if(keyMap[key] == "marks"){
          value = int.parse(value);
        }
        await quizCollection.doc(quizId).update({
          keyMap[key]: value
        });
      }
    });
    if(qTakers != null){
      await quizCollection.doc(quizId).update({
        'takers': FieldValue.arrayUnion(qTakers)
      });
      for(var user in qTakers){
        var dbUsers = await userCollection.where('name', isEqualTo: user).get();
        for(var dbUser in dbUsers.docs){
          userCollection.doc(dbUser.id).update({'quizzes_to_take': FieldValue.arrayUnion([quizId]),});
        }
      }
    }
    if(updateData["qPubScore"] == true){
      await quizCollection.doc(quizId).get().then((DocumentSnapshot ds) async {
        for(var user in ds.data()["takers"]){
          var db_users = await userCollection.where('name', isEqualTo: user).get();
          for(var db_user in db_users.docs){
            //print(db_user.id);
            //print(db_user.data());
            print(db_user.data()["tokenId"]);
            print(db_user.data()["quizzes_taken"][quizId]);
            sendNotification([db_user.data()["tokenId"]], "Scores for " + ds.data()["title"] + " have been published", "Scores Out");
            // if((db_user.data()["tokenId"] != null) && (db_user.data()["quizzes_taken"][quizId] != null)){
            //   sendNotification([db_user.data()["tokenId"]], "Scores for " + ds.data()["title"] + " have been published", "Scores Out");
            // }
          }
        }
      });
    }
    return true;
  }

  Future<void> deleteQuiz(Quiz q) async {
    //await userCollection.doc(uid).update({'quizzes_created': FieldValue.arrayRemove([q.id])});
    for(var user in q.takers){
      var dbUsers = await userCollection.where('name', isEqualTo: user).get();
      for(var dbUser in dbUsers.docs){
        await userCollection.doc(dbUser.id).update({'quizzes_to_take': FieldValue.arrayRemove([q.id]),});
      }
    }
    for(int i = 1; i<= q.questions.length; i++){
      await quizCollection.doc(q.id).collection("Questions").doc("Question"+i.toString()).delete();
    }
    await quizCollection.doc(q.id).delete();
    return true;
  }

  Future<void> uploadQuizScore(String quizId, String quizName, int marksObtained, int totalMarks, int numCorrectAnswers, LinkedHashMap answerIndex) async {
    Map newMap = new Map();
    answerIndex.forEach((key, value) {
      newMap[key.toString()] = value;
    });
    int totalScore = 0;
    int takersCount = 0;
    bool publish = false;
    await quizCollection.doc(quizId).get().then((DocumentSnapshot ds) {
      totalScore = ds.get("total_Score");
      takersCount = ds.get("takers_Count");
      publish = ds.get("pubScore");
    }).catchError((e){});

    takersCount+=1;
    totalScore+=marksObtained;

    await quizCollection.doc(quizId).update({
      'total_Score': totalScore,
      'takers_Count': takersCount,
    });

    List scoreDets = [marksObtained, totalMarks, numCorrectAnswers, quizName, newMap, publish];
    await userCollection.doc(uid).update({
      'quizzes_taken.'+quizId : scoreDets
    });
    return true;
  }

  Future<Map> getQuizScores(Quiz q) async {
    Map scoresData = new Map();
    int takersNA = 0;
    for(var user in q.takers){
      var dbUsers = await userCollection.where('name', isEqualTo: user).get();
      for(var dbUser in dbUsers.docs){
        await userCollection.doc(dbUser.id).get().then((ds){
          if(ds.data()['quizzes_taken'] != null){
            scoresData[user] =  ds.data()['quizzes_taken'][q.id];
            if(ds.data()['quizzes_taken'][q.id] == null){
              takersNA+=1;
            }
          }
          else{
            scoresData[user] = null;
            takersNA +=1;
          }
        });
      }
    }
    await quizCollection.doc(q.id).get().then((ds){
      scoresData["total_Score"] = ds["total_Score"];
      scoresData["takers_Count"] = ds["takers_Count"];
    });
    scoresData["NAC"] = takersNA;
    return scoresData;
  }

  Future<bool> checkIfAlreadyTaken(String quizId) async {
    bool taken =false;
    await userCollection.doc(uid).get().then((user) {
      if(user.data()['quizzes_taken'] != null){
        if(user.data()['quizzes_taken'][quizId] != null){
          taken=true;
        }
      }
    });
    return taken;
  }
}