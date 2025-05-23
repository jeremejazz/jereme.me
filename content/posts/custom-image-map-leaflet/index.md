---
title: Creating a Custom Map from Images in Leaflet
subtitle: Turn images into awesome zoomable applications
date: 2025-05-21T14:26:21+08:00
slug: custom-image-map-leaflet
draft: false
author:
  name: Jereme
  link:
  email:
  avatar:
description: In this tutorial, we’ll walk through how to create a custom map using a large image in Leaflet. Useful when working with non-geographical maps.
keywords:
  - leaflet
  - javascript
  - tutorial
  - custom maps
  - geospatial
  - gdal2tiles
license: <a rel="license external nofollow noopener noreferrer" href="https://creativecommons.org/licenses/by-nc-sa/4.0/" target="_blank">CC BY-NC-SA 4.0</a>
comment: false
weight: 0
tags:
  - javascript
  - leaflet
  - tutorials,
  - development
categories:
  - tutorials
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
summary: In this tutorial, we’ll walk through how to create a custom map using a large image in Leaflet. This technique is useful when working with non-geographical maps or images that you want to make interactive, zoomable, and possibly annotated.
resources:
  - name: featured-image
    src: images/featured-image.jpg
  - name: featured-image-preview
    src: images/featured-image-preview.jpg
toc: true
math: false
lightgallery: true
password:
message:
repost:
  enable: false
  url:
# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---

