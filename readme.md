  

# DEEPSTREAM <3 OSC

![enter image description here](https://gateway.pinata.cloud/ipfs/QmRRDTWCsxqE4JfHZDzUqGRwXJKQAZ8Jox2dbkP8FR4H5U/deeposcexample2.png)


First demo video: https://vimeo.com/416440440 

Live coding w/ Supercollider + Youtube videos: https://www.youtube.com/watch?v=6JwX-vOz1Hg 

Live visuals for Princess Camel album premiere livestream on Twitch at RGB Dog’s BedroomNightOut event: https://www.youtube.com/watch?v=hL9QXTFQdi4


NVIDIA forum post: https://forumsx.developer.nvidia.com/t/turning-jetson-nano-to-an-interactive-audiovisual-instrument-deepstream-3-opensoundcontrol/128766



### This repository includes:

- a modified version of [python-deepstream-apps](https://github.com/NVIDIA-AI-IOT/deepstream_python_apps), to open up an Open Sound Control bridge for DeepStream in Jetson Nano. OSC client broadcasts all the data of detected objects and other frame metadata to computers in the local network. Messages are sent from port 4545.

- a .scd file for parsing incoming OSC messages in SuperCollider, mapping them control busses, to be used for dynamic mapping of parameters in synths, patterns, routines etc.

- a .tox file which includes Python scripts to generate operators, and read OSC messages in Touchdesigner to visualize the detected objects.

![.tox example](https://gateway.pinata.cloud/ipfs/QmemcXTEWScByMnoe7uyT29fo4S9WY6cxqmoe5XPvNiasA/deeposcexample1.png)
  

### WHAT IS THIS?

With this project, I am exploring the possibilities of using a real time object detection system as an interactive performative instrument. 

I am using a single board computer called Jetson Nano, which runs DeepStream SDK; which is a realtime intelligent image analysis framework for survelliance, analysis, security applications or DIY projects. DeepStream can be used with realtime camera input, or video playback. The default model comes with DeepStream can detect people, cars, bicycles and roadsigns.

What I did with it was modifying some of the Python code examples to send data of each detected object to other computers in the network using OSC (Open Sound Control) protocol, which allows me to control any software that accepts OSC messages.

Obviously it is up to one's imagination to how to use this data; they can be mapped as keyboard/mouse/gamepad inputs to control softwares such as videogames, be used to generate/control visuals and sounds, and so on.

I use Supercollider to parse incoming OSC data from DeepStream, and map this data to parameters of synths I create. Each number data DeepStream sends (x-y-width-height each object, frame number, number of people-cars etc.) are stored in control busses in real time, which can be processed and mapped to anything I created in Supercollider on the fly. This allows me to turn the movements of people and vehicles grabbed by my camera to sounds.

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
  


Get the OSC data from any other computer in the same network, from port 4545 (change the IP address of your network connection, on default it is 192.168.1.255). Use it however you want.

Check Touchdesigner and Supercollider examples to play with it!




