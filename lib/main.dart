import 'package:flutter/material.dart';
import 'loading_pages/start_page.dart';
import "question_page/question_page.dart";

import 'package:kb_lib_iter2/kb_lib_iter2.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme
        (
          bodyLarge: TextStyle(fontSize: 12.0),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey
      ),
      home: LoadPageMain()
    );
  }
}


/////////////////////////////////

/*BlocBuilder<CounterCubit,int>(
        builder: (context,count)=>Center(child:Text("$count")))*/


