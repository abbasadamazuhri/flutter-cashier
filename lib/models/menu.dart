class Menu {
  final int id;
  final String title;
  final String description;
  final int price;
  final int createdAt;
  Menu({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.createdAt,
  });
  factory Menu.fromJson(Map<String, dynamic> data) => Menu(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        price: data['price'],
        createdAt: data['createdAt'],
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'createdAt': createdAt
      };
}
