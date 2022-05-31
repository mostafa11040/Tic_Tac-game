import 'package:flutter/material.dart';

import 'logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool isover = false;
  int turn = 0;
  String result = 'xxxxxxxxx';
  Game game = Game();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          SwitchListTile.adaptive(
            title: const Text(
              'turn on/of two players ',
              style: TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
            value: isSwitched,
            onChanged: (bool newValue) {
              setState(() {
                isSwitched = newValue;
              });
            },
          ),
          Text('it\'s $activePlayer turn'.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 52,
              ),
              textAlign: TextAlign.center),
          Expanded(
              child: GridView.count(
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            crossAxisCount: 3,
            children: List.generate(
                9,
                ((index) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isover ? null : () => _ontap(index),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                              Player.playerX.contains(index)
                                  ? 'X'
                                  : Player.playerO.contains(index)
                                      ? 'O'
                                      : '',
                              style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.pink,
                                fontSize: 52,
                              )),
                        ),
                      ),
                    ))),
          )),
          Text(result,
              style: const TextStyle(color: Colors.white, fontSize: 52),
              textAlign: TextAlign.center),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Player.playerX = [];
                Player.playerO = [];
                activePlayer = 'X';
                isover = false;
                turn = 0;
                result = '';
              });
            },
            icon: const Icon(Icons.repeat),
            label: const Text('repeat'),
          )
        ],
      )),
    );
  }

  _ontap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index)))
      game.playGame(index, activePlayer);
    updatePlayer();

    if (!isSwitched && !isover && turn != 9) {
      await game.autoPlay(activePlayer);
      updatePlayer();
    }
  }

  void updatePlayer() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        isover = true;
        result = '$winnerPlayer is the winner';
      } else if (!isover && turn == 9) {
        result = 'it\'s Draw!';
      }
    });
  }
}
