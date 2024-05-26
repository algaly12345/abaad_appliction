import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SheetButton extends StatefulWidget {
  final String  idController;
  SheetButton({Key key,  this.idController}) : super(key: key);

  _SheetButtonState createState() => _SheetButtonState();
}

class _SheetButtonState extends State<SheetButton> {
  bool checkingFlight = false;
  bool success = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<UserController>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return
      GetBuilder<UserController>(builder: (userController) {
      return
      !checkingFlight
        ? MaterialButton(
      color: Colors.grey[800],
      onPressed: () async {
        // setState(() {
        //   if(widget.idController=="omeromer"){
        //     checkingFlight = true;
        //   }else{
        //     checkingFlight = true;
        //   }
        //
        // });



        print("--------------------------------------${widget.idController}");
        showCustomSnackBar(widget.idController);




        await Future.delayed(Duration(seconds:1));

        setState(() {
          success = true;
        });

        await Future.delayed(Duration(milliseconds: 500));

      //  Navigator.pop(context);
      },
      child: Text(
        'Check Flight',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    )
        : !success
        ? CircularProgressIndicator()
        : Icon(
      Icons.check,
      color: Colors.green,
    );

      });

  }
}