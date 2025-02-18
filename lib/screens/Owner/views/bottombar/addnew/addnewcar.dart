import '../../../../../utilz/contants/export.dart';

class CarAddEditScreen extends StatefulWidget {
  final bool isAddNewCar;
  // ignore: prefer_typing_uninitialized_variables
  final cardata;

  const CarAddEditScreen({
    super.key,
    required this.isAddNewCar,
    this.cardata,
  });

  @override
  State<CarAddEditScreen> createState() => _CarAddEditScreenState();
}

class _CarAddEditScreenState extends State<CarAddEditScreen> {
  String? selectedBrand;
  List carImagesList = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        carImagesList.add(pickedFile);
      });
    }
  }

  // List of car brands and logos
  List<Map<String, String>> carBrandsWithLogos = [
    {"brand": "Toyota", "brandImg": LogosApp.toyotalogo},
    {"brand": "Honda", "brandImg": LogosApp.hondalogo},
    {"brand": "BMW", "brandImg": LogosApp.bmwlogo},
    {"brand": "Audi", "brandImg": LogosApp.audilogo},
    {"brand": "Hyundai", "brandImg": LogosApp.hyundailogo},
    {"brand": "Nissan", "brandImg": LogosApp.nissanlogo},
    {"brand": "Kia", "brandImg": LogosApp.kialogo},
    {"brand": "Mazda", "brandImg": LogosApp.mazdalogo},
    {"brand": "Suzuki", "brandImg": LogosApp.suzukilogo},
    {"brand": "Other", "brandImg": IconsApp.speedcar}, // Use a default logo
  ];
  final formkey = GlobalKey<FormState>();

  TextEditingController carnameController = TextEditingController();
  TextEditingController carmodelController = TextEditingController();
  TextEditingController carspeedController = TextEditingController();
  TextEditingController carflueController = TextEditingController();
  TextEditingController carrentperdayController = TextEditingController();
  TextEditingController cardisController = TextEditingController();
  String? cartransmssion;

  @override
  void initState() {
    if (widget.isAddNewCar == false) {
      // carImagesList=  widget.cardata["CarImages"];
      selectedBrand = widget.cardata["Cardrand"];
      cartransmssion = widget.cardata["CarTransmsion"];
      carImagesList = widget.cardata["CarImages"];

      carnameController =
          TextEditingController(text: widget.cardata["CarName"]);
      carmodelController =
          TextEditingController(text: widget.cardata["Carmodel"]);

      carspeedController =
          TextEditingController(text: widget.cardata["Carspeed"]);

      carflueController =
          TextEditingController(text: widget.cardata["Carflue"]);
      carrentperdayController =
          TextEditingController(text: widget.cardata["Carrent"]);
      cardisController =
          TextEditingController(text: widget.cardata["Cardescription"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final carRead = context.read<Ownerviewercontroller>();
    final carwatch = context.watch<Ownerviewercontroller>();

    return Scaffold(
        backgroundColor: AppColors.textcolour,
        appBar: AppBar(
            title: apptext(myText: "Add New Car", size: 20, isBold: true)),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
              ),
              width: w,
              height: h,
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //===========================Select a car Image==============================================

                      Container(
                        height: h * 0.3,
                        width: w,
                        decoration: BoxDecoration(
                          color: AppColors.textformcolour,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: carImagesList.isEmpty
                            ? Center(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          imagePiuckerWidget(),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    // color: AppColors.textcolour,
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add,
                                            color: Colors.blue, size: 30),
                                        SizedBox(height: 8),
                                        Text(
                                          'Please select an image',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                                itemCount: carImagesList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    // Add Image button
                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              imagePiuckerWidget(),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        color: AppColors.textcolour,
                                        child: const Icon(Icons.add,
                                            color: Colors.blue, size: 30),
                                      ),
                                    );
                                  } else {
                                    final image = carImagesList[index - 1];
                                    return Stack(
                                      children: [
                                        Container(
                                          height: h * 0.2,
                                          child: Container(
                                            height: h * 0.1,
                                            width: w * 0.3,
                                            child: widget.isAddNewCar == false
                                                ? (image is String
                                                    ? Image.network(image,
                                                        fit: BoxFit.cover)
                                                    : Image.file(
                                                        File(image.path),
                                                        fit: BoxFit.cover))
                                                : Image.file(File(image.path),
                                                    fit: BoxFit.cover),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                carImagesList
                                                    .removeAt(index - 1);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      //===============================Select a car Image===================================

                      //===========================Select a car brand==============================================
                      apptext(myText: "Select Car brand", size: 15),

                      SizedBox(
                        height: h * 0.01,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role'; // Display required error message
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: AppColors.textformcolour,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Add border radius
                            borderSide:
                                BorderSide.none, // Remove default border line
                          ),
                        ),
                        hint: const Text('Car Brand'),
                        value: selectedBrand,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBrand = newValue;
                            if (selectedBrand == 'Other') {
                              _showOtherBrandDialog(); // Show dialog to enter other brand name
                            }
                          });
                        },
                        items: carBrandsWithLogos.map((car) {
                          return DropdownMenuItem<String>(
                            value: car[
                                'brand'], // Ensure value is unique and matches the DropdownButton value type
                            child: Row(
                              children: [
                                Image.asset(
                                  car['brandImg']!,
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 10),
                                Text(car['brand']!),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(
                        height: h * 0.02,
                      ),
                      //============================================================================================
                      apptext(myText: "Car Name", size: 15),
                      SizedBox(
                        height: h * 0.01,
                      ),

                      textformfeild(
                          hint: "Example 'Yaris' ",
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                          myController: carnameController,
                          erorcolour: Colors.red,
                          backcolour: AppColors.textformcolour,
                          textAlign: TextAlign.start),

                      //===================================Car Model=========================================================
                      SizedBox(
                        height: h * 0.02,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                apptext(myText: "Car Model", size: 15),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                textformfeild(
                                  maxLengths: 4,
                                  textInputType: TextInputType.number,
                                  hint: "Example '2024'",
                                  myController: carmodelController,
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    return null;
                                  },
                                  erorcolour: Colors.red,
                                  backcolour: AppColors.textformcolour,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: w *
                                  0.02), // Adjust the spacing between the two columns
                          Expanded(
                            // Wrap this SizedBox in an Expanded widget as well
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                apptext(myText: "Transmission", size: 15),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.textformcolour,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  hint: Text("Select"),
                                  value: cartransmssion,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a transmission'; // Improved message
                                    }
                                    return null;
                                  },
                                  items: ["Auto", "Manual"]
                                      .map((transmission) => DropdownMenuItem(
                                            value: transmission,
                                            child: Text(transmission),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      cartransmssion =
                                          value; // Update selected value
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //============================================================================================
                      SizedBox(
                        height: h * 0.02,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                apptext(myText: "Speed", size: 15),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: textformfeild(
                                        maxLengths: 3,
                                        textInputType: TextInputType.number,
                                        hint: "160KM/H",
                                        myController: carspeedController,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                        erorcolour: Colors.red,
                                        backcolour: AppColors.textformcolour,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: w * 0.01),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                apptext(myText: "Fuel Average", size: 15),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: textformfeild(
                                        maxLengths: 2,
                                        textInputType: TextInputType.number,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Required";
                                          }
                                          return null;
                                        },
                                        erorcolour: Colors.red,
                                        hint: "20km/L",
                                        myController: carflueController,
                                        backcolour: AppColors.textformcolour,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //=================================Fuel Average"===========================================================

                      //=================================Rent Per Hour==========================================================
                      SizedBox(
                        height: h * 0.02,
                      ),
                      apptext(myText: "Rent Per Day", size: 15),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      textformfeild(
                          maxLengths: 5,
                          textInputType: TextInputType.number,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                          erorcolour: Colors.red,
                          myController: carrentperdayController,
                          hint: "Rent Price Per Day",
                          backcolour: AppColors.textformcolour,
                          textAlign: TextAlign.start),

                      //=================================description===========================================================
                      SizedBox(
                        height: h * 0.02,
                      ),
                      apptext(myText: "Description", size: 15),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      textformfeild(
                          hint: "Write About All detail of Car",
                          myController: cardisController,
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                          erorcolour: Colors.red,
                          backcolour: AppColors.textformcolour,
                          maxline: 6,
                          textAlign: TextAlign.start),

                      SizedBox(
                        height: h * 0.02,
                      ),

                      if (widget.isAddNewCar)
                        SizedBox(
                            height: h * 0.07,
                            child: appbutton(
                                buttonText: "Save",
                                onTap: () async {
                                  if (formkey.currentState!.validate()) {
                                    if (carImagesList.isNotEmpty) {
                                      bool res =
                                          await carRead.addNewCarFunction(
                                        carname: carnameController.text,
                                        description: cardisController.text,
                                        flue: carflueController.text,
                                        carImagess: carImagesList,
                                        model: carmodelController.text,
                                        rent: carrentperdayController.text,
                                        speed: carspeedController.text,
                                        drand: selectedBrand,
                                        transmsion: cartransmssion,
                                      );
                                      carnameController.clear();
                                      cardisController.clear();

                                      carflueController.clear();
                                      carImagesList.clear();
                                      carnameController.clear();
                                      carspeedController.clear();
                                      carmodelController.clear();
                                      carrentperdayController.clear();

                                      if (res) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => newcarpoup(
                                            isbooing: false, 
                                              lottie:
                                                  Appanimation.cardoneanimation,
                                              text: "Car added successfully!"),
                                        );
                                      }
                                    } else {
                                      snaki(
                                          context: context,
                                          msg: "Please Select Car images");
                                    }
                                  }
                                }))
                      else
                        SizedBox(
                            height: h * 0.07,
                            child: appbutton(
                                buttonText: "Update",
                                bottonColor: Colors.green,
                                onTap: () async {
                                  if (formkey.currentState!.validate()) {
                                    if (carImagesList.isNotEmpty) {
                                      bool res = await carRead.carUpDateAllData(
                                          carname: carnameController.text,
                                          description: cardisController.text,
                                          flue: carflueController.text,
                                          model: carmodelController.text,
                                          rent: carrentperdayController.text,
                                          speed: carspeedController.text,
                                          drand: selectedBrand,
                                          transmsion: cartransmssion,
                                          carImagess: carImagesList,
                                          docId: widget.cardata.reference.id);
                                      if (res) {
                                        snaki(
                                            context: context,
                                            msg: "Update sucessfully");
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      snaki(
                                          context: context,
                                          msg: "Please Select Car images",
                                          isErrorColor: true);
                                    }
                                  }
                                })),

                      SizedBox(
                        height: h * 0.02,
                      )
                    ],
                  ),
                ),
              ),
            ),
            carwatch.isLoading ? loadingforall() : const SizedBox()
          ],
        ));
  }

//===========================================showOtherBrandDialog=========================================================================================
  void _showOtherBrandDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController customBrandController = TextEditingController();

        return AlertDialog(
          title: const Text('Enter Car Brand'),
          content: TextField(
            controller: customBrandController,
            decoration: const InputDecoration(hintText: 'Enter brand name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  selectedBrand = customBrandController.text;

                  // Add the new custom brand to the list of car brands
                  if (selectedBrand != null && selectedBrand!.isNotEmpty) {
                    carBrandsWithLogos.add({
                      "brand": selectedBrand!,
                      "brandImg": LogosApp
                          .mazdalogo, // You can use a default logo or a custom one
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//==============================================image picker weighet==============
  imagePiuckerWidget() {
    return Builder(builder: (context) {
      final h = MediaQuery.of(context).size.height;
      final w = MediaQuery.of(context).size.width;
      return Container(
        height: h * 0.22,
        width: w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await pickImage(source: ImageSource.camera);
                    Navigator.pop(context);
                    // Ensure this method is async if needed
                  },
                  icon: Icon(Icons.camera_alt_outlined),
                  iconSize: w * 0.13,
                ),
                apptext(myText: "Camera", isBold: true, size: 13),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    await pickImage(source: ImageSource.gallery);
                    Navigator.pop(context);
                    // await _picker.pickImage(
                    //     source: ImageSource
                    //         .gallery);
                    // Ensure this method is async if needed
                  },
                  icon: Icon(Icons.photo_size_select_actual_sharp),
                  iconSize: w * 0.13,
                ),
                apptext(myText: "Gallery", isBold: true, size: 13),
              ],
            ),
          ],
        ),
      );
    });
  }
}
