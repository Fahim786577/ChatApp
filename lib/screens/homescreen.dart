// ignore_for_file: avoid_print

//import 'package:chatapp/helpers.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/theme.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/calls.dart';
import 'package:chatapp/pages/contacts.dart';
import 'package:chatapp/pages/messages.dart';
import 'package:chatapp/pages/notifications.dart';
import 'package:chatapp/app.dart';
import 'package:chatapp/widgets/realavatar.dart' as realavatar;

class HomeScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> titleIndex = ValueNotifier('Messages');

  final pages = const [
    Messages(),
    Notifications(),
    Calls(),
    ContactsPage(),
  ];

  final pageTitle = const [
    'Messages',
    'Notifications',
    'Calls',
    'Contacts'
  ];

  void _itemSelection(index){
        titleIndex.value = pageTitle[index];
        pageIndex.value = index;
        
    }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(valueListenable: titleIndex, builder: (BuildContext context , String value,_){
          return Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light? AppColors.textDark:AppColors.textLight
                )),
          );
        }),
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(icon: Icons.search,onTap: (){
            print('Tapped');
          },),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Hero(
              tag: 'hero-profile-picture',
              child: realavatar.Avatar.small(
                url: context.currentUserImage,
                onTap: () {
                    Navigator.of(context).push(ProfileScreen.route);
                  },
                ),
            ),
            
          )
          ],
      ),
      body: ValueListenableBuilder(valueListenable: pageIndex, builder: (BuildContext context,int value, _){
          return pages[value];
          
      }),
      bottomNavigationBar: _BottomNavigation(
        onItemSelected: _itemSelection,
      ),
    );
  }  
}

//End of HomeScreen widget

class _BottomNavigation extends StatefulWidget {
  const _BottomNavigation({Key? key, required this.onItemSelected}) : super(key: key);
  final ValueChanged<int> onItemSelected;

  @override
  State<_BottomNavigation> createState() => _BottomNavigationState();
}

var selectedIndex = 0;
class _BottomNavigationState extends State<_BottomNavigation> {
  
  void handleItemSelected(int index){
    setState(() {
      selectedIndex = index;
    });
      widget.onItemSelected(index);
  }
 
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Card(
      margin: const EdgeInsets.all(0.0),
      color: (brightness == Brightness.light)?Colors.transparent : null,
      elevation: 0,
      child: SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0,right: 8.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavigationItems(
                  index: 0,
                  label: 'messages',
                  icon: CupertinoIcons.bubble_left_bubble_right_fill,
                  isSelected: (selectedIndex == 0),
                  onTap:  handleItemSelected),
                  
                _NavigationItems(
                  index: 1,
                  label: 'notifications',
                  icon: CupertinoIcons.bell_fill,
                  isSelected: (selectedIndex == 1),
                  onTap:handleItemSelected),
                  Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
                  child: GlowingActionButton(
                    color: AppColors.secondary,
                    icon: CupertinoIcons.add,
                    size: 60,
                    onPressed: () {
                      print('TODO on new message');
                  },
                ),
              ),
                _NavigationItems(
                  index: 2,
                  label: 'calls',
                  icon: CupertinoIcons.phone_fill,
                  isSelected: (selectedIndex == 2),
                  onTap:handleItemSelected),
                _NavigationItems(
                  index: 3,
                  label: 'contacts',
                  icon: CupertinoIcons.person_2_fill,
                  isSelected: (selectedIndex == 3),
                  onTap:handleItemSelected),
    
              ],
            ),
          )
      ),
    );
  }
}

class _NavigationItems extends StatelessWidget {
  const _NavigationItems({Key? key, 
  required this.label,  
  required this.icon,
  required this.index,
  required this.onTap,
  this.isSelected = false,
  }) : super(key: key);
  
  final String label;
  final IconData icon;
  final int index;
  final ValueChanged<int> onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior:HitTestBehavior.opaque ,
      onTap: (){
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.secondary:null,
              ),
              //Text(label,style: const TextStyle(fontSize: 11),)
            ],
          ),
        ),
      ),
    );
  }
}
