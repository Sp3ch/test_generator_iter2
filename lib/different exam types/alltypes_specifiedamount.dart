import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';
import 'package:test_generator_iter2/roundedButton.dart';
import '../question_page/question_page.dart';

class AllTypesSpecifiedAmountExamStarter extends StatefulWidget
{
  Map<Type,int> types = <Type,int>{};
  Map<Type, String> typeNames = <Type,String>{};
  final Graph graph;
  List<Widget> column = <Widget>[];
  final StreamController<String> amountsChangedSignal = StreamController<String>.broadcast();
  // AllTypesSpecifiedAmountExamStarterState state = AllTypesSpecifiedAmountExamStarterState();
  StreamController<int> fromTopicSK;
  StreamController<int?> toTopicSK;
  int fromTopic = 1;
  int? toTopic;

  // AllTypesSpecifiedAmountExamStarter ()
  AllTypesSpecifiedAmountExamStarter 
  (
    this.graph,
    this.fromTopicSK,
    this.toTopicSK,
    this.fromTopic,
    this.toTopic,
    {super.key}
  )
  {
    // Types to be chosen from
    types[Question_WhatIsDefinedHereAll_TypeIn]=0;
    types[Question_WhatIsDefinedHereOneRandom_TypeIn]=0;

    //
    typeNames[Question_WhatIsDefinedHereAll_TypeIn]
      = "Впсиать все определяемые термины";
    typeNames[Question_WhatIsDefinedHereOneRandom_TypeIn]
      = "Вписать случайно выбранный программой определяемый термин";
    for (Type type in types.keys)
    {
      column.add
      (
        TasksAmountInputer
        (
          type,
          typeNames[type]!,
          amountsChangedSignal,
          key:Key(type.toString())
        )
      );
      column.add(const SizedBox(height:5));
    }
    // amountsChangedSignal.stream.listen((event) {state.setState(() {updateTypes();});});
  }

  void updateTypes()
  {
    for (int i=0;i<column.length/2;i++)
    {
      Type identifier = (column[i*2] as TasksAmountInputer).identifier;
      for (Type key in types.keys)
      {
        if (key==identifier)
        {
          types[key] = (column[i*2] as TasksAmountInputer).number;
        }
      }
    }
  }

  @override
  State<StatefulWidget> createState() 
  // {return state;}
  {return AllTypesSpecifiedAmountExamStarterState();}
}

class AllTypesSpecifiedAmountExamStarterState 
extends State<AllTypesSpecifiedAmountExamStarter>
{
  late Exam_AllTypes_SpecifiedAmounts exam;
  List<Widget> column = <Widget>[];
  late StreamSubscription<String> amountsChangedSignalSS;
  late StreamSubscription<int> fromTopicSS;
  late StreamSubscription<int?> toTopicSS;

  AllTypesSpecifiedAmountExamStarterState();

  bool get canContinue 
  {
    for (int i=0;i<widget.column.length/2;i++)
    {
      if ((widget.column[i*2] as TasksAmountInputer).number!=0) {return true;}
    }
    return false;
  }
  
  @override
  void initState()
  {
    super.initState();
    fromTopicSS = widget.fromTopicSK.stream
      .listen((event) {setState(() {widget.fromTopic=event;});});
    toTopicSS = widget.toTopicSK.stream
      .listen((event) {setState(() {widget.toTopic=event;});});
    amountsChangedSignalSS 
      = widget.amountsChangedSignal.stream
        .listen((event) {setState(() {widget.updateTypes();});});
  
  }

  @override
  void dispose()
  {
    super.dispose();
    amountsChangedSignalSS.cancel();
    fromTopicSS.cancel();
    toTopicSS.cancel();
  }


  @override
    Widget build (BuildContext context)
    {
      return 
      Column 
      (
        children:
          // column 
          <Widget>
          [
            const Text
            (
              "Генерируется указанное для каждого типа количество заданий.\nРаботу можно закончить досрочно. Общая правильность работы оценивается относительно всего количества заданий. В ошибки не входят задания, которые не были сгенерированы до окончания количества заданий.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height:25),
          ]
          +
          widget.column
          +
          <Widget>
          [
            const SizedBox(height:15),
            WidgetRoundedTextButton
            (
              text: "Начать проверочную работу", 
              color: 
                canContinue && 
                widget.graph.intervalApplicable(widget.fromTopic, widget.toTopic)
                ? 
                const Color.fromARGB(255, 158, 180, 208) 
                : 
                const Color.fromARGB(0, 158, 180, 208),
              textStyle: TextStyle
              (
                color: 
                  canContinue && 
                  widget.graph.intervalApplicable(widget.fromTopic, widget.toTopic)
                  ?
                   const Color.fromARGB(255, 0, 0, 0)
                  : 
                  const Color.fromARGB(255, 131, 130, 130),
              ),
              onPressed: 
              canContinue && 
              widget.graph.intervalApplicable(widget.fromTopic, widget.toTopic)
              ? 
              ()
              {
                // for (Widget numberInput in widget.column)
                for (int i=0;i<widget.column.length/2;i++)
                {
                  Type identifier 
                    = (widget.column[i*2] as TasksAmountInputer).identifier;
                  for (Type key in widget.types.keys)
                  {
                    if (key==identifier)
                    {
                      widget.types[key] 
                        = (widget.column[i*2] as TasksAmountInputer).number;
                    }
                  }
                }
                exam = Exam_AllTypes_SpecifiedAmounts
                (
                  widget.graph,
                  true,
                  question_WhatIsDefinedHereAll_TypeIn: 
                    widget.types[Question_WhatIsDefinedHereAll_TypeIn],
                  question_WhatIsDefinedHereOneRandom_TypeIn: 
                    widget.types[Question_WhatIsDefinedHereOneRandom_TypeIn],
                  fromTopic: widget.fromTopic,
                  toTopic: widget.toTopic
                );
                Navigator.of(context).push
                (
                  MaterialPageRoute(builder: (context)=>QuestionPageMain(exam))
                );
              }
              : 
              null,
            )
          ]
      );
    }
}

class TasksAmountInputer extends StatefulWidget
{
  final Type identifier;
  final String text;
  final TextEditingController _tec = TextEditingController();
  final StreamController<String> amountChangedSignal;
  TasksAmountInputer
  (
    this.identifier, 
    this.text, 
    this.amountChangedSignal, 
    {super.key,}
  );

  int get number => _tec.text=="" ? 0 : int.parse(_tec.text);
  
  @override
  State<StatefulWidget> createState() {
    return TasksAmountInputerState();
  }
}

class TasksAmountInputerState extends State<TasksAmountInputer>
{
  @override
  Widget build (BuildContext context)
  {

    return Row
    (
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children:<Widget>
      [
        SizedBox
        (
          width:70,
          height:30,
          child: TextField
          (
            onChanged: (value){widget.amountChangedSignal.add(value);},
            controller:widget._tec,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>
              [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.center,
            decoration:const InputDecoration
            (
              hintText: "0",
              hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
              focusedBorder: OutlineInputBorder() ,
              enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
            ),
          ),
        ),
        const SizedBox(width:20),
        Expanded(child:Text(widget.text)),
      ]
    );
  }
}