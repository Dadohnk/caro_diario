import 'dart:io';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import './diary_list.dart';
import './bottom_nav_bar.dart';
import '../screens/main_diary_screen.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();

  static const routeName = '/diary_page';
}

class _DiaryPageState extends State<DiaryPage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late FocusNode _focusNode;
  File? _storedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Caro diario, ');
    _bodyController = TextEditingController();
    _focusNode = new FocusNode();
    _focusNode.addListener(() => print('focusNode updated: hasFocus: ${_focusNode.hasFocus}'));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void setFocus(){
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _saveDiaryPage() {
    var id = ShortUuid().generate();
    print(_titleController.text);
    print(_bodyController.text);
    print(id);
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      print('somethings empty');
      return;
    }
    DateTime now = DateTime.now();
    String dateTimeFormatted = DateFormat('yMd - kk:mm').format(now);
    Provider.of<DiaryList>(context, listen: false).addPage(
        id.toString(), _titleController.text, _bodyController.text, dateTimeFormatted,);
    print('saved page');
    Navigator.pushReplacementNamed(context, MainDiaryScreen.routeName);
  }

  Future<void> addImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Provider.of<DiaryList>(context, listen: false).getImagePath(image!);
    setState(() {
      _storedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height - AppBar().preferredSize.height - 30;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(elevation: 0, shadowColor: null, title: Center(child: Text('Write your new page', style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center,)),
      actions: [
        IconButton(onPressed: addImage, icon: Icon(Icons.add_photo_alternate_outlined))
      ],),
      bottomNavigationBar: BottomNavBar(),
      body: Column(
        children: [
          Center(
            child: Container(
            height: height - 130,
            child: Card(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                    child: Column(
                        children: [
                          Container(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _titleController,
                              decoration: new InputDecoration.collapsed(hintText: ''),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                          Container(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _bodyController,
                              decoration: InputDecoration(labelText: '...'),
                              keyboardType: TextInputType.multiline,
                              maxLines: 25,
                            ),
                          ),
                            ],
                          )
                      ),
                  ),
                Align(
                  alignment: Alignment.topRight,
                child: ConstrainedBox(
                    constraints: BoxConstraints.tight(Size.fromRadius(80)),
                    child: Card(
                      child: _storedImage == null ? null : Image.file(_storedImage!),))),
                  Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                        constraints: BoxConstraints.tight(Size.fromRadius(30)),
                        child: Image.asset('assets/images/paper-clip.png')),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        tooltip: 'Add your new page',
                        hoverColor: null,
                        focusColor: null,
                        onPressed: _saveDiaryPage,
                        child: Icon((Icons.check_circle_outline_sharp), size: 35, color: Colors.greenAccent,)),
                  ),
                ]
              ),
                ),
              ),
          ),
            ]
      ),
    );
  }
}