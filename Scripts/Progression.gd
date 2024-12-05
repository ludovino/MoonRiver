class_name Progression
extends Resource

export var units : int = 0

export var planets_unlocked : int = 0
export var oxygen_level : int = 0
export var reels_level : int = 0
export var fill_level : int = 0
export var decay_level : int = 0
export var pull_level : int = 0
export var escape_level : int = 0
export var catch_level : int = 0
export var cast_level : int = 0

export var current_location : Resource

export var first_play : bool = true

export(Dictionary) var level_status : Dictionary
