import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _authService = AuthService();
  String _userName = "Cargando...";
  String? _userEmail;
  String? _userImage;

  final List<Map<String, String>> youtubeLinks = [
    {"title": "Saludos y formalidades", "url": "https://www.youtube.com/watch?v=rpfm69CaPWo"},
    {
      "title": "Números naturales del 1-100",
      "url": "https://www.youtube.com/watch?v=gNNp3lXgxic&t=49s"
    },
    {"title": "Diás de la semana", "url": "https://www.youtube.com/watch?v=j-u5Ij9f5kI"},
    {"title": "Mitos y verdades / sordos", "url": "https://www.youtube.com/watch?v=RkEEzo3WGlE"},
    {"title": "Emociones 😍😟😠😀", "url": "https://www.youtube.com/watch?v=r6hRcL6bGZo"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final userInfo = await _authService.getUserInfo();
    if (mounted) {
      setState(() {
        _userName = userInfo?['nombre'] ?? "YOUR NAME";
        _userEmail = userInfo?['correo'] ?? "YourName@gmail.com";
        _userImage = userInfo?['foto'];
      });
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      )) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No se pudo abrir el enlace")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Navbar(
        title: "Perfil",
        transparent: true,
      ),
      drawer: MaterialDrawer(currentPage: "Profile"),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoLogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Parte superior con información del perfil
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                _userImage != null && _userImage!.isNotEmpty
                                    ? CachedNetworkImageProvider(_userImage!)
                                    : const AssetImage(
                                            'assets/img/default_profile.png')
                                        as ImageProvider,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF30A9B9),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _userEmail ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Parte inferior con botones
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Text(
                          "Sigue aprendiendo con estos videos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 12, 12, 12),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    // Espacio para los botones de YouTube
                    const SizedBox(height: 50),
                    Expanded(
                      child: ListView.builder(
                        itemCount: youtubeLinks.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ElevatedButton(
                              onPressed: () =>
                                  _launchURL(youtubeLinks[index]['url']!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 21, 83, 134),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                youtubeLinks[index]['title']!,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
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
}
