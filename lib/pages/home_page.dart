import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:dio_network/models/product_model.dart';
import 'package:dio_network/services/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> list1 = [];
  AllProductModel allProductModel = AllProductModel();
  List list = [];
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  Future<void> getData() async {
    isLoading = false;
    list = [];
    setState(() {});
    var result = await DioService.getData(DioService.mockApi);

    if (result == DioException) {
      result = result as DioException;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Error at: ${result.type.name}. Because of ${result.error}"),
        backgroundColor: Colors.grey,
      ));
    } else {
      list = allProductModelFromJson(result as String);
      log("allProductModel");
      allProductModel = list[0] as AllProductModel;
      list1 = allProductModel.products as List<Product>;
      isLoading = true;
      setState(() {});
    }
  }

  Future<void> searchProduct(String text) async {
    isLoading = false;
    list = [];
    setState(() {});
    var result = await DioService.getData("${DioService.apiSearchProduct}$text");

    if (result == DioException) {
      result = result as DioException;
      log("error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Error at: ${result.type.name}. Because of ${result.error}"),
        backgroundColor: Colors.grey,
      ));
    } else {
      list = allProductModelFromJson(result as String);
      isLoading = true;
      setState(() {});
    }
  }

  Future<void> getCategory(String text) async {
    isLoading = false;
    list = [];
    setState(() {});
    var result =
        await DioService.getDummyData("${DioService.apiCategoryProducts}$text");

    if (result == DioException) {
      result = result as DioException;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Error at: ${result.type.name}. Because of ${result.error}"),
        backgroundColor: Colors.grey,
      ));
    } else {
      list = allProductModelFromJson(result as String);
      isLoading = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextField(
              onChanged: (text) async {
                if (text.isEmpty) {
                  list1 = allProductModel.products!;
                } else {
                  list1 = allProductModel.products!
                      .where((product) => product.title!
                          .toLowerCase()
                          .contains(text.toLowerCase()))
                      .toList();
                }
                setState(() {});
              },
              controller: textEditingController,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: const TextStyle(color: Colors.amber),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.yellow)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.yellow)),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: list1.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {},
                                autoClose: false,
                                backgroundColor: const Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                                borderRadius: BorderRadius.circular(20),
                              ),
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                autoClose: false,
                                label: 'Delete',
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: Colors.blueGrey.withOpacity(0.3),
                            elevation: 0,
                            child: ListTile(
                              leading: Image.network(list1[index].images?[0] ??
                                  "https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg"),
                              title: Text(list1[index].title ?? "No title"),
                              titleTextStyle:
                                  const TextStyle(color: Colors.white),
                              subtitle: Text("Price: ${list1[index].price}\$"),
                              subtitleTextStyle:
                                  const TextStyle(color: Colors.white),
                              trailing: Text(
                                list1[index].category ?? "",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Categories",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                )),
            ListTile(
              title: const Text(
                "SmartPhones",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("smartphones");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("smartphones"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Laptops",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("laptops");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("laptops"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Fragrances",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("fragnances");
                setState(() {});
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("fragnances"))
                    .toList();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Skincare",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("skincare");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("skincare"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Groceries",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("groceries");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("groceries"))
                    .toList();
                setState(() {});

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Home-decoration",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("home-decoration");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("home-decoration"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Furniture",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("furniture");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("furniture"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Tops",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("tops");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("tops"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Womens-dresses",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("womens-dresses");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("womens-dresses"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Womens-shoes",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("womens-shoes");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("womens-shoes"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Men-shirts",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("men-shirts");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("men-shirts"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Mens-shoes",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("mens-shoes");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("mens-shoes"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Mens-watches",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("mens-watches");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("mens-watches"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Womens-watches",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("womens-watches");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("womens-watches"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Womens-bags",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("womens-bags");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("womens-bags"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Womens-jewellery",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("womens-jewellery");
                list1 = list1
                    .where((element) => element.category
                        .toString()
                        .contains("womens-jewellery"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Sunglasses",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("sunglasses");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("sunglasses"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Automative",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("automative");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("automative"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Motorcycle",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("motorcycle");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("motorcycle"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                "Lighting",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                // await getCategory("lighting");
                list1 = list1
                    .where((element) =>
                        element.category.toString().contains("lighting"))
                    .toList();
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
