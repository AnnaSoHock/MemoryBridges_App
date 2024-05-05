import 'package:flutter/material.dart';

class ItemNote extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final VoidCallback onDelete;

  // Define a fixed color for the date widget
  static const Color dateColor = Colors.amber;

  const ItemNote({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox( // Ensure fixed width for date widget
            width: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: dateColor, // Use the fixed color for the date widget
              ),
              child: Column(
                children: [
                  Text(
                    '${_getMonth(date)}', // Extract month from date
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${date.day}', // Extract day from date
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${date.year}', // Extract year from date
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end of the row
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    maxLines: 2, // Truncate to 2 lines
                    overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Function to get the month abbreviation from a DateTime object
  String _getMonth(DateTime date) {
    final monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return monthNames[date.month - 1];
  }
}
