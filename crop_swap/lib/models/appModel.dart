// Model class for seed listing

class SeedListing {
  final String id;
  final String crop;
  final String quantity;
  final String quality;
  final String location;
  final String distance;
  final String farmer;
  final double rating;
  final String imageEmoji;
  final String wantsInReturn;
  final String postedTime;

  SeedListing({
    required this.id,
    required this.crop,
    required this.quantity,
    required this.quality,
    required this.location,
    required this.distance,
    required this.farmer,
    required this.rating,
    required this.imageEmoji,
    required this.wantsInReturn,
    required this.postedTime,
  });
}

class SeedListingDetails {
  final String id;
  final String crop;
  final String quantity;
  final String quality;
  final String location;
  final String distance;
  final String farmer;
  final double rating;
  final String imageEmoji;
  final String wantsInReturn;
  final String postedTime;
  final bool isOrganic;
  final String? description;
  final int totalSwaps;

  SeedListingDetails({
    required this.id,
    required this.crop,
    required this.quantity,
    required this.quality,
    required this.location,
    required this.distance,
    required this.farmer,
    required this.rating,
    required this.imageEmoji,
    required this.wantsInReturn,
    required this.postedTime,
    this.isOrganic = false,
    this.description,
    this.totalSwaps = 0,
  });
}

// Model class for chat message
class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
  });
}