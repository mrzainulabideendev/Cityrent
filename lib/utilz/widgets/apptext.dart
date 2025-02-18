import 'package:car_rent/utilz/contants/export.dart';

Widget apptext( 
    {required String myText,
    double size = 12,
    Color textColor = Colors.black,
    // ignore: non_constant_identifier_names
    TextAlign = TextAlign.left,
    bool isBold = false}) {
  return Text(
    myText,
    textAlign: TextAlign,
    style: TextStyle(
        fontSize: size,
        color: textColor,
        fontFamily: "Poppins",
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal),
  );
}
