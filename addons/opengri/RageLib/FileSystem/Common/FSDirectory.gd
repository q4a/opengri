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

extends FSObject
class_name FSDirectory

var _fsObjects: Array # of FSObject
var _fsObjectsByName: Dictionary # of {string: FSObject}

func IsDirectory() -> bool:
	return true

func FindByName(name: String):
#	var obj: FSObject
#	obj = _fsObjectsByName.get(name.to_lower())
#	return obj
	#FIXME: (feature) this will return null, but not empty obj: FSObject
	return _fsObjectsByName.get(name.to_lower())

func AddObject(obj) -> void:
	_fsObjects.append(obj);
	_fsObjectsByName[obj.Name.to_lower()] = obj

func DeleteObject(obj) -> void:
	_fsObjectsByName.erase(obj.Name.to_lower())
	_fsObjects.erase(obj)

#region IEnumerable
func _get(property):
	#FIXME: add check for int(property) or is property in get_property_list
	return _fsObjects[int(property)]

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
