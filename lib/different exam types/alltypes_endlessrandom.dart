import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_generator_iter2/roundedButton.dart';

import '../question_page/question_page.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';

class AllTypesEndlessRandomStarter extends StatelessWidget
{
  final Graph graph;
  StreamController<int> fromTopicSK;
  StreamController<int?> toTopicSK;
  int fromTopic=1;
  int? toTopic;
  AllTypesEndlessRandomStarter
  (
    this.graph,
    this.fromTopicSK,
    this.toTopicSK, 
    this.fromTopic,
    this.toTopic,
    {super.key}
  )
  {
    fromTopicSK.stream.listen((event) {fromTopic=event;});
    toTopicSK.stream.listen((event) {toTopic=event;});
  }

  @override
  Widget build(BuildContext context) 
  {
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
          color: 
          graph.intervalApplicable(fromTopic, toTopic)
          ? 
          const Color.fromARGB(255, 158, 180, 208) 
          : 
          const Color.fromARGB(0, 158, 180, 208),
          textStyle: TextStyle
          (
            color: 
            graph.intervalApplicable(fromTopic, toTopic)
            ?
              const Color.fromARGB(255, 0, 0, 0)
            : 
            const Color.fromARGB(255, 131, 130, 130),
          ),
          onPressed:  
          graph.intervalApplicable(fromTopic, toTopic)
          ?     
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
                    Exam_AllTypes_EndlessRandom
                    (
                      graph,true,
                      fromTopic: fromTopic,
                      toTopic: toTopic
                    )
                  )
              )
            );
          }
          :
          null
          ,
        ),
      ]
    );
  }

}