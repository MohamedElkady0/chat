import 'package:flutter/material.dart';

class Enjoyment extends StatelessWidget {
  const Enjoyment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(expandedHeight: 250),
            pinned: true,
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(title: Text('Item #$index')),
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    const size = 60;
    final top = expandedHeight - shrinkOffset - size / 2;
    final appearOpacity = shrinkOffset / expandedHeight;
    final disappearOpacity = 1 - appearOpacity;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: disappearOpacity,
          child: Image.asset('assets/images/house.png', fit: BoxFit.cover),
        ),

        Opacity(
          opacity: appearOpacity,
          child: AppBar(
            title: const Text(
              'Enjoyment',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
          ),
        ),

        Positioned(
          top: top,
          left: 20,
          right: 20,
          child: Opacity(
            opacity: disappearOpacity,
            child: Card(
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.group),
                    label: const Text('Groups'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(CustomSliverAppBarDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight;
  }
}
