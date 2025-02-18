import 'package:car_rent/utilz/contants/export.dart';

class PopUpforall extends StatefulWidget {
  final String popupname;
  final String popudescription;
  // ignore: prefer_typing_uninitialized_variables
  final popuicon;
  final ontaps;
  const PopUpforall(
      {super.key,
      required this.popupname,
      required this.popudescription,
      required this.popuicon,
      required this.ontaps});

  @override
  State<PopUpforall> createState() => _PopUpforallState();
}

class _PopUpforallState extends State<PopUpforall> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Dialog(
      child: Container(
        height: h * 0.36,
        width: w * 0.8,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.textcolour,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon:  const Icon(Icons.close)),
              ],
            ),
            Icon(
              widget.popuicon,
              color: AppColors.buttonColors,
              size: 50,
            ),
            apptext(
                myText: widget.popupname,
                textColor: AppColors.textcolour,
                size: 18,
                isBold: true),
            SizedBox(
              height: h * 0.02,
            ),
            apptext(myText: widget.popudescription, textColor: Colors.black,size: 18),
            SizedBox(
              height: h * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: h * 0.06,
                    width: w * 0.32,
                    child: appbutton(
                        buttonText: "No",
                        bottonColor: Colors.red,
                        onTap: () {
                          Navigator.pop(context);
                        })),
                SizedBox(
                    height: h * 0.06,
                    width: w * 0.32,
                    child: appbutton(buttonText: "Yes", onTap: widget.ontaps))
              ],
            )
          ],
        ),
      ),
    );
  }
}
