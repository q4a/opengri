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

extends RealEntry
class_name FileEntry

const TypeOfResource = preload("res://addons/OpenGRI/RageLib/Common/Resources/ResourceType.gd")

var _file: String
var ResourceType: TypeOfResource
var IsResourceFile: bool
var _resourceFiles = [".wtd", ".wdr", ".wdd", ".wft",
					  ".wpfl", ".whm", ".wad", ".wbd", 
					  ".wbn", ".wbs"]

func _init(context#FixCyclicRef: RealContext
		, file: String):
	Context = context
	_file = file;
	Name = _file.get_file()
	
	var ext = Name.get_extension()
	print("#FIXME: just do it")

func IsDirectory() -> bool:
	return false
