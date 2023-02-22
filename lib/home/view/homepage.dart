import 'package:database2/home/controller/homecontroller.dart';
import 'package:database2/utils/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController txtname = TextEditingController();
  TextEditingController txtstd = TextEditingController();
  TextEditingController txtadd = TextEditingController();
  TextEditingController txtdname = TextEditingController();
  TextEditingController txtdstd = TextEditingController();
  TextEditingController txtdadd = TextEditingController();
  Homecontroller homecontroller = Get.put(Homecontroller());

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    homecontroller.dataList.value = await DbHelper.dbHelper.readData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My SQL"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: txtname,
                decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtstd,
                decoration: InputDecoration(
                  hintText: "Std",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: txtadd,
                decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  DbHelper.dbHelper.insertData(
                      name: txtname.text, add: txtadd.text, std: txtstd.text);
                  getData();
                },
                child: Text("Insert"),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading:
                              Text("${homecontroller.dataList[index]['id']}"),
                          title:
                              Text("${homecontroller.dataList[index]['name']}"),
                          subtitle: Text(
                              "${homecontroller.dataList[index]['address']}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  txtdname = TextEditingController(
                                      text: homecontroller.dataList[index]
                                          ['name']);
                                  txtdstd = TextEditingController(
                                      text: homecontroller.dataList[index]
                                          ['std']);
                                  txtdadd = TextEditingController(
                                      text: homecontroller.dataList[index]
                                          ['address']);

                                  Get.defaultDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: txtdname,
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: txtdstd,
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller: txtdadd,
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              DbHelper.dbHelper.updateData(
                                                  id: homecontroller
                                                      .dataList[index]['id'],
                                                  name: txtdname.text,
                                                  std: txtdstd.text,
                                                  add: txtdadd.text);
                                              getData();
                                              Get.back();
                                            },
                                            child: Text("Update"),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DbHelper.dbHelper.deleteData(
                                      id: homecontroller.dataList[index]['id']);
                                  getData();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: homecontroller.dataList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
