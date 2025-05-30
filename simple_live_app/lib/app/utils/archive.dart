import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart';

extension ArchiveExt on Archive {
  addDirectoryToArchive(String dirPath, String parentPath) {
    final dir = Directory(dirPath);
    final entities = dir.listSync(recursive: false);
    for (final entity in entities) {
      final relativePath = relative(entity.path, from: parentPath);
      if (entity is File) {
        final data = entity.readAsBytesSync();
        final archiveFile = ArchiveFile(relativePath, data.length, data);
        addFile(archiveFile);
      } else if (entity is Directory) {
        addDirectoryToArchive(entity.path, parentPath);
      }
    }
  }

  add<T>(String name, T raw) {
    final data = json.encode(raw);
    addFile(
      // 这样会出现问题 不清楚原因
      ArchiveFile(name, data.length, data),
    );
  }
}