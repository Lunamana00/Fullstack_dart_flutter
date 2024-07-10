import 'package:flutter/material.dart';
import 'pg_register.dart';

class Character {
  final String name;
  final String type;
  final String imagePath;

  Character({required this.name, required this.type, required this.imagePath});
}

class CharacterSelectionPage extends StatefulWidget {
  @override
  _CharacterSelectionPageState createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final List<Character> characters = [
    Character(name: '냥이', type: 'cat', imagePath: 'assets/char/cat1.png'),
    Character(name: '멍이', type: 'dog', imagePath: 'assets/char/dog1.png'),
    Character(
        name: '곰이', type: 'polarbear', imagePath: 'assets/char/polarbear1.png'),
    Character(
        name: '레서', type: 'redpanda', imagePath: 'assets/char/redpanda1.png')
  ];

  int currentIndex = 0;

  void _showConfirmationDialog(Character character) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('${character.name}를 선택하시겠습니까?',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterPage(selectedCharacter: character.type),
                  ),
                );
              },
              child: const Text('네'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니요'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '캐릭터 선택',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.purple.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 90),
          Expanded(
            child: PageView.builder(
              itemCount: characters.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            characters[index].imagePath,
                            width: 300,
                            height: 300,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            characters[index].name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(characters[currentIndex]);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: Text(
              '${characters[currentIndex].name} 선택',
            ),
          ),
          const SizedBox(height: 150)
        ],
      ),
    );
  }
}
