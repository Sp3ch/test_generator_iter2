import 'package:flutter/material.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';
import '../different exam types/alltypes_endlessrandom.dart';
import '../different exam types/alltypes_specifiedamount.dart';

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
            child: SizedBox(width:400, child: SetExamWidget(graph))
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
  String typeOfExamSelected="";
  @override
  Widget build (BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
        const SizedBox(height:30),
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
            child: AllTypesSpecifiedAmountExamStarter(widget.graph),
          )
        )
        // AllTypesSpecifiedAmountExamStarter()
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
            child: AllTypesEndlessRandomStarter(widget.graph)
          )
        )
        :
        const SizedBox()
        // the placed widget
      ],
    );    
  }      
}
