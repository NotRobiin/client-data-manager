/*	[ Setup ]	*/

// Full path (base cstrike/) for the json file to be saved at.
static const SaveFile[] = "addons/amxmodx/data/client_data.json";

// Whether save json in the pretty style.
static const bool:SavePretty = true;

// How often to save json object.
// Only if SAVE_ON_INTERVAL.
static const Float:SaveInterval = 30.0;

/*	[ Setup ]	*/

#include <amxmodx>
#include <json>

#define AUTHOR "Wicked - amxx.pl/user/60210-wicked/"

#pragma semicolon 1

#define ForArray(%1,%2) for(new %1 = 0; %1 < sizeof %2; %1++)

enum _:SaveTypeEnumerator (<<= 1)
{
	SAVE_EVERY_ROUND = 1,
	SAVE_EVERY_DISCONNECT,
	SAVE_ON_MAP_END,
	SAVE_ON_INTERVAL,
	SAVE_NEVER
};

enum _:ExceptionsEnumerator (+= 1337)
{
	InvalidArgumentsGiven = -77_33_33_11,
	PlayerNotConnected
};

#define MAX_KEY_LENGTH 100


// Bitsum of save types.
static const SaveType = (SAVE_ON_MAP_END);


new JSON:json_handle;

/*		[ Forwards ]		*/
public plugin_init()
{
	register_plugin("Client data manager (JSON)", "v1.3", AUTHOR);

	register_event("HLTV", "new_round", "a", "1=0", "2=0");

	json_handle = create_json(SaveFile);

	if(should_save_now(SAVE_ON_INTERVAL))
	{
		set_task(SaveInterval, "save_on_interval");
	}
}

public plugin_natives()
{
	register_native("save_data_int", "native_save_data_int", 0);
	register_native("get_data_int", "native_get_data_int", 0);

	register_native("save_data_float", "native_save_data_float", 0);
	register_native("get_data_float", "native_get_data_float", 0);

	register_native("save_data_char", "native_save_data_char", 0);
	register_native("get_data_char", "native_get_data_char", 0);

	register_native("save_user_data_int", "native_save_user_data_int", 0);
	register_native("get_user_data_int", "native_get_user_data_int", 0);

	register_native("save_user_data_float", "native_save_user_data_float", 0);
	register_native("get_user_data_float", "native_get_user_data_float", 0);

	register_native("save_user_data_char", "native_save_user_data_char", 0);
	register_native("get_user_data_char", "native_get_user_data_char", 0);

	register_native("escape_key", "native_escape_key", 0);
}

public plugin_end()
{
	if(!should_save_now(SAVE_ON_MAP_END))
	{
		return;
	}

	save_json(json_handle, SaveFile);
}

public client_disconnected(index)
{
	if(!should_save_now(SAVE_EVERY_DISCONNECT))
	{
		return;
	}

	save_json(json_handle, SaveFile);
}

public new_round()
{
	if(!should_save_now(SAVE_EVERY_ROUND))
	{
		return;
	}

	save_json(json_handle, SaveFile);
}

public save_on_interval()
{
	save_json(json_handle, SaveFile);
}

/*		[ Natives ]			*/
public bool:native_save_data_int(plugin, params)
{
	if(!check_params("save_data_int", 2, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));

	return save_data_int(key, get_param(2));
}

public native_get_data_int(plugin, params)
{
	if(!check_params("get_data_int", 1, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));

	return get_data_int(key);
}

public bool:native_save_data_float(plugin, params)
{
	if(!check_params("save_data_float", 2, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));

	return save_data_float(key, get_param_f(2));
}

public Float:native_get_data_float(plugin, params)
{
	if(!check_params("get_data_float", 1, params))
	{
		return Float:InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));

	return get_data_float(key);
}

