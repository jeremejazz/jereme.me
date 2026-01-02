---
title: Creating a Custom Map from Images in Flutter
subtitle: Build a non-geographical map application from images generated with gdal2tiles and Flutter
date: 2025-05-29T14:10:09+08:00
slug: custom-image-map-flutter
draft: false
description: Build a non-geographical map application from images generated with gdal2tiles and Flutter
tags:
 - flutter
 - map
 - leaflet
license: <a rel="license external nofollow noopener noreferrer" href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">CC BY-NC-SA 4.0</a>
comment: true
collections:
  - map development
categories:
  - tutorials
  - map development
summary:
resources:
  - name: featured-image
    src: images/flutter-in-space-cover.png
  - name: featured-image-preview
    src: images/flutter-in-space-cover-preview.jpg
toc: true
math: false
lightgallery: true
password:
message:
repost:
  enable: false
  url:

---
Ever wanted to build your custom cross-platform map applications without relying on traditional geographic data?

<!--more-->

In this guide, we'll be creating a custom map using a large image in [Flutter](https://flutter.dev/), an open-source development kit for creating cross-platform applications. Instead of using geographical map sources, we'll be using our own images to create non-geographical maps. Using the same technique from the [previous topic](/post/custom-image-map-leaflet/),  we'll be able to create custom maps that support other platforms. 

This opens up possibilities for mobile apps, interactive desktop tools, and even embedded systems, leveraging Flutter's cross-platform capabilities. This allows for applications like indoor maps, game maps, or interactive high-res images, all within a cross-platform Flutter app.

The library we'll be using is to create maps is [flutter_map](https://pub.dev/packages/flutter_map) . Similar to [Leaflet](https://leafletjs.com/),  `flutter_map` offers a similar API and tile-based approach to mapping. 


