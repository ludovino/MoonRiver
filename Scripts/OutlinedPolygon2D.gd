class_name OutlinedPolygon2D
extends Polygon2D


func _draw() -> void:
	var outline = Array(polygon)
	outline.append(polygon[0])
	draw_polyline(PoolVector2Array(outline), Color.red)
	