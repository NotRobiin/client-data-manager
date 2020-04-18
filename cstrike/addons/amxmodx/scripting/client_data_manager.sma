#include <amxmodx>
#include <json>
#include <datamanager_const>

#define AUTHOR "Wicked - amxx.pl/user/60210-wicked/"

#pragma semicolon 1

#define ForRange(%1,%2,%3) for(new %1 = %2; %1 <= %3; %1++)
#define ForArray(%1,%2) for(new %1 = 0; %1 < sizeof %2; %1++)

enum _:ExceptionsEnumerator (+= 1337)
{
	InvalidArgumentsGiven = -77_33_33_11,
	InvalidSessionGiven,
	PlayerNotConnected
};

enum _:SessionSettingsEnumerator (+= 1)
{
	JSON:ss_handle,
	ss_id,
	ss_file[MAX_FILE_NAME + 1],
	bool:ss_pretty
};


new sessions[MAX_SESSIONS + 1][SessionSettingsEnumerator],
	active_sessions;

/*		[ Forwards ]		*/
public plugin_init()
{
	register_plugin("Client data manager (JSON)", "v1.6", AUTHOR);

	// This is the global json session.
	// It is used when you don't want to create a separate session
	// for the plugin.
	// Global session is ALWAYS the 1st element of array (0).
	sessions[0][ss_handle] = create_json(DefaultSaveFile);
	sessions[0][ss_id] = active_sessions;
	copy(sessions[0][ss_file], MAX_FILE_NAME, DefaultSaveFile);
	active_sessions++;
}

