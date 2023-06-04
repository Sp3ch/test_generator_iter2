
import 'package:flutter/material.dart';
import "package:kb_lib_iter2/kb_lib_iter2.dart";
import "package:test_generator_iter2/roundedButton.dart";
import "../results_pages/results_page.dart";



class QuestionPageMain extends StatelessWidget
{
  final Exam exam;

  QuestionPageMain(this.exam, {super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold
    (
      appBar: AppBar(toolbarHeight: 0,),
      body:QuestionPageN(exam)
    );
  }
}

class QuestionPageN extends StatefulWidget
{

  final Exam exam;

  QuestionPageN(this.exam, {super.key});

  @override
  State<StatefulWidget> createState() 
  {
    return QuestionPageNState();
  }

}

class QuestionPageNState extends State<QuestionPageN>
{
  bool tryingToLeave=false;
  Task? task;

  Color percentageColor(double percentage)
    =>Color.fromARGB
      (
        255, 
        (failColor.red*(1-percentage)+successColor.red*(percentage)).round(), 
        (failColor.green*(1-percentage)+successColor.green*(percentage)).round(), 
        (failColor.blue*(1-percentage)+successColor.blue*(percentage)).round()
      );
  bool answering = true;
  double percentage = 0;
  Color successColor=const Color.fromARGB(255, 76, 175, 79);
  Color failColor=const Color.fromARGB(255, 193, 200, 54);
  Map<Type,List> answer = <Type,List<String>>{};
  TextEditingController onerandomTEC = TextEditingController();
  Widget oneRandomAnswerForm = const Text("<Это не должно здесь отображаться>");  
  Widget oneRandomAnswerShowcase= const Text("<Это не должно здесь отображаться>");
  Widget allAnswerForm = const Text("<Это не должно здесь отображаться>");
  Widget allAnswerShowcase= const Text("<Это не должно здесь отображаться>"); 
  List<Widget> allAnswerFormColumn=<Widget>[];
  List<TextEditingController> allAnswerFormTECs=<TextEditingController>[];
  late Color appbarColor; 

  QuestionPageNState()
  {
    appbarColor = percentageColor(0);
  }

