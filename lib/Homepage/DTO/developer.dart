import 'dart:convert';


List<Developer> allDataFromJson(String str) {

  final jsonData = (json.decode(str))["data"];
  print(jsonData);
  return new List<Developer>.from(jsonData.map((x) => Developer.fromJson(x)));
}

class Developer {
  final String name;
  final String email;
  final String skills;
  final String current_company;
  final bool is_intern;
  final bool actively_job_searching;
  final String address;
  final String state;
  final String github_url;
  final String linkedin_url;


  Developer({this.name, this.email, this.skills, this.current_company,this.is_intern,this.actively_job_searching,this.address,this.state,this.github_url,this.linkedin_url});

  factory Developer.fromJson(Map<String, dynamic> json) {
    return Developer(
      name: json["name"],
      email: json["email"],
      skills: json["skills"],
      is_intern: json["is_intern"],
      current_company: json["current_company"],
      actively_job_searching: json["actively_job_searching"],
      address: json["address"],
      state: json["state"],
      github_url: json["github_url"],
      linkedin_url: json["linkedin_url"]
    );
  }
  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "skills": skills,
    "is_intern": is_intern,
    "current_company": current_company,
    "actively_job_searching": actively_job_searching,
    "address": address,
    "state": state,
    "github_url": github_url,
    "linkedin_url": linkedin_url,
  };

}