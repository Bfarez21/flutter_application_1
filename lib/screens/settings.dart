import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';

// Widgets personalizados
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/table-cell.dart';
import 'package:flutter_application_1/widgets/drawer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool useCamera = true;
  bool enableNotifications = true;
  bool saveTranslations = false;

  @override
  void initState() {
    super.initState();
    useCamera = true;
    enableNotifications = true;
    saveTranslations = false;
  }

  Widget _buildSectionTitle(String title, {double topPadding = 16.0}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          subtitle,
          style: TextStyle(color: MaterialColors.caption, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.black)),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: MaterialColors.primary,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Configuración",
      ),
      drawer: MaterialDrawer(currentPage: "Settings"),
      backgroundColor: MaterialColors.bgColorScreen,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Column(
            children: [
              _buildSectionTitle("Configuración General"),
              _buildSectionSubtitle("Ajusta las preferencias generales de la aplicación"),
              _buildSwitchRow(
                "Habilitar Cámara para Traducción de Gestos",
                useCamera,
                (newValue) => setState(() => useCamera = newValue),
              ),
              _buildSwitchRow(
                "Habilitar Notificaciones",
                enableNotifications,
                (newValue) => setState(() => enableNotifications = newValue),
              ),
              _buildSwitchRow(
                "Guardar Traducciones en el Historial",
                saveTranslations,
                (newValue) => setState(() => saveTranslations = newValue),
              ),
              SizedBox(height: 36.0),
              _buildSectionTitle("Configuración de Traducción"),
              _buildSectionSubtitle("Gestiona tus opciones de traducción"),
              TableCellSettings(
                title: "Preferencias de Idioma",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/language-settings');
                },
              ),
              TableCellSettings(
                title: "Opciones de Entrada de Audio",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/audio-settings');
                },
              ),
              SizedBox(height: 36.0),
              _buildSectionTitle("Configuración Avanzada"),
              _buildSectionSubtitle("Personaliza características avanzadas"),
              TableCellSettings(
                title: "Gestionar Permisos de la Cámara",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/camera-permissions');
                },
              ),
              TableCellSettings(
                title: "Privacidad y Uso de Datos",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/privacy');
                },
              ),
              TableCellSettings(
                title: "Acerca de Esta Aplicación",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/about');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
