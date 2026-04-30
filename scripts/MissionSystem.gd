extends Node
class_name SISMissionSystem

signal missions_changed(area: String, missions: Array[Dictionary])
signal mission_completed(area: String, mission: Dictionary)
signal mission_action_requested(area: String, action: Dictionary, mission: Dictionary)

const MISSIONS_ROOT := "res://missions"

var _completed_by_area: Dictionary = {}
var _unlocked_by_area: Dictionary = {}
var _missions_by_area: Dictionary = {}
var _current_area := ""

func set_area(area: String) -> void:
	_current_area = area
	reload_area(area)

func reload_area(area: String) -> void:
	_missions_by_area[area] = _load_area_missions(area)
	missions_changed.emit(area, get_active_missions(area))

func get_active_missions(area: String = "") -> Array[Dictionary]:
	var area_to_use := area
	if area_to_use.is_empty():
		area_to_use = _current_area
	var missions := _missions_for_area(area_to_use)
	var active: Array[Dictionary] = []
	for mission in missions:
		var mission_id := String(mission.get("id", ""))
		if mission_id.is_empty() or _is_completed(area_to_use, mission_id):
			continue
		if bool(mission.get("locked", false)) and not _is_unlocked(area_to_use, mission_id):
			continue
		active.append(mission.duplicate(true))
	return active

func complete_mission(area: String, mission_id: String) -> bool:
	if area.is_empty() or mission_id.is_empty() or _is_completed(area, mission_id):
		return false
	var missions := _missions_for_area(area)
	var completed_mission: Dictionary = {}
	for mission in missions:
		if String(mission.get("id", "")) == mission_id:
			completed_mission = mission.duplicate(true)
			break
	if completed_mission.is_empty():
		completed_mission = {"id": mission_id, "title": mission_id, "text": mission_id}
	_mark_completed(area, mission_id)
	mission_completed.emit(area, completed_mission)
	_run_complete_actions(area, completed_mission)
	missions_changed.emit(area, get_active_missions(area))
	return true

func complete_matching(area: String, event_key: String, context: Dictionary = {}) -> Array[Dictionary]:
	var completed: Array[Dictionary] = []
	for mission in get_active_missions(area):
		if _mission_matches_event(mission, event_key, context):
			var mission_id := String(mission.get("id", ""))
			if complete_mission(area, mission_id):
				completed.append(mission.duplicate(true))
	return completed

func _missions_for_area(area: String) -> Array[Dictionary]:
	if area.is_empty():
		return []
	if not _missions_by_area.has(area):
		_missions_by_area[area] = _load_area_missions(area)
	return _missions_by_area[area]

func _load_area_missions(area: String) -> Array[Dictionary]:
	var missions: Array[Dictionary] = []
	var path := "%s/%s.txt" % [MISSIONS_ROOT, area]
	if not FileAccess.file_exists(path):
		return missions
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open missions file: %s" % path)
		return missions
	var current: Dictionary = {}
	for raw_line in file.get_as_text().split("\n", false):
		var line := String(raw_line).replace("\r", "").strip_edges()
		if line.is_empty():
			_append_mission_if_valid(missions, current, path)
			current = {}
			continue
		if line.begins_with("#") or line.begins_with(";"):
			continue
		var directive := _parse_directive(line)
		if directive.is_empty():
			push_warning("Ignored malformed mission line in %s: %s" % [path, line])
			continue
		var key := String(directive.get("key", "")).to_upper()
		var value := String(directive.get("value", "")).strip_edges()
		match key:
			"MISSION":
				_append_mission_if_valid(missions, current, path)
				current = {
					"id": value,
					"title": "",
					"text": "",
					"objective": "",
					"objective_type": "",
					"objective_target": "",
					"on_complete": [],
					"locked": false
				}
			"TITLE":
				if current.is_empty():
					push_warning("TITLE before MISSION in %s: %s" % [path, line])
					continue
				current["title"] = value
				current["text"] = value
			"OBJECTIVE":
				if current.is_empty():
					push_warning("OBJECTIVE before MISSION in %s: %s" % [path, line])
					continue
				var objective := _parse_typed_value(value)
				current["objective"] = value
				current["objective_type"] = String(objective.get("type", ""))
				current["objective_target"] = String(objective.get("target", ""))
			"ON_COMPLETE":
				if current.is_empty():
					push_warning("ON_COMPLETE before MISSION in %s: %s" % [path, line])
					continue
				var actions: Array = current.get("on_complete", [])
				actions.append(_parse_typed_value(value))
				current["on_complete"] = actions
			"LOCKED":
				if current.is_empty():
					push_warning("LOCKED before MISSION in %s: %s" % [path, line])
					continue
				current["locked"] = _parse_bool(value)
			_:
				push_warning("Unknown mission directive in %s: %s" % [path, line])
	_append_mission_if_valid(missions, current, path)
	return missions

