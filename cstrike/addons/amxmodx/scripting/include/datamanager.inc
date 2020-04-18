#if defined _datamanager_included
  #endinput
#endif
#define _datamanager_included

#include <datamanager_const>

/** Creates json session from the specified folder.
 *
 *  @param name File name to operate on.
 *  @param pretty Whether to use JSON pretty string or not.
 *
 *  @return Session id if successful, Invalid_JSON if error occured.
 */
native create_session(const name[], bool:pretty);

/** Gets global session handle.
 *
 *  @return Session handle.
 */
native JSON:get_global_session();

/** Checks if given session id is valid.
 *
 *  @param session_id Index of active session.
 *
 *  @return True if session is valid, false otherwise.
 */
native bool:is_valid_session(session_id);

/** Saves INT type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *  @param value Int value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_int(session, key[], value);

/** Gets INT type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *
 *  @return Int value assigned to key.
 */
native get_data_int(session, key[]);


/** Saves FLOAT type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *  @param value Float value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_float(session, key[], Float:value);

/** Gets FLOAT type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *
 *  @return Float value assigned to key.
 */
native Float:get_data_float(session, key[]);


/** Saves CHAR type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *  @param value Chars array to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_char(session, key[], value[]);

/** Gets CHAR type of data.
 *
 *  @param session Json session created by native create_session.
 *  @param key Json key
 *  @param output Output array
 *  @param output_length Output array's length
 *
 *  @noreturn
 */
native get_data_char(session, key[], output[], output_length);


/** Saves INT type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *  @param value Int value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_int(session, index, key[], value);

/** Gets INT type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *
 *  @return Int value assigned to key.
 */
native get_user_data_int(session, index, key[]);


/** Saves FLOAT type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *  @param value Float value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_float(session, index, key[], Float:value);

/** Gets FLOAT type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *
 *  @return Float value assigned to key.
 */
native Float:get_user_data_float(session, index, key[]);


/** Saves CHAR type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *  @param value Chars array to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_char(session, index, key[], value[]);

/** Gets CHAR type of data based on client's name.
 *
 *  @param session Json session created by native create_session.
 *  @param index Player id
 *  @param key Json key
 *  @param output Output array
 *  @param length Output array's length
 *
 *  @noreturn
 */
native get_user_data_char(session, index, key[], output[], length);


/** Escapes the key from forbidden characters.
 * Uses the same function as all of the save_[user]_data[int|float|char] functions.
 *
 *  @param key Json key
 *  @param length Key length
 *
 *  @noreturn
 */
native escape_key(key[], length);