## Preparation
For this project, we'll need the following tools:
- [gdal2tiles.py](https://gdal.org/en/stable/programs/gdal2tiles.html) - for processing images into map tiles.
- [Flutter SDK](https://flutter.dev/) - our tools for developing apps.
- any image editor like [GIMP](https://www.gimp.org/) or Photoshop (even Paint works)
- [npm](https://nodejs.org/en) - for installing additional tools needed later

This tutorial assumes basic familiarity with `gdal2tiles` and Flutter, but beginners are still welcome to follow along. 


>[!NOTE]
> If you're new to gdal2tiles or need a refresher on installing and processing images into map tiles, please refer to my detailed tutorial on [Custom Map from Images in Leaflet](/custom-image-map-leaflet). 
> 
> For a step-by-step guide on how to install Flutter, head over to the [Official Documentation](https://docs.flutter.dev/get-started/install) . Google also provides some [codelabs](https://docs.flutter.dev/codelabs) that can help you get started with the basics.

## Creating the App
### Step 1: Download the Sample image
{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748402916/jereme.me/custom-image-map-flutter/hubble-gas-cocoon-preview.jpg" alt="NASA Space Cocoon" linked=false caption="Preview of sample image. Download the full size here [here](https://github.com/jeremejazz/fluttermap_rastercoords_demo/blob/main/images/hubble-gas-cocoon.jpg)" linked=false loading="lazy" nozoom="true" >}}


For this tutorial, we will be using a sample image which can be downloaded [here](https://github.com/jeremejazz/fluttermap_rastercoords_demo/blob/main/images/hubble-gas-cocoon.jpg). Please the image in a folder for processing. This high-resolution image of space serves as a good example of a large, non-geographical image suitable for custom mapping.

### Step 2: Generate the Map Tiles
Before we create our map tiles, let's first compute for the optimal zoom level. You can use the following formula to compute that: 
```text {title="pseudocode"}
imagesize = max(height, width)
ceiling( log(imagesize / tilesize) / log(2) )
```

>[!TIP]+
> If you're on a web browser you can simply just enter the following JavaScript code in your console. Given that our sample max image size is 6143px and the default tile size is 256px:
>```js {.no-header}
> Math.ceil( Math.log(6143 / 256) / Math.log(2) ); 
>```

Using this computation, we should get a result of `5`. We can now use the zoom level to generate our tile:
```sh
gdal2tiles.py --xyz -p raster -z 0-5 -w none hubble_gas_cocoon.jpg map_tiles/
```
Here is a sample demonstration on how the command is executed:

[![asciicast](https://asciinema.org/a/EwWqshuOutpuci3b0qGfAekzM.svg)](https://asciinema.org/a/EwWqshuOutpuci3b0qGfAekzM)

### Step 3: Create a new Flutter App

In our terminal, enter the new Flutter project. You can name it whatever you like:

```sh
flutter create my_map_project
```
This should create a Flutter app with a default sample application. 
After creating a new project, Flutter includes a sample counter app under `lib/main.dart`. Let's remove all these, including the test file `test/widget_test.dart`.

### Step 4: Add the Dependencies
Navigate into your newly created project directory:
```sh
cd my_map_project
```

Open the `pubspec.yaml` file and add the following dependencies:

```yaml { title="pubspec.yaml" hl_lines=["5-7"] }
dependencies:
  flutter:
    sdk: flutter

  flutter_map: ^8.1.1
  latlong2: ^0.9.1
```

Next, fetch the dependencies we added.
```sh
flutter pub get
```

Here we added the following packages to our project.
- `flutter_map` - as mentioned earlier, is a library for creating map widgets in flutter.
- [latlong2](https://pub.dev/packages/latlong2) - needed for creating `LatLng` objects

### Step 5: Create the Basic Map

We'll be creating the basic app along with a map. 

```dart { title="main.dart" }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const RasterCoordsDemo());
}

class RasterCoordsDemo extends StatelessWidget {
  const RasterCoordsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Map View')),
        body: FlutterMap(
          options: MapOptions(
            initialZoom: 5,
            initialCenter: LatLng(11.3352855,124.3544939),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
          ],
        ),
      ),
    );
  }
}

```

For now, we'll be using  [OpenStreetMap](https://www.openstreetmap.org/) as our placeholder just to check if the application is running. You can start the application on any platform, though I'd recommend using Android as the target platform to be consistent with this guide.


{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748505293/jereme.me/custom-image-map-flutter/basic-map-preview.png" alt="Preview of App in Android Emulator" caption="Preview of App in Android Emulator" linked=true loading="lazy"  >}}

> [!NOTE]
> If you encounter any issues relating to network connections, please refer to the Flutter documentation on [Networking](https://docs.flutter.dev/data-and-backend/networking).


### Step 6: Start the Map Server

Install [serve](https://www.npmjs.com/package/serve) , a tool for serving static files locally.
```sh
npm i -g serve
```
This should make the serve command available in your terminal. 
Go back to the parent directory of `map_tiles` , where we ran `gdal2tiles` to generate our map tile images, and run the following to start the local server:

```
serve -l 8080
```

>[!TIP]
> For `web` target builds, you can also add the `--cors` option to enable [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS) on your local server.

You should be able to open the local server in the browser when you open [http://localhost:8080](http://localhost:8080).
{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748491702/jereme.me/custom-image-map-flutter/localhost-browser.png" alt="Opening localhost:8080" caption="Opening localhost:8080" linked=true loading="lazy" >}}
 
### Step 7: Add our custom Map

Now that we have a running web server. We can use the following URL Template
```plaintext {.no-header}
http://localhost/map_tiles/{z}/{x}/{y}.png
```

>[!NOTE]
>When accessing the local server from an Android emulator, replace `localhost` with `10.0.2.2`

Before we make some changes, we need to [flutter_map_rastercoords](https://pub.dev/packages/flutter_map_rastercoords) to our `pubspec.yaml` file:
```yaml { title="pubspec.yaml" }
dependencies:
  # ... existing dependencies
  flutter_map_rastercoords: ^0.0.4

```

Similar to [leaflet-rastercoords](https://github.com/commenthol/leaflet-rastercoords),  `flutter_map_rastercoords` is a plugin for `flutter_map` that makes it easier to project pixel coordinates into the map's `latitude` and `longitude` coordinates. 

Run `flutter pub get` again to download the new package.

Then proceed with the `main.dart` changes:
```dart { title="main.dart" hl_lines=[3,"15-16","27-34",38] }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_rastercoords/flutter_map_rastercoords.dart';

void main() {
  runApp(RasterCoordsDemo());
}

class RasterCoordsDemo extends StatelessWidget {
  // since our image width and height are
  // 6143px and 4600px respectively. Feel free to use
  // your own measurements if you are using a different image. 
  // you can find these by inspecting the original image's file
  // properties
  final rc = RasterCoords(width: 6143, height: 4600);
  RasterCoordsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Map View')),
        body: FlutterMap(
          options: MapOptions(
            // Coordinate reference system for non-geographical maps
            // this also prevents the map from repeating or wrapping.
            crs: CrsSimple(),
            initialZoom: 1,
            minZoom: 1,
            // the calculated optimal zoom based on your image dimensions
            maxZoom: rc.zoom,
            // set the center by dividing
            // the height and width of your image by 2
            initialCenter: rc.pixelToLatLng(x: rc.width / 2, y: rc.height / 2),
          ),
          children: [
            TileLayer(
              urlTemplate: 'http://10.0.2.2:8080/map_tiles/{z}/{x}/{y}.png',
            ),
          ],
        ),
      ),
    );
  }
}

```

When running, you should now be able to view the application on the emulator. 

>[!TIP]
>To simulate pinch for zooming in and out on the emulator, hold the `Ctrl`  (or `cmd` key on mac ) then drag the mouse on the screen.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748495371/jereme.me/custom-image-map-flutter/custom-map-emulator.png" alt="Viewing the map on the Android emulator" caption="  Viewing the map on the Android emulator" linked=true loading="lazy" >}}

 


>[!INFO]
>You can learn more about the methods and properties included in  `RasterCoords` class, from the  [Documentation](https://pub.dev/documentation/flutter_map_rastercoords/latest/flutter_map_rastercoords/RasterCoords-class.html)

### Step 8: Keeping the Map in Place
So you might have noticed that you are able to drag outside the image. To prevent this from happening. Let's add some constraints to the `MapOptions`:
```dart { title="main.dart" hl_lines=["8-10"] }
	  options: MapOptions(
		crs: CrsSimple(),
		initialZoom: 1,
		minZoom: 1,
		maxZoom: rc.zoom,

		initialCenter: rc.pixelToLatLng(x: rc.width / 2, y: rc.height / 2),
		cameraConstraint: CameraConstraint.containCenter(
		  bounds: rc.getMaxBounds(),
		), 
	  ),
```
With this, you should no longer be able to scroll farther from the image.

### Step 9: Adding Markers 

#### Getting the Coordinates
We'll be demonstrating projecting pixel coordinates into map coordinates by adding markers.  We've demonstrated this before by setting the `initialCenter` of our `MapOptions`.
First, open the original image using any Photo editor. Use the cursor or info tool in your image editor to read the pixel coordinates (x, y) at the point you want to use.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748497100/jereme.me/custom-image-map-flutter/space-cloud-coordinates.png" alt="Getting the Pixel Coordinates" caption="Getting the Pixel Coordinates using GIMP" linked=true loading="lazy" >}}

#### Creating the Marker
For adding markers, append a marker layer right below the `TileLayer`, which is in the `children` property of our `FlutterMap` widget.

```dart { title="main.dart" hl_lines=["5-15"] lineNos=true }
      children: [
        TileLayer(
          urlTemplate: 'http://10.0.2.2:8080/map_tiles/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              // create a marker on the specified pixel coordinates
              point: rc.pixelToLatLng(x: 5232, y: 2524),
              width: 20,
              height: 20,
              child: const FlutterLogo(), // Use const for better performance
            ),
          ],
        ),
      ],

```

When running the marker should now be visible on the coordinates we selected. 
{{< image src="https://res.cloudinary.com/jereme/image/upload/v1748498008/jereme.me/custom-image-map-flutter/marker-on-map.png" alt="Marker on Map" caption="Marker on Map" linked=true loading="lazy" >}}
 
## Conclusion

In this guide, we have created a custom non-geographical map in Flutter using an existing image. From here you'll be able to create cross-platform applications that uses custom image-based maps. Try to explore the API of `flutter_map` and `flutter_map_rastercoords`  and also try building for other platforms as well. 

>[!Note]
> The sample code used in this tutorial is available at the Github Repository: [Flutter Map Rastercoords Demo](https://github.com/jeremejazz/fluttermap_rastercoords_demo)

>[!quote] Credits
> - Cover Image by [Gerd Altmann](https://pixabay.com/users/geralt-9301/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2742113) from [Pixabay](https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2742113)
> - Sample Image by [NASA Hubble Telescope](https://www.flickr.com/photos/nasahubble/)


