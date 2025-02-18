import '../../../../../utilz/contants/export.dart';

class Shopslistuser extends StatefulWidget {
  const Shopslistuser({super.key});

  @override
  State<Shopslistuser> createState() => _ShopslistuserState();
}

class _ShopslistuserState extends State<Shopslistuser> {
  List<bool> isFavorite = List.generate(3, (index) => false);
  String shopSearch = '';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      /////////////////////////////////////// Search===================================

      appBar: AppBar(
        backgroundColor: AppColors.textcolour,
        elevation: 0,
        title: Row(
          children: [
            apptext(
              myText: "Shop List",
              textColor: AppColors.buttonColors,
              size: 22,
              isBold: true,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: w,
        height: h,
        color: AppColors.textcolour,
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: Column(
          children: [
            /////////////////////////////////////// Search===================================
            TextFormField(
              onChanged: (value) {
                setState(() {
                  shopSearch = value;
                });
              },
              style: const TextStyle(fontFamily: "Poppins"),
              decoration: InputDecoration(
                fillColor: AppColors.textformcolour,
                filled: true,
                contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                hintText: "Search for a Shop",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.buttonColors),
                ),
              ),
            ),
            /////////////////////////////////////// Search===================================

            /////////////////////////////////////// Shop List===================================
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Owner").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColors,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    var shoplistOwner = snapshot.data!.docs;

                    if (shopSearch.isNotEmpty) {
                      shoplistOwner = shoplistOwner.where((element) {
                        return element
                            .get('shopName')
                            .toString()
                            .toLowerCase()
                            .contains(shopSearch.toLowerCase());
                      }).toList();
                    }

                    if (shoplistOwner.isNotEmpty) {
                      return ListView.builder(
                        itemCount: shoplistOwner.length,
                        itemBuilder: (context, index) {
                          String heroTag =
                              "Shopdeatail_${shoplistOwner[index]['ShopImage']}";

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      Shopdetailsacreen(
                                    heroTag: heroTag,
                                    ownerData: shoplistOwner[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: w,
                              height: h * 0.21,
                              decoration: BoxDecoration(
                                color: AppColors.textcolour,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.02, vertical: h * 0.01),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: heroTag,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.textformcolour,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              shoplistOwner[index]
                                                  ['ShopImage']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: w * 0.3,
                                      height: h * 0.15,
                                    ),
                                  ),
                                  SizedBox(width: w * 0.025),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: h * 0.007),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            apptext(
                                              myText: shoplistOwner[index]
                                                  ['shopName'],
                                              textColor: AppColors.buttonColors,
                                              size: 16,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                        apptext(
                                          myText:
                                              "${shoplistOwner[index]['firstName']} ${shoplistOwner[index]['lastName']}",
                                          textColor: AppColors.buttonColors,
                                          size: 15,
                                        ),
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: w * 0.05,
                                            );
                                          }),
                                        ),
                                        apptext(
                                          myText: shoplistOwner[index]
                                                          ['shopDescription']
                                                      .length >
                                                  100
                                              ? '${shoplistOwner[index]['shopDescription'].toString().substring(0, 100)}...'
                                              : shoplistOwner[index]
                                                  ['shopDescription'],
                                          textColor: AppColors.buttonColors,
                                          size: 12,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: apptext(myText: "No Car Found"));
                    }
                  } else {
                    return Center(child: apptext(myText: "No Car Found"));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
