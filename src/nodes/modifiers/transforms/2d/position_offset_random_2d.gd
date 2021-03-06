tool
extends ConceptNode


func _init() -> void:
	unique_id = "offset_transforms_random_2d"
	display_name = "Translate (Random) 2D"
	category = "Modifiers/Transforms/2D"
	description = "Apply a random position to a set of nodes"

	set_input(0, "Nodes", ConceptGraphDataType.NODE_2D)
	set_input(1, "Amount", ConceptGraphDataType.VECTOR2)
	set_input(2, "Seed", ConceptGraphDataType.SCALAR, {"step": 1})
	set_input(3, "Local Space", ConceptGraphDataType.BOOLEAN, {"value": true})
	set_output(0, " ", ConceptGraphDataType.NODE_2D)

	mirror_slots_type(0, 0)


func _generate_outputs() -> void:
	var nodes := get_input(0)
	var amount: Vector2 = get_input_single(1, Vector2.ZERO)
	var input_seed: int = get_input_single(2, 0)
	var local_space: bool = get_input_single(3, false)

	if not nodes or nodes.size() == 0:
		return

	if not amount:
		output[0] = nodes
		return

	var rand = RandomNumberGenerator.new()
	rand.seed = input_seed

	var p: Vector3

	for n in nodes:
		p = Vector3.ZERO
		p.x = rand.randf_range(-1.0, 1.0) * amount.x
		p.y = rand.randf_range(-1.0, 1.0) * amount.y
		if local_space:
			n.translate_object_local(p)
		else:
			if n.is_inside_tree():
				n.global_translate(p)
			else:
				n.transform.origin += p

	output[0] = nodes
