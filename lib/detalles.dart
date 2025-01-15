import 'package:flutter/material.dart';

class DetallesPage extends StatelessWidget {
  const DetallesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Especificaciones del Viaje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Operador:'),
                      const SizedBox(height: 10),
                      _buildTextField('Autobús:'),
                      const SizedBox(height: 10),
                      _buildTextField('Ruta:'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('lib/assets/chofer.jpg'),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField('Hora de salida:'),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.map, size: 40),
                        onPressed: () {
                          // Acción para mostrar mapa
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Fallas detectadas:'),
            _buildTextField(''),
            const SizedBox(height: 10),
            _buildTextField('Códigos de falla:'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
