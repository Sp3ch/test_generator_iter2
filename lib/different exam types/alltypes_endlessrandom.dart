import 'package:flutter/material.dart';
import 'package:test_generator_iter2/roundedButton.dart';

import '../question_page/question_page.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';

class AllTypesEndlessRandomStarter extends StatelessWidget
{
  final Graph graph;

  AllTypesEndlessRandomStarter(this.graph);

  @override
  Widget build(BuildContext context) {
    return Column
    (
      children:<Widget>
      [
        const Text
        (
          "Проверочная работа бесконечно долго формирует новые задания. Работа заканчивается по нажатию кнопки \"Закончить\". \nПравильность оценивается относительно сгенерированного и предоставленного для решения количества заданий. Запомните, что, если Вы хотите закончить проверочную работу, не нужно переходить на следующее задание после последнего, иначе придётся верно решить и следующее задание.",
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height:20),
        WidgetRoundedTextButton
        (
          text: "Начать бесконечную проверочную работу",
          color: const Color.fromARGB(255, 158, 180, 208),
          onPressed: 
          ()
          {
            Navigator.of(context).push
            (
              MaterialPageRoute
              (
                builder: 
                (context)
                  => QuestionPageMain
                  (
                    Exam_AllTypes_EndlessRandom(graph,true)
                  )
              )
            );
          },
        ),
      ]
    );
  }

}