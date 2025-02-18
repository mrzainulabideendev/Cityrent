import 'package:intl/intl.dart';
import '../../../../../../utilz/contants/export.dart';

class Reviewscreen extends StatefulWidget {
  final dynamic carData;

  const Reviewscreen({super.key, required this.carData});

  @override
  State<Reviewscreen> createState() => _ReviewscreenState();
}

class _ReviewscreenState extends State<Reviewscreen> {
  late List<int> reviewCounts;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Cars')
            .doc(widget.carData.reference.id)
            .collection("Reviews")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reviews available"));
          }

          var carReviews = snapshot.data!.docs;

          // Initialize reviewCounts for 5 ratings (1-5 stars)
          reviewCounts = List<int>.filled(5, 0);

          // Count reviews based on rating and calculate total stars
          int totalStars = 0; // Initialize total stars
          for (var review in carReviews) {
            int rating = (review['star'] as num).toInt();
            if (rating >= 1 && rating <= 5) {
              reviewCounts[rating - 1]++;
              totalStars += rating; // Accumulate total stars
            }
          }

          // Calculate total reviews
          int totalReviews = carReviews.length;

          // Calculate total possible stars
          int totalPossibleStars = totalReviews * 5;

          // Calculate the percentage of total stars received
          double totalStarsPercentage =
              totalPossibleStars > 0 ? totalStars / totalPossibleStars : 0.0;

          return Container(
            color: AppColors.textcolour,
            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: w * 0.11,
                    lineWidth: 7.0,
                    animation: true,
                    animationDuration: 1000,
                    percent: totalStarsPercentage,
                    progressColor: Colors.green,
                    center: apptext(
                      myText:
                          "${(totalStarsPercentage * 10).toStringAsFixed(1)}%",
                      size: 15,
                      isBold: true,
                    ),
                  ),
                  apptext(
                    myText: "Based on $totalReviews reviews from our users",
                    size: 15,
                  ),
                  SizedBox(height: h * 0.02),

                  // Loop from 5 to 1 stars
                  for (int i = 4; i >= 0; i--)
                    review(
                      trailin: reviewCounts[i].toString(),
                      leadin: (i + 1).toString(),
                      perce: totalReviews > 0
                          ? reviewCounts[i] / totalReviews
                          : 0.0,
                    ),

                  SizedBox(height: h * 0.02),

                  Column(
                    children: List.generate(carReviews.length, (index) {
                      var carReview = carReviews[index];
                      return _buildComment(index, carReview, w, h);
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildComment(
      int index, QueryDocumentSnapshot carReview, double w, double h) {
    String name = carReview['name'] ?? "Anonymous";
    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "A";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: w * 0.15,
              height: h * 0.06,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColors,
              ),
              child: Center(
                // Use the first letter instead of "Z"
                child: apptext(myText: firstLetter, size: 25),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                apptext(myText: name, size: 15),
                apptext(
                  myText: DateFormat('yyyy-MM-dd HH:mm')
                      .format(carReview['dateTime'].toDate()),
                  size: 10,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: h * 0.01),
        Container(
          padding: EdgeInsets.only(left: w * 0.06),
          child: apptext(
            myText: carReview['comment'] ?? "No comment provided",
            size: 13,
          ),
        ),
        const Divider(
          color: Colors.grey,
          height: 20,
          thickness: 1,
        ),
      ],
    );
  }
}

Widget review({
  required String trailin,
  required String leadin,
  required double perce,
}) {
  return Builder(
    builder: (context) {
      final w = MediaQuery.of(context).size.width;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearPercentIndicator(
            width: w * 0.7,
            lineHeight: 9.0,
            progressColor: Colors.green,
            percent: perce,
            animation: true,
            animationDuration: 1000,
            trailing: SizedBox(
              width: w * 0.09,
              child: Center(child: apptext(myText: trailin, size: 13)),
            ),
            leading: SizedBox(
              width: w * 0.09,
              child: Center(child: apptext(myText: leadin, size: 13)),
            ),
            barRadius: const Radius.circular(25),
          ),
        ],
      );
    },
  );
}
