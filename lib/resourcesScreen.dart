import 'package:flutter/material.dart';

class ResourceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView(
        children: const [
          ResourceCard(
            title: 'Alzheimer\'s Association',
            description:
            'The Alzheimer\'s Association is a global organization dedicated to providing care and support for those affected by Alzheimer\'s disease and other dementias. They offer resources, support groups, and educational materials for caregivers.',
          ),
          ResourceCard(
            title: 'National Institute on Aging',
            description:
            'The National Institute on Aging (NIA) offers information and resources on aging and age-related diseases, including Alzheimer\'s disease and dementia. Their website provides articles, research updates, and tips for caregivers.',
          ),
          ResourceCard(
            title: 'Caregiver Action Network',
            description:
            'The Caregiver Action Network (CAN) provides education, support, and resources for family caregivers. Their website offers tips for managing caregiving responsibilities, self-care strategies, and links to additional resources.',
          ),
          // Add more resources as needed
        ],
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;

  const ResourceCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
