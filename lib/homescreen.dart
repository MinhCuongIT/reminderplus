import 'package:flutter/material.dart';
import 'package:reminder_plus/add_reminder_page.dart';
import 'package:reminder_plus/settings_page.dart';
import 'package:reminder_plus/database/model/reminder.dart';
import 'package:reminder_plus/home_presenter.dart';
import 'package:reminder_plus/list.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements HomeContract {
  HomePresenter homePresenter;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    homePresenter = new HomePresenter(this);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS;

    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  /* List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: () => AddReminderPage().buildAboutDialog(context, this, false, null),
      ),
    ];
  }*/

  showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              // physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Categories",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  subtitle: Text(
                    "Coming Soon",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: Icon(OMIcons.folderSpecial, color: Colors.pink),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Completed",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  subtitle: Text(
                    "Coming Soon",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: Icon(OMIcons.doneAll, color: Colors.pink),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  subtitle: Text(
                    "Coming Soon",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: Icon(OMIcons.accountCircle, color: Colors.pink),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Help",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  subtitle: Text(
                    "Coming Soon",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: Icon(Icons.help_outline, color: Colors.pink),
                  onTap: () {},
                ),
                ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  subtitle: Text(
                    "Coming Soon",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  leading: Icon(OMIcons.settings, color: Colors.pink),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Reminder+', style: TextStyle(color: Colors.grey[700])),
        // actions: _buildActions(),
        backgroundColor: Colors.white,
      ),
      body: new FutureBuilder<List<Reminder>>(
        future: homePresenter.getReminder(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? new ReminderList(data, homePresenter)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddReminderPage(false, null),
          ),
        ),
        tooltip: 'New Reminder',
        icon: Icon(Icons.add),
        label: const Text('Add Reminder'),
        elevation: 2,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
              child: IconButton(
                  onPressed: showMenu,
                  icon: Icon(Icons.menu),
                  color: Colors.grey[700]),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 5, bottom: 5),
              child: IconButton(
                icon: Icon(OMIcons.folderSpecial),
                color: Colors.grey[700],
                onPressed: () {
                  _showFeatureDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Feature Coming Soon'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This feature will be here in the near future.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void screenUpdate() {
    setState(() {});
  }
}
