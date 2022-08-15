import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_local_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';

import '../../../theme/app_colors.dart';
import '../models/chat_geolocation_geolocation_dto.dart';
import '../models/chat_message_location_dto.dart';

/// Main screen of chat app, containing messages.
class ChatScreen extends StatefulWidget {
  /// Repository for chat functionality.
  final IChatRepository chatRepository;

  /// Constructor for [ChatScreen].
  const ChatScreen({
    required this.chatRepository,
    Key? key,
  }) : super(key: key);



  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _nameEditingController = TextEditingController();

  Iterable<ChatMessageDto> _currentMessages = [];
  String geoMessageText1 = '111';

  // set geoMessageText(String geoMessageText) {}
  String get geoMessageText => geoMessageText1;

  @override
  initState(){
    _onUpdatePressed();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: _ChatAppBar(
          controller: _nameEditingController,
          onUpdatePressed: _onUpdatePressed,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ChatBody(
              messages: _currentMessages,
            ),
          ),
          _ChatTextField(
              onSendPressed: _onSendPressed,
              geoLocationAdded: _geoLocationAdded,
          ),
        ],
      ),
    );
  }

  Future<void> _onUpdatePressed() async {
    final messages = await widget.chatRepository.getMessages();
    setState(() {
      _currentMessages = messages;
    });
  }

  Future<void> _onSendPressed(String messageText) async {
    final messages = await widget.chatRepository.sendMessage(messageText);
    setState(() {
      _currentMessages = messages;
    });
  }

  Future<void> _geoLocationAdded(ChatGeolocationDto location) async {
    // geoMessageText = 'какой-то текст';
    final messages = await widget.chatRepository.sendGeolocationMessage(location: location, message: geoMessageText);
    setState(() {
      _currentMessages = messages;
    });
  }
}

class _ChatBody extends StatelessWidget {
  final Iterable<ChatMessageDto> messages;

  const _ChatBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) => _ChatMessage(
        chatData: messages.elementAt(index),
      ),
    );
  }
}

class _ChatTextField extends StatelessWidget {
  final ValueChanged<String> onSendPressed;
  final ValueChanged <ChatGeolocationDto> geoLocationAdded;

  final _textEditingController = TextEditingController();

  _ChatTextField({
    required this.onSendPressed,
    required this.geoLocationAdded,
    Key? key,
  }) : super(key: key);


  set curentMessage(String curentMessage) {}
  String get curentMessage => curentMessage;


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 8,
          bottom: mediaQuery.padding.bottom + 8,
          left: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  hintText: 'Сообщение',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFced4da), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.mainGreenMoreDark, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ChatGeolocationDto curentLocation = ChatGeolocationDto(
                  longitude: 27,
                  latitude: 54,
                );
                // print(curentLocation.toString());
                // curentMessage = _textEditingController.text;
                geoLocationAdded(curentLocation);
              },
              icon: const Icon(Icons.location_on),
              color: colorScheme.onSurface,
            ),
            IconButton(
              onPressed: () => onSendPressed(_textEditingController.text),
              icon: const Icon(Icons.send),
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final VoidCallback onUpdatePressed;
  final TextEditingController controller;

  const _ChatAppBar({
    required this.onUpdatePressed,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.mainGreenMoreDark,
      foregroundColor: AppColors.foregroundLightGreen,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onUpdatePressed,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  // final ChatMessageDto chatData;
  var chatData;
  // final ChatMessageGeolocationDto location;
  _ChatMessage({
    required this.chatData,
    // required this.location,
    Key? key,
  }) : super(key: key);

  @override
  // late ChatMessageGeolocationDto location;

   Widget build(BuildContext context) {


    ChatGeolocationDto? location;
    String locationForChat= '';
    final colorScheme = Theme.of(context).colorScheme;
    Color myColor;
    if (chatData is ChatMessageGeolocationDto) {
      myColor = AppColors.mainDarkBlue.withOpacity(.2);
      ChatGeolocationDto location = chatData.location;
      print('location latitude: ${location.latitude}' );
      print('location longitude: ${location.longitude}' );
      locationForChat = 'Геометка:\n   location latitude: ${location.latitude}\n'+ '   location longitude: ${location.longitude}' ;
    } else {
      myColor = AppColors.mainLightGreen;

    }

    List<String> chatImages = [];
    List<Widget> widgetImages = [];
    //
    // List<String>imagesList =[];
    if (chatData.images != null ) {
      chatData.images.forEach((image) {
        image != null ? widgetImages.add(Image.network(image)) : print("Null = ${chatData.images.indexOf(image)}");
      });
    } else {
      widgetImages.add(SizedBox());
      // widgetImages.add(Image.network("https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png"));
      print("chatData.images = null");
    }
    //   // (chatData.images).forEach((image) => imagesList.add(image));
    //   print('chatImages: $chatImages');
    //   // for (int i=0; i < chatData.images.lenght-1; i++ ){
    //   //   chatImages.add(chatData.images[i]);
    //   // }
    // } else { chatImages.add('1');
    // };


    if (chatData.images != null) {print('chatData.images ${chatData.images}');};

    return Material(
      // color: chatData.chatUserDto is ChatUserLocalDto ? colorScheme.primary.withOpacity(.1) : null,
      color: chatData.chatUserDto is ChatUserLocalDto ? myColor.withOpacity(.1) : myColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChatAvatar(userData: chatData.chatUserDto),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    chatData.chatUserDto.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Bubble(
                    style: const BubbleStyle(
                      nip: BubbleNip.leftBottom,
                      color: Color.fromARGB(255, 225, 255, 199),
                      borderColor: Colors.green,
                      borderWidth: 1,
                      elevation: 4,
                      margin: BubbleEdges.only(top: 8, left: 50),
                      alignment: Alignment.topLeft,
                    ),
                    child: Text(chatData.message ?? '')),
                  const SizedBox(height: 4),
                  Text(locationForChat != '' ? locationForChat : ''),
                  const SizedBox(height: 4),
                  // chatData.images != null ? Image.network(chatData.images[0]) : SizedBox(height: 4),
                  widgetImages.isNotEmpty ? Column(children: widgetImages,) : SizedBox(height: 4),
                  // chatData.images != null ? Image.network(chatData.images[1]) : SizedBox(height: 4),
                  // chatImages[0] != '1' ? chatImages.forEach((item) => Image.network(item)) : SizedBox(height: 4),

                  // chatData.images != null ? chatData.images.forEach((item) => Image.network(item)) : SizedBox(height: 4),
                  Text('Сообщение создано:\n ${chatData.createdDateTime.toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  static const double _size = 42;

  final ChatUserDto userData;

  const _ChatAvatar({
    required this.userData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = '';
    final colorScheme = Theme.of(context).colorScheme;
    if (userData.name != null) {
      if (userData.name!.contains(' ') && userData.name![userData.name!.length-1] != " ") {
        userName = '${userData.name!.split(' ').first[0]}${userData.name!.split(
            ' ').last[0]}';
      } else {
        userName = '${userData.name![0]}';
        print('bad name there: userData.name');
      }
    } else {
      userName = "*";
    }
    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        // color: colorScheme.primary,
        color: AppColors.mainGreenMoreDark,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            userName,
              // userData.name != null
              //   ? '${userData.name!.split(' ').first[0]}${userData.name!.split(
              //       ' ').last[0]}'
              //   : '-',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

        ),
      ),
    );
  }
}
