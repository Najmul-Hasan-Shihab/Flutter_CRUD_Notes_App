import 'package:flutter/material.dart';
import 'package:flutter_crud_notes_apps/Model/note.dart';
import 'package:intl/intl.dart';

class DisplayNote extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  const DisplayNote({super.key, required this.note, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    DateTime displayTime =
        note.updateAt.isAfter(note.createAt) ? note.updateAt : note.createAt;
    String formattedDateTime =
        DateFormat('h:mma MMMM d, y').format(displayTime);
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(note.color),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 10,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Container(),
                  Spacer(),
                  Text(
                    formattedDateTime,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Flexible(
                  child: Text(
                note.note,
                maxLines: 10,
                style: TextStyle(
                  fontSize: 17,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
