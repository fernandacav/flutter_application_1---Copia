import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/view/components/h1.dart';
import 'package:flutter_application_1/app/view/components/shape.dart';
import 'package:flutter_application_1/app/view/task_list/task_list_page.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            const Row(
              children: [
               Shape(),
              ],
            ),
            const SizedBox(height: 79,),
            Image.asset("assets/images/onboarding-image.png",
              width: 180,
              height: 168,
            ),
            const SizedBox(height: 99,),
            H1("Lista de tarefas"),
            const SizedBox(height: 21,),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return TaskListPage();
                }));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text("O aplicativo que te ajudará a organizar suas tarefas de forma inteligente e intuitiva.",
                textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
  }
}