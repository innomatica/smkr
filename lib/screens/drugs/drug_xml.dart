import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class DrugXml extends StatelessWidget {
  final String xml;
  const DrugXml({required this.xml, super.key});

  @override
  Widget build(BuildContext context) {
    final document = XmlDocument.parse(xml);
    final doc = document.rootElement;
    final title = doc.getAttribute('title');
    final section = doc.firstElementChild;
    final articles = section?.childElements.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: ListView.builder(
        itemCount: articles?.length,
        itemBuilder: (context, index) {
          final article = articles?[index];
          final paragraphs = article?.childElements.toList();

          return ListTile(
            onTap: () {},
            title: Text(article?.getAttribute('title') ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                )),
            subtitle: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: paragraphs?.length,
              itemBuilder: (context, index) {
                final paragraph = paragraphs?[index];
                return ListTile(
                  onTap: () {},
                  title: Text((paragraph?.value ?? '')
                      .replaceAll('&lt;', '<')
                      .replaceAll(RegExp(r'<(.*?)>', unicode: true), '')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
