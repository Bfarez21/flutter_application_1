import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class MaterialDrawer extends StatefulWidget {
  final String currentPage;
  static const Color primaryBlue = Color.fromARGB(255, 10, 3, 64);
  static const Color darkBlue = Color.fromARGB(255, 4, 46, 94);
  static const Color accentBlue = Color(0xFF6BD6FF); // Nuevo color acento
  static const Color lightText = Color(0xFFF0F4F8);  // Color texto claro

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

  double getResponsiveSize(double size, double min, double max) {
    return size.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWeb = screenSize.width > 600;
    final double drawerWidth = isWeb ? 320.0 : screenSize.width * 0.85;
    final double nameFontSize = getResponsiveSize(drawerWidth * 0.05, 16.0, 24.0);
    final double emailFontSize = getResponsiveSize(drawerWidth * 0.035, 14.0, 18.0);
    final double avatarRadius = getResponsiveSize(screenSize.width * 0.1, 30.0, 50.0);

    return Drawer(
      child: Container(
        width: drawerWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MaterialDrawer.darkBlue.withOpacity(0.9),
              MaterialDrawer.primaryBlue.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 16,
              offset: Offset(2, 0),
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 40, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [MaterialDrawer.darkBlue, MaterialDrawer.primaryBlue],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: MaterialDrawer.lightText.withOpacity(0.1),
                    child: ClipOval(
                      child: currentUser?.photoURL != null
                          ? Image.network(currentUser!.photoURL!, fit: BoxFit.cover)
                          : Icon(Icons.person, color: MaterialDrawer.lightText, size: avatarRadius),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    currentUser?.displayName ?? "Usuario",
                    style: TextStyle(
                      fontSize: nameFontSize,
                      color: MaterialDrawer.lightText,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    currentUser?.email ?? "",
                    style: TextStyle(
                      fontSize: emailFontSize,
                      color: MaterialDrawer.lightText.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.home_filled,
                    title: "Inicio",
                    route: '/home',
                    isSelected: widget.currentPage == "Home",
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.history_rounded,
                    title: "Historial",
                    route: '/historial',
                    isSelected: widget.currentPage == "Historial",
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_rounded,
                    title: "Perfil",
                    route: '/profile',
                    isSelected: widget.currentPage == "Perfil",
                  ),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: "Configuraciones",
                    route: '/settings',
                    isSelected: widget.currentPage == "Configuraciones",
                  ),
                  Divider(
                    height: 40,
                    indent: 20,
                    endIndent: 20,
                    color: MaterialDrawer.lightText.withOpacity(0.2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red.withOpacity(0.1),
                      child: InkWell(
                        onTap: () async {
                          try {
                            AuthService authService = AuthService();
                            await authService.handleSignOut();
                            Navigator.pushReplacementNamed(context, '/signin');
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al cerrar sesión'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.logout_rounded, 
                                  color: MaterialDrawer.lightText.withOpacity(0.8)),
                              SizedBox(width: 16),
                              Text(
                                "Cerrar Sesión",
                                style: TextStyle(
                                  color: MaterialDrawer.lightText.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  fontSize: getResponsiveSize(screenSize.width * 0.04, 14.0, 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected 
            ? MaterialDrawer.accentBlue.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            if (widget.currentPage != title) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          hoverColor: MaterialDrawer.lightText.withOpacity(0.05),
          splashColor: MaterialDrawer.lightText.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: MaterialDrawer.accentBlue,
                      width: 2,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected 
                      ? MaterialDrawer.accentBlue
                      : MaterialDrawer.lightText.withOpacity(0.9),
                  size: 24,
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: getResponsiveSize(
                        MediaQuery.of(context).size.width * 0.04, 14.0, 16.0),
                    color: isSelected
                        ? MaterialDrawer.accentBlue
                        : MaterialDrawer.lightText.withOpacity(0.9),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}