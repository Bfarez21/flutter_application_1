import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';

// Widgets personalizados
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Ajustes",
      ),
      drawer: MaterialDrawer(currentPage: "Settings"),
      backgroundColor: MaterialColors.bgColorScreen,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección Cuenta
              _buildSectionHeader("Cuenta"),
              _buildMenuItem(Icons.person, "Editar perfil", onTap: () {
                // Acción para Editar perfil
              }),
              _buildMenuItem(Icons.notifications, "Notificaciones", onTap: () {
                // Acción para Notificaciones
              }),
              SizedBox(height: 16.0),

              // Sección Acerca de
              _buildSectionHeader("Acerca de"),
              _buildMenuItem(Icons.credit_card, "Mi suscripción", onTap: () {
                // Acción para Mi suscripción
              }),
              _buildMenuItem(Icons.help, "Ayuda y Soporte", onTap: () {
                // Acción para Ayuda y Soporte
              }),
              _buildMenuItem(Icons.info, "Políticas", onTap: () {
                // Acción para Políticas
              }),
              SizedBox(height: 16.0),

              // Sección Actions
              _buildSectionHeader("Actions"),
              _buildMenuItem(Icons.flag, "Reportar un problema", onTap: () {
                // Acción para Reportar un problema
              }),
              _buildMenuItem(Icons.logout, "Log out", onTap: () {
                // Acción para Log out
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
      onTap: onTap,
    );
  }
}
