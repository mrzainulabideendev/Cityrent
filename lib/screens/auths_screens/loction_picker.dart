import 'package:car_rent/utilz/contants/export.dart';

class NewPlacePicker extends StatefulWidget {
  final bool ownerediti;
  final String? firstName; // Made nullable
  final String? lastname; // Made nullable
  final String? email; // Made nullable
  final String? password; // Made nullable
  final String? phoneNumber; // Made nullable
  final String? role; // Made nullable
  final String? shopname; // Made nullable
  final shopimage; // Made nullable
  final String? shopDescription;

  const NewPlacePicker({
    this.shopDescription,
    this.ownerediti = true,
    this.firstName,
    this.lastname,
    this.email,
    this.password,
    this.phoneNumber,
    this.role,
    this.shopname,
    this.shopimage,
  });

  @override
  _NewPlacePickerState createState() => _NewPlacePickerState();
}

class _NewPlacePickerState extends State<NewPlacePicker> {
  LatLng? _initialPosition; // Set as nullable
  LatLng? _selectedPosition; // Set as nullable
  late GoogleMapController _mapController;
  bool _isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Get user location when screen opens
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Update the initial position and selected marker position
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _selectedPosition = _initialPosition;
      _isLoading = false; // Remove the loading state
    });

    // Move the camera to the current location
    _mapController.animateCamera(CameraUpdate.newLatLng(_initialPosition!));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final authsRead = context.read<Authencationcontroller>();
    final authsWatch = context.watch<Authencationcontroller>();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition ?? LatLng(0, 0),
                      zoom: 17,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _selectedPosition != null
                        ? {
                            Marker(
                              markerId: MarkerId('selected_location'),
                              position: _selectedPosition!,
                              draggable: true,
                              onDragEnd: (LatLng newPosition) {
                                setState(() {
                                  _selectedPosition = newPosition;
                                });
                              },
                            ),
                          }
                        : {},
                    onCameraMove: (CameraPosition position) {
                      setState(() {
                        _selectedPosition = position.target;
                      });
                    },
                  ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.2),
                child: SizedBox(
                  width: w * 0.8,
                  height: h * 0.07,
                  child: ElevatedButton(
                    child: Center(child: Text("Pick Location")),
                    onPressed: () async {
                      if (_selectedPosition != null) {

                        if (widget.ownerediti) {
                          bool res = await authsRead.changeOnwerLocation(
                              shoplatitude: _selectedPosition!.latitude,
                              shoplongitude: _selectedPosition!.longitude);
                          if (res) {
                            await authsRead.getUserRole(
                                FirebaseAuth.instance.currentUser!.uid);
                            Navigator.pop(context);
                            snaki(
                                context: context,
                                msg: "Successfully Change Your Profile");
                          }
                        } else {
                          bool res = await authsRead.signUpUser(
                            firstName: widget.firstName!,
                            lastName: widget.lastname!,
                            email: widget.email!,
                            password: widget.password!,
                            phoneNumber: widget.phoneNumber!,
                            context: context,
                            role: widget.role!,
                            shopDescription: widget.shopDescription,
                            latitude: _selectedPosition!.latitude,
                            longitude: _selectedPosition!.longitude,
                            shopName: widget.shopname,
                            shopimage: widget.shopimage,
                          );

                          if (res == true) {
                            await FirebaseAuth.instance.signOut();

                            showDialog(
                              context: context,
                              builder: (context) => signuppopup(),
                            );
                          } else {
                            print("Signup failed or returned null");
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            authsWatch.isLoading ? loadingforall() : const SizedBox(),
            Positioned(
              top: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _getUserLocation,
                child:   const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
