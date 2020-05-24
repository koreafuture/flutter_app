import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sttbasicui/database/memo.dart';
import 'package:sttbasicui/database/db.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

class WritePage extends StatelessWidget {
  String path = '';
  String title = '';
  String text = '';
  int record = 0;
  WritePage({Key key, this.path}) : super(key: key);
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: <Widget>[
            record == 0     //작동 안됨...
            ?IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: (){
                record = 1;
                playaudio(path);
              },
            )
            :IconButton(
              icon: const Icon(Icons.stop),
              onPressed: (){
                record = 0;
              },
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveDB,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                maxLines: 2,
                onChanged: (String title) {
                  this.title = title;
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 제목을 적어주세요.',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                maxLines: 8,
                onChanged: (String text) {
                  this.text = text;
                },
                //obscureText: true,
                decoration: InputDecoration(
                  //border: OutlineInputBorder(),
                  hintText: '메모의 내용을 적어주세요.',
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: str2Sha512(DateTime.now().toString()), // String
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: this.path,
    );

    await sd.insertMemo(fido);

    print(await sd.memos());
    Navigator.pop(_context);
  }

  String str2Sha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

  void playaudio (String path) async
  {
    AudioPlayer audioPlayer = AudioPlayer();
    print('playaudio$path');
    await audioPlayer.play(path, isLocal: true);
    record = 0;
  }
}
