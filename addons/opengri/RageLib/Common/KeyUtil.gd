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

extends Object
class_name KeyUtil

var dir: String

func IsNullOrWhiteSpace(value: String) -> bool:
	return (value == null) or (value.strip_edges(true, true) == "")

var ExecutableName: String
var PathRegistryKeys: Array # of String
var SearchOffsets: Array # of int

func _init(cfg_key: String) -> void:
	if cfg_key == "GTA_IV":
		ExecutableName = "GTAIV.exe"
		PathRegistryKeys = [
			"SOFTWARE\\Rockstar Games\\Grand Theft Auto IV", # 32bit
			"SOFTWARE\\Wow6432Node\\Rockstar Games\\Grand Theft Auto IV" # 64bit
		]
		SearchOffsets = [
			# EFIGS EXEs
			0xA94204, # 1.0
			0xB607C4, # 1.0.1
			0xB56BC4, # 1.0.2
			0xB75C9C, # 1.0.3
			0xB7AEF4, # 1.0.4
			0xBE1370, # 1.0.4r2
			0xBE6540, # 1.0.6
			0xBE7540, # 1.0.7
			0xC95FD8, # 1.0.8
			# Russian EXEs
			0xB5B65C, # 1.0.0.1
			0xB569F4, # 1.0.1.1
			0xB76CB4, # 1.0.2.1
			0xB7AEFC, # 1.0.3.1
			# Japan EXEs
			0xB8813C, # 1.0.1.2
			0xB8C38C, # 1.0.2.2
			0xBE6510 # 1.0.5.2
		]
		
	elif cfg_key == "GTA_IV_EFLC":
		ExecutableName = "EFLC.exe"
		PathRegistryKeys = [
			"SOFTWARE\\Rockstar Games\\EFLC", # 32bit
			"SOFTWARE\\Wow6432Node\\Rockstar Games\\EFLC" # 64bit
		]
		SearchOffsets = [
			# EFLC
			0xB82A28, # 1.1.3
			0xBEF028, # 1.1.2
			0xC705E0, # 1.1.1
			0xC6DEEC, # 1.1.0
		]

func FindGameDirectory() -> String:
	return ""
