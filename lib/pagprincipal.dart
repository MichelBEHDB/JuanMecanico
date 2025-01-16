import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
//Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // Altura personalizada
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBarColor, // Color del fondo
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Sombra sutil
                offset: const Offset(0, 3),
                blurRadius: 5,
              ),
            ],
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20), // Bordes redondeados
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      width: 40, // Tamaño del logo
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Fondo temporal para el logo
                      ),
                      child: const Icon(
                        Icons.directions_bus, // Ícono representativo
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),

                // Texto centrado
                const Expanded(
                  child: Center(
                    child: Text(
                      "Juan el Mecánico",
                      style: TextStyle(
                        color: Colors.white, // Texto en blanco
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Menú desplegable
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    // Lógica para las opciones del menú
                    if (value == 'configuracion') {
                      // Acción para configuración
                    } else if (value == 'ajustes') {
                      // Acción para ajustes
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'configuracion',
                        child: Text('Configuración'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ajustes',
                        child: Text('Ajustes'),
                      ),
                    ];
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white, // Ícono de menú
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ViajesApp(), // Contenido principal
          ),
          GestionSection(),
        ],
      ), // Ahora, este es el cuerpo del Scaffold
    );
  }
}

class ViajesApp extends StatefulWidget {
  @override
  _ViajesAppState createState() => _ViajesAppState();
}

class _ViajesAppState extends State<ViajesApp> {
  String selectedViaje = ""; // Inicializar con un viaje seleccionado
  List<Viaje> viajes = [];

  @override
  void initState() {
    super.initState();
    fetchViajes();
  }

  Future<void> fetchViajes() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot viajesSnapshot = await db.collection('viajes').where('estado',
            whereIn: ['normal', 'retrasado']) // `whereIn` en vez de `isIn`
        .get();

    if (viajesSnapshot.docs.isEmpty) {
      print("No se encontraron viajes con el estado 'normal' o 'retrasado'");
      return; // O maneja el caso donde no hay viajes
    }

    List<Viaje> fetchedViajes = [];
    for (var doc in viajesSnapshot.docs) {
      print("Obteniendo datos de viaje");
      String viajeId = doc.id;
      selectedViaje = doc.id;
      String cliente = doc['cliente'];
      String estado = doc['estado'];
      DocumentReference camionRef = doc['camion'];
      DocumentReference operadorRef = doc['operador'];

      // Obtener datos del camión
      DocumentSnapshot camionSnapshot = await camionRef.get();
      String camionNombre = camionSnapshot['nombre'];
      GeoPoint ubicInicio = camionSnapshot['ubic_inicio'];
      GeoPoint ubicFinal = camionSnapshot['ubic_final'];

      // Obtener datos del operador
      DocumentSnapshot operadorSnapshot = await operadorRef.get();
      String operadorNombre = operadorSnapshot['nombre'];
      String operadorCel = operadorSnapshot['numero_cel'];

      // Crear un objeto Viaje
      Viaje viaje = Viaje(
        id: viajeId,
        cliente: cliente,
        estado: estado,
        camionNombre: camionNombre,
        operadorNombre: operadorNombre,
        operadorCel: operadorCel,
        ubicInicio: ubicInicio,
        ubicFinal: ubicFinal,
      );

      fetchedViajes.add(viaje);
    }

    setState(() {
      viajes = fetchedViajes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          // Sección de "Viajes activos"
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Viajes activos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viajes.length,
                    itemBuilder: (context, index) {
                      Viaje viaje = viajes[index];
                      return viajeItem(viaje);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Sección de detalles del viaje seleccionado
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: viajeDetalles(
                  viajes.firstWhere((viaje) => viaje.id == selectedViaje)),
            ),
          ),
        ],
      ),
    );
  }

  Widget viajeItem(Viaje viaje) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedViaje = viaje.id; // Actualizar el viaje seleccionado
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedViaje == viaje.id ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viaje.camionNombre,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              viaje.cliente,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget viajeDetalles(Viaje viaje) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Estado: ${viaje.estado}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Cliente: ${viaje.cliente}"),
        const SizedBox(height: 8),
        Text("Camión: ${viaje.camionNombre}"),
        const SizedBox(height: 8),
        Text("Operador: ${viaje.operadorNombre}"),
        const SizedBox(height: 8),
        Text("Número de Celular: ${viaje.operadorCel}"),
        const SizedBox(height: 8),
        Text(
            "Ubicación Inicio: ${viaje.ubicInicio.latitude}, ${viaje.ubicInicio.longitude}"),
        const SizedBox(height: 8),
        Text(
            "Ubicación Final: ${viaje.ubicFinal.latitude}, ${viaje.ubicFinal.longitude}"),
      ],
    );
  }
}

