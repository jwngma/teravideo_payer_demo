import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tera_player/screens/link_sample_page.dart';
import 'package:tera_player/utils/tools.dart';
import '../models/video_details_model.dart';
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController urlController = TextEditingController();
  VideoDetailsModel? _videoDetails;
  bool _isLoading = false;
  Set<int> loadingIndexes = {}; // Track loading state for each Play Now button
  String? playableLink;

  void fetchVideoDetails() async {
    final url = urlController.text.trim();
    if (url.isEmpty) {
      Tools.showToasts("URL cannot be empty");
      return;
    }

    setState(() => _isLoading = true);

    final result = await ApiServices.getTeraboxVideoDetails(url);
    if (result != null && result.ok) {
      setState(() => _videoDetails = result);
    } else {
      Tools.showToasts("Failed to fetch video details");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
            Text('Terabox Video Player', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Text("You can get The Links of Video for testing here"),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LinkSamplePage()),
                );
              },
              child: Text(
                "Get The Sample Video Links here",
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(height: 20),
          Text("Enter Your Terabox Video Links"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "This Player can be used to play video from Terabox only, don't use links from other video services",
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Enter Terabox file URL',
                border: OutlineInputBorder(),
                suffixIcon: TextButton(
                  onPressed: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    if (data != null) {
                      urlController.text = data.text ?? '';
                    }
                  },
                  child: Text("Paste"),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : fetchVideoDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 48),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Play', style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 16),
          if (_videoDetails != null && _videoDetails!.list.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _videoDetails!.list[0].children.length,
                itemBuilder: (context, index) {
                  final video = _videoDetails!.list[0].children[index];
                  return Card(
                    color: Colors.orangeAccent,
                    child: ListTile(
                      leading: Icon(Icons.play_circle_outline),
                      title: Text(video.filename),
                      subtitle: Text(
                          '${(video.size / (1024 * 1024)).toStringAsFixed(2)} MB'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: loadingIndexes.contains(index)
                            ? null
                            : () async {
                                setState(() {
                                  loadingIndexes.add(index);
                                });

                                final result =
                                    await ApiServices.getTeraboxVideoDetails(
                                  urlController.text.trim(),
                                );

                                if (result != null && result.ok) {
                                  Tools.showDebugPrint(
                                      'Share ID: ${result.shareid}');
                                  final link =
                                      await ApiServices.getDownloadableLink(
                                    shareId: result.shareid,
                                    uk: result.uk,
                                    sign: result.sign,
                                    timestamp: result.timestamp,
                                    fsId: video.fsId.toInt(),
                                  );

                                  if (link != null) {
                                    setState(() {
                                      playableLink = link;
                                      // TODO: Play the video here.
                                    });
                                    Tools.showDebugPrint(
                                        "Final Video Link: $link");
                                    Tools.showToasts(
                                        "Got The Playable Video Link: $link");
                                  } else {
                                    Tools.showToasts(
                                        "Failed to get download link");
                                  }
                                } else {
                                  Tools.showToasts(
                                      "Failed to fetch video details");
                                }

                                setState(() {
                                  loadingIndexes.remove(index);
                                });
                              },
                        child: loadingIndexes.contains(index)
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Play Now",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      onTap: () {
                        Tools.showToasts("Clicked: ${video.filename}");
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
