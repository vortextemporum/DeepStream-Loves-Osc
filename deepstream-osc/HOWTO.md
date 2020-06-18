
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
