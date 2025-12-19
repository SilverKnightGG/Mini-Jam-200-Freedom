class_name Town extends Node

enum ExtractableResource {
	## Resource used based on town size to heat the town seasonally
	FUEL,
	## Resource used at all times by the town, and required for expansion
	FOOD,
	## Resources not used by the town, but brings a high value for paying taxes.
	MATERIALS,
	## Resource used exclusively for expanding the town, and fetches a decent value for paying taxes
	LUXURY}

const TAX_VALUE_MUPLTIPLIERS: Dictionary = {
	ExtractableResource.FUEL: 2.0,
	ExtractableResource.FOOD: 1.0,
	ExtractableResource.MATERIALS: 5.0,
	ExtractableResource.LUXURY: 25.0
}

var quantities: Dictionary[ExtractableResource, float] = {
	ExtractableResource.FUEL: 0.0,
	ExtractableResource.FOOD: 0.0,
	ExtractableResource.MATERIALS: 0.0,
	ExtractableResource.LUXURY: 0.0
}
