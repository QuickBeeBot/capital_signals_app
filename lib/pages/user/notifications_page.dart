import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/z_card.dart';

import '../../models_providers/app_provider.dart';
import '../../utils/z_format.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final notifications = appProvider.notifications;

    return Scaffold(
      appBar: AppBar(title: Text('Alerts')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: ((context, index) => Column(
              children: [
                ZCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      Text(
                        '${ZFormat.dateFormatSignal(notifications[index].timestampCreated)}',
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(notifications[index].title),
                      Text(notifications[index].body),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
