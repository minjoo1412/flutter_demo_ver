import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_ver/Screen/table_list.dart';
import 'package:flutter_demo_ver/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(60)
          )
          ),
          child: Column(
            children: <Widget>[
              Container(
                  child: Text(
                    '\n\n냉장고를 지켜라',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.04,
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
              Container(
                  child: Text(
                    '\n방치되는 재료가 없도록',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.055,
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
              Container(
                  child: SvgPicture.asset("assets/images/nangjang1.svg", height: size.height*0.5,),
              ),
              Container(
                margin: EdgeInsets.only(top: size.height*0.05),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white

                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Tabless()));
                  },
                  child: Text("  다음  ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.height*0.04,
                      color: Colors.white
                    ),
                  ),
                ),
              )
            ]
          ),
        ),
      ]
    );
  }
}
