import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/features/auth/models/token_dto.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

import '../../../theme/app_button_style.dart';
import '../../../theme/app_colors.dart';
import '../exceptions/auth_exception.dart';

/// Screen for authorization process.
///
/// Contains [IAuthRepository] to do so.
class AuthScreen extends StatefulWidget {
  /// Repository for auth implementation.
  final IAuthRepository authRepository;

  /// Constructor for [AuthScreen].
  const AuthScreen({
    required this.authRepository,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // TODO(task): Implement Auth screen.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.cyan,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: _HeaderWidget(),
        ),
      ),
    );
    throw UnimplementedError();
  }

  // void _pushToChat(BuildContext context, TokenDto token) {
  //   Navigator.push<ChatScreen>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) {
  //         return ChatScreen(
  //           chatRepository: ChatRepository(
  //             StudyJamClient().getAuthorizedClient(token.token),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);
  final color = const Color(0xFF01B4E4);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle (
      fontSize: 15,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 150,),
          _FormWidget(),
          SizedBox(height: 25,),
          // const Text('какой-то текст',
          //   style: textStyle,
          // ),
          // const SizedBox(height: 5,),
          // TextButton(
          //   style: AppButtonStyle.linkButton,
          //   onPressed: (){},
          //   child: const Text('Register'),),
          // const SizedBox(height: 25,),
          // const Text("If you signed up but didn't get your verification email, click here to have it resent.",
          //   style: textStyle,
          // ),
          // const SizedBox(height: 5,),
          // TextButton(
          //   style: AppButtonStyle.linkButton,
          //   onPressed: (){},
          //   child: const Text('Verify email'),),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(text: 'test');
  final _passwordTextController = TextEditingController(text: 'test');
  String? errorText;

  void _auth() async {
    // final login = _loginTextController.text;
    // final password = _passwordTextController.text;
    //
    const login = 'pplotko';
    const password = 'RRhdwWV0ZnCc';

    StudyJamClient studyJamClient = StudyJamClient();

    try {
      var authRepository = AuthRepository(studyJamClient);

      final token = await authRepository.signIn(
          login: login, password: password
      );
        print('token: $token');
        _pushToChat(context, token);
        errorText = null;

    }
    on AuthException catch (exception) {
        errorText = 'Error!';
        // errorText = 'Wrong login or password!';
        // print('Ошибка при получении токена!');
    }
    setState(() {});
  }
  void _pushToChat(BuildContext context, TokenDto token) {
    Navigator.push<ChatScreen>(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChatScreen(
            chatRepository: ChatRepository(
              StudyJamClient().getAuthorizedClient(token.token),
            ),
          );
        },
      ),
    );
  }
  void _resetPassword() {
    print('resetPassword');
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle (
      fontSize: 15,
      color: Color(0xFF212529),
    );
    // const textFieldDecorator = InputDecoration(
    //   // border: OutlineInputBorder(),
    //   isCollapsed: true,
    //   contentPadding: EdgeInsets.symmetric(vertical:10, horizontal: 10),
    //   enabledBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: Color(0xFFced4da), width: 1),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderSide: BorderSide(color: AppColors.mainLightGreen, width: 1),
    //   ),
    // );

    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) ...[
          Text(errorText,
            style: const TextStyle(
                color: Colors.red,
                fontSize: 17 ),
          ),
          const SizedBox(height: 20,)],

        // const Text('Username',
        //     style : textStyle),
        // const SizedBox(height: 5,),
        TextField(
          controller: _loginTextController,
          // decoration: textFieldDecorator,
          decoration:  const InputDecoration(
            isCollapsed: true,
            prefixIcon: Icon(Icons.person),
            labelText: 'Логин',
            contentPadding: EdgeInsets.symmetric(vertical:10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFced4da), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainGreenMoreDark, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        // const Text('Password',
        //     style : textStyle),
        // const SizedBox(height: 5,),
        TextField(
          controller: _passwordTextController,
          // decoration: textFieldDecorator,
          decoration:  const InputDecoration(
            isCollapsed: true,
            prefixIcon: Icon(Icons.lock),
            labelText: 'Пароль',
            contentPadding: EdgeInsets.symmetric(vertical:10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFced4da), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainGreenMoreDark, width: 2),
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 30,),
        Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.mainGreenMoreDark),
                foregroundColor: MaterialStateProperty.all(AppColors.foregroundLightGreen),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                ),
              ),
              onPressed: _auth,
              child: const Text('ДАЛЕЕ',),
            ),
          ),
        ),
      ],
    );
  }
}
