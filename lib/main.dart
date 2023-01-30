import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class ListItem {
  final String value;

  const ListItem({required this.value});

  @override
  String toString() {
    return value;
  }
}

class DropdownTextFieldController extends ValueNotifier<List<ListItem>> {
  DropdownTextFieldController() :super([]);

  final textEditingController = TextEditingController();




  addItem() {
    if(value.length > 10) {
      value = [const ListItem(value: 'vas')];
      return;
    } 
    value = [...value, ...value, ListItem(value: textEditingController.text ),];
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DropdownTextFieldController dropdownTextFieldController= DropdownTextFieldController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     dropdownTextFieldController.textEditingController.addListener(() {
      if( dropdownTextFieldController.textEditingController.text.isNotEmpty) {
 dropdownTextFieldController.addItem();
      }
      
     },);
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
        
          children: [
             Center(child: CountryFormField(
              textEditingController: dropdownTextFieldController. textEditingController,
              controller: dropdownTextFieldController,
              height: 400,
        
            ),),


            DropdownButton(items: const [
              DropdownMenuItem(value: 1,child: Text('sdf'),),
              DropdownMenuItem(value: 2,child: Text('sdf'),),
            ], onChanged: (value) {},),

          Container(height: 1000,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



class CountryFormField<Item> extends StatefulWidget {
   final TextEditingController textEditingController;
  final  double? height;
  final ValueListenable<List<Item>>  controller;
  final Widget Function(BuildContext context, Item? item)? itemBuilder;

  const CountryFormField({Key? key,   required this.controller, required this.textEditingController, this.height, this.itemBuilder, }) : super(key: key);

  @override
  _CountryFormFieldState<Item> createState() => _CountryFormFieldState<Item>();
}

class _CountryFormFieldState<Item> extends State<CountryFormField<Item>>
    with TickerProviderStateMixin {
    
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();



  @override
  void initState() {

    super.initState();
    
    _focusNode.addListener(() {
   final OverlayState overlayState = Overlay.of(context);
      if (_focusNode.hasFocus) {
              _overlayEntry = _createOverlay();
        overlayState.insert(_overlayEntry!);
      } else {
       _overlayEntry!.remove();
      }
    },);


  }


  OverlayEntry _createOverlay() {
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    var size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: GestureDetector(
            onTap: () {
              if(_focusNode.hasFocus) {
                _focusNode.unfocus();

              }
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height:  MediaQuery.of(context).size.height,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder<List<Item>>(
                    valueListenable: widget.controller,
                    builder: (context, value, child) {
                      return SizedBox(
                        height: widget.height,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: value.length,
                          itemBuilder: (context, index) {

                            

                            final item = value[index]; 

                            if( widget.itemBuilder == null) {
                               return Material(child: ListTile(title: Text(item.toString(),) , onTap: () {
                            widget.textEditingController.text = item.toString();
                                      _focusNode.unfocus();
                                
                            },),);
                            } else {
                              return widget.itemBuilder?.call(context, item);
                            }
                                        
                           
                          },
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
        ),);
  }

  @override
  Widget build(BuildContext context) {

    return   CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            focusNode: _focusNode,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            controller: widget.textEditingController,
          ),
        );
  }
}

class TextFieldDropdownItem<Item> {
  final Widget child;
  final Item item;

  const TextFieldDropdownItem({required this.child, required this.item,});
}