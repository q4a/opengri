"""

 RageLib
 Copyright (C) 2008  Arushan/Aru <oneforaru at gmail.com>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""

#extends "FSObject.gd".FSObject
extends Node

class FSDirectory:
	var Name: String
	var ParentDirectory: FSDirectory
	func FullName() -> String:
		var path = ParentDirectory.FullName()
		if path == "":
			return Name
		else:
			return path+"/"+Name
	
	var _fsObjects: Array
	var _fsObjectsByName: Dictionary 
	
	func IsDirectory() -> bool:
		print("FSDirectory.IsDirectory")
		return true
	
	func GetEl(index: int):
		return _fsObjects[index]
	
	func FindByName(name: String):
#		var obj: FSObject
#		obj = _fsObjectsByName.get(name.to_lower())
#		return obj
		return _fsObjectsByName.get(name.to_lower())
	
	func AddObject(obj) -> void:
		_fsObjects.append(obj);
		_fsObjectsByName[obj.Name.to_lower()] = obj
	
	func DeleteObject(obj) -> void:
		_fsObjectsByName.erase(obj.Name.to_lower())
		_fsObjects.erase(obj)
	
	#region IEnumerable
	var current: int
	var dir_size: int
	
	func should_continue():
		return (current < dir_size)

	func _iter_init(arg):
		current = 0
		dir_size = _fsObjects.size()
		return should_continue()

	func _iter_next(arg):
		current += 1
		return should_continue()

	func _iter_get(arg):
		return _fsObjects[current]
	#endregion IEnumerable
	
#	func _init():
#		_fsObjects = []
#		_fsObjectsByName = {}
