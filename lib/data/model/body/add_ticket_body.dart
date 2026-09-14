
class AddTicketBody {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  int? designationId;
  int? employeeStatusId;
  int? departmentId;
  String? joiningDate;
  String? salary;
  String? profilePicture;
  AddTicketBody({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.designationId,
    this.employeeStatusId,
    this.departmentId,
    this.joiningDate,
    this.salary,
    this.profilePicture,
  });

  AddTicketBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    designationId = json['designation_id'];
    employeeStatusId = json['employee_status_id'];
    departmentId = json['department_id'];
    joiningDate = json['joining_date'];
    salary = json['salary'];
    profilePicture = json['profile_picture'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['gender'] = gender;
    data['designation_id'] = designationId;
    data['employee_status_id'] = employeeStatusId;
    data['department_id'] = departmentId;
    data['joining_date'] = joiningDate;
    data['salary'] = salary;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
