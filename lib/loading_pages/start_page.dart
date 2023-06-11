import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_generator_iter2/loading_pages/setexam_page.dart';
import 'package:kb_lib_iter2/kb_lib_iter2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:test_generator_iter2/roundedButton.dart';

// могут быть варианты использования:
// - файл не выбран
// - файл выбирается
//   - файл выбран, но не .knowledge
//   - файл выбран, ,knowledge, но граф не читается
//   - файл выбраг, граф читается
// - файл выбран, граф читается, выбирается новый файл

// когда хотя бы какой-то файл считан, то есть есть какой-то граф:
// - показать варианты экзаменов
//   - в бесконечном экзамене - просто факт выбора самого экзамена
//   - в конечном: для типов - текст типа и окно ввода с предустановленным 
//   количеством

// файл можно выбрать:
// - кнопкой "выбрать файл", если поле для ввода пустое
// - кнопкой выбраьт файл попытаться загрузить файл, если поле не пустое, по пути, 
// который указан



class LoadPageMain extends StatelessWidget
{
  const LoadPageMain({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return 
    Scaffold
    (
      appBar: AppBar(toolbarHeight: 0,),
      body: Center
      (
        child: SingleChildScrollView
        (
          child: SizedBox
          (
            width:400,
            child: Stack
            (
              children: <Widget>
              [
                Align
                (
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.18, 
                    child: Image.asset('assets/logo.png'),
                  )
                ),
                const Align
                (
                  alignment: Alignment.center,
                  child: Padding
                  (
                    padding: EdgeInsets.all(16.0),
                    // child: LoadPage()
                    child: LoadPageN()
                  )
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}


class LoadPageN extends StatefulWidget
{
  const LoadPageN({super.key});

  @override
  State<StatefulWidget> createState() 
  {
    return LoadPageNState();
  }

}

class LoadPageNState extends State<LoadPageN>
{
  // fields that define the state
  bool itsQuiet = true; // для первого открытия приложения и когда ошибка исправляется
  bool fileFound = false; // не выброшена ошибка доступа к файлу
  bool fileRead = false; // не выброшена ошибка из kb_lib, или при любом 
  // раскладе загрузки файл уже загружен, и пользователь пытается выбрать новый
  Graph? graph;
  List<String> errorMessages=<String>[];

  //all other fields
  final TextEditingController filenameTextEditingController = TextEditingController();

  void readFileByPath(String path)
  {
    File(path).readAsString().then
    (
      (value) 
      {
        setState(() {fileFound=true;});
        try
        {
          graph = Graph.fromSaveFile_knowledgeOnly(value);
          setState
          (
            () 
            {
              errorMessages=<String>[];
              fileRead=true; 
              itsQuiet=true; 
            }
          );
        }
        catch (e)
        {
          // Graph failed to form
          errorMessages.add("Чтение знаний из файла не удалось.\nФайл знаний содержит ошибку.");
          if (e is FormatException && e.offset!=null)
          {
            if (e.offset!<10)
            {
              if (e.source.length<10)
              {
                errorMessages.last+="\nМесто ошибки:\n";
                errorMessages.last+="${e.source}";
                errorMessages.last+="\nпозиция:\n";
                for (int iii=0;iii<e.offset!;iii++)
                {
                  errorMessages.last+="_";  
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1;iii<e.source.length;iii++)
                {
                  errorMessages.last+="_";
                }
              }
              else if (e.source.length<20)
              {
                errorMessages.last+="\nМесто ошибки:\n";
                errorMessages.last+="${e.source}";
                errorMessages.last+="\nпозиция:\n";
                for (int iii=0;iii<e.offset!;iii++)
                {
                  errorMessages.last+="_";  
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1;iii<e.source.length;iii++)
                {
                  errorMessages.last+="_";
                }
              }
              else
              {
                errorMessages.last+="\nМесто ошибки:\n";
                errorMessages.last+="${e.source.substring(0,20)}";
                errorMessages.last+="\nпозиция:\n";
                for (int iii=0;iii<e.offset!;iii++)
                {
                  errorMessages.last+="_";
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1;iii<20;iii++)
                {
                  errorMessages.last+="_";
                }
              }
            }
            else if (e.offset!>e.source.length-10)
            {
              if (e.source.length<10)
              {
                errorMessages.last+="\nМесто ошибки:\n";
                errorMessages.last+="${e.source}";
                errorMessages.last+="\nПозиция:\n";
                for (int iii=0;iii<e.offset!;iii++)
                {
                  errorMessages.last+="_";  
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1;iii<e.source.length;iii++)
                {
                  errorMessages.last+="_";
                }
              }
              else if (e.source.length<20)
              {
                errorMessages.last+="\nМесто ошибки:\n";
                errorMessages.last+="${e.source}";
                errorMessages.last+="\nпозиция:\n";
                for (int iii=0;iii<e.offset!;iii++)
                {
                  errorMessages.last+="_";  
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1;iii<e.source.length;iii++)
                {
                  errorMessages.last+="_";
                }
              }
              else
              {
                errorMessages.last+="\nМесто ошибки:\n";
                int c = e.source.length-20;
                errorMessages.last+="${e.source.substring(c,e.source.length)}";
                errorMessages.last+="\nпозиция:\n";
                for (int iii=0;iii<e.offset!-c;iii++)
                {
                  errorMessages.last+="_";
                }
                errorMessages.last+="#";
                for (int iii=e.offset!+1-c;iii<20;iii++)
                {
                  errorMessages.last+="_";
                }
              }
            }
            else
            {
              errorMessages.last+="\nМесто ошибки:\n";
              errorMessages.last+="${e.source.substring(e.offset!-10,e.offset!+11)}";
              errorMessages.last+="/nпозиция:";
              errorMessages.last+="__________#__________";
            }
          }
          else if (e is TypeError)
          {
            errorMessages.last+="\n$e";
          }
          else
          {
            if (e is FormatException)
            {
              errorMessages.last+="\n${e.message}";
            }
            else
            {
              errorMessages.last+="\n$e";
            }
          }
          setState
          (
            ()
            {
              fileRead=false;
              itsQuiet=false;
            }
          );
          }
      }
    )
    .catchError 
    (
      (e) 
      {
        if (e is PathNotFoundException) 
        {
          errorMessages.add("Файл по указанному пути не был найден.\nВозможно, Вы указали путь не к локальной памяти устройства или к съёмному диску, который был извлечён.\nВ настоящее время программа не поддерживает загрузку из облачных хранилищ.");
          setState
          (
            ()
            {
              fileRead=false;
              itsQuiet=false;
            }
          );
        }
        else if (e is FormatException) 
        {
          errorMessages.add("Ошибка формата: /n${e.message}");
          setState
          (
            ()
            {
              fileRead=false;
              itsQuiet=false;
            }
          );
        }
        else if (e is FileSystemException)
        {
          errorMessages.add("Не удалось прочитать содержимое файла как текстовый файл UTF-8 \nОтветом системы было: ${e.osError}");
          setState
          (
            ()
            {
              fileRead=false;
              itsQuiet=false;
            }
          );
        }
        else
        {
          errorMessages.add("Иное: /n$e");
          setState
          (
            ()
            {
              fileRead=false;
              itsQuiet=false;
            }
          );
        }
      }
    );
  }

  void findAndReadFile()
  {
    FilePicker.platform.pickFiles
    (
      type:FileType.any,
      withData: true,
      allowMultiple: false
    ).then
    ( 
      (retval)
      {
        if (retval!=null)
        {
          if (retval.files.isNotEmpty)
          {
            PlatformFile fPFile = retval.files[0];
            if (fPFile.path!=null) { readFileByPath(fPFile.path!);}
            else 
            {
              setState
              (
                ()
                {
                  fileFound=false;
                  itsQuiet=false;
                  errorMessages.add("Система устройства заблокировала выбор файла.");
                }
              );
            }
          }
          else
          {
            setState
            (
              ()
              {
                fileFound=false;
                itsQuiet=false;
                errorMessages.add("Выбрано 0 файлов, или система устройства заблокировала выбор файла.");
              }
            );
          }
        }
        else 
        {
          setState
          (
            () 
            {
              fileFound=false;
              itsQuiet=false;
              errorMessages.add("Файл не был выбран.");
            }
          );
        }
      }
    );
  }

  void initializeOpeningTheFile(path)
  {
    if (path.trim()=="") {findAndReadFile();}
    else 
    {
      if (path.trim().endsWith(".knowledge"))
      {
        readFileByPath(path.trim());  
      }
      else 
      {
        readFileByPath("${path.trim()}.knowledge");
      }
    }
  }


  @override
  Widget build(BuildContext context) 
  {
    return 
    Center
    (
      child: SizedBox
      (
        width:400,
        child: Padding
        (
          padding: const EdgeInsets.all(16.0),
          child: Column
          (
            mainAxisSize: MainAxisSize.min,
            children:<Widget>
            [
              const Text
              (
                "Выберите исправный .knowledge файл из хранилища Вашей системы.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(16,0,16,0),
                child: Center
                (
                  child: TextField
                  (
                    controller: filenameTextEditingController,
                    decoration: InputDecoration
                    (
                      suffixText: filenameTextEditingController.text.trim().endsWith(".knowledge") 
                      ?
                      ""
                      :
                      ".knowledge",
                      hintMaxLines: 1,
                      hintText: "путь к файлу",
                      enabledBorder: const OutlineInputBorder(borderSide:BorderSide()),
                    ),
                    onChanged: (value){setState((){});},
                  )
                ),
              ),
              const SizedBox(height: 15),
              WidgetRoundedTextButton
              (
                text: 
                  graph==null ? 
                  "Найти файл по пути выше"
                  : "Найти новый файл по пути выше", 
                color:
                  graph==null ? 
                  const Color.fromARGB(131, 158, 180, 208):
                  const Color.fromARGB(0, 255, 255, 255) ,
                paddingEdgeInsets: const EdgeInsets.all(8.0),
                roundnessRadius: 10,
                textStyle: const TextStyle(fontSize: 16,color: Colors.black),
                onPressed: 
                  ()
                  {
                    setState((){fileRead=false;});
                    if (Platform.isAndroid || Platform.isIOS)
                    {
                      FilePicker.platform.clearTemporaryFiles()
                      .then
                      (
                        (val) 
                        {
                          initializeOpeningTheFile
                          (filenameTextEditingController.text.trim());
                        }
                      );
                    }
                    else 
                    {
                      initializeOpeningTheFile
                      (
                        filenameTextEditingController.text.trim()
                      );
                    }
                  }
              ),
              const SizedBox(height: 15),
              WidgetRoundedTextButton
              (
                text: 
                  graph==null ? 
                  "Выбрать файл"
                  : "Выбрать новый файл", 
                color: 
                  graph==null ? 
                  const Color.fromARGB(131, 158, 180, 208):
                  const Color.fromARGB(0, 255, 255, 255) ,
                paddingEdgeInsets: const EdgeInsets.all(8.0),
                roundnessRadius: 10,
                textStyle: const TextStyle(fontSize: 16,color: Colors.black),
                onPressed:
                  ()
                  {
                    setState((){fileRead=false;fileFound=false;});
                    if (Platform.isAndroid || Platform.isIOS)
                    {
                      FilePicker.platform.clearTemporaryFiles()
                        .then((val) {findAndReadFile();});  
                    }
                    else {findAndReadFile();}
                  }
              ),
              const SizedBox(height:10),
              Padding
              (
                padding: const EdgeInsets.fromLTRB(10,0,10,0),
                child: 
                itsQuiet && errorMessages.isEmpty
                ?
                const SizedBox()
                :
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
                  child:Padding
                  (
                    padding: const EdgeInsets.fromLTRB(8,2,8,2),
                    child: Text
                    (
                      errorMessages.isEmpty ? "Ошибка!" : errorMessages.last,
                      style: const TextStyle
                      (
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: "Courier New"
                      ),
                      textAlign: 
                      errorMessages.isNotEmpty 
                      && errorMessages.last.startsWith("Чтение знаний из файла не удалось") 
                      ? TextAlign.left 
                      : TextAlign.justify,
                    ),
                  )
                )
              ),
              itsQuiet==true && graph==null ? 
              const SizedBox()
              :
              Column
              (
                children:
                <Widget>
                [
                  const SizedBox(height:5),
                  SizedBox
                  (
                    child:Text
                    (
                      fileFound ? 
                      "Файл найден." : 
                      graph!=null ? 
                      "Ожидается новый файл\n(уже загруженный файл доступен)":
                      "Файл не найден",
                      textAlign: TextAlign.center,
                    )
                  ),
                  SizedBox
                  (
                    child:Text
                    (
                      !fileFound ? 
                      "Ожидается файл для считывания знаний":
                      fileRead ? 
                      "Знания считаны." :
                      "Знания не были считаны.",
                      textAlign: TextAlign.center,
                    )
                  ),
                ]
              ),
              graph==null ?
              const SizedBox()
              :
              Column
              (
                children: 
                <Widget>
                [
                  const SizedBox(height:15),
                  WidgetRoundedTextButton
                  (
                    text: "Перейти к настрйоке \nпроверочной работы", 
                    color: const Color.fromARGB(255, 158, 180, 208),
                    onPressed: ()
                    {
                      Navigator.of(context).push
                      (
                        MaterialPageRoute(builder: (context)=>SetExamPage(graph!))
                      );
                    }
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }
  
}









