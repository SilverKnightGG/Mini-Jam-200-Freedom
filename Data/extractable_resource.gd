class_name ExtractableResource extends Resource



enum Type {FUEL, FOOD, MATERIALS, LUXURY}
@export var name: String = ""
@export var type: Type = Type.FUEL
@export_range(1.0, 200.0, 1.0, "suffix:1 to 200") var tax_value = 1.0
@export_range(0.0, 20.0, 1.0, "suffix:0 to 20") var town_value = 1.0
