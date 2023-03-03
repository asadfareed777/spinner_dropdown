
/// This is a model class that will be used for holding dynamic objects
/// like User,Person etc
class SpinnerListItem {
  /// set isSelected to true if you want to display it as selected
  bool? isSelected;
  /// data can been any type of object
  dynamic data;

  SpinnerListItem({
    required this.data,
    this.isSelected = false,
  });
}
