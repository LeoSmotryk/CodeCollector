import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:file_saver/file_saver.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  runApp(CodeCollectorApp());

  doWhenWindowReady(() {
    final initialSize = Size(700, 600);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "CodeCollector";
    appWindow.show();
  });
}

class CodeCollectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeCollector',
      debugShowCheckedModeBanner: false,
      home: CodeCollectorHomePage(),
    );
  }
}

class CodeCollectorHomePage extends StatefulWidget {
  @override
  _CodeCollectorHomePageState createState() => _CodeCollectorHomePageState();
}

class _CodeCollectorHomePageState extends State<CodeCollectorHomePage> {
  String _output = '';
  final Set<String> _loadedFilePaths = {};

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
    );

    if (result != null) {
      String formattedOutput = '';

      for (var file in result.files) {
        final path = file.path;
        if (path != null && !_loadedFilePaths.contains(path)) {
          try {
            final content = await File(path).readAsString();
            final filename = p.basename(path);
            formattedOutput += '$filename:\n$content\n\n';
            _loadedFilePaths.add(path);
          } catch (_) {}
        }
      }

      setState(() {
        _output += formattedOutput;
      });
    }
  }

  Future<void> addFolder() async {
    String? dirPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder to add',
    );

    if (dirPath != null) {
      final dir = Directory(dirPath);
      final files = dir.listSync(recursive: true).whereType<File>();

      String formattedOutput = '';

      for (var file in files) {
        if (!_loadedFilePaths.contains(file.path)) {
          try {
            final name = p.basename(file.path);
            final content = await file.readAsString();
            formattedOutput += '"$name":\n"$content"\n\n';
            _loadedFilePaths.add(file.path);
          } catch (_) {}
        }
      }

      setState(() {
        _output += formattedOutput;
      });
    }
  }

  Future<void> saveAsFile() async {
    if (_output.isEmpty) return;

    try {
      final bytes = Uint8List.fromList(_output.codeUnits);

      await FileSaver.instance.saveFile(
        name: 'code_output',
        bytes: bytes,
        ext: 'txt',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }

  void clearOutput() {
    setState(() {
      _output = '';
      _loadedFilePaths.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: pickFiles,
                    icon: Icon(Icons.file_copy),
                    label: Text('Select Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: addFolder,
                    icon: Icon(Icons.folder),
                    label: Text('Select Folder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: saveAsFile,
                    icon: Icon(Icons.save),
                    label: Text('Save To Downloads'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: clearOutput,
                    icon: Icon(Icons.delete_outline),
                    label: Text('Clear'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    width: 800,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        _output.isEmpty
                            ? 'No code loaded yet.\n\nUse the buttons above to select files or folders.'
                            : _output,
                        style: TextStyle(fontFamily: 'monospace', fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}