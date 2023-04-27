class RaiseTicketExpansionModel {
  RaiseTicketExpansionModel({
    required this.title,
    required this.children,
    this.isExpanded = true,
  });
  String title;
  List<String> children = [];
  bool isExpanded;
}
