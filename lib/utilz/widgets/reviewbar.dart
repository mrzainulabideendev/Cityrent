import 'package:car_rent/utilz/contants/export.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Reviewbox extends StatefulWidget {
  final car;

  const Reviewbox({
    super.key,
    this.car,
  });

  @override
  State<Reviewbox> createState() => _ReviewboxState();
}

class _ReviewboxState extends State<Reviewbox> {
  double _rating = 0;
  final TextEditingController commentController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final userCarRead = context.read<UserViewerController>();
    final autwatch = context.watch<Authencationcontroller>();
    final notificatioRead = context.watch<GolbProviderNotification>();

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
        height: h * 0.43,
        width: w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.textcolour,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close)),
                ],
              ),
              Center(
                child: apptext(
                  myText: "Review",
                  size: 20,
                  isBold: true,
                ),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                itemCount: 5,
                itemSize: 30.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Material(
                child: textformfeild(
                  hint: "Your comment...",
                  maxline: 5,
                  erorcolour: Colors.red,
                  myController: commentController,
                  borderColor: AppColors.buttonColors,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }

                    return null;
                  },
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              SizedBox(
                height: h * 0.06,
                width: w * 0.28,
                child: Center(
                  child: appbutton(
                      buttonText: "Submit",
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          if (_rating > 0) {
                            await userCarRead.reviewrideComplete(
                                carid: widget.car["carId"],
                                comment: commentController.text,
                                name:
                                    "${autwatch.userData!["firstName"]} ${autwatch.userData!["lastName"]}",
                                star: _rating);
                            bool res = await userCarRead.rideComplete(
                                bookingId: widget.car.reference.id);

                            if (res) {
                              await notificatioRead.sendFCMNotification(
                                  body: "Successfully Booking is Complete",
                                  title: "Booking Complete",
                                  collection: "Owner",
                                  uid: widget.car['owner']);
                              Navigator.pop(context);
                            }
                          } else {
                            snaki(
                                context: context, msg: "please sslect satrts");
                          }
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
