import 'package:flutter/material.dart';
import 'package:flutter_myntua/widgets/appbar.dart';
import 'package:flutter_myntua/models/person.dart';

//Contains: Friend, FriendProfileScreen, FriendRow and the friend dummy data

class Friend extends Person {
  final DateTime friendsSince;

  Friend({
    required super.photoUrl,
    required super.name,
    required super.currentLocation,
    required super.school,
    required super.interests,
    required super.timeSpent,
    required this.friendsSince,
  });

  // Factory method to create a Friend from a Person
  factory Friend.fromPerson(Person person) {
    return Friend(
      photoUrl: person.photoUrl,
      name: person.name,
      currentLocation: person.currentLocation,
      school: person.school,
      interests: person.interests,
      timeSpent: person.timeSpent,
      friendsSince: DateTime.now(),
    );
  }
}

class FriendProfileScreen extends StatelessWidget {
  final Friend friend;

  const FriendProfileScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Add remove friend button
          IconButton(
            icon: const Icon(Icons.person_remove),
            color: Colors.red,
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Remove Friend'),
                    content: Text(
                        'Are you sure you want to remove ${friend.name} from your friends?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Remove',
                            style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          friends.removeWhere((f) => f.name == friend.name);
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Return to friends list
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(friend.photoUrl),
              ),
            ),
            SizedBox(height: 20),
            // Name and Location
            Text(
              friend.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${friend.currentLocation}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // School
            Text(
              'School: ${friend.school}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Interests
            Text(
              'Interests: ${friend.interests.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Time Spent in Location
            Text(
              'Time spent in ${friend.currentLocation}: ${friend.timeSpent}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomBar(currentIndex: -1), // You can customize the bottom bar
    );
  }
}

class FriendRow extends StatelessWidget {
  final Friend friend;

  const FriendRow({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to friend's profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendProfileScreen(friend: friend),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            // Profile Photo Column
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(friend.photoUrl),
              ),
            ),
            // Name and Location Column
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      friend.currentLocation,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Dummy Data

final List<Person> persons = [
  Person(
    name: 'Makis Papadakis',
    currentLocation: 'NTUA Library',
    photoUrl: 'assets/images/makis.png',
    school: 'ECE',
    interests: ['Coding', 'Gaming'],
    timeSpent: '12 hours',
  ),
  Person(
    name: 'John Doe',
    currentLocation: 'ECE Cafeteria',
    photoUrl: 'assets/images/john.png',
    school: 'MECH',
    interests: ['Music', 'Traveling'],
    timeSpent: '568 hours',
  ),
  Person(
    name: 'Dimitra Papangeli',
    currentLocation: 'ECE Restaurant',
    photoUrl: 'assets/images/dimitra.png',
    school: 'ECE',
    interests: ['Dance', 'Volunteering'],
    timeSpent: '1240 hours',
  ),
  Person(
    name: 'Kiriaki Fragkonikolaki',
    currentLocation: 'ECE Restaurant',
    photoUrl: 'assets/images/Kiriaki.png',
    school: 'ECE',
    interests: ['Volunteering', 'Traveling'],
    timeSpent: '1089',
  ),
];

// Convert first two persons to friends
final List<Friend> friends = [
  Friend.fromPerson(persons[0]), // Makis is now a friend
  Friend.fromPerson(persons[1]), // John is now a friend
];
