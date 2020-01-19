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

extends Node

const ResourceHeader = preload("res://addons/OpenGRI/RageLib/Common/Resources/ResourceHeader.gd")

class ResourceFile:
	var _header = ResourceHeader.new()
	const MagicBigEndian: int = 0x52534305
	const MagicValue: int = 0x05435352
	
	var Magic: int
	var Type: int
	var Flags: int
	var CompressCodec: int
	
	func GetSystemMemSize() -> int:
		return int(Flags & 0x7FF) << int(((Flags >> 11) & 0xF) + 8)
	
	func GetGraphicsMemSize() -> int:
		return int((Flags >> 15) & 0x7FF) << int(((Flags >> 26) & 0xF) + 8)
	
	func SetMemSizes(systemMemSize: int, graphicsMemSize: int) -> void:
		
		# gfx = a << (b + 8)
		# minimum representable is block of 0x100 bytes
		
		var maxA: int = 0x3F
		
		var sysA: int = systemMemSize >> 8;
		var sysB: int = 0
		
		while(sysA > maxA):
			if ((sysA & 1) != 0):
				sysA += 2
			sysA >>= 1
			sysB += 1
		
		var gfxA: int = graphicsMemSize >> 8
		var gfxB: int = 0
		
		while (gfxA > maxA):
			if ((gfxA & 1) != 0):
				gfxA += 2
			gfxA >>= 1
			gfxB += 1
			
			Flags = (Flags & 0xC0000000) | int(sysA | (sysB << 11) | (gfxA << 15) | (gfxB << 26))
	
	func Read(br) -> void:
		print("Implement BinaryReader!")
		print_stack()
	
	func Write(bw) -> void:
		print("Implement BinaryWriter!")
		print_stack()
		
