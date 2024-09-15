import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
 final Function()? onTap;
 final hantname;
  const Bottom({Key? key, required this.onTap, this.hantname}) : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onTap,
    height: 45,
    minWidth: 300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: Colors.orange),
    ),
    color: Colors.orange,
    child: Text( hantname,style: TextStyle(color: Colors.white),),
    );
  }
}
