  

# DEEPSTREAM <3 OSC

![enter image description here](https://gateway.pinata.cloud/ipfs/QmRRDTWCsxqE4JfHZDzUqGRwXJKQAZ8Jox2dbkP8FR4H5U/deeposcexample2.png)


Examples video: https://vimeo.com/416440440 


### This repository includes:

- a modified version of [python-deepstream-apps](https://github.com/NVIDIA-AI-IOT/deepstream_python_apps) (only tested with DeepStream version 4.0.2, Jetpack 4.3), to open up an Open Sound Control bridge for DeepStream in Jetson Nano. OSC client broadcasts all the data of detected objects and other frame metadata to computers in the local network. Messages are sent from port 4545.

- a .scd file for parsing incoming OSC messages in SuperCollider, mapping them control busses, to be used for dynamic mapping of parameters in synths, patterns, routines etc.

- a .tox file which includes Python scripts to generate operators, and read OSC messages in Touchdesigner to visualize the detected objects.

![.tox example](https://gateway.pinata.cloud/ipfs/QmemcXTEWScByMnoe7uyT29fo4S9WY6cxqmoe5XPvNiasA/deeposcexample1.png)
  

## What is DeepStream SDK?

  
NVIDIA DeepStream SDK is a very powerful resource for making real-time intelligent video analytics apps, DIY projects and IOT services.

And the best part is, it can be run on a single board computer like Jetson Nano, with a very good performance (30 fps), even with multiple video sources.

## What am I doing with it?

I had bought a Jetson Nano, before DeepStream SDK for Jetson Nano was released. When I saw [this pre-release video of DeepStream](https://www.youtube.com/watch?v=Y43W04sMK7I) by Nvidia Developers, I thought that this technology can be half [code-bent](http://www.paperkettle.com/codebending/) to output the real time analysis data to any other software, and become an instrument, sonifier, visualizer, controller to play with in any space.

I am working with a pre-trained model and config that comes with DeepStream examples. The model working in my modified app can only detect people, cars, bicycles and road signs. And I use a Logitech C920 webcam.

![schemadeeposc](https://gateway.pinata.cloud/ipfs/QmPoqJLG7D5ktt4DA4N6WVQFn3ykgVbK9aq1shuufNsR2k/Deepstream%20Python.png)

## Messages:

Jetson Nano constantly sends OSC messages to network with port 4545. The types of messages are:

**/frame_number** - Current frame number

**/oxywhc** - This message is sent for each object detected in the frame.

[ object no, x coordinate, y coordinate, width, height, class name ]

**/num_rects** - Total number of objects detected in the frame

**/num_vehicles** - Number of vehicles detected in the frame

**/num_people** - Number of people detected in the frame


 
## Possible Use Cases:

- Programming interactive / generative audiovisual setups. Using algorithms, rule sets, direct mapping, chance

- Performances with choreography in a fixed space and camera position, or moving space (portable)

- Hooking up to any software which can listen to OSC

- Controlling any software, i.e. music software, videogame, browser, editing software etc. by translating OSC messages to MIDI or HID or serial


  
## How to Use

    Install DeepStream SDK 5 and Python bindings, examples.
Have python-osc library installed for your Python3. 

`pip install python-osc`

Copy this folder to your Deepstream 5.0 installation folder.

`/opt/nvidia/deepstream/deepstream-5.0/sources/python/apps`


------

Usage:


  $ cd /opt/nvidia/deepstream/deepstream-5.0/sources/python/apps/deepstream-osc


Video files:

  $ python3 dsoscvideo.py file:///home/user/path/to/video_file.mp4

Webcam:

  $ python3 dsoscwebcam.py <v4l2-device-path>
Example:
  $ python3 dsoscwebcam.py /dev/video0
  


Get the OSC data from any other computer in the same network, from port 4545. 




