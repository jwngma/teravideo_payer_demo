import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkSamplePage extends StatefulWidget {
  const LinkSamplePage({super.key});

  @override
  State<LinkSamplePage> createState() => _LinkSamplePageState();
}

class _LinkSamplePageState extends State<LinkSamplePage> {
  final List<String> dataList = [
    "https://teraboxapp.com/s/1BHMxtOF-G7fvMlse4Ejs1Q",
    "https://terafileshare.com/s/1wXLHVGyQ9f03L3aYW6VZ5Q",
    "https://terabox.com/s/1V4hRAWz2Gzj5wW2XUtrRbw",
    "https://terabox.com/s/13jHU-D3MFFvPYe7NB4_SuQ",
    "https://terabox.com/s/1bUsnWbYZksl9DS5R4smQ2Q",
    "https://terabox.com/s/17w88mzb6a7u0CPrdpztZTg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Page"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.orange,
            child: ListTile(
              title: Text("Item ${index + 1}: ${dataList[index]}"),
              trailing: ElevatedButton(
                child: Text("Copy"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: dataList[index]));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Copied to Clipboard")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