In this tutorial, we’ll walk through how to create a custom map using a large image in [Leaflet](https://leafletjs.com/), a lightweight JavaScript library for building interactive maps in web applications.

This technique is useful when working with non-geographical maps or images that you want to make interactive, zoomable, and possibly annotated.

## Why Use Custom Maps?

Here are some use cases where custom maps from image are applicable:

- **Indoor Maps**: This is a common use case—think of malls, airports, or exhibition halls where a visual indoor layout helps visitors navigate.
- **Video Game Maps**: Many games come with expansive in-game worlds. Custom maps allow for interactive player guides. For example, [The Forest Map](https://theforestmap.com/) provides an interactive map for players of _The Forest_ game.
- **Zoomable Images**: You’re not limited to maps. If you have a large image, such as a blueprint, artwork, or infographic, you can use Leaflet to let users zoom into specific areas without loading the entire image at once. You can even add markers or annotations for more context. (ex. ESO’s 9-gigapixel [zoomable image of the Milky Way galaxy](https://www.eso.org/public/images/eso1242a/zoomable/), even though this is using HTML5 canvas, you can also make something similar using Leaflet. )

## Preparation and Setup

Before we begin, make sure you have the following tools installed:

- **Geospatial Data Abstraction Library (GDAL)** – a powerful library for reading and processing raster and vector geospatial data.
- **Python 3** (with GDAL Python bindings)
- **[npm](https://nodejs.org)** – for setting up and running our web application.

### Installing GDAL and Python

If you don’t have GDAL installed yet, the recommended method (which we’ll use in this tutorial) is via **Anaconda** or **Miniconda**. This approach is beginner-friendly and includes the required Python bindings out of the box.
{{< admonition info >}}
I would recommend checking out this [step-by-step GDAL installation guide](https://gist.github.com/jeremejazz/02ea7626ec12a39a789f44db4a9ec49c) for installing GDAL with Anaconda
{{< /admonition >}}
While there are other installation methods available (e.g., via Homebrew, apt, or pip), using Anaconda ensures fewer compatibility issues.

## Tiling The Image

#### Getting the Sample Image

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747823095/jereme.me/custom-image-map-leaflet/treasure-map_l9oo8u.jpg" alt="Treasure Map" caption="Image by [Prawny](https://pixabay.com/users/prawny-162579/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1904523) from [Pixabay](https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1904523)" linked=false loading="lazy" >}}

For this tutorial, we'll use a sample image named [treasure-map.jpg](https://github.com/jeremejazz/leaflet-raster-to-tiles-example/blob/main/images/treasure-map.jpg). You can simply just right click the image above then save it to your project folder. You can also substitute this with your own image, keeping in mind the recommendations regarding image dimensions discussed later.

#### Tiling with `gdal2tiles.py`

Assuming that you’ve followed the provided step-by-step guide for installing GDAL earlier, be sure to activate the conda environment:

```bash
conda activate geospatial
```

Now, let's generate the image tiles. We'll use the following command:

```bash
gdal2tiles.py --xyz -p raster -z 0-2 -w leaflet treasure-map.jpg map/
```

Let's break down each parameter:

- `--xyz`: This crucial flag ensures that the generated tile coordinates are compatible with common web mapping libraries like Leaflet. Without `--xyz`, `gdal2tiles.py` defaults to TMS (Tile Map Service) coordinate system, which can result in jumbled or incorrectly displayed tiles in Leaflet.
- `-p raster`: This parameter simply indicates that our input file is a raster image.
- `-z 0-2`: This specifies the zoom range for tile generation. We are generating tiles from zoom level 0 (the most zoomed-out view) up to zoom level 2 (more zoomed-in). Generating more zoom levels will create a larger number of tile files, but it allows for greater detail as the user zooms in.
- `-w leaflet`: This parameter specifies the desired web viewer. While `gdal2tiles.py` doesn't strictly generate a full-fledged web viewer for Leaflet (you'll still need to write some HTML/JavaScript for that), setting it to `leaflet` prevents the generation of files for other map web viewers that you might not need. You can also set this to `none` if you prefer to avoid generating any viewer-specific files.

{{< admonition info >}}
For a complete list of options, refer to the official [gdal2tiles CLI documentation](https://gdal.org/en/stable/programs/gdal2tiles.html).
{{< /admonition >}}

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819557/jereme.me/custom-image-map-leaflet/gdal2tiles-tiling-example.png" alt="Tiling with gdal2tiles.py" caption="Tiling with gdal2tiles.py" loading="lazy" >}}

#### Understanding Zoom Levels and Image Dimensions

The choice of zoom levels is directly related to your image's dimensions. Web map tiles typically have a size of 256x256 pixels. Each subsequent zoom level doubles the resolution of the previous level, effectively quadrupling the number of tiles needed to cover the same area.

The table below illustrates the relationship between zoom level and the size of the area covered by a single tile at that level:

| zoom level | size(px) |
| ---------- | -------- |
| 0          | 256      |
| 1          | 512      |
| 2          | 1024     |
| 3          | 2048     |
| 4          | 4096     |
| 5          | 8192     |

Since our `treasure-map.jpg` is 1024x1024, the maximum recommended zoom level is 2. Going beyond this ideal zoom level would not add further detail but might simply stretch or pixelate the image, affecting its quality.

This can be calculated based on the size of a leaflet tile which is 256px and has each square size increasing based on the power of 2.

```text {title="pseudocode"}
ceiling( log(imagesize / tilesize) / log(2) )
```

After running the `gdal2tiles.py` command, you will find a `map/` directory containing subdirectories for each zoom level, and within those, individual image tiles. We’ll be using these tiles in our web mapping application, such as Leaflet, by pointing the map’s tile layer to the `map/` directory.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819556/jereme.me/custom-image-map-leaflet/gdal2tiles-output-folder.png" alt="Output Folder" caption="Example output of tiled images" loading="lazy">}}

## Creating the Web Application with Vite and Leaflet

Now that we have our image tiles, let's build a simple web application to display them using Vite and Leaflet. Vite provides a fast development experience with features like hot module replacement and a local development server.

### Initialize the Project with Vite

First, navigate to your desired projects folder in the terminal and create a new Vite project. We'll use the `vanilla` template for a basic setup. You can name your project anything you like; here, we'll use `my-leaflet-app`:

```bash
npm create vite@latest my-leaflet-app -- --template vanilla
```

This command will create a new directory named `my-leaflet-app` (or whatever you specified). Follow the on-screen instructions, which will typically guide you to:

1.  Change into the new project directory:

    ```bash
    cd my-leaflet-app
    ```

2.  Install the project dependencies:

    ```bash
    npm install
    ```

3.  Start the development server:
    This will open your application in a browser, and it will automatically reload whenever you make changes to your code.
    ```bash
    npm run dev
    ```

#### Install Required Packages

Next, we need to install the core libraries for our map application:

- **`leaflet`**: The popular open-source JavaScript library for interactive maps.
- **`leaflet-rastercoords`**: A useful utility for projecting pixel coordinates from our image to Leaflet's map coordinates.

Install them using npm:

```bash
npm i -S leaflet leaflet-rastercoords
```

#### Creating the Map

Now that our project is set up and dependencies are installed, let's clean up the default Vite code and start building our map.

1. **Clean up `src/main.js` and `src/style.css`**: Remove all existing content from these two files.
2. **Add Styles to `src/style.css`**: Add the following CSS to style our web page and the map container:

```css { title="style.css" }
body {
  font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
  color: #505050;
  display: block;
  max-width: 768px;
  width: 100%;
  margin: 0 auto;
}

#app {
  max-width: 768px;
  border: 1px solid #eee;
  width: 100%;
  height: 550px;
}
```

       We've defined a `div` with the ID `app` where our map will be rendered.

1. **Initialize the Map in `src/main.js`**: Now, let's add the JavaScript code to `src/main.js` to create and display our Leaflet map.

```js { title="main.js" }
import "leaflet/dist/leaflet.css";
import "./style.css";
import * as L from "leaflet";
import "leaflet-rastercoords";

// Note for Markers:
// Since Leaflet's default marker icons don't work properly with package bundlers like Vite,
// we need to explicitly import and re-create them.
import marker from "leaflet/dist/images/marker-icon.png";
import marker2x from "leaflet/dist/images/marker-icon-2x.png";
import markerShadow from "leaflet/dist/images/marker-shadow.png";

function init() {
  const container = document.getElementById("app");

  if (!container) throw new Error('There is no div with the id: "app" ');

  const height = 1024;
  const width = 1024;

  const imageDimensions = [width, height];

  const map = L.map(container, {
    center: L.latLng(0, 0),
    noWrap: true,
    crs: L.CRS.Simple,
  });

  L.tileLayer("/map/{z}/{x}/{y}.png", {
    noWrap: true,
    maxZoom: 2,
  }).addTo(map);

  // Initialize Leaflet.RasterCoords with the map and image dimensions
  const rc = new L.RasterCoords(map, imageDimensions);

  map.setView(rc.unproject([width, height]), 1);

  // Re-create Leaflet's default icon for markers (due to bundler issues)
  const icon = L.icon({
    iconUrl: marker,
    iconRetinaUrl: marker2x,
    shadowUrl: markerShadow,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });
  // Example of adding a marker at specific pixel coordinates
  // L.marker(rc.unproject([611, 433]), { icon }).addTo(map);
}

init();
```

#### Copying the Tiles to the Public Folder

For our Vite development server to serve the generated map tiles, we need to copy the `map/` folder (created in the previous `gdal2tiles.py` step) into the `public/` directory of your Vite project.

If your local development server (`npm run dev`) is still running, you should now be able to see your `treasure-map.jpg` image displayed as a zoomable map in your browser!

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747821388/jereme.me/custom-image-map-leaflet/example-web-app.png" alt="Example leaflet web app" caption="Webpage after loading the tiled images" loading="lazy">}}

#### Projecting Coordinates with `leaflet-rastercoords` and `L.CRS.Simple`

In our main.js, you might have noticed the following lines when initializing the map:

```js { title="main.js" hl_lines=[4,9,10]}
const map = L.map(container, {
  center: L.latLng(0, 0),
  noWrap: true,
  crs: L.CRS.Simple,
});

// ...

const rc = new L.RasterCoords(map, imageDimensions);
map.setView(rc.unproject([width, height]), 1);
```

Here's why `leaflet-rastercoords` and `CRS.Simple` are essential for working with custom image maps:

##### Understanding Coordinate Reference Systems (CRS)

Typically, web maps use a geographic coordinate system (like EPSG:3857, also known as Web Mercator) to represent real-world locations. However, for our custom image map, we're not dealing with geographic coordinates (latitude and longitude). Instead, we're working directly with the **pixel coordinates** of our image. This is where `CRS.Simple` comes in. It's a special, non-projected coordinate reference system provided by Leaflet that treats pixel coordinates as its primary unit.

`CRS.Simple`'s origin starts at the top left corner of the map (0,0) and the X and Y coordinates increases as you move to the right and down respectively. This setup aligns with how pixel coordinates are typically referenced in most photo editing softwares.

{{< admonition info>}}
For more in-depth guide and examples, check out the Leaflet's official post regarding [non-geographical maps](https://leafletjs.com/examples/crs-simple/crs-simple.html)
{{< /admonition >}}

##### The Role of `leaflet-rastercoords`

While `L.CRS.Simple` provides the foundation, `leaflet-rastercoords` significantly simplifies the process of integrating our image with Leaflet's map functions. This utility library makes it easy to convert between your image's raw pixel coordinates.
This library also automatically handles the map boundaries so that cannot scroll endlessly outside the bounds of your image, as it sets the pan limits.

This means you can easily work with the familiar pixel coordinates from your image (e.g., obtained directly from a photo editing software like GIMP or Photoshop) and convert them to map locations for adding markers, polygons, or other interactive elements.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819557/jereme.me/custom-image-map-leaflet/getting-pixel-coordinates-with-gimp.png" alt="Getting Coordinates with GIMP" caption="Hovering the mouse pointer over an area in the image displays the coordinates at the bottom in GIMP" loading="lazy">}}

For example, if you want to place a marker at pixel coordinates X: 611, Y: 433 on our sample image `treasure-map.jpg`, you can do so by using `rc.unproject()` to set the coordinates:

```js
L.marker(rc.unproject([611, 433]), { icon }).addTo(map);
```

After adding this line and refreshing your browser (or if Vite automatically reloads), you should see a marker appear and the coordinate based the Y and X coordinates.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819557/jereme.me/custom-image-map-leaflet/example-web-app-leaflet-marker.png" alt="Example Leaflet Web App with Marker" caption="After applying the pixel coordinates, marker should now appear." loading="lazy">}}

## Conclusion

In this tutorial we have created a custom zoomable map in Leaflet from an existing image. This setup provides a foundation for building more custom image-based map. Feel free to experiment by using different images, adding more layers such as markers and shapes while exploring other leaflet functionalities as well.

{{< admonition type="info" title="Source Code" open=true >}}
You can find the complete source code for this project at the Github Repository: [Leaflet Raster to Tiles Example](https://github.com/jeremejazz/leaflet-raster-to-tiles-example)
{{< /admonition >}}

{{< admonition "References"  >}}

[Zoomable images with Leaflet](https://build-failed.blogspot.com/2012/11/zoomable-image-with-leaflet.html) - I used this as basis for my earlier project for an [earlier project](https://github.com/jeremejazz/olivarezmaps) back in 2013. [Maptiler](https://www.maptiler.com/) was used on that project instead of `gdal2tiles.py`.

{{< /admonition >}}

{{< admonition type=quote title="Credits" open=false >}}
Cover Image by [Pexels](https://pixabay.com/users/pexels-2286921/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1867212) from [Pixabay](https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1867212)

{{< /admonition >}}
