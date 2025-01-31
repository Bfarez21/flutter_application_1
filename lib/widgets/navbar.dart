import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Category.dart';

//import 'package:flutter_application_1/constants/Theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:material_kit_flutter/screens/categories.dart';
// import 'package:material_kit_flutter/screens/best-deals.dart';
// import 'package:material_kit_flutter/screens/search.dart';
// import 'package:material_kit_flutter/screens/cart.dart';
// import 'package:material_kit_flutter/screens/chat.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String categoryOne;
  final String categoryTwo;
  final bool searchBar;
  final bool backButton;
  final bool transparent;
  final bool rightOptions;
  final List<String>? tags;
  final Function(String)? getCurrentPage;
  final bool isOnSearch;
  final TextEditingController? searchController;
  final Function(String)? searchOnChanged;
  final bool searchAutofocus;
  final bool noShadow;
  final Color bgColor;

  Navbar({
    this.title = "Home",
    this.categoryOne = "",
    this.categoryTwo = "",
    this.tags,
    this.transparent = false,
    this.rightOptions = true,
    this.getCurrentPage,
    this.searchController,
    this.isOnSearch = false,
    this.searchOnChanged,
    this.searchAutofocus = false,
    this.backButton = false,
    this.noShadow = false,
    this.bgColor = Colors.blue,
    this.searchBar = false,
  });

  final double _preferredHeight = 180.0;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

class _NavbarState extends State<Navbar> {
  late String activeTag;
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.tags != null && widget.tags!.isNotEmpty) {
      activeTag = widget.tags!.first;
    } else {
      activeTag = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool categories =
        widget.categoryOne.isNotEmpty && widget.categoryTwo.isNotEmpty;
    final bool tagsExist = widget.tags != null && widget.tags!.isNotEmpty;

    return Container(
      height: widget.searchBar
          ? (!categories
              ? (tagsExist ? 160 : 130.0)
              : (tagsExist ? 200.0 : 170.0))
          : (!categories
              ? (tagsExist ? 100.0 : 80.0)
              : (tagsExist ? 150.0 : 120.0)),
      decoration: BoxDecoration(
        color: !widget.transparent ? widget.bgColor : Colors.transparent,
        boxShadow: [
          if (!widget.transparent && !widget.noShadow)
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              spreadRadius: -10,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.backButton ? Icons.arrow_back_ios : Icons.menu,
                          color: !widget.transparent
                              ? (widget.bgColor == Colors.white
                                  ? Colors.black
                                  : Colors.white)
                              : Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          if (widget.backButton) {
                            Navigator.pop(context);
                          } else {
                            Scaffold.of(context).openDrawer();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: !widget.transparent
                                ? (widget.bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white)
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.rightOptions)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            color: !widget.transparent
                                ? (widget.bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white)
                                : Colors.white,
                            size: 22.0,
                          ),
                          onPressed: () {},
                        ),
                        //agregar flutter ruta de para conectar la base
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.gamepad,
                            color: !widget.transparent
                                ? (widget.bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white)
                                : Colors.white,
                            size: 22.0,
                          ),
                          // redirigo a otra ventana
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.shapes, // Icono para categorías
                            color: !widget.transparent
                                ? (widget.bgColor == Colors.white
                                    ? Colors.black
                                    : Colors.white)
                                : Colors.white,
                            size: 22.0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/categories'); // Usa la ruta nombrada
                          },
                        ),
                      ],
                    )
                ],
              ),
              if (widget.searchBar)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.0),
                  child: TextField(
                    controller: widget.searchController,
                    onChanged: widget.searchOnChanged,
                    autofocus: widget.searchAutofocus,
                    decoration: InputDecoration(
                      hintText: "What are you looking for?",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              if (categories)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.border_all,
                              color: Colors.black87, size: 22.0),
                          const SizedBox(width: 10),
                          Text(widget.categoryOne,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 16.0)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      color: Colors.grey,
                      height: 25,
                      width: 0.3,
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.camera_enhance,
                              color: Colors.black87, size: 22.0),
                          const SizedBox(width: 10),
                          Text(widget.categoryTwo,
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 16.0)),
                        ],
                      ),
                    )
                  ],
                ),
              if (tagsExist)
                SizedBox(
                  height: 40,
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.tags!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (activeTag != widget.tags![index]) {
                            setState(() => activeTag = widget.tags![index]);
                            _scrollController.scrollTo(
                              index: index,
                              duration: const Duration(milliseconds: 420),
                              curve: Curves.easeIn,
                            );
                            widget.getCurrentPage?.call(activeTag);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 46 : 8,
                            right: 8,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2.0,
                                color: activeTag == widget.tags![index]
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.tags![index],
                              style: TextStyle(
                                color: activeTag == widget.tags![index]
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
