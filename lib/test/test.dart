//import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_app_bar_page/search_app_bar_page.dart';









// ignore: must_be_immutable
class SearchAppBarStream1 extends StatefulWidget {
  const SearchAppBarStream1({Key? key}) : super(key: key);

  @override
  _SearchAppBarStream1State createState() => _SearchAppBarStream1State();
}

class _SearchAppBarStream1State extends State<SearchAppBarStream1> {
  @override
  Widget build(BuildContext context) {
    return 
    SearchAppBarPageStream<Person>(
      //initialData: _initialData,
      magnifyinGlassColor: Color.fromARGB(255, 207, 58, 58),
      searchAppBarcenterTitle: true,
      searchAppBarhintText: 'Search for a name',
      searchAppBartitle: Text(
        'Search Stream Page',
        style: TextStyle(fontSize: 20),
      ),

      /// Add stream. Use setState if your stream change.
      listStream: _streamListPerson,
      stringFilter: (Person person) => person.name,
      //stringFilter: (Person person) => person.age.toString(),
      /// sort default compare by stringFilter return.
      sortFunction: (Person a, Person b) => a.age!.compareTo(b.age!),
      filtersType: FiltersTypes.contains,
      obxListBuilder: (context, list, isModSearch) {
        // ☑️ This function is inside an Obx.
        // Place other reactive verables into it.
        if (list.isEmpty) {
          return Center(
              child: Text(
            'NOTHING FOUND',
            style: TextStyle(fontSize: 14),
          ));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      // color: Theme.of(context).primaryColorDark,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Name: ${list[index].name}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Age: ${list[index].age!.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        );
      },
    );
  
  }

  Stream<List<Person>> _streamListPerson = (() async* {
    await Future<void>.delayed(Duration(seconds: 5));
    //throw Exception('Erro voluntario');
    yield dataListPerson3;
  })();
}




final dataListPerson3 = <Person>[
  Person(name: 'Rafaela Pinho', age: 30),
  Person(name: 'Paulo Emilio Silva', age: 45),
  Person(name: 'Pedro Gomes', age: 18),
  Person(name: 'Orlando Guerra', age: 23),
  Person(name: 'Ana Pereira', age: 23),
  Person(name: 'Zacarias Triste', age: 15),
  Person(name: 'Antonio Rabelo', age: 33),
  Person(name: 'Leticia Maciel', age: 47),
  Person(name: 'Patricia Oliveira', age: 19),
  Person(name: 'Pedro Lima', age: 15),
  Person(name: 'Fabio Melo', age: 51),
  Person(name: 'Junior Rabelo', age: 33),
  Person(name: 'Lucia Maciel', age: 47),
  Person(name: 'Ana Oliveira', age: 19),
  Person(name: 'Thiago Silva', age: 33),
  Person(name: 'Charles Ristow', age: 47),
  Person(name: 'Raquel Montenegro', age: 19),
  Person(name: 'Rafael Peireira', age: 15),
  Person(name: 'Thiago Ferreira', age: 33),
  Person(name: 'Joaquim Gomes', age: 18),
  Person(name: 'Esther Guerra', age: 23),
  Person(name: 'Pedro Braga', age: 19),
  Person(name: 'Milu Silva', age: 17),
  Person(name: 'William Ristow', age: 47),
  Person(name: 'Elias Tato', age: 22),
  Person(name: 'Dada Istomesmo', age: 44),
  Person(name: 'Nome Incomum', age: 52),
  Person(name: 'Qualquer Nome', age: 9),
  Person(name: 'First Last', age: 11),
  Person(name: 'Bom Dia', age: 23),
  Person(name: 'Bem Mequiz', age: 13),
  Person(name: 'Mal Mequer', age: 71),
  Person(name: 'Quem Sabe', age: 35),
  Person(name: 'Miriam Leitao', age: 33),
  Person(name: 'Gabriel Mentiroso', age: 19),
  Person(name: 'Caio Petro', age: 27),
  Person(name: 'Tanto Nome', age: 66),
  Person(name: 'Nao Diga', age: 33),
  Person(name: 'Fique Queto', age: 11),
  Person(name: 'Cicero Gome', age: 37),
  Person(name: 'Carlos Gome', age: 48),
  Person(name: 'Mae Querida', age: 45),
  Person(name: 'Exausto Nome', age: 81),
];

//class Person extends CacheJson {
class Person {
  final String? name;

  final int? age;
  final String? id;
  final String? avatar;
  final String? username;
  final String? image;

  Person({
    this.name,
    this.age,
    this.id,
    this.avatar,
    this.username,
    this.image,
  });

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return new Person(
      name: map['name'] as String,
      age: map['age'] as int,
      id: map['id'] as String,
      avatar: map['avatar'] as String,
      username: map['username'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
      'id': this.id,
      'avatar': this.avatar,
      'username': this.username,
      'image': this.image,
    };
  }
}





