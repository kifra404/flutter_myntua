import 'package:flutter/material.dart';
import 'package:flutter_myntua/widgets/appbar.dart';
import 'package:flutter_myntua/widgets/friend.dart';
import 'package:flutter_myntua/models/person.dart';

class FriendRow extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const FriendRow({required this.friend, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            // Profile photo
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(friend.photoUrl),
            ),
            const SizedBox(width: 16),
            // Name and current location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    friend.currentLocation,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  String searchQuery = '';
  List<Person> searchResults = [];

  void searchPeople(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = persons
            .where((person) =>
                person.name.toLowerCase().contains(query.toLowerCase()) &&
                !friends.any((friend) => friend.name == person.name))
            .toList();
      }
    });
  }

  void addFriend(Person person) {
    setState(() {
      friends.add(Friend.fromPerson(person));
      searchResults.remove(person);
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(isHomeScreen: false),
      body: Column(
        children: [
          // Molecule Bar Image
          Image.asset(
            'assets/images/Molecule Bar Friends.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for people...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onChanged: searchPeople,
            ),
          ),
          // Search Results
          if (searchResults.isNotEmpty)
            Container(
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Search Results',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ...searchResults.map((person) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(person.photoUrl),
                        ),
                        title: Text(person.name),
                        subtitle: Text(person.school),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () => addFriend(person),
                        ),
                      )),
                ],
              ),
            ),
          // Friends List
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return FriendRow(
                  friend: friend,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FriendProfileScreen(friend: friend),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(currentIndex: 1),
    );
  }
} // FriendsScreen widget
