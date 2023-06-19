import 'package:flutter/material.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  String result = 'extracted entities...';

  late EntityExtractorModelManager modelManager;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelManager = EntityExtractorModelManager();
    checkAndDownloadModel();
  }

  bool isModelDownloaded = false;
  dynamic entityExtractor;
  checkAndDownloadModel() async {
    print("check model start");

    //TODO if models are loaded then create extractor
    bool isDownloaded = await modelManager
        .isModelDownloaded(EntityExtractorLanguage.english.name);

    //TODO download models if not downloaded
    if (isDownloaded == false) {
      bool isDownloaded = await modelManager
          .downloadModel(EntityExtractorLanguage.english.name);
    }

    //TODO if models are loaded then create extractor
    if (isDownloaded) {
      entityExtractor =
          EntityExtractor(language: EntityExtractorLanguage.english);
    }

    print("check model end");
  }

  //TODO extract entity
  extractEntity(String text) async {
    final List<EntityAnnotation> annotations =
        await entityExtractor.annotateText(text);
    result = "";
    for (final annotation in annotations) {
      debugPrint(annotation.toString());
      annotation.start;
      annotation.end;
      result += "Entity Text: ${annotation.text}\n";
      for (final entity in annotation.entities) {
        result += "Entity Type: ${entity.type.name}\n";
        entity.rawValue;
      }
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: 50,
                  child: const Text(
                    'Entity Extraction',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 2, right: 2),
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Type text here...',
                            filled: true,
                            border: InputBorder.none),
                        style: const TextStyle(color: Colors.black),
                        maxLines: 100,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 13, right: 13),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white),
                        backgroundColor: Colors.orange),
                    child: const Text('Extract Entity'),
                    onPressed: () {
                      extractEntity(textEditingController.text);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    color: Colors.white,
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          result,
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
