import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Quiz_info {
   String image, title, description, price, faculty, duration, category;
   int  size, id, marks;
   Color color;
  Quiz_info({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.category,
    this.size,
    this.color,
    this.faculty,
    this.duration,
    this.marks
  });


}
/*
Future<void> readJsonProduct() async {
  final String response = await rootBundle.loadString('assets/categories.json');
  final data = await json.decode(response);
  //_items = data["Categories"];
  test = data["QuizInfo"];
  print(test);
  for (int i = 0; i < test.length; i++) {
    var tempid = test[i]["id"];
    var temptitle = test[i]["title"];
    var tempprice = test[i]["price"];
    var tempsize = test[i]["size"];
    var tempimage = test[i]["id"];
    var tempcolor = Color(int.parse(test[i]["colorcode"]));
    var tempdescription = test[i]["description"];
    var tempfaculty = test[i]["faculty"];
    var tempmarks = test[i]["marks"];
    var tempduration = test[i]["duration"];

    var temp_Product = Product(
      id: tempid,
      title: temptitle,
      price: tempprice,
      size: tempsize,
      image: tempimage,
      color: tempcolor,
      description: tempdescription,
      faculty: tempfaculty,
      marks: tempmarks,
      duration: tempduration);
    productstest.add(temp_Product);
    products.add(temp_Product); // comment this later, used for test
  }


}
*/
//List test = [];
List<Quiz_info> productstest = [];
List<Quiz_info> products = [];
/*
List<Product> products = [
  Product(
      id: 1,
      title: "Machine Learning",
      price: "23:00",
      size: 12,
      description: dummyText,//bruh1
      image: "assets/images/pngegg.png",
      color: Color(0xFF3D82AE),
      faculty: "Dr.Kannan",
      marks: 20,
      category: "CSE",
      duration: "1 hour"),
  Product(
      id: 2,
      title: "CIR",
      price: "11:30",
      size: 8,
      description: dummyText,
      image: "assets/images/pngegg-1.png",
      color: Color(0xFFD3A984),
      faculty: "Dr.Kannan",
      marks: 20,
      category: "CSE",
      duration: "1 hour"),
  Product(
      id: 3,
      title: "Biology Fundamentals",
      price: "23:00",
      size: 10,
      description: dummyText,
      image: "assets/images/pngegg-2.png",
      color: Color(0xFF989493),
      faculty: "Dr.Kannan",
      marks: 20,
      category: "CSE",
      duration: "1 hour"),
  Product(
      id: 4,
      title: "Chemistry Lab",
      price: "23:00",
      size: 11,
      description: dummyText,
      image: "assets/images/pngegg-3.png",
      color: Color(0xFFE6B398),
      faculty: "Dr.Kannan",
      marks: 20,
      category: "CSE",
      duration: "1 hour"),
  Product(
      id: 5,
      title: "Biometrics",
      price: "23:00",
      size: 12,
      description: dummyText,
      image: "assets/images/pngegg-4.png",
      color: Color(0xFFFB7883),
      faculty: "Dr.Kannan",
      marks: 20,
      category: "CSE",
      duration: "1 hour"),
  Product(
    id: 6,
    title: "Statistics",
    price: "23:00",
    size: 12,
    description: dummyText,
    image: "assets/images/bag_6.png",
    color: Color(0xFFAEAEAE),
    faculty: "Dr.Kannan",
    marks: 20,
    category: "CSE",
    duration: "1 hour",
  ),
];
*/
String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
