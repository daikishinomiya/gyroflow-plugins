<span class="badge-patreon"><a href="https://www.patreon.com/smartislav" title="Donate to this project using Patreon"><img src="https://img.shields.io/badge/patreon-donate-yellow.svg" alt="Patreon donate button" /></a></span>
![example workflow](https://github.com/gyroflow/gyroflow-ofx/actions/workflows/build.yml/badge.svg)

# Gyroflow OpenFX plugin

* Works with stabilization data exported with [gyroflow](http://gyroflow.xyz/)
* Allows you to apply the stabilization right in your OpenFX-capable video editor

# Installation

Grab the archive for your OS from the [releases page](https://github.com/gyroflow/gyroflow-ofx/releases).

## Linux

    mkdir -p /usr/OFX/Plugins
    cd /usr/OFX/Plugins
    sudo unzip ${PATH_TO}/gyroflow-ofx-linux.zip

## MacOS

Copy the `Gyroflow.ofx.bundle` from the archive into the `/Library/OFX/Plugins` directory.
Create the directory if it doesn't exist yet.
Then in Resolve, make sure to go to Preferences -> Video plugins and enable Gyroflow.ofx.bundle.

## Windows

Copy the `Gyroflow.ofx.bundle` from the archive into the `C:\Program Files\Common Files\OFX\Plugins` folder.
Create the folder if it doesn't exist yet.

## For more detailed instructions, see the [docs](https://docs.gyroflow.xyz/app/video-editor-plugins/davinci-resolve-openfx#installation)

# Usage

### Export `.gyroflow` file in the Gyroflow app

Click the `Export project file (including gyro data)` in the Gyroflow app. You can also use `Ctrl+S` or `Command+S` shortcut

### Basic plugin usage

First you need to apply the plugin to the clip.
In DaVinci Resolve you can do that by going to the Fusion tab and inserting the "Warp -> Gyroflow" after the media input node.
You can also apply the plugin on the Edit or Color page - it should work faster this way.

### Load the .gyroflow file

In DaVinci Resolve, go to the `Gyroflow` plugin settings. Select the `.gyroflow` file in the `Project file` entry.
If your video file is from GoPro 8+, DJI or Insta360, you can also select video file directly. If it's from Sony or it's BRAW - you can also select the video file directly, but you need to load lens profile or preset after that.

## For more detailed instructions, see the [docs](https://docs.gyroflow.xyz/app/video-editor-plugins/general-plugin-workflow)

# Interface additions

These controls sit alongside the ones described on the [DaVinci Resolve (OpenFX) docs page](https://docs.gyroflow.xyz/app/video-editor-plugins/davinci-resolve-openfx#interface).

### Adjust parameters

#### Stabilization amount

How much of the stabilization is applied. **100%** is fully stabilized, **0%** is the clip as the camera recorded it (including in-camera stabilization such as Sony IBIS, which Gyroflow otherwise undoes), and values in between blend the two. Keyframe it in the Inspector to stabilize only part of a clip, or let **Stabilization range** set the keyframes for you.

The zoom follows the amount, so it eases in and out with it instead of jumping. Lens correction is not affected: keyframe **Lens correction** as well if the unstabilized parts should keep the lens's original distortion.

### Stabilization range

Stabilizes only part of the clip, chosen with the playhead.

#### Set in here

Stabilizes from the current frame on. Before it, the stabilization eases in over the **Ease** duration.

#### Set out here

Stabilizes up to the current frame. After it, the stabilization eases out over the **Ease** duration.

Setting an in point after the out point (or an out point before the in point) clears the other one, and the **Range** field says so.

#### Clear range

Stabilizes the whole clip again and removes the **Stabilization amount** keyframes.

#### Ease (frames)

How many frames the stabilization takes to ease in before the in point and out after the out point. Changing it updates the keyframes of the current range. **0** switches it within a single frame.

#### Range

Shows the current in and out points, in clip frames and seconds.

> [!NOTE]
> **Set in here**, **Set out here**, **Clear range** and **Ease** rewrite the **Stabilization amount** keyframes. Keyframes you added to it by hand are replaced. The ease is written as a few keyframes on an S-curve, so it eases regardless of the interpolation Resolve uses between them. You can still move or edit them in the keyframe editor afterwards.

# Workflow

### Stabilize only part of a clip

1. Apply the plugin on the Edit or Color page and load the project or video as usual.
2. Open **Stabilization range**.
3. Move the playhead to where the stabilization should start and click **Set in here**.
4. Move the playhead to where it should end and click **Set out here**.
5. Adjust **Ease (frames)** until the transition looks right.

Only one side can be set too: an in point alone stabilizes from there to the end of the clip, an out point alone from the start up to it.

For more than one stabilized section, keyframe **Stabilization amount** by hand instead.

# Building

The plugins build against Gyroflow core with the patches in [`core-patches/`](core-patches) applied (they add the **Stabilization amount** keyframe to the core). Fetch and patch it once before building, and again whenever the core revision changes:

    just core

The core revision is pinned in `core-patches/gyroflow-core.rev`; keep it in step with the `rev` of `gyroflow-core` in `common/Cargo.toml`.


# License

This software is licensed under GNU General Public License version 3 ([LICENSE](LICENSE))

# Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the GNU General Public License version 3, shall be
licensed as above, without any additional terms or conditions.
