import 'package:car_rent/utilz/contants/export.dart';

class ShopAbout extends StatefulWidget {
  final dynamic ownerdata;

  const ShopAbout({
    super.key,
    this.ownerdata,
  });

  @override
  State<ShopAbout> createState() => _ShopAboutState();
}

class _ShopAboutState extends State<ShopAbout> {
  late GoogleMapController mapController;

 
  late final LatLng _center = LatLng(
    widget.ownerdata['shoplatitude'], 
    widget.ownerdata['shoplongitude'],
  );

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('_centerMarker'),
          position: _center, // Marker position
          infoWindow: InfoWindow(
            title: widget.ownerdata['shopName'], // Dynamic shop name
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, ),
      width: w,
      color: AppColors.textcolour,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.message,
                  size: w * 0.08,
                ),
                SizedBox(
                  width: w * 0.04,
                ),
                apptext(myText: "Chat With Owner", size: 15, isBold: true),
                Spacer(),
                SizedBox(
                    width: w * 0.25,
                    height: h * 0.05,
                    child: appbutton(buttonText: "Chat", onTap: () {}))
              ],
            ),
            SizedBox(
              height: h * 0.013,
            ),
            Row(
              children: [
                apptext(myText: "Shop Name", size: 20, isBold: true),
                Spacer(),
                apptext(
                  myText: widget.ownerdata['shopName'], // Dynamic shop name
                  size: 18,
                ),
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Divider(),
            Row(
              children: [
                apptext(myText: "Owner", size: 18, isBold: true),
                Spacer(),
                apptext(
                  myText:
                      "${widget.ownerdata['firstName']} ${widget.ownerdata['lastName']}",
                  size: 15,
                ),
              ],
            ),
            SizedBox(
              height: h * 0.01,
            ),
            Divider(),
              Row(
              children: [
                apptext(myText: "Phone Number", size: 15, isBold: true),
                Spacer(),
                apptext(
                  myText: widget.ownerdata['phoneNumber'], // Dynamic shop name
                  size: 18,
                ),
              ],
            ),
           SizedBox(
              height: h * 0.01,
            ),
            Divider(),
            apptext(myText: "Map Location", size: 20, isBold: true),
            SizedBox(
              height: h * 0.01,
            ),
            Container(
              width: w,
              height: h * 0.2,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center, // Initial camera position
                  zoom: 9.0, // Adjust zoom level as needed
                ),
                markers: _markers, // Display markers on the map
              ),
            ),
          ],
        ),
      ),
    );
  }
}
