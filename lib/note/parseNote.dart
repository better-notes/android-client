String parseNote(String content) {
  return content.trim();
}

List<Map<String, dynamic>> getNoteTags(String content) {
  RegExp exp = new RegExp(r"#[a-zA-Z0-9а-яА-Я]+");
  var matches = [];
  exp.allMatches(content).forEach((match) {
    matches.add(match.group(0));
  });
  var tags = matches.map((e) {
    e.trim();
    e.replaceAll(new RegExp(r'[,.`~!:;\n\[\]\{\}\?<>]+'), '');
    return e;
  }).where((e) => e.length > 1);
  return tags.map((e) => {'name': e.substring(1)}).toList();
}