class Viaje {
  final String id;
  final String cliente;
  final String estado;
  final String camionNombre;
  final String operadorNombre;
  final String operadorCel;
  final GeoPoint ubicInicio;
  final GeoPoint ubicFinal;

  Viaje({
    required this.id,
    required this.cliente,
    required this.estado,
    required this.camionNombre,
    required this.operadorNombre,
    required this.operadorCel,
    required this.ubicInicio,
    required this.ubicFinal,
  });
}

class GestionSection extends StatefulWidget {
  @override
  _GestionSectionState createState() => _GestionSectionState();
}

class _GestionSectionState extends State<GestionSection> {
  List<Map<String, dynamic>> camiones = []; // Lista para almacenar los camiones

  @override
  void initState() {
    super.initState();
    fetchCamiones();
  }

  // Función para obtener los camiones disponibles desde Firestore
  Future<void> fetchCamiones() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Obtener los camiones con viaje_activo = true
    QuerySnapshot camionesSnapshot = await db
        .collection('camiones') // Solo los camiones activos
        .get();

    List<Map<String, dynamic>> camionesList = [];

    for (var doc in camionesSnapshot.docs) {
      camionesList.add({
        'id': doc.id,
        'nombre': doc['nombre'],
        'viaje_activo': doc['viaje_activo'],
        'modelo': doc['modelo'],
      });
    }

    setState(() {
      camiones = camionesList; // Actualizamos la lista de camiones
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        color: Colors.blue[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sección de gestión",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Camiones",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: camiones.isEmpty
                                      ? const Center(
                                          child: Text(
                                              "No hay camiones disponibles."))
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: camiones.length,
                                          itemBuilder: (context, index) {
                                            final camion = camiones[index];
                                            bool isActivo =
                                                camion['viaje_activo'];

                                            return ListTile(
                                              title: Text(camion['nombre']),
                                              subtitle: Text(
                                                  'Modelo: ${camion['modelo']}'),
                                              tileColor: isActivo
                                                  ? Colors.green[100]
                                                  : Colors
                                                      .white, // Resaltar los activos
                                              trailing: ElevatedButton(
                                                onPressed: () {
                                                  // Navegar a la pantalla del historial de fallas
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HistorialFallasScreen(
                                                              camionId:
                                                                  camion['id']),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                    "Historial de Fallas"),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.directions_car, color: Colors.white),
                    label: const Text("Camiones",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 32),
                      minimumSize: const Size(150, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nueva pantalla de historial de fallas
class HistorialFallasScreen extends StatefulWidget {
  final String camionId;

  const HistorialFallasScreen({Key? key, required this.camionId})
      : super(key: key);

  @override
  _HistorialFallasScreenState createState() => _HistorialFallasScreenState();
}

class _HistorialFallasScreenState extends State<HistorialFallasScreen> {
  List<Map<String, dynamic>> fallas = [];

  @override
  void initState() {
    super.initState();
    fetchFallas();
  }

  // Función para obtener el historial de fallas desde Firestore
  Future<void> fetchFallas() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;

    // Obtener las fallas de la subcolección "fallas" del camión
    QuerySnapshot fallasSnapshot = await db
        .collection('camiones')
        .doc(widget.camionId)
        .collection('fallas')
        .orderBy('tiempo',
            descending: true) // Ordenar por tiempo (más reciente primero)
        .get();

    List<Map<String, dynamic>> fallasList = [];

    for (var doc in fallasSnapshot.docs) {
      fallasList.add({
        'codigo': doc['codigo'],
        'tiempo': doc['tiempo'],
        'resultados': doc['resultados'],
        'accion': doc['accion'],
        'relacion_codigos': doc['relacion_codigos'],
        'solucion': doc['solucion'],
        'mecanico': doc['mecanico'],
        'costo': doc['costo'],
      });
    }

    setState(() {
      fallas = fallasList; // Actualizamos el estado con las fallas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Fallas'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Historial de fallas:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (fallas.isEmpty)
              const Text(
                "No hay fallas registradas.",
                style: TextStyle(color: Colors.grey),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: fallas.length,
                itemBuilder: (context, index) {
                  final falla = fallas[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(falla['codigo']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tiempo: ${falla['tiempo'].toDate()}'),
                          Text('Resultados: ${falla['resultados']}'),
                          Text('Acción: ${falla['accion']}'),
                          Text(
                              'Relación códigos: ${falla['relacion_codigos']}'),
                          Text('Solución: ${falla['solucion']}'),
                          Text('Mecánico: ${falla['mecanico']}'),
                          Text('Costo: ${falla['costo']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
