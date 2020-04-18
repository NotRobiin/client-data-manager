#include <amxmodx>
#include <datamanager>

#define AUTHOR "Wicked - amxx.pl/user/60210-wicked/"

new session,
	user_value[33];

public plugin_init()
{
	register_plugin("Session test", "v1.0", AUTHOR);

	create_json();

	register_clcmd("say /add", "count_up");
}

public count_up(index)
{
	// Just a helper variable.
	user_value[index]++;

	// Save the data in multiple datatypes.
	save_user_data_int(session, index, "int.value", user_value[index]);
	save_user_data_char(session, index, "string.value", fmt("%i", user_value[index]));
	save_user_data_float(session, index, "float.value", Float:user_value[index]);

	new string_value[10];

	// Read string value.
	get_user_data_char(session, index, "string.value", string_value, charsmax(string_value));

	// Print the data read from session.
	client_print(index, print_chat, "Int: %i, Float: %0.2f, String: %s.",
		get_user_data_int(session, index, "int.value"),
		get_user_data_float(session, index, "float.value"),
		string_value);
}

/** Function to create the session handle.
 * Not required, but it's nicely done in one place.
 * There can be multiple sessions assigned to one plugin,
 * alltho it's not recommended.
 *
 */
create_json()
{
	// '.json' extension is optional.
	static const name[] = "file_name";
	static const plugin_name[] = "Session test";

	// Create the session handle.
	session = create_session(name);
	
	// Throw fail state when invalid session was given.
	if(!is_valid_session(session))
	{
		set_fail_state("Failed to create session ^"%s^" for plugin ^"%s^"", session, plugin_name);
	}
}