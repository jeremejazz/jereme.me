---
title: "Creating a Custom Map from Images in Flutter: Part 2 - Hosting Custom Maps Offline"
subtitle: ""
slug: custom-image-map-flutter-offline-server
date: 2026-01-13T21:58:28+08:00
lastmod: 2026-01-13T21:58:28+08:00
series: ["Non-Geospatial Maps in Flutter"]
series_order: 2
draft: false
authors: [Jereme]
description: "In this guide, we will build a robust offline mapping solution for Flutter"
summary: "In this guide, we will build a robust offline mapping solution for Flutter"

tags: [flutter, map, cross-platform development]
categories: [tutorials, map development]
posts: []


---

In the previous topic, we managed to create a custom map from a non-geographical image in `flutter_map`. However, this process relies on a running external static server. 

In this guide, we will build a robust offline mapping solution for Flutter. Instead of relying on external tile servers, we will bundle our map tiles into a single ZIP file, extract them on the first run, and spin up a lightweight internal HTTP server to feed the tiles to our map.

> [!info] 
> This is a continuation from the previous topic [Creating a Custom Map from Images in Flutter](/posts/custom-image-map-flutter/). This tutorial assums that you have already setup a custom image in  `flutter_map`. If you need to create the project, feel free to check the post.

## The Tech Stack

- **flutter_map:** The core mapping engine.
- **flutter_map_rastercoords:** Handles coordinate translation (Pixels <-> LatLng) for custom images.
- **shelf & shelf_static:** Runs a pure Dart HTTP server inside your app.    
- **archive:** Handles unzipping the assets.
- **path_provider:** Finds the correct storage location on the device.

## Steps to Implement 

### Step 1: Add Dependencies

Add the following to your `pubspec.yaml`.
```yaml { title="pubspec.yaml" }

dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^8.1.1
  latlong2: ^0.9.1
  flutter_map_rastercoords: ^0.0.1
  provider: ^6.1.5
  shelf: ^1.4.2
  shelf_static: ^1.1.3
  path_provider: ^2.1.5
  archive: ^4.0.7
  
```

### Step 2: Prepare Your Assets

1. Generate your map tiles (using tools like `gdal2tiles` or `maptiler`). You should have a structure like `folder/z/x/y.png`.
2. Zip this folder content into `map.zip`.
    - _Note:_ Ensure the zip structure is flat or you account for the root folder. For this guide, we assume the zip contains the `z` folders at the root.
3. Place `map.zip` in your Flutter project under `assets/`.
4. Update `pubspec.yaml`:

```yaml { title="pubspec.yaml" }
flutter:
  assets:
    - assets/map.zip
```

### Step 3: Create the Map Server Service

This is the brain of our operation. It handles two jobs: **Extraction** and **Serving**.
Create a file named `local_server.dart`.

```dart { title="local_server.dart" lineNos=true }
import 'dart:io';  
import 'package:archive/archive.dart';  
import 'package:flutter/services.dart' show rootBundle;  
import 'package:path_provider/path_provider.dart';  
import 'package:shelf/shelf_io.dart' as shelf_io;  
import 'package:shelf_static/shelf_static.dart';  
  
class LocalServer {  
  
  HttpServer? _server;  
  
  Future<String> start() async {  
    final directory = await getTemporaryDirectory();  
    final webDir = Directory('${directory.path}/http');  
  
    if (!await webDir.exists()) {  
      await webDir.create(recursive: true);  
    }  
  
    final bytes = await rootBundle.load('assets/map.zip');  
  
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());  
  
    for (final file in archive) {  
      final filename = '${webDir.path}/${file.name}';  
      if (file.isFile) {  
        final outFile = File(filename);  
        await outFile.create(recursive: true);  
        await outFile.writeAsBytes(file.content as List<int>);  
      } else {  
        await Directory(filename).create(recursive: true);  
      }  
    }  
  
    final handler = createStaticHandler(webDir.path);  
    _server = await shelf_io.serve(handler, InternetAddress.loopbackIPv4, 0);  
    return 'http://${_server!.address.host}:${_server!.port}';  
  }  
  
  Future<void> dispose() async {  
    await _server?.close(force: true);  
  }  
}

```

