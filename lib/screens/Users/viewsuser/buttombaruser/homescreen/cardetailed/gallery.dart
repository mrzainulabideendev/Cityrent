import 'package:car_rent/utilz/contants/export.dart';

class Galleryscreen extends StatefulWidget {
  final List? imagesCarList;
  const Galleryscreen({super.key, this.imagesCarList});

  @override
  State<Galleryscreen> createState() => _GalleryscreenState();
}

class _GalleryscreenState extends State<Galleryscreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2, // Defines how many columns the grid will have
        mainAxisSpacing: 2,
        crossAxisSpacing: 1,
        children: List.generate(widget.imagesCarList!.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imagesCarList![index]),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
          );
        }));
  }
}
