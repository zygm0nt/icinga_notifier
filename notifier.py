#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import sys
from pprint import pprint

if len(sys.argv) < 2:
  raise Exception("usage: %s file_to_open" % sys.argv[0])

json_data=open(sys.argv[1])

data = json.load(json_data)

size = len(data["status"]["service_status"])

per_host_map = dict()

for i in range(size):
  obj = data["status"]["service_status"][i]
  if obj['host'] not in per_host_map:
    per_host_map[obj['host']] = []
  per_host_map[obj['host']].append((obj['service'], obj['duration'], obj['status_information']))

json_data.close()

import operator
for key, values in sorted(per_host_map.iteritems(), key=operator.itemgetter(0)):
  print "* %s" % (key)
  for (service, duration, stat_info) in values:
    print "\t - %s - %s" % (service, duration)
