import 'package:chat/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer(
      {Key? key,
      required this.pages,
      required this.actions,
      required this.onPageChanged,
      this.currentPage = 0})
      : super(key: key);

  List<Map<String, dynamic>> pages;
  List<Map<String, dynamic>> actions;
  Function(int) onPageChanged;
  int currentPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Row(children: const [Expanded(child: SizedBox())]),
                Text(
                  "MQTT Chat",
                  style: TextStyle(
                      color: AppColors().primary,
                      fontSize: 12,
                      fontFamily: 'Iceberg'),
                ),
                Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: AppColors().primary)),
                  child: Text(
                    'Admin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors().primary,
                        fontSize: 12,
                        fontFamily: 'Iceberg'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 0.59 * MediaQuery.of(context).size.height,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...List.generate(pages.length, (index) {
                  return ListTile(
                    leading: Icon(
                      pages[index]["icon"],
                      color: currentPage == index ? AppColors().primary : null,
                    ),
                    title: Text(
                      pages[index]["label"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            currentPage == index ? FontWeight.bold : null,
                        color:
                            currentPage == index ? AppColors().primary : null,
                      ),
                    ),
                    onTap: () {
                      onPageChanged(index);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          ...List.generate(actions.length, (index) {
            return ListTile(
              leading: Icon(actions[index]["icon"]),
              title: Text(
                actions[index]["label"],
              ),
              onTap: () => actions[index]["onClick"](),
            );
          }),
        ],
      ),
    );
  }
}
