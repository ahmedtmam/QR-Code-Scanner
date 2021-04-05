import 'dart:io';

var modelName = 'Employee';
var attr = 'id, email, displayName';
var array = attr.split(',').map((e) => e.trim()).toList();
var fromDoc = true;
var fromMap = false;
var toMap = true;
var toString = false;
StringBuffer buffer = StringBuffer();

main() {
  if (fromDoc) printFromDocument();
  print('');
  if (fromMap) printFromMap();
  print('');
  if (toMap) printToMap();
  print('');
  if (toString) printToString();
  print('');
  appendToFile(buffer.toString());
}

void appendToFile(String content) {
  var model = File('bin/model.txt');
  model.writeAsString(content);
}

void printToString() {
  buffer.writeln('''  @override
  String toString() {
    return jsonEncode(toMap());
  }''');
}

void printToMap() {
  buffer.writeln('toMap() => {');
  array.forEach((element) {
    buffer.writeln('\'$element\' : this.$element,');
  });
  buffer.writeln('};');
}

void printFromMap() {
  buffer.writeln('$modelName.fromMap(Map<String, dynamic> map) {');
  array.forEach((element) {
    buffer.writeln('this.$element = map[\'$element\'];');
  });
  buffer.writeln('}');
}

void printFromDocument() {
  buffer.writeln('$modelName.fromDocumentSnapshot(DocumentSnapshot doc){');
  buffer.writeln('this.${array[0]} = doc.id;');
  buffer.writeln('var map = doc.data();');
  for (var i = 1; i < array.length; i++) {
    buffer.writeln('this.${array[i]} = map[\'${array[i]}\'];');
  }
  buffer.writeln('}');
}
