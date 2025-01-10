import 'package:flutter_myntua/models/person.dart';
import 'package:flutter_myntua/widgets/friend.dart';

class User extends Person {
  final List<Friend> friends;

  User({
    required super.name,
    required super.currentLocation,
    required super.school,
    required super.interests,
    required super.timeSpent,
    required super.photoUrl,
    required this.friends,
  });
}

// Create the current user instance
final currentUser = User(
  name: 'Maria',
  currentLocation: 'ECE Cafeteria',
  school: 'ECE',
  interests: ['Physics'],
  timeSpent: '300 hours',
  photoUrl: 'assets/images/maria.png',
  friends: friends, // Using the existing friends list
);
