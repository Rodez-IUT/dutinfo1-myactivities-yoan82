CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$
	DECLARE
		defaultOwner "user"%ROWTYPE;
		defaultOwnerUsername VARCHAR(500) := 'Default Owner';

	BEGIN
		SELECT * INTO defaultOwner FROM "user"
			WHERE username = defaultOwnerUserName;
		IF NOT FOUND THEN
			INSERT INTO "user" (id, username)
				values (nextval('id_generator'),defaultOwnerUsername);
			SELECT * INTO defaultOwner FRON "user"
				WHERE username = defaultOwnerUsername;
		END IF;
		RETURN defaultOwner;
	END
$$ LANGUAGE plpgsql;

--Return next ou return query
/*CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity
	DECLARE
	
	BEGIN
	
END;*/
	
