/*

RANDOM NOTES:
- Will try to keep most commentary and/or documentation in the docs directory.
- "arg_" and "ret_" are pretty much my own idiolectual thing for readability and sanity. They're kinda self-explanatory.

*/

CREATE OR REPLACE FUNCTION quote_count_comments (arg_quote_id BIGINT, OUT ret_comment_count BIGINT) AS $$ 
BEGIN
	ret_comment_count = (SELECT COUNT(*) FROM comments WHERE comments.quote_id = arg_quote_id AND comments.is_visible = TRUE);
  UPDATE quotes SET comment_count = ret_comment_count WHERE quote_id = arg_quote_id;
END; 
$$ LANGUAGE plpgsql;
