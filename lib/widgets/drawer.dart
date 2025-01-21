import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/auth_service.dart'; // Add this line to import AuthService

class MaterialDrawer extends StatefulWidget {
  final String currentPage;

  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFBBDEFB);

  MaterialDrawer({this.currentPage = ""});

  @override
  _MaterialDrawerState createState() => _MaterialDrawerState();
}

class _MaterialDrawerState extends State<MaterialDrawer> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          currentUser = user;
        });
      }
    });
  }

  // Función para calcular tamaños responsivos con límites
  double getResponsiveSize(double size, double min, double max) {
    return size.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWeb = screenSize.width > 600; // Detectar si es web

    // Calcular tamaños con límites
    final double drawerWidth = isWeb 
        ? 320.0 // Ancho fijo para web
        : screenSize.width * 0.85; // 85% para móvil
    
    final double nameFontSize = getResponsiveSize(
      drawerWidth * 0.05,
      16.0, // mínimo 16px
      24.0  // máximo 24px
    );
    
    final double emailFontSize = getResponsiveSize(
      drawerWidth * 0.035,
      14.0, // mínimo 14px
      18.0  // máximo 18px
    );

    final double avatarRadius = getResponsiveSize(
      screenSize.width * 0.1,
      30.0,  // mínimo 30px
      50.0   // máximo 50px
    );

    return Drawer(
      child: Container(
        width: drawerWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [MaterialDrawer.darkBlue, Colors.white],
            stops: [0.3, 0.3],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: MaterialDrawer.lightBlue,
                      backgroundImage: currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!)
                          : const AssetImage('assets/default_profile.png') as ImageProvider,
                      radius: avatarRadius,
                    ),
                    SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isWeb ? 280 : double.infinity,
                      ),
                      child: Text(
                        currentUser?.displayName ?? "Usuario",
                        style: TextStyle(
                          fontSize: nameFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isWeb ? 280 : double.infinity,
                      ),
                      child: Text(
                        currentUser?.email ?? "",
                        style: TextStyle(
                          fontSize: emailFontSize,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isWeb ? 8 : 4,
                  ),
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.home_rounded,
                      title: "Inicio",
                      route: '/home',
                      isSelected: widget.currentPage == "Home",
                      isWeb: isWeb,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.history_rounded,
                      title: "Historial",
                      route: '/historial',
                      isSelected: widget.currentPage == "Historial",
                      isWeb: isWeb,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.person_rounded,
                      title: "Perfil",
                      route: '/profile',
                      isSelected: widget.currentPage == "Perfil",
                      isWeb: isWeb,
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      title: "Configuraciones",
                      route: '/settings',
                      isSelected: widget.currentPage == "Configuraciones",
                      isWeb: isWeb,
                    ),
                    const Divider(height: 32),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout_rounded,
                      title: "Cerrar Sesión",
                      route: '/signin',
                      isSelected: false,
                      isWeb: isWeb,
                      onTap: () async {
                        try {
                          AuthService authService = AuthService();
                          await authService.handleSignOut();
                          Navigator.pushReplacementNamed(context, '/signin');
                        } catch (error) {
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

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    required bool isWeb,
    VoidCallback? onTap,
  }) {
    final double fontSize = getResponsiveSize(
      MediaQuery.of(context).size.width * 0.04,
      14.0,  // mínimo 14px
      16.0   // máximo 16px
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? MaterialDrawer.lightBlue : Colors.transparent,
      ),
      child: ListTile(
        dense: !isWeb, // Más compacto en móvil
        leading: Icon(
          icon,
          color: isSelected ? MaterialDrawer.darkBlue : MaterialDrawer.primaryBlue,
          size: isWeb ? 24 : 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? MaterialDrawer.darkBlue : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        onTap: onTap ?? () {
          if (widget.currentPage != title) {
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