import 'package:blue_filter/infrastructure/models/pages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PageDetailsViewer extends StatelessWidget {
  final Datum pageDetails;

  const PageDetailsViewer({Key? key, required this.pageDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(pageDetails.body);
    return Scaffold(
        appBar: AppBar(
          title: Text(pageDetails.title.toString()),
        ),
        body: _getUI(context));
  }

  Widget _getUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Html(
            data: """<div>
     ${pageDetails.body}
        <!--You can pretty much put any html in here!-->
      </div>""",
          )
        ],
      ),
    );
  }
}
