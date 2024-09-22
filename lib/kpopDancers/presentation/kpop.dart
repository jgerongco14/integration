// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:integration/kpopDancers/controller/kpopController.dart';
import 'package:integration/kpopDancers/model/description.dart';
import 'package:integration/kpopDancers/widget/textFieldWidget.dart';

class KPOPDancersPage extends StatefulWidget {
  const KPOPDancersPage({Key? key}) : super(key: key);

  @override
  _KPOPDancersPageState createState() => _KPOPDancersPageState();
}

class _KPOPDancersPageState extends State<KPOPDancersPage> {
  final kpopDancerController = KpopDancerController();
  late Future<List<Map<String, dynamic>>?> kpopDancers;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    kpopDancers = kpopDancerController.fetchKpopDancers();
  }

  @override
  Widget build(BuildContext context) {
    final heightSize = MediaQuery.of(context).size.height;
    final widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text(
              'KPOP Dancers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by stage name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          kpopDancers = kpopDancerController.fetchKpopDancers();
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    performSearch(searchController.text);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>?>(
                    future: kpopDancers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: heightSize * 1,
                            crossAxisCount: 1,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final kpopDancer = snapshot.data![index];

                            return Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: PopupMenuButton<String>(
                                          icon: const Icon(
                                              FontAwesomeIcons.ellipsis),
                                          onSelected: (String choice) async {
                                            if (choice == 'edit') {
                                              editCard(kpopDancer);
                                            } else if (choice == 'delete') {
                                              await kpopDancerController
                                                  .deleteKpopDancer(
                                                      kpopDancer['id']);
                                              setState(() {
                                                kpopDancers =
                                                    kpopDancerController
                                                        .fetchKpopDancers();
                                              });
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ];
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomTextField(
                                    description: kpopDancer['name'],
                                    fontsize: 30,
                                  ),
                                  const Text('Also known as: '),
                                  CustomTextField(
                                    description: kpopDancer['stage_name'],
                                    fontsize: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SizedBox(
                                      height: heightSize * 0.5,
                                      width: widthSize * 0.8,
                                      child: kpopDancer['photo'] != null &&
                                              kpopDancer['photo'].isNotEmpty
                                          ? Image.network(
                                              kpopDancer['photo'],
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(Icons.person,
                                              size: heightSize * 0.5),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: widthSize * 0.08),
                                    child: CustomTextField(
                                      description: buildDescription(kpopDancer),
                                      fontsize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            addKpopDancer();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }

  void performSearch(stageName) {
    String stageName = searchController.text.trim();
    if (stageName.isNotEmpty) {
      setState(() {
        kpopDancers = kpopDancerController.searchKpopDancers(stageName);
      });
    }
  }

  void addKpopDancer() {
    final newName = TextEditingController();
    final newStageName = TextEditingController();
    final newPhoto = TextEditingController();
    final newAge = TextEditingController();
    final newSex = TextEditingController();
    final newKgroup = TextEditingController();
    final newCompany = TextEditingController();
    final newDebutYear = TextEditingController();
    final newNationality = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add KPOP Dancer"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Title(
                  title: 'STAGE NAME',
                ),
                TextField(controller: newStageName),
                const Title(
                  title: 'NAME',
                ),
                TextField(controller: newName),
                const Title(
                  title: 'PHOTO',
                ),
                TextField(controller: newPhoto),
                const Title(
                  title: 'AGE',
                ),
                TextField(controller: newAge),
                const Title(
                  title: 'SEX',
                ),
                TextField(controller: newSex),
                const Title(
                  title: 'KPOP GROUP',
                ),
                TextField(controller: newKgroup),
                const Title(
                  title: 'COMPANY',
                ),
                TextField(controller: newCompany),
                const Title(
                  title: 'DEBUT YEAR',
                ),
                TextField(controller: newDebutYear),
                const Title(
                  title: 'NATIONALITY',
                ),
                TextField(controller: newNationality),
                // Show the Save button if the caption has been modified
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> newData = {
                      'stage_name': newStageName.text,
                      'name': newName.text,
                      'photo': newPhoto.text,
                      'age': newAge.text,
                      'sex': newSex.text,
                      'kgroup': newKgroup.text,
                      'company': newCompany.text,
                      'debut_year': newDebutYear.text,
                      'nationality': newNationality.text,
                    };

                    await kpopDancerController.insertKpopDancer(newData);

                    setState(() {
                      kpopDancers = kpopDancerController.fetchKpopDancers();
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editCard(Map<String, dynamic> kpopDancer) {
    String? newName;
    String? newStageName;
    String? newPhoto;
    String? newAge;
    String? newSex;
    String? newKgroup;
    String? newCompany;
    String? newDebutYear;
    String? newNationality;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit KPOP Dancer"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Title(
                  title: 'STAGE NAME',
                ),
                TextField(
                  controller:
                      TextEditingController(text: kpopDancer['stage_name']),
                  onChanged: (value) {
                    newStageName = value;
                  },
                ),
                const Title(
                  title: 'NAME',
                ),
                TextField(
                  controller: TextEditingController(text: kpopDancer['name']),
                  onChanged: (value) {
                    newName = value;
                  },
                ),
                const Title(
                  title: 'PHOTO',
                ),
                TextField(
                  controller: TextEditingController(text: kpopDancer['photo']),
                  onChanged: (value) {
                    newPhoto = value;
                  },
                ),
                const Title(
                  title: 'AGE',
                ),
                TextField(
                  controller: TextEditingController(text: kpopDancer['age']),
                  onChanged: (value) {
                    newAge = value;
                  },
                ),
                const Title(
                  title: 'SEX',
                ),
                TextField(
                  controller: TextEditingController(text: kpopDancer['sex']),
                  onChanged: (value) {
                    newSex = value;
                  },
                ),
                const Title(
                  title: 'KPOP GROUP',
                ),
                TextField(
                  controller: TextEditingController(text: kpopDancer['kgroup']),
                  onChanged: (value) {
                    newKgroup = value;
                  },
                ),
                const Title(
                  title: 'COMPANY',
                ),
                TextField(
                  controller:
                      TextEditingController(text: kpopDancer['company']),
                  onChanged: (value) {
                    newCompany = value;
                  },
                ),
                const Title(
                  title: 'DEBUT YEAR',
                ),
                TextField(
                  controller:
                      TextEditingController(text: kpopDancer['debut_year']),
                  onChanged: (value) {
                    newDebutYear = value;
                  },
                ),
                const Title(
                  title: 'NATIONALITY',
                ),
                TextField(
                  controller:
                      TextEditingController(text: kpopDancer['nationality']),
                  onChanged: (value) {
                    newNationality = value;
                  },
                ),
                // Show the Save button if the caption has been modified
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await kpopDancerController.updateKpopDancer(
                      kpopDancer['id'],
                      newStageName,
                      newName,
                      newPhoto,
                      newAge,
                      newSex,
                      newKgroup,
                      newCompany,
                      newDebutYear,
                      newNationality,
                    );

                    setState(() {
                      kpopDancers = kpopDancerController.fetchKpopDancers();
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}
