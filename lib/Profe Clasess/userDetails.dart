
final String url = 'https://jsonplaceholder.typicode.com/users';
class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails({required this.id, required this.firstName, required this.lastName, this.profileUrl = 'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}