import 'package:flutter/material.dart';
import 'package:my_chat/core/theme/save_theme.dart';
import 'package:provider/provider.dart';

class ChatW extends StatefulWidget {
  const ChatW({super.key});

  @override
  State<ChatW> createState() => _ChatWState();
}

class _ChatWState extends State<ChatW> with SingleTickerProviderStateMixin {
  // late TabController controller;
  // @override
  // void initState() {
  //   controller = TabController(length: 4, vsync: this);

  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode(context);
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              // title: Text(
              //   'الدردشة',
              //   style: Theme.of(context).textTheme.displayLarge,
              // ),
              expandedHeight: 200,
              bottom: TabBar(
                // controller: controller,
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                tabs: [
                  Tab(
                    text: 'الدردشات',
                    icon: Icon(
                      Icons.chat,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Tab(
                    text: 'المجموعات',
                    icon: Icon(
                      Icons.group,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Tab(
                    text: 'القنوات',
                    icon: Icon(
                      Icons.broadcast_on_home,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Tab(
                    text: 'القنوات',
                    icon: Icon(
                      Icons.broadcast_on_home,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'assets/images/telegram.png',
                  fit: BoxFit.cover,
                ),
                collapseMode: CollapseMode.pin,
                // title: Text(
                //   'الدردشة',
                //   style: Theme.of(
                //     context,
                //   ).textTheme.headlineMedium!.copyWith(color: Colors.white),
                // ),
                // centerTitle: true,
              ),

              floating: true,
              snap: true,
              actions: [
                IconButton(icon: Icon(Icons.search), onPressed: () {}),
                IconButton(icon: Icon(Icons.settings), onPressed: () {}),
                Switch(
                  value: isDark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ],
            ),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate((context, index) {
            //     return ListTile(
            //       leading: CircleAvatar(child: Text('U$index')),
            //       title: Text('User $index'),
            //       subtitle: Text('Last message from User $index'),
            //     );
            //   }, childCount: 20),
            // ),
          ];
        },
        body: TabBarView(
          // controller: controller,
          children: [
            chatWidget(),
            Center(child: Text('Groups Content')),
            Center(child: Text('Channels Content')),
            Center(child: Text('Channels Content')),
          ],
        ),
      ),
    );
  }

  ListView chatWidget() {
    return ListView.builder(
      itemCount: 20, // childCount becomes itemCount
      itemBuilder: (context, index) {
        // delegate becomes itemBuilder
        return ListTile(
          leading: CircleAvatar(child: Text('U$index')),
          title: Text('User $index'),
          subtitle: Text('Last message from User $index'),
        );
      },
    );
  }
}
