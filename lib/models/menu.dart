class MenuColumn {
  static final List<String> values = [id, title, description];

  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
}

class Menu {
  late String id;
  late String title;
  late String description;

  Menu({required this.id, required this.title, required this.description});

  Menu.fromMap(Map<String, dynamic> item)
      : id = item[MenuColumn.id],
        title = item[MenuColumn.title],
        description = item[MenuColumn.description];

  Map<String, Object> toMap() {
    return {
      MenuColumn.id: id,
      MenuColumn.title: title,
      MenuColumn.description: description,
    };
  }
}
