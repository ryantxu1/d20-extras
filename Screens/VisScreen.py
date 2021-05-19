# Copyright 2021 MITRE Corporation

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from d20.Manual.Logger import logging
from d20.Manual.Options import Arguments
from d20.Manual.Templates import (ScreenTemplate, registerScreen)

from typing import List

import json

LOGGER = logging.getLogger(__name__)

# USING THIS SCREEN:
#
# When using this screen, redirect output to a file called "data.json".
#
# Put the "data.json" file in the same directory as the "visjs.html" file that
# comes in the "extras" folder. You can then load the "visjs.html" file in a
# browser and it will import the data generated by this screen to construct a
# graph of the results.


class BytesEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, bytes):
            return (str(obj, 'utf-8'))
        return json.JSONEncoder.default(self, obj)


@registerScreen(
    name="visjs",
    version="0.1",
    engine_version="0.1",
    options=Arguments(
        ("exclude", {'type': list, 'default': []}),
        ("object_color", {'type': str, 'default': None}),
        ("fact_color", {'type': str, 'default': None}),
        ("object_edge_color", {'type': str, 'default': None}),
        ("fact_edge_color", {'type': str, 'default': None})
    )
)
class VisScreen(ScreenTemplate):

    exclusions: List[str] = []
    obj_color = "#86FF33"
    fact_color = "#33FCFF"
    obj_edge_color = "#E333FF"
    fact_edge_color = "#FFAF33"

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.exclusions = self.options.get("exclude", [])
        self.obj_color = self.options.get("object_color", self.obj_color)
        self.fact_color = self.options.get("fact_color", self.fact_color)
        self.obj_edge_color = self.options.get("object_edge_color",
                                               self.obj_edge_color)
        self.fact_edge_color = self.options.get("fact_edge_color",
                                                self.fact_edge_color)

    def present(self):
        d = self.filter()
        try:
            return "var data = {0};".format(json.dumps(d, cls=BytesEncoder))
        except Exception:
            LOGGER.exception("Error attempting to JSON serialize game data")

    def filter(self):
        nodes = []
        edges = []

        for obj in self.objects:
            oid = "object_{}".format(obj.id)
            title = obj._coreInfo
            title.pop("data", None)
            title = ',<br />'.join("{!s}={!r}".format(key, val)
                                   for (key, val) in title.items())
            od = {
                "id": oid,
                "label": "Object",
                "title": title,
                "color": self.obj_color,
            }
            nodes.append(od)
            for p in obj.parentObjects:
                edges.append({
                    "from": oid,
                    "to": "object_{}".format(p),
                    "color": {
                        'color': self.obj_edge_color
                    },
                })
            for p in obj.parentFacts:
                edges.append({
                    "from": oid,
                    "to": "fact_{}".format(p),
                    "color": {
                        'color': self.fact_edge_color
                    },
                })

        for (fact_type, column) in self.facts.items():
            if not any(e in fact_type for e in self.exclusions):
                for fact in column:
                    fid = "fact_{}".format(fact.id)
                    title = fact._nonCoreFacts
                    title = ',<br />'.join("{!s}={!r}".format(key, val)
                                           for (key, val) in title.items())
                    fd = {
                        "id": fid,
                        "label": fact_type,
                        "title": title,
                        "color": self.fact_color,
                    }
                    nodes.append(fd)
                    for p in fact.parentObjects:
                        edges.append({
                            "from": fid,
                            "to": "object_{}".format(p),
                            "color": {
                                'color': self.obj_edge_color
                            },
                        })
                    for p in fact.parentFacts:
                        edges.append({
                            "from": fid,
                            "to": "fact_{}".format(p),
                            "color": {
                                'color': self.fact_edge_color
                            },
                        })

        d = {'nodes': nodes, 'edges': edges}
        return d

    def formatData(self, data):
        return {key.strip('_'): value for (key, value) in data.items()}
