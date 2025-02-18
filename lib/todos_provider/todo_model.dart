class TodoModel {
  final String? title;
  final String? description;
  final int? completed;
  final int? id;

  TodoModel({this.title, this.description, this.completed, this.id});
// Convert a Todo into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Todo{id: $id, title: $title, description: $description}';
  }
}
