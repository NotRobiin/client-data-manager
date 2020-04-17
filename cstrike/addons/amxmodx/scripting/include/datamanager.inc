#if defined _datamanager_included
  #endinput
#endif
#define _datamanager_included

/** Saves INT type of data.
 *
 *  @param key Json key
 *  @param value Int value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_int(key[], value);

/** Gets INT type of data.
 *
 *  @param key Json key
 *
 *  @return Int value assigned to key.
 */
native get_data_int(key[]);


/** Saves FLOAT type of data.
 *
 *  @param key Json key
 *  @param value Float value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_float(key[], Float:value);

/** Gets FLOAT type of data.
 *
 *  @param key Json key
 *
 *  @return Float value assigned to key.
 */
native Float:get_data_float(key[]);


/** Saves CHAR type of data.
 *
 *  @param key Json key
 *  @param value Chars array to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_data_char(key[], value[]);

/** Gets CHAR type of data.
 *
 *  @param key Json key
 *  @param output Output array
 *  @param output_length Output array's length
 *
 *  @noreturn
 */
native get_data_char(key[], output[], output_length);


/** Saves INT type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *  @param value Int value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_int(index, key[], value);

/** Gets INT type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *
 *  @return Int value assigned to key.
 */
native get_user_data_int(index, key[]);


/** Saves FLOAT type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *  @param value Float value to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_float(index, key[], Float:value);

/** Gets FLOAT type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *
 *  @return Float value assigned to key.
 */
native Float:get_user_data_float(index, key[]);


/** Saves CHAR type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *  @param value Chars array to be saved
 *
 *  @return True if saved successfully, false otherwise.
 */
native bool:save_user_data_char(index, key[], value[]);

/** Gets CHAR type of data based on client's name.
 *
 *  @param index Player id
 *  @param key Json key
 *  @param output Output array
 *  @param length Output array's length
 *
 *  @noreturn
 */
native get_user_data_char(index, key[], output[], length);


/** Escapes the key from forbidden characters.
 * Uses the same function as all of the save_[user]_data[int|float|char] functions.
 *
 *  @param key Json key
 *  @param length Key length
 *
 *  @noreturn
 */
native escape_key(key[], length);