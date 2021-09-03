import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/app_button_style.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login to your account'),
        ),
        body: ListView(
          children: [_HeaderWidget()],
        ));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25,
            ),
            _FormWidget(),
            SizedBox(
              height: 25,
            ),
            Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDB, '
              'а также получить персональные рекомендации, необходимо войти '
              'в свою учётную запись. Если у вас нет учётной записи, '
              'её регистрация является бесплатной и простой. Нажмите здесь, '
              'чтобы начать.',
              style: textStyle,
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
                style: AppButtonStyle.linkButton,
                onPressed: () {},
                child: Text('Register')),
            SizedBox(
              height: 25,
            ),
            Text(
              'Если Вы зарегистрировались, но не получили письмо для '
              'подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
              style: textStyle,
            ),
            SizedBox(
              height: 5,
            ),
            TextButton(
                style: AppButtonStyle.linkButton,
                onPressed: () {},
                child: Text('Verify email')),
          ],
        ));
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(text:'admin');
  final _passwordTextController = TextEditingController(text: 'admin');
  String? errorText = null;

  void _auth() {
    final login = _loginTextController.text;
    final password = _passwordTextController.text;
    if (login == 'admin' && password == 'admin') {
      errorText = null;
      Navigator.of(context).pushReplacementNamed('/main_screen');
      print('open app');
    } else {
      errorText = 'Не верный логин или пароль';
      print('show error');
    }
    setState(() {});
  }

  void _resetPassword() {
    print('reset password');
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 16, color: Color(0xFF212529));
    final textFieldDecorator = const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
    );
    final color = const Color(0xFF01B4E4);
    final errorText = this.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///через 3 точки передаем массив виджетов в условии
        if (errorText != null) ...[
          Text(
            errorText,
            style: TextStyle(fontSize: 17, color: Colors.red),
          ),
          SizedBox(
            height: 20,
          ),
        ],
        Text(
          'Username',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _loginTextController,
          decoration: textFieldDecorator,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        TextField(
          controller: _passwordTextController,
          decoration: textFieldDecorator,
          obscureText: true,
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: _auth,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(color),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 15, vertical: 8))),
                child: Text('Login')),
            SizedBox(
              width: 30,
            ),
            TextButton(
                onPressed: _resetPassword,
                style: AppButtonStyle.linkButton,
                child: Text('Reset password')),
          ],
        )
      ],
    );
  }
}
