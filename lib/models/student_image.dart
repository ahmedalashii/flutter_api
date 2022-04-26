class StudentImage {
  late int id;
  late String image;
  late int studentId;

  StudentImage(
      {required this.id, required this.image, required this.studentId});

  StudentImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    studentId = json['student_id'];
  }
}
