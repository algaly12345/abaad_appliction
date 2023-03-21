import 'package:flutter/material.dart';
class ListViewSelectRemove extends StatefulWidget {
  @override
  _ListViewSelectRemoveState createState() => _ListViewSelectRemoveState();
}

class _ListViewSelectRemoveState extends State<ListViewSelectRemove> {
  final List<String> _interfaceist = [   " الواجهة الشمالية",
    " الواجهة الشرقية",
    "الواجهة الغربية",
    "الواجهة الجنوبية",];
  final List<String> _selectedInterfaceistItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select and Remove Items'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                for (final item in _selectedInterfaceistItems) {
                  print("-----------------${item}");
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        height: 50,


        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _interfaceist.length,
          itemBuilder: (context, index) {
            final item = _interfaceist[index];

            return  Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextButton(
                  style:  ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(  _selectedInterfaceistItems.contains(item) ? Theme.of(context).primaryColor : null),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                   RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  
                  side: BorderSide(color:Theme.of(context).primaryColor)
              ),),),
                  onPressed: (){
    setState(() {
            if (_selectedInterfaceistItems.contains(item)) {
              _selectedInterfaceistItems.remove(item);
            } else {
              _selectedInterfaceistItems.add(item);
            }
          });
                  },
                  child: Text(item,style: TextStyle(color: _selectedInterfaceistItems.contains(item) ? Theme.of(context).cardColor : null,fontSize: 17.0),)
              ),
            );

            // return Container(
            //   width: 100,
            //   height: 60,
            //
            //   padding: EdgeInsets.only(right: 10,left: 10),
            //   decoration: BoxDecoration(
            //     color:Theme.of(context).cardColor,
            //     borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            //
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(.02),
            //         blurRadius: 10.0,
            //         spreadRadius: 10.0,
            //       )
            //     ],
            //   ),
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         if (_selectedItems.contains(item)) {
            //           _selectedItems.remove(item);
            //         } else {
            //           _selectedItems.add(item);
            //         }
            //       });
            //     },
            //     child: Container(
            // decoration: BoxDecoration(
            //   color:  _selectedItems.contains(item) ? Theme.of(context).primaryColor : null,
            // borderRadius: const BorderRadius.all(Radius.circular(5.0)),),
            //
            //       child: Center(
            //         child: ListTile(
            //           title: Center(child: Text(item,style: TextStyle(color: _selectedItems.contains(item) ? Theme.of(context).cardColor : null),)),
            //         ),
            //       ),
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
