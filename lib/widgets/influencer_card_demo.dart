import 'package:flutter/material.dart';
import 'package:inovant/screens/influencer_detail.dart';
import '../models/influencer.dart';

class InfluencerCard extends StatelessWidget {
  final Influencer influencer;

  const InfluencerCard({super.key, required this.influencer});

  Color _genderColor(String gender) {
    switch (gender.toUpperCase()) {
      case "M":
        return Colors.blue;
      case "F":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: influencer.image.isNotEmpty
              ? NetworkImage(influencer.image)
              : null,
          radius: 28,
          child: influencer.image.isEmpty
              ? const Icon(Icons.person, size: 28)
              : null,
        ),
        title: Text(
          influencer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.circle,
              size: 12,
              color: _genderColor(influencer.gender),
            ),
            const SizedBox(width: 6),
            Text(influencer.gender == "M" ? "Male" : "Female"),
          ],
        ),
        trailing: Icon(
          influencer.isInWishlist == 1 ? Icons.favorite : Icons.favorite_border,
          color: influencer.isInWishlist == 1 ? Colors.red : Colors.grey,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return InfluencerDetailPage(influencerId: influencer.id);
              },
            ),
          );
        },
      ),
    );
  }
}
