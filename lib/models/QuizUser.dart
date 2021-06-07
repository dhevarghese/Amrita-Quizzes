

class QuizUser {

  final String name, department, section;
  List quizzesCreated, quizzesToTake;
  Map quizzesTaken;

  QuizUser({
    this.name,
    this.department,
    this.section,
    this.quizzesCreated,
    this.quizzesToTake
  });

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'department': department,
        'section': section,
        'quizzes_created': quizzesCreated,
        'quizzes_to_take': quizzesToTake,
        'quizzes_taken': quizzesTaken,
      };

  QuizUser.fromJson(Map parsedJson) :
        name = parsedJson['name'] ?? '',
        department = parsedJson['department'] ?? '',
        section = parsedJson['section'] ?? '',
        quizzesCreated = parsedJson['quizzes_created'] ?? [],
        quizzesToTake = parsedJson['quizzes_to_take'] ?? [],
        quizzesTaken = parsedJson['quizzes_taken'] ?? {};

  @override
  String toString(){
    return this.name +" "+ this.department +" "+ this.section;
  }
}