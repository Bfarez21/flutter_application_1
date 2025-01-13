import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Definición de la clase principal como StatelessWidget
class MaterialDrawer extends StatelessWidget {
  // Propiedades de la clase
  final String currentPage;            // Página actual para resaltar en el menú
  final GoogleSignInAccount? user;     // Datos del usuario de Google
  
  // Colores personalizados para toda la aplicación
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFBBDEFB);

  // Constructor de la clase
  MaterialDrawer({this.currentPage = "", this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // Decoración con gradiente para el fondo del drawer
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkBlue, Colors.white],
            stops: [0.3, 0.3],
          ),
        ),
        child: Column(
          children: [
            // SECCIÓN 1: HEADER DEL USUARIO
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              // Widget para la foto de perfil
              currentAccountPicture: CircleAvatar(
                backgroundColor: lightBlue,
                // Manejo condicional de la imagen de perfil
                backgroundImage: user?.photoUrl != null
                    ? NetworkImage(user!.photoUrl!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
                radius: 50,
              ),
              // Nombre del usuario desde Google Sign In
              accountName: Text(
                user?.displayName ?? "Usuario",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Email del usuario desde Google Sign In
              accountEmail: Text(
                user?.email ?? "",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            
            // SECCIÓN 2: MENÚ DE OPCIONES
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  children: [
                    // Opción de Inicio
                    _buildMenuItem(
                      context: context,
                      icon: Icons.home_rounded,
                      title: "Inicio",
                      route: '/home',
                      isSelected: currentPage == "Home",
                    ),
                    
                    // Opción de Historial
                    _buildMenuItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: "Historial",
                      route: '/historial',
                      isSelected: currentPage == "Historial",
                    ),
                    
                    // Opción de Perfil
                    _buildMenuItem(
                      context: context,
                      icon: Icons.person_rounded,
                      title: "Perfil",
                      route: '/profile',
                      isSelected: currentPage == "Perfil",
                    ),

                    // Opción de Configuraciones (Nueva)
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: "Configuraciones",
                      route: '/settings',
                      isSelected: currentPage == "Configuraciones",
                    ),

                    // Separador antes de las opciones de cierre
                    const Divider(height: 32),

                    // Opción de Cerrar Sesión
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout_rounded,
                      title: "Cerrar Sesión",
                      route: '/signin',
                      isSelected: false,
                      // IMPORTANTE: Esta es la función de cierre de sesión
                      onTap: () async {
                        try {
                          // 1. Cierra la sesión de Google
                          await GoogleSignIn().signOut();
                          // 2. Redirecciona a la página de inicio de sesión
                          Navigator.pushReplacementNamed(context, '/signin');
                        } catch (error) {
                          // 3. Maneja cualquier error durante el cierre de sesión
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al cerrar sesión'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FUNCIÓN AUXILIAR: Constructor de elementos del menú
  Widget _buildMenuItem({
    required BuildContext context,     // Contexto de la aplicación
    required IconData icon,            // Ícono a mostrar
    required String title,             // Título del elemento
    required String route,             // Ruta de navegación
    required bool isSelected,          // Estado de selección
    VoidCallback? onTap,              // Función opcional al tocar
  }) {
    return Container(
      // Estilo del contenedor del ítem
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? lightBlue : Colors.transparent,
      ),
      child: ListTile(
        // Ícono del elemento
        leading: Icon(
          icon,
          color: isSelected ? darkBlue : primaryBlue,
          size: 24,
        ),
        // Texto del elemento
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? darkBlue : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        // Manejo del tap: usa onTap personalizado o navegación por defecto
        onTap: onTap ?? () {
          if (currentPage != title) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}