func _append_mission_if_valid(missions: Array[Dictionary], mission: Dictionary, path: String) -> void:
	if mission.is_empty():
		return
	var mission_id := String(mission.get("id", "")).strip_edges()
	if mission_id.is_empty():
		push_warning("Ignored mission without id in %s" % path)
		return
	var objective_type := String(mission.get("objective_type", "")).strip_edges()
	if objective_type.is_empty():
		push_warning("Ignored mission without OBJECTIVE in %s: %s" % [path, mission_id])
		return
	var title := String(mission.get("title", "")).strip_edges()
	if title.is_empty():
		title = _title_from_id(mission_id)
	mission["id"] = mission_id
	mission["title"] = title
	mission["text"] = title
	mission["objective_type"] = objective_type.to_lower()
	mission["objective_target"] = String(mission.get("objective_target", "")).strip_edges()
	missions.append(mission.duplicate(true))

func _parse_directive(line: String) -> Dictionary:
	var separator := _first_whitespace_index(line)
	if separator < 0:
		return {"key": line, "value": ""}
	return {
		"key": line.substr(0, separator).strip_edges(),
		"value": line.substr(separator + 1).strip_edges()
	}

func _first_whitespace_index(text: String) -> int:
	for index in range(text.length()):
		var character := text.substr(index, 1)
		if character == " " or character == "\t":
			return index
	return -1

func _parse_typed_value(value: String) -> Dictionary:
	var separator := value.find(":")
	if separator < 0:
		return {
			"type": value.strip_edges().to_lower(),
			"target": ""
		}
	return {
		"type": value.substr(0, separator).strip_edges().to_lower(),
		"target": value.substr(separator + 1).strip_edges()
	}

func _parse_bool(value: String) -> bool:
	var normalized := value.strip_edges().to_lower()
	return normalized in ["true", "yes", "1", "on", "locked"]

func _title_from_id(mission_id: String) -> String:
	var words := mission_id.replace("_", " ").split(" ", false)
	var titled: Array[String] = []
	for word in words:
		if word.is_empty():
			continue
		titled.append(word.substr(0, 1).to_upper() + word.substr(1).to_lower())
	return " ".join(titled)

func _mission_matches_event(mission: Dictionary, event_key: String, context: Dictionary) -> bool:
	var objective_type := String(mission.get("objective_type", "")).to_lower()
	var event_type := event_key.strip_edges().to_lower()
	if event_type == "talk_vendor":
		event_type = "talk_to_npc"
	elif event_type == "use_teleport_device":
		event_type = "use_relic"
	if objective_type != event_type:
		return false
	var objective_target := _normalize_mission_key(String(mission.get("objective_target", "")))
	if objective_target.is_empty():
		return true
	var candidates := _event_target_candidates(event_key, context)
	return candidates.has(objective_target)

func _event_target_candidates(event_key: String, context: Dictionary) -> Array[String]:
	var candidates: Array[String] = []
	for key in ["target", "npc_id", "npc_name", "vendor_id", "relic_id", "item_id"]:
		var value := _normalize_mission_key(String(context.get(key, "")))
		if not value.is_empty() and not candidates.has(value):
			candidates.append(value)
	if event_key.strip_edges().to_lower() == "use_teleport_device" and not candidates.has("teleport_device"):
		candidates.append("teleport_device")
	return candidates

func _normalize_mission_key(value: String) -> String:
	return value.strip_edges().to_lower().replace(" ", "_").replace("-", "_")

func _run_complete_actions(area: String, mission: Dictionary) -> void:
	var actions: Array = mission.get("on_complete", [])
	for action_variant in actions:
		if not (action_variant is Dictionary):
			continue
		var action := (action_variant as Dictionary).duplicate(true)
		var action_type := String(action.get("type", "")).to_lower()
		if action_type == "unlock_mission":
			_unlock_mission(area, String(action.get("target", "")))
		mission_action_requested.emit(area, action, mission.duplicate(true))

func _completed_array_for_area(area: String) -> Array:
	if not _completed_by_area.has(area):
		_completed_by_area[area] = []
	return _completed_by_area[area]

func _unlocked_array_for_area(area: String) -> Array:
	if not _unlocked_by_area.has(area):
		_unlocked_by_area[area] = []
	return _unlocked_by_area[area]

func _is_completed(area: String, mission_id: String) -> bool:
	return _completed_array_for_area(area).has(mission_id)

func _is_unlocked(area: String, mission_id: String) -> bool:
	return _unlocked_array_for_area(area).has(mission_id)

func _mark_completed(area: String, mission_id: String) -> void:
	var completed := _completed_array_for_area(area)
	if not completed.has(mission_id):
		completed.append(mission_id)
	_completed_by_area[area] = completed

func _unlock_mission(area: String, mission_id: String) -> void:
	if area.is_empty() or mission_id.is_empty():
		return
	var unlocked := _unlocked_array_for_area(area)
	if not unlocked.has(mission_id):
		unlocked.append(mission_id)
	_unlocked_by_area[area] = unlocked
