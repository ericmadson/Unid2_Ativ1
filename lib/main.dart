import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService {
  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);

  var keys = ["name", "style", "ibu"];
  var columns = ["Exercitando", "os", "estados"];

  void load(index) {
    var funcoes = [
      loadMartialArts,
      loadCountry,
      loadCompanies,
    ];

    funcoes[index]();
  }

  void columnMartialArts() {
    keys = ["name", "type", "foundation"];
    columns = ["Nome", "Estilo", "Fundação"];
  }

  void columnCountry() {
    keys = ["country", "title_amount", "last_title"];
    columns = ["Seleção", "Quantidade de Títulos", "Último Título"];
  }

  void columnCompanies() {
    keys = ["company", "founder", "foundation_year"];
    columns = ["Empresa", "Fundador", "Ano de Fundação"];
  }

  void loadMartialArts() {
    columnMartialArts();

    tableStateNotifier.value = [
      {"name": "Jiu-Jistu", "type": "Grappling", "foundation": "Séc. III"},
      {"name": "Boxe", "type": "Striking", "foundation": "Séc. XVI"},
      {"name": "Karatê", "type": "Striking", "foundation": "Séc XIX"},
      {"name": "Judô", "type": "Grappling", "foundation": "Séc. XIX"},
      {"name": "Muay Thai", "type": "Striking", "foundation": "Séc. XV"}
    ];
  }

  void loadCountry() {
    columnCountry();

    tableStateNotifier.value = [
      {"country": "Brasil", "title_amount": "5", "last_title": "2002"},
      {"country": "Alemanha", "title_amount": "4", "last_title": "2014"},
      {"country": "Itália", "title_amount": "4", "last_title": "2006"},
      {"country": "Argentina", "title_amount": "3", "last_title": "1986"},
      {"country": "Uruguai", "title_amount": "2", "last_title": "1950"}
    ];
  }

  void loadCompanies() {
    columnCompanies();

    tableStateNotifier.value = [
      {"company": "Amazon", "founder": "Jeff Bezos", "foundation_year": "1994"},
      {
        "company": "Microsoft",
        "founder": "Bill Gates",
        "foundation_year": "1975"
      },
      {
        "company": "Apple",
        "founder": "Steve Jobs, Steve Wozniak, Ronald Wayne",
        "foundation_year": "1976"
      },
      {
        "company": "Alphabet (Google)",
        "founder": "Larry Page, Sergey Brin",
        "foundation_year": "1998"
      },
      {
        "company": "Facebook",
        "founder": "Mark Zuckerberg",
        "foundation_year": "2004"
      }
    ];
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("State Change"),
          ),
          body: ValueListenableBuilder(
              valueListenable: dataService.tableStateNotifier,
              builder: (_, value, __) {
                return DataTableWidget(
                  jsonObjects: value,
                  propertyNames: dataService.keys,
                  columnNames: dataService.columns,
                );
              }),
          bottomNavigationBar:
              NewNavBar(itemSelectedCallback: dataService.load),
        ));
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback;

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {};
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);
    return BottomNavigationBar(
        onTap: (index) {
          state.value = index;
          itemSelectedCallback(index);
        },
        currentIndex: state.value,
        items: const [
          BottomNavigationBarItem(
            label: "Artes Marciais",
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
              label: "Seleções", icon: Icon(Icons.emoji_flags)),
          BottomNavigationBarItem(
              label: "Empresas", icon: Icon(Icons.library_books_rounded))
        ]);
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget(
      {this.jsonObjects = const [],
      this.columnNames = const ["Nome", "Estilo", "IBU"],
      this.propertyNames = const ["name", "style", "ibu"]});
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: columnNames
            .map((name) => DataColumn(
                label: Expanded(
                    child: Text(name,
                        style: TextStyle(fontStyle: FontStyle.italic)))))
            .toList(),
        rows: jsonObjects
            .map((obj) => DataRow(
                cells: propertyNames
                    .map((propName) => DataCell(Text(obj[propName])))
                    .toList()))
            .toList());
  }
}
