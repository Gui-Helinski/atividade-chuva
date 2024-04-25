import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 

void main() {
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Calendar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//--------------------------------------------------------------------------------------
class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _filtroAtual = DateTime(2023, 11, 26);
  
  List<dynamic> activities = [];
  
  Future<void> buscaDeAtividades(DateTime dataAlvo) async {
    Uri uri1 = Uri.https('raw.githubusercontent.com', '/chuva-inc/exercicios-2023/master/dart/assets/activities.json');
    Uri uri2 = Uri.https('raw.githubusercontent.com', '/chuva-inc/exercicios-2023/master/dart/assets/activities-1.json');

    try {
      final response1 = await http.get(uri1);
      final response2 = await http.get(uri2);

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        print('Páginas carregadas com sucesso');

        List<dynamic> allActivities1 = json.decode(response1.body)['data'];
        List<dynamic> allActivities2 = json.decode(response2.body)['data'];

        // Combinar as atividades dos dois arquivos
        List<dynamic> combinedActivities = [];
        combinedActivities.addAll(allActivities1);
        combinedActivities.addAll(allActivities2);


        // Filtrar apenas as atividades relacionadas à categoria "Astrofísica e Cosmologia"
        List<dynamic> filteredActivities = combinedActivities.where((activity) {
          var startDateTime = DateTime.parse(activity['start']);
          return startDateTime.year == dataAlvo.year &&
            startDateTime.month == dataAlvo.month &&
            startDateTime.day == dataAlvo.day &&
            (activity['parent'] == null);
        }).toList();

        // Ordenar as atividades por horário
        filteredActivities.sort((a, b) {
          var startTimeA = DateTime.parse(a['start']);
          var startTimeB = DateTime.parse(b['start']);
          return startTimeA.compareTo(startTimeB);
        });
        
        setState(() {
          activities = filteredActivities;
        });

        print('Número de atividades carregadas: ${activities.length}');
        
        activities.forEach((element) {
          print(element);
        });
      } else {
        print('Erro ao carregar páginas: ${response1.statusCode}, ${response2.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }


  void _alterarData(DateTime newDate) {
    setState(() {
      _filtroAtual = newDate;
      buscaDeAtividades(newDate);
    });
  }

  @override
  void initState() {
    super.initState();
    // Carregue os dados JSON no initState
    buscaDeAtividades(_filtroAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfafafa),
      appBar: AppBar(
        backgroundColor: const Color(0xFF456189),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25,)),
            const SizedBox(width: 50,),
            const Column(
              children: [
                Text(
                  'Chuva ❤️ Flutter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
                ),
                Text(
                  "Programação",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 55,
              width: double.infinity,
              color: const Color(0xFF456189),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Container(
                      height: 40,
                      width: 335,
                      decoration: BoxDecoration(
                        color: const Color(0xFFfafafa),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 3,),
                          Container(
                            height: 35,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0XFF306dc3),
                            ),   
                            child: const Icon(Icons.calendar_month_outlined),
                          ),
                          const SizedBox(width: 60),
                          const Text(
                            "Exibindo todas atividades",
                            style: TextStyle(
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 1,),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 60,
                  color: const Color(0xFFfafafa),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nov',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        '2023',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: const Color(0XFF306dc3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _alterarData(DateTime(2023, 11, 26));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder()), // Define a forma do botão como StadiumBorder para remover a borda
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const BorderSide(
                                      color: Colors.transparent); // Define a cor da borda como transparente quando o botão está desativado
                                }
                                return const BorderSide(
                                    color: Colors.transparent); // Define a cor da borda como transparente
                              },
                            ),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text(
                            '26',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                            )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _alterarData(DateTime(2023, 11, 27));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder()), // Define a forma do botão como StadiumBorder para remover a borda
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const BorderSide(
                                      color: Colors.transparent); // Define a cor da borda como transparente quando o botão está desativado
                                }
                                return const BorderSide(
                                    color: Colors.transparent); // Define a cor da borda como transparente
                              },
                            ),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text(
                            '27',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                            )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _alterarData(DateTime(2023, 11, 28));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder()), // Define a forma do botão como StadiumBorder para remover a borda
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const BorderSide(
                                      color: Colors.transparent); // Define a cor da borda como transparente quando o botão está desativado
                                }
                                return const BorderSide(
                                    color: Colors.transparent); // Define a cor da borda como transparente
                              },
                            ),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text(
                            '28',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                            )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _alterarData(DateTime(2023, 11, 29));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder()), // Define a forma do botão como StadiumBorder para remover a borda
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const BorderSide(
                                      color: Colors.transparent); // Define a cor da borda como transparente quando o botão está desativado
                                }
                                return const BorderSide(
                                    color: Colors.transparent); // Define a cor da borda como transparente
                              },
                            ),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text(
                            '29',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                            )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            _alterarData(DateTime(2023, 11, 30));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder()), // Define a forma do botão como StadiumBorder para remover a borda
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const BorderSide(
                                      color: Colors.transparent); // Define a cor da borda como transparente quando o botão está desativado
                                }
                                return const BorderSide(
                                    color: Colors.transparent); // Define a cor da borda como transparente
                              },
                            ),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                          ),
                          child: const Text(
                            '30',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  )
                )
              ],
            ),
            const SizedBox(height: 12,),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (BuildContext context, int index) {
                  var activity = activities[index];
                  var activityId = activity['id'];
                  var titulo = activity['title']['pt-br'] ?? 'Título não disponível';
                  var descricao = activity['description']['pt-br'] ?? 'Descrição não disponível';
                  var categoryColorHex = activity['category']['color'] ?? '#000000'; // Cor padrão em caso de falha na obtenção da cor
                  var categoryColor = Color(int.parse(categoryColorHex.replaceAll('#', '0xFF')));
                  var type = activity['type']['title']['pt-br'] ?? 'Tipo não disponível';
                  var categoria = activity['category']['title']['pt-br'];
                  var horarioDeInicioString = activity['start'];
                  var horarioDeTerminioString = activity['end'];
                  var inicioString = horarioDeInicioString.substring(11, 16); 
                  var terminioString = horarioDeTerminioString.substring(11, 16);
                  List<dynamic> people = activity['people'] ?? [];
                  var nomeDoAutor = '';
                  var instituicaoDoAutor = '';
                  var imagemAutor = '';
                  if (people.isNotEmpty) {
                    var firstPerson = people.first;
                    imagemAutor = firstPerson['picture'] ?? "noa tem imagem";
                  }
                  if (people.isNotEmpty) {
                    var firstPerson = people.first;
                    instituicaoDoAutor = firstPerson['institution'] ?? 'Sem instituição';
                  }
                  if (people.isNotEmpty) {
                    var autor = people[0]; 
                    nomeDoAutor = autor['name'] ?? 'Nome do autor não disponível';
                  }
                  var localizacao = '';
                  if (activity['locations'] != null && activity['locations'].isNotEmpty) {
                    localizacao = activity['locations'][0]['title']['pt-br'] ?? 'Localização não disponível';
                  }
                  var roleLabel = '';
                  if (people.isNotEmpty) {
                    var firstPerson = people.first; 
                    var role = firstPerson['role']; 
  
                    if (role != null) {
                      var label = role['label']; 
    
                      if (label != null) {
                        roleLabel = label['pt-br']; 
                      }
                    } 
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity(activityId: activityId, titulo: titulo, categoria: categoria, horaDeInicio: inicioString, horaDeTerminio: terminioString, localizacao: localizacao, descricao: descricao, papel: roleLabel, nomeDoAutor: nomeDoAutor, instituicao: instituicaoDoAutor, imagemURL: imagemAutor, cor: categoryColor,)));
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Cor do sombreado
                            spreadRadius: 1, // Espalhamento do sombreado
                            blurRadius: 7, // Desfoque do sombreado
                            offset: const Offset(0, 3), // Deslocamento do sombreado
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                           ClipRRect(
                            borderRadius: BorderRadius.circular(5.0), // Aplica as bordas arredondadas à faixa vertical
                            child: Container(
                              width: 5.0, // Largura da faixa vertical
                              color: categoryColor, // Cor da faixa vertical
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0, left: 15),
                                  child: Text(
                                    '$type de $inicioString até $terminioString'
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    titulo,
                                    style: const TextStyle(
                                      fontSize: 18
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    nomeDoAutor,
                                    style: const TextStyle(
                                      color: Color(0xFF808080)
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),    
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------

class Activity extends StatefulWidget {
   final int activityId; // Adicione o parâmetro de ID da atividade
   final String titulo;
   final String categoria;
   final String horaDeInicio;
   final String horaDeTerminio;
   final String localizacao;
   final String descricao;
   final String papel;
   final String nomeDoAutor;
   final String instituicao;
   final String imagemURL;
   final Color cor;
   const Activity({Key? key, required this.activityId, required this.titulo, required this.categoria, required this.horaDeInicio, required this.horaDeTerminio, required this.localizacao, required this.descricao, required this.papel, required this.nomeDoAutor, required this.instituicao, required this.imagemURL, required this.cor}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {

  @override
  void initState() {
    super.initState();
  }

  String limparDescricao(String descricaoHtml) {
  // Remove todas as tags HTML da descrição usando uma expressão regular
  return descricaoHtml.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    var descricaoComHtml = widget.descricao;
    var descricaoLimpa = limparDescricao(descricaoComHtml);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF456189),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25,)
            ),
            const SizedBox(width: 45,),
            const Column(
              children: [
                Text(
                  'Chuva ❤️ Flutter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 35,
                width: double.infinity,
                color: widget.cor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10),
                  child: Text(
                    widget.categoria,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                widget.titulo, 
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.access_time, color: Color(0XFF306dc3), size: 15,),
                    const SizedBox(width: 5,),
                    Text('${widget.horaDeInicio}h - ${widget.horaDeTerminio}h'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.location_on, color: Color(0XFF306dc3), size: 15),
                    const SizedBox(width: 5,),
                    Text(widget.localizacao),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF306dc3),
                  fixedSize: const Size(380, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                onPressed: (){}, 
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text(
                      "Adicionar à sua agenda",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15
                      ),
                    ),
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(
                  descricaoLimpa,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Row(
                children: <Widget>[
                  const SizedBox(width: 35,),
                  Text(
                    widget.papel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Text(
                widget.nomeDoAutor,
                style: const TextStyle(
                  fontSize: 16
                ),
              ),
              Text(
                widget.instituicao,
                style: const TextStyle(
                  color: Color(0xFF808080)
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}