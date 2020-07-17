#!/usr/bin/env python
import os
app = "Desktop"
os.system('systemctl start moonlight@"%s".service' % app)
