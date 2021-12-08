import 'package:flutter/material.dart';
import 'package:themoviedb/Library/Widgets/inherited/provider.dart';
import 'package:themoviedb/Theme/app_button_style.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';



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
          title: const Text('Login to your account'),
        ),
        body: ListView(
          children: const [_HeaderWidget()],
        ));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle =  TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            const _FormWidget(),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDB, '
              'а также получить персональные рекомендации, необходимо войти '
              'в свою учётную запись. Если у вас нет учётной записи, '
              'её регистрация является бесплатной и простой. Нажмите здесь, '
              'чтобы начать.',
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                style: AppButtonStyle.linkButton,
                onPressed: () {},
                child: const Text('Register')),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Если Вы зарегистрировались, но не получили письмо для '
              'подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
                style: AppButtonStyle.linkButton,
                onPressed: () {},
                child: const Text('Verify email')),
          ],
        ));
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.readFromModel<AuthModel>(context);
    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xff212529),
    );
    const textFieldDecorator = InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true);
    //Объявляем переменную почему так не понял
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text(
          'Username',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          decoration: textFieldDecorator,
          controller: model?.loginTextController,
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          'Password',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.passwordTextController,
          obscureText: true,
          decoration: textFieldDecorator,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(
              width: 30,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Reset password'),
              style: AppButtonStyle.linkButton,
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    if (model?.canStartAuth == true) {
      model?.auth(context);
      print('can start auth');
    } else {
      print('cant start auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF01b4e4);
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            height: 19,
            width: 41,
          )
        : const Text('Login');
    return ElevatedButton(
      onPressed: () => pressff(context),
      child: child,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.zero),
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 15, vertical: 8))),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watchOnModel<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 17)),
    );
  }
}
