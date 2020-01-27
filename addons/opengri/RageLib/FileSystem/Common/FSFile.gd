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
class_name FSFile

const TypeOfResource = preload("res://addons/OpenGRI/RageLib/Common/Resources/ResourceType.gd")

# You don't need Delegates
# This 2 vars is pointers that allow to use: IsCustomData, GetData, SetData
var _customData: Dictionary
var _fileEntry: FileEntry

func _init(customData: Dictionary, fileEntry: FileEntry) -> void:
	_customData = customData
	_fileEntry = fileEntry
#	_customData[fileEntry.FullName()] = "any_data"
#	print("FSFile._customData.size()="+str(_customData.size()))

func IsDirectory() -> bool:
	return false

var IsCompressed: bool
var CompressedSize: int

var Size: int

var IsResource: bool
var ResourceType: TypeOfResource

func IsCustomData() -> bool:
	return _customData.has(_fileEntry.FullName())

#func GetData() -> Array:
#	pass
#	return _customData.has(_fileEntry.FullName())



