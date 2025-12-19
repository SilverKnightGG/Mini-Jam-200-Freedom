class_name Town extends Node


## Resource used based on town size to heat the town seasonally
var fuel: float = 0
## Resource used at all times by the town, and required for expansion
var food: float = 0
## Resources not used by the town, but brings a high value for paying taxes
var luxury: float = 0
## Resource used exclusively for expanding the town, and fetches a decent value for paying taxes
var materials: float = 0
