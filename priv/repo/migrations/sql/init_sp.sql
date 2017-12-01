/*

TODO: 
- Add \i init_sp.sql to end of init_up.sql. (This *may* require an absolute path, but no big deal.)
- Fill in any missing columns in init_up.sql.

RANDOM NOTES:
- Will try to keep most commentary and/or documentation in the docs directory.
- "arg_" and "ret_" are pretty much my own idiolectual thing for readability and sanity. They're kinda self-explanatory.

*/

CREATE OR REPLACE FUNCTION quote_count_comments (arg_quote_id BIGINT, OUT ret_comment_count BIGINT) AS $$ 
BEGIN
	ret_comment_count = (SELECT COUNT(*) FROM comments WHERE comments.quote_id = arg_quote_id);
  UPDATE quotes SET comment_count = ret_comment_count WHERE quote_id = arg_quote_id;
END; 
$$ LANGUAGE plpgsql;
