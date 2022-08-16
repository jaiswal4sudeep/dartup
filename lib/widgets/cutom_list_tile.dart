import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  final String text;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        text,
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
      ),
    );
  }
}