  @override
  Widget build(BuildContext context) 
  {
    task ??= widget.exam.nextTask;
    const double fontSizeForAnswer=16;
    onerandomTEC.text="";
    for (TextEditingController tec in allAnswerFormTECs)
    {
      tec.text="";
    }
    if (task.runtimeType==Question_WhatIsDefinedHereOneRandom_TypeIn)
    {
      allAnswerForm=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
      allAnswerShowcase=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
      if (answering)
      {
        oneRandomAnswerShowcase=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
        oneRandomAnswerForm = 
        Container
        ( 
          color: Colors.white,
          height: 40,
          width: 400,
          child: TextField
          (
            controller: onerandomTEC,
            decoration: const InputDecoration
            (
              enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
              labelText: 'Ответ',
            ),
          )
        );
      }
      else
      {
        oneRandomAnswerForm 
          = const SizedBox(child:Text("<Это не должно здесь отображаться>"));
        String givenAnswer = (task! as Question_WhatIsDefinedHereOneRandom_TypeIn)
          .lastGivenAnswer;
        String rightAnswer = (task! as Question_WhatIsDefinedHereOneRandom_TypeIn)
          .rightAnswer;
        List<String> possibleAnswers 
          = (task! as Question_WhatIsDefinedHereOneRandom_TypeIn).possibleAnswers;
        oneRandomAnswerShowcase=Container(
          child: Column
          (
            children:<Widget>
            [
              
              const SizedBox
              (
                child:Text
                (
                  "Ваш ответ:",
                  style:TextStyle(fontSize: fontSizeForAnswer)
                )
              ),
              // const SizedBox(height:3),
              SizedBox
              (
                child:
                givenAnswer=="" ? 
                const Text
                (
                  "нет ответа",
                  style: TextStyle
                  (
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.lineThrough
                  ),
                ) 
                :
                Text(givenAnswer)
              ),
              const SizedBox(height:7),
              Container
              (
                decoration: BoxDecoration
                (
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  color:percentageColor(task!.confdence),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column
                  (
                    children:<Widget>
                    [
                      const Text("Ответ дан"),
                      task!.confdence==0 ?
                        const Text("неверно") :
                      task!.confdence>=1 ?
                        const Text("ВЕРНО!") :
                        const Text("частично верно")
                    ]
                  ),
                )
              ),
              const SizedBox(height: 7),
              const SizedBox
              (
                child:Text
                (
                  "Правильный ответ:",
                  style:TextStyle(fontSize: fontSizeForAnswer)
                )
              ),
              SizedBox(child:Text(rightAnswer)),
              const SizedBox(height:7),
              const SizedBox
              (
                child:Text
                (
                  "Возможные ответы:",
                  style:TextStyle(fontSize: fontSizeForAnswer)
                )
              ),
              SizedBox(child:Text(possibleAnswers.join(", "))),
            ]
          ),
        );
      }
    }
    else if (task.runtimeType==Question_WhatIsDefinedHereAll_TypeIn)
    {
      oneRandomAnswerForm=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
      oneRandomAnswerShowcase=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
      allAnswerFormColumn=<Widget>
      [
        const SizedBox(child: Text("Термины:", style: TextStyle(fontSize: 18),)),
        const SizedBox(height:7),
      ];
      allAnswerFormTECs=<TextEditingController>[];
      if (answering)
      {
        allAnswerShowcase=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
        for (int i=0;i<(task as Question_WhatIsDefinedHereAll_TypeIn).amountOfTerms;i++)
        {
          allAnswerFormTECs.add(TextEditingController());
          allAnswerFormColumn.add
          (
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>
              [
                SizedBox
                (
                  width:30,
                  child:Text
                  (
                    "(${i+1})",
                    style:const TextStyle(fontSize: 16)
                  )
                ),
                const SizedBox(width:10),
                Container
                ( 
                  color: Colors.white,
                  height: 40,
                  width: 300,
                  child: TextField
                  (
                    controller: allAnswerFormTECs.last,
                    decoration:  InputDecoration
                    (
                      enabledBorder: 
                        const OutlineInputBorder(borderSide: BorderSide()),
                      hintText: 'Термин (${i+1})',
                    ),
                  )
                )
              ]
            )
          );
          allAnswerFormColumn.add(const SizedBox(height:5));
        }
        allAnswerForm=Column(children:allAnswerFormColumn);
      }
      else
      {
        allAnswerForm=const SizedBox(child:Text("<Это не должно здесь отображаться>"));
        List<String> givenAnswer = (task! as Question_WhatIsDefinedHereAll_TypeIn)
          .lastGivenAnswer;
        List<String> rightAnswer = (task! as Question_WhatIsDefinedHereAll_TypeIn)
          .rightAnswer;
        List<List<String>> possibleAnswers 
          = (task! as Question_WhatIsDefinedHereAll_TypeIn).possibleAnswers;
        List<Widget> allAnswerShocaseColumn = <Widget>[];
        allAnswerShocaseColumn.add
        (
          Container
          (
            decoration: BoxDecoration
            (
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color:percentageColor(task!.confdence),
            ),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column
              (
                children:<Widget>
                [
                  const Text("Ответ дан"),
                  task!.confdence==0 ?
                    const Text("неверно") :
                  task!.confdence>=1 ?
                    const Text("ВЕРНО!") :
                    const Text("частично верно")
                ]
              ),
            )
          )
        );
        for (int i=0;i<(task as Question_WhatIsDefinedHereAll_TypeIn).amountOfTerms;i++)
        {
          allAnswerShocaseColumn.add
          (
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>
                [
                  Container
                  (
                    decoration: const BoxDecoration
                    (
                      color:Color.fromARGB(255, 198, 197, 197),
                      borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    width:30, child:Center(child: Text("(${i+1})"))
                  ),
                  const SizedBox(width:10),
                  Expanded
                  (
                    child: Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>
                      [
                        const SizedBox
                        (
                          child:Text
                          (
                            "Ваш ответ:",
                            style:TextStyle(fontSize: fontSizeForAnswer)
                          )
                        ),
                        SizedBox
                        (
                          child:
                          
                          givenAnswer[i]=="" ?
                          const Text
                          (
                            "нет ответа",
                            style: TextStyle
                            (
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.lineThrough
                            ),
                          )
                          :
                          Text(givenAnswer[i])
                        ),
                        const SizedBox(height:7),
                        const SizedBox
                        (
                          child:Text
                          (
                            "Правильный ответ:",
                            style:TextStyle(fontSize: fontSizeForAnswer)
                          )
                        ),
                        SizedBox(child:Text(rightAnswer[i])),
                        const SizedBox(height:7),
                        const SizedBox
                        (
                          child:Text
                          (
                            "Возможные ответы:",
                            style:TextStyle(fontSize: fontSizeForAnswer)
                          )
                        ),
                        SizedBox(child:Text(possibleAnswers[i].join(", "))),
                      ]
                    ),
                  )
                ]
              ),
            )
          );
        }
        allAnswerShowcase=Column
        (
          children:allAnswerShocaseColumn
        );
      } 
    }
    WidgetRoundedTextButton endTB = WidgetRoundedTextButton
    (
      text: "Закончить", 
      color: const Color.fromARGB(255, 237, 68, 56),
      textStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      roundnessRadius: 7,
      paddingEdgeInsets: const EdgeInsets.all(8.0),
      borderless: true,

      onPressed: () {setState((){tryingToLeave=true;});},
    );
    WidgetRoundedTextButton nextTB = WidgetRoundedTextButton
    (
      text: 
        answering ? 
        "Проверить" :
        widget.exam.endOfExam ? 
        "Закончить" :
        "Дальше",
      textStyle: const TextStyle(color:Color.fromARGB(255, 0, 0, 0)),
      color: const Color.fromARGB(255, 158, 180, 208),
      paddingEdgeInsets: const EdgeInsets.all(8.0),
      roundnessRadius: 7,
      borderless: true,

      onPressed:
      ()
      {
        if (answering)
        {
          if (task.runtimeType==Question_WhatIsDefinedHereAll_TypeIn)
          {
            List<String> answerGiven = <String>[];
            for (int i=0;i<(task as Question_WhatIsDefinedHereAll_TypeIn).amountOfTerms;i++)
            {
              answerGiven.add(allAnswerFormTECs[i].text);
            }
            widget.exam.answer=answerGiven;
            setState(() {answering=false;});
          }
          else if (task.runtimeType==Question_WhatIsDefinedHereOneRandom_TypeIn)
          {
            widget.exam.answer=onerandomTEC.text;
            setState(() {answering=false;});
          }
          else {print("ASSERT: Не нашлось типа для вопроса :(");}
          appbarColor=percentageColor(widget.exam.percentageFinal);
        }
        else
        {
          if (widget.exam.endOfExam)
          {
            setState(() {tryingToLeave=true;});
          }
          else
          {
            task=widget.exam.nextTask;
            setState((){answering=true;});
          }
        }
      }
    );
    // return built page !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return Stack
    (
      children: <Widget>
      [
        Container
        (
          color: const Color.fromARGB(255, 229, 226, 226),
          child: Column
          (
            children:<Widget>
            [
              //appbar !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              Container(
                height:50,
                color:appbarColor,
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>
                  [
                    const SizedBox(),
                    Text
                    (
                      "Вопрос ${widget.exam.currentTaskNumber}${
                        widget.exam.tasksMax!=null 
                          ? " из ${widget.exam.tasksMax}"
                          :""}",
                      style:  const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(),
                  ]
                ),
              ),
              // the rest below appbar !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
              Expanded
              (
                child:Padding
                (
                  padding: const EdgeInsets.fromLTRB(10,5,10,5),// LTRB
                  child: Container
                  (
                    width:400,
                    color:const Color.fromARGB(255, 229, 226, 226),
                    child: SingleChildScrollView
                    (
                      child:Column
                      (
                        children: <Widget>
                        [
                          //body + instruction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          Column
                          (
                            children:<Widget>
                            [
                              const SizedBox(height:15),
                              // instruction !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                              Center
                              (
                                child: Container
                                (
                                  width: 350,
                                  decoration:const BoxDecoration
                                  (
                                    color: Color.fromARGB(255, 190, 188, 188),
                                    borderRadius: BorderRadius.all(Radius.circular(3))
                                  ),
                                  padding: const EdgeInsets.symmetric
                                    (
                                      vertical:5,
                                      horizontal:10
                                    ),
                                  child: Text
                                  (
                                    task!.instruction,
                                    textAlign: TextAlign.center,
                                    style:const TextStyle(fontSize: 16)
                                  )
                                ),
                              ),
                              const SizedBox(height:15),
                              //body !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                              Column
                              (
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: <Widget>
                                [
                                  const SizedBox(width:5,height:5),
                                  Container
                                  (
                                    decoration:const BoxDecoration
                                    (
                                      color: Color.fromARGB(255, 205, 203, 203),
                                      borderRadius: BorderRadius.all(Radius.circular(7))
                                    ),
                                    width:400,
                                    padding: const EdgeInsets.symmetric
                                    (
                                      vertical:5,
                                      horizontal:10
                                    ),
                                    child: Center
                                    (
                                      child: Text
                                      ( 
                                        task!.body,
                                        style:const TextStyle(fontSize:22.0),
                                        textAlign: TextAlign.justify
                                      )
                                    )
                                  ),
                                  const SizedBox(height:15)
                                ]
                              ),
                            ]
                          ),
                          // answer form !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          answering ?
                          (
                            task.runtimeType==Question_WhatIsDefinedHereAll_TypeIn ? 
                            allAnswerForm // TODO
                            :
                            task.runtimeType==Question_WhatIsDefinedHereOneRandom_TypeIn ?
                            oneRandomAnswerForm // TODO
                            :
                            const SizedBox(child:Text("<answering the question which type is not defined>")) // TODO
                          )
                          :
                          (
                            task.runtimeType==Question_WhatIsDefinedHereAll_TypeIn ? 
                            allAnswerShowcase // TODO
                            :
                            task.runtimeType==Question_WhatIsDefinedHereOneRandom_TypeIn ?
                            oneRandomAnswerShowcase // TODO
                            :
                            const SizedBox(child:Text("<checking the question which type is not defined>")) // TODO
                          )
                        ],
                      )
                    )
                  )
                )
              ),
              Container
              (
                height:50,
                color:Colors.white,
                child: Row
                (
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: 
                      
                  widget.exam.endOfExam  && !answering? 
                  <Widget>
                  [
                    const SizedBox(),
                    nextTB,
                    const SizedBox(),
                  ]
                  :
                  <Widget>
                  [
                    const SizedBox(),
                    endTB,
                    const SizedBox(),
                    nextTB,
                    const SizedBox(),
                  ]
                ),
              ),
            ]
          )
        ),
        tryingToLeave
        ?
        Container(
          color: const Color.fromARGB(139, 0, 0, 0),
          child: Align(
            alignment: Alignment.center,
            child: Container
            (
              decoration: const BoxDecoration
              (
                color:Color.fromARGB(255, 208, 183, 158),
                borderRadius:  BorderRadius.all(Radius.circular(10))
              ),
              child:Padding(
                padding: const EdgeInsets.all(16.0),
                child: 
                widget.exam.endOfExam && !answering ?
                Column
                (
                  mainAxisSize: MainAxisSize.min,
                  children:<Widget>
                  [
                    const SizedBox
                    (
                      child:Text
                      (
                        "Вопросы в проверочной работе закончились",
                        style:TextStyle(fontSize: 20)
                      )
                    ),
                    const SizedBox(height:30),
                    WidgetRoundedTextButton
                    (
                      text: "Посмотреть результаты...", 
                      textStyle: const TextStyle(color:Color.fromARGB(255, 0, 0, 0)),
                      color: const Color.fromARGB(255, 158, 180, 208),
                      paddingEdgeInsets: const EdgeInsets.all(8.0),
                      roundnessRadius: 7,
                      borderless: true,
                      onPressed: 
                      () 
                      {
                        Navigator.of(context).push
                        (
                          MaterialPageRoute
                          (
                            builder: 
                            (context)=>
                            ResultPage
                            (
                              earnedPoints: widget.exam.pointsCurrent, 
                              totalPoints: widget.exam.pointsMax ?? widget.exam.pointsMaxCurrent, 
                              score: widget.exam.percentageFinal,
                              questionsRight: widget.exam.perfectTasks, 
                              errors: widget.exam.errors,
                              totalQuestions: widget.exam.tasksMax ?? widget.exam.currentTaskNumber,
                            )
                          )
                        );
                      }
                    ),
              
                  ]
                )
                :
                Column
                (
                  mainAxisSize: MainAxisSize.min,
                  children:<Widget>
                  [
                    const SizedBox
                    (
                      child:Text
                      (
                        "Хотите закончить тестирование?",
                        style:TextStyle(fontSize: 20)
                      )
                    ),
                    const SizedBox(height:30),
                    WidgetRoundedTextButton
                    (
                      text: "Да, хочу закончить", 
                      textStyle: const TextStyle(color:Color.fromARGB(255, 0, 0, 0)),
                      color: const Color.fromARGB(255, 237, 68, 56),
                      paddingEdgeInsets: const EdgeInsets.all(8.0),
                      roundnessRadius: 7,
                      borderless: true,
                      onPressed: 
                      () 
                      {
                        Navigator.of(context).push
                        (
                          MaterialPageRoute
                          (
                            builder: 
                            (context)=>
                            ResultPage
                            (
                              earnedPoints: widget.exam.pointsCurrent, 
                              totalPoints: widget.exam.pointsMax ?? widget.exam.pointsMaxCurrent,
                              score: widget.exam.percentageFinal,
                              questionsRight: widget.exam.perfectTasks,
                              errors: widget.exam.errors,
                              totalQuestions: widget.exam.tasksMax ?? widget.exam.currentTaskNumber,
                            )
                          )
                        );
                      }
                    ),
                    const SizedBox(height:12),
                    WidgetRoundedTextButton
                    (
                      text: "Нет, хочу остаться", 
                      textStyle: const TextStyle(color:Color.fromARGB(255, 0, 0, 0)),
                      color: const Color.fromARGB(255, 158, 180, 208),
                      paddingEdgeInsets: const EdgeInsets.all(8.0),
                      roundnessRadius: 7,
                      borderless: true,
                      onPressed: () {setState((){tryingToLeave=false;});}
                    ),
              
                  ]
                ),
              )  
            ),
          ),
        )
        :
        const SizedBox()
      ],
    );
  }
}