### Step 4: Update the Map UI 

In our main  `main.dart` instantiate the local web server we've just created:

```dart { title="main.dart" lineNos=true hl_lines=["7-10", "14", "18", "25-26", "29-35", "52"] }
import 'package:flutter/material.dart';  
import 'package:flutter_map/flutter_map.dart';  
import 'package:flutter_map_rastercoords/flutter_map_rastercoords.dart';  
import 'package:flutter_map_rastercoords_example/local_server.dart';  
  
void main() async {  
  WidgetsFlutterBinding.ensureInitialized();  
  final LocalServer server = LocalServer();  
  final Future<String> urlFuture = server.start();  
  runApp(RasterCoordsDemo(urlFuture: urlFuture));  
}  
  
class RasterCoordsDemo extends StatelessWidget {  
  final Future<String> urlFuture;  
  
  
  final rc = RasterCoords(width: 6143, height: 4600);  
  RasterCoordsDemo({super.key, required this.urlFuture});  
  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      home: Scaffold(  
        appBar: AppBar(title: const Text('Map View')),  
        body: FutureBuilder<String>(  
          future: urlFuture,  
          builder: (context, snapshot) {  
  
            if (snapshot.connectionState == ConnectionState.waiting) {  
              return const Center(child: CircularProgressIndicator());  
            }  
  
            if (snapshot.hasError) {  
              return Center(child: Text("Error: ${snapshot.error}"));  
            }  
  
            return  FlutterMap(  
              options: MapOptions(  
                // Coordinate reference system for non-geographical maps  
                // this also prevents the map from repeating or wrapping.                crs: CrsSimple(),  
                initialZoom: 1,  
                minZoom: 1,  
                // the calculated optimal zoom based on your image dimensions  
                maxZoom: rc.zoom,  
                // set the center by dividing  
                // the height and width of your image by 2                initialCenter: rc.pixelToLatLng(x: rc.width / 2, y: rc.height / 2),  
                cameraConstraint: CameraConstraint.containCenter(  
                  bounds: rc.getMaxBounds(),  
                ),  
              ),  
              children: [  
                TileLayer(urlTemplate: "${Uri.parse(snapshot.data!).toString()}/map/{z}/{x}/{y}.png" ),  
                MarkerLayer(  
                  markers: [  
                    Marker(  
                      // create a marker on the specified pixel coordinates  
                      point: rc.pixelToLatLng(x: 5232, y: 2524),  
                      width: 20,  
                      height: 20,  
                      child: FlutterLogo(),  
                    ),  
                  ],  
                ),  
              ],  
            );  
          }  
        ),  
      ),  
    );  
  }  
}
```

After updating you should be able to run the custom image map locally. 

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1768316061/jereme.me/custom-image-map-flutter-offline-server/Pasted_image_20260113221503.png" alt="Marker on Map" caption="Marker on Map" >}}

> [!IMPORTANT] Important
> Though we are able to solve the issue about running maps offline, there are some issues you still need to consider before implementing this solution:
>- **Storage:** Be mindful of the user's storage. If your unzipped map is 500MB, you are taking up that space permanently in the user's storage.
> - **Cleanup:** In a production app, you might want to add version checking. If you update the app with `tiles_v2.zip`, your `initialize` method should detect the version change, delete the old folder, and unzip the new one.


## Conclusion

In summary, building a locally hosted map in Flutter is a smart way to handle high-resolution, custom imagery without relying on an internet connection. By bundling your tiles in a ZIP file and serving them through a local internal server, you ensure the app remains fast and responsive while keeping the installation size manageable. With the added layer of version control, your app can seamlessly update its map data whenever you release new content, providing a smooth and professional experience for the user. Whether you are building a mall directory, a game world, or an offline site plan, this method gives you full control over your map's performance and coordinate system.

> [!NOTE]
> The sample code used in this tutorial is available at the Github Repository: [Flutter Map RasterCoords demo](https://github.com/jeremejazz/fluttermap_rastercoords_demo/tree/localserver) under the `localserver` branch
