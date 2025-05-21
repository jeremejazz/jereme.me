---
title: Creating a Custom Map from Images in Leaflet
subtitle:
date: 2025-05-21T14:26:21+08:00
slug: custom-image-map-leaflet
draft: true
author:
  name: Jereme
  link:
  email:
  avatar:
description:
keywords:
license:
comment: false
weight: 0
tags:
  - javascript
  - leaflet
  - tutorials,
  - development
categories:
  - development tutorials
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRelated: false
hiddenFromFeed: false
summary:
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

<!--more-->

In this tutorial, we’ll walk through how to create a custom map using a large image in [Leaflet](https://leafletjs.com/), a lightweight JavaScript library for building interactive maps in web applications.

This technique is useful when working with non-geographical maps or images that you want to make interactive, zoomable, and possibly annotated.

## Why Use Custom Maps?

There are several scenarios where using a custom image as a map makes sense:

- **Indoor Maps**: This is a common use case—think of malls, airports, or exhibition halls where a visual indoor layout helps visitors navigate.
- **Video Game Maps**: Many games come with expansive in-game worlds. Custom maps allow for interactive player guides. For example, [The Forest Map](https://theforestmap.com/) provides an interactive map for players of _The Forest_ game.
- **Zoomable Images**: You’re not limited to maps. If you have a large image, such as a blueprint, artwork, or infographic, you can use Leaflet to let users zoom into specific areas without loading the entire image at once. You can even add markers or annotations for more context. (ex. ESO’s 9-gigapixel [zoomable image of the Milky Way galaxy](https://www.eso.org/public/images/eso1242a/zoomable/), even though this is using HTML5 canvas, you can also make something similar using Leaflet. )

## Preparation and Setup

Before we begin, make sure you have the following tools installed:

- **Geospatial Data Abstraction Library (GDAL)** – a powerful library for reading and processing raster and vector geospatial data.
- **Python 3** (with GDAL Python bindings)
- **npm** – for setting up and running our web application.

### Installing GDAL

If you don’t have GDAL installed yet, the recommended method (which we’ll use in this tutorial) is via **Anaconda** or **Miniconda**. This approach is beginner-friendly and includes the required Python bindings out of the box.
{{< admonition info >}}
I would recommend checking out this [step-by-step GDAL installation guide](https://gist.github.com/jeremejazz/02ea7626ec12a39a789f44db4a9ec49c) for installing GDAL with Anaconda
{{< /admonition >}}
While there are other installation methods available (e.g., via Homebrew, apt, or pip), using Anaconda ensures fewer compatibility issues.

## Tiling The Image

#### Getting the Sample Image

For this tutorial, we'll use a sample image named [treasure-map.jpg](https://github.com/jeremejazz/leaflet-raster-to-tiles-example/blob/main/images/treasure-map.jpg). You can substitute this with your own image, keeping in mind the recommendations regarding image dimensions discussed later.

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

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819557/jereme.me/custom-image-map-leaflet/gdal2tiles-tiling-example.png" alt="Tiling with gdal2tiles.py" caption="Tiling with gdal2tiles.py" >}}

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

This can be calculated based on the size of a leaflet tile which is 256x256 and has each square size increasing based on the power of 2

```text
ceiling( log(imagesize / tilesize) / log(2) )
```

{{< admonition tip >}}
For optimal results and to avoid unnecessary file generation, it's highly recommended to use images with equal dimensions that are powers of 2 (e.g., 256x256, 512x512, 1024x1024, 2048x2048, etc.). This ensures that your image aligns perfectly with the tile grid at various zoom levels.
{{< /admonition >}}

After running the `gdal2tiles.py` command, you will find a `map/` directory containing subdirectories for each zoom level, and within those, individual image tiles. We’ll be using these tiles in our web mapping application, such as Leaflet, by pointing the map’s tile layer to the `map/` directory.

{{< image src="https://res.cloudinary.com/jereme/image/upload/v1747819556/jereme.me/custom-image-map-leaflet/gdal2tiles-output-folder.png" alt="Output Folder" caption="Example output of tiled images" >}}
