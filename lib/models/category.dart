//Buscar as categorias diretamente da API depois
final categories = [
  Category(id: 1, description: "Comportamental"),
  Category(id: 2, description: "Programação"),
  Category(id: 3, description: "Qualidade"),
  Category(id: 4, description: "Processos")
];

class Category {
  int id;
  String description;

  Category({this.id, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() =>
      {'id': this.id, 'description': this.description};

  bool operator ==(dynamic other) =>
      other != null && other is Category && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}

class CategoryModel {
  List<Category> getCategories() => categories;
}
