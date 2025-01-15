import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'detalles.dart';

void main() {
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
  String selectedViaje = "TLX - MTY"; // Inicializar con un viaje seleccionado

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          // Sección de "Viajes activos"
          Container(
            width: MediaQuery.of(context).size.width *
                0.3, // 30% del ancho de la pantalla
            color: Colors.grey[100], // Fondo claro
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
                  child: ListView(
                    children: [
                      viajeItem("TLX - MTY", "Empresa cliente"),
                      viajeItem("TLX - GDL", "Empresa cliente"),
                      viajeItem("TLX - CDMX", "Empresa cliente"),
                      viajeItem("TLX - CUN", "Empresa cliente"),
                      viajeItem("TLX - VER", "Empresa cliente"),
                      // Agregar más viajes si es necesario
                    ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedViaje,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Empresa cliente"),
                  const SizedBox(height: 16),
                  const Text("Estado: Normal"),
                  const SizedBox(height: 16),
                  const Text("Operador(es):"),
                  const SizedBox(height: 16),
                  const Text("Horarios:"),
                  const SizedBox(height: 16),
                  const Text("Ubicaciones:"),
                  const SizedBox(height: 16),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetallesPage()),
                        ); // Acción para ver detalles
                      },
                      child: Text("Ver detalles"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada viaje activo
  Widget viajeItem(String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedViaje = title; // Actualizar el viaje seleccionado
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedViaje == title ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Botón de gestión
  Widget _gestionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class GestionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Espacio inferior
      child: Container(
        color: Colors.blue[100], // Fondo blanco para un diseño más limpio
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sección de gestión",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        0, // Por ahora la lista está vacía
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text("Elemento $index"),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Actualmente no hay camiones en la lista.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.directions_car, color: Colors.white),
                    label: const Text(
                      "Camiones",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 32),
                      minimumSize: const Size(150, 50),
                    ),
                  ),
                  const SizedBox(width: 16), // Separación entre botones
                  ElevatedButton.icon(
                    onPressed: () {
                      // Acción para el botón
                    },
                    icon: const Icon(Icons.person, color: Colors.white),
                    label: const Text(
                      "Operadores",
                      style: TextStyle(color: Colors.white),
                    ),
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
