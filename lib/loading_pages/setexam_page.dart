import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';
import '../different exam types/alltypes_endlessrandom.dart';
import '../different exam types/alltypes_specifiedamount.dart';
import 'package:flutter/services.dart';

class SetExamPage extends StatelessWidget
{
  late final Graph graph;
  SetExamPage
  (
    this.graph,
    {super.key}
  );
  @override
  Widget build(BuildContext context) 
  {
    return 
    Scaffold
    (
      appBar: AppBar(toolbarHeight: 0,),
      body: Center
      (
        child: Stack
        (
        children: <Widget>
        [
          Align
          (
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.18, 
              child: Image.asset
              (
                'assets/logo.png',
              ),
            )
          ),
          Align
          (
            alignment:Alignment.center,
            child: SizedBox
            (
              width:400, 
              child: SingleChildScrollView
              (
                child: Padding
                (
                  padding: const EdgeInsets.fromLTRB(0,10,0,10),
                  child: SetExamWidget(graph),
                )
              )
            )
          ),
        ],
      ))
      // body: Center(child: SizedBox(width:400, child: SetExamWidget()))
    );
  }
}

class SetExamWidget extends StatefulWidget
{
  late final Graph graph;
  SetExamWidget
  (
    this.graph,
    {super.key}
  );

  @override
  State<StatefulWidget> createState()  {return SetExamWidgetState();}

}

class SetExamWidgetState extends State<SetExamWidget>
{
  AllTypesSpecifiedAmountExamStarter? allTypesSpecifiedAmountExamStarter;
  TextEditingController toTopicTEC = TextEditingController();
  TextEditingController fromTopicTEC = TextEditingController();
  StreamController<int> fromTopicSK = StreamController<int>.broadcast();
  StreamController<int?> toTopicSK = StreamController<int?>.broadcast();
  int fromTopic = 1;
  int? toTopic;
  String typeOfExamSelected="";

  
  @override
  void initState()
  {
    super.initState();
    fromTopicSK.stream.listen((event) {setState(() {fromTopic=event;});});
    toTopicSK.stream.listen((event) {setState(() {toTopic=event;});});
  }

  @override
  Widget build (BuildContext context)
  {
    if (typeOfExamSelected=="allTasksSpecifiedAmount")
    {
      allTypesSpecifiedAmountExamStarter 
      ??= AllTypesSpecifiedAmountExamStarter
        (widget.graph, fromTopicSK, toTopicSK, fromTopic, toTopic);
    }
    return Column
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>
      [
        const Text
        (
          "Выберите тип проверочной работы",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 12),
        Column
        (
          children:<Widget>
          [
            RadioListTile<String>
            (
              value: "allTasksSpecifiedAmount", 
              groupValue: typeOfExamSelected, 
              title: const Text("Заданное количество"),
              subtitle: const Text("(всех типов заданий)"),
              onChanged: (value)
              {
                setState(() {typeOfExamSelected=value ?? "";});
              }
            ),
            RadioListTile<String>
            (
              value: "allTasksEndless", 
              groupValue: typeOfExamSelected, 
              title: const Text("Бесконечная проверочная работа"),
              subtitle: const Text("(все типы заданий, закончите когда захотите)"),
              onChanged: (value)
              {
                setState(() {typeOfExamSelected=value ?? "";});
              }
            ),
          ]
        ),
        const SizedBox(height:5),
        const Divider(color: Colors.black,),
        const Text
        (
          "Название предмета:",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Text(widget.graph.name ?? "[без имени]"),
        const Divider(color: Colors.black,),
        const SizedBox(height:5),
        const Text
        (
          "Выберите темы, по которым нужно сгенерировать задания.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height:15),
        Row
        (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children:<Widget>
          [
            const Text("Начиная с темы "),
            const SizedBox(width:10),
            SizedBox
            (
              width:70,
              height:30,
              child: TextField
              (
                onChanged: (value) 
                {
                  if (value=="") {fromTopicSK.add(1);}
                  else {fromTopicSK.add(int.parse(value));}
                },
                controller:fromTopicTEC,
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
                  hintText: "1",
                  hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
            ),
            // const SizedBox(width: 20)
          ]
        ),
        const SizedBox(height: 10),
        Row
        (
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children:<Widget>
          [
            const Text("Заканчивая темой "),
            const SizedBox(width:10),
            SizedBox
            (
              width:70,
              height:30,
              child: TextField
              (
                onChanged: (value) 
                {
                  if (value=="") {toTopicSK.add(null);}
                  else {toTopicSK.add(int.parse(value));}
                },
                controller:toTopicTEC,
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
                  hintText: "—",
                  hintStyle: TextStyle(color: Color.fromARGB(85, 0, 0, 0)),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide()),
                ),
              ),
            ),
            // const SizedBox(width: 20)
          ]
        ),
        widget.graph.intervalApplicable(fromTopic, toTopic) 
        ? 
        const SizedBox()
        : 
        Column(
          children: <Widget>
          [
            const SizedBox(height: 10),
            Container 
            (
              decoration: BoxDecoration
              (
                color: Colors.amber,
                border:Border.all
                (
                  color: const Color.fromARGB(255, 240, 84, 17),
                  width: 3
                ),
              ),
              child: const Padding
              (
                padding: EdgeInsets.fromLTRB(8,2,8,2),
                child: Text
                (
                  "Диапазон номеров тем пуст или выходит за пределы тем в загруженном файле.",
                  style: TextStyle
                  (
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "Courier New"
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            ),
          ],
        ),
        const SizedBox(height:10),
        typeOfExamSelected=="allTasksSpecifiedAmount" ? 
        Container
        (
          width:400,
          decoration: BoxDecoration
          (
            border: Border.all
            (
               width: 1, color: const Color.fromARGB(255, 158, 180, 208) 
            )
          ),
          child: Padding
          (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: allTypesSpecifiedAmountExamStarter!,
          )
        )
        :
        typeOfExamSelected=="allTasksEndless" ?
        Container
        (
          width:400,
          decoration: BoxDecoration
          (
            border: Border.all
            (
               width: 1, color: const Color.fromARGB(255, 158, 180, 208) 
            )
          ),
          child: Padding
          (
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: AllTypesEndlessRandomStarter
            (
              widget.graph, 
              fromTopicSK, 
              toTopicSK,
              fromTopic,
              toTopic
            )
          )
        )
        :
        const SizedBox()
      ],
    );    
  }      
}
