import 'package:flutter/material.dart';

class ListCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const ListCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 5,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        leading: Icon(widget.icon),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey),
        tileColor: Colors.white,
      ),
    );
  }
}
