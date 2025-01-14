import 'package:flutter/material.dart';
import 'app_colors.dart';

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
        preferredSize: Size.fromHeight(80), // Altura personalizada
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBarColor, // Color del fondo
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // Sombra sutil
                offset: Offset(0, 3),
                blurRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.vertical(
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
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Fondo temporal para el logo
                      ),
                      child: Icon(
                        Icons.directions_bus, // Ícono representativo
                        color: AppColors.backgroundColor,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),

                // Texto centrado
                Expanded(
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
                      PopupMenuItem<String>(
                        value: 'configuracion',
                        child: Text('Configuración'),
                      ),
                      PopupMenuItem<String>(
                        value: 'ajustes',
                        child: Text('Ajustes'),
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white, // Ícono de menú
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ViajesApp(), // Ahora, este es el cuerpo del Scaffold
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedViaje,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Empresa cliente"),
                  SizedBox(height: 16),
                  Text("Estado: Normal"),
                  SizedBox(height: 16),
                  Text("Operador(es):"),
                  SizedBox(height: 16),
                  Text("Horarios:"),
                  SizedBox(height: 16),
                  Text("Ubicaciones:"),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para ver detalles
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
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
