import 'package:flutter/material.dart';
import 'package:test_generator_iter2/roundedButton.dart';

import '../loading_pages/start_page.dart';

class ResultPage extends StatefulWidget
{
  final double totalPoints;
  final double earnedPoints;
  final double score;
  final int questionsRight;
  final int totalQuestions;
  final int errors;

  ResultPage
  (
    {
      required this.earnedPoints, 
      required this.totalPoints, 
      required this.score,
      required this.questionsRight,
      required this.totalQuestions,
      required this.errors,
      super.key, 
    }
  );

  @override
  State<StatefulWidget> createState() {return ResultPageState();}
}

class ResultPageState extends State<ResultPage>
{
  Color successColor=const Color.fromARGB(255, 76, 175, 79);
  Color failColor=const Color.fromARGB(255, 193, 200, 54);
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar(toolbarHeight: 0,),
      body:Container
      (
        color: const Color.fromARGB(255, 229, 226, 226),
        child: Center(
          child: Container(
            decoration: BoxDecoration
            (
              color: Color.fromARGB
                  (
                    255, 
                    (failColor.red*(1-widget.score)+successColor.red*(widget.score)).round(), 
                    (failColor.green*(1-widget.score)+successColor.green*(widget.score)).round(), 
                    (failColor.blue*(1-widget.score)+successColor.blue*(widget.score)).round()
                  ), 
              borderRadius: const BorderRadius.all(Radius.circular(16))
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,6,10,6),
              child: Column
              (
                mainAxisSize: MainAxisSize.min,
                children:<Widget>
                [
                  const SizedBox(height:5),
                  SizedBox
                  (
                    child:Text
                    (
                      "Правильность: ${(widget.score*10000).round()/100}%",
                      style: const TextStyle(fontSize:20),
                    )
                  ),
                  const SizedBox(height:5),
                  SizedBox
                  (
                    child:Text
                    (
                      "Ошибок:${widget.errors}",
                      style: const TextStyle(fontSize:20),
                    )
                  ),
                  const SizedBox(height:5),
                  WidgetRoundedTextButton
                  (
                    text: "Вернуться на стартовую страницу", 
                    color: Colors.white,
                    onPressed: ()
                    {
                      Navigator.of(context).push
                        (
                          MaterialPageRoute
                            (builder: (context) => LoadPageMain())
                        );
                    },
                  ),
                  const SizedBox(height:5),
                ] 
              ),
            ),
          ),
        )
      )
    );
  }
}