public plugin_precache()
{
	// Make sure rest of the sessions are set to invalid ones.
	// Helps with "is_valid_session" function.
	ForRange(i, 1, MAX_SESSIONS)
	{
		sessions[i][ss_handle] = Invalid_JSON;
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

	register_native("create_session", "native_create_session", 0);
	register_native("get_global_session", "native_get_global_session", 0);
	register_native("is_valid_session", "native_is_valid_session", 0);
}

public plugin_end()
{
	ForRange(i, 0, active_sessions  - 1)
	{
		if(!is_valid_sesion(i))
		{
			continue;
		}

		save_json(sessions[i][ss_id]);
	}
}

/*		[ Natives ]			*/
public bool:native_save_data_int(plugin, params)
{
	if(!check_params("save_data_int", 3, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}

	get_string(2, key, charsmax(key));

	return save_data_int(sessions[s][ss_handle], key, get_param(3));
}

public native_get_data_int(plugin, params)
{
	if(!check_params("get_data_int", 2, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return InvalidSessionGiven;
	}

	get_string(2, key, charsmax(key));

	return get_data_int(sessions[s][ss_handle], key);
}

public bool:native_save_data_float(plugin, params)
{
	if(!check_params("save_data_float", 3, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}
	
	get_string(2, key, charsmax(key));

	return save_data_float(sessions[s][ss_handle], key, get_param_f(3));
}

public Float:native_get_data_float(plugin, params)
{
	if(!check_params("get_data_float", 2, params))
	{
		return Float:InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return Float:InvalidSessionGiven;
	}
	
	get_string(2, key, charsmax(key));

	return get_data_float(sessions[s][ss_handle], key);
}

public bool:native_save_data_char(plugin, params)
{
	if(!check_params("save_data_char", 2, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		value[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}
	
	get_string(2, key, charsmax(key));
	get_string(3, value, charsmax(value));

	return save_data_char(sessions[s][ss_handle], key, value);
}

public native_get_data_char(plugin, params)
{
	if(!check_params("get_data_char", 4, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		output[MAX_KEY_LENGTH + 1],
		output_length,
		return_value,
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return InvalidSessionGiven;
	}
	
	get_string(2, key, charsmax(key));

	output_length = get_param(4);
	return_value = get_data_char(sessions[s][ss_handle], key, output, output_length);

	set_string(3, output, output_length);

	return return_value;
}

public bool:native_save_user_data_int(plugin, params)
{
	if(!check_params("save_user_data_int", 4, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}
	
	get_string(3, key, charsmax(key));

	return save_user_data_int(sessions[s][ss_handle], get_param(2), key, get_param(4));
}

public native_get_user_data_int(plugin, params)
{
	if(!check_params("get_user_data_int", 3, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return InvalidSessionGiven;
	}
	
	get_string(3, key, charsmax(key));

	return get_user_data_int(sessions[s][ss_handle], get_param(2), key);
}

public bool:native_save_user_data_float(plugin, params)
{
	if(!check_params("save_user_data_float", 4, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}
	
	get_string(3, key, charsmax(key));

	return save_user_data_float(sessions[s][ss_handle], get_param(2), key, get_param_f(4));
}

public Float:native_get_user_data_float(plugin, params)
{
	if(!check_params("get_user_data_float", 3, params))
	{
		return Float:InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return Float:InvalidSessionGiven;
	}
	
	get_string(3, key, charsmax(key));

	return get_user_data_float(sessions[s][ss_handle], get_param(2), key);
}

public bool:native_save_user_data_char(plugin, params)
{
	if(!check_params("save_user_data_char", 4, params))
	{
		return false;
	}

	static key[MAX_KEY_LENGTH + 1],
		value[MAX_KEY_LENGTH + 1],
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return false;
	}
	
	get_string(3, key, charsmax(key));
	get_string(4, value, charsmax(value));

	return save_user_data_char(sessions[s][ss_handle], get_param(2), key, value);
}

public native_get_user_data_char(plugin, params)
{
	if(!check_params("get_user_data_char", 5, params))
	{
		return InvalidArgumentsGiven;
	}

	static key[MAX_KEY_LENGTH + 1],
		output[MAX_KEY_LENGTH + 1],
		func_return,
		length,
		s;

	s = get_param(1);

	// Invalid session.
	if(!is_valid_sesion(s))
	{
		return InvalidSessionGiven;
	}
	
	get_string(3, key, charsmax(key));

	length = get_param(5);
	func_return = get_user_data_char(sessions[s][ss_handle], get_param(2), key, output, length);

	set_string(4, output, length);

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

public native_create_session(plugin, params)
{
	if(!check_params("create_session", 2, params))
	{
		return any:Invalid_JSON;
	}

	static name[MAX_KEY_LENGTH + 1],
		bool:pretty;

	get_string(1, name, charsmax(name));
	
	pretty = bool:get_param(2);

	// Session name is invalid.
	if(!is_valid_session_name(name))
	{
		return any:Invalid_JSON;
	}
	
	// No file extension.
	if(!equal(name[strlen(name) - 5], ".json"))
	{
		add(name, charsmax(name), ".json");
	}

	// Add the full path to the save folder.
	if(containi(name, "addons") == -1)
	{
		format(name, charsmax(name), "%s%s", SaveFileFolder, name);
	}

	new id = active_sessions;

	active_sessions++;

	sessions[id][ss_handle] = create_json(name);
	sessions[id][ss_id] = id;
	sessions[id][ss_pretty] = pretty;
	copy(sessions[id][ss_file], MAX_FILE_NAME, name);

	return id;
}

public JSON:native_get_global_session(plugin, params)
{
	if(!check_params("get_global_session", 0, params))
	{
		return Invalid_JSON;
	}

	return sessions[0][ss_handle];
}

public bool:native_is_valid_session(plugin, params)
{
	if(!check_params("is_valid_session", 1, params))
	{
		return false;
	}

	return is_valid_sesion(get_param(1));
}

/*		[ Functions ]		*/
bool:is_valid_sesion(session_id)
{
	if(session_id > MAX_SESSIONS)
	{
		return false;
	}

	if(session_id > active_sessions)
	{
		return false;
	}

	if(session_id < 0)
	{
		return false;
	}

	if(sessions[session_id][ss_handle] == Invalid_JSON)
	{
		return false;
	}

	return true;
}

bool:is_valid_session_name(name[])
{
	static length;

	length = strlen(name);

	// No name given.
	if(!length)
	{
		return false;
	}

	// Name too long.
	if(length > MAX_FILE_NAME)
	{
		return false;
	}

	return true;
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
 *
 *	@noreturn
 */
save_json(session_id)
{
	json_serial_to_file(sessions[session_id][ss_handle], sessions[session_id][ss_file], sessions[session_id][ss_pretty]);
	json_free(sessions[session_id][ss_handle]);
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
bool:save_data_int(JSON:s, key[], value)
{
	return json_object_set_number(s, key, value, true);
}

get_data_int(JSON:s, key[])
{
	return json_object_get_number(s, key, true);
}

bool:save_data_float(JSON:s, key[], Float:value)
{
	return json_object_set_real(s, key, value, true);
}

Float:get_data_float(JSON:s, key[])
{
	return json_object_get_real(s, key, true);
}

bool:save_data_char(JSON:s, key[], value[])
{
	return bool:json_object_set_string(s, key, value, true);
}

get_data_char(JSON:s, key[], output[], output_length)
{
	return json_object_get_string(s, key, output, output_length, true);
}

// User data functions
bool:save_user_data_int(JSON:s, index, key[], value)
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);

	return json_object_set_number(s, new_key, value, true);
}

get_user_data_int(JSON:s, index, key[])
{
	if(!is_user_connected(index))
	{
		return PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_number(s, new_key, true);
}

bool:save_user_data_float(JSON:s, index, key[], Float:value)
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_set_real(s, new_key, value, true);
}

Float:get_user_data_float(JSON:s, index, key[])
{
	if(!is_user_connected(index))
	{
		return Float:PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_real(s, new_key, true);
}

bool:save_user_data_char(JSON:s, index, key[], value[])
{
	if(!is_user_connected(index))
	{
		return false;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return bool:json_object_set_string(s, new_key, value, true);
}

get_user_data_char(JSON:s, index, key[], output[], length)
{
	if(!is_user_connected(index))
	{
		return PlayerNotConnected;
	}

	static new_key[100];

	get_user_name(index, new_key, charsmax(new_key));

	escape_key(new_key, charsmax(new_key));

	format(new_key, charsmax(new_key), "%s.%s", new_key, key);
	
	return json_object_get_string(s, new_key, output, length, true);
}