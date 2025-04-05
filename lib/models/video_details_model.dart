class VideoDetailsModel {
  final bool ok;
  final int shareid;
  final int uk;
  final String sign;
  final int timestamp;
  final List<FolderItem> list;

  VideoDetailsModel({
    required this.ok,
    required this.shareid,
    required this.uk,
    required this.sign,
    required this.timestamp,
    required this.list,
  });

  factory VideoDetailsModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailsModel(
      ok: json['ok'],
      shareid: json['shareid'],
      uk: json['uk'],
      sign: json['sign'],
      timestamp: json['timestamp'],
      list: (json['list'] as List)
          .map((item) => FolderItem.fromJson(item))
          .toList(),
    );
  }
}

class FolderItem {
  final String category;
  final String fsId;
  final String isDir;
  final String size;
  final String filename;
  final String createTime;
  final List<VideoItem> children;

  FolderItem({
    required this.category,
    required this.fsId,
    required this.isDir,
    required this.size,
    required this.filename,
    required this.createTime,
    required this.children,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) {
    return FolderItem(
      category: json['category'],
      fsId: json['fs_id'],
      isDir: json['is_dir'],
      size: json['size'],
      filename: json['filename'],
      createTime: json['create_time'],
      children: (json['children'] as List)
          .map((child) => VideoItem.fromJson(child))
          .toList(),
    );
  }
}

class VideoItem {
  final int category;
  final int fsId;
  final int isDir;
  final int size;
  final String filename;
  final int createTime;

  VideoItem({
    required this.category,
    required this.fsId,
    required this.isDir,
    required this.size,
    required this.filename,
    required this.createTime,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      category: json['category'],
      fsId: json['fs_id'],
      isDir: json['is_dir'],
      size: json['size'],
      filename: json['filename'],
      createTime: json['create_time'],
    );
  }
}
