import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Product {
  final String id;
  final String creatorId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // create an instance of the firebase database
    final database = FirebaseDatabase.instance;
    try {
      await database.ref('userFavorites/$uid/').update({id: !isFavorite});
    } catch (error) {
      throw Exception('Unable to switch favorite');
    }
  }
}