public bool:native_save_data_char(plugin, params)
{
	if(!check_params("save_data_char", 2, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		value[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));
	get_string(2, value, charsmax(value));

	return save_data_char(key, value);
}

public native_get_data_char(plugin, params)
{
	if(!check_params("get_data_char", 3, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		output[MAX_KEY_LENGTH + 1],
		output_length,
		return_value;

	get_string(1, key, charsmax(key));

	output_length = get_param(3);
	return_value = get_data_char(key, output, output_length);

	set_string(2, output, output_length);

	return return_value;
}

public bool:native_save_user_data_int(plugin, params)
{
	if(!check_params("save_user_data_int", 3, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(2, key, charsmax(key));

	return save_user_data_int(get_param(1), key, get_param(3));
}

public native_get_user_data_int(plugin, params)
{
	if(!check_params("get_user_data_int", 2, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(2, key, charsmax(key));

	return get_user_data_int(get_param(1), key);
}

public bool:native_save_user_data_float(plugin, params)
{
	if(!check_params("save_user_data_float", 3, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(2, key, charsmax(key));

	return save_user_data_float(get_param(1), key, get_param_f(3));
}

public Float:native_get_user_data_float(plugin, params)
{
	if(!check_params("get_user_data_float", 2, params))
	{
		return Float:InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(2, key, charsmax(key));

	return get_user_data_float(get_param(1), key);
}

public bool:native_save_user_data_char(plugin, params)
{
	if(!check_params("save_user_data_char", 3, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		value[MAX_KEY_LENGTH + 1];

	get_string(2, key, charsmax(key));
	get_string(3, value, charsmax(value));

	return save_user_data_char(get_param(1), key, value);
}

public native_get_user_data_char(plugin, params)
{
	if(!check_params("get_user_data_char", 4, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		output[MAX_KEY_LENGTH + 1],
		func_return,
		length;

	get_string(2, key, charsmax(key));

	length = get_param(4);
	func_return = get_user_data_char(get_param(1), key, output, length);

	set_string(3, output, length);

	return func_return;
}

public bool:native_escape_key(plugin, params)
{
	if(!check_params("escape_key", 2, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1];

	get_string(1, key, charsmax(key));

	escape_key(key, get_param(2));

	return true;
}

/*		[ Functions ]		*/
bool:should_save_now(now)
{
	if(SaveType == SAVE_NEVER)
	{
		return false;
	}

	if(SaveType & now)
	{
		return true;
	}

	return false;
}

stock bool:check_params(native_name[], required, given)
{
	#if !defined DEBUG_MODE

	#pragma unused native_name

	#endif

	if(given != required)
	{
		#if defined DEBUG_MODE

		log_amx("Native received invalid amount of parameters. Native: %s, params: %i, required: %i.", native_name, given, required);

		#endif

		return false;
	}

	return true;
}

/**
 *	Serializes json object to specified file.
 *	Frees the handle after saving data.
 *
 *	@param handle	Valid json handle
 *	@param file 	Path to the save file
 *
 *	@noreturn
 */
save_json(JSON:handle, const file[])
{
	json_serial_to_file(json_handle, file, SavePretty);
	json_free(handle);

	json_handle = create_json(file);
}

/**
 *	Creates json handle, prases the file.
 *	Creates file, if necessarry.
 *
 *	@param file	Path to .json file
 *	@return json handle 
 */
JSON:create_json(const file[])
{
	// File doesn't exist?
	if(!file_exists(file))
	{
		write_file(file, "");
	}

	new JSON:h;

	h = json_parse(file, true, false);

	if(h == Invalid_JSON)
	{
		h = json_init_object();
	}

	return h;
}

/** Replaces all invalid/forbidden characters in the key.
 *	For example '.' in the player nickname will be forbidden
 *	because of the dot notation.
 *
 *	@param key	Json value key
 *	@param length Length of key
 *
 *	@noreturn
 */
stock escape_key(key[], length)
{
	static const KeyForbinddenChars[][][] =
	{
		{ ".", "_" }
	};

	ForArray(i, KeyForbinddenChars)
	{
		replace_all(key, length, KeyForbinddenChars[i][0], KeyForbinddenChars[i][1]);
	}
}

// Custom data functions.
bool:save_data_int(key[], value)
{
	return json_object_set_number(json_handle, key, value, true);
}

get_data_int(key[])
{
	return json_object_get_number(json_handle, key, true);
}

bool:save_data_float(key[], Float:value)
{
	return json_object_set_real(json_handle, key, value, true);
}

Float:get_data_float(key[])
{
	return json_object_get_real(json_handle, key, true);
}

bool:save_data_char(key[], value[])
{
	return bool:json_object_set_string(json_handle, key, value, true);
}

get_data_char(key[], output[], output_length)
{
	return json_object_get_string(json_handle, key, output, output_length, true);
}

// User data functions
bool:save_user_data_int(index, key[], value)
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);

	return json_object_set_number(json_handle, new_key, value, true);
}

get_user_data_int(index, key[])
{
	if(!is_user_connected(index))
	{
		return PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_number(json_handle, new_key, true);
}

bool:save_user_data_float(index, key[], Float:value)
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_set_real(json_handle, new_key, value, true);
}

Float:get_user_data_float(index, key[])
{
	if(!is_user_connected(index))
	{
		return Float:PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_real(json_handle, new_key, true);
}

bool:save_user_data_char(index, key[], value[])
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return bool:json_object_set_string(json_handle, new_key, value, true);
}

get_user_data_char(index, key[], output[], length)
{
	if(!is_user_connected(index))
	{
		return PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_string(json_handle, new_key, output, length, true);
}