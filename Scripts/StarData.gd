class_name StarData
extends InventoryItem

export var frames: SpriteFrames
export var animation: String
export var fx_scene: PackedScene
export var radius: float
export var pulse_speed: float
export var pulse_graph: Curve
export var score: int
export var escape_speed: float
export var magnitude: float
export var min_level: int = 0 
export(float, 0.5, 2) var audio_pitch_modulate: float = 1.0
export(float, 0, 1.0) var reel_speed_mod: float = 0.9
