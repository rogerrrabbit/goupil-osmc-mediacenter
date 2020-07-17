#!/usr/bin/env python
import os
app = "Steam"
os.system('systemctl start moonlight@"%s".service' % app)
