extends Object
class_name CommonResLib

func _init() -> void:
	pass

func IsResource(cfg_key: String, filename: String) -> String:
	var ext = filename.get_extension()
	if cfg_key == "MM_ARECH":
		var _resourceFiles = ["lod", "hwl"]
		if _resourceFiles.has(ext):
			return "Yes"
		else:
			return "No"
	else:
		return "?." + ext  
