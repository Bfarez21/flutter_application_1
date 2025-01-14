import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/widgets/photo-album.dart';
import 'package:flutter_application_1/services/auth_service.dart'; // Importa tu AuthService

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _authService = AuthService();
  String _userName = "Cargando...";
  String? _userImage;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final userInfo = _authService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        _userName = userInfo['nombre'] ?? "Nombre desconocido";
        _userImage = userInfo['foto']; // URL de la foto del perfil
      });
    } else {
      setState(() {
        _userName = "Usuario no autenticado";
        _userImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Navbar(
        title: "Profile",
        transparent: true,
      ),
      backgroundColor: MaterialColors.bgColorScreen,
      drawer: MaterialDrawer(currentPage: "Profile"),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: _userImage != null && _userImage!.isNotEmpty
                    ? NetworkImage(_userImage!)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.45,
            ),
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen del usuario con validación
                if (_userImage != null && _userImage!.isNotEmpty)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_userImage!),
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        _userImage = null; // Imagen inválida
                      });
                    },
                  )
                else
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
                  ),
                SizedBox(width: 16),
                // Ajuste del nombre con Flexible
                Flexible(
                  child: Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis, // Maneja texto largo
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13.0),
                  topRight: Radius.circular(13.0),
                ),
              ),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.58,
              ),
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("25",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Text("Traducciones",
                                style: TextStyle(color: MaterialColors.muted)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("2",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Text("Idiomas",
                                style: TextStyle(color: MaterialColors.muted)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.pin_drop, color: MaterialColors.muted),
                            SizedBox(height: 6),
                            Text("Estadísticas",
                                style: TextStyle(color: MaterialColors.muted)),
                          ],
                        ),
                      ],
                    ),
                    PhotoAlbum(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
