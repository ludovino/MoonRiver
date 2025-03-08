extends GridContainer

enum { MASTER, MUSIC, SFX }
var config : ConfigFile

func _ready() -> void:
	config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	var master_vol = config.get_value("volume", "master", 1.0)
	var sfx_vol = config.get_value("volume", "sfx", 1.0)
	var music_vol = config.get_value("volume", "music", 1.0)
	$MasterSlider.value = master_vol
	$SfxSlider.value = sfx_vol
	$MusicSlider.value = music_vol
	AudioServer.set_bus_volume_db(MASTER, linear_to_db(master_vol))
	AudioServer.set_bus_volume_db(SFX, linear_to_db(sfx_vol))
	AudioServer.set_bus_volume_db(MUSIC, linear_to_db(music_vol))


func _on_MasterSlider_value_changed(value: float) -> void:
	config.set_value("volume", "master", value)
	AudioServer.set_bus_volume_db(MASTER, linear_to_db(value))


func _on_SfxSlider_value_changed(value: float) -> void:
	config.set_value("volume", "sfx", value)
	AudioServer.set_bus_volume_db(SFX, linear_to_db(value))


func _on_MusicSlider_value_changed(value: float) -> void:
	config.set_value("volume", "music", value)
	AudioServer.set_bus_volume_db(MUSIC, linear_to_db(value))


func _save_settings(value_changed: bool) -> void:
	if(value_changed):
		config.save("user://settings.cfg")
